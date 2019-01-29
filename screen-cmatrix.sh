#!/bin/bash

idle=false
idleAfter=300000     # consider idle after 300000 ms = 5 min

while true; do
  isFullscreen=$(./isFullscreen.py)
  idleTimeMillis=$(xprintidle)
  #echo $idleTimeMillis  # just for debug purposes.
  if [[ $idle = false && $idleTimeMillis -gt $idleAfter && $isFullscreen == "False" ]] ; then
    #echo "start idle"   # or whatever command(s) you want to run...
    active_window_name=$(xdotool getactivewindow getwindowname)
    if [[ $active_window_name == "tilda" ]] ; then
        xdotool getactivewindow windowminimize
    fi
    # tilda -g config_0
    gnome-terminal --window --full-screen --command=cmatrix
    window_id=$(xwininfo -name "Terminal" |sed -e 's/^ *//' | grep -E "Window id" | awk '{ print $4 }')
    sleep 1
    xdotool windowactivate $window_id #0x4600006
    idle=true
  fi

  if [[ $idle = true && $idleTimeMillis -lt $idleAfter ]] ; then
    #echo "end idle"     # same here.
    pid_of_cmatrix=$(pidof cmatrix)
    kill -SIGINT $pid_of_cmatrix
    idle=false
  fi
  sleep 1      # polling interval

done    
