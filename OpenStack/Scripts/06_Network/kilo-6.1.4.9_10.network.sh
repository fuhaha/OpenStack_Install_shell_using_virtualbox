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
# Chapter : 6 Add a networking component
# Node : Network

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.06_network.sh


# ============================================================================================
# 6 Add a networking component
# 6.1 OpenStack Networking (neutron)
# 6.1.1 OpenStack Networking
# 6.1.2 Networking concepts
# 6.1.3 Install and configure controller node
# 6.1.4 Install and configure network node

# (9) To configure the Open vSwitch (OVS) service
# (9-1) Start the OVS service and configure it to start when the system boots:
# (9-2) Add the external bridge:
func_neutron_configure_OVS_service_network_node


# (10) To finalize the installation
# (10-1) The Networking service initialization scripts expect a symbolic link /etc/neutron/plugin.ini pointing to the ML2 plug-in 
# (10-2) Start the Networking services and configure them to start when the system boots:
func_neutron_start_service_network_node


