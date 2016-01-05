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
# Chapter :  7 Add the dashboard
# Node : HOST
# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh

source ./kilo-function.host.sh

# ============================================================================================
# 7 Add the dashboard
# 7.1 System requirements
# 7.2 Install and configure
# (1) To install the dashboard components
# (2) To configure the dashboard
# (3) To finalize installation
echo "[CALL scripts/kilo-7.2_4.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-7.2_4.controller.sh"

# 7.3 Verify operation
# 7.3 Next steps

