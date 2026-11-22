#!/bin/sh
cd "$(dirname "$0")"
python3 price_floor.py > price_floor.log 2>&1
