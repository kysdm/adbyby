#!/bin/sh
export ADBYBY=/usr/share/adbyby
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

#规则地址，仅可启用一个，去除#启用该地址，镜像地址规则可能非最新
rules="https://gitee.com/kysdm/xwhyc-rules/raw/master/lazy.txt"   #镜像地址
#rules="https://raw.githubusercontent.com/adbyby/xwhyc-rules/master/lazy.txt"  #官方github地址

#下载规则文件
echo_date 下载规则文件中...
echo_date 如长时间无反应，尝试挂代理后重试，或使用镜像地址
wget -t10 --no-check-certificate -O /tmp/lazy.txt $rules
 if [ "$?" == "0" ]; then
    echo_date 下载lazy文件成功，因video文件无用跳过下载...
   else
    echo_date 下载lazy文件失败，连接失败，尝试挂代理后重试
    rm -rf /tmp/lazy.txt
    exit
 fi

#判断是否有更新
version_lazy_up=$(sed -n '1p' /tmp/lazy.txt | awk -F' ' '{print $3 $4}' | sed 's/-//g' | sed 's/://g')
version_lazy=$(sed -n '1p' $ADBYBY/data/lazy.txt | awk -F' ' '{print $3 $4}' | sed 's/-//g' | sed 's/://g')

if [ "$version_lazy_up" -gt "$version_lazy_up" ];then
#if [ "$version_lazy_up" != "$version_lazy" ];then
  echo_date 检测到lazy规则更新，应用规则中...
#   mv /tmp/lazy.txt $ADBYBY/data/lazy.txt
 else
  echo_date 本地lazy规则与云端规则相同，无需更新
   rm -f /tmp/lazy.txt 
  exit
fi

#删除临时规则文件
rm -f /tmp/lazy.txt 

#重启adbyby应用规则
#/etc/init.d/adbyby restart
