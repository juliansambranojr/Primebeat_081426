#!/bin/sh
cd "$(dirname "$0")"
python3 price_height.py > price_height.log 2>&1
