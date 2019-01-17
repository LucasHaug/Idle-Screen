#!/bin/bash

idle=false
idleAfter=300000     # consider idle after 3000 ms

while true; do
  idleTimeMillis=$(xprintidle)
  #echo $idleTimeMillis  # just for debug purposes.
  if [[ $idle = false && $idleTimeMillis -gt $idleAfter ]] ; then
    #echo "start idle"   # or whatever command(s) you want to run...
    active_window_name=$(xdotool getactivewindow getwindowname)
    if [[ $active_window_name == "tilda" ]] ; then
        xdotool getactivewindow windowminimize
    fi
    tilda -g config_0
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