# A runnable that fails, on purpose. This fixture is committed so that the
# state `lab run` leaves behind after a failure is a thing a reader can open
# rather than a thing a test asserts about and then deletes.
#
# The second line raises. Under `/bin/sh -e` the shell stops there and returns
# that command's status, so the third line never runs -- which is the whole
# reason the flag is there. Without it sh would have carried on and returned
# the status of the last echo, reporting success for a run that crashed.
echo "starting the sweep"
python3 -c "raise ValueError('the grid is empty at this rung')"
echo "this line is never reached"
