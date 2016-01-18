
DAPLAB Architecture follows a typical Data Lake architecture.

Users have physical SSH access to so-called Users Gateway servers, and interact with Hadoop services from there.
Users have also access to user interaces such as Ambari or Hue. User Gateways have home directories mounted
on a SAN via NFS in order to share home folders between gateways.

Applications are either run as long living YARN applications, or have dedicated gateways simply called
Application Gateways. The rational behind that is that Users Gateways tend to have unpredictable workload,
highly correlated to users mood. Applications might require more predictable workload and are thus separated.

The servers running Hadoop & friends are split in two categories with two distinct hardware configurations:
Storage and non-storage.

The storage nodes usually contains 12 spinning 2TB drives or more. They have really small SSDs for the OS,
dual CPU and 128GB of RAM.
The second type of servers have 2 to 4 bigger SSDs and are intended to run master processes such as Zookeeper,
Namenode, Resource Manager as well as Kafka brokers. We also bonded two of their NIC to have 20Gb/s of bandwidth
for the Kafka brokers.

The last type of servers are called _Utility_ servers, and are primarily running mandatory services to run the
Hadoop platform such as DHCP, DNS, Kerberos, LDAP etc. These one are also Postgresql in master-slave mode to store Ambari, Hive,
Hue and Oozie databases.

Below is a architecture diagram illustrating all the above text.

![High level architecture](architecture_1.png)

