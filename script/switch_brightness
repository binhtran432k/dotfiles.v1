#!/bin/bash
brightness=("$@")
brightness_num=${#brightness[@]}
if [[ $brightness_num == 0 ]]; then
    echo "No brightness provided"
    exit 2
fi

current_brightness=$(brightnessctl get)
for (( i=0; i<$brightness_num; i++ ));
do
    if [[ ${brightness[$i]} == $current_brightness ]]; then
        next_index=$(expr $i + 1)
        next_index=$(expr $next_index % $brightness_num)
        next_brightness=${brightness[$next_index]}
        break
    fi
done

if [[ -z $next_brightness ]]; then
    echo "Brightness not in list"
    next_brightness=${brightness[0]}
fi

brightnessctl set $next_brightness
exit 0
