#!/bin/sh
#kysdm(gxk7231@gmail.com)
export ADBYBY=/usr/share/adbyby
export config=/etc/config
crontab=/etc/crontabs/root
cron=/etc/config/cron
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

sh_ver="1.0.2"

#下载规则辅助更新脚本
Download_adupdate(){
    wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate.sh
    chmod 777 $ADBYBY/adupdate.sh
    echo -e "${Info} 下载成功"   #可增加判断机制
}
#更新规则辅助更新脚本
Update_adupdate(){
    echo -e "${Error} 暂时未完成此功能"
}
#删除规则辅助更新脚本
delete_adupdate(){
 	rm -f $ADBYBY/adupdate.sh
 	echo -e "${Info} 删除成功"
}
#运行脚本,执行一次更新
run_adupdate(){
    sh $ADBYBY/adupdate.sh
}
#重启ADBYBY主程序
restart_adbyby(){
    /etc/init.d/adbyby restart 2>&1
    echo -e "${Info} 重启完成"
}
#重启crontab进程
restart_crontab(){
    /etc/init.d/cron restart 2>&1
    echo -e "${Info} 重启完成"
}
#查看规则辅助更新脚本日志
check_adupdate_log(){
    cat /tmp/log/adupdate.log
}
#停止ADBYBY进程
stop_adbyby(){
    /etc/init.d/adbyby stop
    echo -e "${Info} 停止成功"
}
# # # 计划任务
# # auto_adupdate(){
# #   echo && echo -e"${Tip}未安装规则辅助更新脚本，运行1
# #   ${Green_font_prefix}1.${Font_color_suffix} '添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)'
# #  ————————————
# #   ${Tip}已安装规则辅助更新脚本，运行2-4
# #   ${Green_font_prefix}2.${Font_color_suffix} '添加自动更新规则功能，web计划任务界面为可视化操控界面(新版pandorabox固件)'
# #   ${Green_font_prefix}3.${Font_color_suffix} '添加自动更新规则功能，web计划任务界面为一个框(常见界面需自己手打任务时间)'
# #   ${Green_font_prefix}4.${Font_color_suffix} '添加自动更新规则功能，web计划任务界面为可视化操控界面(非新版pandorabox固件)'
# # ————————————
# #   ${Green_font_prefix}5.${Font_color_suffix} '重启crontab进程' " && echo

# # 	stty erase '^H' && read -p "'(默认: 取消)':" other_num
# # 	[[ -z "${other_num}" ]] && echo "已取消..." && exit 1
# # 	if [[ ${other_num} == "1" ]]; then
# # 		auto_adupdate4
# # 	elif [[ ${other_num} == "2" ]]; then
# # 		auto_adupdate1
# # 	elif [[ ${other_num} == "3" ]]; then
# # 		auto_adupdate2
# #     elif [[ ${other_num} == "4" ]]; then
# # 		auto_adupdate3   
# # 	elif [[ ${other_num} == "5" ]]; then
# # 		restart_crontab
# # 	else
# # 		echo -e "${Error} '请输入正确的数字 [1-4]''" && exit 1
# # 	fi
# # }
# auto_adupdate1(){
#     echo "config task" >> $cron
#     echo "	option enabled '1'" >> $cron
#     echo "	option task_name 'adbyby规则更新'" >> $cron
#     echo "	option custom '1'" >> $cron
#     echo "	option custom_cron_table '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
#     /etc/init.d/cron restart
#     echo -e "${Info} 写入完成"
# }
# auto_adupdate2(){
# 	sed -i '/adbyby/d' $crontab
#     echo '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1' >> $crontab
#     /etc/init.d/cron restart 
#     echo -e "${Info} 写入完成"
# }
# auto_adupdate3(){
#     echo -e "${Error} 因没有对应固件无法做支持"
#     echo -e "${Info} 请手动添加计划任务到系统中，命令如下"
# 	echo -e "${Info} '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'"

# }
# auto_adupdate4(){
# 	sed -i '/adbyby/d' $crontab
#     echo '30 */6 * * * /etc/init.d/adbyby restart 2>&1' >> $crontab
#     /etc/init.d/cron restart 
#     echo  "写入完成"
# }





#主菜单
cat << EOF
 ADBYBY一键管理脚本 [v${sh_ver}]
********请输入您的选择:(1-13)****
 1.安装LCUI_ADBYBY程序  待做
 2.删除LCUI_ADBYBY程序  待做 
————————————
 3.下载规则辅助更新脚本
 4.更新规则辅助更新脚本  待做
 5.删除规则辅助更新脚本
 6.运行规则辅助更新脚本
————————————
 7.添加自动更新规则功能
————————————
 8.重启ADBYBY主程序
 9.停止ADBYBY进程
 10.查看规则辅助更新脚本日志
————————————
 11.其他功能 待做
 12.升级脚本 待做
 13.退出菜单
————————————
EOF
read -p "现在选择顶部选项: " input
case $input in 
	1) echo  "未完成";;
	2) echo  "未完成";;
	3) Download_adupdate;;
    4) Update_adupdate   ;;
	5) delete_adupdate;;
	6) run_adupdate;;
	7) auto_adupdate;;
	8) restart_adbyby;;
	9) stop_adbyby;;
	10) check_adupdate_log	;;
	11) echo  "未完成";;
	12) echo  "未完成";;
	13) exit 0	;;
	*) echo "请输入正确的数字" && exit 1;;
esac