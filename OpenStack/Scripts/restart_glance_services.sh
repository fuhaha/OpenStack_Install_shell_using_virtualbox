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

# glance service ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; glance image-list"

echo "[glance service restart]=========================================="
if [ "$TARGET_OS_UBUNTU" = "1" ];
then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service glance-registry restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service glance-api restart"
else
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "systemctl start openstack-glance-api.service openstack-glance-registry.service"
fi

# glance
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; glance image-list"

