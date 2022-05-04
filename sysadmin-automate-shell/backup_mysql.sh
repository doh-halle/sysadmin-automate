#! /bin/bash
# Description: Perform backup of all mysql databases
# $Author: Doh Halle $

### NOTE ###
# vi /root/.my.cnf
# ---
# [client]
# host=localhost
# user=user
# password=password

########################

BDIR="/srv/backup/mysql"

test -d $BDIR || mkdir -p $BDIR

for DB in $( mysql -N -B -e "show databases" | egrep -v 'information_schema|performance_schema' )
do
  mysqldump $DB --single-transaction | gzip > $BDIR/$DB.mysql.gz
done
