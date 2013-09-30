#!/bin/bash

# ----------------------------------------------------------------------------
# 2013.09 by Marcin Praczko
#
# OSSL-repeatme project
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# This shell script helps install ansible on Linux
#
# Installation methods:
#   - From available packages (EPEL)
#
# Operating system:
#   - CentOS 6 / RHEL
# ----------------------------------------------------------------------------

SYSTEM=""
RELEASE_FILE=""

RH_RPMFORGE_LAST="rpmforge-release-0.5.3-1.el6.rf"
RH6_EPEL_LAST="epel-release-6-8.noarch"

RH6_RPM_EPEL_i386="http://dl.fedoraproject.org/pub/epel/6/i386/${RH6_EPEL_LAST}.rpm"
RH6_RPM_EPEL_x86_64="http://dl.fedoraproject.org/pub/epel/6/x86_64/${RH6_EPEL_LAST}.rpm"

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

# Install yum additional repo
function install_yum_repository() {
    local yumrepo="$1"
    local yumurl="$2"
    local rpm2chk="$3"

    echo " + ${yumrepo}:"
    rpm -q --quiet ${rpm2chk}
    rc=$?
    if [ ! $rc = 0 ]; then
        echo "  -> Installing..."
        rpm -i ${yumurl}
    else
        echo " -> Already installed, skipped..."
    fi
}

# Install RPMForge and EPEL yum repositories
function install_yum_repos() {
    arch=`uname -i`

    echo "-> Installing additional yum repositories..."
    case ${SYSTEM} in
        # CentOS 6.x
        "CentOS release 6."*)
            case ${arch} in
                i386)
                    url_epel="${RH6_RPM_EPEL_i386}"
                    ;;
                x86_64)
                    url_epel="${RH6_RPM_EPEL_x86_64}"
                    ;;
            esac
            ;;
        *)
            echo "ERROR: System '${SYSTEM}' is not supported by this script yet.."
            exit 3
            ;;
    esac

    # Install packages
    echo "Installing yum repositories..."
    install_yum_repository "EPEL" "${url_epel}" "epel-release"
}

# Install ansible from EPEL repository
function install_ansible_epel() {
    echo "-> Installing ansible from EPEL..."
    yum -q -y install ansible
}

# Display banner
function display_banner() {
    echo ""
    echo "--- === PROVISIONING === ---"
    echo ""
}

# --- Main Code ---
display_banner
detect_system
install_yum_repos
install_ansible_epel

exit 0
