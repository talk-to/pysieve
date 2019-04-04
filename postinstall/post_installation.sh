#!/bin/bash

# Copyright (c) 2019 Krishna Kumar
# All rights reserved.
#
# Author: Krishna Kumar, 2019
#

function get_system() {
    echo `ps --no-headers -o comm 1`
}

function enable_sysVinit() {
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
			    echo "Needs sudo user"
			    exit 1
		    fi
        fi    
        # Start installing init script
        $sh_c 'cp /opt/pysieved/init_script/pysieved /etc/init.d/pysieved'
        $sh_c 'cp /opt/pysieved/cpanel_monitoring/sysVinit/pysieved /etc/chkserv.d/pysieved'
        retval=`echo $?`
        echo $retval
        if [ $retval -eq 0 ]
        then
            echo "Successfully put script into directory /etc/init.d/"
        else
            echo "Some Error occurred. Please copy init script manually.\nLocation of pysieved init file is /opt/pysieved/init_script/pysieved"
        fi

        $sh_c 'chkconfig --add pysieved'
        retval=`echo $?`
        [ $retval -eq 0 ] && $sh_c 'chkconfig --level 35 pysieved on'
        echo "Installation Succesful !!! \n"            
	fi
}

function enable_systemd() {
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
        $sh_c 'cp /opt/pysieved/systemd_service/pysieved.service /etc/systemd/system/pysieved.service'
        $sh_c 'cp /opt/pysieved/cpanel_monitoring/systemd/pysieved /etc/chkserv.d/pysieved'
        retval=`echo $?`
        echo $retval
        if [ $retval -eq 1 ]
        then
            echo "Successfully put systemd service file into directory /etc/systemd/system/pysieved.service"
        else
            echo "Some Error occurred. Please copy init script manually.\nLocation of pysieved init file is /opt/pysieved/systemd_service/pysieved.service"
        fi

        $sh_c 'systemctl enable pysieved.service'
        retval=`echo $?`
        [ $retval -eq 0 ] && echo "Installation Succesful !!! \n"           
              
	fi
}

function put_init() {
    local system=$(get_system)
    if [ "$system" = "systemd" ] 
    then
        echo "This is systemd enabled systemd"
        enable_systemd
    elif [ "$system" = "init" ]
    then 
        echo "This is SysVInit system"
        enable_sysVinit
    fi            
}

put_init
