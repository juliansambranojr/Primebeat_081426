#!/bin/sh
gcc -O3 -o lucy_pi lucy_pi.c -lm
python3 -I census.py
rm -f lucy_pi
