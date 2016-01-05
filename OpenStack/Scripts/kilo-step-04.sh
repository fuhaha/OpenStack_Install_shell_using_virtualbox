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
# Node : HOST
# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh
# Load Env global variables
source ./kilo-function.host.sh


if [ ${USING_NODE_CONTROLLER} = "1" ]; then
	# ============================================================================================
	# 4. Add the Image service
	# 4.1 Install and configure
	# (1) To configure prerequisites
	# (1-1) To create the database, complete these steps:
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-4.1.1-1.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-1.controller.sh"
	# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
	# (1-3) To create the service credentials, complete these steps:
	# (1-4) Create the Image service API endpoint:
	echo "[CALL kilo-4.1.1-2-4.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-2-4.controller.sh"
	# (2) To install and configure the Image service components
	# (2-1) Install the packages:
	# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
	# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
	# (2-4) Populate the Image service database:
	# (3) To finalize installation
	echo "[CALL kilo-4.1.2-1-3.controller.sh]========================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-4.1.2-1-3.controller.sh"
	# 4.2 Verify operation
	# (1) In each client environment script, configure the Image service client to use API version 2.0:

	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "mkdir /tmp/images"

	if [ "$USINF_HOST_SCP_IMAGES" = "1" ];	
	then
		scp ${HOME_SCRIPT_DIR}/images/cirros-0.3.4-x86_64-disk.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/tmp/images

		if [ "$USING_IMAGE_UBUNTU14" = "1" ];
		then
			scp ${HOME_SCRIPT_DIR}/images/trusty-server-cloudimg-amd64-disk1.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/tmp/images
		fi

		if [ "$USING_IMAGE_CENTOS7" = "1" ];
		then
			scp ${HOME_SCRIPT_DIR}/images/CentOS-7-x86_64-GenericCloud-1503.qcow2 student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/tmp/images
		fi
	fi
	echo "[CALL kilo-4.2.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"

	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "rm -rf /tmp/images"
fi

if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
	# ============================================================================================
	# 4. Add the Image service
	# 4.1 Install and configure
	# (1) To configure prerequisites
	# (1-1) To create the database, complete these steps:
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-4.1.1-1.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-1.controller.sh"
	# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
	# (1-3) To create the service credentials, complete these steps:
	# (1-4) Create the Image service API endpoint:
	echo "[CALL kilo-4.1.1-2-4.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-2-4.controller.sh"
	# (2) To install and configure the Image service components
	# (2-1) Install the packages:
	# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
	# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
	# (2-4) Populate the Image service database:
	# (3) To finalize installation
	echo "[CALL kilo-4.1.2-1-3.controller.sh]========================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-4.1.2-1-3.controller.sh"
	# 4.2 Verify operation
	# (1) In each client environment script, configure the Image service client to use API version 2.0:
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "mkdir /tmp/images"

	if [ "$USINF_HOST_SCP_IMAGES" = "1" ];	
	then
		scp ${HOME_SCRIPT_DIR}/images/cirros-0.3.4-x86_64-disk.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}:/tmp/images

		if [ "$USING_IMAGE_UBUNTU14" = "1" ];
		then
			scp ${HOME_SCRIPT_DIR}/images/trusty-server-cloudimg-amd64-disk1.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}:/tmp/images
		fi

		if [ "$USING_IMAGE_CENTOS7" = "1" ];
		then
			scp ${HOME_SCRIPT_DIR}/images/CentOS-7-x86_64-GenericCloud-1503.qcow2 student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}:/tmp/images
		fi
	fi
	echo "[CALL kilo-4.2.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"

	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "rm -rf /tmp/images"
fi

if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
	# ============================================================================================
	# 4. Add the Image service
	# 4.1 Install and configure
	# (1) To configure prerequisites
	# (1-1) To create the database, complete these steps:
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-4.1.1-1.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-1.controller.sh"
	# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
	# (1-3) To create the service credentials, complete these steps:
	# (1-4) Create the Image service API endpoint:
	echo "[CALL kilo-4.1.1-2-4.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-4.1.1-2-4.controller.sh"
	# (2) To install and configure the Image service components
	# (2-1) Install the packages:
	# (2-2) Edit the /etc/glance/glance-api.conf file and complete the following actions:
	# (2-3) Edit the /etc/glance/glance-registry.conf file and complete the following actions:
	# (2-4) Populate the Image service database:
	# (3) To finalize installation
	echo "[CALL kilo-4.1.2-1-3.controller.sh]========================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-4.1.2-1-3.controller.sh"
	# 별도의 image 증록및 점검 생략
	# 4.2 Verify operation
	# (1) In each client environment script, configure the Image service client to use API version 2.0:
	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "mkdir /tmp/images"

	# if [ "$USINF_HOST_SCP_IMAGES" = "1" ];	
	# then
	# 	scp ${HOME_SCRIPT_DIR}/images/cirros-0.3.4-x86_64-disk.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}:/tmp/images

	# 	if [ "$USING_IMAGE_UBUNTU14" = "1" ];
	# 	then
	# 		scp ${HOME_SCRIPT_DIR}/images/trusty-server-cloudimg-amd64-disk1.img  student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}:/tmp/images
	# 	fi

	# 	if [ "$USING_IMAGE_CENTOS7" = "1" ];
	# 	then
	# 		scp ${HOME_SCRIPT_DIR}/images/CentOS-7-x86_64-GenericCloud-1503.qcow2 student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}:/tmp/images
	# 	fi
	# fi
	# echo "[CALL kilo-4.2.controller.sh]========================================================"
	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-4.2.controller.sh"

	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "rm -rf /tmp/images"
fi