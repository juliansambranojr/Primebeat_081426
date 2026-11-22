#!/bin/sh
cd "$(dirname "$0")"
python3 price_num.py > price_num.log 2>&1
