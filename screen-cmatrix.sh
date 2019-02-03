#!/bin/bash

idle=false
idleAfter=240000     # consider idle after 240000 ms = 4 min

running_dir=$(ps aux | grep "cmatrix" | grep "screen-cmatrix.sh" | awk '{ print $12 }')
isFullscreen_program="${running_dir/"screen-cmatrix.sh"/"isFullscreen.py"}"

while true; do
  working_dir=$(pwd)
  if [[ $working_dir != "/" ]] ; then
    cd /
  fi
  isFullscreen=$(./$isFullscreen_program)
  idleTimeMillis=$(xprintidle)
  # echo $idleTimeMillis  # just for debug purposes.
  if [[ $idle = false && $idleTimeMillis -gt $idleAfter && $isFullscreen == "False" ]] ; then
    # echo "start idle"   # or whatever command(s) you want to run...
    active_window_name=$(xdotool getactivewindow getwindowname | grep -E "fish|tilda")
    if [[ ! -z "$active_window_name" ]] ; then # check if the variable is not empty
      xdotool getactivewindow windowminimize
    fi
    # tilda -g config_0
    gnome-terminal --window --full-screen --command="cmatrix -B"
    window_id=$(xwininfo -name "Terminal" |sed -e 's/^ *//' | grep -E "Window id" | awk '{ print $4 }')
    window_id=$(echo ${window_id:0:8}6)
    sleep 0.01
    xdotool windowactivate $window_id
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
