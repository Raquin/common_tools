#!/bin/bash
#ip=`ifconfig|grep -v 127.0.0.1 | sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p'`
ip=`ifconfig -a | grep inet  | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | tr -d "addr:"`
echo "即将安装RabbitMQ服务，你确定要安装吗?"
echo "yes: 确定安装"
echo "no: 退出安装"
read -p "你的选择是 (yes or no): " Choice
case $Choice in
	yes ) 
		read -p "请输入你要创建的管理员: " username
		read -p "请输入管理员密码: " passwd
		read -p "是否启用RabbitMQ Web UI 插件: (yes or no)" Choice
		echo "你选择安装，请等待......"
		for soft_name in esl-erlang-19.0-1.x86_64.rpm rabbitmq-server-3.6.5-1.noarch.rpm; do
			wget -P /tmp http://tools.yeshj.com/$soft_name
			rpm -ivh $soft_name --force --nodeps
			/etc/init.d/rabbitmq-server start
			rm -rf /tmp/$soft_name
		done
		if [[ "$Choice" = "yes" ]]; then
			rabbitmq-plugins enable rabbitmq_management
			rabbitmqctl add_user ${username} ${passwd}
			rabbitmqctl set_user_tags $username administrator
			rabbitmqctl set_permissions -p / $username ".*" ".*" ".*"
			/etc/init.d/rabbitmq-server restart
			echo -e "你创建的管理员为：$username\n管理员密码：$passwd\n访问地址 http://$ip:15672"
		else
			echo "RabbitMQ插件未启用，不能添加管理员，请手动添加"
		fi
		;;
	no )
		echo "你选择退出安装，已退出"
		;;
	*)
		echo "你选择错误，已退出"
		;;
esac
#rpm -ivh esl-erlang-19.0-1.x86_64.rpm --force --nodeps



#for soft_name in esl-erlang-19.0-1.x86_64.rpm rabbitmq-server-3.6.5-1.noarch.rpm; do wget -P /tmp http://tools.yeshj.com/$soft_name;rpm -ivh /tmp/$soft_name --force --nodeps;done
