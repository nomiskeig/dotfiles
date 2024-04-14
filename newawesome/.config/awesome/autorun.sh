#!/bin/sh

run() {
    "$@"&
}

#run streamdeck
run amixer -c 0 set 'Front Mic Boost' 0 
