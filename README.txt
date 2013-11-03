                                  README.txt
                                  ==========

Author: Marcin Praczko
Date: 2013-11-03 15:02:54 GMT


Table of Contents
=================
1 OSSL-repeatme
2 Requirements
3 Vagrant OSSL images:
4 Achieved goals - so far
5 Quick setup
    5.1 Jenkins
        5.1.1 Run Vagrant VM
        5.1.2 Get access to OSSL main console VM
        5.1.3 Initial setup for VM ossl-console
        5.1.4 Setup jenkins on VM ossl-console
        5.1.5 Get access to Jenkins installed on ossl-console VM
6 Main details related with project.
    6.1 Internal network configuration
    6.2 Port forwarding to guests
    6.3 Access over SSH to OSSL vagrant VMs
    6.4 Access to root account.
    6.5 Run commands as root
7 Summary


1 OSSL-repeatme 
----------------
  - Source: [https://github.com/marcinpraczko/ossl-repeatme]
  - Version: 0.1.0

OSSL-repeatme is a basic project which allow repeat tasks, for example
related with:
- service installation
- deploying code

This project should help to practice tasks related with administration.
The idea is to use vagrant and ansible for quick setup services.

2 Requirements 
---------------
  - VirtualBox: Version >= 4.1.16 (Configured to allow run x86_64 machines).
  - Vagrant: Version = 1.2.X (on 1.3.X there are some issues with shared folders).
  - Access to internet during first setup.

3 Vagrant OSSL images: 
-----------------------
  - This project uses image: [OSSL CentOS 6.4 x86_64]
  - Image has been created with project: [ossl-ansible-vagrant-init]


  [OSSL CentOS 6.4 x86_64]: http://www.silentlinux.info/vagrantbox/ossl_vagrant_centos_64_x86_64.box
  [ossl-ansible-vagrant-init]: https://github.com/marcinpraczko/ossl-ansible-vagrantbox-init

4 Achieved goals - so far 
--------------------------
  - This project allow setup CentOS 6.X 64b with installed Jenkins + default
    jenkins plugins.

5 Quick setup 
--------------

5.1 Jenkins 
============

5.1.1 Run Vagrant VM 
~~~~~~~~~~~~~~~~~~~~~
   - After check-out from git repository, please go to main console VM


  cd ossl-repeatme/vagrantfiles/ossl-main_console
  vagrant up


   - Vagrant should boot VM under VirtualBox
   - Vagrant should install ansible from EPEL repository

5.1.2 Get access to OSSL main console VM 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    After boot VM, please make notes about port forwarding, it will be required below. Login to VM via SSH:
    -  Connect with localhost and port 2222 (This port can be different if
       others VMs has been running first by vagrant).

5.1.3 Initial setup for VM ossl-console 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   After login to VM please run following commands to initial setup for VM ossl-console.
   - These commands should be run as normal user


  cd /src/ansible
  make setup-console-init


   - If everything is working as expected ansible should display message:


  PLAY RECAP ********************************************************************
  ossl-console               : ok=7    changed=4    unreachable=0    failed=0


5.1.4 Setup jenkins on VM ossl-console 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   When initial setup has been done, jenkins can be installed by running (it will take a while)


  make setup-build-hosts


   - If everything is working as expected ansible should display message:


  PLAY RECAP ********************************************************************
  ossl-console               : ok=10   changed=9    unreachable=0    failed=0


5.1.5 Get access to Jenkins installed on ossl-console VM 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   - Default jenkins installation is available by hitting from host URL:


  http://localhost:18080/


6 Main details related with project. 
-------------------------------------

6.1 Internal network configuration 
===================================
  Network        192.168.79.0/24  
 --------------+-----------------
  Host                        IP  
 --------------+-----------------
  ossl-console    192.168.79.254  
  ossl-test1      192.168.79.252  
  ossl-test2      192.168.79.253  

6.2 Port forwarding to guests 
==============================
   Current configuration has following port forwarding settings
  Host           Service   Port on PC   Port on VM   Info                              
 --------------+---------+------------+------------+----------------------------------
  ossl-console   SSH                                 Dynamically allocated by vagrant  
                 HTTP           10080           80                                     
                 HTTPS          10443          443                                     
                 Jenkins        18080         8080                                     
 --------------+---------+------------+------------+----------------------------------
  ossl-test1     SSH                                 Dynamically allocated by vagrant  
                 HTTP           20080           80                                     
                 HTTPS          20443          443                                     
                 Jenkins        28080         8080                                     
 --------------+---------+------------+------------+----------------------------------
  ossl-test2     SSH                                 Dynamically allocated by vagrant  
                 HTTP           30080           80                                     
                 HTTPS          30443          443                                     
                 Jenkins        38080         8080                                     

6.3 Access over SSH to OSSL vagrant VMs 
========================================
   Vagrant VMs has been created based on 'vagrant' guide about configuration, this include:
   - username: vagrant
   - password: vagrant
   - access to vagrant user with insecure vagrant SSH pair keys

6.4 Access to root account. 
============================
   - password for root: vagrant
   - access to root from vagrant user


  sudo -i -u root


6.5 Run commands as root 
=========================
   - Sudo configuration allow all users belong to admin group run commands as
     root without knowing password:
   - For example as 'vagrant' user.


  sudo ls -la /root


7 Summary 
----------
  I hope that this project will help you repeat some configuration much more
  quicker and enjoy working on your projects instead spending time of trying
  repeat some configuration for long hours.
