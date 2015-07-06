======
README
======


Table of Contents
=================

.. contents::
   :depth: 3


OSSL-repeatme
=============

:Version: 0.1.0
:Source: `<https://github.com/marcinpraczko/ossl-repeatme>`_


This project aims to help to practice tasks related with server/services administration.
The idea is to use vagrant and ansible for quick setup services.

OSSL-repeatme is a basic project which allow repeat tasks, for example
related with:

* service installation
* code deployment


Requirements
============

* VirtualBox: Version >= **4.1.16** (configured to allow run x86_64 machines). Recommended version **4.2.x**
* Vagrant: Version = **1.2.X** (on 1.3.X there are some issues with shared folders).
* Access to internet during first setup.


Vagrant OSSL images
===================

* This project uses image: `<http://www.silentlinux.info/vagrantbox/ossl_vagrant_centos_64_x86_64.box>`_
* Image has been created with project: `<https://github.com/marcinpraczko/ossl-ansible-vagrantbox-init>`_


Achieved goals - so far
=======================

This project allows to setup CentOS 6.X **64bit** with pre-installed Jenkins + default Jenkins plugins.


Quick setup
===========

Jenkins
-------

Run Vagrant VM
++++++++++++++

* After cloning git repository, please navigate to main console folder (we call it ossl-console)

::

  cd ossl-repeatme/vagrantfiles/ossl-main_console
  vagrant up

* Vagrant will download the VM image.
* Vagrant should boot VM under VirtualBox.
* Vagrant should install ansible from EPEL repository.

Get access to ossl-console VM
+++++++++++++++++++++++++++++

After vagrant boots VM, please read the output and take notes about port forwarding, it will be
required to gain access to the box using SSH.

Now you can login to VM via SSH:

**Please note**, that port below can vary depending if others VMs has been
running by vagrant before ossl-console was started.

* Connect with **localhost** and port **2222**
* Username: **vagrant**
* Password: **vagrant**

More details about access to VMs, please see `vm_access`_ section.


Initial setup for VM ossl-console
+++++++++++++++++++++++++++++++++

After login to VM please run following commands to perform initial setup for
VM ossl-console. *(These commands should be run as normal user)*

::

  cd /src/ansible
  make setup-console-init

If everything is working as expected ansible should display message:

::

  PLAY RECAP ********************************************************************
  ossl-console               : ok=9    changed=1    unreachable=0    failed=0


Setup jenkins on VM ossl-console
++++++++++++++++++++++++++++++++

When initial setup has been done, jenkins can be installed by running
following command: (it may take a while)

::

  make setup-build-hosts

If everything is working as expected ansible should display message:

::

 PLAY RECAP ********************************************************************
 ossl-console               : ok=10   changed=9    unreachable=0    failed=0


Get access to Jenkins installed on ossl-console VM
++++++++++++++++++++++++++++++++++++++++++++++++++

Default jenkins installation is available by hitting from host URL:

* http://localhost:18080/


Important details related to the project
========================================

Internal network configuration
------------------------------

+--------------+-----------------+
| Network      | 192.168.79.0/24 |
+==============+=================+
| Host         |              IP |
+--------------+-----------------+
| ossl-console |  192.168.79.254 |
+--------------+-----------------+
| ossl-test1   |  192.168.79.252 |
+--------------+-----------------+
| ossl-test2   |  192.168.79.253 |
+--------------+-----------------+


Port forwarding to guests
-------------------------

Current configuration has following port forwarding settings

+--------------+---------+------------+------------+----------------------------------+
| Host         | Service | Port on PC | Port on VM | Info                             |
+==============+=========+============+============+==================================+
| ossl-console | SSH     |            |            | Dynamically allocated by vagrant |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTP    |      10080 |         80 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTPS   |      10443 |        443 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | Jenkins |      18080 |       8080 |                                  |
+--------------+---------+------------+------------+----------------------------------+
| ossl-test1   | SSH     |            |            | Dynamically allocated by vagrant |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTP    |      20080 |         80 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTPS   |      20443 |        443 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | Jenkins |      28080 |       8080 |                                  |
+--------------+---------+------------+------------+----------------------------------+
| ossl-test2   | SSH     |            |            | Dynamically allocated by vagrant |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTP    |      30080 |         80 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | HTTPS   |      30443 |        443 |                                  |
+--------------+---------+------------+------------+----------------------------------+
|              | Jenkins |      38080 |       8080 |                                  |
+--------------+---------+------------+------------+----------------------------------+


.. _vm_access:

Access over SSH to OSSL vagrant VMs
-----------------------------------

Not root user
+++++++++++++

Vagrant VMs has been created based on **'vagrant'** guide about configuration, this include:

* username: **vagrant**
* password: **vagrant**
* access to vagrant user with insecure vagrant SSH pair keys

Root user
+++++++++

* username: **root**
* password: **vagrant**
* access to root from vagrant user

::

  sudo -i -u root


Run commands as root
--------------------

* Sudo configuration allows all users belonging to admin group to run commands
  as root without knowing password
* For example as 'vagrant' user.

::

  sudo ls -la /root

Summary
=======

I hope that this project will help you to repeat some configurations much
quicker. Using it you can enjoy working on your projects instead of spending
countless hours trying to repeat same configurations again and again.
