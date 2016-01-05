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
# Chapter :  6 Add a networking component
# Node : HOST
# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh

source ./kilo-function.host.sh

# OpenStack Networking (neutron)
# 6 Add a networking component

if [ "$NETWORK_USE_LEGACY" = "0" ];
then
	################################################################################################################################################
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# (1) To configure prerequisites
	# echo "[CALL kilo-6.1.3.1-1.controller.sh]=========================================="
	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.1-1.controller.sh"
	# # (1-2) Source the admin credentials to gain access to admin-only CLI commands:
	# echo "[CALL scripts/kilo-6.1.3.1-2-4.controller.sh]=========================================="
	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.1-2-4.controller.sh" 

	echo "[CALL kilo-6.1.3.1.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.1.controller.sh"

	# (2) To install the Networking components
	# (3) To configure the Networking server component
	# (4) To configure the Modular Layer 2 (ML2) plug-in
	# (5) To configure Compute to use Networking
	# (6) To finalize installation
	echo "[CALL kilo-6.1.3.2-6.controller.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.2-6.controller.sh"
	# (7) Verify operation
	echo "[CALL kilo-6.1.3.7.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.3.7.controller.sh"

	################################################################################################################################################
	# 6.1.4 Install and configure network node
	# (1) Install and configure network node
	# (2) To configure prerequisites
	# (3) To install the Networking components
	# (4) To configure the Networking common components
	# (5) To configure the Modular Layer 2 (ML2) plug-in
	# (6) To configure the Layer-3 (L3) agent
	# (7) To configure the DHCP agent
	# (8) To configure the metadata agent
	# (8-1) Edit the /etc/neutron/metadata_agent.ini file and complete the following actions:
	echo "[CALL kilo-6.1.4.1_8-1.network.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.1_8-1.network.sh"
	
	# (8-2) On the controller node, edit the /etc/nova/nova.conf file and complete the following action:
	echo "[CALL kilo-6.1.4.8-2_8-3.controller.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.8-2_8-3.controller.sh"
	
	# (9) To configure the Open vSwitch (OVS) service
	# (10) To finalize the installation
	echo "[CALL kilo-6.1.4.9_10.network.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.9_10.network.sh"
	# echo "[CALL scripts/kilo-6.1.4.10-1.network.sh]=========================================="
	# ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.10-1.network.sh"

	# (11) Verify operation
	echo "[CALL kilo-6.1.4.11.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.4.11.controller.sh"


	################################################################################################################################################
	# 6.1.5 Install and configure compute node
	echo "[CALL kilo-6.1.5.compute.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-6.1.5.compute.sh"

	# 6.1.6 Verify operation
	echo "[CALL kilo-6.1.6.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.1.6.controller.sh"

	# 6.3 Create initial networks
	echo "[CALL kilo-6.3.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.3.controller.sh"	
else
	# 6.2 Legacy networking (nova-network)
	# 6.2.1 Configure controller node
	echo "[CALL scripts/kilo-6.2.1.controller.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.2.1.controller.sh"
	# 6.2.2 Configure compute node
	echo "[CALL scripts/kilo-6.2.2.compute.sh]=========================================="
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "cd ~student/scripts/; ~student/scripts/kilo-6.2.2.compute.sh"
	# 6.2.3 Create initial network
	echo "[CALL scripts/kilo-6.2.3.controller.sh]=========================================="
	ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-6.2.3.controller.sh"
fi
 