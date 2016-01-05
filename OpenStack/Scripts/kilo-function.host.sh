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

source ./kilo-function.utils.sh

##################################################################################################3
# Functions
function func_host_poweroff_and_delete_vm_all()
{
	echo func_host_poweroff_and_delete_vm_all....................................

	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		# Init Controller VM 
		VBoxManage controlvm ${VBOX_CONTROLLER} poweroff
		VBoxManage unregistervm ${VBOX_CONTROLLER} --delete
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		# Init Controller VM 
		VBoxManage controlvm ${VBOX_CONTROLLER1} poweroff
		VBoxManage unregistervm ${VBOX_CONTROLLER1} --delete
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		# Init Controller VM 
		VBoxManage controlvm ${VBOX_CONTROLLER2} poweroff
		VBoxManage unregistervm ${VBOX_CONTROLLER2} --delete
	fi	

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		# Init Compute VM 
		VBoxManage controlvm ${VBOX_COMPUTE} poweroff
		VBoxManage unregistervm ${VBOX_COMPUTE} --delete
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		# Init Compute VM 
		VBoxManage controlvm ${VBOX_COMPUTE1} poweroff
		VBoxManage unregistervm ${VBOX_COMPUTE1} --delete
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		# Init Compute VM 
		VBoxManage controlvm ${VBOX_COMPUTE2} poweroff
		VBoxManage unregistervm ${VBOX_COMPUTE2} --delete
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		# Init Network VM 
		VBoxManage controlvm ${VBOX_NETWORK} poweroff
		VBoxManage unregistervm ${VBOX_NETWORK} --delete
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		# Init Network VM 
		VBoxManage controlvm ${VBOX_NETWORK1} poweroff
		VBoxManage unregistervm ${VBOX_NETWORK1} --delete
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		# Init Network VM 
		VBoxManage controlvm ${VBOX_NETWORK2} poweroff
		VBoxManage unregistervm ${VBOX_NETWORK2} --delete
	fi	

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		# Init Block1 VM 
		VBoxManage controlvm ${VBOX_BLOCK1} poweroff
		VBoxManage unregistervm ${VBOX_BLOCK1} --delete
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		# Init Block1 VM 
		VBoxManage controlvm ${VBOX_BLOCK2} poweroff
		VBoxManage unregistervm ${VBOX_BLOCK2} --delete
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		# Init Object1 VM 
		VBoxManage controlvm ${VBOX_OBJECT1} poweroff
		VBoxManage unregistervm ${VBOX_OBJECT1} --delete
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		# Init Object2 VM 
		VBoxManage controlvm ${VBOX_OBJECT2} poweroff
		VBoxManage unregistervm ${VBOX_OBJECT2} --delete
	fi	
}

function func_host_import_vm_all()
{
	echo func_host_import_vm_all.................................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER}.ova
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER1}.ova
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER2}.ova
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE}.ova
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE1}.ova		
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE2}.ova		
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_NETWORK}.ova
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_NETWORK1}.ova
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_NETWORK2}.ova
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_BLOCK1}.ova
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_BLOCK2}.ova
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_OBJECT1}.ova
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/${VBOX_OBJECT2}.ova
	fi		
}

function func_host_export_vm_all()
{
	echo func_host_export_vm_all.................................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER} --output ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER1} --output ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER2} --output ~/OpenStack/OpenStack_VM/${VBOX_CONTROLLER2}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE} --output ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE1} --output ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE1}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE2} --output ~/OpenStack/OpenStack_VM/${VBOX_COMPUTE2}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK} --output ~/OpenStack/OpenStack_VM/${VBOX_NETWORK}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK1} --output ~/OpenStack/OpenStack_VM/${VBOX_NETWORK1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK2} --output ~/OpenStack/OpenStack_VM/${VBOX_NETWORK2}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		VBoxManage export ${VBOX_BLOCK1} --output ~/OpenStack/OpenStack_VM/${VBOX_BLOCK1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		VBoxManage export ${VBOX_BLOCK2} --output ~/OpenStack/OpenStack_VM/${VBOX_BLOCK2}.ova --ovf20 --options manifest
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		VBoxManage export ${VBOX_OBJECT1} --output ~/OpenStack/OpenStack_VM/${VBOX_OBJECT1}.ova --ovf20 --options manifest
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		VBoxManage export ${VBOX_OBJECT2} --output ~/OpenStack/OpenStack_VM/${VBOX_OBJECT2}.ova --ovf20 --options manifest
	fi
}

function func_host_add_group_vm_all()
{
	echo func_host_add_group_vm_all..............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		VBoxManage modifyvm ${VBOX_CONTROLLER} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		VBoxManage modifyvm ${VBOX_CONTROLLER1} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		VBoxManage modifyvm ${VBOX_CONTROLLER2} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		VBoxManage modifyvm ${VBOX_COMPUTE} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		VBoxManage modifyvm ${VBOX_COMPUTE1} --groups ${VBOX_GROUP}		
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		VBoxManage modifyvm ${VBOX_COMPUTE2} --groups ${VBOX_GROUP}		
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		VBoxManage modifyvm ${VBOX_NETWORK} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		VBoxManage modifyvm ${VBOX_NETWORK1} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		VBoxManage modifyvm ${VBOX_NETWORK2} --groups ${VBOX_GROUP}
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		VBoxManage modifyvm ${VBOX_BLOCK1} --groups ${VBOX_GROUP}
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		VBoxManage modifyvm ${VBOX_BLOCK2} --groups ${VBOX_GROUP}
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		VBoxManage modifyvm ${VBOX_OBJECT1} --groups ${VBOX_GROUP}
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		VBoxManage modifyvm ${VBOX_OBJECT2} --groups ${VBOX_GROUP}
	fi
}

function func_host_nic_promisc_allowall_vm()
{

	echo func_host_nic_promisc_allowall_vm $1..............................................	
	VBoxManage modifyvm $1 --nicpromisc1 allow-all
	VBoxManage modifyvm $1 --nicpromisc2 allow-all
	VBoxManage modifyvm $1 --nicpromisc3 allow-all
	VBoxManage modifyvm $1 --nicpromisc4 allow-all

	VBoxManage modifyvm $1 --nicproperty1 promiscuousModePolicy='allow-all'
	VBoxManage modifyvm $1 --nicproperty2 promiscuousModePolicy='allow-all'
	VBoxManage modifyvm $1 --nicproperty3 promiscuousModePolicy='allow-all'
	VBoxManage modifyvm $1 --nicproperty4 promiscuousModePolicy='allow-all'
}


function func_host_nic_promisc_allowall_vm_all()
{

	echo func_host_nic_promisc_allowall_vm_all..............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_CONTROLLER}
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_CONTROLLER1}
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_CONTROLLER2}
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_COMPUTE}
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_COMPUTE1}
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_COMPUTE2}
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_NETWORK}
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_NETWORK1}
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_NETWORK2}
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_BLOCK1}
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_BLOCK2}
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_OBJECT1}
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		func_host_nic_promisc_allowall_vm ${VBOX_OBJECT2}
	fi
}


function func_host_start_vm_all()
{
	echo func_host_start_vm_all...............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		vboxmanage startvm ${VBOX_CONTROLLER} --type headless
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		vboxmanage startvm ${VBOX_CONTROLLER1} --type headless
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		vboxmanage startvm ${VBOX_CONTROLLER2} --type headless
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		vboxmanage startvm ${VBOX_COMPUTE} --type headless
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		vboxmanage startvm ${VBOX_COMPUTE1} --type headless
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		vboxmanage startvm ${VBOX_COMPUTE2} --type headless
	fi		

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		vboxmanage startvm ${VBOX_NETWORK} --type headless		
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		vboxmanage startvm ${VBOX_NETWORK1} --type headless	
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		vboxmanage startvm ${VBOX_NETWORK2} --type headless	
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		vboxmanage startvm ${VBOX_BLOCK1}  --type headless
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		vboxmanage startvm ${VBOX_BLOCK2}  --type headless
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		vboxmanage startvm ${VBOX_OBJECT1} --type headless
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		vboxmanage startvm ${VBOX_OBJECT2} --type headless
	fi
}

function func_host_wait_vm_start_all()
{
	echo func_host_wait_vm_start_all.............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		# Compute server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		# Compute server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		# Compute server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} &>/dev/null; do :; done
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		# Network server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} &>/dev/null; do :; done		
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		# Network server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} &>/dev/null; do :; done		
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		# Network server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} &>/dev/null; do :; done		
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		# Block1 server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} &>/dev/null; do :; done
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		# Block1 server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} &>/dev/null; do :; done
	fi
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		# Object1 server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} &>/dev/null; do :; done
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		# Object1 server ssh password 생략
		# Server가 살아 날때 까지 대기
		while ! ping -c1 ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} &>/dev/null; do :; done
	fi

	sleep 1	
}

function func_host_ssh_copy_id_all()
{
	echo func_host_ssh_copy_id_all...............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}
	fi		

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1}
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2}
	fi		

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK}
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1}
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2}
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2}
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		ssh-copy-id student@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}
		ssh-copy-id root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}
	fi
}

function func_host_set_hostname_all()
{
	echo func_host_set_hostname_all..............................................

	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "hostnamectl set-hostname controller"
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "hostnamectl set-hostname controller1"
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "hostnamectl set-hostname controller2"
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "hostnamectl set-hostname compute"
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "hostnamectl set-hostname compute1"
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "hostnamectl set-hostname compute2"
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "hostnamectl set-hostname network"
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "hostnamectl set-hostname network1"
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "hostnamectl set-hostname network2"
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "hostnamectl set-hostname block1"
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "hostnamectl set-hostname block2"
	fi	

	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "hostnamectl set-hostname object1"
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "hostnamectl set-hostname object2"
	fi
}


# ============================================================================================
# hostonly netwotk mapping
# Make by @ianychoi
# Function
function check_vboxnet()
{
	IS_NETWORK=`echo $VBOXMANAGE_LIST_VBOXNET_IP | tr ' ' '\n' | grep "$1" | awk -F: '{print $1}'`

	if [ -z $IS_NETWORK ]
	then
		TARGET_VBOXNET_NAME=`VBoxManage hostonlyif create | egrep -o 'vboxnet[0-9]+'`
		VBoxManage hostonlyif ipconfig $TARGET_VBOXNET_NAME --ip $1
	else
		TARGET_VBOXNET_NAME=`echo $VBOXMANAGE_LIST_VBOXNET_NAME | tr ' ' '\n' | sed -n "${IS_NETWORK}p" | awk -F: '{print $2}'`
	fi
	echo $TARGET_VBOXNET_NAME
}

function func_host_hostonly_netwotk_mapping()
{ 
	echo func_host_hostonly_netwotk_mapping......................................

	VBOXMANAGE_LIST_VBOXNET_NAME=`VBoxManage list hostonlyifs | egrep -o 'Name:[ ]*vboxnet[0-9]*' | awk '{print NR":"$2}'`
	VBOXMANAGE_LIST_VBOXNET_IP=`VBoxManage list hostonlyifs | egrep -o 'IPAddress:[ ]*[0-9]*.[0-9]*.[0-9]*.[0-9]*' | awk '{print NR":"$2}'`
	VBOXNET_NAME_EXTERNAL=$(check_vboxnet $NETWORK_1ST_IP_EXTERNAL)
	VBOXNET_NAME_MANAGEMENT=$(check_vboxnet $NETWORK_1ST_IP_MANAGEMENT)
	VBOXNET_NAME_TUNNEL=$(check_vboxnet $NETWORK_1ST_IP_TUNNEL)
	VBOXNET_NAME_STORAGE=$(check_vboxnet $NETWORK_1ST_IP_STORAGE)
	VBOXNET_NAME_HA=$(check_vboxnet $NETWORK_1ST_IP_HA)

	echo VBOXNET_NAME_EXTERNAL=${VBOXNET_NAME_EXTERNAL}
	echo VBOXNET_NAME_MANAGEMENT=${VBOXNET_NAME_MANAGEMENT}
	echo VBOXNET_NAME_TUNNEL=${VBOXNET_NAME_TUNNEL}
	echo VBOXNET_NAME_STORAGE=${VBOXNET_NAME_STORAGE}
	echo VBOXNET_NAME_HA=${VBOXNET_NAME_HA}

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then

		if [ ${USING_NODE_CONTROLLER} = "1" ]; then
			VBoxManage modifyvm ${VBOX_CONTROLLER} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_CONTROLLER} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_CONTROLLER} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi	

		if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
			VBoxManage modifyvm ${VBOX_CONTROLLER1} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_CONTROLLER1} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_CONTROLLER1} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi	

		if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
			VBoxManage modifyvm ${VBOX_CONTROLLER2} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_CONTROLLER2} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_CONTROLLER2} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi	

		if [ ${USING_NODE_NETWORK} = "1" ]; then
			VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi

		if [ ${USING_NODE_NETWORK1} = "1" ]; then
			VBoxManage modifyvm ${VBOX_NETWORK1} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_NETWORK1} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_NETWORK1} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi

		if [ ${USING_NODE_NETWORK2} = "1" ]; then
			VBoxManage modifyvm ${VBOX_NETWORK2} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_NETWORK2} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_NETWORK2} --hostonlyadapter3 $VBOXNET_NAME_EXTERNAL
		fi

		if [ ${USING_NODE_COMPUTE} = "1" ]; then
			VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_COMPUTE1} = "1" ]; then
			VBoxManage modifyvm ${VBOX_COMPUTE1} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_COMPUTE1} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_COMPUTE1} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_COMPUTE2} = "1" ]; then
			VBoxManage modifyvm ${VBOX_COMPUTE2} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_COMPUTE2} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_COMPUTE2} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_BLOCK1} = "1" ]; then
			VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_BLOCK2} = "1" ]; then
			VBoxManage modifyvm ${VBOX_BLOCK2} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_BLOCK2} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_BLOCK2} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_OBJECT1} = "1" ]; then
			VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

		if [ ${USING_NODE_OBJECT2} = "1" ]; then
			VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter1 $VBOXNET_NAME_MANAGEMENT
			VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter2 $VBOXNET_NAME_TUNNEL
			VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter3 $VBOXNET_NAME_STORAGE
		fi

	else
		echo NOP
		VBoxManage modifyvm ${VBOX_CONTROLLER} --hostonlyadapter2 $VBOXNET_NAME_HA
		VBoxManage modifyvm ${VBOX_CONTROLLER} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT

		VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter2 $VBOXNET_NAME_EXTERNAL
		VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
		VBoxManage modifyvm ${VBOX_NETWORK} --hostonlyadapter4 $VBOXNET_NAME_TUNNEL

		VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
		VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter4 $VBOXNET_NAME_TUNNEL
		VBoxManage modifyvm ${VBOX_COMPUTE} --hostonlyadapter4 $VBOXNET_NAME_TUNNEL

		VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter2 $VBOXNET_NAME_STORAGE
		VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
		VBoxManage modifyvm ${VBOX_BLOCK1} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT

		VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter2 $VBOXNET_NAME_STORAGE
		VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
		VBoxManage modifyvm ${VBOX_OBJECT1} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT

		VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter2 $VBOXNET_NAME_STORAGE
		VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
		VBoxManage modifyvm ${VBOX_OBJECT2} --hostonlyadapter3 $VBOXNET_NAME_MANAGEMENT
	fi	


}

function func_host_scp_scripts_controller()
{
	echo func_host_scp_scripts_controller $1............................................
	ssh student@$1 "mkdir scripts"
	scp ${HOME_SCRIPT_DIR}/common/kilo-perform-vars.common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.00_common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.02_base.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.03_identity.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.04_image.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.05_compute.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.06_network.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.07_dashboard.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.08_blockstorage.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.09_objectstorage.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.all.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.controller.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_IDENTITY}/kilo-3.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_IMAGE}/kilo-4.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_COMPUTE}/kilo-5.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_NETWORK}/kilo-6.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_DASHBOARD}/kilo-7.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BLOCK_STORAGE}/kilo-8.*.controller.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_OBJECT_STORAGE}/kilo-9.*.controller.sh  student@$1:~/scripts

	ssh student@$1 "chmod +x ~/scripts/*.sh"
}

function func_host_scp_scripts_compute()
{
	echo func_host_scp_scripts_compute $1............................................
	ssh student@$1 "mkdir scripts"
	scp ${HOME_SCRIPT_DIR}/common/kilo-perform-vars.common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.00_common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.02_base.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.05_compute.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.06_network.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.all.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.5.other-conrtoller.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_COMPUTE}/kilo-5.*.compute.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_NETWORK}/kilo-6.*.compute.sh  student@$1:~/scripts

	ssh student@$1 "chmod +x ~/scripts/*.sh"
}

function func_host_scp_scripts_network()
{
	echo func_host_scp_scripts_network $1............................................
	ssh student@$1 "mkdir scripts"
	scp ${HOME_SCRIPT_DIR}/common/kilo-perform-vars.common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.00_common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.02_base.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.06_network.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.all.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.5.other-conrtoller.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_NETWORK}/kilo-6.*.network.sh  student@$1:~/scripts
	
	ssh student@$1 "chmod +x ~/scripts/*.sh"
}

function func_host_scp_scripts_block()
{
	echo func_host_scp_scripts_block $1............................................
	ssh student@$1 "mkdir scripts"
	scp ${HOME_SCRIPT_DIR}/common/kilo-perform-vars.common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.00_common.sh student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.02_base.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.08_blockstorage.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.all.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.5.other-conrtoller.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BLOCK_STORAGE}/kilo-8.*.block1.sh  student@$1:~/scripts
	
	ssh student@$1 "chmod +x ~/scripts/*.sh"
}

function func_host_scp_scripts_object()
{
	echo func_host_scp_scripts_object $1............................................
	ssh student@$1 "mkdir scripts"
	scp ${HOME_SCRIPT_DIR}/common/kilo-perform-vars.common.sh  student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.00_common.sh student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.02_base.sh student@$1:~/scripts
	scp ${HOME_SCRIPT_DIR}/common/kilo-function.09_objectstorage.sh student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.*.all.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_BASE}/kilo-2.5.other-conrtoller.sh  student@$1:~/scripts

	scp ${SOURCE_SCRIPT_DIR_OBJECT_STORAGE}/kilo-9.*.object1.sh  student@$1:~/scripts
	scp ${SOURCE_SCRIPT_DIR_OBJECT_STORAGE}/kilo-9.*.object2.sh  student@$1:~/scripts

	ssh student@$1 "chmod +x ~/scripts/*.sh"
}


function func_host_scp_scripts_all()
{
	echo func_host_scp_scripts_all................................................

	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		func_host_scp_scripts_controller ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER}
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		func_host_scp_scripts_controller ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1}
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		func_host_scp_scripts_controller ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2}
	fi	

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		func_host_scp_scripts_compute ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE}
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		func_host_scp_scripts_compute ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1}
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		func_host_scp_scripts_compute ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2}
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		func_host_scp_scripts_network ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK}
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		func_host_scp_scripts_network ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1}
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		func_host_scp_scripts_network ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2}
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		func_host_scp_scripts_block ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1}
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		func_host_scp_scripts_block ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2}
	fi
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		func_host_scp_scripts_object ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1}
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		func_host_scp_scripts_object ${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2}
	fi		
		
}

function func_setup_virtualbox_network_hostonly_with_iptables
{
	iptables -A FORWARD -o $(ip route get 8.8.8.8 | awk '{ print $5; exit }') -i vboxnet0 -s ${EXTERNAL_NETWORK_CIDR} -m conntrack --ctstate NEW -j ACCEPT
	iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -A POSTROUTING -t nat -j MASQUERADE	
}


function func_host_yum_update()
{
	echo func_host_yum_update ............................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER} "yum -y update"
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER1} "yum -y update"
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_CONTROLLER2} "yum -y update"
	fi	

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE} "yum -y update"
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE1} "yum -y update"
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_COMPUTE2} "yum -y update"
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK} "yum -y update"
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK1} "yum -y update"
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_NETWORK2} "yum -y update"
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK1} "yum -y update"
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_BLOCK2} "yum -y update"
	fi
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT1} "yum -y update"
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		ssh root@${INSTANCE_MANAGEMENT_INTERFACE_IP_ADDRESS_OBJECT2} "yum -y update"
	fi		
}



#################################################################################################

function func_host_import_vm_all_test()
{
	echo func_host_import_vm_all.................................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER}.ova
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER1}.ova
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER2}.ova
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE}.ova		
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE1}.ova		
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE2}.ova		
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK}.ova
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK1}.ova
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK2}.ova
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_BLOCK1}.ova
	fi	

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_BLOCK2}.ova
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_OBJECT1}.ova
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_OBJECT2}.ova
	fi		
}

function func_host_export_vm_all_test()
{
	echo func_host_export_vm_all.................................................
	if [ ${USING_NODE_CONTROLLER} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER} --output ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_CONTROLLER1} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER1} --output ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_CONTROLLER2} = "1" ]; then
		VBoxManage export ${VBOX_CONTROLLER2} --output ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER2}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_COMPUTE} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE} --output ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_COMPUTE1} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE1} --output ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE1}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_COMPUTE2} = "1" ]; then
		VBoxManage export ${VBOX_COMPUTE2} --output ~/OpenStack/OpenStack_VM/test/${VBOX_COMPUTE2}.ova --ovf20 --options manifest		
	fi

	if [ ${USING_NODE_NETWORK} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK} --output ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_NETWORK1} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK1} --output ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_NETWORK2} = "1" ]; then
		VBoxManage export ${VBOX_NETWORK2} --output ~/OpenStack/OpenStack_VM/test/${VBOX_NETWORK2}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_BLOCK1} = "1" ]; then
		VBoxManage export ${VBOX_BLOCK1} --output ~/OpenStack/OpenStack_VM/test/${VBOX_BLOCK1}.ova --ovf20 --options manifest
	fi

	if [ ${USING_NODE_BLOCK2} = "1" ]; then
		VBoxManage export ${VBOX_BLOCK2} --output ~/OpenStack/OpenStack_VM/test/${VBOX_BLOCK2}.ova --ovf20 --options manifest
	fi	
	
	if [ ${USING_NODE_OBJECT1} = "1" ]; then
		VBoxManage export ${VBOX_OBJECT1} --output ~/OpenStack/OpenStack_VM/test/${VBOX_OBJECT1}.ova --ovf20 --options manifest
	fi		
	
	if [ ${USING_NODE_OBJECT2} = "1" ]; then
		VBoxManage export ${VBOX_OBJECT2} --output ~/OpenStack/OpenStack_VM/test/${VBOX_OBJECT2}.ova --ovf20 --options manifest
	fi
}

function func_host_import_vm_controller1()
{
	VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER1}.ova
}

function func_host_import_vm_controller2()
{
	VBoxManage import ~/OpenStack/OpenStack_VM/test/${VBOX_CONTROLLER2}.ova
}

