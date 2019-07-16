#!/bin/bash
#
# chkconfig: 2345 64 36
# description: qzserver startup scripts
#

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
rc=0

export PATH

qzserver=/uc/sbin
# each config file for one instance
configs="/uc/etc/qzserver.conf"
pidfile="/uc/etc/qzserver.pid"
nohupfile="/uc/etc/nohup.qzserver.out"

# 检查配置文件是否包含空白行
errConfs=0
for file in /uc/etc/*.conf
do
    if test -f $file
    then
		num=`grep -E '^[[:blank:]]+$' $file | wc -l`
		if [ "$num" -gt 0 ]; then
			echo $file
			grep -n -E '^[[:blank:]]+$' $file | cat -A
			errConfs=$[$errConfs + 1]
		fi
    fi
done

if [ "$errConfs" -ne 0 ]; then
	echo "******$errConfs configure invalid******" 
	exit 8
fi
##########################


ulimit -c unlimited
echo 1 > /proc/sys/fs/suid_dumpable
echo  "/uc/share/%e-%p-%s-%t.core" >/proc/sys/kernel/core_pattern

ulimit -n 1024000 

startdebug() {
	if [ -f $pidfile ];then
		echo "qzserver is running"
		exit 7
	fi 
	env GOTRACEBACK=crash nohup $qzserver_root/qzserver -c $configs >> $nohupfile &
	sleep 1
	test -f $pidfile && echo "Start qzserver success"
}

startX(){
        if [ -f $pidfile ];then
            echo "qzserver is running"
            exit 7
        fi  
        nohup $qzserver_root/qzserver -c $configs >> $nohupfile &
        sleep 3
		getpid
        echo $pid >> $pidfile
        if [ -f $pidfile ];then
            echo "Start qzserver success"
            rc=0
        else
            echo "qzserver is not start"
            rc=7
        fi
}

getpid(){
    pid=`ps -eo 'pid,args' | grep $qzserver_root/qzserver | grep -v grep | awk '{print $1}'`
}
 
stopX(){
        getpid
        if [ -z "$pid" ];then
            echo "qzserver is not running"
            rc=0
        else
            kill $pid >/dev/null 2>&1
            sleep 3
            getpid
            if [ -n "$pid" ];then
                kill -9 $pid >/dev/null 2>&1
            fi
            echo "Stop qzserver success";
        fi
        test -f $pidfile && rm $pidfile
}

# See how we were called.
case "$1" in
    startdebug)
        startdebug
        ;;
    start)
        startX
        ;;
    stop)
        stopX
        ;;
    restart)
        stopX
        startX
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        ;;
esac
exit $rc
