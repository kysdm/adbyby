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
sh_ver="1.3.8"

Download_adupdate(){
    wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh $kysdm_coding/master/adupdate.sh
     if [ "$?"x == "0"x ]; then
      chmod 777 $ADBYBY/adupdate.sh && echo -e "${Info} 下载成功"
     else
      echo -e "${Error} 下载失败" && exit 1
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
 	rm -f $ADBYBY/adupdate.sh $ADBYBY/create_jd.txt && echo -e "${Info} 删除成功"
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
check_adupdate_log(){
    cat /tmp/log/adupdate.log
}
stop_adbyby(){
    /etc/init.d/adbyby stop && echo -e "${Info} 停止成功"
}
auto_adupdate_install(){
	echo && echo -e "
————————————
 ${Green_font_prefix}1.${Font_color_suffix} 添加自动更新规则功能  
 ${Green_font_prefix}2.${Font_color_suffix} 添加定时清空日志功能
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}4.${Font_color_suffix} 退出
————————————
 $Tip 请先下载更新脚本，否则该功能不生效!!!" && echo
    read -p " 现在选择顶部选项 [1-4]: " input
    case $input in 
     1) auto_adupdate_auto_install;;
     2) add_clearlog;;
	 3) restart_crontab;;
	 4) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-4]" && exit 1;;
    esac
}
auto_adupdate_auto_install(){
    if [ -e "$cron" ]; then
     if  grep -q pandorabox /etc/banner ; then
        auto_adupdate1_install
     else
        auto_adupdate3_install    
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
       echo "	option custom_cron_table '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	 else
       echo -e "\nconfig task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	fi 
}
# auto_adupdate2_install(){
# 	sed -i '/adbyby/d' $crontab
#     echo "" >> $crontab
#     echo -e "\n0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1" >> $crontab
#     /etc/init.d/cron restart 
#     echo -e "${Info} 写入完成"
# }
auto_adupdate3_install(){
    echo -e "${Error} 因没有对应固件无法做支持"
    echo -e "${Info} 请手动添加计划任务到系统中，cron原生参数如下"
	echo -e "${Info} '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'"
    exit 0
}
auto_adupdate4_install(){
	sed -i '/adbyby/d' $crontab
    echo -e "\n0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1" >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 写入完成"
}
add_clearlog(){
    if [ -e "$cron" ]; then
     if  grep -q pandorabox /etc/banner ; then
       	if  grep -q adbyby脚本日志清空 $cron ; then
	        plan_the_task_line=$(grep -n "clear adupdate log" $cron  | awk '{print $1}' | sed 's/://g')
	        rod=`expr $plan_the_task_line - 4`
	        sed -i "$rod,+4d" $cron
            echo -e "\nconfig task" >> $cron
            echo "	option enabled '1'" >> $cron
            echo "	option task_name 'adbyby脚本日志清空'" >> $cron
            echo "	option custom '1'" >> $cron
            echo "	option custom_cron_table '0 1 * * 1 echo "" > /tmp/log/adupdate.log 2>&1 #clear adupdate log'" >> $cron
            /etc/init.d/cron restart
            echo -e "${Info} 写入完成";
	    else
            echo -e "\nconfig task" >> $cron
            echo "	option enabled '1'" >> $cron
            echo "	option task_name 'adbyby脚本日志清空'" >> $cron
            echo "	option custom '1'" >> $cron
            echo "	option custom_cron_table '0 1 * * 1 echo "" > /tmp/log/adupdate.log 2>&1 #clear adupdate log'" >> $cron
            /etc/init.d/cron restart
            echo -e "${Info} 写入完成";
	    fi 
     else
        echo -e "${Error} 因没有对应固件无法做支持"
        echo -e "${Info} 请手动添加计划任务到系统中，cron原生参数如下"
	    echo -e "${Info} '0 1 * * 1 echo "" > /tmp/log/adupdate.log 2>&1'"
        exit 0
     fi
    else
     sed -i '/clear adupdate log/d' $crontab
     echo -e "\n0 1 * * 1 echo "" > /tmp/log/adupdate.log 2>&1 #clear adupdate log" >> $crontab
     /etc/init.d/cron restart
     echo -e "${Info} 写入完成"
    fi  
}
auto_adupdate_uninstall(){
	echo && echo -e "
————————————
 ${Green_font_prefix}1.${Font_color_suffix} 移除自动更新规则功能   
 ${Green_font_prefix}2.${Font_color_suffix} 移除定时清空日志功能
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}4.${Font_color_suffix} 退出
———————————— 
 $Tip 仅限删除本脚本添加的计划任务 " && echo
    read -p " 现在选择顶部选项 [1-4]: " input
    case $input in 
	 1) auto_adupdate_auto_uninstall;;    
	 2) delete_clearlog;;
	 3) restart_crontab;;
	 4) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-4]" && exit 1;;
    esac
}
delete_clearlog(){
 if [ -e "$cron" ]; then
  if  grep -q pandorabox /etc/banner ; then
   if  grep -q adbyby脚本日志清空 $cron ; then
	 plan_the_task_line=$(grep -n "clear adupdate log" $cron  | awk '{print $1}' | sed 's/://g')
	 rod=`expr $plan_the_task_line - 4`
	 sed -i "$rod,+4d" $cron
     sed -i '/clear adupdate log/d' $crontab
	 /etc/init.d/cron restart
     echo -e "${Info} 删除成功";
   else
     echo -e "${Error} 未添加计划任务"
   fi
  else
     echo -e "${Error} 不支持当前固件，请手动删除计划任务"
     exit 0    
  fi
 else
   	sed -i '/clear adupdate log/d' $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 删除成功"
 fi  
}
auto_adupdate_auto_uninstall(){                                
 if [ -e "$cron" ]; then
  if  grep -q pandorabox /etc/banner ; then
      auto_adupdate1_uninstall
      sed -i '/adbyby/d' $crontab
      /etc/init.d/cron restart
  else
     echo -e "${Error} 不支持当前固件，请手动删除计划任务"
     exit 0    
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
    echo -e "${Info} 删除成功"
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
#其他功能 
other(){
  echo -e "
————————————"
echo -e "  ${Green_font_prefix}1.${Font_color_suffix} 以GitHub或Coding服务器上的规则为主
  ${Green_font_prefix}2.${Font_color_suffix} 以adbyby官方服务器为主"
  menu_kill_rule
echo -e "————————————
  ${Green_font_prefix}3.${Font_color_suffix} 重启ADBYBY进程
  ${Green_font_prefix}4.${Font_color_suffix} 停止ADBYBY进程
————————————   
  ${Green_font_prefix}5.${Font_color_suffix} 查看当前规则时间
  ${Green_font_prefix}6.${Font_color_suffix} 查看规则辅助更新脚本日志
———————————— 
  ${Green_font_prefix}7.${Font_color_suffix} 升级一键管理脚本脚本
  ${Green_font_prefix}8.${Font_color_suffix} 升级规则辅助更新脚本 
  ${Green_font_prefix}9.${Font_color_suffix} 退出
————————————"
    read -p " 现在选择顶部选项 [1-9]: " input
    case $input in 
	 1) kill_rule;;
	 2) re_rule_server;;
     3) restart_adbyby;;
     4) stop_adbyby;;
     5) cat_lazy
	    cat_video;;
     6) check_adupdate_log;;
     7) Update_all_install;;
     8) Update_adupdate ;;    
	 9) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-9]" && exit 1;;
    esac 
}
menu_kill_rule(){
    if  grep -q YES $ADBYBY/create_jd.txt ; then
      echo -e "  ${Info} 当前使用GitHub或Coding服务器上的规则"
    else
      echo -e "  ${Info} 当前使用adbyby官方服务器规则"
    fi
}
kill_rule(){
       echo && echo -e "   
———————————— 
  ${Green_font_prefix}1.${Font_color_suffix} 方案一：需要有足够的空间,且系统分区格式要为ext2,3,4，通常硬路由分区都不使用这种格式
  ${Green_font_prefix}2.${Font_color_suffix} 方案二：通过屏蔽adbyby更新域名,连接此路由的所有设备将无法连接官方更新服务器
  ${Green_font_prefix}3.${Font_color_suffix} 退出
————————————" && echo  
    read -p " 现在选择顶部选项 [1-3]: " input
    case $input in 
	 1) kill_rule_server;;
	 2) kill_rule_domain;;
	 3) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-3]" && exit 1;;
    esac 
}
kill_rule_domain(){
    sed -i '/update.adbyby.com/d' /etc/hosts
    echo "0.0.0.0 update.adbyby.com" >> /etc/hosts
    /etc/init.d/dnsmasq restart
    echo "YES2" > $ADBYBY/create_jd.txt
    echo -e "${Info} 更改成功"
}

kill_rule_server(){
    sed -i 's/video,lazya/none/g' $ADBYBY/adhook.ini
    echo "YES" > $ADBYBY/create_jd.txt
     if  grep -q chattr /tmp/installed.txt ; then
       echo -e "${Info} 已安装chattr,继续...";
       chattr +i $ADBYBY/data/lazy.txt
       chattr +i $ADBYBY/data/video.txt
	  else
       echo -e "${Info} 未安装chattr,开始安装..."
       opkg update && opkg install chattr   #可增加判断机制
       chattr +i $ADBYBY/data/lazy.txt
       chattr +i $ADBYBY/data/video.txt
	 fi 
    echo -e "${Info} 更改成功"
}
re_rule_server(){
    sed -i '/update.adbyby.com/d' /etc/hosts
    /etc/init.d/dnsmasq restart
    sed -i 's/none/video,lazya/g' $ADBYBY/adhook.ini
    echo "NO" > $ADBYBY/create_jd.txt
     if  grep -q chattr /tmp/installed.txt ; then
        chattr -i $ADBYBY/data/lazy.txt
        chattr -i $ADBYBY/data/video.txt
        read -p "是否移除chattr插件(默认: n):" yn
	    [[ -z "${yn}" ]] && yn="n"
        case $yn in 
         y|Y) 
         opkg remove chattr e2fsprogs libext2fs
         echo -e "${Info} 已移除chattr插件并更改成功" && exit 0
         ;;
         n|N)
         echo -e "${Info} 保留chattr插件并更改成功" 
         ;;
        esac 
     fi       
    echo -e "${Info} 更改成功" 
}
cat_lazy(){
    lazy_time=$(sed -n '1p' $ADBYBY/data/lazy.txt | awk -F' ' '{print $3,$4}')
    echo -e "lazy : $lazy_time"
}
cat_video(){
    video_time=$(sed -n '1p' $ADBYBY/data/video.txt | awk -F' ' '{print $3,$4}')
    echo -e "video: $video_time"
}
menu_adbyby(){
	 if [ -e $ADBYBY/adbyby ]; then
		pid=`ps |grep -v 'grep\|all' | grep adbyby |awk '{print $1}'`
		if [ ! -z "${pid}" ]; then
			echo -e " [ 已安装adbyby并已启动 ]"
		else
			echo -e " [ 已安装adbyby但未启动 ]"
		fi
	 else
	 	echo -e " [ 未安装adbyby ]"
	 fi
}
menu_adupdate(){
    if [ -e "$ADBYBY/adupdate.sh" ]; then
        echo -e " [ 已下载规则辅助更新脚本 ]"
    else
        echo -e " [ 未下载规则辅助更新脚本 ]"
    fi    
}
menu_auto_adupdate(){
    if [ -e "$cron" ]; then
      if  grep -q "adupdate" "$cron" || grep -q "adupdate" "$crontab"; then
        echo -e " [ 已启用自动更新规则功能 ]"
     else
         echo -e " [ 未启用自动更新规则功能 ]"
      fi 
    else
      if  grep -q "adupdate" "$crontab"; then
         echo -e " [ 已启用自动更新规则功能 ]"  
      else
         echo -e " [ 未启用自动更新规则功能 ]"
      fi  
    fi
}
menu_auto_clearlog(){
    if [ -e "$cron" ]; then
      if  grep -q "adbyby脚本日志清空" "$cron" || grep -q "clear adupdate log" "$crontab"; then
        echo -e " [ 已启用自动清空日志功能 ]"
     else
         echo -e " [ 未启用自动清空日志功能 ]"
      fi 
    else
      if  grep -q "clear adupdate log" "$crontab"; then
         echo -e " [ 已启用自动清空日志功能 ]"  
      else
         echo -e " [ 未启用自动清空日志功能 ]"
      fi  
    fi
}
fool_install(){
   if  grep -q adbyby /tmp/installed.txt ; then
      kill_rule_domain;Download_adupdate;auto_adupdate_auto_install;add_clearlog;run_adupdate
      echo -e "${Info} 一键安装成功"
   else
      echo -e "${Error} 未安装主程序"
   fi 
}
fool_unstall(){
   if  grep -q adbyby /tmp/installed.txt ; then
      re_rule_server;delete_adupdate;auto_adupdate_auto_uninstall;delete_clearlog
      echo -e "${Info} 一键卸载成功"
   else
      echo -e "${Error} 未安装主程序"
   fi 
}
installation_status(){
   echo && echo -e " 安装情况如下:" 
     menu_adbyby
     menu_adupdate
     menu_auto_adupdate
     menu_auto_clearlog
}
if [ ! -x "$ADBYBY/adbyby_all_install.sh" ]; then
  chmod 777 $ADBYBY/adbyby_all_install.sh
fi
if [ ! -e "$ADBYBY/create_jd.txt" ]; then
   touch $ADBYBY/create_jd.txt
   echo "NO" > $ADBYBY/create_jd.txt
fi
 echo -e "
  ADBYBY一键管理脚本  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  适用于pandorabox openwrt LEDE 固件 
————————————
  ${Green_font_prefix}1.${Font_color_suffix} 安装LCUI_ADBYBY程序
  ${Green_font_prefix}2.${Font_color_suffix} 卸载LCUI_ADBYBY程序
————————————
  ${Green_font_prefix}3.${Font_color_suffix} 下载规则辅助更新脚本
  ${Green_font_prefix}4.${Font_color_suffix} 删除规则辅助更新脚本
  ${Green_font_prefix}5.${Font_color_suffix} 运行规则辅助更新脚本
————————————
  ${Green_font_prefix}6.${Font_color_suffix} 添加自动更新规则功能
  ${Green_font_prefix}7.${Font_color_suffix} 删除自动更新规则功能
————————————
  ${Green_font_prefix}8.${Font_color_suffix} 一键傻瓜式安装(主程序不会安装)
  ${Green_font_prefix}9.${Font_color_suffix} 一键傻瓜式卸载(主程序不会卸载)
————————————
 ${Green_font_prefix}10.${Font_color_suffix} 查询当前安装状态 
 ${Green_font_prefix}11.${Font_color_suffix} 次要功能
 ${Green_font_prefix}12.${Font_color_suffix} 退出
————————————
 $Tip 有BUG请群里私聊我,最好屏蔽掉主服务器(次要功能中进行屏蔽) "
  echo && read -p "现在选择顶部选项 [1-12]: " input
case $input in 
	1) adbyby_install;;
	2) adbyby_uninstall;;
	3) Download_adupdate;;
	4) delete_adupdate;;
	5) run_adupdate;;
	6) auto_adupdate_install;;
	7) auto_adupdate_uninstall;;	
    8) fool_install;;
    9) fool_unstall;;
    10) installation_status;;
	11) other;;
	12) exit 0	;;
	*) echo -e "${Error} 请输入正确的数字 [1-12]" && exit 1;;
esac

