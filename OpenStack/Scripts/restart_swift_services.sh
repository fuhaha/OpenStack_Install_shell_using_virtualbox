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
# Node : Guest ALL

source ./common/kilo-perform-vars.common.sh

# swift service ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 stat"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 list"

if [ "$TARGET_OS_UBUNTU" = "1" ];
then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "swift-init all restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "swift-init all restart"
else
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "systemctl start openstack-swift-account.service openstack-swift-account-auditor.service openstack-swift-account-reaper.service openstack-swift-account-replicator.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "systemctl start openstack-swift-container.service openstack-swift-container-auditor.service openstack-swift-container-replicator.service openstack-swift-container-updater.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "systemctl start openstack-swift-object.service openstack-swift-object-auditor.service openstack-swift-object-replicator.service openstack-swift-object-updater.service"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "systemctl start openstack-swift-account.service openstack-swift-account-auditor.service openstack-swift-account-reaper.service openstack-swift-account-replicator.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "systemctl start openstack-swift-container.service openstack-swift-container-auditor.service openstack-swift-container-replicator.service openstack-swift-container-updater.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "systemctl start openstack-swift-object.service openstack-swift-object-auditor.service openstack-swift-object-replicator.service openstack-swift-object-updater.service"
fi

###############################################################################################################

ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 stat"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 list"