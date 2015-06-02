#!/bin/bash
source /etc/dsniff-daemon.conf
mkdir $LOGDIR

# Check if script is running with uid 0
if [ "$(id -u)" != 0 ]; then
  echo "This script must be run as root"
  exit 128
fi

# Make sure script is only executed one time
PID=$$
if [ -e $PIDFILE ] && kill -0 $(cat $PIDFILE) 2>/dev/null; then
  echo  "Another instance is running with PID $(cat $PIDFILE)"
  exit 128
fi
echo $PIDFILE
echo -n $PID > $PIDFILE

dsniff $@ &
DSNIFFPID=$!

trap "kill $DSNIFFPID; rm $PIDFILE; exit" 15

while true; do
  sleep 3
done
