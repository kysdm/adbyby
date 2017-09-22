#!/bin/sh
export ADBYBY=/usr/share/adbyby
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
url_main="https://raw.githubusercontent.com/adbyby/xwhyc-rules"
url_image="https://raw.githubusercontent.com/adbyby/xwhyc-rules"

#下载规则文件
echo_date 下载规则文件中...

wget -N --no-check-certificate -O /tmp/lazy.txt $url_main/master/lazy.txt
  if [ "$?" == "0" ]; then
    echo_date 下载lazy文件成功，继续下载video文件...
   else
    echo_date 下载lazy文件失败，连接github失败，尝试挂代理后重试
    rm -rf /tmp/lazy.txt
    exit
  fi

wget -N --no-check-certificate -O /tmp/video.txt $url_image/master/video.txt
  if [ "$?" == "0" ]; then
    echo_date 下载video文件成功，判断规则是否有更新中...
   else
    echo_date 下载video文件失败，连接github失败，尝试挂代理后重试
    rm -rf /tmp/video.txt
    exit
  fi

#wget -N --no-check-certificate -O /tmp/user.action $url_main/master/user.action

#判断是否有更新
version_lazy_up=$(head -1 /tmp/lazy.txt  | awk -F' ' '{print $3,$4}')
version_video_up=$(head -1 /tmp/video.txt | awk -F' ' '{print $3,$4}')

version_lazy=$(head -1 $ADBYBY/lazy.txt  | awk -F' ' '{print $3,$4}')
version_lazy=$(head -1 $ADBYBY/video.txt  | awk -F' ' '{print $3,$4}')

if [ "$version_lazy_up" != "$version_lazy" ];then
  echo_date 本地lazy规则与云端规则相同，无需更新
 else
  echo_date 检测到lazy规则更新，应用规则中...
  mv /tmp/lazy.txt $ADBYBY/data/lazy.txt
fi

if [ "$version_video_up" != "$version_video" ];then
  echo_date 本地video规则与云端规则相同，无需更新
  exit
else
  echo_date 检测到video规则更新，应用规则中...
  mv /tmp/video.txt $ADBYBY/data/video.txt
fi

#if [ "$version_lazy_up" != "$version_lazy" -o （"$version_video_up" != "$version_video" ]

#删除临时规则文件
#rm -f /tmp/lazy.txt /tmp/video.txt /tmp/user.action

#重启adbyby应用规则
#/etc/init.d/adbyby restart
