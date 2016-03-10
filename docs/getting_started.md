
Quicklinks:<br/>
- [Hue interface https://hue.daplab.ch](https://hue.daplab.ch)<br/>
- SSH access `ssh -p 2201 pubgw1.daplab.ch`
{: .vscc-notify-success }


# Pre-requirements

* **SSH client** (for Windows, we recommend the use of [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
  and see [how to create a key with PuTTY](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-putty-on-digitalocean-droplets-windows-users))
* **A browser** -- well, if you can access this page, you should have met this requirement :)

# Creating an account

* &nbsp; &nbsp; Send your **public** SSH key to [Benoit](mailto:benoit@daplab.ch)
{: .fa .fa-arrow-right}

# Environment Setup

The following configuration can be added in your `~/.ssh/config` file:

```
Host pubgw1.daplab.ch
    Port 2201
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent yes
    ProxyCommand none
    ControlPersist 60s
    ControlMaster auto
    ControlPath ~/.ssh/ssh_control_%h_%p_%r
```

Please update accordingly the parameter `IdentityFile` in the above snippet. You might
also need to set a username using the `User` parameter.
{: .vscc-notify-warning }


# SSH into the gateway

```bash
ssh -p 2201 pubgw1.daplab.ch
```

For enhanced security reasons, we decided to move the SSH port to `2201`. Please remember that trick.
{: .vscc-notify-warning }


# Set a Password

Once we've ssh'ed in, you can set a password, which will allow you to login into HUE

```bash
sudo /usr/bin/passwd $LOGNAME

Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

You can now access the [Hue interface](https://hue.daplab.ch), and login with the username 
and password just set. If you loose your password, you can always change it the same 
way you just set it.
{: .vscc-notify-info }

# Python 2.7

In order to have python 2.7 as the default version, please run:

```
scl enable python27 bash
```

Validate that it's ok:
```
python --version
Python 2.7.5
```

## DAPLAB Admins Setup

This section is specific to the DAPLAB Admins in order to ease their life accessing
frequently different servers.

In order to access to every nodes transparently via the gw, the following lines can be 
added in `~/.ssh/config`

```
Host daplab-*.fri.lan
    StrictHostKeyChecking no
    ProxyCommand ssh pubgw1.daplab.ch nc %h 22 2> /dev/null
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
```

(_mind updating the params, more particularly the ssh key and the User_)

You can then ssh directly into any internal servers:

```
ssh daplab-rt-11.fri.lan
```

To access internal UIs from outside the DAPLAB wifi, you can use [sshuttle](https://github.com/apenwarr/sshuttle)
 
```bash
sshuttle --dns -r pubgw1.daplab.ch 10.10.10.0/24
```

And then you can ssh to daplab servers as if you where local to the infrastructure;

```bash
ssh daplab-wn-03
```

**MacOS Yosemite Users ?**

You need to add an extra route in order to have the setup working properly (more details
[here](http://www.evoila.de/openstack-opensource/running-a-poors-man-vpn-on-yosemite-with-sshuttle-and-ssh/?lang=en)):

```
sudo route add -net 10.10.10.0/24 160.98.23.11
```
