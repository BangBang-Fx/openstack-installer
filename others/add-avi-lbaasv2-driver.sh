set -e
set -x

# explicitly set locale to avoid any pip install issues
export LC_ALL=C

avi_cntr_ip="10.10.39.219"
if [ $# -gt 0 ]; then
   avi_cntr_ip=$1
fi
avi_admin_passwd="avi123\$%"
if [ $# -gt 1 ]; then
   avi_admin_passwd=$2
fi
pip install /root/avi-lbaasv2-*.tar.gz 
sed -i 's/service_provider = LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default/service_provider = LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver\nservice_provider = LOADBALANCERV2:avi_adc:avi_lbaasv2.avi_driver.AviDriver:default/' /etc/neutron/neutron.conf

cat << EOF >> /etc/neutron/neutron.conf
[avi_adc]
address=$avi_cntr_ip
user=admin
password="$avi_admin_passwd"
cloud=openstack
EOF

service neutron-server restart
sleep 60
