#!/bin/bash
# DESC: Screenshot tool
# $Author: Doh Halle $
# $RCSfile: screenshot_tool.sh,v $

DIR=$HOME/shot
TMP=/tmp/$(basename $0).tmp
test -d $DIR || mkdir $DIR
test -f $TMP && TEXT="$(cat $TMP)"
yad --title "Screen Shot Name" --entry --entry-text="$TEXT" --text "Enter Name of PNG Image:" > $TMP 2>/dev/null
FILE="$(cat $TMP)_$(date '+%Y%m%d-%H%M%S')"
scrot -s "$DIR/$FILE.png"
exit 0