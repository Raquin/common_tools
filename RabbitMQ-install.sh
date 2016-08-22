#!/bin/bash
#Install RabbitMQ Server
cd_dir="$(pwd)"
function Install_RabbitMQ_Base_Plugins ()
	{
		cd $cd_dir
		wget http://tools.yeshj.com/epel-release-6-8.noarch.rpm
		wget http://tools.yeshj.com/rabbitmq-server-3.5.2-1.noarch.rpm
		wget http://tools.yeshj.com/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
		if [[ -s epel-release-6-8.noarch.rpm ]]; then
			rpm -ivh epel-release-6-8.noarch.rpm
			if [[ -s rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ]]; then
				rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
			else
				echo "rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm not found"
				exit 1
			fi
		else
			echo "epel-release-6-8.noarch.rpm not found"
			exit 1
		fi
	}
function Install_Erlang ()
	{
		yum -y install erlang 
	}
function Install_RabbitMQ ()
	{
		if [[ -s rabbitmq-server-3.5.2-1.noarch.rpm ]]; then
			rpm -ivh rabbitmq-server-3.5.2-1.noarch.rpm
		else
			echo "rabbitmq-server-3.5.2-1.noarch.rpm not found"
			exit 1
		fi
	}
function enaled_rabbitmq_plugins_management ()
	{
		/etc/init.d/rabbitmq-server start
		rabbitmq-plugins enable rabbitmq_management
		/etc/init.d/rabbitmq-server restart
		rabbitmq_port=`netstat -tpln | grep 5672 | wc -l`
		if [[ $rabbitmq_port -eq 1 ]]; then
			echo "RabbitMQ Server Running"
		fi
	}
function add_user_rabbitmq ()
	{
	rabbitmqctl add_user admin admin
	rabbitmqctl set_user_tags admin administrator
	rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
	}
read -p "Please Input rabbitmq:" Installpage
read -p "是否启用RabbitMQ插件:" enable
read -p "是否启用RabbitMQ集群模式:" enabled 
if [[ $Installpage = "rabbitmq" ]]; then
		Install_RabbitMQ_Base_Plugins
		if [[ $? -eq 0 ]]; then
			Install_Erlang
			if [[ $? -eq 0 ]]; then
				Install_RabbitMQ
					if [[ $? -eq 0 ]]; then
						echo "Install Install_RabbitMQ_Base_Plugins Install_Erlang Install_RabbitMQ Success"
						rm -rf $cd_dir/*.rpm
						add_user_rabbitmq
						if [[ $enable = "yes" ]]; then
							enaled_rabbitmq_plugins_management
						else
							echo "RabbitMQ 没有启用，请手动启用"
						fi
						if [[ $enabled = "yes" ]]; then
							if [[ -d /etc/rabbitmq ]]; then
								if [[ -f /etc/rabbitmq/rabbitmq.config ]]; then
									cat > /etc/rabbitmq/rabbitmq.config << EOF
										[
										{rabbit,[{cluster_nodes,['rabbit@node1','rabbit@node2','rabbit@node3']}]}
										].
EOF
								else
									touch /etc/rabbitmq/rabbitmq.config
									cat > /etc/rabbitmq/rabbitmq.config << EOF
																				[
										{rabbit,[{cluster_nodes,['rabbit@node1','rabbit@node2','rabbit@node3']}]}
										].
EOF
								fi
							else
								mkdir /etc/rabbitmq/
								touch /etc/rabbitmq/rabbitmq.config
																	cat > /etc/rabbitmq/rabbitmq.config << EOF
																				[
										{rabbit,[{cluster_nodes,['rabbit@node1','rabbit@node2','rabbit@node3']}]}
										].
EOF
							fi
						fi
					else
						echo "Install Install_RabbitMQ_Base_Plugins Install_Erlang Install_RabbitMQ Failured"
					fi
			else
				echo "Install Install_Erlang Failured"
				exit 1
			fi
		else
			echo "Install Install_RabbitMQ_Base_Plugins Failured"
			exit 1
		fi
else
		echo "Input Name Not In Installpage List"
fi