#!/bin/bash

# http://en.gentoo-wiki.com/wiki/OpenVPN#OpenVPN_on_Xen_DomU
# Error Message:
# Note: Cannot open TUN/TAP dev /dev/net/tun: \
#	No such device Note: \
#	Attempting fallback to kernel 2.2 TUN/TAP interface \
#	Cannot allocate TUN/TAP dev dynamically Exiting
#
# Fix this problem...
# 1. mkdir /dev/net
# 2. mknod /dev/net/tun c 10 200
# 3. chmod 0700 /dev/net/tun
# 4. modprobe tun
# 5. /etc/init.d/openvpn restart

if [[ ! -a /dev/net/tun  ]]
then
	echo "WARNING: TUN/TAP device missing."
	modprobe tun > /dev/null 2>&1
	mkdir /dev/net > /dev/null 2>&1
	mknod /dev/net/tun c 10 200
	chmod 0700 /dev/net/tun;
	if [[ ! -a /dev/net/tun  ]]
	then
		echo "ERROR: TUN/TAP device does not exist and I could not create it."
		exit 1
	fi
else
	if [[ ! $(stat --printf=%a /dev/net/tun) == 700 ]]
        then
		echo "TUN/TAP permissions incompatible, rebuilding device."
                rm -f /dev/net/tun
                rmmod tun > /dev/null 2>&1
		modprobe tun > /dev/null 2>&1
		mkdir /dev/net > /dev/null 2>&1
                mknod /dev/net/tun c 10 200
                chmod 0700 /dev/net/tun
                if [[ ! $(stat --printf=%a /dev/net/tun) == 700 ]]
                then
                        echo "ERROR: TUN/TAP device rebuild failed."
                else
                        echo "TUN/TAP device successfully rebuilt."
                fi
        else
        echo "TUN/TAP device created successfully."
        fi
fi





