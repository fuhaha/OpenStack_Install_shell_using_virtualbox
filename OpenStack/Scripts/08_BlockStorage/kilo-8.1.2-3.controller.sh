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
# Chapter : 8. Add the Block Storage service
# Node : Controller

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.08_blockstorage.sh

# ======================================================================================================
# 8. Add the Block Storage service
# 8.1 Install and configure controller node
 
# (2) To install and configure Block Storage controller components
# (2-1) Install the packages:
func_cinder_install_package_controller_node

# (2-2) Copy the /usr/share/cinder/cinder-dist.conf file to /etc/cinder/cinder.conf.
# (2-3) Edit the /etc/cinder/cinder.conf file and complete the following actions:
# (2-4) To finalize installation
func_cinder_configure_controller_node

# (3) To finalize installation
func_cinder_finalize_installation_controller_node
