pinfile=${XDG_DATA_HOME:-$HOME}/pins

alias showpins='if [ -f $pinfile ]; then
            while read -r pin; do
              key=`awk -F "\t" '"'"'{print $1}'"'"' <<< $pin`
              folder=`awk -F "\t" '"'"'{print $2}'"'"' <<< $pin`
              echo -e "$key:-- $folder"
            done < $pinfile | column -t -s :
          fi'

pins() {
  operation=$1
  argument=$2
  case $operation in
    a)
      if [ "$argument" != "" ] && ([ ! -f "$pinfile" ] || ! awk -F "\t" '{print $1}' "$pinfile" | grep -q "^$argument$"); then
        touch "$pinfile"
        echo -e "$argument\t$PWD" >> "$pinfile"
        sort -o "$pinfile" "$pinfile"
        showpins
      fi
      ;;

    d)
      if [ "$argument" != "" ] && awk -F "\t" '{print $1}' "$pinfile" | grep -q "^$argument$"; then
        sed -i --follow-symlinks "/^$argument\t/d" "$pinfile"
        showpins
      fi
      ;;

    e)
      if [ "$argument" != "" ] && awk -F "\t" '{print $1}' "$pinfile" | grep -q "^$argument$"; then
        sed -i --follow-symlinks "s~^$argument\t.*~$argument\t$PWD~" "$pinfile"
        showpins
      fi
      ;;

    g)
      if [ "$argument" != "" ] && awk -F "\t" '{print $1}' "$pinfile" | grep -q "^$argument$"; then
        cd "$(awk -F "\t" -v arg="$argument" '$1==arg {print $2}' "$pinfile")" || exit
        ls
      fi
      ;;
  esac
}