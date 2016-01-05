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
# Node : Controller

source ./kilo-perform-vars.common.sh

##################################################################################################
# Keystone
function func_keystone_install_package()
{
	echo [$(hostname)] func_keystone_install_package..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		echo "manual" > /etc/init/keystone.override
		apt-get -y install keystone python-openstackclient apache2 libapache2-mod-wsgi memcached python-memcache
	else
		yum -y install openstack-keystone httpd mod_wsgi python-openstackclient memcached python-memcached
	fi	
}

function func_keystone_start_memcached_service()
{
	echo [$(hostname)] func_keystone_start_memcached_service..............................................................................
	# Run Only CentOS
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service memcached start
		while ! (\
			(service memcached status >/dev/null 2>&1) \
			) do :; done
	else
		systemctl enable memcached.service
		systemctl start memcached.service
		echo "[CONTROLLER]===================================> start memcached.service"
		while ! systemctl is-active memcached.service >/dev/null 2>&1; do :; done
		echo "[CONTROLLER]===================================> start memcached.service Done!"
	fi	
}

function func_keystone_configure()
{
	echo [$(hostname)] func_keystone_configure..............................................................................
	# Edit the /etc/keystone/keystone.conf file and complete the following actions:

	crudini --set /etc/keystone/keystone.conf  DEFAULT admin_token ${ADMIN_TOKEN}

	crudini --set /etc/keystone/keystone.conf database connection mysql://keystone:${KEYSTONE_DBPASS}@controller/keystone

	crudini --set /etc/keystone/keystone.conf memcache servers localhost:11211

	crudini --set /etc/keystone/keystone.conf token provider keystone.token.providers.uuid.Provider
	crudini --set /etc/keystone/keystone.conf token driver keystone.token.persistence.backends.memcache.Token

	crudini --set /etc/keystone/keystone.conf revoke driver keystone.contrib.revoke.backends.sql.Revoke

	crudini --set /etc/keystone/keystone.conf DEFAULT verbose True


	if [ "$DEBUG_MODE" == "1" ];
	then
		crudini --set /etc/keystone/keystone.conf DEFAULT debug true
	fi 
	
	# Populate the Identity service database:
	su -s /bin/sh -c "keystone-manage db_sync" keystone

	# (3) To configure the Apache HTTP server
	# Edit the /etc/httpd/conf/httpd.conf file and configure the ServerName option to reference the controller node:
	#crudini --set /etc/httpd/conf/httpd.conf  DEFAULT ServerName controller

	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		echo "ServerName controller" >> /etc/apache2/apache2.conf
		# Create the /etc/apache2/sites-available/wsgi-keystone.conf file with the following content:
		cat << EOF > /etc/apache2/sites-available/wsgi-keystone.conf
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
      ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    LogLevel info
    ErrorLog /var/log/apache2/keystone-error.log
    CustomLog /var/log/apache2/keystone-access.log combined
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
      ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    LogLevel info
    ErrorLog /var/log/apache2/keystone-error.log
    CustomLog /var/log/apache2/keystone-access.log combined
</VirtualHost>
EOF
		# Enable the Identity service virtual hosts:
		ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
	else
		echo "ServerName controller" >> /etc/httpd/conf/httpd.conf

		# Create the /etc/httpd/conf.d/wsgi-keystone.conf file with the following content:
		cat > /etc/httpd/conf.d/wsgi-keystone.conf << EOF
Listen 5000
Listen 35357

<VirtualHost *:5000>
    WSGIDaemonProcess keystone-public processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-public
    WSGIScriptAlias / /var/www/cgi-bin/keystone/main
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>

<VirtualHost *:35357>
    WSGIDaemonProcess keystone-admin processes=5 threads=1 user=keystone group=keystone display-name=%{GROUP}
    WSGIProcessGroup keystone-admin
    WSGIScriptAlias / /var/www/cgi-bin/keystone/admin
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    LogLevel info
    ErrorLogFormat "%{cu}t %M"
    ErrorLog /var/log/httpd/keystone-error.log
    CustomLog /var/log/httpd/keystone-access.log combined
</VirtualHost>
EOF

	fi

	# Create the directory structure for the WSGI components:
	mkdir -p /var/www/cgi-bin/keystone

	#Copy the WSGI components from the upstream repository into this directory:
	curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
	  | tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin

	# Adjust ownership and permissions on this directory and the files in it:
	chown -R keystone:keystone /var/www/cgi-bin/keystone
	chmod 755 /var/www/cgi-bin/keystone/*
}


function func_keystone_start_httpd_service()
{
	echo [$(hostname)] func_keystone_start_httpd_service..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		service apache2 restart
		sleep 1
		echo "[CONTROLLER]===================================> start httpd.service"
		while ! service apache2 status >/dev/null 2>&1; do :; done
		echo "[CONTROLLER]===================================> start httpd.service Done!"
	else
		systemctl enable httpd.service
		systemctl start httpd.service
		echo "[CONTROLLER]===================================> start httpd.service"
		while ! systemctl is-active httpd.service >/dev/null 2>&1; do :; done
		echo "[CONTROLLER]===================================> start httpd.service Done!"
	fi	
}


function func_keystone_remove_sqllite_ubuntu()
{
	echo [$(hostname)] func_keystone_remove_sqllite_ubuntu..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
			# Enable the Identity service virtual hosts:
		rm -f /var/lib/keystone/keystone.db
	fi
}

function func_keystone_verify_operation()
{
	echo [$(hostname)] func_keystone_verify_operation..............................................................................
	if [ "$TARGET_OS_UBUNTU" = "1" ];
	then
		sed -ie "s/ admin_token_auth / /" /etc/keystone/keystone-paste.ini
	else
		sed -ie "s/ admin_token_auth / /" /usr/share/keystone/keystone-dist-paste.ini
	fi	

	# 3.4 Verify operation
	# or security reasons, disable the temporary authentication token mechanism:

	# Unset the temporary OS_TOKEN and OS_URL environment variables:
	unset OS_TOKEN OS_URL

	#As the admin user, request an authentication token from the Identity version 2.0 API:
	openstack --os-auth-url http://controller:35357 \
	  --os-project-name admin --os-username admin   --os-password ${ADMIN_PASS} \
	  token issue  

	openstack --os-auth-url http://controller:35357 \
	  --os-project-domain-id default --os-user-domain-id default \
	  --os-project-name admin --os-username admin  --os-password ${ADMIN_PASS} \
	  token issue

	openstack --os-auth-url http://controller:35357 \
	  --os-project-name admin --os-username admin --os-password ${ADMIN_PASS} \
	  project list

	openstack --os-auth-url http://controller:35357 \
	  --os-project-name admin --os-username admin --os-password ${ADMIN_PASS} \
	  user list

	openstack --os-auth-url http://controller:35357 \
	  --os-project-name admin --os-username admin --os-password ${ADMIN_PASS} \
	  role list

	openstack --os-auth-url http://controller:5000 \
	  --os-project-domain-id default --os-user-domain-id default \
	  --os-project-name demo --os-username demo --os-password ${DEMO_PASS} \
	  token issue

	# As the demo user, attempt to list users to verify that it cannot execute admin-only CLI commands:
	openstack --os-auth-url http://controller:5000 \
	  --os-project-domain-id default --os-user-domain-id default \
	  --os-project-name demo --os-username demo --os-password ${DEMO_PASS} \
	  user list

	# ERROR: openstack You are not authorized to perform the requested action, admin_required. (HTTP 403)
}



function func_keystone_make_client_environment_scripts()
{
	echo [$(hostname)] func_keystone_make_client_environment_scripts..............................................................................
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

	# To load client environment scripts
	source ~student/env/admin-openrc.sh
	openstack token issue
}


# function func_keystone_create_service_and_endpoint()
# {
# 	echo [$(hostname)] func_keystone_create_service_and_endpoint..............................................................................
# 	# Configure the authentication token:
# 	export OS_TOKEN=${ADMIN_TOKEN}

# 	# Configure the endpoint URL:
# 	export OS_URL=http://controller:35357/v2.0

# 	# (2) To create the service entity and API endpoint
# 	# Create the service entity for the Identity service:
# 	openstack service create \
# 	  --name keystone --description "OpenStack Identity" identity

# 	# Create the Identity service API endpoint:
# 	openstack endpoint create \
# 	  --publicurl http://controller:5000/v2.0 \
# 	  --internalurl http://controller:5000/v2.0 \
# 	  --adminurl http://controller:35357/v2.0 \
# 	  --region RegionOne \
# 	  identity
# }