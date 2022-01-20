# iMacFanspinner
Simple but effective script for handling 2011 27" iMac temperatures.

## What is this?

This script is made to control my year 2011 27" iMac temperatures in Debian 11.

I got an iMac for free due it having an defective Radeon GPU. I managed to bake it ("Reflow" the GPU in oven) back to working order and wanted to make sure it stays that way as long as possible, so I started to find an way to keep the temperatures low enough.
The SMC on this iMac didnt spin the fans anywhere near quick and reliably enough for my liking (atleast in linux).

There was an more complex script for controlling the fans available in Github, but due to changes somewhere in Kernel 4.xx (if I remember correctly) the way the system is able to write and read from the apples SMC EFI system changed and that script ceased to work.

I made some research on the internet, and testing on the readable and writeable SMC "files" and found an way to manually control the fans.
I made this simple script to control the fan RPM based on the CPU and GPU temperatures and added logarithmic step to make sure it stays quiet, but cool if needed.

## Files

- fancontrol.sh       Bash script to control the fans.
- fancontrol.service  Service file to make the script run as service at system boot (systemd).

## Usage

On debian based systems (with systemd), place the fancontrol.service to /etc/systemd/system/ and fancontrol.sh to /usr/local/bin/

I have not tested this script on any other model nor any other system than Debian 11 Bullseye with kernel version 5.10.0-10

## Improvements

The script is simple and did what it needed to do. I do not have this system anymore so I have no future plans to develop it.
This is here in hopes that someone else could find the aid for this specific problem.
