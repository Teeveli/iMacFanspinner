#!/bin/bash

# Simple but effective script for controllng 27" 2011 iMac's CPU and Radeon GPU temperatures.
# The default fan curve from EFI is way too loose and works ureliably in linux with newer kernels.
# The system has 3 internal fans. Left, Right and Middle (hdd)


##-------------------
# Definable variables

FPATH="/sys/devices/platform/applesmc.768" # Path to the apple efi devices.
LETMERUN=1 # Variable to disable the scripts loop if needed.


##------------------------------------------------------------------
# Set all fans to manual mode so we can write the rpm value to them.

# Read current mode
fan1manual=$(cat $FPATH/fan1_manual)
fan2manual=$(cat $FPATH/fan2_manual)
fan3manual=$(cat $FPATH/fan3_manual)

#If value is not manual (1), set it to 1.
if [[ ${fan1manual} != 1 ]]; then
	sudo sh -c "echo 1 > $FPATH/fan1_manual"
fi
if [[ ${fan2manual} != 1 ]]; then
        sudo sh -c "echo 1 > $FPATH/fan2_manual"
fi
if [[ ${fan3manual} != 1 ]]; then
        sudo sh -c "echo 1 > $FPATH/fan3_manual"
fi


##-----------------------------------------
# Set GPU initial fan RPM to @1500 minimum.

#Read current RPM
fan1rpm=$(cat $FPATH/fan1_output)

#If value is below 1500, set it to 1500
if [[ ${fan1rpm} -le 1500 ]]; then
	sudo sh -c "echo 1500 > $FPATH/fan1_output"
fi


##----------------
# Fan control loop

while [[ ${LETMERUN} -eq 1 ]]; do

	cputemp=$(cat $FPATH/temp14_input) # Input sensor for CPU temperature
	gputemp=$(cat $FPATH/temp15_input) # Input sensor for GPU temperature
	cpurelrpm1=$(((cputemp / 30)-300)) # Calculated RPM based on CPU temp. (lower rpm)
	cpurelrpm2=$(((cputemp / 30)-150)) # Calculated RPM based on CPU temp. (higher rpm)
	gpurelrpm=$(((gputemp / 20)-1200)) # Calculated RPM based on GPU temp.

	# If the CPU temp. is below 60c we use the lower RPM setting.
	# Above 60c we ramp up the fan curve more to keep up with the temperature scaling.
	if [[ ${cputemp} < 60000 ]]; then
		sudo sh -c "echo ${cpurelrpm1} > $FPATH/fan3_output"
	else
		sudo sh -c "echo ${cpurelrpm2} > $FPATH/fan3_output"
	fi
	
	# If GPU temperature is below 55c we keep constant 1500 RPM, otherwise we use the scaling RPM
	if [[ ${gputemp} < 55000 ]]; then
		sudo sh -c "echo 1500 > $FPATH/fan1_output"
	else
		sudo sh -c "echo ${gpurelrpm} > $FPATH/fan1_output"
	fi
	
	# Sleep for 5 seconds
	sleep 5
done



