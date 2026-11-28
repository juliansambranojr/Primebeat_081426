#!/bin/sh
gcc -O3 -march=native -fopenmp parity.c -o parity -lm
python3 -I check.py
