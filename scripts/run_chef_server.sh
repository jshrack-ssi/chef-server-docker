#!/bin/bash -xe

sysctl -w kernel.shmmax=17179869184 # for postgres 
/opt/opscode/embedded/bin/runsvdir-start &
# do not use 'chef-server-ctl start' instead

if [ x"$(hostname)" != x"$(grep server_name /etc/opscode/chef-server-running.json | sed 's/.*\"\(.*\)\".*\"\(.*\)\".*/\2/')" ]; then
    echo "Hostname changed, chef-server must be reconfigured"
    # if it fails, let someone in to correct it or find error.
    chef-server-ctl reconfigure || /bin/bash
fi

## Manage
apt-get update

chef-server-ctl install opscode-manage

rm -f /var/lib/apt/lists/partial/packagecloud.io_chef_stable_ubuntu_dists_lucid_main_*

chef-server-ctl install opscode-manage

/opt/opscode-manage/embedded/bin/runsvdir-start &

chef-server-ctl reconfigure && opscode-manage-ctl reconfigure

## Reporting
chef-server-ctl install opscode-reporting

/opt/opscode-reporting/embedded/bin/runsvdir-start &

chef-server-ctl reconfigure && opscode-reporting-ctl reconfigure

chef-server-ctl user-create jshrack Jason Shrack jshrack@gmail.com mT1MIVdheo20 --filename /root/chef_server_admin.pem && \
chef-server-ctl org-create killbox1a "KillBox1A" --association_user jshrack --filename /root/killbox1a-validator.pem

tail -F /opt/opscode/embedded/service/*/log/current
