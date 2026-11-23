#!/bin/sh
# the first N steps, turned and added; where they line up, against the zeros
python3 lineup.py ../../../zeros600.json lineup.json > lineup.log
# the same steps asked for the size rate, the weight no longer put in by hand
python3 sizerate.py ../../../zeros600.json sizerate.json > sizerate.log
