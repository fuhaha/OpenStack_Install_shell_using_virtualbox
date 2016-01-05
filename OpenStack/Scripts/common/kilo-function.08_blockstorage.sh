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
# Chapter : 8. Add the Block Storage service
# Node : Controller

# Load Common functions
source ./kilo-perform-vars.common.sh

# Load Common functions
source ./kilo-function.00_common.sh

##################################################################################################
# cinder controller node

function func_cinder_configure_prerequisites_controller_node()
{
	echo [$(hostname)] func_cinder_configure_prerequisites_controller_node..............................................................................
	# 8.  Add the Block Storage service
	# export DATABASE_ADMIN_PASS=pass_for_db
	# export NOVA_DBPASS=pass_for_db_nova
	# export NOVA_PASS=pass_for_nova
	# 8.1 Install and configure controller node
	# (1) To configure prerequisites
	# (1-1) To create the database, complete these steps:
	# Create the cinder database:
	# mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE cinder;"
	# # Grant proper access to the cinder database:
	# mysql -u root -p${DATABASE_ADMIN_PASS} -e \
	# "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '${CINDER_DBPASS}';"
	# mysql -u root -p${DATABASE_ADMIN_PASS} -e \
	# "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '${CINDER_DBPASS}';"

	func_common_database_create_grant cinder ${CINDER_DBPASS}

	# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (1-3) To create the service credentials, complete these steps:

	# func_common_create_user_role [user] [passwd] [role] [project]
	func_common_create_user_role cinder ${CINDER_PASS} admin service

	# func_common_create_service_and_endpoint [name]  [description] [server-name] [publicurl] [internalurl] [adminurl]
	func_common_create_service_and_endpoint cinder "OpenStack Block Storage" volume http://controller:8776/v2/%\(tenant_id\)s http://controller:8776/v2/%\(tenant_id\)s http://controller:8776/v2/%\(tenant_id\)s

	# func_common_create_service_and_endpoint [name]  [description] [server-name] [publicurl] [internalurl] [adminurl]
	func_common_create_service_and_endpoint cinderv2 "OpenStack Block Storage" volumev2 http://controller:8776/v2/%\(tenant_id\)s http://controller:8776/v2/%\(tenant_id\)s http://controller:8776/v2/%\(tenant_id\)s

}



function func_cinder_install_package_controller_node()
{
	echo [$(hostname)] func_cinder_install_package_controller_node..............................................................................
	# 8. Add the Block Storage service
	# 8.1 Install and configure controller node
	 
	# (2) To install and configure Block Storage controller components
	# (2-1) Install the packages:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install cinder-api cinder-scheduler python-cinderclient
		# # ERROR : For "Oslo.config cfg.py throws deprecation warning".
		# apt-get -y install python-guestfs		
		# pip install oslo.config --upgrade

		# # for Error cinder-rtstool import No module named rtslib
		# apt-get -y install --no-install-recommends targetcli python-urwid
		# pip install --upgrade https://pypi.python.org/packages/source/r/rtstool/rtstool-0.1a4.tar.gz
		# pip install --upgrade https://pypi.python.org/packages/source/r/rtslib-fb/rtslib-fb-2.1.49.tar.gz		
	else
		yum -y install openstack-cinder python-cinderclient python-oslo-db
	fi	
}

function func_cinder_configure_controller_node()
{
	echo [$(hostname)] func_cinder_configure_controller_node..............................................................................

	# if [ "$TARGET_OS_UBUNTU" != "1" ];
	# then
	# 	mv -i /etc/cinder/cinder.conf /etc/cinder/cinder.conf.org
	# 	cp -i /usr/share/cinder/cinder-dist.conf /etc/cinder/cinder.conf
	# 	chown -R cinder:cinder /etc/cinder/cinder.conf
	# fi	

	# (2-2) Copy the /usr/share/cinder/cinder-dist.conf file to /etc/cinder/cinder.conf.


	# (2-3) Edit the /etc/cinder/cinder.conf file and complete the following actions:
	# if [ ! -f /etc/cinder/cinder.conf ]; then
	#     touch /etc/cinder/cinder.conf
	# fi

	# In the [database] section, configure database access:
	# [database]
	crudini --set /etc/cinder/cinder.conf database connection mysql://cinder:${CINDER_DBPASS}@controller/cinder

	# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT rpc_backend rabbit

	# [oslo_messaging_rabbit]
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then
	# 	# Error: Unable to retrieve network quota information.
	# 	# Unable to establish connection to http://controller:9696/v2.0/agents.json
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_host controller
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_userid openstack
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_password ${RABBIT_PASS}		
	# fi

	# # ERROR oslo_messaging._drivers.impl_rabbit
	# crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_port 5672
	# crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_hosts controller:5672
	# crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_use_ssl False
	# crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_virtual_host /
	# crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_ha_queues False

	# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone

	# [keystone_authtoken]
	crudini --del /etc/cinder/cinder.conf keystone_authtoken

	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_plugin password
	crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_id default
	crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_id default
	crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service
	crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder
	crudini --set /etc/cinder/cinder.conf keystone_authtoken password ${CINDER_PASS}

 
	# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
	crudini --set /etc/cinder/cinder.conf DEFAULT my_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}

	# In the [oslo_concurrency] section, configure the lock path:
	crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lock/cinder

	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/cinder/cinder.conf DEFAULT verbose True

	# (2-4) To finalize installation
	su -s /bin/sh -c "cinder-manage db sync" cinder
}


function func_cinder_finalize_installation_controller_node()
{
	echo [$(hostname)] func_cinder_finalize_installation_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (3) To finalize installation
		# (3-1) Reload the web server configuration:
		service cinder-scheduler restart
		service cinder-api restart
		sleep 1
		while ! (\
			(service cinder-scheduler status >/dev/null 2>&1) && \
			(service cinder-api status >/dev/null 2>&1) \
			) do :; done
		# (3-2) By default, the Ubuntu packages create an SQLite database.
		rm -f /var/lib/cinder/cinder.sqlite
	else
		# (3) To finalize installation
		systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service
		systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service
		echo "[CONTROLLER]===================================> start openstack-cinder-api.service openstack-cinder-scheduler.service"
		while ! ( \
			(systemctl is-active openstack-cinder-api.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-cinder-scheduler.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> start openstack-cinder-api.service openstack-cinder-scheduler.service Done!"
		# sleep 5
	fi	
}

##################################################################################################
# cinder block1 node

function func_cinder_configure_prerequisites_block1_node()
{
	echo [$(hostname)] func_cinder_configure_prerequisites_block1_node..............................................................................
	# 8. Add the Block Storage service
	# 8.2 Install and configure a storage node
	# (1) To configure prerequisites
	# (1-1)Configure the management interface:
	# IP address: 10.0.0.41
	# Network mask: 255.255.255.0 (or /24)
	# Default gateway: 10.0.0.1
	# (1-2) Set the hostname of the node to block1.

	# (1-3) Copy the contents of the /etc/hosts file from the controller node to the storage node and add the following to it:
	#3# block1
	# 10.0.0.41       block1

	# (1-4) Install and configure NTP using the instructions in the section called “Other nodes”.


	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (1-5) If you intend to use non-raw image types such as QCOW2 and VMDK, install the QEMU support package:
		# yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python python-virtinst libvirt-client virt-install virt-viewer
		# yum -y install qemu
		apt-get -y install qemu

		# (1-6) Install the LVM packages:
		apt-get -y install lvm2
	else
		# (1-5) If you intend to use non-raw image types such as QCOW2 and VMDK, install the QEMU support package:
		# yum install qemu-kvm qemu-img virt-manager libvirt libvirt-python python-virtinst libvirt-client virt-install virt-viewer
		# yum -y install qemu
		yum -y install qemu

		# (1-6) Install the LVM packages:
		yum -y install lvm2
		# [Note]	Note
		# Some distributions include LVM by default.

		# (1-7) Start the LVM metadata service and configure it to start when the system boots:
		systemctl enable lvm2-lvmetad.service
		systemctl start lvm2-lvmetad.service
	fi	

	parted -s -a optimal /dev/sdb mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on

	mkfs -t ext4 /dev/sdb1 

	# (1-8) Create the LVM physical volume /dev/sdb1:
	pvcreate /dev/sdb1 <<!
y
!
	# WARNING: ext4 signature detected on /dev/sdb1 at offset 1080. Wipe it? [y/n]:
	# Y로 자동 처리

	#  Physical volume "/dev/sdb1" successfully created

	# (1-9) Create the LVM volume group cinder-volumes:
	vgcreate cinder-volumes /dev/sdb1
	#  Volume group "cinder-volumes" successfully created


	# (1-10) Only instances can access Block Storage volumes. However, the underlying operating system manages the devices associated with the volumes. By default, the LVM volume scanning tool scans the /dev directory for block storage devices that contain volumes. If projects use LVM on their volumes, the scanning tool detects these volumes and attempts to cache them which can cause a variety of problems with both the underlying operating system and project volumes. You must reconfigure LVM to scan only the devices that contain the cinder-volume volume group. 
	# Edit the /etc/lvm/lvm.conf file and complete the following actions:

	# (1-10-a) In the devices section, add a filter that accepts the /dev/sdb device and rejects all other devices:
	# devices {
	# ...
	# filter = [ "a/sdb/", "r/.*/"]

	sed -i -e "s/devices {/devices {\n\tfilter = [ \"a\/sdb\/\"\, \"r\/\.\*\/\"\]/g" /etc/lvm/lvm.conf


	# Each item in the filter array begins with a for accept or r for reject and includes a regular expression for the device name. The array must end with r/.*/ to reject any remaining devices. You can use the vgs -vvvv command to test filters.

	# [Warning]	Warning
	# If your storage nodes use LVM on the operating system disk, you must also add the associated device to the filter. For example, if the /dev/sda device contains the operating system:

	# filter = [ "a/sda/", "a/sdb/", "r/.*/"]
	# Similarly, if your compute nodes use LVM on the operating system disk, you must also modify the filter in the /etc/lvm/lvm.conf file on those nodes to include only the operating system disk. For example, if the /dev/sda device contains the operating system:

	# filter = [ "a/sda/", "r/.*/"]
 

}

function func_cinder_install_package_block1_node()
{
	echo [$(hostname)] func_cinder_install_package_block1_node..............................................................................
	# 8. Add the Block Storage service
	# 8.1 Install and configure controller node
	 
	# (2) To install and configure Block Storage controller components
	# (2-1) Install the packages:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# # ERROR : Unable to import guestfsfalling back to VFSLocalFS 때문...
		# apt-get -y install python-guestfs	
			
		apt-get -y install cinder-volume python-mysqldb
		# # ERROR : For "Oslo.config cfg.py throws deprecation warning"
		# apt-get -y install python-pip
		# pip install oslo.config --upgrade

		# # for Error cinder-rtstool import No module named rtslib
		# apt-get -y install --no-install-recommends targetcli python-urwid
		# pip install --upgrade https://pypi.python.org/packages/source/r/rtstool/rtstool-0.1a4.tar.gz
		# pip install --upgrade https://pypi.python.org/packages/source/r/rtslib-fb/rtslib-fb-2.1.49.tar.gz
	else
		yum -y install openstack-cinder targetcli python-oslo-db python-oslo-log MySQL-python
	fi
}

function func_cinder_configure_block1_node()
{
	echo [$(hostname)] func_cinder_configure_block1_node..............................................................................
	# (2-2) Edit the /etc/cinder/cinder.conf file and complete the following actions:
	if [ ! -f /etc/cinder/cinder.conf ]; then
	    touch /etc/cinder/cinder.conf
	fi
	# Add a [database] section, and configure database access:
	crudini --set /etc/cinder/cinder.conf database connection mysql://cinder:${CINDER_DBPASS}@controller/cinder

	# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT rpc_backend rabbit

	# [oslo_messaging_rabbit]
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_host controller
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_userid openstack
	crudini --set /etc/cinder/cinder.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}
	
	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then
	# 	# Error: Unable to retrieve network quota information.
	# 	# Unable to establish connection to http://controller:9696/v2.0/agents.json
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_host controller
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_userid openstack
	# 	crudini --set /etc/cinder/cinder.conf DEFAULT rabbit_password ${RABBIT_PASS}		
	# fi
	
	# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT auth_strategy keystone

	# [keystone_authtoken]
	crudini --del /etc/cinder/cinder.conf keystone_authtoken

	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/cinder/cinder.conf keystone_authtoken auth_plugin password
	crudini --set /etc/cinder/cinder.conf keystone_authtoken project_domain_id default
	crudini --set /etc/cinder/cinder.conf keystone_authtoken user_domain_id default
	crudini --set /etc/cinder/cinder.conf keystone_authtoken project_name service
	crudini --set /etc/cinder/cinder.conf keystone_authtoken username cinder
	crudini --set /etc/cinder/cinder.conf keystone_authtoken password ${CINDER_PASS}

	# In the [DEFAULT] section, configure the my_ip option to use the management interface IP address of the controller node:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT my_ip ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}

	# In the [lvm] section, configure the LVM back end with the LVM driver, cinder-volumes volume group, iSCSI protocol, and appropriate iSCSI service:
	# [lvm]
	crudini --set /etc/cinder/cinder.conf lvm volume_driver cinder.volume.drivers.lvm.LVMVolumeDriver
	crudini --set /etc/cinder/cinder.conf lvm volume_group cinder-volumes
	crudini --set /etc/cinder/cinder.conf lvm iscsi_protocol iscsi

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then	
		crudini --set /etc/cinder/cinder.conf lvm iscsi_helper tgtadm
	else
		crudini --set /etc/cinder/cinder.conf lvm iscsi_helper lioadm
	fi	
	# In the [DEFAULT] section, enable the LVM back end:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT enabled_backends lvm

	# In the [DEFAULT] section, configure the location of the Image service:
	# [DEFAULT]
	crudini --set /etc/cinder/cinder.conf DEFAULT glance_host controller


	# In the [oslo_concurrency] section, configure the lock path:
	crudini --set /etc/cinder/cinder.conf oslo_concurrency lock_path /var/lock/cinder

	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/cinder/cinder.conf DEFAULT verbose True

	if [ "$TARGET_OS_UBUNTU" != "1" ];
	then
		# iSCSI target : OpenStack Block Storage. Required.
		firewall-cmd --zone=public --add-port=873/tcp --permanent
	fi

	chown -R cinder:cinder /var/lock
	chown -R cinder:cinder /var/run/lock/

	##############################################################################################
	# ERROR : OSError: [Errno 13] Permission denied: '/var/lock/cinder'
	# URL : http://www.francescpinyol.cat/openstack.html
	mkdir  /var/lock/cinder
	chown cinder:cinder /var/lock/cinder
}

function func_cinder_finalize_installation_block1_node()
{
	echo [$(hostname)] func_cinder_finalize_installation_block1_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (3) To finalize installation
		# (3-1) Reload the web server configuration:
		service tgt restart
		service cinder-volume restart
		sleep 1
		while ! (\
			(service tgt status >/dev/null 2>&1) && \
			(service cinder-volume status >/dev/null 2>&1) \
			) do :; done
		# (3-2) By default, the Ubuntu packages create an SQLite database.
		rm -f /var/lib/cinder/cinder.sqlite
	else
		# (3) To finalize installation

		# (3-1) Start the Block Storage volume service including its dependencies and configure them to start when the system boots:
		systemctl enable openstack-cinder-volume.service target.service
		systemctl start openstack-cinder-volume.service target.service
		echo "[BLOCK]===================================> start openstack-cinder-volume.service target.service"
		while ! ( \
			(systemctl is-active openstack-cinder-volume.service >/dev/null 2>&1) && \
			(systemctl is-active target.service >/dev/null 2>&1) \
			)  do :; done
		echo "[BLOCK]===================================> start openstack-cinder-volume.service target.service Done!"
		# sleep 5
	fi	
}



function func_cinder_verify_operation()
{
	echo [$(hostname)] func_cinder_verify_operation..................................................
	# 8. Add the Block Storage service
	# 8.3 Verify operation
	# (1) In each client environment script, configure the Block Storage client to use API version 2.0:
	echo "export OS_VOLUME_API_VERSION=2" | tee -a ~student/env/admin-openrc.sh ~student/env/demo-openrc.sh
	# (2) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (3) List service components to verify successful launch of each process:
	cinder service-list
	# (4) Source the demo credentials to perform the following steps as a non-administrative project:
	source ~student/env/demo-openrc.sh
	# (5) Create a 1 GB volume:
	cinder create --name demo-volume1 1
	# (6) Verify creation and availability of the volume:
	cinder list

	cinder delete demo-volume1
}
