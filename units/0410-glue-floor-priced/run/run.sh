#!/bin/sh
cd "$(dirname "$0")"
python3 price_split.py > price_split.log 2>&1
