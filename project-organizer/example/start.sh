#!/bin/bash

# this script will be started in its folder

#midipp &
#urxvt -e a2jmidi_bridge &
#urxvt -e j2amidi_bridge &

#           zynaddsubfx --named instrument_1 --load instrument_1.xmz &
#sleep 8s ; zynaddsubfx --named instrument_2 --load instrument_2.xmz &
#sleep 8s ; zynaddsubfx --named instrument_3 --load instrument_3.xmz &
#sleep 8s ; zynaddsubfx --named instrument_4 --load instrument_4.xmz &
#sleep 8s ; zynaddsubfx --named instrument_5 --load instrument_5.xmz &
#sleep 8s ; zynaddsubfx --named instrument_6 --load instrument_6.xmz &
#sleep 8s ; zynaddsubfx --named instrument_7 --load instrument_7.xmz &
#sleep 8s ; zynaddsubfx --named instrument_8 --load instrument_8.xmz &
#sleep 8s ; zynaddsubfx --named instrument_9 --load instrument_9.xmz &

#exec patchage &

renoise ./renoise.xrns &> .log_renoise &

sleep 10s ; aj-snapshot --jack --remove --restore snapshot
