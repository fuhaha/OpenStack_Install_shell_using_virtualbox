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
# Chapter : 2. Basic environment
# Node : COMMON
# 

# ============================================================================================
# Init  VM 
echo "[kilo-step-01.sh]===========================================================================>>START>>"
./kilo-step-01.sh
echo "[kilo-step-01.sh]==============================================================================>>END>>"
# ============================================================================================
# Run Install

# ============================================================================================
# 2. Basic environment
echo "[kilo-step-02.sh]===========================================================================>>START>>"
./kilo-step-02.sh
echo "[kilo-step-02.sh]==============================================================================>>END>>"
# ============================================================================================
# 3. Add the Identity service
echo "[kilo-step-03.sh]===========================================================================>>START>>"
./kilo-step-03.sh
echo "[kilo-step-03.sh]==============================================================================>>END>>"

# ============================================================================================
# 4. Add the Image service
echo "[kilo-step-04.sh]===========================================================================>>START>>"
./kilo-step-04.sh
echo "[kilo-step-04.sh]==============================================================================>>END>>"

# ============================================================================================
# 5. Add the Compute service
echo "[kilo-step-05.sh]===========================================================================>>START>>"
./kilo-step-05.sh
echo "[kilo-step-05.sh]==============================================================================>>END>>"

# ============================================================================================
# 6 Add a networking component
echo "[kilo-step-06.sh]===========================================================================>>START>>"
./kilo-step-06.sh
echo "[kilo-step-06.sh]==============================================================================>>END>>"
# ============================================================================================
# 7 Add the dashboard
echo "[kilo-step-07.sh]===========================================================================>>START>>"
./kilo-step-07.sh
echo "[kilo-step-07.sh]==============================================================================>>END>>"

# ======================================================================================================
# 8.  Add the Block Storage service
echo "[kilo-step-08.sh]===========================================================================>>START>>"
./kilo-step-08.sh
echo "[kilo-step-08.sh]==============================================================================>>END>>"

# ============================================================================================
# 9. Add Object Storage
echo "[kilo-step-09.sh]===========================================================================>>START>>"
./kilo-step-09.sh
echo "[kilo-step-09.sh]==============================================================================>>END>>"






