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
# Chapter : 7. Add the dashboard
# Node : Controller

source ./kilo-perform-vars.common.sh

##################################################################################################
# nova controller node
function func_horizon_install_package()
{
	echo [$(hostname)] func_horizon_install_package..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install openstack-dashboard
	else
		yum -y install openstack-dashboard httpd mod_wsgi memcached python-memcached
	fi	
}

function func_horizon_configure()
{
	echo [$(hostname)] func_horizon_configure..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		DASHBOARD_CONFIG_FILE=/etc/openstack-dashboard/local_settings.py
	else
		DASHBOARD_CONFIG_FILE=/etc/openstack-dashboard/local_settings
	fi	

	cp ${DASHBOARD_CONFIG_FILE} ${DASHBOARD_CONFIG_FILE}.org
	# (2) To configure the dashboard
	# (2-1) Edit the /etc/openstack-dashboard/local_settings file and complete the following actions:
	# (2-1-1) Configure the dashboard to use OpenStack services on the controller node:
	# crudini --set /etc/openstack-dashboard/local_settings '' OPENSTACK_HOST '"controller"'
	sed -i -e "s,^OPENSTACK_HOST =.*,OPENSTACK_HOST = \"controller\"," ${DASHBOARD_CONFIG_FILE}

	# (2-1-2) Allow all hosts to access the dashboard:
	#crudini --set /etc/openstack-dashboard/local_settings '' ALLOWED_HOSTS "'*'"
	sed -i -e "s,^ALLOWED_HOSTS = .*,ALLOWED_HOSTS = '\*'," ${DASHBOARD_CONFIG_FILE}

	# (2-1-3) Configure the memcached session storage service:
	#crudini --set /etc/openstack-dashboard/local_settings '' CACHES "{ 'default': {  'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache', 'LOCATION': '127.0.0.1:11211', } }"
	if [ "$TARGET_OS_UBUNTU" != "1" ];
	then
		sed -i -e "s,locmem.LocMemCache'.*,memcached.MemcachedCache'\,\n\t'LOCATION' : '127.0.0.1:11211'\,," ${DASHBOARD_CONFIG_FILE}
	fi
	# (2-1-4) Configure user as the default role for users that you create via the dashboard:
	# crudini --set /etc/openstack-dashboard/local_settings '' OPENSTACK_KEYSTONE_DEFAULT_ROLE '"user"'
	sed -i -e "s,^OPENSTACK_KEYSTONE_DEFAULT_ROLE = .*,OPENSTACK_KEYSTONE_DEFAULT_ROLE = \"user\"," ${DASHBOARD_CONFIG_FILE}

	# (2-1-5) Optionally, configure the time zone:
	# crudini --set /etc/openstack-dashboard/local_settings '' TIME_ZONE '"${TIME_ZONE}"'
	sed -i -e "s,^TIME_ZONE = .*,TIME_ZONE = \"${TIME_ZONE}\"," /${DASHBOARD_CONFIG_FILE}


}


function func_horizon_finalize_installation()
{
	echo [$(hostname)] func_horizon_finalize_installation..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (3) To finalize installation
		# (3-1) Reload the web server configuration:

		# service apache2 restart
		# sleep 1
		# echo "[CONTROLLER]===================================> start apache2"
		# while ! (service apache2 status >/dev/null 2>&1) do :; done
		# echo "[CONTROLLER]===================================> start apache2 Done!"
		service apache2 reload
	else
		# (3) To finalize installation
		# (3-1) On RHEL and CentOS, configure SELinux to permit the web server to connect to OpenStack services:
		setsebool -P httpd_can_network_connect on

		# (3-2) Due to a packaging bug, the dashboard CSS fails to load properly. Run the following command to resolve this issue:
		chown -R apache:apache /usr/share/openstack-dashboard/static

		# # Firewall 80 Port Open

		# firewall-cmd --add-service=http --permanent		## Port 80
		# firewall-cmd --zone=public --add-port=80/tcp --permanent
		# # firewall-cmd --reload
		# systemctl restart firewalld.service
		# sleep 3

		# (3-3) Start the web server and session storage service and configure them to start when the system boots:
		# 이미 kilo-3.1.2-4.controller.sh 에서 서비스 등록및 서비스 기동 했음 
		# 그러므로 지금은 서비스 제기동이 필요함.
		# systemctl enable httpd.service memcached.service
		# systemctl start httpd.service memcached.service
		
		systemctl enable httpd.service memcached.service
		systemctl restart httpd.service memcached.service
		sleep 1
		echo "[CONTROLLER]===================================> start httpd.service memcached.service"
		sleep 3
		while ! (systemctl is-active httpd.service memcached.service >/dev/null 2>&1)  do :; done
		echo "[CONTROLLER]===================================> start httpd.service memcached.service Done!"

	fi	
}


function func_horizon_verify_operation()
{
	echo [$(hostname)] func_horizon_verify_operation..................................................
	echo "This section describes how to verify operation of the dashboard."
	echo "   1.  Access the dashboard using a web browser: http://controller/horizon ."
	echo "   2. Authenticate using admin or demo user credentials."
}

