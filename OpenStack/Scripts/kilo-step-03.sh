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
# Chapter : 3. Add the Identity service
# Node : HOST
# 

# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh
# Load Env global variables
source ./kilo-function.host.sh


if [ ${USING_NODE_CONTROLLER} = "1" ]; then
	# ============================================================================================
	# 3. Add the Identity service
	# 3.1 Install and configure
	# (1) To configure prerequisites
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-3.1.1.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.1.1.controller.sh"

	# (2) To install and configure the Identity service components
	# (3) To configure the Apache HTTP server
	# (4) To finalize installation
	echo "[CALL kilo-3.1.2-4.controller.sh]===================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.1.2-4.controller.sh"

	# 3.2 Create the service entity and API endpoint
	# (1) To configure prerequisites
	# (2) To create the service entity and API endpoint

	echo "[CALL kilo-3.2.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.2.controller.sh"

	# 3.3 Create projects, users, and roles
	# (1) To create tenants, users, and roles
	# (2) This guide uses a service project that contains a unique user for each service that you add to your environment.
	# (3)Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
	echo "[CALL kilo-3.3.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.3.controller.sh"

	# 3.4 Verify operation
	echo "[CALL kilo-3.4.controller.sh]======================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"

	# 3.5 Create OpenStack client environment scripts
	echo "[CALL kilo-3.5.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-3.5.controller.sh"
fi

if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
	# ============================================================================================
	# 3. Add the Identity service
	# 3.1 Install and configure
	# (1) To configure prerequisites
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-3.1.1.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.1.1.controller.sh"

	# (2) To install and configure the Identity service components
	# (3) To configure the Apache HTTP server
	# (4) To finalize installation
	echo "[CALL kilo-3.1.2-4.controller.sh]===================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.1.2-4.controller.sh"

	# 3.2 Create the service entity and API endpoint
	# (1) To configure prerequisites
	# (2) To create the service entity and API endpoint

	echo "[CALL kilo-3.2.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.2.controller.sh"

	# 3.3 Create projects, users, and roles
	# (1) To create tenants, users, and roles
	# (2) This guide uses a service project that contains a unique user for each service that you add to your environment.
	# (3)Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
	echo "[CALL kilo-3.3.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.3.controller.sh"

	# 3.4 Verify operation
	echo "[CALL kilo-3.4.controller.sh]======================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"

	# 3.5 Create OpenStack client environment scripts
	echo "[CALL kilo-3.5.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "cd ~student/scripts/; ~student/scripts/kilo-3.5.controller.sh"
fi

if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
	# ============================================================================================
	# 3. Add the Identity service
	# 3.1 Install and configure
	# (1) To configure prerequisites
	# Create the keystone database:
	# Grant proper access to the keystone database:
	echo "[CALL kilo-3.1.1.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.1.1.controller.sh"

	# (2) To install and configure the Identity service components
	# (3) To configure the Apache HTTP server
	# (4) To finalize installation
	echo "[CALL kilo-3.1.2-4.controller.sh]===================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.1.2-4.controller.sh"

	# 3.2 Create the service entity and API endpoint
	# (1) To configure prerequisites
	# (2) To create the service entity and API endpoint

	echo "[CALL kilo-3.2.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.2.controller.sh"

	# 3.3 Create projects, users, and roles
	# (1) To create tenants, users, and roles
	# (2) This guide uses a service project that contains a unique user for each service that you add to your environment.
	# (3)Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
	echo "[CALL kilo-3.3.controller.sh]======================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.3.controller.sh"

	# 3.4 Verify operation
	echo "[CALL kilo-3.4.controller.sh]======================================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.4.controller.sh"

	# 3.5 Create OpenStack client environment scripts
	echo "[CALL kilo-3.5.controller.sh]========================================================"
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "cd ~student/scripts/; ~student/scripts/kilo-3.5.controller.sh"
fi
