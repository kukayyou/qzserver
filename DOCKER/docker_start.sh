#!/bin/sh

# merge hosts optional
if [ -f "/mnt/conf/hosts" ]
then
    cat /mnt/conf/hosts >> /etc/hosts
fi

echo "${NODE_IP}  syslogserver" >> /etc/hosts

# copy conf
if [ -d "/mnt/conf" ]
then
	cp -f /mnt/conf/* /uc/etc/
fi

# start
/uc/sbin/qzserver -c /uc/etc/qzserver.conf