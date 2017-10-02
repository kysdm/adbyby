#!/bin/sh
export ADBYBY=/usr/share/adbyby
crontab=/etc/crontabs/root

#删除wget插件
# opkg remove wget

#删除脚本文件
  rm -f $ADBYBY/adupdate.sh

#删除计划任务
  sed -i '/adupdate.sh/d' $crontab
  /etc/init.d/cron restart
