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
# Chapter : COMMON
# Node : HOST
# 
# Set environment and declare global variables
#
# ============================================================================================
# Chapter : 2. Basic environment
# Node : HOST
# 

# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh

source ./kilo-function.host.sh

# ============================================================================================
# Run Install

# 2.1 필요 Package 설치
if [ ${USING_NODE_CONTROLLER} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi	

if [ ${USING_NODE_COMPUTE} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_COMPUTE1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_COMPUTE2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_NETWORK} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_NETWORK1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_NETWORK2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_BLOCK1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi	

if [ ${USING_NODE_BLOCK2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi

if [ ${USING_NODE_OBJECT1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi		

if [ ${USING_NODE_OBJECT2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-2.1.all.sh" &
fi	

wait
# ============================================================================================
# 2. Basic environment
# 2.2 Before you begin
# 2.3 Security (NOP)
# 2.4 Networking (NOP)
# 2.5 Network Time Protocol (NTP) (NOP)
if [ ${USING_NODE_CONTROLLER} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.5.controller.sh" &
fi

if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.5.controller.sh" &
fi

if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.5.controller.sh" &
fi	

if [ ${USING_NODE_COMPUTE} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_COMPUTE1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_COMPUTE2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_NETWORK} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_NETWORK1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_NETWORK2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_BLOCK1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi	

if [ ${USING_NODE_BLOCK2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi

if [ ${USING_NODE_OBJECT1} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi		

if [ ${USING_NODE_OBJECT2} = "1" ]; then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-2.5.other-conrtoller.sh" &
fi	

wait
# 
# 2.6 OpenStack packages 설치
echo "[CALL kilo-2.6.x.all.sh]================================================================"
if [ "$CODETREE_USE_LOCAL_REPOSITORY" = "0" ];
then
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi	

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi

	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi		

	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.a.all.sh" &
	fi	
else
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi	

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi

	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi		

	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-2.6.b.all.sh" &
	fi		
fi

wait

# 2.7 SQL database
#(1) To install and configure the database server
# (1-1) Install the packages:
# (1-2) Create and edit the /etc/my.cnf.d/mariadb_openstack.cnf file and complete the following actions:
# (2) To finalize installation
# (2-1) Start the database service and configure it to start when the system boots:

if [ ${USING_NODE_CONTROLLER} = "1" ]; then
	echo "[CALL kilo-2.7.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.7.1.controller.sh ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}"
	# (2-2) Secure the database service including choosing a suitable password for the root account:
	echo "[CALL kilo-2.7.2.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.7.2.controller.sh"
	# 2.8 Message queue
	# (1) To install the message queue service
	echo "[CALL kilo-2.8.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-2.8.1.controller.sh"
fi

if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
	echo "[CALL kilo-2.7.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.7.1.controller.sh ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}"
	# (2-2) Secure the database service including choosing a suitable password for the root account:
	echo "[CALL kilo-2.7.2.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.7.2.controller.sh"
	# 2.8 Message queue
	# (1) To install the message queue service
	echo "[CALL kilo-2.8.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-2.8.1.controller.sh"
fi

if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
	echo "[CALL kilo-2.7.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.7.1.controller.sh ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}"
	# (2-2) Secure the database service including choosing a suitable password for the root account:
	echo "[CALL kilo-2.7.2.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.7.2.controller.sh"
	# 2.8 Message queue
	# (1) To install the message queue service
	echo "[CALL kilo-2.8.1.controller.sh]======================================================"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-2.8.1.controller.sh"
fi	
