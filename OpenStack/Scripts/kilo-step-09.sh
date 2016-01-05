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
# Chapter :  9. Add Object Storage
# Node : HOST
# 
# Set environment and declare global variables
# ============================================================================================

# Load Env global variables
source ./common/kilo-perform-vars.common.sh

source ./kilo-function.host.sh

# ============================================================================================
# 9. Add Object Storage
# 9.1 Install and configure the controller node
# (1) To configure prerequisites
# (1-1) To create the Identity service credentials, complete these steps:
# ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "pip install --upgrade python-openstackclient"


echo "[CALL scripts/kilo-9.1.1.controller.sh]============================================"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.1.1.controller.sh"

# (1-2) Create the Object Storage service API endpoint:

# (2) To install and configure the controller node components
# (2-1) Install the packages:
# (2-2) Obtain the proxy service configuration file from the Object Storage source repository:
# (2-3) Edit the /etc/swift/proxy-server.conf file and complete the following actions:
echo "[CALL scripts/kilo-9.1.2.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.1.2.controller.sh"

# ============================================================================================
# 9.2 Install and configure the storage nodes
# (1) Configure unique items on the first storage node:
# (2) Configure unique items on the second storage node:
# (3) Configure shared items on both storage nodes:
# (4) Edit the /etc/rsyncd.conf file and add the following to it:
# (5) Start the rsyncd service and configure it to start when the system boots:
echo "[CALL scripts/kilo-9.2.object1.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-9.2.object1.sh"

echo "[CALL scripts/kilo-9.2.object2.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-9.2.object2.sh"

# ============================================================================================
# 9.3 Create initial rings
echo "[CALL scripts/kilo-9.3.1_4.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.3.1_4.controller.sh"

# 9.3.4 Distribute ring configuration files
# Copy the account.ring.gz, container.ring.gz, and object.ring.gz files to the /etc/swift directory on each storage node and any additional nodes running the proxy service.
mkdir ~/OpenStack/Scripts/object
scp root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/etc/swift/account.ring.gz   ~/OpenStack/Scripts/object/
scp root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/etc/swift/container.ring.gz   ~/OpenStack/Scripts/object/
scp root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/etc/swift/object.ring.gz   ~/OpenStack/Scripts/object/

scp ~/OpenStack/Scripts/object/account.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:/etc/swift/
scp ~/OpenStack/Scripts/object/container.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:/etc/swift/
scp ~/OpenStack/Scripts/object/object.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:/etc/swift/

scp ~/OpenStack/Scripts/object/account.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:/etc/swift/
scp ~/OpenStack/Scripts/object/container.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:/etc/swift/
scp ~/OpenStack/Scripts/object/object.ring.gz  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:/etc/swift/

# ============================================================================================
# 9.4 Finalize installation
echo "[CALL scripts/kilo-9.4.1_2.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.4.1_2.controller.sh"

# (3) Copy the swift.conf file to the /etc/swift directory on each storage node and any additional nodes running the proxy service.
scp root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}:/etc/swift/swift.conf   ~/OpenStack/Scripts/object/
scp ~/OpenStack/Scripts/object/swift.conf  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}:/etc/swift/
scp ~/OpenStack/Scripts/object/swift.conf  root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}:/etc/swift/
rm -rf  ~/OpenStack/Scripts/object/

echo "[CALL scripts/kilo-9.4.4_5.controller.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.4.4_5.controller.sh"

echo "[CALL scripts/kilo-9.4.4_6.object1.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "cd ~student/scripts/; ~student/scripts/kilo-9.4.4_6.object1.sh"

echo "[CALL scripts/kilo-9.4.4_6.object2.sh]============================================"
ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "cd ~student/scripts/; ~student/scripts/kilo-9.4.4_6.object2.sh"

# 9.5 Verify operation
echo "[CALL scripts/kilo-9.5.controller.sh]============================================"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.5.controller.sh"


