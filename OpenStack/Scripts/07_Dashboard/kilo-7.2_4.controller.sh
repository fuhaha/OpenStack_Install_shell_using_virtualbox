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
# Chapter : 7. Add the dashboard
# Node : Controller

# Load Env global variables
source  ./kilo-perform-vars.common.sh
# Load Common functions
source ./kilo-function.00_common.sh
source ./kilo-function.07_dashboard.sh

# ============================================================================================
# 7 Add the dashboard
# 7.1 System requirements
# 7.2 Install and configure
# (1) To install the dashboard components
# (1-1) Install the packages:
func_horizon_install_package

# (2) To configure the dashboard
# (2-1) Edit the /etc/openstack-dashboard/local_settings file and complete the following actions:
func_horizon_configure


# (3) To finalize installation
# (3-1) On RHEL and CentOS, configure SELinux to permit the web server to connect to OpenStack services:
# (3-2) Due to a packaging bug, the dashboard CSS fails to load properly. Run the following command to resolve this issue:
# (3-3) Start the web server and session storage service and configure them to start when the system boots:
func_horizon_finalize_installation

# 7.3 Verify operation
func_horizon_verify_operation
# 7.3 Next steps

