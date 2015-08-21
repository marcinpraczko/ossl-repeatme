#!/bin/bash

# ---------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Script helps mounting and unmounting LUKS files.
# By default on Linux there are requires a few steps to mount encrypted file
# system.
#
# VERSION: 0.1.0
# ---------------------------------------------------------------------------

# -- Global variables --
LCD=`pwd`
SCRIPT_NAME=`basename $0`

if [ ! $(id -u) -eq 0 ]; then
    echo ""
    echo "WARNING: Script must be run as root"
    echo "         Script terminated"
    echo ""
    exit 2
fi

# -- Functions --
function usage() {
    local msg="$1"	 
    
    if [ ! "$msg" = "" ]; then
	echo "ERROR: ${msg}"
    fi
    
    cat <<EOF

Usage: ${SCRIPT_NAME} [-h] 
       ${SCRIPT_NAME} -m LUKS_IMAGE
       ${SCRIPT_NAME} -s LUKS_IMAGE
       ${SCRIPT_NAME} -d LUKS_IMAGE

Where:
  -h - Display this usage screen
  -m - Mount LUKS image
  -m - Status of LUKS image
  -d - Umount LUKS image

Examples:
  ${SCRIPT_NAME} -m my_luks_image.img
  ${SCRIPT_NAME} -s my_luks_image.img
  
EOF
}

# Mount LUKS image
function LUKS_mount() {
    img="$1"
    img_dir="${img}_mount"
 
    if [ -b /dev/mapper/${img} ]; then
	echo ""
	echo "WARNING: Device '/dev/mapper/${img}' exists already"
	echo "         Please check status with command: cryptsetup status /dev/mapper/${img}"
	echo ""
	exit 1
    fi

    echo ""
    echo "=== Mounting LUKS image ==="
    echo "[+] Opening loop device"
    loop=$(losetup -f)
    echo "[i] Found loop device: ${loop}"
    echo "[+] Attaching file to loop device"
    losetup ${loop} ${img}
    losetup -a
    echo "[+] Opening LUKS (Password required)"
    cryptsetup luksOpen ${loop} ${img}
    echo "[+] Mounting LUKS to local folder: ${img_dir}"
    if [ ! -d "${img_dir}" ]; then
	mkdir -vp "${img_dir}"
    fi
    mount -v /dev/mapper/${img} ${img_dir}
}

# Umount LUKS image
function LUKS_umount() {
    img="$1"
    img_dir="${img}_mount"

    if [ ! -b /dev/mapper/${img} ]; then
	echo ""
	echo "WARNING: Device '/dev/mapper/${img}' not exists"
	echo "         It is possible that image was not mounted"
	echo ""
	exit 1
    fi

    echo ""
    echo "=== Umounting LUKS image ==="
    loop=$(cryptsetup status /dev/mapper/${img} | grep "device:" | cut -d":" -f 2 | tr -d " ")
    if [ -z "${loop}" ]; then
	echo "ERROR: Can't obtain loop device from command 'cryptsetup status'"
	echo "       Please investigate, script terminated."
	echo ""
	exit 2
    fi
    echo "[+] Unmounting LUKS from local folder"
    umount ${img_dir}
    echo "[+] Closing LUKS"
    cryptsetup luksClose ${img}
    echo "[+] Detaching file from loop device"
    losetup -d ${loop}
}

# Display LUKS_status
function LUKS_status() {
    img="$1"
    img_dir="${img}_mount"

    echo ""
    echo "=== Status about LUKS image ==="
    echo "Image: ${img}"
    file ${img}
    echo ""
    echo "=== Mount details ==="
    mount | grep --color="auto" "${img_dir}"
    echo ""
    echo "=== Details about device: /dev/mapper/${img} ==="
    cryptsetup status /dev/mapper/${img}
    echo ""
    echo "=== Details about loop devices ==="
    losetup -a
    echo ""
}

# Check if file exists
function check_if_exist() {
    img="$1"

    if [ ! -f "${img}" ]; then
	echo ""
	echo "ERROR: Can't open file: ${img}"
	echo "       Please investigate if filename is valid or file exists"
	echo ""
	exit 2
    fi
}

# -- Main code --
if [ $# -lt 1 ]; then
    usage "Missing arguments"
    exit 2
fi

while getopts :hd:m:s: OPT; do
    case $OPT in
	h|+h)
	    usage ""
	    exit 0
	    ;;
	m|+m)
	    check_if_exist "$OPTARG"
	    LUKS_mount "$OPTARG"
	    LUKS_status "$OPTARG"
	    ;;
	s|+s)
	    check_if_exist "$OPTARG"
	    LUKS_status "$OPTARG"
	    ;;
	d|+d)
	    check_if_exist "$OPTARG"
	    LUKS_umount "$OPTARG"
	    ;;
	*)
	    usage "Unknown arguments"
	    exit 2
    esac
done
shift `expr $OPTIND - 1`
OPTIND=1

exit 0
