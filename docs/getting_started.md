# Accessing the DAPLAB

Quicklinks:<br/>
- [Hue interface -- https://hue.daplab.ch](https://hue.daplab.ch)<br/>
- SSH access `ssh -p 2201 pubgw1.daplab.ch`
{: .vscc-notify-success }


## Pre-requirements

* **SSH client** (for Windows, we recommend the use of [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
  and see [how to create a key with PuTTY](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-putty-on-digitalocean-droplets-windows-users))
* **A browser** -- well, if you can access this page, you should have met this requirement :)

## Creating an account

* &nbsp; &nbsp; Send your **public** SSH key to [Benoit](mailto:benoit@daplab.ch)
{: .fa .fa-arrow-right}

Please read carefully the first login section below for the first login.
{: .vscc-notify-warning }


## Environment Setup

The following configuration can be added in your `~/.ssh/config` file:

```
Host pubgw1.daplab.ch
    Port 2201
    PreferredAuthentications publickey,password
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent yes
    ProxyCommand none
    ControlPersist 60s
    ControlMaster auto
    ControlPath ~/.ssh/ssh_control_%h_%p_%r
```

Please update accordingly the parameter `IdentityFile` in the above snippet. You might
also need to set a username using the `User` parameter.
{: .vscc-notify-info }


## SSH into the gateway

```bash
ssh -p 2201 pubgw1.daplab.ch
```

For enhanced security reasons, we decided to move the SSH port to `2201`. If you
use the ssh config above, you're not forced to remember this trick
{: .vscc-notify-warning }


## First login: Set a Password

The first time you'll login into the server, you'll have to set a new password.
You should have received the initial, temporary password via email. If not,
[request the password again](mailto:benoit@daplab.ch?Subject=Password Recovery).

The password has to contain letters, numbers and special characters, and can't be based
on a dictionary word.
{: .vscc-notify-warning }

```bash
$ ssh pubgw1.daplab.ch
bperroud@pubgw1.daplab.ch's password:
Password expired. Change your password now.
Last login: Thu Apr  7 08:19:24 2016 from 10.10.10.109
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user bperroud.
Current Password:
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
Shared connection to pubgw1.daplab.ch closed.
```

You can now access the [Hue interface](https://hue.daplab.ch), and login with the username
and password just set. If you lost your password, you can always
[request the re-generate the password](mailto:benoit@daplab.ch?Subject=Password Recovery).


## Python version

The DAPLAB has both python2.7 and python3.4 installed. To switch between them,
use one of the `module load` commands below:

```
module load python2.7
module load python3.4
```

You can validate that it's ok by running `python --version`.

Woot!

# DAPLAB Admins Setup

This section is specific to the DAPLAB Admins in order to ease their life accessing
frequently different servers.

In order to access to every nodes transparently via the gateway, the following lines can be
added in `~/.ssh/config`:

```
Host daplab-*.fri.lan
    StrictHostKeyChecking no
    ProxyCommand ssh pubgw1.daplab.ch nc %h 22 2> /dev/null
    PreferredAuthentications publickey,password
    IdentityFile ~/.ssh/id_rsa
```

(_mind updating the params, more particularly the ssh key and the User_)

You can then ssh directly into any internal servers:

```
ssh daplab-rt-11.fri.lan
```

To access internal UIs from outside the DAPLAB wifi, you can use [sshuttle](https://github.com/apenwarr/sshuttle):

```bash
sshuttle --dns -r pubgw1.daplab.ch 10.10.10.0/24
```

And then you can ssh to daplab servers as if you where local to the infrastructure;

```bash
ssh daplab-gw-1.fri.lan
```

You are a **MacOS Yosemite User ?**

Then, you need to add an extra route in order to have the setup working properly (more details
[here](http://www.evoila.de/openstack-opensource/running-a-poors-man-vpn-on-yosemite-with-sshuttle-and-ssh/?lang=en)):

```
sudo route add -net 10.10.10.0/24 160.98.23.11
```
