. "$HOME/.remote-manager/config"

get_group() {
  group_regex='^=== *\(.*\)$'
  #return nothing if not match; return only group and no prefix
  echo "$1" | sed "/$group_regex/!d; s/$group_regex/\1/g"
}

get_key() {
  echo "$1" | cut -d \; -f 1
}

_remote_manager_args() {
  _arguments \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "$1 subcommand" _1st_arguments_$1
    return
  fi
}

for config in $(ls "$HOME/.remote-manager/"*.cfg); do
  basename=`basename "$config"`
  filename=${basename%.*}
  local -a "_1st_arguments_$filename"
  SAVEIFS=$IFS
  IFS=$(echo -en "\n\b")
  for i in `cat "$config"`; do
    group=`get_group "$i"`
    if [[ "$group" == "" ]]; then
      key=`get_key "$i"`
      if [[ "$key" != "" ]]; then
        eval "_1st_arguments_$filename+=( \"$key\" )"
      fi
    fi
  done
  IFS=$SAVEIFS

  compdef "_remote_manager_args $filename" $filename
  compdef $filename$MC_POSTFIX=$filename
done
