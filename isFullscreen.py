#! /usr/bin/python3

from ewmh import EWMH

ewmh = EWMH()

win = ewmh.getActiveWindow()

inhibit = '_NET_WM_STATE_FULLSCREEN' in ewmh.getWmState(win, str=True)

print(inhibit)