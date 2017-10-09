#!/bin/sh
#kysdm(gxk7231@gmail.com)
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
export ADBYBY=/usr/share/adbyby
judgment=$(sed -n '1p' $ADBYBY/create_jd.txt)
separated="—————————————————————"
sh_ver="1.1.0"
rules="https://raw.githubusercontent.com/adbyby/xwhyc-rules/master"
lazy_version=$(sed -n '1p' $ADBYBY/data/lazy.txt | awk -F' ' '{print $3,$4}')
video_version=$(sed -n '1p' $ADBYBY/data/video.txt | awk -F' ' '{print $3,$4}')

lazy_update(){
  echo_date "本地lazy规则时间 [$lazy_version] " 
  echo_date "线上lazy规则时间 [$lazy_versiony_new] " 
   if [ "$lazy_versiony_new" != "$lazy_version" ]; then
    if [ "$judgment"x == "YES"x ];then
       echo_date 检测到lazy规则有更新，应用规则中...
       chattr -i $ADBYBY/data/lazy.txt                                     
       cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt          
       chattr +i $ADBYBY/data/lazy.txt                                      
    else
       echo_date 检测到lazy规则有更新，应用规则中...
       cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt           
    fi
   else
    echo_date "lazy规则无更新" 
   fi
}
video_update(){
  echo_date "本地video规则时间 [$video_version] " 
  echo_date "线上video规则时间 [$video_versiony_new] " 
   if [ "$video_versiony_new" != "$video_version" ]; then
    if [ "$judgment"x == "YES"x ];then
       echo_date 检测到video规则有更新，应用规则中...
       chattr -i $ADBYBY/data/video.txt                                       
       cp -f /tmp/video.txt $ADBYBY/data/video.txt          
       chattr +i $ADBYBY/data/video.txt                                     
    else
       echo_date 检测到video规则有更新，应用规则中...
       cp -f /tmp/video.txt $ADBYBY/data/video.txt         
    fi
   else
    echo_date "video规则无更新"
   fi
}
#创建判断文件
if [ ! -e "$ADBYBY/create_jd.txt" ]; then
   touch $ADBYBY/create_jd.txt
   echo "NO" > $ADBYBY/create_jd.txt
fi
#下载规则文件
 echo_date "$separated脚本开始运行$separated"
 echo_date 下载规则文件中...
#下载lazy
  wget --no-check-certificate -O /tmp/lazy.txt $rules/lazy.txt
  lazy_result=$?
  lazy_versiony_new=$(sed -n '1p' /tmp/lazy.txt | awk -F' ' '{print $3,$4}')
#下载video
  wget --no-check-certificate -O /tmp/video.txt $rules/video.txt
  video_result=$?
  video_versiony_new=$(sed -n '1p' /tmp/video.txt | awk -F' ' '{print $3,$4}')
#判断文件是否下载成功
 if [[ "$lazy_result"x == "0"x ]] && [[ "$video_result"x == "0"x ]]; then   #两个都下载成功执行下行命令
    echo_date lazy与video规则文件都下载成功,判断是否有更新...
    lazy_update
    video_update
    rm -f /tmp/lazy.txt /tmp/video.txt
    /etc/init.d/adbyby restart
    echo_date "$separated脚本结束运行$separated"
    exit 0
 elif [[ "$lazy_result"x != "0"x ]] && [[ "$video_result"x != "0"x ]]; then   #两个都下载失败执行下行命令
    echo_date lazy与video规则文件都下载失败,请检查网络!
    rm -f /tmp/lazy.txt /tmp/video.txt
    echo_date "$separated脚本结束运行$separated"
    exit 1
 elif [ "$lazy_result"x == "0"x ]; then                                       #只有lazy下载成功执行下行命令
    echo_date 只有lazy规则文件下载成功，判断是否有更新...
    lazy_update
    rm -f /tmp/lazy.txt /tmp/video.txt
    /etc/init.d/adbyby restart
    echo_date "$separated脚本结束运行$separated"
    exit 0  
 elif [ "$video_result"x == "0"x ]; then                                      #只有video下载成功执行下行命令     
    echo_date 只有video规则文件下载成功，判断是否有更新...
    video_update
    rm -f /tmp/lazy.txt /tmp/video.txt
    /etc/init.d/adbyby restart
    echo_date "$separated脚本结束运行$separated"
    exit 0  
 fi  