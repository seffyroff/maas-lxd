#!/bin/bash

CONTAINER=$1

# Find LXC version
# MAJOR=$(lxc version | awk -F. '{print $1}')
# MINOR=$(lxc version | awk -F. '{print $2}')

# Create container
echo "Creating container $CONTAINER"
lxc profile create maas-profile 2> /dev/null
lxc profile edit maas-profile < maas-profile
# if [ $MAJOR -eq 2 ] && [ $MINOR -eq 0 ]
# then
#    lxc launch ubuntu:bionic $CONTAINER -p maas-profile
# else
    lxc profile create root-device 2> /dev/null
    lxc profile edit root-device < root-device
    lxc launch ubuntu:bionic $CONTAINER -p maas-profile -p root-device
# fi

echo "Sleeping to wait for IP"
sleep 10

# Setup LXD forward for pxe requests
# TODO: Make this work on 2.0.x stable LXC
IPADDRESS=$(lxc info $CONTAINER | awk -F"[: \t]+" '/eth0:.*inet[^6]/ {print $4}')
# # if [ $MAJOR -eq 2 ] && [ $MINOR -eq 0 ]
# # then
#     echo "LXC Stable branch not scripted for dnsmasq settings PXE will not work"
#     echo "To install the backport: apt install -t xenial-backports lxc lxc-client"
# # else
#     echo "Setting up pxe redirect for IP $IPADDRESS"
# #     lxc network set lxdbr0 raw.dnsmasq dhcp-boot=pxelinux.0,$CONTAINER,$IPADDRESS && systemctl restart lxd.service
# # fi

echo "MAAS will become available at: http://$IPADDRESS:5240/MAAS with user/password admin/admin"
