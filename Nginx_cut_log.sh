#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
log_path=/home/log
move_log_path=/home/log/log_backup
nginx_pid=/opt/openresty/nginx/logs/nginx.pid
Date=`date +%Y-%m-%d -d '-1 days'`
Date_y=`date +%Y`
Date_m=`date +%m`
for name_log in hujiang hjenglish yeshj; do
    for name in `find $log_path -type f -name "*.log" -print | cut -d "/" -f 4 | grep $name_log`;do
        if  [ -d $move_log_path/$Date_y ];then
            if [ -d $move_log_path/$Date_y/$Date_m ];then
                mv $log_path/$name  $move_log_path/$Date_y/$Date_m/$Date.$name
                kill -USR1 `cat $nginx_pid`
                sleep 2
                /opt/openresty/nginx/sbin/nginx -s reload
            else
                mkdir -p $move_log_path/$Date_y/$Date_m
                mv $log_path/$name  $move_log_path/$Date_y/$Date_m/$Date.$name
                kill -USR1 `cat $nginx_pid`
                sleep 2
                /opt/openresty/nginx/sbin/nginx -s reload
            fi
        else
            mkdir -p $move_log_path/$Date_y
            if [ -d $move_log_path/$Date_y/$Date_m ];then
                mv $log_path/$name  $move_log_path/$Date_y/$Date_m/$Date.$name
            else
                mkdir -p $move_log_path/$Date_y/$Date_m
                mv $log_path/$name  $move_log_path/$Date_y/$Date_m/$Date.$name
                kill -USR1 `cat $nginx_pid`
                sleep 2
                /opt/openresty/nginx/sbin/nginx -s reload
            fi
        fi
    done
done