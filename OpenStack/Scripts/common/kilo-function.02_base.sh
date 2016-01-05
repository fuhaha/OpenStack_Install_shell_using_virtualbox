# !/bin/bash
# ============================================================================================
# Copyright (c) 2010-2012 OpenStack Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ============================================================================================
# Werite by: Jeon.sungwook 
# Create Date : 2015-06-02
# Update Date : 2015-06-02
#
# OS : CentOS-7-x86_64 1503-01
# OS : Ubuntu 14.04.02
#
# Text : OPENSTACK INSTALLATION GUIDE FOR RED HAT ENTERPRISE LINUX 7, CENTOS 7, AND FEDORA 21  - KILO
# Text : OPENSTACK INSTALLATION GUIDE FOR UBUNTU 14.04  - KILO
#
# This script is to be installed and run on OpenStack Kilo
# 
# Set environment and declare global variables
#
# ============================================================================================
# Chapter : 2. Basic environment
# Node : Guest ALL

source ./kilo-perform-vars.common.sh
source ./kilo-function.00_common.sh

function func_install_apt_fast()
{
	echo [$(hostname)] func_install_apt_fast..............................................................................
	add-apt-repository ppa:saiarcot895/myppa
	apt-get update
	apt-get install apt-fast

	apt-fast -y update && sudo apt-fast upgrade -y
}

##################################################################################################
# Init HOSTS ip address
function func_init_hosts()
{
	echo [$(hostname)] func_init_hosts..............................................................................
	#func_install_apt_fast
	cat << EOF >> /etc/hosts 
# controller
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}               controller
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}               controller1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}               controller2
# network
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK}               network
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1}               network1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2}               network2
# compute
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}               compute
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1}               compute1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2}               compute2
# block1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}               block1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2}               block2
# object1
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}               object1
# object2
${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}               object2
EOF

	cat /etc/hosts
	
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then		
		apt-get update
		# 2015.12.11
		# 아래 문제 발생으로 GRUB 설정 디스크 선택 자동화
		# The GRUB boot loader was previously installed to a disk that is no longer 
		# present, or whose unique identifier has changed for some reason. It is important
		# to make sure that the installed GRUB core image stays in sync with GRUB modules 
		# and grub.cfg. Please check again to make sure that GRUB is written to the 
		# appropriate boot devices.

		# If you're unsure which drive is designated as boot drive by your BIOS, it is 
		# often a good idea to install GRUB to all of them.

		# Note: it is possible to install GRUB to partition boot records as well, and some
		# appropriate partitions are offered here. However, this forces GRUB to use the 
		# blocklist mechanism, which makes it less reliable, and therefore is not 
		# recommended.

		#   1. /dev/sda (17179 MB; VBOX_HARDDISK)
		#   2. - /dev/sda1 (254 MB; /boot)
		#   3. /dev/dm-0 (14751 MB; ubuntu--vg-root)

		# (Enter the items you want to select, separated by spaces.)
		# apt-get -y upgrade
		apt-get -y upgrade <<!
1
!

		apt-get -y autoremove

		apt-get -y install python-dev
		apt-get -y install libyaml-dev
		# apt-get -y install libpython2.7-dev		
		# apt-get -y install python-dev-all
		apt-get -y install python-pip
		# ERROR openstackclient.shell Exception raised ...을 막기위해 추가
		# pip install --upgrade python-openstackclient	
	else
		yum -y update	
		systemctl stop firewalld.service	
		systemctl disable firewalld.service
	fi

}

##################################################################################################
# Install NTP function

function func_install_ntp()
{
	echo [$(hostname)] func_install_ntp..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install ntp
	else
		yum -y install ntp
	fi
} 


function func_configure_ntp_server()
{
	echo [$(hostname)] func_configure_ntp_server..............................................................................
	cp /etc/ntp.conf /etc/ntp.conf.org
	sed -i -e 's/^server/#server/g' /etc/ntp.conf
	#sed -i -e 's/^restrict/#restrict/g' /etc/ntp.conf

	cat << EOF >> /etc/ntp.conf
#My Config
server ${NTP_SERVER1} iburst
server ${NTP_SERVER2} iburst
server ${NTP_SERVER3} iburst

#restrict 127.0.0.1
#restrict ::1

#restrict ${NETWORK_RANGE_MANAGEMENT} netmask 255.255.255.0 nomodify notrap

restrict -4 default kod notrap nomodify
restrict -6 default kod notrap nomodify
EOF


	if [ -f /var/lib/ntp/ntp.conf.dhcp ]; then
	    rm /var/lib/ntp/ntp.conf.dhcp
	fi

} 

function func_configure_ntp_client()
{
	echo [$(hostname)] func_configure_ntp_client..............................................................................
	cp /etc/ntp.conf /etc/ntp.conf.org
	sed -i -e 's/^server/#server/g' /etc/ntp.conf

	cat << EOF >> /etc/ntp.conf
#My Config
server controller iburst

#broadcastclient                 # broadcast client

#restrict ${NETWORK_RANGE_MANAGEMENT} netmask 255.255.255.0 nomodify notrap

EOF

	if [ -f /var/lib/ntp/ntp.conf.dhcp ]; then
	    rm /var/lib/ntp/ntp.conf.dhcp
	fi
} 

function func_start_ntpd_service()
{
	echo [$(hostname)] func_start_ntpd_service..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service ntp restart
		echo "[CONTROLLER]===================================> start ntpd.service"
		while ! service ntp status >/dev/null 2>&1; do :; done
		echo "[CONTROLLER]===================================> start ntpd.service Done!"
	else
		systemctl enable ntpd.service
		systemctl start ntpd.service
		echo "[CONTROLLER]===================================> start ntpd.service"
		while ! systemctl is-active  ntpd.service >/dev/null 2>&1; do :; done
		echo "[CONTROLLER]===================================> start ntpd.service Done!"
	fi	
}

function func_verify_ntp()
{
	echo [$(hostname)] func_verify_ntp..............................................................................
	# Verify operation
	# Run this command on the controller node:
	ntpq -c peers
	# Run this command on the controller node:
	ntpq -c assoc
}

##################################################################################################
# Install OpenStack packages

function func_init_local_repository_for_centos7()
{
	echo [$(hostname)] func_init_local_repository_for_centos7..............................................................................
	# 이부분은 별도 모둘로 분리 필요
	# ======================================================================================================
	# Setting for Using CentOS7 Local Repository
	cd /etc/yum.repos.d
	for i in $(ls *.repo); do mv $i $i.orig; done

	# create "/etc/yum.repos.d/CentOS7.repo" and insert :
	cat << EOF > /etc/yum.repos.d/CentOS7.repo
[base]
name=CentOS-\$releasever - Base
baseurl=http://${IP_BASE_SERVER}/repos/centos/\$releasever/os/\$basearch/
gpgcheck=0
gpgkey=http://${IP_BASE_SERVER}/repos/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-\$releasever - Updates
baseurl=http://${IP_BASE_SERVER}/repos/centos/\$releasever/updates/\$basearch/
gpgcheck=0
gpgkey=http://${IP_BASE_SERVER}/repos/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-\$releasever - Extras
baseurl=http://${IP_BASE_SERVER}/repos/centos/\$releasever/extras/\$basearch/
gpgcheck=0
gpgkey=http://${IP_BASE_SERVER}/repos/centos/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-\$releasever - Plus
baseurl=http://${IP_BASE_SERVER}/repos/centos/\$releasever/centosplus/\$basearch/
gpgcheck=0
gpgkey=http://${IP_BASE_SERVER}/repos/centos/RPM-GPG-KEY-CentOS-7
EOF

	cat << EOF > /etc/yum.repos.d/epel7.repo
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
baseurl=http://${IP_BASE_SERVER}/repos/epel/7/\$basearch/
gpgkey=http://${IP_BASE_SERVER}/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Debug
baseurl=http://${IP_BASE_SERVER}/repos/epel/7/\$basearch/debug/
gpgkey=http://${IP_BASE_SERVER}/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0

[epel-source]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Source
baseurl=http://${IP_BASE_SERVER}/repos/epel/7/SRPMS/
gpgkey=http://${IP_BASE_SERVER}/repos/epel/RPM-GPG-KEY-EPEL-7
failovermethod=priority
enabled=1
gpgcheck=0
EOF

	cat << EOF > /etc/yum.repos.d/openstack-kilo.repo
[openstack-kilo]
name=OpenStack Kilo Repository
baseurl=http://${IP_BASE_SERVER}/repos/openstack-kilo/openstack-kilo/el7/
gpgkey=http://${IP_BASE_SERVER}/repos/openstack-kilo/openstack-kilo/RPM-GPG-KEY-EPEL-7
skip_if_unavailable=0
enabled=1
gpgcheck=0

[openstack-kilo-testing]
name=OpenStack Kilo Testing
baseurl=http://${IP_BASE_SERVER}/repos/openstack-kilo/openstack-kilo-testing/el7/
gpgkey=http://${IP_BASE_SERVER}/repos/openstack-kilo/openstack-kilo-testing/RPM-GPG-KEY-EPEL-7
skip_if_unavailable=0
gpgcheck=0
enabled=1
EOF

	# 검증
	cat /etc/yum.repos.d/CentOS7.repo
	cat /etc/yum.repos.d/epel7.repo
	cat /etc/yum.repos.d/openstack-kilo.repo

	ls -l /etc/yum.repos.d


	# fastestmirror 설정 취소
	yum -y  --disableplugin=fastestmirror update
	sed -i -e "s/^enabled=1/enabled=0/g" /etc/yum/pluginconf.d/fastestmirror.conf 
}

function func_enable_openstack_repository()
{
	echo [$(hostname)] func_enable_openstack_repository..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# 2.6 OpenStack packages	
		# (1) To enable the OpenStack repository
		apt-get -y install ubuntu-cloud-keyring
		echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		  "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
		# (2) To finalize installation
		apt-get -y update && apt-get -y dist-upgrade
	else
		# 2.6 OpenStack packages
		# (1) To configure prerequisites
		# (1-1) On RHEL and CentOS, enable the EPEL repository:
		echo '2.6.1 ===============> yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
		yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
		# (2) To enable the OpenStack repository
		# (2-1) Install the rdo-release-kilo package to enable the RDO repository:		
		echo '2.6.2 ===============> yum -y install  http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm'
		yum -y install  http://rdo.fedorapeople.org/openstack-kilo/rdo-release-kilo.rpm
		# (3) To finalize installation
		yum -y update
		echo '2.6.3 ===============> yum -y install  openstack-selinux'
		yum -y install  openstack-selinux
	fi
}

function func_ubuntu_init_apt_chache_client()
{
	echo [$(hostname)] func_ubuntu_init_apt_chache_client..............................................................................
	# sed -i 's,^deb http://us.,deb http://${IP_BASE_SERVER}:3142/us.,g'  /etc/apt/sources.list
	# sed -i 's,^deb-src http://us.,deb-src http://${IP_BASE_SERVER}:3142/us./,g'  /etc/apt/sources.list

	# sed -i 's,^deb http://security,deb http://${IP_BASE_SERVER}:3142/security,g' /etc/apt/sources.list
	# sed -i 's,^deb-src http://security,deb-src http://${IP_BASE_SERVER}:3142/security,g' /etc/apt/sources.list

	# sed -i 's,^deb http://ubuntu-cloud,deb http://${IP_BASE_SERVER}:3142/ubuntu-cloud,g' /etc/apt/sources.list.d/cloudarchive-kilo.list	
	cat << EOF > /etc/apt/apt.conf.d/01proxy
Acquire::http::Proxy "http:/${IP_BASE_SERVER}:3142";
EOF

	sed -i 's,^#!/bin/sh -e,#!/bin/bash,g'  /etc/rc.local
	sed -i 's,^exit 0,,g' /etc/rc.local
	cat << EOF >> /etc/rc.local
echo "Sleeping 10 seconds..."
sleep 10s
echo "Ready"
. /lib/lsb/init-functions
log_daemon_msg "Configuring APT cache proxy" "(based on ${IP_BASE_SERVER}'s presence...)"
ping -c 1 ${IP_BASE_SERVER} &> /dev/null
if [ $? = "0" ]; then
  echo "Acquire::http::Proxy \"http://${IP_BASE_SERVER}:3142\";" > /etc/apt/apt.conf.d/01proxy
else
  rm /etc/apt/apt.conf.d/01proxy &> /dev/null
fi
log_end_msg 0
exit 0
EOF

}

function func_enable_openstack_repository_using_local()
{
	echo [$(hostname)] func_enable_openstack_repository_using_local..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# 2.6 OpenStack packages	
		# (1) To enable the OpenStack repository
		apt-get -y install ubuntu-cloud-keyring
		echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" \
		  "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list

		func_ubuntu_init_apt_chache_client
		# (2) To finalize installation
		apt-get update && apt-get -y dist-upgrade
		pip install --upgrade python-openstackclient	
	else
		# 2.6 OpenStack packages
		# (1) To configure prerequisites
		# (1-1) On RHEL and CentOS, enable the EPEL repository:
		yum -y install http://${IP_BASE_SERVER}/repos/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
		# (2) To enable the OpenStack repository
		# (2-1) Install the rdo-release-kilo package to enable the RDO repository:		
		yum -y install http://${IP_BASE_SERVER}/repos/openstack-kilo/openstack-kilo/rdo-release-kilo-1.noarch.rpm

		func_init_local_repository_for_centos7

		# (3) To finalize installation
		yum -y update
		echo '2.6.3 ===============> yum -y install  openstack-selinux'
		yum -y install  openstack-selinux
	fi
}

function func_install_utils()
{
	echo [$(hostname)] func_install_utils..............................................................................
	# (1) wget install	
	# (2) crudini install
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install wget
		apt-get -y install crudini
	else
		yum -y install crudini
		yum -y install wget
		yum -y install net-tools
		yum -y install tcpdump
	fi
}


##################################################################################################
# Install MySQL

function func_install_mysql()
{
	echo [$(hostname)] func_install_mysql..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123qwe'
		debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123qwe'
		echo '2.7.1-1 =============> apt-get -y install mariadb-server python-mysqldb'
		apt-get -y install mariadb-server python-mysqldb
	else
		echo '2.7.1-1 =============> yum  -y install mariadb mariadb-server MySQL-python'
		yum  -y install mariadb mariadb-server MySQL-python
	fi
}

function func_configure_mysql()
{
	echo [$(hostname)] func_configure_mysql $1..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		cat << EOF > /etc/mysql/conf.d/mysqld_openstack.cnf
# Openstack MySQL Configuration

[mysqld]
bind-address = $1

default-storage-engine = innodb
innodb_file_per_table
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
character-set-server = utf8
EOF
	else
		if [ ! -f /etc/my.cnf.d/mariadb_openstack.cnf ]; then
		    touch /etc/my.cnf.d/mariadb_openstack.cnf
		fi

		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld bind-address $1
		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld default-storage-engine innodb
		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld innodb_file_per_table
		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld collation-server utf8_general_ci
		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld init-connect  "'SET NAMES utf8'"
		crudini --set /etc/my.cnf.d/mariadb_openstack.cnf mysqld character-set-server utf8	
	fi
}


function func_start_mysql_service()
{
	echo [$(hostname)] func_start_mysql_service..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		echo service mysql restart
		service mysql restart
		sleep 1
		while ! service mysql status >/dev/null 2>&1; do :; done
	else
		systemctl enable mariadb.service
		systemctl start mariadb.service
		while ! systemctl is-active  mariadb.service >/dev/null 2>&1; do :; done
	fi	
}


function func_init_mysql()
{
	echo [$(hostname)] func_init_mysql..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		mysql_secure_installation <<!
123qwe
Y
${DATABASE_ADMIN_PASS}
${DATABASE_ADMIN_PASS}
Y
Y
Y
Y

!

	else	
	# export DATABASE_ADMIN_PASS=pass_for_db

	# Make sure that NOBODY can access the server without a password
	mysql -e "UPDATE mysql.user SET Password = PASSWORD('${DATABASE_ADMIN_PASS}') WHERE User = 'root'"
	# Kill the anonymous users
	mysql -e "DROP USER ''@'localhost'"
	# Because our hostname varies we'll use some Bash magic here.
	mysql -e "DROP USER ''@'$(hostname)'"
	# Kill off the demo database
	mysql -e "DROP DATABASE test"
	# Make our changes take effect
	mysql -e "FLUSH PRIVILEGES"
	# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
	fi
}

##################################################################################################
# Install Rabbitmq

function func_install_rabbitmq()
{
	echo [$(hostname)] func_install_rabbitmq..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install rabbitmq-server
	else
		yum -y install rabbitmq-server
	fi
}


function func_start_rabbitmq_service_for_centos()
{
	echo [$(hostname)] func_start_rabbitmq_service_for_centos..............................................................................
	if [ "$TARGET_OS_UBUNTU" != "1" ];
	then
		systemctl enable rabbitmq-server.service
		systemctl start rabbitmq-server.service
		while ! systemctl is-active rabbitmq-server.service >/dev/null 2>&1; do :; done
	fi
}

function func_configure_rabbitmq()
{
	echo [$(hostname)] func_configure_rabbitmq..............................................................................
	# (2-2) Add the openstack user:
	rabbitmqctl add_user openstack ${RABBIT_PASS}

	# (2-3) Permit configuration, write, and read access for the openstack user:
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"

	cat << EOF > /etc/rabbitmq/rabbitmq.conf
[
{rabbit, [
{tcp_listeners, [{"0.0.0.0",5672}]}
]}
]
EOF
	
	service rabbitmq-server restart

}

	
	


##################################################################################################
# Install Rabbitmq

# function func_open_port_firewall_for_centos()
# {
# 	echo [$(hostname)] func_open_port_firewall_for_centos..............................................................................
# 	if [ "$TARGET_OS_UBUNTU" != "1" ];
# 	then	
# 		# Firewall을 연다.
# 		# HTTP : OpenStack dashboard (Horizon) when it is not configured to use secure access.
# 		firewall-cmd --zone=public --add-port=80/tcp --permanent
# 		# HTTP alternate : OpenStack Object Storage (swift) service.
# 		firewall-cmd --zone=public --add-port=8080/tcp --permanent
# 		# HTTPS : Any OpenStack service that is enabled for SSL, especially secure-access dashboard.
# 		firewall-cmd --zone=public --add-port=443/tcp --permanent
# 		# rsync : OpenStack Object Storage. Required.
# 		firewall-cmd --zone=public --add-port=873/tcp --permanent
# 		# iSCSI target : OpenStack Block Storage. Required.
# 		firewall-cmd --zone=public --add-port=873/tcp --permanent
# 		# iSCSI target	3260 OpenStack Block Storage. Required.
# 		firewall-cmd --zone=public --add-port=3260/tcp --permanent
# 		# MySQL database service	3306	Most OpenStack components.
# 		firewall-cmd --zone=public --add-port=3306/tcp --permanent
# 		# Message Broker (AMQP traffic)	5672	OpenStack Block Storage, Networking, Orchestration, and Compute.
# 		firewall-cmd --zone=public --add-port=5672/tcp --permanent

# 		# Block Storage (cinder)	8776	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=8776/tcp --permanent
# 		# Compute (nova) endpoints	8774	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=8774/tcp --permanent
# 		# Compute API (nova-api)	8773, 8775	
# 		firewall-cmd --zone=public --add-port=8773/tcp --add-port=8775/tcp --permanent
# 		# Compute ports for access to virtual machine consoles	5900-5999	
# 		firewall-cmd --zone=public --add-port=5900-5999/tcp --permanent
# 		# Compute VNC proxy for browsers ( openstack-nova-novncproxy)	6080
# 		firewall-cmd --zone=public --add-port=6080/tcp --permanent
# 		# Compute VNC proxy for traditional VNC clients (openstack-nova-xvpvncproxy)	6081	
# 		firewall-cmd --zone=public --add-port=6081/tcp --permanent
# 		# Proxy port for HTML5 console used by Compute service	6082	
# 		firewall-cmd --zone=public --add-port=6082/tcp --permanent
# 		# Data processing service (sahara) endpoint	8386	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=8386/tcp --permanent
# 		# Identity service (keystone) administrative endpoint	35357	adminurl
# 		firewall-cmd --zone=public --add-port=35357/tcp --permanent
# 		# Identity service public endpoint	5000	publicurl
# 		firewall-cmd --zone=public --add-port=5000/tcp --permanent
# 		# Image service (glance) API	9292	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=9292/tcp --permanent
# 		# Image service registry	9191	
# 		firewall-cmd --zone=public --add-port=9191/tcp --permanent
# 		# Networking (neutron)	9696	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=9696/tcp --permanent
# 		# Object Storage (swift)	6000, 6001, 6002	
# 		firewall-cmd --zone=public --add-port=6000-6002/tcp --permanent
# 		# Orchestration (heat) endpoint	8004	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=8004/tcp --permanent
# 		# Orchestration AWS CloudFormation-compatible API (openstack-heat-api-cfn)	8000	
# 		firewall-cmd --zone=public --add-port=8000/tcp --permanent
# 		# Orchestration AWS CloudWatch-compatible API (openstack-heat-api-cloudwatch)	8003	
# 		firewall-cmd --zone=public --add-port=8003/tcp --permanent
# 		# Telemetry (ceilometer)	8777	publicurl and adminurl
# 		firewall-cmd --zone=public --add-port=8777/tcp --permanent

# 		# 재기동 중복 
# 		# firewall-cmd --reload

# 		firewall-cmd --zone=public --list-ports

# 		systemctl restart firewalld.service
# 		sleep 2
# 		echo "[CONTROLLER]===================================> restart firewalld.service"
# 		while ! systemctl is-active firewalld.service >/dev/null 2>&1; do :; done
# 		echo "[CONTROLLER]===================================> restart firewalld.service Done!"
# 	fi
# }

function func_open_port_firewall_for_centos() 
{
	echo [$(hostname)] func_open_port_firewall_for_centos..............................................................................
}