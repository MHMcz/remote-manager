#!/bin/bash
# Copyright © 2014 Jan Markup <mhmcze@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

. "$HOME/.remote-manager/config"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
SCRIPT_NAME=$(basename $0)
CP=0

get_group() {
  group_regex='^=== *\(.*\)$'
  # return nothing if not match; return only group and no prefix
  echo "$1" | sed "/$group_regex/!d; s/$group_regex/\1/g"
}

get_key() {
  echo "$1" | cut -d \; -f 1
}

get_server() {
  echo $i | cut -d \; -f 2 | cut -d \@ -f 2
}

get_params() {
  echo $i | cut -d \; -f 3
}

if [[ $SCRIPT_NAME == *$MC_POSTFIX ]]; then
    CP=1
    SCRIPT_NAME=${SCRIPT_NAME%$MC_POSTFIX}
fi

CONFIG="$HOME/.remote-manager/$SCRIPT_NAME.cfg"

QUICK_NUMBER=()

COMMAND=$1
if [ "$COMMAND" == "" ]; then
  # create all_keys temp value with all aliases for check collison when create QUICK_NUMBER array
  all_keys=""
  for i in `cat "$CONFIG"`; do
    group=`get_group "$i"`
    if [ "$group" == "" ]; then
      all_keys+=`get_key "$i"`
      all_keys+='\n'
    fi
  done

  quick_key=1
  echo "==========================================="
  for i in `cat "$CONFIG"`; do
    group=`get_group "$i"`
    if [ "$group" != "" ]; then
      echo -e "\033[1;32m$group\033[0m"
    else
      is_key_free=`echo -e $all_keys | grep -cx "$quick_key"`
      while [ "$is_key_free" != "0" ]; do
        quick_key=$((quick_key+1))
        is_key_free=`echo -e $all_keys | grep -cx "$quick_key"`
      done

      key=`get_key "$i"`
      server=`get_server "$i"`
      echo -e " - [\033[1;31m$quick_key\033[0m] \033[1;31m$key\033[0m: $server"
      QUICK_NUMBER[$quick_key]=$key
      quick_key=$((quick_key+1))
    fi
  done
  echo "==========================================="
  echo
  read COMMAND
fi

if [ "$COMMAND" != "" ]; then
  # when command is quick number, replace command with real alias
  # must be checked for "is_number" - when space is in, array key fails on bash < 4
  if [[ "$COMMAND" =~ ^[0-9]+$ && "${QUICK_NUMBER[$COMMAND]}" != "" ]]; then
    COMMAND=${QUICK_NUMBER[$COMMAND]}
  fi

  for i in `cat "$CONFIG"`; do
    key=`get_key "$i"`
    server=`get_server "$i"`
    params=`get_params "$i"`
    
    if [ "$COMMAND" == "$key" ]; then
      echo -e "Connecting... \033[1;31m$server\033[0m"
      if [ $CP -eq 0 ]; then
        eval "ssh $server $params"
      else
        eval "mc $DEFAULT_LOCAL_DIR sh://$server"
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
