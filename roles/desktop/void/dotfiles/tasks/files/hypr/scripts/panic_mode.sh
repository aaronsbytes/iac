#!/bin/bash

# Mute audio
wpctl set-mute @DEFAULT_AUDIO_SINK@ 1

# Mute microphone
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1

# Turn off screen
brightnessctl s 0%
