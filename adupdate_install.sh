#!/bin/bash
export ADBYBY=/usr/share/adbyby
export config=/etc/config
crontab=/etc/crontabs/root
cron=/etc/config/cron
alias echo_date='echo 【$(date +%Y年%m月%d日\ %X)】:'
until  
        echo "1.下载脚本(大前提!!!)"
        echo "2.添加自动更新规则，web计划任务界面为可视化操控界面(新版pandorabox固件)"  
        echo "3.添加自动更新规则，web计划任务界面为一个框(常见界面需自己手打任务时间)"  
        echo "4.添加自动更新规则，web计划任务界面为可视化操控界面(非新版pandorabox固件)" 
        echo "5.执行一次更新(运行脚本)"		
        echo "6.退出菜单"  
		echo "请输入选择（1-6）" 
        read input  
        test $input = 6
        do  
            case $input in  
			1)  echo "#############################################################################"
      			wget -t3 -T10 --no-check-certificate -O $ADBYBY/adupdate.sh https://raw.githubusercontent.com/kysdm/adbyby/master/adupdate.sh
                chmod 777 $ADBYBY/adupdate.sh
                echo "#############################################################################";;
            2)  echo "#############################################################################"
     			echo  >> $cron
                echo "config task" >> $cron
                echo "	option enabled '1'" >> $cron
                echo "	option task_name 'adbyby规则更新'" >> $cron
                echo "	option custom '1'" >> $cron
                echo "	option custom_cron_table '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1'" >> $cron
            	/etc/init.d/cron restart
				echo "写入完成"
                echo "#############################################################################";;				
            3)  echo "#############################################################################"
			    sed -i '/adupdate.sh/d' $crontab
                echo '30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1' >> $crontab
                /etc/init.d/cron restart 
				echo "写入完成"
                echo "#############################################################################";;
            4)  echo "#############################################################################"
   		        echo 暂不支持自动添加计划任务到当前系统
                echo 请手动添加计划任务到系统中，命令如下
	            echo "30 */6 * * * /usr/share/adbyby/adupdate.sh >> /tmp/log/adupdate.log 2>&1"
				echo "#############################################################################";;				
            5)  echo "#############################################################################"
			    sh $ADBYBY/adupdate.sh
        	    echo "#############################################################################";;	
			6)
            esac  
        done  