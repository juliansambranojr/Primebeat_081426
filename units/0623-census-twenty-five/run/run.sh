#!/bin/sh
python3 -I table.py
python3 -I builds.py
python3 -I pins.py ../../.. only_four_zeros_le24,piData24_of_25,only_four_zeros_le25,piData25_of_26,only_four_zeros_outside_corner26
