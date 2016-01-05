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
# Chapter : 3. Add the Identity service
# Node : controller

# Load Env global variables
source ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.03_identity.sh

# Configure the authentication token:
export OS_TOKEN=${ADMIN_TOKEN}

# Configure the endpoint URL:
export OS_URL=http://controller:35357/v2.0

# 3.3 Create projects, users, and roles
# (1) To create tenants, users, and roles

# 3.3 Create projects, users, and roles
# (1) To create tenants, users, and roles
func_common_create_project_user_role "Admin Project" admin ${ADMIN_PASS} admin admin


# (2) This guide uses a service project that contains a unique user for each service that you add to your environment.
# Create the service project:
func_common_create_project "Service Project" service

# (3) Regular (non-admin) tasks should use an unprivileged project and user. As an example, this guide creates the demo project and user.
func_common_create_project_user_role "Demo Project" demo ${DEMO_PASS} user demo


