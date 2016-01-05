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
# Chapter : 4. Add the Image service
# Node : Controller

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.05_compute.sh

# ======================================================================================================
# 5. Add the Compute service
# export DATABASE_ADMIN_PASS=pass_for_db
# export NOVA_DBPASS=pass_for_db_nova
# export NOVA_PASS=pass_for_nova
# 5.1 Install and configure controller node
# (1) To configure prerequisites
# (1-1) To create the database, complete these steps:
# Create the nova database:

func_common_database_create_grant nova ${NOVA_DBPASS}
