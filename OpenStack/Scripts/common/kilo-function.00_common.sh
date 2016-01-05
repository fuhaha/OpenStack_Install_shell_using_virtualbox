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

source ./kilo-perform-vars.common.sh


##################################################################################################
# Init Database
function func_common_database_create_grant()
{
	echo [$(hostname)] func_common_database_create_grant................................................
	# Create the keystone database:
	echo mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE $1;"
	# Grant proper access to the $1 database:
	echo mysql -u root -p${DATABASE_ADMIN_PASS} -e "GRANT ALL PRIVILEGES ON $1.* TO \"$1\"@\"localhost\" IDENTIFIED BY \"$2\";"
	echo mysql -u root -p${DATABASE_ADMIN_PASS} -e "GRANT ALL PRIVILEGES ON $1.* TO \"$1\"@\"%\" IDENTIFIED BY \"$2\";"

	# Create the keystone database:
	mysql -u root -p${DATABASE_ADMIN_PASS} -e "CREATE DATABASE $1;"
	# Grant proper access to the $1 database:
	mysql -u root -p${DATABASE_ADMIN_PASS} -e \
	"GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost' IDENTIFIED BY '$2';"
	mysql -u root -p${DATABASE_ADMIN_PASS} -e \
	"GRANT ALL PRIVILEGES ON $1.* TO '$1'@'%' IDENTIFIED BY '$2';"
}

function func_common_create_project()
{
	echo [$(hostname)] func_common_create_project................................................
	# # Create the keystone database:
	# # Configure the authentication token:
	# export OS_TOKEN=${ADMIN_TOKEN}

	# # Configure the endpoint URL:
	# export OS_URL=http://controller:35357/v2.0

	echo openstack project create --description "$1" $2

	openstack project create --description "$1" $2
}



# func_common_Create_project_user_role "Admin Project" admin ${ADMIN_PASS} admin admin
function func_common_create_project_user_role()
{
	echo [$(hostname)] func_common_create_project_user_role................................................
	# # Configure the authentication token:
	# export OS_TOKEN=${ADMIN_TOKEN}

	# # Configure the endpoint URL:
	# export OS_URL=http://controller:35357/v2.0

	echo $1 # Description : "Admin Project"
	echo $2 # user : admin
	echo $3 # passwd : ${ADMIN_PASS}
	echo $4 # role : admin
	echo $5 # project : admin

	# Create the admin project:
	echo openstack project create --description "$1" $2
	echo openstack user create --password $3 $2
	echo openstack role create $4
	echo openstack role add --project $5 --user $2 $4

	# Create the admin project:
	openstack project create --description "$1" $2

	# Create the admin user:
	# echo openstack user create --password-prompt admin
	# openstack user create --password-prompt admin
	# openstack user create --project admin --password ${ADMIN_PASS} admin
	openstack user create --password $3 $2
	# User Password:
	# Repeat User Password:

	# Create the admin role:
	openstack role create $4

	# Add the admin role to the admin project and user:
	openstack role add --project $5 --user $2 $4
}

# func_common_create_user_role [user] [passwd] [role] [project]
# func_common_create_user_role glance ${GLANCE_PASS} admin service
function func_common_create_user_role()
{
	echo [$(hostname)] func_common_create_user_role................................................

	echo $1 # user : glance
	echo $2 # passwd : ${GLANCE_PASS}
	echo $3 # role : admin
	echo $4 # project : service

	# Create the admin project:
	echo openstack user create --password $2 $1
	echo openstack role add --project $4 --user $1 $3

	# Create the admin user:
	openstack user create --password $2 $1

	# Add the admin role to the admin project and user:
	openstack role add --project $4 --user $1 $3
}

# func_common_create_service_and_endpoint [name]  [description] [server-name] [publicurl] [internalurl] [adminurl]
# func_common_create_service_and_endpoint keystone  "OpenStack Identity" identity http://controller:5000/v2.0 http://controller:5000/v2.0 http://controller:35357/v2.0
function func_common_create_service_and_endpoint()
{
	echo [$(hostname)] func_common_create_service_and_endpoint.................................................

	echo $1 # name : keystone
	echo $2 # description : "OpenStack Identity"
	echo $3 # server-name : identity
	echo $4 # publicurl : http://controller:5000/v2.0
	echo $5 # internalurl : http://controller:5000/v2.0
	echo $6 # adminurl : http://controller:35357/v2.0


	# To create the service entity and API endpoint
	# Create the service entity for the Identity service:
	echo openstack service create --name $1 --description \"$2\" $3

	# Create the Identity service API endpoint:
	echo openstack endpoint create --publicurl $4 --internalurl $5 --adminurl $6 --region RegionOne $3	

	openstack service create --name $1 --description "$2" $3

	# Create the Identity service API endpoint:
	openstack endpoint create --publicurl $4 --internalurl $5 --adminurl $6 --region RegionOne $3	
}

function func_common_make_client_environment_scripts()
{
	echo [$(hostname)] func_common_make_client_environment_scripts..............................................................................
	# 3.5 Create OpenStack client environment scripts
	# To create the scripts
	mkdir ~student/env
	cat > ~student/env/admin-openrc.sh << EOF
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=pass_for_admin
export OS_AUTH_URL=http://controller:35357/v3
export OS_REGION_NAME=RegionOne
EOF

	cat > ~student/env/demo-openrc.sh << EOF
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=pass_for_demo
export OS_AUTH_URL=http://controller:5000/v3
export OS_REGION_NAME=RegionOne
EOF

	chown -R student:student  ~student/env

	# # To load client environment scripts
	# source ~student/env/admin-openrc.sh
	# openstack token issue
}