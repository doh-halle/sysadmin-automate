
#!/bin/sh
# Description: Prints log lines which have been added since last logtail
# $Author: Doh Halle$

###########################################################
export PATH=/sbin:/usr/sbin:/bin:/usr/bin
set -e
LOGF=$1 # logfile itself
LOGT=$1.logtail #here we store logfile size
test -r $LOGF || (echo ERROR: can not read $LOGF ; exit 1)
test -e $LOGT || echo 0 > $LOGT || (echo ERROR: can not write $LOGT ; exit 1)
LOFFSET=`cat $LOGT` # get last run logfile size
COFFSET=`cat $LOGF | wc -c` # get current logfile size
[ $COFFSET -eq $LOFFSET ] && exit 0 # logfile has same size as last run, do nothing
[ $COFFSET -lt $LOFFSET ] && LOFFSET=0 # file is smaller than last time, we assume it got tuncated
cat $LOGF | dd  bs=1 skip=$LOFFSET conv=noerror 2>/dev/null | cat | strings
echo $COFFSET > $LOGT || (echo ERROR: can not write $LOGF ; exit 1) # write new file size