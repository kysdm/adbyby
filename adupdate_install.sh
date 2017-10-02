#!/bin/sh
export ADBYBY=/usr/share/adbyby
crontab=/etc/crontabs/root

#安装必要插件
#opkg update
#opkg install wget

#下载脚本
 wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate.sh
 chmod 777 $ADBYBY/adupdate.sh

#添加计划任务
 sed -i '/adupdate.sh/d' $crontab
 echo '30 */6 * * * /usr/share/adbyby/adupdate.sh > /tmp/log/adupdate.log 2>&1' >> $crontab
 /etc/init.d/cron restart

#执行一次更新
 sh $ADBYBY/adupdate.sh
