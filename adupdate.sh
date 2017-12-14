#!/bin/sh
#kysdm(gxk7231@gmail.com)
alias echo_date="echo 【$(date +%Y年%m月%d日\ %X)】:"
export ADBYBY=/usr/share/adbyby
judgment=$(sed -n '1p' $ADBYBY/create_jd.txt)
separated="—————————————————————"
sh_ver="1.1.9"
github_rules="https://raw.githubusercontent.com/adbyby/xwhyc-rules/master"
coding_rules="https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master"
#hiboy_rules="http://opt.cn2qq.com/opt-file"

restart_ad(){
  /etc/init.d/adbyby restart >/dev/null 2>&1
}
rm_cache(){
  cd /tmp
  rm -f lazy.txt video.txt md5.json installed.txt user-rules-adbyby.txt
}
judge_update(){
    if [ "$lazy_online"x == "$lazy_local"x ]; then
      echo_date "本地lazy规则已经最新，无需更新"
      logger -t "【Adbyby】" -p cron.info "本地lazy规则已经最新，无需更新" 
        if [ "$video_online"x == "$video_local"x ]; then
          echo_date "本地video规则已经最新，无需更新"
          logger -t "【Adbyby】" -p cron.info "本地video规则已经最新，无需更新"
          user_rules;rm_cache
	        echo_date "$separated脚本结束运行$separated"
          logger -t "【Adbyby】" -p cron.info "更新脚本结束运行"          
        else
          echo_date "检测到video规则更新，下载规则中..."
          logger -t "【Adbyby】" -p cron.info "检测到video规则更新，下载规则中..."
          download_video;user_rules;rm_cache;restart_ad    
          echo_date "$separated脚本结束运行$separated"
          logger -t "【Adbyby】" -p cron.info "更新脚本结束运行"
          
        fi
    else
      echo_date "检测到lazy规则更新，下载规则中..."
      logger -t "【Adbyby】" -p cron.info "检测到lazy规则更新，下载规则中..."
        if [ "$video_online"x == "$video_local"x ]; then
          echo_date "本地video规则已经最新，无需更新"
          logger -t "【Adbyby】" -p cron.info "本地video规则已经最新，无需更新"
          download_lazy;user_rules;rm_cache;restart_ad
          echo_date "$separated脚本结束运行$separated"
          logger -t "【Adbyby】" -p cron.info "更新脚本结束运行"
        else
          echo_date "检测到video规则更新，下载规则中..."
          logger -t "【Adbyby】" -p cron.info "检测到video规则更新，下载规则中..."
          download_lazy;download_video;user_rules;rm_cache;restart_ad
          echo_date "$separated脚本结束运行$separated"
          logger -t "【Adbyby】" -p cron.info "更新脚本结束运行"        
        fi
    fi
}
download_lazy(){
    wget --no-check-certificate -O /tmp/lazy.txt $coding_rules/lazy.txt
      if [ "$?"x != "0"x ]; then
        echo_date "下载coding中的lazy规则失败，尝试下载github中的规则"
        logger -t "【Adbyby】" -p cron.error "下载coding中的lazy规则失败，尝试下载github中的规则"
        wget --no-check-certificate -O /tmp/lazy.txt $github_rules/lazy.txt
          if [ "$?"x != "0"x ]; then
            echo_date "lazy规则下载失败，请检查网络"
            logger -t "【Adbyby】" -p cron.error "lazy下载失败，请检查网络"
          else
            echo_date "lazy规则下载成功，正在应用..."
            logger -t "【Adbyby】" -p cron.info "lazy规则下载成功，正在应用..."
            cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
          fi  
      else
        echo_date "【lazy】下载成功，正在应用..."
        logger -t "【Adbyby】" -p cron.info "lazy规则下载成功，正在应用..."
        cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
      fi  
}
download_video(){
    wget --no-check-certificate -O /tmp/video.txt $coding_rules/video.txt
      if [ "$?"x != "0"x ]; then
        echo_date "下载Coding中的video规则失败，尝试下载Github中的规则"
        logger -t "【Adbyby】" -p cron.error "下载Coding中的video规则失败，尝试下载Github中的规则"
        wget --no-check-certificate -O /tmp/video.txt $github_rules/video.txt
          if [ "$?"x != "0"x ]; then           
            echo_date "video规则下载失败，请检查网络"
            logger -t "【Adbyby】" -p cron.error "video规则下载失败，请检查网络"
          else
            echo_date "video规则下载成功，正在应用..."
            logger -t "【Adbyby】" -p cron.info "video规则下载成功，正在应用..."
            cp -f /tmp/lazy.txt $ADBYBY/data/lazy.txt
          fi       
      else
        echo_date "video规则下载成功，正在应用..."
        logger -t "【Adbyby】" -p cron.info "video规则下载成功，正在应用..."
        cp -f /tmp/video.txt $ADBYBY/data/video.txt
      fi  
}
user_rules(){
   if  grep -q 1 /usr/share/adbyby/rule_status.txt ; then    
      wget --no-check-certificate -O /tmp/user-rules-adbyby.txt https://raw.githubusercontent.com/kysdm/ad-rules/master/user-rules-adbyby.txt 
      if [ "$?"x != "0"x ]; then
        echo_date "下载自用规则失败"
        logger -t "【Adbyby】" -p cron.error "下载自用规则失败"
      else          
        user_online=$(sed -n '1p' /tmp/user-rules-adbyby.txt |  awk -F' ' '{print $3$4}'  | sed  's/-//g' | sed  's/://g')
        user_local=$(sed -n '1p' /usr/share/adbyby/user.txt |  awk -F' ' '{print $3$4}'  | sed  's/-//g' | sed  's/://g')
        if [ "$user_online" -le "$user_local" ];then
           echo_date "本地自用规则已经最新，无需更新"
           logger -t "【Adbyby】" -p cron.info "本地自用规则已经最新，无需更新"
        else
           echo_date "检测到自用规则更新，应用规则中..."
           logger -t "【Adbyby】" -p cron.info "检测到自用规则更新，应用规则中..."
            cp -f /tmp/user-rules-adbyby.txt $ADBYBY/user.txt
        fi
      fi  
   fi 
}
# check_rules(){
    echo_date "$separated脚本开始运行$separated" && cd /tmp
    logger -t "【Adbyby】" -p cron.info "更新脚本开始运行"
    wget --no-check-certificate https://coding.net/u/adbyby/p/xwhyc-rules/git/raw/master/md5.json
      if [ "$?"x != "0"x ]; then
         echo_date "获取在线规则MD5失败" 
         logger -t "【Adbyby】" -p cron.error "获取在线规则MD5失败" 
         echo_date "$separated脚本结束运行$separated"
         logger -t "【Adbyby】" -p cron.info "更新脚本结束运行"
         exit 0
      else
         lazy_local=$(md5sum $ADBYBY/data/lazy.txt | awk -F' ' '{print $1}')
         video_local=$(md5sum $ADBYBY/data/video.txt  | awk -F' ' '{print $1}') 
         lazy_online=$(sed  's/":"/\n/g' md5.json  |  sed  's/","/\n/g' | sed -n '2p')
         video_online=$(sed  's/":"/\n/g' md5.json  |  sed  's/","/\n/g' | sed -n '4p')
         echo_date "获取在线规则MD5成功，正在判断是否有更新中"
         logger -t "【Adbyby】" -p cron.info "获取在线规则MD5成功，正在判断是否有更新中"
         judge_update
      fi
# }
# action=$1
# if [[ "${action}" == "update" ]]; then
#   create_jd
# 	check_rules
# fi