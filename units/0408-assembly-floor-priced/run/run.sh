#!/bin/sh
cd "$(dirname "$0")"
python3 price_floorconst.py > price_floorconst.log 2>&1
