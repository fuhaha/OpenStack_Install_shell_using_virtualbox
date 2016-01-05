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

##################################################################################################3
# Utility

function func_poweron_centos_base()
{
	vboxmanage startvm Cent7Base --type headless

	while ! ping -c1 10.0.0.100 &>/dev/null; do :; done
	sleep 10
	# for repos sync
	ssh root@10.0.0.100 "mount -t vboxsf -o rw,uid=\$(id -u apache),gid=\$(id -g apache) repos /var/www/html/repos"		
}

function func_poweron_centos_controller()
{
	vboxmanage startvm cent7-controller --type headless
}

function func_poweron_centos_controller1()
{
	vboxmanage startvm cent7-controller1 --type headless
}

function func_poweron_centos_controller2()
{
	vboxmanage startvm cent7-controller2 --type headless
}

function func_poweron_centos_network()
{
	vboxmanage startvm cent7-network --type headless
}

function func_poweron_centos_network1()
{
	vboxmanage startvm cent7-network1 --type headless	
}

function func_poweron_centos_network2()
{
	vboxmanage startvm cent7-network2 --type headless
}

function func_poweron_centos_compute()
{
	vboxmanage startvm cent7-compute --type headless	
}

function func_poweron_centos_compute1()
{
	vboxmanage startvm cent7-compute1 --type headless		
}

function func_poweron_centos_compute2()
{
	vboxmanage startvm cent7-compute2 --type headless	
}

function func_poweron_centos_block1()
{
	vboxmanage startvm cent7-block1 --type headless
}

function func_poweron_centos_block2()
{
	vboxmanage startvm cent7-block2 --type headless
}

function func_poweron_centos_object1()
{
	vboxmanage startvm cent7-object1 --type headless	
}

function func_poweron_centos_object2()
{
	vboxmanage startvm cent7-object2 --type headless
}

function func_poweron_centos_test1()
{
	vboxmanage startvm cent7-test1 --type headless
}

function func_poweron_centos_test2()
{
	vboxmanage startvm cent7-test2 --type headless
}

function func_poweron_centos_all()
{
	echo func_poweron_centos_all................................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		func_poweron_centos_controller
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		func_poweron_centos_controller1
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		func_poweron_centos_controller2
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		func_poweron_centos_network
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		func_poweron_centos_network1
	fi
	if [ ${USING_NODE_NETWORK2} = "1" ]; then	
		func_poweron_centos_network2
	fi	
	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		func_poweron_centos_compute
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		func_poweron_centos_compute1
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		func_poweron_centos_compute2
	fi	
	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		func_poweron_centos_block1
	fi
	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		func_poweron_centos_block2
	fi
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		func_poweron_centos_object1
	fi
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		func_poweron_centos_object2
	fi
}

function func_poweron_ubuntu_base()
{
	vboxmanage startvm ubuntu14-base --type headless
}

function func_poweron_ubuntu_controller()
{
	vboxmanage startvm ubuntu14-controller --type headless
}

function func_poweron_ubuntu_network()
{
	vboxmanage startvm ubuntu14-network --type headless
}

function func_poweron_ubuntu_network1()
{
	vboxmanage startvm ubuntu14-network --type headless
}

function func_poweron_ubuntu_network2()
{
	vboxmanage startvm ubuntu14-network2 --type headless
}

function func_poweron_ubuntu_compute()
{
	vboxmanage startvm ubuntu14-compute --type headless
}

function func_poweron_ubuntu_block1()
{
	vboxmanage startvm ubuntu14-block1 --type headless
}

function func_poweron_ubuntu_object1()
{
	vboxmanage startvm ubuntu14-object2 --type headless
}

function func_poweron_ubuntu_object2()
{
	vboxmanage startvm ubuntu14-object1 --type headless
}


function func_poweron_ubuntu_all()
{
	echo func_poweron_ubuntu_all................................................

	func_poweron_ubuntu_controller

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		# Compute server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} &>/dev/null; do :; done
	fi
	sleep 10

	func_poweron_ubuntu_network
	func_poweron_ubuntu_compute
	func_poweron_ubuntu_block1
	func_poweron_ubuntu_object1
	func_poweron_ubuntu_object2
	echo func_poweron_ubuntu_all Done............................................
}

function func_poweroff_centos_base()
{
	ssh root@10.0.0.100 "poweroff"	
}

function func_poweroff_centos_controller()
{
	ssh root@10.0.0.11 "poweroff"
}

function func_poweroff_centos_controller1()
{
	ssh root@10.0.0.11 "poweroff"
}

function func_poweroff_centos_controller2()
{
	ssh root@10.0.0.12 "poweroff"
}

function func_poweroff_centos_network()
{
	ssh root@10.0.0.21 "poweroff"
}

function func_poweroff_centos_network1()
{
	ssh root@10.0.0.21 "poweroff"
}


function func_poweroff_centos_network2()
{
	ssh root@10.0.0.22 "poweroff"
}

function func_poweroff_centos_compute()
{
	ssh root@10.0.0.31 "poweroff"
}

function func_poweroff_centos_compute1()
{
	ssh root@10.0.0.31 "poweroff"
}

function func_poweroff_centos_compute2()
{
	ssh root@10.0.0.32 "poweroff"
}


function func_poweroff_centos_block1()
{
	ssh root@10.0.0.41 "poweroff"
}

function func_poweroff_centos_block2()
{
	ssh root@10.0.0.42 "poweroff"
}

function func_poweroff_centos_object1()
{
	ssh root@10.0.0.51 "poweroff"
}

function func_poweroff_centos_object2()
{
	ssh root@10.0.0.52 "poweroff"
}

function func_poweroff_centos_all()
{
	echo func_poweroff_centos_all................................................
	func_poweroff_centos_controller1
	func_poweroff_centos_controller2
	func_poweroff_centos_network1
	func_poweroff_centos_network2	
	func_poweroff_centos_compute1
	func_poweroff_centos_compute2
	func_poweroff_centos_block1
	func_poweroff_centos_block2
	func_poweroff_centos_object1
	func_poweroff_centos_object2
}

function func_poweroff_ubuntu_base()
{
	ssh root@10.1.0.100 "poweroff"	
}

function func_poweroff_ubuntu_controller()
{
	ssh root@10.1.0.11 "poweroff"
}

function func_poweroff_ubuntu_network()
{
	ssh root@10.1.0.21 "poweroff"
}

function func_poweroff_ubuntu_compute()
{
	ssh root@10.1.0.31 "poweroff"
}

function func_poweroff_ubuntu_block1()
{
	ssh root@10.1.0.41 "poweroff"
}

function func_poweroff_ubuntu_block1()
{
	ssh root@10.1.0.41 "poweroff"
}

function func_poweroff_ubuntu_object1()
{
	ssh root@10.1.0.51 "poweroff"
}

function func_poweroff_ubuntu_object2()
{
	ssh root@10.1.0.52 "poweroff"
}

function func_poweroff_ubuntu_all()
{
	echo func_poweron_ubuntu_all................................................
	func_poweroff_ubuntu_controller
	func_poweroff_ubuntu_network
	func_poweroff_ubuntu_compute
	func_poweroff_ubuntu_block1
	func_poweroff_ubuntu_object1
	func_poweroff_ubuntu_object2
}

function func_run()
{
	echo func_run Step ${1}................................................
	cd ~/OpenStack/Scripts
	time ./kilo-step-${1}.sh >& rst${1}.log
}

function func_run2()
{
	echo func_run Step ${1}................................................
	cd ~/OpenStack/Scripts
	time ./kilo-step-${1}.sh 2> rst${1}.err 1> rst${1}.log
}

function func_run_all()
{
	echo func_run_all................................................

	func_run 01
	func_run 02
	func_run 03
	func_run 04
	func_run 05
	func_run 06
	func_run 07
	func_run 08
	func_run 09
	# func_run 10
	# func_run 11
	# func_run 12
}

function func_run2_all()
{
	echo func_run_all................................................

	func_run2 01
	func_run2 02
	func_run2 03
	func_run2 04
	func_run2 05
	func_run2 06
	func_run2 07
	func_run2 08
	func_run2 09
	# func_run2 10
	# func_run2 11
	# func_run2 12
}

function func_log()
{
	echo func_log Step ${1}................................................
	cd ~/OpenStack/Scripts
	tail -f rst${1}.log
}

function func_err()
{
	echo func_log Step ${1}................................................
	cd ~/OpenStack/Scripts
	tail -f rst${1}.err
}
