#!/bin/bash

find ~/Voices/ \
    -type f \
    -name \*.mp3 \
    -o \
    -name \*.wav \
    | shuffle.pl \
    | head -1 \
    | xargs -I % afplay "%"
