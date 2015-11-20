
Quicklinks:<br/>
- [Hue interface https://api.daplab.ch](https://api.daplab.ch)<br/>
- SSH access `ssh pubgw1.daplab.ch`
{: .vscc-notify-success }


# Pre-requirements

* **SSH client** (for Windows, we recommend the use of [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html)
  and see [how to create a key with PuTTY](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-putty-on-digitalocean-droplets-windows-users))
* **A browser** -- well, if you can access this page, you should have met this requirement :)

# Creating an account

 ==> Send your **public** SSH key to Benoit

# Environment Setup

The following configuration can be added in your `~/.ssh/config` file:

```
Host pubgw1.daplab.ch
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent yes
    ProxyCommand none
    ControlPersist 60s
    ControlMaster auto
    ControlPath ~/.ssh/ssh_control_%h_%p_%r
```

Please update accordingly the parameter `IdentityFile` in the snippet above. You might
also need to set a username using the `User` parameter.
{: .vscc-notify-warning }


# SSH into the gateway

```bash
ssh pubgw1.daplab.ch
```

# Set a Password

Once we've ssh'ed in, you can set a password, which will be used to login into HUE

```bash
passwd
```

And then access [Hue interface](https://api.daplab.ch)

## DAPLAB Admin setup

In order to access to every nodes, transparently via the gw, you can add the following 
config in your `~/.ssh/config`

```
Host daplab-*.fri.lan
    StrictHostKeyChecking no
    ProxyCommand ssh bperroud@pubgw1.daplab.ch nc %h 22 2> /dev/null
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/id_rsa_daplab_new
    User daplabadm
```

    
To access internal UI from outside the DAPLAB wifi, you can use [sshuttle](https://github.com/apenwarr/sshuttle)
 
```bash
sshuttle --dns -r pubgw1.daplab.ch 10.10.10.0/24
```

And then you can ssh to daplab servers as if you where local to the infrastructure;

```bash
ssh daplab-wn-03
```
