#!/bin/sh
#脚本作者Lean，我只改了规则更新地址

wget -O /tmp/lazy.txt --no-check-certificate --tries=5 https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/lazy.txt
wget -O /tmp/video.txt --no-check-certificate --tries=5 https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/video.txt
wget -O /tmp/user.action --tries=5 http://update.adbyby.com/rule3/user.action

[ -s "/tmp/lazy.txt" ] && ( ! cmp -s /tmp/lazy.txt /usr/share/adbyby/data/lazy.txt ) && mv /tmp/lazy.txt /usr/share/adbyby/data/lazy.txt	
[ -s "/tmp/user.action" ] && ( ! cmp -s /tmp/video.txt /usr/share/adbyby/data/video.txt ) && mv /tmp/video.txt /usr/share/adbyby/data/video.txt	
[ -s "/tmp/video.txt" ] && ( ! cmp -s /tmp/user.action /usr/share/adbyby/user.action ) && mv /tmp/user.action /usr/share/adbyby/user.action	

if [ -s "/tmp/lazy.txt" -a -s "/tmp/user.action" -a -s "/tmp/video.txt" ];then
  echo "Adbyby Rules No Change"
 else
  rm -f /usr/share/adbyby/update.info
   echo "Adbyby Rules Upadated!"
fi

rm -f /tmp/lazy.txt /tmp/video.txt /tmp/user.action

/etc/init.d/adbyby restart


