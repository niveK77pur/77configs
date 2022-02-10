#!/bin/bash
# Kill the program "rhythmbox" if it is running.
#If closed uncorrectly it can still run in the background making you have to kill it manually.

getPid=$(ps -C rhythmbox | awk '{print $1}' | tail -n 1)

if [[ $getPid -eq "PID" ]]; then
	echo "Program 'rhythmbox' is currently not running."
	exit 1
else
	echo -e "rhythmbox PID: \t $getPid"
	echo "killing the program 'rhythmbox' ..."
	kill $getPid
	echo "Done."
	exit 0
fi
