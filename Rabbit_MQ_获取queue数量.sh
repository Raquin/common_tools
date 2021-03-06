#!/bin/bash
# Author nanyansi
# Time 2016-08-19
for virtual_host in `rabbitmqctl list_vhosts | grep -v 'Listing queues ...' | grep -v '\/'`
do
    for queue_name in `rabbitmqctl list_queues -p $virtual_host name |grep -v 'Listing queues ...'`
    do
#	for  queue_name_num in `rabbitmqctl list_queues -p $virtual_host | grep $queue_name |grep -v 'Listing queues ...' | awk '{print $2}'`
#	do
#		echo $virtual_host.$queue_name=$queue_name_num
#		queue_sum=$[$queue_sum+$queue_name_num]
#	done
	if [[ $queue_name = "normandy.q" ]];then
		for  queue_name_num in `rabbitmqctl list_queues -p $virtual_host | grep $queue_name | grep -v "message_normandy.q" |awk '{print $2}'`
		do
			echo $virtual_host.$queue_name=$queue_name_num
			queue_sum=$[$queue_sum+$queue_name_num]
		done
	else
		for  queue_name_num in `rabbitmqctl list_queues -p $virtual_host | grep $queue_name  |awk '{print $2}'`
		do
            		echo $virtual_host.$queue_name=$queue_name_num
            		queue_sum=$[$queue_sum+$queue_name_num]
       		done
	fi
    done
done
echo -e "RabbitMQ_Ready=$queue_sum"
