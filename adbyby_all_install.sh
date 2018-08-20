#!/bin/sh
#kysdm(gxk7231@gmail.com)
export ADBYBY=/usr/share/adbyby
export config=/etc/config
crontab=/etc/crontabs/root
cron=/etc/config/cron
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
luci="http://code.taobao.org/svn/luci-app-adbyby" 
kysdm_github="https://raw.githubusercontent.com/kysdm/adbyby" 
kysdm_coding="https://coding.net/u/kysdm/p/adbyby/git/raw"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
opkg list-installed | awk -F' ' '{print $1}' > /tmp/installed.txt
sh_ver="1.5.0"

Download_adupdate(){
    wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh $kysdm_coding/master/adupdate.sh
     if [ "$?"x == "0"x ]; then
      chmod 777 $ADBYBY/adupdate.sh && echo -e "${Info} 规则辅助更新脚本下载成功"
     else
      echo -e "${Error} 规则辅助更新脚本下载失败" && exit 1
     fi  
}
Update_all_install(){
    echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
    wget -t3 -T10 --no-check-certificate -q -O /tmp/adbyby_all_install.sh $kysdm_coding/master/adbyby_all_install.sh
	sh_new_ver=$(grep 'sh_ver="' /tmp/adbyby_all_install.sh |awk -F "=" '{print $NF}'| sed 's/\"//g' | sed -n '1p')
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
        case $yn in 
         y|Y) 
         cp -f /tmp/adbyby_all_install.sh $ADBYBY/adbyby_all_install.sh
         chmod 777 $ADBYBY/adbyby_all_install.sh && rm -f /tmp/adbyby_all_install.sh
         echo -e "${Info} 脚本已更新为最新版本[ ${sh_new_ver} ] !"
         ;;
         n|N)
         echo "${Info} 已取消..."
         ;;
        esac 
	else
		echo -e "${Info} 当前已是最新版本[ ${sh_new_ver} ] !"
	fi
	exit 0
}
Update_adupdate(){
    sh_ver=$(grep 'sh_ver="' $ADBYBY/adupdate.sh | awk -F "=" '{print $NF}' | sed 's/\"//g' | sed -n '1p' )
    echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
    wget -t3 -T10 --no-check-certificate -q -O /tmp/adupdate.sh $kysdm_coding/master/adupdate.sh
	sh_new_ver=$(grep 'sh_ver="' /tmp/adupdate.sh | awk -F "=" '{print $NF}' | sed 's/\"//g' | sed -n '1p' )
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
        case $yn in 
         y|Y) 
         cp -f /tmp/adupdate.sh $ADBYBY/adupdate.sh
         chmod 777 $ADBYBY/adupdate.sh && rm -f /tmp/adupdate.sh
         echo -e "${Info} 脚本已更新为最新版本[ ${sh_new_ver} ] !"
         ;;
         n|N)
         echo "${Info} 已取消..."
         ;;
        esac 
	else
		echo -e "${Info} 当前已是最新版本[ ${sh_new_ver} ] !"
	fi
	exit 0
}
delete_adupdate(){
 	rm -f $ADBYBY/adupdate.sh $ADBYBY/rule_status.txt && echo -e "${Info} 规则辅助更新脚本删除成功"
}
run_adupdate(){
    sh $ADBYBY/adupdate.sh
}
restart_adbyby(){
    /etc/init.d/adbyby restart 2>&1 && echo -e "${Info} 重启完成"
}
restart_crontab(){
    /etc/init.d/cron restart 2>&1 && echo -e "${Info} 重启完成" 
}
stop_adbyby(){
    /etc/init.d/adbyby stop && echo -e "${Info} 停止成功"
}
auto_adupdate_auto_install(){
    # if [ -e "$cron" ]; then
    #  if  grep -q pandorabox /etc/banner ; then
    #     auto_adupdate1_install
    #  else
    #     if  grep -q rapistor /etc/banner ; then   #明月永在固件
    #       auto_adupdate4_install
    #     else
    #       auto_adupdate3_install    
    #     fi 
    #  fi
    # else
    #     auto_adupdate4_install
    # fi  
    if  grep -q pandorabox /etc/banner ; then
      if [ -e "$cron" ]; then
        auto_adupdate1_install
      else
        auto_adupdate4_install
      fi
    else
      auto_adupdate4_install
    fi  
}
auto_adupdate1_install(){
    sed -i '/adbyby/d' $crontab
	if  grep -q adbyby规则更新 $cron ; then
	   plan_the_task_line=$(grep -n "$ADBYBY/adupdate.sh" $cron  | awk '{print $1}' | sed 's/://g')
	   rod=`expr $plan_the_task_line - 4`
	   sed -i "$rod,+4d" $cron
       echo -e "\nconfig task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '0 */3 * * * /usr/share/adbyby/adupdate.sh'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 计划任务写入完成";
	 else
       echo -e "\nconfig task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '0 */3 * * * /usr/share/adbyby/adupdate.sh'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 计划任务写入完成";
	fi 
}
# auto_adupdate3_install(){
#     echo -e "${Error} 因没有对应固件无法做支持"
#     echo -e "${Info} 请手动添加计划任务到系统中，cron原生参数如下"
# 	echo -e "${Info} '0 */3 * * * /usr/share/adbyby/adupdate.sh'"
#     exit 0
# }
auto_adupdate4_install(){
	sed -i '/adbyby/d' $crontab
    echo -e "0 */3 * * * /usr/share/adbyby/adupdate.sh" >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 计划任务写入完成"
}
auto_adupdate_auto_uninstall(){                                
#  if [ -e "$cron" ]; then
#   if  grep -q pandorabox /etc/banner ; then
#       auto_adupdate1_uninstall
#       sed -i '/adbyby/d' $crontab
#       /etc/init.d/cron restart
#   else
#      if  grep -q rapistor /etc/banner ; then   #明月永在固件
#        auto_adupdate2_uninstall
#      else        
#        echo -e "${Error} 不支持当前固件，请手动删除计划任务" && exit 0
#      fi
#   fi
#  else
#    auto_adupdate2_uninstall
#  fi
    if  grep -q pandorabox /etc/banner ; then
      if [ -e "$cron" ]; then
        auto_adupdate1_uninstall
      else
        auto_adupdate2_uninstall
      fi
    else
        auto_adupdate2_uninstall
    fi 
}
auto_adupdate1_uninstall(){
	if  grep -q adupdate $cron ; then
	   plan_the_task_line=$(grep -n "$ADBYBY/adupdate.sh" $cron  | awk '{print $1}' | sed 's/://g')
	   rod=`expr $plan_the_task_line - 4`
	   sed -i "$rod,+4d" $cron
	   /etc/init.d/cron restart
       echo -e "${Info} 删除成功";
	 else
       echo -e "${Error} 未添加计划任务"
	fi 
}
auto_adupdate2_uninstall(){
	sed -i '/adbyby/d' $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 计划任务删除成功"
}
adbyby_install(){
    echo && echo -e "
————————————
  ${Green_font_prefix}1.${Font_color_suffix} 自动判断固件(LEDE固件必须使用这个)(需要进入web管理界面二次确认安装)
  ${Green_font_prefix}2.${Font_color_suffix} 安装ar71xx版
  ${Green_font_prefix}3.${Font_color_suffix} 安装arm版(K3)
  ${Green_font_prefix}4.${Font_color_suffix} 安装armv7版
  ${Green_font_prefix}5.${Font_color_suffix} 安装7620A（N)和7621 pandorabox专用版
  ${Green_font_prefix}6.${Font_color_suffix} 安装7620A（N)和7621 OPENWRT官版专用版
  ${Green_font_prefix}7.${Font_color_suffix} 安装7620A（N)和7621 pandorabox专用版(2016.10之后的固件)
  ${Green_font_prefix}8.${Font_color_suffix} 安装7620A（N)和7621 pandorabox小闪存专用版(每次开机时下载主程序到内存中运行)
  ${Green_font_prefix}9.${Font_color_suffix} 安装最新 pandorabox小闪存专用版(2016.10之后的固件)(每次开机时下载主程序到内存中运行)
  ${Green_font_prefix}10.${Font_color_suffix} 安装X86版
 ${Green_font_prefix}11.${Font_color_suffix} 安装X64版
 ${Green_font_prefix}12.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-12]: " input
    case $input in 
     1) auto_adbyby_install;;
	 2) ar71xx;;
	 3) arm;;
	 4) armv7;;
     5) pandorabox_dedicated;;
	 6) OPENWRT_dedicated;;
     7) pandorabox_dedicated_new;;
     8) pandorabox_dedicated_small;;
     9) pandorabox_dedicated_small_new;;
     10) x86;;
     11) x64;;
	 12) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-12]" && exit 1;;
    esac
}
auto_adbyby_install(){
    opkg update && opkg install $luci/adbyby_2.7-8.0_all.ipk
}
ar71xx(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_ar71xx.ipk
}
arm(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_arm.ipk
}
armv7(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_armv7.ipk
}
pandorabox_dedicated(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_ralink.ipk
}
OPENWRT_dedicated(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_ramips_24kec.ipk
}
pandorabox_dedicated_new(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_mipsel_24kec_dsp.ipk
}
pandorabox_dedicated_small(){
    opkg update && opkg install $luci/adbyby_mini_2.7-7.0_ralink.ipk
}
pandorabox_dedicated_small_new(){
    opkg update && opkg install $luci/adbyby_mini_2.7-7.0_mipsel_24kec_dsp.ipk
}
x86(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_x86.ipk 
}
x64(){
    opkg update && opkg install $luci/adbyby_2.7-7.0_x64.ipk
}
adbyby_uninstall(){
   if  grep -q adbyby /tmp/installed.txt ; then
     opkg remove adbyby && echo -e "${Info} 卸载成功" 
   else
     echo -e "${Error} 未安装ADBYBY"
   fi 
}

cat_time(){
    lazy_time=$(sed -n '1p' $ADBYBY/data/lazy.txt | awk -F' ' '{print $3,$4}')
    echo -e "lazy : $lazy_time"
    video_time=$(sed -n '1p' $ADBYBY/data/video.txt | awk -F' ' '{print $3,$4}')
    echo -e "video: $video_time"    
}
######################################################
#判断一些文件是否存在，以免后续报错，就这样写了 简单明了
 if [ ! -x "$ADBYBY/adbyby_all_install.sh" ]; then
   chmod 777 $ADBYBY/adbyby_all_install.sh
 fi
 if [ ! -e "$ADBYBY/rule_status.txt" ]; then
    touch $ADBYBY/rule_status.txt
    echo "0" > $ADBYBY/rule_status.txt
 fi   
 if [ ! -e "$ADBYBY/wechat_status" ]; then
    touch $ADBYBY/wechat_status
    echo "off" > $ADBYBY/wechat_status
 fi
 if [ ! -e "$ADBYBY/wechat_sckey" ]; then
    touch $ADBYBY/wechat_sckey
    echo "" > $ADBYBY/wechat_sckey
 fi   
######################################################
user_rules(){
    echo "1" > $ADBYBY/rule_status.txt
    cd /tmp
    wget -t3 -T10 --no-check-certificate https://raw.githubusercontent.com/kysdm/ad-rules/master/user-rules-adbyby.txt
      if [ "$?"x == "0"x ]; then
        cp -f /tmp/user-rules-adbyby.txt $ADBYBY/user.txt
        echo -e "${Info} 规则下载成功" && restart_adbyby
      else
        echo -e "${Error} 规则下载失败" && exit 1
      fi  
}
close_user_rules(){
    echo "0" > $ADBYBY/rule_status.txt
    echo "!" > $ADBYBY/user.txt
}
restore_the_master_server(){
    sed -i '/update.adbyby.com/d' /etc/hosts
    sed -i '/Block adbyby master server/d' /etc/hosts
    /etc/init.d/dnsmasq restart
}    
block_master_server(){    
    if  grep -q "Block adbyby master server" /etc/hosts ; then
       echo ""
    else
       echo "#Block adbyby master server" >> /etc/hosts
       echo "127.0.0.1  update.adbyby.com" >> /etc/hosts
       /etc/init.d/dnsmasq restart
    fi
}
one_key_installation(){
   if  grep -q adbyby /tmp/installed.txt ; then    
      Download_adupdate;auto_adupdate_auto_install;block_master_server;run_adupdate
      echo -e "${Info} 一键安装成功"
   else
      echo -e "${Error} 未安装主程序"
   fi 
}
one_button_removal(){
   if  grep -q adbyby /tmp/installed.txt ; then
      restore_the_master_server;auto_adupdate_auto_uninstall;delete_adupdate
      echo -e "${Info} 一键卸载成功"
   else
      echo -e "${Error} 未安装主程序"
   fi 
}

#####
#Server酱 微信推送
#因为以前写的自己也搞不清了 凑合下好了
wechat_on(){
   echo -e "${Info} 请到 http://sc.ftqq.com 获取SCKEY"
   read -p " 请输入SCKEY：" SCKEY
   echo $SCKEY > $ADBYBY/wechat_sckey
   echo "on" > $ADBYBY/wechat_status
   echo -e "${Info} 已启用微信通知"
}
wechat_off(){
   echo "off" > $ADBYBY/wechat_status
   echo -e "${Info} 已禁用微信通知"
   echo -e "${Info} SCKEY不会自动清除，如需要清除请进入adbyby安装目录后运行命令：rm -f wechat_sckey"
}
#####

#其他功能 
other(){
  echo -e "
————————————"
echo -e "  ${Green_font_prefix}1.${Font_color_suffix} 启用自用规则(会覆盖自定义规则文件)
  ${Green_font_prefix}2.${Font_color_suffix} 禁用自用规则(会覆盖自定义规则文件)  
  ${Green_font_prefix}3.${Font_color_suffix} 启用微信通知
  ${Green_font_prefix}4.${Font_color_suffix} 禁用微信通知 (默认)
————————————
  ${Green_font_prefix}5.${Font_color_suffix} 重启ADBYBY进程
  ${Green_font_prefix}6.${Font_color_suffix} 停止ADBYBY进程
  ${Green_font_prefix}7.${Font_color_suffix} 重启crontab进程
————————————   
  ${Green_font_prefix}8.${Font_color_suffix} 查看当前规则时间
———————————— 
  ${Green_font_prefix}9.${Font_color_suffix} 升级一键管理脚本脚本
 ${Green_font_prefix}10.${Font_color_suffix} 升级规则辅助更新脚本 
 ${Green_font_prefix}11.${Font_color_suffix} 退出
————————————"
    read -p " 现在选择顶部选项 [1-9]: " input
    case $input in 
	 1) user_rules;;
     2) close_user_rules;;
     3) wechat_on;;
     4) wechat_off;;
     5) restart_adbyby;;
     6) stop_adbyby;;
     7) restart_crontab;;
     8) cat_time;;
     9) Update_all_install;;
     10) Update_adupdate ;;    
	 11) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-9]" && exit 1;;
    esac 
}
#主菜单
 echo -e "
  ADBYBY一键管理脚本  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  适用于pandorabox openwrt LEDE 固件 
————————————
  ${Green_font_prefix}1.${Font_color_suffix} 安装LCUI_ADBYBY程序
  ${Green_font_prefix}2.${Font_color_suffix} 卸载LCUI_ADBYBY程序
————————————
  ${Green_font_prefix}3.${Font_color_suffix} 添加自动更新规则功能
  ${Green_font_prefix}4.${Font_color_suffix} 移除自动更新规则功能
————————————
  ${Green_font_prefix}5.${Font_color_suffix} 次要功能
  ${Green_font_prefix}6.${Font_color_suffix} 退出
————————————"
  echo && read -p "现在选择顶部选项 [1-6]: " input
case $input in 
	1) adbyby_install;;
	2) adbyby_uninstall;;
	3) one_key_installation;;
	4) one_button_removal;;
	5) other;;
	6) exit 0	;;
	*) echo -e "${Error} 请输入正确的数字 [1-6]" && exit 1;;
esac

