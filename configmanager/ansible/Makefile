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

# ----------------------------------------------------------------------------
# Makefile for automation process running ansible
# ----------------------------------------------------------------------------

# TODO: UPDATE from normal projects

DIR_INVENTORY_SRC=inventory
DIR_INVENTORY_DST=/src/ansible-workspace/inventory
FILE_INVENTORY_OSSL_VMS=hosts_ossl_vms

# Ansible options to run
# OPTARG?=""

usage:
	@echo "Usage:"
	@echo "  setup-console-init - Setup initial configuration for ossl-console"
	@echo "  setup-build-hosts  - Setup build hosts"

# ========================================
# ==== Small subtasks ====
# ========================================
copy-invetory-file-tmp:
	@echo " + Copy inventory file to /tmp folder"
	@cp -f $(DIR_INVENTORY_SRC)/$(FILE_INVENTORY_OSSL_VMS) /tmp
	@chmod 644 /tmp/$(FILE_INVENTORY_OSSL_VMS)

copy-invetory-file:
	@echo " + Copy inventory file to $(DIR_INVENTORY_DST) folder"
	@cp -f $(DIR_INVENTORY_SRC)/$(FILE_INVENTORY_OSSL_VMS) $(DIR_INVENTORY_DST)
	@chmod 644 $(DIR_INVENTORY_DST)/$(FILE_INVENTORY_OSSL_VMS)

# ========================================
# ==== Targets ====
# ========================================
setup-console-init: copy-invetory-file-tmp
	@echo "=== Setup ossl-console (localhost) ==="
	@echo " + Run ansible"
	ansible-playbook $(OPTARG) -i /tmp/$(FILE_INVENTORY_OSSL_VMS) ossl-console-init.yml
	@rm -f /tmp/$(FILE_INVENTORY_OSSL_VMS)

setup-build-hosts: copy-invetory-file
	@echo "=== Setup build hosts ==="
	@echo " + Run ansible"
	ansible-playbook $(OPTARG) -i $(DIR_INVENTORY_DST)/$(FILE_INVENTORY_OSSL_VMS) ossl-buildservers.yml
