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
# Chapter : 5. Add the Compute service
# Node : Controller

source ./kilo-perform-vars.common.sh

##################################################################################################
# nova controller node
function func_nova_install_package_controller_node()
{
	echo [$(hostname)] func_nova_install_package_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# # # ERROR : Unable to import guestfsfalling back to VFSLocalFS 때문...
		# # apt-get -y install python-guestfs
		# echo \# pip install eventlet
		# echo \# pip install --upgrade eventlet
		# pip install eventlet
		# pip install --upgrade eventlet

		# ERROR 발생
		# Adding new user `nova' (UID 111) with group `nova' ...
		# Not creating home directory `/var/lib/nova'.
		# usermod: no changes
		# No handlers could be found for logger "oslo_config.cfg"
		# 이유는 https://bugs.launchpad.net/nova/+bug/1450291
		# change the 'logdir' to 'log_dir' did fix this issue
		# 그래서 nova.cfg에서 log_dir 추가사던가
		# logdir 설정을 이 옵션이므로 제거한다. Centos에서는 제거되어 있다.
		# 1. nova-common설치 
		# 2. nova.conf에서 logdir제거
		apt-get -y install nova-common
		crudini --del /etc/nova/nova.conf DEFAULT logdir
		crudini --set /etc/nova/nova.conf DEFAULT log_dir /var/log/nova


		echo \# apt-get -y install nova-api nova-cert nova-conductor nova-consoleauth nova-novncproxy nova-scheduler python-novaclient

		apt-get -y install nova-api nova-cert nova-conductor nova-consoleauth \
       nova-novncproxy nova-scheduler python-novaclient
	else
		yum -y install openstack-nova-api openstack-nova-cert openstack-nova-conductor \
       openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler \
       python-novaclient
	fi	
}

function func_nova_configure_controller_node()
{
	echo [$(hostname)] func_nova_configure_controller_node..............................................................................
	# (2-2) Edit the /etc/nova/nova.conf file and complete the following actions:
	if [ ! -f /etc/nova/nova.conf ]; then
	    touch /etc/nova/nova.conf
	fi

	# Add a [database] section, and configure database access:
	crudini --set /etc/nova/nova.conf database connection mysql://nova:${NOVA_DBPASS}@controller/nova
	# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
	crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller
	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}


	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then
	# 	# Error: Unable to retrieve network quota information.
	# 	# Unable to establish connection to http://controller:9696/v2.0/agents.json
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_host controller
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_userid openstack
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_password ${RABBIT_PASS}
	# fi


	# # ERROR oslo_messaging._drivers.impl_rabbit
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_port 5672
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_hosts controller:5672
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_use_ssl False
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_virtual_host /
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_ha_queues False

	# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
	# [DEFAULT]
	crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone

	# [keystone_authtoken]
	crudini --del /etc/nova/nova.conf keystone_authtoken

	crudini --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/nova/nova.conf keystone_authtoken auth_plugin password
	crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_id default
	crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_id default
	crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
	crudini --set /etc/nova/nova.conf keystone_authtoken username nova
	crudini --set /etc/nova/nova.conf keystone_authtoken password ${NOVA_PASS}

	# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
	crudini --set /etc/nova/nova.conf DEFAULT my_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}

	# In the [DEFAULT] section, configure the VNC proxy to use the management interface IP address of the controller node:
	crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}
	crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}

	# In the [glance] section, configure the location of the Image service:
	crudini --set /etc/nova/nova.conf glance host controller

	# In the [oslo_concurrency] section, configure the lock path:
	crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/nova/nova.conf DEFAULT verbose True

	# (2-3) To finalize installation
	su -s /bin/sh -c "nova-manage db sync" nova
}


function func_nova_start_service_controller_node()
{
	echo [$(hostname)] func_nova_start_service_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service nova-api restart
		service nova-cert restart
		service nova-consoleauth restart
		service nova-scheduler restart
		service nova-conductor restart
		service nova-novncproxy restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy"
		while ! (\
			(service nova-api status >/dev/null 2>&1) && \
			(service nova-cert status >/dev/null 2>&1) && \
			(service nova-consoleauth status >/dev/null 2>&1) && \
			(service nova-scheduler status >/dev/null 2>&1) && \
			(service nova-conductor status >/dev/null 2>&1) && \
			(service nova-novncproxy status >/dev/null 2>&1) \
			) do :; done
		echo "[CONTROLLER]===================================> start nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy Done!"
	else
		# (3) To finalize installation
		systemctl enable openstack-nova-api.service openstack-nova-cert.service \
		  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
		  openstack-nova-conductor.service openstack-nova-novncproxy.service

		systemctl start openstack-nova-api.service openstack-nova-cert.service \
		  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
		  openstack-nova-conductor.service openstack-nova-novncproxy.service
		echo "[CONTROLLER]===================================> start openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service"
		while ! ( \
			(systemctl is-active openstack-nova-api.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-cert.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-consoleauth.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-scheduler.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-conductor.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-novncproxy.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> start openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service Done!"
		# sleep 5
	fi	
}

function func_nova_remove_sqllite_ubuntu_controller_node()
{
	echo [$(hostname)] func_nova_remove_sqllite_ubuntu_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
			# Because this configuration uses a SQL database server, you can remove the SQLite database file:
		rm -f /var/lib/nova/nova.sqlite
	fi
}


##################################################################################################
# nova compute node
function func_nova_install_package_compute_node()
{
	echo [$(hostname)] func_nova_install_package_compute_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# ERROR for Troubleshoot KVM
		# libvirtError: internal error no supported architecture for os type 'hvm'
		# http://docs.openstack.org/kilo/config-reference/content/kvm.html
		echo \# udevadm trigger
		udevadm trigger

		# ERROR : Unable to import guestfsfalling back to VFSLocalFS 때문...
		apt-get -y install python-guestfs	



		# ERROR 발생
		# Adding new user `nova' (UID 111) with group `nova' ...
		# Not creating home directory `/var/lib/nova'.
		# usermod: no changes
		# No handlers could be found for logger "oslo_config.cfg"
		# 이유는 https://bugs.launchpad.net/nova/+bug/1450291
		# change the 'logdir' to 'log_dir' did fix this issue
		# 그래서 nova.cfg에서 log_dir 추가사던가
		# logdir 설정을 이 옵션이므로 제거한다. Centos에서는 제거되어 있다.
		# 1. nova-common설치 
		# 2. nova.conf에서 logdir제거
		apt-get -y install nova-common
		crudini --del /etc/nova/nova.conf DEFAULT logdir
		crudini --set /etc/nova/nova.conf DEFAULT log_dir /var/log/nova

		# Err http://kr.archive.ubuntu.com/ubuntu/ trusty-updates/main kpartx amd64 0.4.9-3ubuntu7.4
		#   404  Not Found
		# E: Failed to fetch http://kr.archive.ubuntu.com/ubuntu/pool/main/m/multipath-tools/kpartx_0.4.9-3ubuntu7.4_amd64.deb  404  Not Found
		# E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
		apt-get update
		
		apt-get -y install nova-compute sysfsutils	
	else
		yum -y install openstack-nova-compute sysfsutils
	fi	
}

function func_nova_configure_compute_node()
{
	echo [$(hostname)] func_nova_configure_compute_node..............................................................................
	# (1-2) Edit the /etc/nova/nova.conf file and complete the following actions:
	if [ ! -f /etc/nova/nova.conf ]; then
	    touch /etc/nova/nova.conf
	fi
	# # Add a [database] section, and configure database access:
	# crudini --set /etc/nova/nova.conf database connection mysql://nova:${NOVA_DBPASS}@controller/nova
	# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
	# [DEFAULT]
	crudini --set /etc/nova/nova.conf DEFAULT rpc_backend rabbit

	# [oslo_messaging_rabbit]
	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_host controller
	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_userid openstack
	crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then
	# 	# Error: Unable to retrieve network quota information.
	# 	# Unable to establish connection to http://controller:9696/v2.0/agents.json
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_host controller
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_userid openstack
	# 	crudini --set /etc/nova/nova.conf DEFAULT rabbit_password ${RABBIT_PASS}
	# fi

	# # ERROR oslo_messaging._drivers.impl_rabbit
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_port 5672
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_hosts controller:5672
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_use_ssl False
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_virtual_host /
	# crudini --set /etc/nova/nova.conf oslo_messaging_rabbit rabbit_ha_queues False

	# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
	# [DEFAULT]
	crudini --set /etc/nova/nova.conf DEFAULT auth_strategy keystone

	# [keystone_authtoken]
	crudini --del /etc/nova/nova.conf keystone_authtoken

	crudini --set /etc/nova/nova.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/nova/nova.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/nova/nova.conf keystone_authtoken auth_plugin password
	crudini --set /etc/nova/nova.conf keystone_authtoken project_domain_id default
	crudini --set /etc/nova/nova.conf keystone_authtoken user_domain_id default
	crudini --set /etc/nova/nova.conf keystone_authtoken project_name service
	crudini --set /etc/nova/nova.conf keystone_authtoken username nova
	crudini --set /etc/nova/nova.conf keystone_authtoken password ${NOVA_PASS}

	# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
	crudini --set /etc/nova/nova.conf DEFAULT my_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}

	# In the [DEFAULT] section, configure the VNC proxy to use the management interface IP address of the controller node:
	crudini --set /etc/nova/nova.conf DEFAULT vnc_enabled True
	crudini --set /etc/nova/nova.conf DEFAULT vncserver_listen 0.0.0.0
	crudini --set /etc/nova/nova.conf DEFAULT vncserver_proxyclient_address ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}
	crudini --set /etc/nova/nova.conf DEFAULT novncproxy_base_url http://controller:6080/vnc_auto.html

	# In the [glance] section, configure the location of the Image service:
	crudini --set /etc/nova/nova.conf glance host controller

	# In the [oslo_concurrency] section, configure the lock path:
	crudini --set /etc/nova/nova.conf oslo_concurrency lock_path /var/lib/nova/tmp

	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/nova/nova.conf DEFAULT verbose True

	crudini --set /etc/nova/nova.conf libvirt virt_type qemu

}


function func_nova_start_service_compute_node()
{
	echo [$(hostname)] func_nova_start_service_compute_node..............................................................................
	# If this command returns a value of zero, your compute node does not support hardware acceleration and you must configure libvirt to use QEMU instead of KVM.
	# crudini --set /etc/nova/nova.conf libvirt virt_type qemu	
	egrep -c '(vmx|svm)' /proc/cpuinfo	

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then

		if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]; 
		then 
			crudini --set /etc/nova/nova-compute.conf libvirt virt_type qemu
		fi

		service nova-compute restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-compute"
		while ! (\
			service nova-compute status >/dev/null 2>&1 \
			) do :; done
		echo "[CONTROLLER]===================================> start nova-compute Done!"
		rm -f /var/lib/nova/nova.sqlite
	else
		if [ $(egrep -c '(vmx|svm)' /proc/cpuinfo) -eq 0 ]; 
		then 
			crudini --set /etc/nova/nova.conf libvirt virt_type qemu
		fi
		systemctl enable libvirtd.service openstack-nova-compute.service
		systemctl start libvirtd.service openstack-nova-compute.service
		echo "[COMPUTE]===================================> start libvirtd.service openstack-nova-compute.service"
		while ! ( \
			(systemctl is-active libvirtd.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-compute.service >/dev/null 2>&1) \
			)  do :; done
		echo "[COMPUTE]===================================> start libvirtd.service openstack-nova-compute.service Done!"

		# # Compute ports for access to virtual machine consoles	5900-5999	
		# firewall-cmd --zone=public --add-port=5900-5999/tcp --permanent
		# # Compute VNC proxy for browsers ( openstack-nova-novncproxy)	6080
		# firewall-cmd --zone=public --add-port=6080/tcp --permanent
		# # Compute VNC proxy for traditional VNC clients (openstack-nova-xvpvncproxy)	6081	
		# firewall-cmd --zone=public --add-port=6081/tcp --permanent
		# # Proxy port for HTML5 console used by Compute service	6082	
		# firewall-cmd --zone=public --add-port=6082/tcp --permanent
				
		# systemctl restart firewalld.service
		# sleep 1
		# echo "[COMPUTE]===================================> start firewalld.service"
		# while ! systemctl is-active firewalld.service >/dev/null 2>&1; do :; done
		# echo "[COMPUTE]===================================> start firewalld.service  Done!"
	fi	
}

function func_nova_remove_sqllite_ubuntu_compute_node()
{
	echo [$(hostname)] func_nova_remove_sqllite_ubuntu_compute_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
			# Because this configuration uses a SQL database server, you can remove the SQLite database file:
		rm -f /var/lib/nova/nova.sqlite
	fi
}

function func_nova_verify_operation()
{
	echo [$(hostname)] func_nova_verify_operation..............................................................................
	# 5. Add the Compute service
	# 5.3 Verify operation
	# (1) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (2) List service components to verify successful launch and registration of each process:
	nova service-list
	# (3) List API endpoints in the Identity service to verify connectivity with the Identity service:
	nova endpoints
	# (4) List images in the Image service catalog to verify connectivity with the Image service:
	nova image-list
}
