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

function func_swift_configure_prerequisites_controller_node()
{
	echo [$(hostname)] func_swift_configure_prerequisites_controller_node..............................................................................
	# 9. Add Object Storage
	# 9.1 Install and configure the controller node
	# (1) To configure prerequisites

	source ~student/env/admin-openrc.sh
	# (1-1) To create the Identity service credentials, complete these steps:
	# (1-1-1) Create the swift user:
	# (1-1-2) Add the admin role to the swift user:
	func_common_create_user_role swift ${SWIFT_PASS} admin service

	# (1-1-3) Create the swift service entity:
	# (1-2) Create the Object Storage service API endpoint:
	func_common_create_service_and_endpoint swift "OpenStack Object Storage" object-store http://controller:8080/v1/AUTH_%\(tenant_id\)s http://controller:8080/v1/AUTH_%\(tenant_id\)s http://controller:8080
}


function func_swift_install_package_controller_node()
{
	echo [$(hostname)] func_swift_install_package_controller_node..............................................................................
	# 8. Add the Block Storage service
	# 8.1 Install and configure controller node
	 
	# (2) To install and configure Block Storage controller components
	# (2-1) Install the packages:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install swift swift-proxy python-swiftclient python-keystoneclient python-keystonemiddleware memcached
	else
		yum -y install openstack-swift-proxy python-swiftclient python-keystone-auth-token python-keystonemiddleware memcached
	fi	
}

function func_swift_configure_controller_node()
{
	echo [$(hostname)] func_swift_configure_controller_node..............................................................................

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		mkdir /etc/swift
	# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
		# curl -o /etc/swift/proxy-server.conf \
		# 	https://raw.githubusercontent.com/openstack/swift/stable/juno/etc/proxy-server.conf-sample?h=stable/kilo	
		curl -o /etc/swift/proxy-server.conf \
		  https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/kilo			
	else
	# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
		curl -o /etc/swift/proxy-server.conf \
		  https://git.openstack.org/cgit/openstack/swift/plain/etc/proxy-server.conf-sample?h=stable/kilo
	fi	



	# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:
	# (2-3-1) In the [DEFAULT] section, configure the bind port, user, and configuration directory:
	# [DEFAULT]
	crudini --set /etc/swift/proxy-server.conf DEFAULT bind_port 8080
	crudini --set /etc/swift/proxy-server.conf DEFAULT user swift
	crudini --set /etc/swift/proxy-server.conf DEFAULT swift_dir /etc/swift

	# (2-3-2) In the [pipeline:main] section, enable the appropriate modules:
	# [pipeline:main]
	# crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo proxy-logging proxy-server'
	# swiftclient.service.SwiftError: 'Account not found' 때문에 아래와 같이 변경
	# <참조> https://bugs.launchpad.net/openstack-manuals/+bug/1485278 

	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then	
	# 	crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo proxy-logging proxy-server'
	# else
	# 	crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors healthcheck cache authtoken proxy-logging proxy-server'
	# fi

	# crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors gatekeeper healthcheck proxy-logging cache container_sync bulk ratelimit authtoken keystoneauth container-quotas account-quotas slo dlo proxy-logging proxy-server'
	crudini --set /etc/swift/proxy-server.conf pipeline:main pipeline 'catch_errors healthcheck cache authtoken proxy-logging proxy-server'
	
	# (2-3-3) In the [app:proxy-server] section, enable automatic account creation:
	# [app:proxy-server]
	crudini --set /etc/swift/proxy-server.conf app:proxy-server account_autocreate true

	# (2-3-4) In the [filter:keystoneauth] section, configure the operator roles:
	# [filter:keystoneauth]
	crudini --set /etc/swift/proxy-server.conf filter:keystoneauth use egg:swift#keystoneauth
	crudini --set /etc/swift/proxy-server.conf filter:keystoneauth operator_roles admin,user

	# (2-3-5) In the [filter:authtoken] section, configure Identity service access:
	# [filter:authtoken]
	crudini --del /etc/swift/proxy-server.conf filter:authtoken

	crudini --set /etc/swift/proxy-server.conf filter:authtoken paste.filter_factory keystonemiddleware.auth_token:filter_factory

	crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_uri http://controller:5000
	crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_url http://controller:35357
	crudini --set /etc/swift/proxy-server.conf filter:authtoken auth_plugin password
	crudini --set /etc/swift/proxy-server.conf filter:authtoken project_domain_id default
	crudini --set /etc/swift/proxy-server.conf filter:authtoken user_domain_id default
	crudini --set /etc/swift/proxy-server.conf filter:authtoken project_name service
	crudini --set /etc/swift/proxy-server.conf filter:authtoken username swift
	crudini --set /etc/swift/proxy-server.conf filter:authtoken password ${SWIFT_PASS}
	crudini --set /etc/swift/proxy-server.conf filter:authtoken delay_auth_decision true

	# (2-3-6) In the [filter:cache] section, configure the memcached location:
	# [filter:cache]
	crudini --set /etc/swift/proxy-server.conf filter:cache memcache_servers 127.0.0.1:11211
}

function func_swift_create_account_rings()
{
	echo [$(hostname)] func_swift_create_account_rings..............................................................................
	# 9.3.1 Account ring
	# (1) To create the ring
	# (1-1) Change to the /etc/swift directory.
	cd /etc/swift
	# (1-2) Create the base account.builder file::
	swift-ring-builder account.builder create 10 3 1

	# (1-3) Add each storage node to the ring:

	swift-ring-builder account.builder \
		add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder account.builder \
		add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6002/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder account.builder \
		add r1z3-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6002/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder account.builder \
		add r1z4-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6002/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	# (1-4) Verify the ring contents:

	swift-ring-builder account.builder
	# (1-5) Rebalance the ring:

	swift-ring-builder account.builder rebalance
	# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
}

function func_swift_create_container_rings()
{
	echo [$(hostname)] func_swift_create_container_rings..............................................................................
	# 9.3.2 Container ring
	# (1) To create the ring
	# (1-1) Change to the /etc/swift directory.
	cd /etc/swift
	# (1-2) Create the base container.builder file::
	swift-ring-builder container.builder create 10 3 1

	# (1-3) Add each storage node to the ring:

	swift-ring-builder container.builder \
		add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6001/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder container.builder \
		add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6001/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder container.builder \
		add r1z3-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6001/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder container.builder \
		add r1z4-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6001/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	# (1-4) Verify the ring contents:

	swift-ring-builder container.builder
	# (1-5) Rebalance the ring:

	swift-ring-builder container.builder rebalance
	# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
}

function func_swift_create_object_rings()
{
	echo [$(hostname)] func_swift_create_object_rings..............................................................................
	# 9.3.3 Object ring
	# (1) To create the ring
	# (1-1) Change to the /etc/swift directory.
	cd /etc/swift
	# (1-2) Create the base object.builder file::
	swift-ring-builder object.builder create 10 3 1

	# (1-3) Add each storage node to the ring:

	swift-ring-builder object.builder \
		add r1z1-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6000/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder object.builder \
		add r1z2-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:6000/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder object.builder \
		add r1z3-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6000/${OBJECT_NODE_DEVICE_NAME1} ${OBJECT_NODE_DEVICE_WEIGHT}

	swift-ring-builder object.builder \
		add r1z4-${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:6000/${OBJECT_NODE_DEVICE_NAME2} ${OBJECT_NODE_DEVICE_WEIGHT}

	# (1-4) Verify the ring contents:

	swift-ring-builder object.builder
	# (1-5) Rebalance the ring:

	swift-ring-builder object.builder rebalance
	# Reassigned 1024 (100.00%) partitions. Balance is now 0.00.  Dispersion is now 0.00
}

function func_swift_create_initial_rings()
{
	echo [$(hostname)] func_swift_create_initial_rings..................................................
	# 9.2 Install and configure the storage nodes
	# 9.3 Create initial rings

	# 9.3.1 Account ring
	func_swift_create_account_rings

	# 9.3.2 Container ring
	func_swift_create_container_rings


	# 9.3.3 Object ring
	func_swift_create_object_rings
}


function func_swift_finalize_installation_step1_controller_node()
{
	echo [$(hostname)] func_swift_finalize_installation_step1..............................................................................
	# 9.4 Finalize installation
	# 9.4.1 Configure hashes and default storage policy

	# (1) Obtain the /etc/swift/swift.conf file from the Object Storage source repository:

	curl -o /etc/swift/swift.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/swift.conf-sample?h=stable/kilo

	# (2) Edit the /etc/swift/swift.conf file and complete the following actions:
	# (2-1) In the [swift-hash] section, configure the hash path prefix and suffix for your environment.
	# [swift-hash]
	crudini --set /etc/swift/swift.conf swift-hash swift_hash_path_suffix $(openssl rand -hex 10)
	crudini --set /etc/swift/swift.conf swift-hash swift_hash_path_prefix $(openssl rand -hex 10)
	# Replace HASH_PATH_PREFIX and HASH_PATH_SUFFIX with unique values.

	# (2-2) In the [storage-policy:0] section, configure the default storage policy:
	# [storage-policy:0]
	crudini --set /etc/swift/swift.conf storage-policy:0 name Policy-0
	crudini --set /etc/swift/swift.conf storage-policy:0 default yes
}

function func_swift_finalize_installation_step2_controller_node()
{
	echo [$(hostname)] func_swift_finalize_installation_step2..............................................................................
	# 9.4 Finalize installation
	# 9.4.1 Configure hashes and default storage policy

	# (4)On all nodes, ensure proper ownership of the configuration directory:
	chown -R swift:swift /etc/swift


	# (5) On the controller node and any other nodes running the proxy service, start the Object Storage proxy service including its dependencies and configure them to start when the system boots:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service memcached restart
		service swift-proxy restart
		sleep 3
		while ! (\
			(service memcached status >/dev/null 2>&1) && \
			(service swift-proxy status >/dev/null 2>&1) \
			) do :; done
	else
		systemctl enable openstack-swift-proxy.service memcached.service
		systemctl start openstack-swift-proxy.service memcached.service
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-proxy.service memcached.service"
		while ! ( \
			(systemctl is-active openstack-swift-proxy.service >/dev/null 2>&1) && \
			(systemctl is-active memcached.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-proxy.service memcached.service Done!"

		systemctl status openstack-swift-proxy.service
		systemctl status memcached.service
	fi	

}

##################################################################################################
# cinder block1 node
# func_swift_configure_prerequisites_object_node [management_ip_address]
function func_swift_configure_prerequisites_object_node()
{
	echo [$(hostname)] func_swift_configure_prerequisites_object_node..............................................................................
	# object node management interface IP : ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} or ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}
	echo "object node management interface IP : $1" 
	# 9.2 Install and configure the storage nodes
	# 9.2.1 To configure prerequisites
	# (1) Configure unique items on the first storage node:
	# (2) Configure unique items on the second storage node:
	# (3) Configure shared items on both storage nodes:
	# (3-1) Copy the contents of the /etc/hosts file from the controller node and add the following to it:
	# (3-2) Install and configure NTP using the instructions in the section called “Other nodes”.
	# (3-3) Install the supporting utility packages:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install xfsprogs rsync
	else
		yum -y install xfsprogs rsync
	fi		
	
	parted -s -a optimal /dev/sdb mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on
	parted -s -a optimal /dev/sdc mklabel gpt -- mkpart extended ext4 1 -1 set 1 lvm on

	# (3-4) Format the /dev/sdb1 and /dev/sdc1 partitions as XFS:
	mkfs.xfs /dev/sdb1
	mkfs.xfs /dev/sdc1

	# (3-5) Create the mount point directory structure:
	mkdir -p /srv/node/sdb1
	mkdir -p /srv/node/sdc1

	# (3-6) Edit the /etc/fstab file and add the following to it:
	cat << EOF >> /etc/fstab 
/dev/sdb1 /srv/node/sdb1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
/dev/sdc1 /srv/node/sdc1 xfs noatime,nodiratime,nobarrier,logbufs=8 0 2
EOF

	# (3-7) Mount the devices:
	mount /srv/node/sdb1
	mount /srv/node/sdc1


	# (4) Edit the /etc/rsyncd.conf file and add the following to it:
	cat << EOF >> /etc/rsyncd.conf
uid = swift
gid = swift
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
address = $1
 
[account]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/account.lock
 
[container]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/container.lock
 
[object]
max connections = 2
path = /srv/node/
read only = false
lock file = /var/lock/object.lock
EOF

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		crudini --set /etc/default/rsync '' RSYNC_ENABLE true
	fi
	
	if [ "$TARGET_OS_UBUNTU" != "1" ];
	then
		# # rsync : OpenStack Object Storage. Required.
		# firewall-cmd --zone=public --add-port=873/tcp --permanent
		# firewall-cmd --reload
		sleep 3
	fi

	# (5) Start the rsyncd service and configure it to start when the system boots:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service rsync start
		echo "[OBJECT]===================================> start rsync"
		while ! (service rsync status >/dev/null 2>&1) do :; done
		echo "[OBJECT]===================================> start rsync Done!"
	else
		systemctl enable rsyncd.service
		systemctl start rsyncd.service
		echo "[OBJECT]===================================> start rsyncd.service"
		while ! (systemctl is-active rsyncd.service >/dev/null 2>&1)  do :; done
		echo "[OBJECT]===================================> start rsyncd.service Done!"
	fi
}

function func_swift_install_package_object_node()
{
	echo [$(hostname)] func_swift_install_package_object_node..............................................................................
	# 8. Add the Block Storage service
	# 8.1 Install and configure controller node
	 
	# (2) To install and configure Block Storage controller components
	# (2-1) Install the packages:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install swift swift-account swift-container swift-object
	else
		yum -y install openstack-swift-account openstack-swift-container openstack-swift-object
	fi
}

# func_swift_configure_object_node [management_ip_address]
function func_swift_configure_object_node()
{
	echo [$(hostname)] func_swift_configure_object_node..............................................................................
	# object node management func_swift_configure_object_node IP : ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} or ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}
	echo "object node management interface IP : $1" 
	# (2) Obtain the accounting, container, object, container-reconciler, and object-expirer service configuration files from the Object Storage source repository:
	curl -o /etc/swift/account-server.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/account-server.conf-sample?h=stable/kilo

	curl -o /etc/swift/container-server.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/container-server.conf-sample?h=stable/kilo

	curl -o /etc/swift/object-server.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/object-server.conf-sample?h=stable/kilo 

	curl -o /etc/swift/container-reconciler.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/container-reconciler.conf-sample?h=stable/kilo

	curl -o /etc/swift/object-expirer.conf \
	  https://git.openstack.org/cgit/openstack/swift/plain/etc/object-expirer.conf-sample?h=stable/kilo

	# (3) Edit the /etc/swift/account-server.conf file and complete the following actions:
	# (3-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
	# [DEFAULT]
	crudini --set /etc/swift/account-server.conf DEFAULT bind_ip $1
	crudini --set /etc/swift/account-server.conf DEFAULT bind_port 6002
	crudini --set /etc/swift/account-server.conf DEFAULT user swift
	crudini --set /etc/swift/account-server.conf DEFAULT swift_dir /etc/swift
	crudini --set /etc/swift/account-server.conf DEFAULT devices /srv/node

	# (3-2) In the [pipeline:main] section, enable the appropriate modules:
	# [pipeline:main]
	crudini --set /etc/swift/account-server.conf pipeline:main pipeline 'healthcheck recon account-server'

	# (3-3) In the [filter:recon] section, configure the recon (metrics) cache directory:
	# [filter:recon]
	crudini --set /etc/swift/account-server.conf filter:recon recon_cache_path /var/cache/swift

	# (4) Edit the /etc/swift/container-server.conf file and complete the following actions:
	# (4-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
	# [DEFAULT]
	crudini --set /etc/swift/container-server.conf DEFAULT bind_ip $1
	crudini --set /etc/swift/container-server.conf DEFAULT bind_port 6001
	crudini --set /etc/swift/container-server.conf DEFAULT user swift
	crudini --set /etc/swift/container-server.conf DEFAULT swift_dir /etc/swift
	crudini --set /etc/swift/container-server.conf DEFAULT devices /srv/node

	# (4-2) In the [pipeline:main] section, enable the appropriate modules:
	#[pipeline:main]
	crudini --set /etc/swift/container-server.conf pipeline:main pipeline 'healthcheck recon container-server'

	# (4-3) IIn the [filter:recon] section, configure the recon (metrics) cache directory:
	# [filter:recon]
	crudini --set /etc/swift/container-server.conf filter:recon recon_cache_path /var/cache/swift

	# (5) Edit the /etc/swift/object-server.conf file and complete the following actions:
	# (5-1) In the [DEFAULT] section, configure the bind IP address, bind port, user, configuration directory, and mount point directory:
	# [DEFAULT]
	crudini --set /etc/swift/object-server.conf DEFAULT bind_ip $1
	crudini --set /etc/swift/object-server.conf DEFAULT bind_port 6000
	crudini --set /etc/swift/object-server.conf DEFAULT user swift
	crudini --set /etc/swift/object-server.conf DEFAULT swift_dir /etc/swift
	crudini --set /etc/swift/object-server.conf DEFAULT devices /srv/node

	# (5-2) In the [pipeline:main] section, enable the appropriate modules:
	# [pipeline:main]

	crudini --set /etc/swift/object-server.conf pipeline:main pipeline 'healthcheck recon object-server'

	# (5-3) In the [filter:recon] section, configure the recon (metrics) cache and lock directories:
	# [filter:recon]
	crudini --set /etc/swift/object-server.conf filter:recon recon_cache_path /var/cache/swift
	crudini --set /etc/swift/object-server.conf filter:recon recon_lock_path /var/lock

	# (6) Ensure proper ownership of the mount point directory structure:
	chown -R swift:swift /srv/node

	# (7) Create the recon directory and ensure proper ownership of it:
	mkdir -p /var/cache/swift
	chown -R swift:swift /var/cache/swift

	if [ "$TARGET_OS_UBUNTU" != "1" ];
	then
		# SELinux restore context 
		restorecon -R /srv
		restorecon -R /var/cache/swift
	fi
}

function func_swift_finalize_installation_object_node()
{
	echo [$(hostname)] func_swift_finalize_installation_object_node..............................................................................
	# 9.4 Finalize installation
	# 9.4.1 Configure hashes and default storage policy

	# # (4)On all nodes, ensure proper ownership of the configuration directory:
	# chown -R swift:swift /etc/swift


	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (6) On the storage nodes, start the Object Storage services:
		swift-init all start
		# service openstack-swift-object start
		# service openstack-swift-object-replicator start
		# service openstack-swift-object-updater start
		# service openstack-swift-object-auditor start
		# while ! (\
		# 	(service openstack-swift-object status >/dev/null 2>&1) && \
		# 	(service openstack-swift-object-replicator status >/dev/null 2>&1) && \
		# 	(service openstack-swift-object-updater status >/dev/null 2>&1) && \
		# 	(service openstack-swift-object-auditor status >/dev/null 2>&1) \
		# 	) do :; done

		# service openstack-swift-container start
		# service openstack-swift-container-replicator start
		# service openstack-swift-container-updater start
		# service openstack-swift-container-auditor start
		# while ! (\
		# 	(service openstack-swift-container status >/dev/null 2>&1) && \
		# 	(service openstack-swift-container-replicator status >/dev/null 2>&1) && \
		# 	(service openstack-swift-container-updater status >/dev/null 2>&1) && \
		# 	(service openstack-swift-container-auditor status >/dev/null 2>&1) \
		# 	) do :; done


		# service openstack-swift-account start
		# service openstack-swift-account-replicator start
		# service openstack-swift-account-reaper start
		# service openstack-swift-account-auditor start
		# while ! (\
		# 	(service openstack-swift-account status >/dev/null 2>&1) && \
		# 	(service openstack-swift-account-replicator status >/dev/null 2>&1) && \
		# 	(service openstack-swift-account-updater status >/dev/null 2>&1) && \
		# 	(service openstack-swift-account-auditor status >/dev/null 2>&1) \
		# 	) do :; done
	else
		# # JSW : 방화벽 포트 열기 필요
		# # firewall-cmd --zone=public --add-port=8080/tcp --permanent
		# firewall-cmd --zone=public --add-port=6000-6002/tcp --permanent
		# systemctl reload firewalld

		# (6) On the storage nodes, start the Object Storage services and configure them to start when the system boots:

		systemctl enable openstack-swift-account.service openstack-swift-account-auditor.service \
		  openstack-swift-account-reaper.service openstack-swift-account-replicator.service
		systemctl start openstack-swift-account.service openstack-swift-account-auditor.service \
		  openstack-swift-account-reaper.service openstack-swift-account-replicator.service
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-account.service openstack-swift-account-auditor.service openstack-swift-account-reaper.service openstack-swift-account-replicator.service"
		while ! ( \
			(systemctl is-active openstack-swift-account.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-account-auditor.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-account-reaper.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-account-replicator.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-account.service openstack-swift-account-auditor.service openstack-swift-account-reaper.service openstack-swift-account-replicator.service Done!"


		systemctl enable openstack-swift-container.service openstack-swift-container-auditor.service \
		  openstack-swift-container-replicator.service openstack-swift-container-updater.service
		systemctl start openstack-swift-container.service openstack-swift-container-auditor.service \
		  openstack-swift-container-replicator.service openstack-swift-container-updater.service
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-container.service openstack-swift-container-auditor.service openstack-swift-container-replicator.service openstack-swift-container-updater.service"
		while ! ( \
			(systemctl is-active openstack-swift-container.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-container-auditor.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-container-replicator.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-container-updater.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-container.service openstack-swift-container-auditor.service openstack-swift-container-replicator.service openstack-swift-container-updater.service Done!"


		systemctl enable openstack-swift-object.service openstack-swift-object-auditor.service \
		  openstack-swift-object-replicator.service openstack-swift-object-updater.service
		systemctl start openstack-swift-object.service openstack-swift-object-auditor.service \
		  openstack-swift-object-replicator.service openstack-swift-object-updater.service

		echo "[CONTROLLER]===================================> systemctl start openstack-swift-object.service openstack-swift-object-auditor.service openstack-swift-object-replicator.service openstack-swift-object-updater.service"
		while ! ( \
			(systemctl is-active openstack-swift-object.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-object-auditor.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-object-replicator.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-swift-object-updater.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> systemctl start openstack-swift-object.service openstack-swift-object-auditor.service openstack-swift-object-replicator.service openstack-swift-object-updater.service Done!"

		# systemctl status openstack-swift-account.service
		# systemctl status openstack-swift-account-auditor.service
		# systemctl status openstack-swift-account-reaper.service
		# systemctl status openstack-swift-account-replicator.service

		# systemctl status openstack-swift-container.service
		# systemctl status openstack-swift-container-auditor.service
		# systemctl status openstack-swift-container-replicator.service
		# systemctl status openstack-swift-container-updater.service

		# systemctl status openstack-swift-object.service
		# systemctl status openstack-swift-object-auditor.service
		# systemctl status openstack-swift-object-replicator.service
		# systemctl status openstack-swift-object-updater.service
	fi
}

function func_swift_verify_operation()
{
	echo [$(hostname)] func_swift_verify_operation..................................................
	# 9. Add Object Storage
	# 9.5 Verify operation

	# (1) Source the demo credentials:
	source ~student/env/demo-openrc.sh

	# (2) Show the service status:
	swift -V 3 stat

	# (3) Upload a test file:
	cat << EOF >>  testfile2.txt
testdata
EOF

	swift -V 3 upload demo-container1 testfile2.txt
	#Replace FILE with the name of a local file to upload to the demo-container1 container.

	# (4) List containers:
	swift -V 3 list

	# (5) Download a test file:
	swift -V 3 download demo-container1 testfile2.txt
	# Replace FILE with the name of the file uploaded to the demo-container1 container.
}

