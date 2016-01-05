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


# neutron service ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; neutron agent-list"

echo "[neutron service restart]=========================================="
if [ "$TARGET_OS_UBUNTU" = "1" ];
then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service neutron-server restart"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service neutron-server restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service openvswitch-switch restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service neutron-plugin-openvswitch-agent restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service neutron-l3-agent restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service neutron-dhcp-agent restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "service neutron-metadata-agent restart"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "service openvswitch-switch restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "service neutron-plugin-openvswitch-agent restart"
else
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "systemctl restart neutron-server.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "systemctl restart openstack-nova-api.service"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "systemctl restart openvswitch.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "systemctl restart neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "systemctl restart openvswitch.service"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "systemctl restart neutron-openvswitch-agent.service"
fi


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

# nova service ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; nova service-list"

echo "[Nova service restart]=========================================="
if [ "$TARGET_OS_UBUNTU" = "1" ];
then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "service nova-compute restart"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service nova-cert restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service nova-consoleauth restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service nova-scheduler restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service nova-conductor restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service nova-novncproxy restart"
else
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "systemctl restart libvirtd.service openstack-nova-compute.service"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "systemctl restart openstack-nova-api.service openstack-nova-cert.service openstack-nova-consoleauth.service openstack-nova-scheduler.service openstack-nova-conductor.service openstack-nova-novncproxy.service"	
fi	

# cinder servoce ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; cinder service-list"
echo "[cinder service restart]=========================================="

if [ "$TARGET_OS_UBUNTU" = "1" ];
then
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service cinder-scheduler restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "service cinder-api restart"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "service tgt restart"
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "service cinder-volume restart"
else
	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service"

	ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "systemctl start openstack-cinder-volume.service target.service"
fi

# swift service ========================================================================================================================
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 stat"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 list"

echo "[swift service restart]=========================================="
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
# Status #####################################################################################################
# keystone
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; openstack token issue"

# glance
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; glance image-list"

# nova
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; nova service-list"

# neutron
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; neutron agent-list"

# cinder
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; cinder service-list"

# swift
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 stat"
ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student; source ~student/env/admin-openrc.sh; swift -V 3 list"

ssh student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "cd ~student/scripts/; ~student/scripts/kilo-9.5.controller.sh"
