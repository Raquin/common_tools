#!/bin/bash
dir=/opt/openresty/nginx/
dirbin=/opt/openresty/nginx/sbin/
daemon=nginx
config=/opt/openresty/nginx/conf/conf/
echo	"选择更改WAF机房位置:"
echo	"南汇机房:(请使用:nanhui)"
echo	"外高桥机房:(请使用:waigaoqiao)"
read address
case $address in
	nanhui)
		echo "你选择的机房位置是:南汇机房"
		echo "你选择更改WAF服务器的地址:"
		for waflist in 192.168.25.127 192.168.25.172
		do
			echo $waflist
		done
        echo "你要更改的站点如下:"
for weblist in `find $config -type f -name "*.hujiang.com" -print | awk -F \/ '{print $7}'`
do
        echo $weblist
done
echo "输入你要更改的站点名称:"
read site
web=`find $config -type f -name "$site" -print | awk -F \/ '{print $7}'`
if [ "$web" = "$site" ];then
                echo "你要更改的IP如下:"
        for iplist in `cat $config$site | grep ":80" | grep -v grep | awk -F server '{print $1,$2}'`
        do
                echo $iplist
        done
        echo "输入你要更改站点的IP:"
        read addr
        ip=`cat $config$site | grep ":80" | grep -v grep | awk -F server '{print $2}' | awk '{print $1}' | awk -F : '{print $1}'|grep "$addr" | grep -v grep`
        if [ "$ip" = "$addr" ];then
        echo "输入你要操作的方式:上线: online; 下线: offline:"
        read line
                if [ $line = "online" ];then
                        echo "站点 $site 服务器IP $addr 正在更改当中...... "
                        sleep 10
                        sed -i  's/server '$addr':80 down/server '$addr':80/g' $config$site
                        $dirbin$daemon -t
                                if [ $? -eq 0 ];then
                                        $dirbin$daemon -s reload
                                else
                                        echo "站点 $site $config$site 配置文件错误，请检查!"
                                fi
                        echo "站点 $site 服务器IP $addr 已上线"
                elif [ $line = "offline" ];then
                        echo "站点 $site 服务器IP $addr 正在更改当中...... "
                        sleep 10
                        sed -i 's/server '$addr':80/server '$addr':80 down/g' $config$site
                        $dirbin$daemon -t
                                if [ $? -eq 0 ];then
                                        $dirbin$daemon -s reload
                                else
                                        echo "站点 $site $config$site 配置文件错误，请检查!"
                                fi
                        echo "站点 $site 服务器IP $addr 已下线"
                else
                        echo "你的操作方式不正确，请输入 online|offline"
                fi
        else
                echo "你要下线的服务器IP $addr 不在配置当中"
        fi
else
        echo "你输入的站点 $site 不在列表当中......，请检查站点名称是否正确。谢谢！！！"
fi
	;;
	waigaoqiao)
		echo "你选择的机房位置是:外高桥机房"
        echo "你要更改的站点如下:"
for weblist in `find $config -type f -name "*.hujiang.com" -print | awk -F \/ '{print $7}'`
do
        echo $weblist
done
echo "输入你要更改的站点名称:"
read site
web=`find $config -type f -name "$site" -print | awk -F \/ '{print $7}'`
if [ "$web" = "$site" ];then
                echo "你要更改的IP如下:"
        for iplist in `cat $config$site | grep ":80" | grep -v grep | awk -F server '{print $1,$2}'`
        do
                echo $iplist
        done
        echo "输入你要更改站点的IP:"
        read addr
        ip=`cat $config$site | grep ":80" | grep -v grep | awk -F server '{print $2}' | awk '{print $1}' | awk -F : '{print $1}'|grep "$addr" | grep -v grep`
        if [ "$ip" = "$addr" ];then
        echo "输入你要操作的方式:上线: online; 下线: offline:"
        read line
                if [ $line = "online" ];then
                        echo "站点 $site 服务器IP $addr 将要被更改中...... "
                        sleep 10
                        sed -i  's/server '$addr':80 down/server '$addr':80/g' $config$site
                        $dirbin$daemon -t
                                if [ $? -eq 0 ];then
                                        $dirbin$daemon -s reload
                                else
                                        echo "站点 $site $config$site 配置文件错误，请检查!"
                                fi
                        echo "站点 $site 服务器IP $addr 已上线"
                elif [ $line = "offline" ];then
                        echo "站点 $site 服务器IP $addr 将要被更改中...... "
                        sleep 10
                        sed -i 's/server '$addr':80/server '$addr':80 down/g' $config$site
                        $dirbin$daemon -t
                                if [ $? -eq 0 ];then
                                        $dirbin$daemon -s reload
                                else
                                        echo "站点 $site $config$site 配置文件错误，请检查!"
                                fi
                        echo "站点 $site 服务器IP $addr 已下线"
                else
                        echo "你的操作方式不正确，请输入 online|offline"
                fi
        else
                echo "你要下线的服务器IP $addr 不在配置当中"
        fi
else
        echo "你输入的站点 $site 不在列表当中......，请检查站点名称是否正确。谢谢！！！"
fi	
	;;
	*)
		echo "你输入的机房地址不正确;请输入正确的机房位置或名称"
	;;
esac