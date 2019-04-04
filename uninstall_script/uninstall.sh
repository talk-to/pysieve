#!/bin/bash

# Copyright (c) 2019 Krishna Kumar
# All rights reserved.
#
# Author: Krishna Kumar, 2019
#

function get_system() {
    echo `ps --no-headers -o comm 1`
}

function delete_sysVinit() {
    if [ -d /etc/init.d/ ]
    then
        user="$(id -un 2>/dev/null || true)"

	    sh_c='sh -c'
	    if [ "$user" != 'root' ]; then
		    if command_exists sudo; then
			    sh_c='sudo -E sh -c'
		    elif command_exists su; then
			    sh_c='su -c'
		    else
			    echo "Needs root priviledges\n"
			    exit 1
		    fi
        fi    
        # Start installing init script
        $sh_c 'rm /etc/init.d/pysieved'
        $sh_c 'rm -r /opt/pysieved'
        $sh_c 'rm /etc/chkserv.d/pysieved'
        echo "Deleted init.d script" 
        echo "Deleted directory /opt/pysieved"
                    
	fi
}

function delete_systemd() {
    if [ -d /etc/systemd/ ]
    then
        user="$(id -un 2>/dev/null || true)"

	    sh_c='sh -c'
	    if [ "$user" != 'root' ]; then
		    if command_exists sudo; then
			    sh_c='sudo -E sh -c'
		    elif command_exists su; then
			    sh_c='su -c'
		    else
			    echo "Needs sudo user"
			    exit 1
		    fi
        fi    
        # Start installing init script
        $sh_c 'rm /etc/systemd/system/pysieved.service'
        $sh_c 'rm -r /opt/pysieved'
        $sh_c 'rm /etc/chkserv.d/pysieved'
        echo "Deleted pysieved.service file" 
        echo "Deleted directory /opt/pysieved"
        echo "Deleted /etc/chkserv.d/pysieved"
              
              
	fi
}

function uninstall() {
    local system=$(get_system)
    if [ "$system" = "systemd" ] 
    then
        echo "This is systemd enabled systemd"
        delete_systemd
    elif [ "$system" = "init" ]
    then 
        echo "This is SysVInit system"
        delete_sysVinit
    fi            
}

uninstall
