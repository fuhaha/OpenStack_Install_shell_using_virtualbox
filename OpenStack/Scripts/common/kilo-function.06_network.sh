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
# Chapter : 6. Add a networking component
# Node : Controller

# function func_[service]_configure_prerequisites_[node_type]_node()
# function func_[service]_install_package_[node_type]_node()
# function func_[service]_configure_[node_type]_node()
# function func_[service]_start_service_[node_type]_node()
# function func_[service]_verify_operation()

source ./kilo-perform-vars.common.sh

##################################################################################################
# neutron common function

function func_neutron_common_configure_neutron_base()
{
	echo [$(hostname)] func_neutron_common_configure_neutron_base..............................................................................
	############################################################################################################
	# (3) To configure the Networking server component
	# (3-1) Edit the /etc/neutron/neutron.conf file and complete the following actions:
	if [ ! -f /etc/neutron/neutron.conf ]; then
	    touch /etc/neutron/neutron.conf
	fi
	# f. (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/neutron/neutron.conf DEFAULT verbose True

	# In the [DEFAULT] and [oslo_messaging_rabbit] sections, configure RabbitMQ message queue access:
	# [DEFAULT]
	crudini --set /etc/neutron/neutron.conf DEFAULT rpc_backend rabbit
	# [oslo_messaging_rabbit]
	crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_host controller
	crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_userid openstack
	crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_password ${RABBIT_PASS}

	# if [ "$TARGET_OS_UBUNTU" = "1" ];
	# then
	# 	# Error: Unable to retrieve network quota information.
	# 	# Unable to establish connection to http://controller:9696/v2.0/agents.json

	# 	crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_host controller
	# 	crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_userid openstack
	# 	crudini --set /etc/neutron/neutron.conf DEFAULT rabbit_password ${RABBIT_PASS}
	# fi

	# # ERROR oslo_messaging._drivers.impl_rabbit
	# crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_port 5672
	# crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_hosts controller:5672
	# crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_use_ssl False
	# crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_virtual_host /
	# crudini --set /etc/neutron/neutron.conf oslo_messaging_rabbit rabbit_ha_queues False

	# In the [DEFAULT] and [keystone_authtoken] sections, configure Identity service access:
	# [DEFAULT]
	crudini --set /etc/neutron/neutron.conf DEFAULT auth_strategy keystone

	# [keystone_authtoken]
	crudini --del /etc/neutron/neutron.conf keystone_authtoken

	crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_uri http://controller:5000
	crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_url http://controller:35357
	crudini --set /etc/neutron/neutron.conf keystone_authtoken auth_plugin password
	crudini --set /etc/neutron/neutron.conf keystone_authtoken project_domain_id default
	crudini --set /etc/neutron/neutron.conf keystone_authtoken user_domain_id default
	crudini --set /etc/neutron/neutron.conf keystone_authtoken project_name service
	crudini --set /etc/neutron/neutron.conf keystone_authtoken username neutron
	crudini --set /etc/neutron/neutron.conf keystone_authtoken password ${NEUTRON_PASS}

	# In the [DEFAULT] section, enable the Modular Layer 2 (ML2) plug-in, router service, and overlapping IP addresses:
	crudini --set /etc/neutron/neutron.conf DEFAULT core_plugin ml2
	crudini --set /etc/neutron/neutron.conf DEFAULT service_plugins router
	crudini --set /etc/neutron/neutron.conf DEFAULT allow_overlapping_ips True	
}


function func_neutron_common_configure_neutron_nova()
{
	echo [$(hostname)] func_neutron_common_configure_neutron_nova..............................................................................
	############################################################################################################
	# (3) To configure the Networking server component
	# (3-1) Edit the /etc/neutron/neutron.conf file and complete the following actions:
	# In the [DEFAULT] and [nova] sections, configure Networking to notify Compute of network topology changes:
	crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_status_changes True
	crudini --set /etc/neutron/neutron.conf DEFAULT notify_nova_on_port_data_changes True
	crudini --set /etc/neutron/neutron.conf DEFAULT nova_url http://controller:8774/v2

	crudini --set /etc/neutron/neutron.conf nova auth_url http://controller:35357
	crudini --set /etc/neutron/neutron.conf nova auth_plugin password
	crudini --set /etc/neutron/neutron.conf nova project_domain_id default
	crudini --set /etc/neutron/neutron.conf nova user_domain_id default
	crudini --set /etc/neutron/neutron.conf nova region_name RegionOne
	crudini --set /etc/neutron/neutron.conf nova project_name service
	crudini --set /etc/neutron/neutron.conf nova username nova
	crudini --set /etc/neutron/neutron.conf nova password ${NOVA_PASS}

	# f. (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/neutron/neutron.conf DEFAULT verbose True
}


function func_neutron_common_configure_ml2()
{
	echo [$(hostname)] func_neutron_common_configure_ml2..............................................................................
	############################################################################################################
	# (4) To configure the Modular Layer 2 (ML2) plug-in
	# (4-1) Edit the /etc/neutron/plugins/ml2/ml2_conf.ini file and complete the following actions:
	if [ ! -f /etc/neutron/plugins/ml2/ml2_conf.ini ]; then
	    touch /etc/neutron/plugins/ml2/ml2_conf.ini
	fi

	# In the [ml2] section, enable the flat, VLAN, generic routing encapsulation (GRE), and virtual extensible LAN (VXLAN) network type drivers, GRE tenant networks, and the OVS mechanism driver:
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 type_drivers flat,vlan,gre,vxlan
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 tenant_network_types gre
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2 mechanism_drivers openvswitch

	# In the [ml2_type_gre] section, configure the tunnel identifier (id) range:
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_gre tunnel_id_ranges 1:1000

	# In the [securitygroup] section, enable security groups, enable ipset, and configure the OVS iptables firewall driver:
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_security_group True
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup enable_ipset True
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini securitygroup firewall_driver neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
}

function func_neutron_common_configure_nova()
{
	echo [$(hostname)] func_neutron_common_configure_nova..............................................................................
	############################################################################################################
	# (5) To configure Compute to use Networking
	# (5-1) Edit the /etc/nova/nova.conf file on the controller node and complete the following actions:
	if [ ! -f /etc/nova/nova.conf ]; then
	    touch /etc/nova/nova.conf
	fi

	# In the [DEFAULT] section, configure the APIs and drivers:
	crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.neutronv2.api.API
	crudini --set /etc/nova/nova.conf DEFAULT security_group_api neutron
	crudini --set /etc/nova/nova.conf DEFAULT linuxnet_interface_driver nova.network.linux_net.LinuxOVSInterfaceDriver
	crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

	# In the [neutron] section, configure access parameters:
	crudini --set /etc/nova/nova.conf neutron url http://controller:9696
	crudini --set /etc/nova/nova.conf neutron auth_strategy keystone
	crudini --set /etc/nova/nova.conf neutron admin_auth_url http://controller:35357/v2.0
	crudini --set /etc/nova/nova.conf neutron admin_tenant_name service
	crudini --set /etc/nova/nova.conf neutron admin_username neutron
	crudini --set /etc/nova/nova.conf neutron admin_password ${NEUTRON_PASS}
}

##################################################################################################
# nova controller node
function func_neutron_install_package_controller_node()
{
	echo [$(hostname)] func_neutron_install_package_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install neutron-server neutron-plugin-ml2 python-neutronclient
	else 
		yum -y install openstack-neutron openstack-neutron-ml2 python-neutronclient which
	fi	
}

function func_neutron_configure_controller_node()
{
	echo [$(hostname)] func_neutron_configure_controller_node..............................................................................
	############################################################################################################
	# (3) To configure the Networking server component
	func_neutron_common_configure_neutron_base
	# In the [database] section, configure database access:
	# [database]
	crudini --set /etc/neutron/neutron.conf database connection mysql://neutron:${NEUTRON_DBPASS}@controller/neutron

	func_neutron_common_configure_neutron_nova

	############################################################################################################
	# (4) To configure the Modular Layer 2 (ML2) plug-in
	func_neutron_common_configure_ml2

	############################################################################################################
	# (5) To configure Compute to use Networking
	func_neutron_common_configure_nova
}

function func_neutron_start_service_controller_node()
{
	echo [$(hostname)] func_neutron_start_service_controller_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		# (6) To finalize installation
		# (6-1) Populate the database:
		su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
		  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
  
  		# Restart the Compute services:
		service nova-api restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-api"
		while ! (service nova-api status >/dev/null 2>&1) do :; done
		echo "[CONTROLLER]===================================> start nova-api Done!"

		# Restart the Networking service:
		service neutron-server restart
		sleep 1
		echo "[CONTROLLER]===================================> start neutron-server"
		while ! (service neutron-server status >/dev/null 2>&1) do :; done
		echo "[CONTROLLER]===================================> start neutron-server Done!"

		# Remove the SQLite database file:
		echo "[CONTROLLER]===================================> rm -f /var/lib/neutron/neutron.sqlite"
		rm -f /var/lib/neutron/neutron.sqlite


	else
		# (6) To finalize installation
		# (6-1) The Networking service initialization scripts expect a symbolic link...
		ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
		# (6-2) Populate the database:
		su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
		  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
		sleep 5

		# (6-3) Restart the Compute services:
		systemctl restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service
		echo "[CONTROLLER]===================================> restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service"
		sleep 2
		while ! ( \
			(systemctl is-active openstack-nova-api.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-scheduler.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-conductor.service >/dev/null 2>&1) \
			)  do :; done
		echo "[CONTROLLER]===================================> restart openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service Done!"
		# (6-4) Start the Networking service and configure it to start when the system boots:
		systemctl enable neutron-server.service
		systemctl start neutron-server.service
		echo "[CONTROLLER]===================================> start neutron-server.service"
		while ! (systemctl is-active neutron-server.service >/dev/null 2>&1)  do :; done
		echo "[CONTROLLER]===================================> start neutron-server.service Done!"
	fi	
}


function func_neutron_verify_operation_controller_node()
{
	echo [$(hostname)] func_neutron_verify_operation_controller_node..................................................
	# ============================================================================================
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node

	# (7) Verify operation
	# (7-1) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh

	# (7-2) List loaded extensions to verify successful launch of the neutron-server process:
	neutron ext-list

}

##################################################################################################
# neutron network node

function func_neutron_configure_prerequisites_network_node()
{
	echo [$(hostname)] func_neutron_configure_prerequisites_network_node.......................................................
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node
	# (1) Install and configure network node
	# (2) To configure prerequisites
	# (2-1) Edit the /etc/sysctl.conf file to contain the following parameters:
	# 아래 처럼 하면 타이틀 커멘트 위에 설정이 붙는다.
	# crudini --set /etc/sysctl.conf '' net.ipv4.ip_forward 1
	# crudini --set /etc/sysctl.conf '' net.ipv4.conf.all.rp_filter 0
	# crudini --set /etc/sysctl.conf '' net.ipv4.conf.default.rp_filter 0

	echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
	echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf

	# (2-2) Implement the changes:
	sysctl -p	
}


function func_neutron_install_package_network_node()
{
	echo [$(hostname)] func_nova_install_package_compute_node..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install neutron-plugin-ml2 neutron-plugin-openvswitch-agent \
  			neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent
	else
		yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-openvswitch
	fi	
}


function func_neutron_configure_network_node()
{
	echo [$(hostname)] func_neutron_configure_network_node..............................................................................

	#################################################################################################################################
	# (4) To configure the Networking common components
	func_neutron_common_configure_neutron_base

	# # 기본설정에는 없지만 그래도....
	# # In the [database] section, configure database access:
	# # [database]
	# crudini --set /etc/neutron/neutron.conf database connection mysql://neutron:${NEUTRON_DBPASS}@controller/neutron/


	func_neutron_common_configure_neutron_nova

	############################################################################################################
	# (5) To configure the Modular Layer 2 (ML2) plug-in
	func_neutron_common_configure_ml2

	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ml2_type_flat flat_networks external

	# (5-1-5) In the [ovs] section, enable tunnels, configure the local tunnel endpoint, and map the external flat provider network to the br-ex external network bridge:
	# [ovs]
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs local_ip ${INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_NETWORK}
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs bridge_mappings external:br-ex

	# (5-1-6) In the [agent] section, enable GRE tunnels:
	# [agent]
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini agent tunnel_types gre

	###############################################################################################################################
	# (6) To configure the Layer-3 (L3) agent
	# (6-1) Edit the /etc/neutron/l3_agent.ini file and complete the following actions:
	# (6-1-1) In the [DEFAULT] section, configure the interface driver, external network bridge, and enable deletion of defunct router namespaces:
	# [DEFAULT]
	crudini --set /etc/neutron/l3_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
	crudini --set /etc/neutron/l3_agent.ini DEFAULT external_network_bridge ''
	crudini --set /etc/neutron/l3_agent.ini DEFAULT router_delete_namespaces True
	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/neutron/l3_agent.ini DEFAULT verbose True

	###############################################################################################################################
	# (7) To configure the DHCP agent
	# (7-1) Edit the /etc/neutron/dhcp_agent.ini file and complete the following actions:
	# (7-1-1) In the [DEFAULT] section, configure the interface and DHCP drivers and enable deletion of defunct DHCP namespaces:
	#[DEFAULT]
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT interface_driver neutron.agent.linux.interface.OVSInterfaceDriver
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_delete_namespaces True
	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT verbose True
	
	# (Optional)
	#[DEFAULT]
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dnsmasq_config_file /etc/neutron/dnsmasq-neutron.conf
	crudini --set /etc/neutron/dhcp_agent.ini DEFAULT dhcp_driver neutron.agent.linux.dhcp.Dnsmasq


	cat << EOF > /etc/neutron/dnsmasq-neutron.conf
dhcp-option-force=26,1454
EOF
	
	pkill dnsmasq
}

function func_neutron_configure_metadata_agent_network_node()
{
	echo [$(hostname)] func_neutron_configure_metadata_agent_network_node..............................................................................
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node
	###############################################################################################################################
	# (8) To configure the metadata agent
	# (8-1) Edit the /etc/neutron/metadata_agent.ini file and complete the following actions:
	# (8-1-1) In the [DEFAULT] section, configure access parameters:
	# [DEFAULT]
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_uri http://controller:5000
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_url http://controller:35357
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_region RegionOne
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT auth_plugin password
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT project_domain_id default
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT user_domain_id default
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT project_name service
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT username neutron
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT password ${NEUTRON_PASS}

	# (8-1-2) In the [DEFAULT] section, configure the metadata host:
	# [DEFAULT]
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT nova_metadata_ip controller

	# (8-1-3) In the [DEFAULT] section, configure the metadata proxy shared secret:
	# [DEFAULT]
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT metadata_proxy_shared_secret ${METADATA_SECRET}
	# (Optional) To assist with troubleshooting, enable verbose logging in the [DEFAULT] section:
	crudini --set /etc/neutron/metadata_agent.ini DEFAULT verbose True	
}

function func_neutron_configure_metadata_agent_controller_node()
{
	echo [$(hostname)] func_neutron_configure_metadata_agent_controller_node..............................................................................
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node
	###############################################################################################################################
	# (8) To configure the metadata agent
	# (8-2) On the controller node, edit the /etc/nova/nova.conf file and complete the following action:
	# (8-2-1) In the [neutron] section, enable the metadata proxy and configure the secret:
	# [neutron]
	crudini --set /etc/nova/nova.conf neutron service_metadata_proxy True
	crudini --set /etc/nova/nova.conf neutron metadata_proxy_shared_secret ${METADATA_SECRET}

	# (8-3) On the controller node, restart the Compute API service:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service nova-api restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-api"
		while ! (service nova-api status >/dev/null 2>&1) do :; done
		echo "[CONTROLLER]===================================> start nova-api Done!"
	else
		systemctl restart openstack-nova-api.service
		echo "[CONTROLLER]===================================> restart openstack-nova-api.service"
		sleep 2
		while ! (systemctl is-active openstack-nova-api.service >/dev/null 2>&1)  do :; done
	echo "[CONTROLLER]===================================> restart openstack-nova-api.service Done!"
	fi	
}

function func_neutron_configure_OVS_service_network_node()
{
	echo [$(hostname)] func_neutron_configure_OVS_service_network_node..............................................................................
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node

	# (9) To configure the Open vSwitch (OVS) service
	# (9-1) Start the OVS service and configure it to start when the system boots:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service openvswitch-switch restart
		sleep 1
		echo "[NETWORK]===================================> start openvswitch-switch"
		while ! (\
			service openvswitch-switch status >/dev/null 2>&1 \
			) do :; done
		echo "[NETWORK]===================================> start openvswitch-switch Done!"
	else
		systemctl enable openvswitch.service
		systemctl start openvswitch.service
		echo "[NETWORK]===================================> start openvswitch.service"
		while ! (systemctl is-active openvswitch.service >/dev/null 2>&1)  do :; done
		echo "[NETWORK]===================================> start openvswitch.service Done!"
	fi	
	# (9-2) Add the external bridge:
	echo ovs-vsctl add-br br-ex
	ovs-vsctl add-br br-ex
	# (9-3) Add a port to the external bridge that connects to the physical external network interface:
	echo ovs-vsctl add-port br-ex ${EXTERNAL_NETWORK_INTERFACE_NAME}
	ovs-vsctl add-port br-ex ${EXTERNAL_NETWORK_INTERFACE_NAME}

}


function func_neutron_start_service_network_node()
{
	echo [$(hostname)] func_neutron_start_service_network_node..............................................................................

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service neutron-plugin-openvswitch-agent restart
		service neutron-l3-agent restart
		service neutron-dhcp-agent restart
		service neutron-metadata-agent restart
		sleep 1
		echo "[NETWORK]===================================> start neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent"
		while ! (\
			(service neutron-plugin-openvswitch-agent status >/dev/null 2>&1) && \
			(service neutron-l3-agent status >/dev/null 2>&1) && \
			(service neutron-dhcp-agent status >/dev/null 2>&1) && \
			(service neutron-metadata-agent status >/dev/null 2>&1) \
			) do :; done
		echo "[NETWORK]===================================> start neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent-compute Done!"
	else
		# (10) To finalize the installation
		# (10-1) The Networking service initialization scripts expect a symbolic link /etc/neutron/plugin.ini pointing to the ML2 plug-in configuration file, /etc/neutron/plugins/ml2/ml2_conf.ini. If this symbolic link does not exist, create it using the following command:
		ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

		cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
		  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
		sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
		  /usr/lib/systemd/system/neutron-openvswitch-agent.service

		# (10-2) Start the Networking services and configure them to start when the system boots:
		systemctl enable neutron-openvswitch-agent.service neutron-l3-agent.service \
		  neutron-dhcp-agent.service neutron-metadata-agent.service \
		  neutron-ovs-cleanup.service
		systemctl start neutron-openvswitch-agent.service neutron-l3-agent.service \
		  neutron-dhcp-agent.service neutron-metadata-agent.service
		echo "[NETWORK]===================================> start neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service"
		while ! ( \
			(systemctl is-active neutron-openvswitch-agent.service >/dev/null 2>&1) && \
			(systemctl is-active neutron-l3-agent.service >/dev/null 2>&1) && \
			(systemctl is-active neutron-dhcp-agent.service >/dev/null 2>&1) && \
			(systemctl is-active neutron-metadata-agent.service >/dev/null 2>&1) \
			)  do :; done
		echo "[NETWORK]===================================> start neutron-openvswitch-agent.service neutron-l3-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service Done!"

		##################################################################################################################
		# ERROR : "rm: cannot remove /lib/drauct/hooks/shutdown/30-dm-shutdown.sh: Read-only filesystem"
		# Bug 1178497 - unable to shutdown - dracut loop
		sed -i -e "s/inst_multiple umount poweroff reboot halt losetup/inst_multiple umount poweroff reboot halt losetup stat/g" /usr/lib/dracut/modules.d/99shutdown/module-setup.sh
		sed -i -e "s/. \/lib\/dracut-lib.sh/. \/lib\/dracut-lib.sh\n\nif \[ \"\$(stat -c \'%T\' -f \/)\" = \"tmpfs\" \]; then\n    mount -o remount,rw \/\nfi/g" /usr/lib/dracut/modules.d/99shutdown/shutdown.sh

		systemctl mask dracut-shutdown.service

		
# 		cp /etc/sysconfig/network-scripts/ifcfg-${EXTERNAL_NETWORK_INTERFACE_NAME} ~student/

# 		cat << EOF > /etc/sysconfig/network-scripts/ifcfg-${EXTERNAL_NETWORK_INTERFACE_NAME}
# DEVICE=${EXTERNAL_NETWORK_INTERFACE_NAME}
# ONBOOT=yes
# TYPE=OVSPort
# DEVICETYPE=ovs
# OVS_BRIDGE=br-ex
# PROMISC=yes
# ALLMULTI=yes
# EOF

# 		cat << EOF > /etc/sysconfig/network-scripts/ifcfg-br-ex
# DEVICE=br-ex
# BOOTPROTO=static
# ONBOOT=yes
# TYPE=OVSBridge
# DEVICETYPE=ovs
# USERCTL=yes
# PEERDNS=yes
# IPV6INIT=no
# IPADDR=203.0.113.2
# NETMASK=255.255.255.0
# GATEWAY=203.0.113.1
# EOF
		
# 		systemctl restart network.service
# 		echo "[CONTROLLER]===================================> restart network.service"
# 		sleep 2
# 		while ! (systemctl is-active network.service >/dev/null 2>&1)  do :; done
# 		echo "[CONTROLLER]===================================> restart network.service Done!"				
	fi	
}


function func_neutron_verify_operation()
{
	echo [$(hostname)] func_nova_verify_operation..............................................................................
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node
	# (11) Verify operation
	# (11-1) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (11-2) ist agents to verify successful launch of the neutron agents:
	neutron agent-list
}


function func_neutron_create_external_network()
{
	echo [$(hostname)] func_neutron_create_external_network..............................................................................
	# 6 Add a networking component
	# 6.2 Create initial networks
	# 6.2.1 External network
	# (1) To create the external network
	# (1-1) Source the admin credentials to gain access to admin-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (1-2) Create the network:

	# neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat
	echo neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat --shared
	neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat --shared

	# (2) To create a subnet on the external network
	# (2-1) Create the subnet:
	echo neutron subnet-create ext-net ${EXTERNAL_NETWORK_CIDR} --name ext-subnet --allocation-pool start=${EXTERNAL_NETWORK_FLOATING_IP_START},end=${EXTERNAL_NETWORK_FLOATING_IP_END} --disable-dhcp --gateway ${EXTERNAL_NETWORK_GATEWAY} --dns-nameserver ${EXTERNAL_NETWORK_DNS}
	neutron subnet-create ext-net ${EXTERNAL_NETWORK_CIDR} --name ext-subnet --allocation-pool start=${EXTERNAL_NETWORK_FLOATING_IP_START},end=${EXTERNAL_NETWORK_FLOATING_IP_END} --disable-dhcp --gateway ${EXTERNAL_NETWORK_GATEWAY} --dns-nameserver ${EXTERNAL_NETWORK_DNS}

	# neutron subnet-delete ext-subnet
	
	# neutron subnet-create ext-net 203.0.113.0/24 --name ext-subnet --allocation-pool start=203.0.113.101,end=203.0.113.200 --disable-dhcp --gateway 203.0.113.1

	# 실제 네트워크와 마찬가지로 가상 네트워크는 그것에 할당 된 서브넷이 필요합니다. 외부 네트워크는 네트워크 노드의 외부 인터페이스에 연결된 물리적 네트워크에 연결된 동일한 서브넷과 게이트웨이를 공유합니다. 당신은 라우터의 서브넷 독점적 인 슬라이스를 지정하고 IP 플로팅 외부 네트워크의 다른 장치와의 간섭을 방지하기 위해 해결해야합니다.		
}

function func_neutron_create_tenant_network()
{
	echo [$(hostname)] func_neutron_create_tenant_network..............................................................................
	# 6 Add a networking component
	# 6.2 Create initial networks
	# 6.2.2 Tenant network
	#	(1) To create the tenant network
	# (1-1) Source the demo credentials to gain access to user-only CLI commands:
	source ~student/env/admin-openrc.sh
	# (1-2) Create the network:
	echo neutron net-create demo-net
	neutron net-create demo-net

	# (2) To create a subnet on the tenant network
	# (2-1) Create the subnet:
	echo neutron subnet-create demo-net ${TENANT_NETWORK_CIDR} --name demo-subnet -dns-nameserver 8.8.4.4 --gateway ${TENANT_NETWORK_GATEWAY}
	neutron subnet-create demo-net ${TENANT_NETWORK_CIDR} --name demo-subnet --dns-nameserver 8.8.4.4 --gateway ${TENANT_NETWORK_GATEWAY}
	# neutron subnet-delete demo-subnet
}



function func_neutron_create_router_network()
{
	echo [$(hostname)] func_neutron_create_router_network..............................................................................
	
	source ~student/env/admin-openrc.sh	
	# (3) To create a router on the tenant network and attach the external and tenant networks to it
	# (3-1) Create the router:
	echo neutron router-create demo-router
	neutron router-create demo-router
	# (3-2) Attach the router to the demo tenant subnet:
	echo neutron router-interface-add demo-router demo-subnet
	neutron router-interface-add demo-router demo-subnet
	# (3-3) Attach the router to the external network by setting it as the gateway:
	echo neutron router-gateway-set demo-router ext-net
	neutron router-gateway-set demo-router ext-net
}



function func_neutron_delete_router_network()
{
	echo [$(hostname)] func_neutron_delete_router_network..............................................................................
	source ~student/env/admin-openrc.sh

	neutron floatingip-list

	neutron floatingip-disassociate 9fbd87a2-3549-4203-82ee-f08f11ea98fb
	neutron floatingip-delete 9fbd87a2-3549-4203-82ee-f08f11ea98fb

	neutron router-gateway-clear demo-router ext-net
	neutron router-interface-delete demo-router demo-subnet
	neutron router-delete demo-router

}

function func_neutron_delete_tenant_network()
{
	echo [$(hostname)] func_neutron_delete_tenant_network..............................................................................
	source ~student/env/admin-openrc.sh
	neutron subnet-delete demo-subnet
	neutron net-delete demo-net
}

function func_neutron_delete_external_network()
{
	echo [$(hostname)] func_neutron_delete_external_network..............................................................................	
	source ~student/env/admin-openrc.sh
	
	neutron subnet-delete ext-subnet 
	neutron net-delete ext-net
}

function func_neutron_delete_all_network()
{
	func_neutron_delete_router_network
	func_neutron_delete_tenant_network
	func_neutron_delete_external_network
}

function func_neutron_create_test_network()
{
	source ~student/env/admin-openrc.sh

	neutron net-create ext-net --router:external --provider:physical_network external --provider:network_type flat --shared
	neutron subnet-create ext-net 203.0.113.0/24 --name ext-subnet --allocation-pool start=203.0.113.101,end=203.0.113.200 --disable-dhcp --gateway 203.0.113.1

	neutron net-create demo-net --provider:network_type gre
	neutron subnet-create demo-net 192.168.10.0/24 --name demo-subnet --gateway 192.168.10.1

	neutron router-create demo-router 
	neutron router-interface-add demo-router demo-subnet
	neutron router-gateway-set  demo-router ext-net
}

function func_neutron_delete_test_network()
{
	neutron floatingip-list

	neutron floatingip-disassociate 9fbd87a2-3549-4203-82ee-f08f11ea98fb
	neutron floatingip-delete 9fbd87a2-3549-4203-82ee-f08f11ea98fb

	neutron router-gateway-clear demo-router ext-net
	neutron router-interface-delete demo-router demo-subnet
	neutron router-delete demo-router

	neutron subnet-delete demo-subnet
	neutron net-delete demo-net

	neutron subnet-delete ext-subnet 
	neutron net-delete ext-net	
}

function func_neutron_verify_connectivity()
{
	echo [$(hostname)] func_neutron_verify_connectivity..............................................................................
	# 6 Add a networking component
	# 6.2 Create initial networks
	# 6.2.3 Verify connectivity
	sleep 10
	ping -c 10 ${EXTERNAL_NETWORK_FLOATING_IP_START}
}

###################################################################################################
# neutron compute node

function func_neutron_configure_prerequisites_compute_node()
{
	echo [$(hostname)] func_neutron_configure_prerequisites_compute_node............................................................
	# ============================================================================================
	# 6 Add a networking component
	# 6.1 OpenStack Networking (neutron)
	# 6.1.1 OpenStack Networking
	# 6.1.2 Networking concepts
	# 6.1.3 Install and configure controller node
	# 6.1.4 Install and configure network node
	# 6.1.5 Install and configure compute node
	# (1) Install and configure compute node
	# (2) To configure prerequisites
	# (2-1) Edit the /etc/sysctl.conf file to contain the following parameters:
	# 아래 처럼 하면 타이틀 커멘트 위에 설정이 붙는다.
	echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
	echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
	echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
	echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf

	# (2-2) Implement the changes:
	sysctl -p
}

function func_neutron_install_package_compute_node()
{
	echo [$(hostname)] func_neutron_install_package_compute_node............................................................
	# (3) To install the Networking components
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install neutron-plugin-ml2 neutron-plugin-openvswitch-agent
	else
		yum -y install openstack-neutron openstack-neutron-ml2 openstack-neutron-openvswitch
	fi		
}

function func_neutron_configure_compute_node()
{
	echo [$(hostname)] func_neutron_configure_compute_node............................................................
	################################################################################################################
	# (4) To configure the Networking common components
	func_neutron_common_configure_neutron_base

	# func_neutron_common_configure_neutron_nova

	############################################################################################################
	# (5) To configure the Modular Layer 2 (ML2) plug-in
	func_neutron_common_configure_ml2

	# (5-1-4) In the [ovs] section, enable tunnels, configure the local tunnel endpoint, and map the external flat provider network to the br-ex external network bridge:
	# [ovs]
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini ovs local_ip ${INSTANCE_TUNNELS_INTERFACE_IP_ADDRESS_COMPUTE}

	# (5-1-5) In the [agent] section, enable GRE tunnels:
	# [agent]
	crudini --set /etc/neutron/plugins/ml2/ml2_conf.ini agent tunnel_types gre

	################################################################################################################
	# (6) To configure the Open vSwitch (OVS) service
	# (6-1) Start the OVS service and configure it to start when the system boots:

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service openvswitch-switch restart
		sleep 1
		echo "[COMPUTE]===================================> start openvswitch-switch"
		while ! (\
			service openvswitch-switch status >/dev/null 2>&1 \
			) do :; done
		echo "[COMPUTE]===================================> start openvswitch-switch Done!"
	else
		systemctl enable openvswitch.service
		systemctl start openvswitch.service
		echo "[COMPUTE]===================================> start openvswitch.service"
		while ! (systemctl is-active openvswitch.service >/dev/null 2>&1)  do :; done
		echo "[COMPUTE]===================================> start openvswitch.service Done!"
	fi	

	################################################################################################################
	# (7) To configure Compute to use Networking
	func_neutron_common_configure_nova
}

function func_neutron_start_service_compute_node()
{
	echo [$(hostname)] func_neutron_start_service_compute_node............................................................
	# (8) To finalize the installation
	# (8-1) The Networking service initialization scripts expect a symbolic link /etc/neutron/plugin.ini pointing to the ML2 plug-in configuration file, /etc/neutron/plugins/ml2/ml2_conf.ini. If this symbolic link does not exist, create it using the following command:
	
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service nova-compute restart
		echo "[COMPUTE]===================================> start nova-compute"
		while ! (\
			service nova-compute status >/dev/null 2>&1 \
			) do :; done
		echo "[COMPUTE]===================================> start nova-compute Done!"

		service neutron-plugin-openvswitch-agent restart
		sleep 1
		echo "[COMPUTE]===================================> start neutron-plugin-openvswitch-agent"
		while ! (\
			service neutron-plugin-openvswitch-agent status >/dev/null 2>&1 \
			) do :; done
		echo "[COMPUTE]===================================> start openvswitch-switch Done!"
	else
		ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

		cp /usr/lib/systemd/system/neutron-openvswitch-agent.service \
		  /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
		sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' \
		  /usr/lib/systemd/system/neutron-openvswitch-agent.service

		# (8-2) Restart the Compute service:
		systemctl restart openstack-nova-compute.service
		echo "[COMPUTE]===================================> restart openstack-nova-compute.service"
		sleep 2
		while ! (systemctl is-active openstack-nova-compute.service >/dev/null 2>&1)  do :; done
		echo "[COMPUTE]===================================> restart openstack-nova-compute.service Done!"

		# (8-3) Start the Open vSwitch (OVS) agent and configure it to start when the system boots:
		systemctl enable neutron-openvswitch-agent.service
		systemctl start neutron-openvswitch-agent.service
		echo "[COMPUTE]===================================> start neutron-openvswitch-agent.service"
		while ! (systemctl is-active neutron-openvswitch-agent.service >/dev/null 2>&1)  do :; done
		echo "[COMPUTE]===================================> start neutron-openvswitch-agent.service Done!"
		sleep 2
	fi
}

function func_neutron_verify_operation()
{
	echo [$(hostname)] func_neutron_verify_operation..............................................................................
	source ~student/env/admin-openrc.sh

	neutron agent-list
}

################################################################################################################################################
#

function func_nova_network_configure_controller_node()
{
	echo [$(hostname)] func_nova_network_configure_controller_node..............................................................................
	# 6 Add a networking component
	# 6.2 Legacy networking (nova-network)
	# 6.2.1 Configure controller node
	# (1) To configure legacy networking
	if [ ! -f /etc/nova/nova.conf ]; then
	    touch /etc/nova/nova.conf
	fi

	# Edit the /etc/nova/nova.conf file and complete the following actions:
	crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.api.API
	crudini --set /etc/nova/nova.conf DEFAULT security_group_api nova

	# (2) Restart the Compute services:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service nova-api restart
		service nova-scheduler restart
		service nova-conductor restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-api nova-scheduler nova-conductor"
		while ! (\
			(service nova-api status >/dev/null 2>&1) && \
			(service nova-scheduler >/dev/null 2>&1) && \
			(service nova-conductor status >/dev/null 2>&1) \
			) do :; done
		echo "[CONTROLLER]===================================> start nova-api nova-scheduler nova-conductor Done!"
	else
		systemctl restart openstack-nova-api.service openstack-nova-scheduler.service \
  			openstack-nova-conductor.service
		echo "[NETWORK]===================================> start openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service"
		while ! ( \
			(systemctl is-active openstack-nova-api.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-scheduler.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-conductor.service >/dev/null 2>&1) \
			)  do :; done
		echo "[NETWORK]===================================> start  openstack-nova-api.service openstack-nova-scheduler.service openstack-nova-conductor.service Done!"
	fi	
}

function func_nova_network_configure_compute_node()
{
	echo [$(hostname)] func_nova_network_configure_compute_node..............................................................................

	# 6 Add a networking component
	# 6.2 Legacy networking (nova-network)
	# 6.2.2 Configure compute node
	# (1) To configure legacy networking
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		apt-get -y install nova-network nova-api-metadata
	else
		yum -y install openstack-nova-network openstack-nova-api
	fi	

	# (2) To configure legacy networking
	if [ ! -f /etc/nova/nova.conf ]; then
	    touch /etc/nova/nova.conf
	fi

	# Edit the /etc/nova/nova.conf file and complete the following actions:

	crudini --set /etc/nova/nova.conf DEFAULT network_api_class nova.network.api.API
	crudini --set /etc/nova/nova.conf DEFAULT security_group_api nova

	crudini --set /etc/nova/nova.conf DEFAULT firewall_driver nova.virt.libvirt.firewall.IptablesFirewallDriver
	crudini --set /etc/nova/nova.conf DEFAULT network_manager nova.network.manager.FlatDHCPManager
	crudini --set /etc/nova/nova.conf DEFAULT network_size 254
	crudini --set /etc/nova/nova.conf DEFAULT allow_same_net_traffic False
	crudini --set /etc/nova/nova.conf DEFAULT multi_host True
	crudini --set /etc/nova/nova.conf DEFAULT send_arp_for_ha True
	crudini --set /etc/nova/nova.conf DEFAULT share_dhcp_address True
	crudini --set /etc/nova/nova.conf DEFAULT force_dhcp_release True
	crudini --set /etc/nova/nova.conf DEFAULT flat_network_bridge br100
	crudini --set /etc/nova/nova.conf DEFAULT flat_interface ${EXTERNAL_NETWORK_INTERFACE_NAME}
	crudini --set /etc/nova/nova.conf DEFAULT public_interface ${EXTERNAL_NETWORK_INTERFACE_NAME}

	# (2) Restart the services:
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service nova-network restart
		service nova-api-metadata restart
		sleep 1
		echo "[CONTROLLER]===================================> start nova-network nova-api-metadata"
		while ! (\
			(service nova-network status >/dev/null 2>&1) && \
			(service nova-api-metadata status >/dev/null 2>&1) \
			) do :; done
		echo "[CONTROLLER]===================================> start nova-network nova-api-metadata Done!"
	else
		systemctl enable openstack-nova-network.service openstack-nova-metadata-api.service
		systemctl start openstack-nova-network.service openstack-nova-metadata-api.service
		echo "[NETWORK]===================================> start openstack-nova-network.service openstack-nova-metadata-api.service"
		while ! ( \
			(systemctl is-active openstack-nova-network.service >/dev/null 2>&1) && \
			(systemctl is-active openstack-nova-metadata-api.service >/dev/null 2>&1) \
			)  do :; done
		echo "[NETWORK]===================================> start  openstack-nova-network.service openstack-nova-metadata-api.service Done!"
	fi	
}


function func_nova_network_create_initial_network()
{
	echo [$(hostname)] func_nova_network_create_initial_network..............................................................................
	# 6 Add a networking component
	# 6.2 Legacy networking (nova-network)
	# 6.2.3 Create initial network
	# (1) To create the network
	# (1-1) Source the admin tenant credentials:
	source ~student/env/admin-openrc.sh
	# (1-2) Create the network:
	nova network-create demo-net --bridge br100 --multi-host T \
		--fixed-range-v4 ${NETWORK_CIDR}
	# (1-3) Verify creation of the network:
	nova net-list
}

function func_nova_network_create_initial_network()
{
	echo [$(hostname)] func_nova_network_create_initial_network..............................................................................
	
	source ~student/env/admin-openrc.sh
	# Add Security Groups  
	# Create New Security Groups 
	neutron security-group-create secur_student
	# Add Rule all ICMP
	neutron security-group-rule-create --direction ingress --ethertype IPv4 --protocol icmp --remote-ip-prefix 0.0.0.0/0 secur_student
	neutron security-group-rule-create --direction egress --ethertype IPv4 --protocol icmp --remote-ip-prefix 0.0.0.0/0 secur_student

	# Add Rule all tcp IPv4
	neutron security-group-rule-create --direction ingress --ethertype IPv4 --protocol tcp --port-range-min 1 --port-range-max 65535 --remote-ip-prefix 0.0.0.0/0 secur_student
	neutron security-group-rule-create --direction egress --ethertype IPv4 --protocol tcp --port-range-min 1 --port-range-max 65535 --remote-ip-prefix 0.0.0.0/0 secur_student

	#neutron security-group-rule-create --direction ingress --ethertype IPv4 --protocol tcp --port-range-min 22 --port-range-max 22 secur_student

	neutron security-group-rule-list

}