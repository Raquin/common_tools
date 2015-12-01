#!/bin/bash
#Install Server
#Release: 1.0
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH
cd_dir="$(pwd)"
base_dir=/opt
read -p "Please Input nginx:" Installpage
function install ()
	{
		# Install Tengine
		cd $cd_dir
		wget http://mail.yeshj.com:8021/pcre-8.36.tar.gz
		wget http://mail.yeshj.com:8021/libunwind-1.1.tar.gz
		wget http://mail.yeshj.com:8021/gperftools-2.3.tar.gz
		wget http://mail.yeshj.com:8021/ngx_openresty-1.9.3.1.tar.gz
		for pages in "gcc gcc-c++ make autoconf libtool-ltdl-devel openssh-clients  freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel bison patch unzip libmcrypt-devel libmhash-devel ncurses-devel sudo bzip2 mlocate flex lrzsz sysstat lsof setuptool system-config-network-tui system-config-firewall-tui ntp libaio-devel wget ntp vim openssh-clients glibc.i686 perl-devel perl-ExtUtils-Embed lua lua-static lua-devel"
		do
			yum -y install $pages
		done
		if [ -s pcre-8.36.tar.gz ];then
			tar xf pcre-8.36.tar.gz -C /opt/
		else
			echo "the pcre-8.36.tar.gz not found"
		fi
		cd $cd_dir
		if [ -s libunwind-1.1.tar.gz ];then
			tar xf libunwind-1.1.tar.gz
			cd libunwind-1.1
			CFLAGS=-fPIC ./configure
			make CFLAGS=-fPIC
			make CFLAGS=-fPIC ./configure install
		else
			echo "The libunwind-1.1.tar.gz not found"
		fi
		cd $cd_dir
		if [ -s gperftools-2.3.tar.gz ];then
			tar xf gperftools-2.3.tar.gz
			cd gperftools-2.3
			./configure
			make && make install
			echo '/usr/local/lib' > /etc/ld.so.conf.d/usr_local_lib.conf
		else
			echo "The gperftools-2.3.tar.gz not found"
		fi
		cd $cd_dir
		if [ -s ngx_openresty-1.9.3.1.tar.gz ];then
			tar xf ngx_openresty-1.9.3.1.tar.gz
			cd ngx_openresty-1.9.3.1
			./configure --user=nobody \
			--group=nobody \
			--prefix=/opt/openresty \
			--with-google_perftools_module \
			--with-http_stub_status_module \
			--with-google_perftools_module \
			--with-pcre-jit \
			--with-pcre=/opt/pcre-8.36 \
			--with-http_ssl_module \
			--with-http_addition_module \
			--with-http_gzip_static_module
			gmake
			gmake install
		else
			echo "The ngx_openresty-1.9.3.1.tar.gz not found"
		fi
		for so in `ldd $(which /opt/openresty/nginx/sbin/nginx) | grep "not found" | cut -d " " -f 1`
		do
			for joint in `find / -name $so`
			do
				/bin/ln -s $joint /lib64/$so
				/sbin/ldconfig
			done
		done
		for so1 in `ldd $(which /opt/openresty/nginx/sbin/nginx) | grep "not found" | cut -d " " -f 1`
		do
			for joint in `find / -name $so1`
			do
				/bin/ln -s $joint1 /lib64/$so1
				/sbin/ldconfig
			done
		done
		cd $cd_dir
		> /opt/openresty/nginx/conf/nginx.conf
		if [ ! -d /opt/openresty/nginx/conf/conf ];then
			mkdir -p /opt/openresty/nginx/conf/conf
			if [ -s waf2.tar.gz ];then
				tar xf waf2.tar.gz -C /opt/openresty/nginx/conf
				cat > /opt/openresty/nginx/conf/nginx.conf << EOF
					user nobody;
					worker_processes  8;
					pid /opt/openresty/nginx/logs/nginx.pid;
					error_log /opt/openresty/nginx/logs/error.log error;
					worker_rlimit_nofile 65535;
					events {
						use epoll;
						worker_connections  65535;
					}
					http {
						include       mime.types;
						default_type  text/html;
						log_format  custom_log '$time_local $http_x_forwarded_for $remote_addr $server_addr $status $body_bytes_sent $request_time $request_method $scheme://$host$uri $query_string $http_cookie $http_referer $http_user_agent';
						server_names_hash_bucket_size 256;
						client_header_buffer_size     32k;
						large_client_header_buffers   4 128k;
						client_max_body_size          8m;
						client_body_buffer_size       64k;
						proxy_connect_timeout         600;
						proxy_read_timeout            600;
						proxy_send_timeout            600;
						proxy_buffer_size             32k;
						proxy_buffers                 4 32k;
						proxy_busy_buffers_size       64k;
						proxy_temp_file_write_size    1024m;
						proxy_ignore_client_abort     on;
						sendfile           on;
						tcp_nopush         on;
						keepalive_timeout  0;
						tcp_nodelay        on;
						gzip               off;
						gzip_min_length    1k;
						gzip_buffers       4 16k;
						gzip_http_version  1.0;
						gzip_proxied       any;
						gzip_comp_level    2;
						gzip_types         text/plain application/x-javascript text/css application/xml;
						gzip_vary          on;
						lua_package_path "/opt/openresty/nginx/conf/waf2/?.lua;;";
						init_by_lua_file  /opt/openresty/nginx/conf/waf2/init.lua;
						ignore_invalid_headers off;
						lua_shared_dict xss 1m;
						lua_shared_dict sql 1m;
						lua_shared_dict url 1m;
						lua_shared_dict ua 10m;
						lua_shared_dict ban 10m;
						lua_shared_dict count 10m;
						lua_need_request_body on;
						lua_shared_dict protected_urls 10m;
						lua_shared_dict whitelist_urls 10m;
						include	conf/*.hujiang.com;
					}
				}
EOF
			else
				exit 1
			fi
		else
			exit 1
		fi
		#ln -s /opt/openresty/nginx/conf/waf2/libinjection.so /opt/openresty/lualib/
	}
	if [[ $Installpage = "nginx" ]]; then
		install
		rm -rf  $cd_dir/gperftools-2.*  $cd_dir/libunwind-1.*  $cd_dir/ngx_openresty-1.9.*  $cd_dir/pcre-8.* $cd_dir/waf2.tar.gz
	else
		echo "Input Name Not In Installpage"
	fi
