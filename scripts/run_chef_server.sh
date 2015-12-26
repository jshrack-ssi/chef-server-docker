#!/bin/bash -xe

sysctl -w kernel.shmmax=17179869184 # for postgres 
/opt/opscode/embedded/bin/runsvdir-start &
# do not use 'chef-server-ctl start' instead

if [ x"$(hostname)" != x"$(grep server_name /etc/opscode/chef-server-running.json | sed 's/.*\"\(.*\)\".*\"\(.*\)\".*/\2/')" ]; then
    echo "Hostname changed, chef-server must be reconfigured"
    # if it fails, let someone in to correct it or find error.
    chef-server-ctl reconfigure || /bin/bash
fi

chef-server-ctl install opscode-manage

chef-server-ctl reconfigure && opscode-manage-ctl reconfigure

tail -F /opt/opscode/embedded/service/*/log/current
