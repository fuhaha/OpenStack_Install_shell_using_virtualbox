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
# Node : Controller

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

# (2) To install the Networking components
# (2-1) Install the packages:
func_neutron_install_package_controller_node

# (3) To configure the Networking server component
# (3-1) Edit the /etc/neutron/neutron.conf file and complete the following actions:
# (4) To configure the Modular Layer 2 (ML2) plug-in
# (4-1) Edit the /etc/neutron/plugins/ml2/ml2_conf.ini file and complete the following actions:
# (5) To configure Compute to use Networking
# (5-1) Edit the /etc/nova/nova.conf file on the controller node and complete the following actions:
func_neutron_configure_controller_node

# (6) To finalize installation
# (6-1) The Networking service initialization scripts expect a symbolic link...
func_neutron_start_service_controller_node
