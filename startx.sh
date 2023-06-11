#!/bin/bash 

echo "--- List Input Devices ---"
xinput list
echo "----- End of List --------"

if [[ -z "$WINDOW_SIZE" ]]
then
    # detect the window size from the framebuffer file
    echo "Detecting window size from framebuffer"
    export WINDOW_SIZE=$( cat /sys/class/graphics/fb0/virtual_size )
    echo "Window size detected as $WINDOW_SIZE"
else
    echo "Window size set by environment variable to $WINDOW_SIZE"
fi

# stop the screen blanking
xset s off -dpms

foxglove-studio
