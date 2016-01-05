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
# Node : object1

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.09_objectstorage.sh

# ======================================================================================================
# 9.2 Install and configure the storage nodes
# 9.2.1 To configure prerequisites
# (1) Configure unique items on the first storage node:
# (2) Configure unique items on the second storage node:
# (3) Configure shared items on both storage nodes:
# (4) Edit the /etc/rsyncd.conf file and add the following to it:
# (5) Start the rsyncd service and configure it to start when the system boots:

func_swift_configure_prerequisites_object_node ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}

# 9.2.2 Install and configure storage node components
# (1) Install the packages:
func_swift_install_package_object_node


# (2) Obtain the accounting, container, object, container-reconciler, and object-expirer service configuration files from the Object Storage source repository:
# (3) Edit the /etc/swift/account-server.conf file and complete the following actions:
# (4) Edit the /etc/swift/container-server.conf file and complete the following actions:
# (5) Edit the /etc/swift/object-server.conf file and complete the following actions:
# (6) Ensure proper ownership of the mount point directory structure:
# (7) Create the recon directory and ensure proper ownership of it:
func_swift_configure_object_node ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}

# 9.3 Create initial rings
# 9.4 Finalize installation
# 9.5 Verify operation


