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
		wget http://tools.yeshj.com/pcre-8.36.tar.gz
		wget http://tools.yeshj.com/libunwind-1.1.tar.gz
		wget http://tools.yeshj.com/gperftools-2.3.tar.gz
		wget http://tools.yeshj.com/ngx_openresty-1.9.3.1.tar.gz
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
		else
			exit 1
		fi
	}
	if [[ $Installpage = "nginx" ]]; then
		install
		rm -rf  $cd_dir/gperftools-2.*  $cd_dir/libunwind-1.*  $cd_dir/ngx_openresty-1.9.*  $cd_dir/pcre-8.* $cd_dir/waf2.tar.gz
	else
		echo "Input Name Not In Installpage"
	fi
