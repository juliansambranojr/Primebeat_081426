# Unit 0308's runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory.
#
# Phase 2b produced its figures by typing commands at a terminal. Nothing in
# the tree reproduced them, so this unit's prose would have had to quote a
# report. figures.py is the missing script: it recomputes every number the
# prose states, from git, from notes/lab_notebook_2.md, from the two .numbers
# files, and from the test suite, and writes figures.json for `lab values`.
#
# It is deliberately one invocation with no flags. Everything it reads is
# addressed inside it, because a figure whose source is a command-line
# argument is a figure the next reader has to reconstruct.
echo "recomputing unit 0308's figures"
python3 figures.py
echo "done"
