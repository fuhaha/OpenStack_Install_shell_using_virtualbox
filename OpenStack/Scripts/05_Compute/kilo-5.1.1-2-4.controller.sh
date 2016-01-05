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
# Chapter :  5. Add the Compute service
# Node : Controller

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.05_compute.sh

# 5. Add the Compute service
# 5.1 Install and configure controller node

# (1-2) Source the admin credentials to gain access to admin-only CLI commands:
source ~student/env/admin-openrc.sh
# (1-3) To create the service credentials, complete these steps:


# func_common_create_user_role [user] [passwd] [role] [project]
func_common_create_user_role nova ${NOVA_PASS} admin service

# func_common_create_service_and_endpoint [name]  [description] [server-name] [publicurl] [internalurl] [adminurl]
func_common_create_service_and_endpoint nova  "OpenStack Compute" compute \
	http://controller:8774/v2/%\(tenant_id\)s \
	http://controller:8774/v2/%\(tenant_id\)s \
	http://controller:8774/v2/%\(tenant_id\)s

