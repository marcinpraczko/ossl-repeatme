#!/bin/bash

# ----------------------------------------------------------------------------
# (C) 2013, Marcin Praczko, <marcin.praczko@gmail.com>
#
# This file is part of OSSL-repeatme
#
# OSSL-repeatme is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# OSSL-repeatme is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OSSL-repeatme. If not, see <http://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------
# Add SSH keys to know hosts (not hash hosts so far).
# ----------------------------------------------------------------------

# Quit if error
set -e

SSH_HOST_EXIST="no"
SSH_KHFILE_EXIST="no"

SSH_USER="vagrant"
FILE_SSH_KNOWHOST="/home/${SSH_USER}/.ssh/known_hosts"
MSG_PREFIX="(SSH Know hosts) | "

function check_host_if_exist_knowhosts() {
    if [ -f "${FILE_SSH_KNOWHOST}" ]; then
	SSH_KHFILE_EXIST="yes"

        # If not empty - Host key found
	ssh_key_localhost=`ssh-keygen -f "${FILE_SSH_KNOWHOST}" -F localhost`
	if [ ! "${ssh_key_localhost}" = "" ]; then
	    echo "${MSG_PREFIX}Host found, skipping."
	    SSH_HOST_EXIST="yes"
	fi
    fi
}

function add_host_to_knowhosts() {
    if [ "${SSH_HOST_EXIST}" = "no" ] || [ "${SSH_KHFILE_EXIST}" = "no" ]; then
	echo "${MSG_PREFIX} -> Host adding..."
	ssh-keyscan localhost,127.0.0.1 >>${FILE_SSH_KNOWHOST}
	chown ${SSH_USER}: ${FILE_SSH_KNOWHOST}
	chmod 0600 ${FILE_SSH_KNOWHOST}
	echo "${MSG_PREFIX} -> Host added."
    fi
}

# --- MAIN CODE ---
now=`date +"%Y-%m-%d %H:%M:%S"`
echo "[${now}] *** Script start ***"
echo "${MSG_PREFIX}Adding SSH Key to know hosts for localhost if not exists..."
check_host_if_exist_knowhosts
add_host_to_knowhosts
now=`date +"%Y-%m-%d %H:%M:%S"`
echo "[${now}] *** Start finished ***"

exit 0
