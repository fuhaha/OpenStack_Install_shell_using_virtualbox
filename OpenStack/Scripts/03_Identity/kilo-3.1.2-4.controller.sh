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

# ======================================================================================================
# 3. Add the Identity service
# export ADMIN_TOKEN=3986891fe916bc6dd730
# export DATABASE_ADMIN_PASS=pass_for_db
# export KEYSTONE_DBPASS=pass_for_db_keystone
# 3.1 Install and configure

# openssl rand -hex 10
# (2) To install and configure the Identity service components
# [root계정]
# Run the following command to install the packages:
func_keystone_install_package

# Start the Memcached service and configure it to start when the system boots:
func_keystone_start_memcached_service

# sleep 2
# Edit the /etc/keystone/keystone.conf file and complete the following actions:
# (3) To configure the Apache HTTP server
func_keystone_configure

# (4) To finalize installation
# Restart the Apache HTTP server:
func_keystone_start_httpd_service
# sleep 2

# By default, the Ubuntu packages create a SQLite database
# Because this configuration uses a SQL database server, you can remove the SQLite database file:

func_keystone_remove_sqllite_ubuntu
