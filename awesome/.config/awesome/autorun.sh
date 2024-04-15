#!/bin/sh

run() {
    "$@"&
}

#run streamdeck
run amixer -c 0 set 'Front Mic Boost' 0 
run brillo -k -s "platform::mute" -rc -S 0
run brillo -k -s "platform::mute" -r -S 0
run brillo -k -s "platform::micmute" -rc -S 0
run brillo -k -s "platform::micmute" -r -S 0
run brillo -k -s "tpacpi::kbd_backlight" -rc -S 0 
run brillo -k -s "tpacpi::kbd_backlight" -c -S 0 
