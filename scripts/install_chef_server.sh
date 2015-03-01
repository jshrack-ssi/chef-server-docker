#!/bin/bash

apt-get update 
DEBIAN_FRONTEND=noninteractive apt-get install -y nano wget curl # https://github.com/docker/docker/issues/4032

# choose from: https://www.chef.io/download-open-source-chef-server-11/
# latest: www.opscode.com/chef/download-server?p=ubuntu&pv=12.04&m=x86_64&v=latest&prerelease=false&nightlies=false
# latest on 01 March 2015: https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.1.6-1_amd64.deb, it installs gem chef 11.12.2
#cd /tmp && wget --content-disposition "http://www.opscode.com/chef/download-server?p=ubuntu&pv=12.04&m=x86_64&v=latest&prerelease=false&nightlies=false"
cd /tmp && wget --content-disposition "http://archive.ai-traders.com/lab/1.0/cookbooks/ai_chef_server/files/chef-server_11.1.6-1_amd64.deb"
dpkg -i /tmp/chef-server*.deb

#/opt/chef-server/embedded/bin/runsvdir-start & # same as chef-server-ctl start but blocking (without '&')?
chef-server-ctl start
chef-server-ctl reconfigure
chef-server-ctl stop
cd /etc/chef-server/ && tar -cvzf knife_admin_key.tar.gz admin.pem chef-validator.pem

mv /scripts/run_chef_server.sh /usr/bin/on_container_first_run.sh
chmod 755 /usr/bin/on_container_first_run.sh
mv /scripts/run_chef_server.sh /usr/bin/run_chef_server.sh
chmod 755 /usr/bin/run_chef_server.sh