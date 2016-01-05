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
# Chapter :  8. Add the Compute service
# Node : HOST
#
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh

source ./kilo-function.host.sh

# ============================================================================================
# 8. Add the Compute service
# 8.1 Install and configure controller node
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
# (1-3) To create the service credentials, complete these steps:
# (1-4) Create the Compute service API endpoint:
echo "[CALL scripts/kilo-8.1.1-1.controller.sh]============================================"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-8.1.1.controller.sh"
# (2) To install and configure Compute controller components
# (3) To finalize installation
echo "[CALL scripts/kilo-8.1.2-3.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-8.1.2-3.controller.sh"

# 8.2 Install and configure a storage node
# (1) To install and configure the Compute hypervisor components
# (2) To finalize installation
echo "[CALL scripts/kilo-8.2.1-3.block1.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "cd ~student/scripts/; ~student/scripts/kilo-8.2.1-3.block1.sh"

# 8.3 Verify operation
echo "[CALL scripts/kilo-8.3.1_6.controller.sh]============================================"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-8.3.1_6.controller.sh"


