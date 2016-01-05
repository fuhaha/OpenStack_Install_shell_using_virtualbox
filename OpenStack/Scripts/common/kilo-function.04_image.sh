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
# Chapter : 4. Add the Image service
# Node : Controller

source ./kilo-perform-vars.common.sh

##################################################################################################
# glance
function func_glance_install_package()
{
	echo [$(hostname)] func_glance_install_package..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install glance python-glanceclient
	else
		yum -y install openstack-glance python-glance python-glanceclient
	fi	
}

function func_glance_configure()
{
	echo [$(hostname)] func_glance_configure..............................................................................
	# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
	# [database]
	crudini --set /etc/glance/glance-api.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

	# [keystone_authtoken]
	crudini --del /etc/glance/glance-api.conf keystone_authtoken

	crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
	crudini --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
	crudini --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
	crudini --set /etc/glance/glance-api.conf keystone_authtoken project_name service
	crudini --set /etc/glance/glance-api.conf keystone_authtoken username glance
	crudini --set /etc/glance/glance-api.conf keystone_authtoken password ${GLANCE_PASS}

	# [paste_deploy]
	crudini --set /etc/glance/glance-api.conf paste_deploy flavor keystone

	# [glance_store]
	crudini --set /etc/glance/glance-api.conf glance_store default_store file
	crudini --set /etc/glance/glance-api.conf glance_store filesystem_store_datadir /var/lib/glance/images/

	# [DEFAULT]
	crudini --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
	crudini --set /etc/glance/glance-api.conf DEFAULT verbose True

	# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
	#[database]
	crudini --set /etc/glance/glance-registry.conf database connection mysql://glance:${GLANCE_DBPASS}@controller/glance

	# [keystone_authtoken]
	crudini --del /etc/glance/glance-registry.conf keystone_authtoken

	crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken username glance
	crudini --set /etc/glance/glance-registry.conf keystone_authtoken password ${GLANCE_PASS}
	 
	# [paste_deploy]
	crudini --set /etc/glance/glance-registry.conf paste_deploy flavor keystone

	# [DEFAULT]
	crudini --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
	crudini --set /etc/glance/glance-registry.conf DEFAULT verbose True

	# (2-4) Populate the Image service database:
	su -s /bin/sh -c "glance-manage db_sync" glance
}

function func_glance_start_service()
{
	echo [$(hostname)] func_glance_start_service..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service glance-registry restart
		service glance-api restart
		sleep 1
		echo "[CONTROLLER]===================================> start glance-registry"
		while ! (\
			(service glance-registry status >/dev/null 2>&1) && \
			(service glance-api status >/dev/null 2>&1) \
			) do :; done
		echo "[CONTROLLER]===================================> start glance-registry Done!"
	else
		systemctl enable openstack-glance-api.service openstack-glance-registry.service
		systemctl start openstack-glance-api.service openstack-glance-registry.service
		echo "[CONTROLLER]===================================> start openstack-glance-api.service openstack-glance-registry.service"
		while ! ( \
			(systemctl is-active openstack-glance-api.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-glance-registry.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> start openstack-glance-api.service openstack-glance-registry.service Done!"
# sleep 3
	fi	
}

function func_glance_remove_sqllite_ubuntu()
{
	echo [$(hostname)] func_glance_remove_sqllite_ubuntu..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
			# Because this configuration uses a SQL database server, you can remove the SQLite database file:
		rm -f /var/lib/glance/glance.sqlite
	fi
}

function func_glance_verify_operation()
{
	echo [$(hostname)] func_glance_verify_operation..............................................................................
	# 4.2 Verify operation
	# (1) In each client environment script, configure the Image service client to use API version 2.0:

	echo "export OS_IMAGE_API_VERSION=2" | tee -a ~student/env/admin-openrc.sh ~student/env/demo-openrc.sh
	# (2) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh

	# (3) Create a temporary local directory:
	# mkdir /tmp/images

	# (4) Download the source image into it:
	if [ "$USINF_HOST_SCP_IMAGES" != "1" ];
	then
		if [ "$CODETREE_USE_LOCAL_REPOSITORY" = "0" ];
		then
			wget -P /tmp/images http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
		else
			wget -P /tmp/images http://${IP_BASE_SERVER}/cirros-cloud/0.3.4/cirros-0.3.4-x86_64-disk.img
		fi
	fi
	# (5) Upload the image to the Image service using the QCOW2 disk format, bare container format, and public visibility so all projects can access it:


	glance image-create --name "cirros-0.3.4-x86_64" --file /tmp/images/cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --visibility public --progress


	# (6) Confirm upload of the image and validate attributes:
	glance image-list

	# # Delete image
	# declare -a VM_TEMP_IMAGE=(`glance image-list | grep cirros-0.3.4-x86_64 | awk '{print $2}'`)
	# echo ${VM_TEMP_IMAGE}
	# glance image-delete ${VM_TEMP_IMAGE}

	# # (7) Remove the temporary local directory and source image:
	# rm -rf /tmp/images
}

function func_glance_get_images()
{
	echo [$(hostname)] func_glance_get_images..............................................................................

		# mkdir /tmp/images


	if [ "$USING_IMAGE_UBUNTU14" = "1" ];
	then
		# Create ubuntu image 
		if [ "$USINF_HOST_SCP_IMAGES" != "1" ];
		then
			wget -P /tmp/images http://uec-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
		fi
		glance image-create --name "ubuntu14_x86_64" --file /tmp/images/trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --visibility public --progress
		rm /tmp/images/trusty-server-cloudimg-amd64-disk1.img
	fi

		# Create CentOS-7 image 
	if [ "$USING_IMAGE_CENTOS7" = "1" ];
	then
		if [ "$USINF_HOST_SCP_IMAGES" != "1" ];
		then
			wget -P /tmp/images http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1503.qcow2
		fi
		glance image-create --name "centos-7_x86_64" --file /tmp/images/CentOS-7-x86_64-GenericCloud-1503.qcow2 --disk-format qcow2 --container-format bare --visibility public --progress
		rm /tmp/images/CentOS-7-x86_64-GenericCloud-1503.qcow2
	fi

		# rm -rf /tmp/images
		# (6) Confirm upload of the image and validate attributes:
		glance image-list
	

}