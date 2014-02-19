#!/bin/bash
# Copyright © 2014 Jan Markup <mhmcze@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
SCRIPT_NAME=$(basename $0)
CP=0

if [[ $SCRIPT_NAME == *cp ]]; then
    CP=1
    SCRIPT_NAME=${SCRIPT_NAME%cp}
fi

CONFIG="$HOME/.remote-manager/$SCRIPT_NAME.cfg"

COMMAND=$1
if [ "$COMMAND" == "" ]; then
  echo "==========================================="
  for i in `cat "$CONFIG"`; do
    key=`echo $i | cut -d \; -f 1`
    server=`echo $i | cut -d \; -f 2 | cut -d \@ -f 2`
    echo -e " - \033[1;31m$key\033[0m: $server"
  done
  echo "==========================================="
  echo
  read COMMAND
fi

if [ "$COMMAND" != "" ]; then
  for i in `cat "$CONFIG"`; do
    key=`echo $i | cut -d \; -f 1`
    server=`echo $i | cut -d \; -f 2`
    params=`echo $i | cut -d \; -f 3`
    
    if [ "$COMMAND" == "$key" ]; then
      echo -e "Connecting... \033[1;31m$server\033[0m"
      if [ $CP -eq 0 ]; then
        eval "ssh $server $params"
      else
        eval "mc ~/work sh://$server"
      fi
      echo -e "Closed... \033[1;31m$server\033[0m"
      trueend="1"
    fi
  done
fi

if [ "$trueend" != "1" ]; then
  echo "???"
fi

IFS=$SAVEIFS
