#!/bin/bash
# Description: Copy user from other system to local system
# $Author: Doh Halle $
# $RCSfile: user-copy.sh,v $



# system to copy user from
SHOST=$1
# username to copy
USR=$2

[ $# -ne 2 ] && exit 1

mkdir -p /root/.pwcopy 2>/dev/null
rm -f /root/.pwcopy/*
scp $SHOST:/etc/{passwd,shadow,group,group} /root/.pwcopy/

cd /root/.pwcopy/
grep ^$USR: passwd > passwd.copy
grep ^$USR: shadow > shadow.copy
grep :$(cut -d: -f4 passwd.copy): group > group.copy
grep :$(cut -d: -f4 gshadow.copy): group > gshadow.copy

grep -q ^$USR: /etc/passwd
if [ $? -ne 0 ]
then
   cat passwd.copy >> /etc/passwd
   cat shadow.copy >> /etc/shadow
   cat group.copy >> /etc/group
   cat gshadow.copy >> /etc/gshadow
   pwconv
   grpconv
   mkdir -p $( dirname $(grep ^$USR: passwd.copy | cut -d: -f6 ))
   cp -a /etc/skel $(grep ^$USR: passwd.copy | cut -d: -f6)
   chown -R $USR:$(cut -d: -f4 gshadow.copy) $(grep ^$USR: passwd.copy | cut -d: -f6)
   chmod -R 700 $(grep ^$USR: passwd.copy | cut -d: -f6)
   pwck
   grpck
fi
rm -fr /root/.pwcopy
