#!/bin/sh
cd "$(dirname "$0")"
python3 price_ef_route.py > price_ef_route.log 2>&1
