#!/bin/bash

iconcolor=#7aa2f7

output=$(brightnessctl | grep Current | awk '{print $4}' | sed -r 's/\((.*)\)/\1/g')

echo -n "%{F$iconcolor}BRIGHT%{F-} $output%{F-}"
