ubuntu-in-a-box
===============

Just a simple little 32-bit Ubuntu 12.04 Vagrant box provisioned with Puppet. It's a collection of approaches we've found during our time learning joined by a few of our own contributions.

The server runs at `localhost.dev:8080`, so a hosts entry will be required for 127.0.0.1.

`public` and `log` folders will be created for you, so just `vagrant up` and have at it!

Assumptions
---------------
* You have [Vagrant](http://vagrantup.com/) installed (requires on 1.3.5+)
* You are using [Virtualbox](https://www.virtualbox.org/) as the VM provider
* You have created a host entry for `localhost.dev` to 127.0.0.1

What's Included?
---------------

A basic LAMP stack is set up using:

* Ubuntu 12.04 LTS 32-bit
* Apache 2.4.x
* PHP 5.5.x (using the ondrej PPA)
* MySQL 5.5.x
* Sendmail

In addition, a few tools are installed:

* Git
* cURL
* ACL

Known Issues
---------------

This particular version of Ubuntu can be a little finicky with current versions of Vagrant. Sometimes it will hang at the 'Configuring Network' stage for a minute or two on boot. Other times it will get stuck at the GRUB screen.
