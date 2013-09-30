                                  README.txt
                                  ==========

Author: Marcin Praczko
Date: 2013-09-30 22:20:51 BST


Table of Contents
=================
1 OSSL-repeatme
2 Requirements
3 Vagrant OSSL images:
4 Quick setup - Jenkins.
    4.1 Run Vagrant VM
    4.2 Get access to OSSL main console VM
    4.3 Initial setup for VM ossl-console
    4.4 Setup jenkins on VM ossl-console
    4.5 Get access to Jenkins installed on ossl-console VM
5 Main details about credentials.
    5.1 Access over SSH to OSSL vagrant VMs
6 Summary


1 OSSL-repeatme 
----------------
  - Source: [https://github.com/marcinpraczko/ossl-repeatme]
  - Version: 0.1.0

This project should help to practice tasks related with administration.

The idea is to use vagrant and ansible for quick setup services and practice on
them.

2 Requirements 
---------------
  - VirtualBox: Version >= 4.1.16 (Configured to allow run x86_64 machines).
  - Vagrant: Version = 1.2.X (on 1.3.X there are some issues with shared folders).
  - Access to internet during first setup.

3 Vagrant OSSL images: 
-----------------------
  - This project uses image: [OSSL CentOS 6.4 x86_64]


  [OSSL CentOS 6.4 x86_64]: http://www.silentlinux.info/vagrantbox/ossl_vagrant_centos_64_x86_64.box

4 Quick setup - Jenkins. 
-------------------------
So far this project allow setup CentOS 6.X 64b with installed jenkins.

4.1 Run Vagrant VM 
===================
   - After check-out from git repository, please go to main console VM


  cd ossl-repeatme/vagrantfiles/ossl-main_console
  vagrant up


   - Vagrant should boot VM under VirtualBox
   - Vagrant should install ansible from EPEL repository

4.2 Get access to OSSL main console VM 
=======================================
   After boot VM, please make notes about port forwarding, it will be required below. Login to VM via SSH:
   -  Connect with localhost and port 2222 (if not others VMs are running)

4.3 Initial setup for VM ossl-console 
======================================
   After login to VM please run following commands to initial setup for VM ossl-console.
   - These commands don't must be run as normal user 'vagrant'


  cd /src/ansible
  make setup-console-init


   - If everything is working as expected ansible should display message:


  PLAY RECAP ********************************************************************
  ossl-console               : ok=7    changed=4    unreachable=0    failed=0


4.4 Setup jenkins on VM ossl-console 
=====================================
   When initial setup has been done, jenkins can be installed by running (it will take a while)


  make setup-build-hosts


   - If everything is working as expected ansible should display message:


  PLAY RECAP ********************************************************************
  ossl-console               : ok=10   changed=9    unreachable=0    failed=0


4.5 Get access to Jenkins installed on ossl-console VM 
=======================================================
   - Default jenkins installation is available by hitting from host URL:


  http://localhost:18080/


5 Main details about credentials. 
----------------------------------

5.1 Access over SSH to OSSL vagrant VMs 
========================================
   Vagrant VMs has been created based on 'vagrant' guide about configuration, this include:
   - username: vagrant
   - password: vagrant
   - password for root: vagrant
   - access to vagrant user with insecure vagrant SSH pair keys
   - access to root from vagrant user


  sudo -i -u root


6 Summary 
----------
  I hope that this project will help you repeat some configuration much more
  quicker and enjoy working on your projects instead spending time of trying
  repeat some configuration for long hours.
