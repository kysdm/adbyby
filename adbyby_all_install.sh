#!/bin/sh
#kysdm(gxk7231@gmail.com)
export ADBYBY=/usr/share/adbyby
export config=/etc/config
crontab=/etc/crontabs/root
cron=/etc/config/cron
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
luci="http://code.taobao.org/svn/luci-app-adbyby" 
kysdm_github="https://raw.githubusercontent.com/kysdm/adbyby" 
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

opkg list-installed | awk -F' ' '{print $1}' > /tmp/installed.txt

sh_ver="1.2.0"

Download_adupdate(){
    wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh $kysdm_github/master/adupdate.sh
     if [ "$?" == "0" ]; then
      chmod 777 $ADBYBY/adupdate.sh
      echo -e "${Info} 下载成功"  
     else
      echo -e "${Error} 下载失败" 
      exit 1
     fi  
}
Update_all_install(){
    echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
    wget -t3 -T10 --no-check-certificate -q -O /tmp/adbyby_all_install.sh $kysdm_github/master/adbyby_all_install.sh
	sh_new_ver=$(grep 'sh_ver="' /tmp/adbyby_all_install.sh |awk -F "=" '{print $NF}'| sed 's/\"//g' | sed -n '1p')
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
        case $yn in 
         y|Y) 
         cp -f /tmp/adbyby_all_install.sh $ADBYBY/adbyby_all_install.sh
         chmod 777 $ADBYBY/adbyby_all_install.sh
         rm -f /tmp/adbyby_all_install.sh
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
    wget -t3 -T10 --no-check-certificate -q -O /tmp/adupdate.sh $kysdm_github/master/adupdate.sh
	sh_new_ver=$(grep 'sh_ver="' /tmp/adupdate.sh | awk -F "=" '{print $NF}' | sed 's/\"//g' | sed -n '1p' )
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
        case $yn in 
         y|Y) 
         cp -f /tmp/adupdate.sh $ADBYBY/adupdate.sh
         chmod 777 $ADBYBY/adupdate.sh
         rm -f /tmp/adupdate.sh
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
 	rm -f $ADBYBY/adupdate.sh
    rm -f $ADBYBY/create_jd.txt
 	echo -e "${Info} 删除成功"
}
run_adupdate(){
    sh $ADBYBY/adupdate.sh
}
restart_adbyby(){
    /etc/init.d/adbyby restart 2>&1
    echo -e "${Info} 重启完成"
}
restart_crontab(){
    /etc/init.d/cron restart 2>&1
    echo -e "${Info} 重启完成"
}
check_adupdate_log(){
    cat /tmp/log/adupdate.log
}
stop_adbyby(){
    /etc/init.d/adbyby stop
    echo -e "${Info} 停止成功"
}
auto_adupdate_install(){
	echo && echo -e "
—————自动判断 测试功能
 ${Green_font_prefix}1.${Font_color_suffix} 自动判断当前固件，并自动添加自动更新规则功能  
—————未安装规则辅助更新脚本
 ${Green_font_prefix}2.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
—————已安装规则辅助更新脚本
 ${Green_font_prefix}3.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为可视化操控界面(新版pandorabox固件)
 ${Green_font_prefix}4.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
 ${Green_font_prefix}5.${Font_color_suffix} 添加自动更新规则功能，web计划任务界面为可视化操控界面(非新版pandorabox固件)
————————————
 ${Green_font_prefix}6.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}7.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-6]: " input
    case $input in 
     1) auto_adupdate_auto_install;;
	 2) auto_adupdate4_install;;
	 3) auto_adupdate1_install;;
	 4) auto_adupdate2_install;;
     5) auto_adupdate3_install;;
	 6) restart_crontab;;
	 7) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-6]" && exit 1;;
    esac
}
auto_adupdate_auto_install(){
    if [ ! -e "$cron" ]; then
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
    sed -i '/adbyby/d' $crontab  #防止有两条相同计划任务在系统中
	if  grep -q adupdate $cron ; then
	   plan_the_task_line=$(grep -n "$ADBYBY/adupdate.sh" $cron  | awk '{print $1}' | sed 's/://g')
	   rod=`expr $plan_the_task_line - 4`
	   sed -i "$rod,+4d" $cron
       echo "" >> $cron
       echo "config task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	 else
	   echo "" >> $cron
       echo "config task" >> $cron
       echo "	option enabled '1'" >> $cron
       echo "	option task_name 'adbyby规则更新'" >> $cron
       echo "	option custom '1'" >> $cron
       echo "	option custom_cron_table '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
       /etc/init.d/cron restart
       echo -e "${Info} 写入完成";
	fi 
}
auto_adupdate2_install(){
	sed -i '/adbyby/d' $crontab
    echo '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1' >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 写入完成"
}
auto_adupdate3_install(){
    echo -e "${Error} 因没有对应固件无法做支持"
    echo -e "${Info} 请手动添加计划任务到系统中，cron原生参数如下"
	echo -e "${Info} '0 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'"
}
auto_adupdate4_install(){
	sed -i '/adbyby/d' $crontab
    echo '0 */6 * * * /etc/init.d/adbyby restart 2>&1' >> $crontab
    /etc/init.d/cron restart 
    echo -e "${Info} 写入完成"
}
auto_adupdate_uninstall(){
	echo && echo -e "
—————自动判断 测试功能
 ${Green_font_prefix}1.${Font_color_suffix} 自动判断当前固件，并自动移除自动更新规则功能   
—————未安装规则辅助更新脚本启用自动更新规则功能的
 ${Green_font_prefix}2.${Font_color_suffix} 移除自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
—————已安装规则辅助更新脚本启用自动更新规则功能的
 ${Green_font_prefix}3.${Font_color_suffix} 移除自动更新规则功能，web计划任务界面为可视化操控界面(新版pandorabox固件)
 ${Green_font_prefix}4.${Font_color_suffix} 移除自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)
 ${Green_font_prefix}5.${Font_color_suffix} 移除自动更新规则功能，web计划任务界面为可视化操控界面(非新版pandorabox固件)
————————————
 ${Green_font_prefix}6.${Font_color_suffix} 重启crontab进程
 ${Green_font_prefix}7.${Font_color_suffix} 退出
———————————— 
 $Tip 仅限删除本脚本添加的计划任务 " && echo
    read -p " 现在选择顶部选项 [1-7]: " input
    case $input in 
	 1) auto_adupdate_auto_uninstall;;    
	 2) auto_adupdate2_uninstall;;
	 3) auto_adupdate1_uninstall;;
	 4) auto_adupdate2_uninstall;;
     5) auto_adupdate3_uninstall;;
	 6) restart_crontab;;
	 7) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-7]" && exit 1;;
    esac
}
auto_adupdate_auto_uninstall(){                                
 if [ ! -e "$cron" ]; then
  if  grep -q pandorabox /etc/banner ; then
      auto_adupdate1_uninstall
      sed -i '/adbyby/d' $crontab
      /etc/init.d/cron restart
  else
     echo -e "${Error} 不支持当前固件，请手动删除计划任务"    
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
auto_adupdate3_uninstall(){
    echo -e "${Error} 因没有对应固件无法做支持"
    echo -e "${Info} 请手动删除添加的计划任务"
}
adbyby_install(){
    echo && echo -e "
————————————
  ${Green_font_prefix}1.${Font_color_suffix} 安装ar71xx版
  ${Green_font_prefix}2.${Font_color_suffix} 安装arm版
  ${Green_font_prefix}3.${Font_color_suffix} 安装armv7版
  ${Green_font_prefix}4.${Font_color_suffix} 安装7620A（N)和7621 pandorabox专用版
  ${Green_font_prefix}5.${Font_color_suffix} 安装7620A（N)和7621 OPENWRT官版专用版
  ${Green_font_prefix}6.${Font_color_suffix} 安装最新 pandorabox专用版(2016.10之后的固件)
  ${Green_font_prefix}7.${Font_color_suffix} 安装7620A（N)和7621 pandorabox小闪存专用版(每次开机时下载主程序到内存中运行)
  ${Green_font_prefix}8.${Font_color_suffix} 安装最新 pandorabox小闪存专用版(2016.10之后的固件)(每次开机时下载主程序到内存中运行)
  ${Green_font_prefix}9.${Font_color_suffix} 安装X86版
 ${Green_font_prefix}10.${Font_color_suffix} 安装X64版
 ${Green_font_prefix}11.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-11]: " input
    case $input in 
	 1) ar71xx;;
	 2) arm;;
	 3) armv7;;
     4) pandorabox_dedicated;;
	 5) OPENWRT_dedicated;;
     6) pandorabox_dedicated_new;;
     7) pandorabox_dedicated_small;;
     8) pandorabox_dedicated_small_new;;
     9) x86;;
     10) x64;;
	 11) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-11]" && exit 1;;
    esac
}
ar71xx(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_ar71xx.ipk
}
arm(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_arm.ipk
}
armv7(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_armv7.ipk
}
pandorabox_dedicated(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_ralink.ipk
}
OPENWRT_dedicated(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_ramips_24kec.ipk
}
pandorabox_dedicated_new(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_mipsel_24kec_dsp.ipk
}
pandorabox_dedicated_small(){
    opkg update
    opkg install $luci/adbyby_mini_2.7-7.0_ralink.ipk
}
pandorabox_dedicated_small_new(){
    opkg update
    opkg install $luci/adbyby_mini_2.7-7.0_mipsel_24kec_dsp.ipk
}
x86(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_x86.ipk 
}
x64(){
    opkg update
    opkg install $luci/adbyby_2.7-7.0_x64.ipk
}
adbyby_uninstall(){
   if  grep -q adbyby /tmp/installed.txt ; then
     opkg remove adbyby
     echo -e "${Info} 卸载成功"
   else
     echo -e "${Error} 未安装ADBYBY"
   fi 
}
#其他功能 
other(){
       echo && echo -e "
————————————
  ${Tip} 需要有足够的空间,8M闪存的可以放弃了
  ${Green_font_prefix}1.${Font_color_suffix} 只获取GitHub上的规则
  ${Green_font_prefix}2.${Font_color_suffix} 同时获取主服务器和GitHub规则(如成功获取直接使用主服务器规则.则忽略GitHub上的规则)
————————————
  ${Green_font_prefix}3.${Font_color_suffix} 查看当前lazy规则时间
  ${Green_font_prefix}4.${Font_color_suffix} 查看当前video规则时间
———————————— 
  ${Green_font_prefix}5.${Font_color_suffix} 退出
————————————" && echo
    read -p " 现在选择顶部选项 [1-5]: " input
    case $input in 
	 1) kill_rule_server;;
	 2) re_rule_server;;
     3) cat_lazy;;
	 4) cat_video;;
	 5) exit 0	;;
	 *) echo -e "${Error} 请输入正确的数字 [1-5]" && exit 1;;
    esac 
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
    sed -i 's/none/video,lazya/g' $ADBYBY/adhook.ini
    echo "NO" > $ADBYBY/create_jd.txt
    chattr -i $ADBYBY/data/lazy.txt
    chattr -i $ADBYBY/data/video.txt
		read -p "是否移除chattr插件(默认: n):" yn
		[[ -z "${yn}" ]] && yn="n"
        case $yn in 
         y|Y) 
         opkg remove chattr
         echo -e "${Info} 已移除chattr插件并更改成功" 
         exit 0
         ;;
         n|N)
         echo -e "${Info} 保留chattr插件并更改成功" 
         ;;
        esac 
}
cat_lazy(){
    lazy_time=$(sed -n '1p' $ADBYBY/data/lazy.txt | awk -F' ' '{print $3,$4}')
    echo -e "${Info} $lazy_time"
}
cat_video(){
    video_time=$(sed -n '1p' $ADBYBY/data/video.txt | awk -F' ' '{print $3,$4}')
    echo -e "${Info} $video_time"
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
#创建判断文件
if [ ! -e "$ADBYBY/create_jd.txt" ]; then
   touch $ADBYBY/create_jd.txt
   echo "NO" > $ADBYBY/create_jd.txt
fi
#主菜单
 echo -e "
  ADBYBY一键管理脚本  ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  适用于pandorabox openwrt LEDE 固件 
————————————
  ${Green_font_prefix}1.${Font_color_suffix} 安装LCUI_ADBYBY程序
  ${Green_font_prefix}2.${Font_color_suffix} 卸载LCUI_ADBYBY程序
————————————
  ${Green_font_prefix}3.${Font_color_suffix} 下载规则辅助更新脚本
  ${Green_font_prefix}4.${Font_color_suffix} 升级规则辅助更新脚本
  ${Green_font_prefix}5.${Font_color_suffix} 删除规则辅助更新脚本
  ${Green_font_prefix}6.${Font_color_suffix} 运行规则辅助更新脚本
————————————
  ${Green_font_prefix}7.${Font_color_suffix} 添加自动更新规则功能
  ${Green_font_prefix}8.${Font_color_suffix} 删除自动更新规则功能
————————————
  ${Green_font_prefix}9.${Font_color_suffix} 重启ADBYBY主程序
 ${Green_font_prefix}10.${Font_color_suffix} 停止ADBYBY进程
 ${Green_font_prefix}11.${Font_color_suffix} 查看规则辅助更新脚本日志
————————————
 ${Green_font_prefix}12.${Font_color_suffix} 其他功能 
 ${Green_font_prefix}13.${Font_color_suffix} 升级脚本 
 ${Green_font_prefix}14.${Font_color_suffix} 退出菜单
————————————
 $Tip 有BUG请群里私聊我 " && echo
  echo -e " 安装情况如下:" 
  menu_adbyby
  menu_adupdate
  menu_auto_adupdate
  echo && read -p "现在选择顶部选项 [1-14]: " input
case $input in 
	1) adbyby_install;;
	2) adbyby_uninstall;;
	3) Download_adupdate;;
    4) Update_adupdate;;
	5) delete_adupdate;;
	6) run_adupdate;;
	7) auto_adupdate_install;;
	8) auto_adupdate_uninstall;;	
	9) restart_adbyby;;
	10) stop_adbyby;;
	11) check_adupdate_log;;
	12) other;;
	13) Update_all_install;;
	14) exit 0	;;
	*) echo -e "${Error} 请输入正确的数字 [1-14]" && exit 1;;
esac

