#!/bin/bash 

echo "--- List Input Devices ---"
xinput list
echo "----- End of List --------"

if [[ -z "$WINDOW_SIZE" ]]
then
    # detect the window size from the framebuffer file
    echo "Detecting window size from framebuffer"
    export WINDOW_SIZE=$( xrandr | awk '/\*/{ print $1 }' | tr 'x' ' ' )
    echo "Window size detected as $WINDOW_SIZE"
else
    echo "Window size set by environment variable to $WINDOW_SIZE"
fi

# stop the screen blanking
xset s off -dpms

# Start Foxglove Studio in the backgroung
foxglove-studio &
PID=$!

# Wait a bit until Foxglove Studio is running properly
sleep 5

# Move and set window size to max available size
arr=($WINDOW_SIZE)
xdotool search --name "Foxglove Studio" windowmove 0 0 windowsize ${arr[0]} ${arr[1]}

# Wait until Foxglove Studio stops/dies
wait $PID

echo Foxglove Studio exited
