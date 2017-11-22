#!/bin/sh
#kysdm(gxk7231@gmail.com)
alias echo_date="echo 【$(date +%Y年%m月%d日\ %X)】:"
export ADBYBY=/usr/share/adbyby
judgment=$(sed -n '1p' $ADBYBY/create_jd.txt)
separated="—————————————————————"
sh_ver="1.1.6"
github_rules="https://raw.githubusercontent.com/adbyby/xwhyc-rules/master"
coding_rules="https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master"
#hiboy_rules="http://opt.cn2qq.com/opt-file"

restart_ad(){
  /etc/init.d/adbyby restart >/dev/null 2>&1
}
rm_cache(){
  cd /tmp
  rm -f lazy.txt video.txt local-md5.json md5.json installed.txt
}
judge_update(){
    if [ "$lazy_online"x == "$lazy_local"x ]; then
      echo_date "本地lazy规则已经最新，无需更新" 
        if [ "$video_online"x == "$video_local"x ]; then
          echo_date "本地video规则已经最新，无需更新"
	        echo_date "$separated脚本结束运行$separated" 
          rm_cache && exit 0
        else
          echo_date "检测到video规则更新，下载规则中..."
          download_video;restart_ad
          echo_date "$separated脚本结束运行$separated"
          rm_cache && exit 0
        fi
    else
      echo_date "检测到lazy规则更新，下载规则中..."
        if [ "$video_online"x == "$video_local"x ]; then
          echo_date "本地video规则已经最新，无需更新"
          download_lazy;restart_ad
          echo_date "$separated脚本结束运行$separated"
          rm_cache && exit 0
        else
          echo_date "检测到video规则更新，下载规则中..."
          download_lazy;download_video;restart_ad
          echo_date "$separated脚本结束运行$separated"
          rm_cache && exit 0
        fi
    fi
}

download_lazy(){
    wget --no-check-certificate -O /tmp/lazy.txt $coding_rules/lazy.txt
      if [ "$?"x != "0"x ]; then
        echo_date "【lazy】下载coding中的规则失败，尝试下载github中的规则"
        wget --no-check-certificate -O /tmp/lazy.txt $github_rules/lazy.txt
          if [ "$?"x != "0"x ]; then
            echo_date "【lazy】双双失败GG，请检查网络"
          else
            echo_date "【lazy】下载成功，正在应用..."
            cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
          fi  
      else
        echo_date "【lazy】下载成功，正在应用..."
        cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
      fi  
}
download_video(){
    wget --no-check-certificate -O /tmp/video.txt $coding_rules/video.txt
      if [ "$?"x != "0"x ]; then
        echo_date "【video】下载Coding中的规则失败，尝试下载Github中的规则"
        wget --no-check-certificate -O /tmp/video.txt $github_rules/video.txt
          if [ "$?"x != "0"x ]; then           
            echo_date "【video】双双失败GG，请检查网络"
          else
            echo_date "【video】下载成功，正在应用..."
            cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
          fi       
      else
        echo_date "【video】下载成功，正在应用..."
        cp -f /tmp/video.txt $ADBYBY/data/video.txt
      fi  
}
create_jd(){
    if [ ! -e "$ADBYBY/create_jd.txt" ]; then
        touch $ADBYBY/create_jd.txt
        echo "NO" > $ADBYBY/create_jd.txt
    fi
}
# check_rules(){
    echo_date "$separated脚本开始运行$separated" && cd /tmp
    md5sum /usr/share/adbyby/data/lazy.txt /usr/share/adbyby/data/video.txt > local-md5.json
    wget --no-check-certificate https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master/md5.json
      if [ "$?"x != "0"x ]; then
         echo_date "获取在线规则时间失败" && exit 0       
      else
         lazy_local=$(grep 'lazy' local-md5.json | awk -F' ' '{print $1}')
         video_local=$(grep 'video' local-md5.json | awk -F' ' '{print $1}')  
         lazy_online=$(sed  's/":"/\n/g' md5.json  |  sed  's/","/\n/g' | sed -n '2p')
         video_online=$(sed  's/":"/\n/g' md5.json  |  sed  's/","/\n/g' | sed -n '4p')
         echo_date "获取在线规则MD5成功，正在判断是否有更新中"
         judge_update
      fi  
# }
# action=$1
# if [[ "${action}" == "update" ]]; then
#   create_jd
# 	check_rules
# fi