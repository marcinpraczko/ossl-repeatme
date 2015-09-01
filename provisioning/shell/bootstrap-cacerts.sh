#!/bin/bash

# ----------------------------------------------------------------------------
# (C) 2015, Marcin Praczko, <marcin.praczko@gmail.com>
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

# ----------------------------------------------------------------------------
# This shell script helps update ca-cacertificates on Linux
#
# Installation methods:
#   - From available packages (EPEL)
#
# Operating system:
#   - CentOS 6 / RHEL
# ----------------------------------------------------------------------------

SYSTEM=""
RELEASE_FILE=""

# --- Functions ---
# Detect system - so far only for CentOS / RHEL
function detect_system() {
    local release="/etc/redhat-release"

    if [ -f "${release}" ]; then
        SYSTEM=`cat ${release}`
        RELEASE_FILE="${release}"
    else
        echo "ERROR: This script can't detect operating system"
        echo "       Probably detection is not implemented yet"
        echo ""
        echo "Script terminated."
        exit 3
    fi
}

# Issue: #8 (https://github.com/marcinpraczko/ossl-repeatme/issues/8)
# Update ca-certs.
# This is required to allow install others repositories (like EPEL).
# During time CA-certificates changes and valid certs should be available
# from the begining of provsioning.
function update_ca_certs() {
    echo "-> Updating ca-certificates to latest version..."
    yum clean all
    # When EPEL is already installed - run:
    # yum -y upgrade --disablerepo=epel --disableplugin=fastestmirror ca-certificates
    yum -y upgrade --disableplugin=fastestmirror ca-certificates
}

# Display banner
function display_banner() {
    echo ""
    echo "--- === UPDATING CA-Certificates === ---"
    echo ""
}

# --- Main Code ---
display_banner
detect_system
update_ca_certs

exit 0
