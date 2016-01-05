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
# Chapter : 9. Add Object Storage
# Node : Controller

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.09_objectstorage.sh


# ============================================================================================
# 9. Add Object Storage
# 9.1 Install and configure the controller node
# (1) To configure prerequisites
source ~student/env/admin-openrc.sh
# (1-1) To create the Identity service credentials, complete these steps:
# (1-2) Create the Object Storage service API endpoint:
func_swift_configure_prerequisites_controller_node

# (2) To install and configure the controller node components
# (2-1) Install the packages:
# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:


# 9.2 Install and configure the storage nodes
# 9.3 Create initial rings
# 9.4 Finalize installation
# 9.5 Verify operation

