# Accessing the DAPLAB

<!-- Quicklinks:<br/>
- [Hue interface -- https://hue.daplab.ch](https://hue.daplab.ch)<br/> -->
SSH access &nbsp; ➙ &nbsp; `ssh -p 2202 pubgw1.daplab.ch`
{: .vscc-notify-info }


## Requirements

* **SSH client** (for Windows, we recommend the use of [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html){:target="_blank"}
  and see [how to create a key with PuTTY](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-putty-on-digitalocean-droplets-windows-users){:target="_blank"})
* **A browser** -- well, if you can access this page, you should have met this requirement :)

## Creating an account

Here are the steps to create a new DAPLAB account:

0. go to [https://portal.daplab.ch](https://portal.daplab.ch){:target="_blank"}

![portal menubar](images/new-user.png)

1. select "New User" on the top menubar and fill the form. You will soon receive a confirmation email (as soon as an administrator got the time to review your application form).

2. Once the email received, you can go to <a href="https://portal.daplab.ch/request_reset" target="_blank">Request Password Reset</a> and enter your
  username. You will immediately receive an email containing a _token_.

3. Go to <a href="https://portal.daplab.ch/reset_password" target="_blank">Finish Password Reset</a>, enter your username as well as the _token_ you
  just received by email. This last step will give you a temporary password.

That's it ! Now, it's time for your first login. 

## First login

Once you get your temporary password, you can log into the gateway via ssh:
```bash
ssh -p 2202 yourusername@pubgw1.daplab.ch
```

A prompt will ask you your temporary password, then ask you for a new one. Please, ensure your password is strong enough !

The password has to contain letters, numbers and special characters, and can't be based
on a dictionary word.
{: .vscc-notify-warning }

Congrats, you are now a Daplab user !

For enhanced security reasons, we decided to move the SSH port to `2202`. If you use the ssh config described below, you're not forced to remember this trick.


<!-- You can now access the [Hue interface](https://hue.daplab.ch), and login with the username
and password just set. If you lost your password, you can always
[re-generate the password](https://portal.daplab.ch/request_reset).
{: .vscc-notify-success } -->

# SSH keys

## Using a key instead of a password

In case you don't want to login with a password every time, you can copy your public key to the `~/.ssh/authorized_keys` file in your daplab home directory.

__Create a key__: If you don't already have a key on your system, you need to generate one. On a unix-based system, creating a ssh key is done using `ssh-keygen -t rsa -b 2048`. It should generate two files (private and public key) which default to `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` respectively.

__Copy your key__: On your local system, navigate to `~/.ssh` and copy the content of your public key file (the one ending with `.pug`). SSH into the daplab and paste it to the `~/.ssh/authorized_keys` file (you might need to create it). Note that those steps can also be performed automatically by using the commandline tool `ssh-copy-id`.

Once this is done, you can use the tricks described below.

## Environment Setup

The following configuration can be added in your `~/.ssh/config` file (given you have setup the key-based ssh login):

```
Host pubgw1.daplab.ch
    Port 2202
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


# DAPLAB Admins Setup

This section is specific to the DAPLAB Admins in order to ease their life accessing
frequently different servers.

In order to access every nodes transparently via the gateway, the following lines can be
added in `~/.ssh/config`:

```
Host daplab-*.fri.lan
    StrictHostKeyChecking no
    ProxyCommand ssh pubgw1.daplab.ch nc %h 22 2> /dev/null
    PreferredAuthentications publickey,password
    IdentityFile ~/.ssh/id_rsa
```

(_mind updating the params, more particularly the ssh key and the User_)

You can then ssh directly into any internal server:

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
