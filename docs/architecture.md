
# DAPLAB architecture

In this page, we review some of the principal software components of the Daplab as a Big Data Platform, then give you more informations about the hardware and architecture of the Daplab cluster dedicated to Big Data Analysis.

The DAPLAB team is currently working on an OpenStack project. More about this and the hardware dedicated to it at the bottom of the page.
{: .vscc-notify-info }

Counting the OpenStack-dedicated hardware, the Daplab has __1,026__ cores, __5.7 TB__ of RAM and __575 TB__ or storage !
{: .vscc-notify-info }

## HDP - HortonWorks Data Platform

The HADOOP ecosystem being especially complex and constently changing, DAPLAB uses
[Hortonworks](http://hortonworks.com/) as its hadoop provider.
[HDP](http://hortonworks.com/products/hdp/) is a secure, enterprise-ready open
source Apache™ Hadoop® distribution based on a centralized architecture (YARN).

In theory, DAPLAB can run any tool developed for HADOOP. In practice, it is
necessary to take into account the already installed frameworks as well as the
limitations imposed by HDP.

The HDP architecture is presented in the figure below.

![HDP data platform](images/HDP_2.3.png)


As of August 2017, DAPLAB platform is running
[**HDP 2.6.x**](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.5.0/bk_release-notes/content/ch_relnotes_v250.html)
based on **Hadoop 2.7.x**, with
[Ambari 2.5.x](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/index.html)
for management.
{: .vscc-notify-info }

__Hadoop Distributed File System (HDFS)__ and __YARN__ are the cornerstone components of Hortonworks Data Platform (HDP).
HDFS is a distributed file system providing a scalable, fault-tolerant and cost-efficient storage for the data. YARN,
_Yet Another Resource Negotiator_, is a large-scale, distributed operating system for big data applications. It
decouples _MapReduce_'s resource management and scheduling capabilities from the data processing components,
enabling Hadoop to support more varied processing approaches and a broader array of applications.

On top of YARN, it is possible to plug a versatile range of processing engines that allows multiple processes to
interact with the same data in multiple ways, at the same time. Most of the tools visible on the figure are discussed
more in depth in our [tutorials](tutorials/index.md) and other resources.

__Ambari__ is a graphical interface to provision, manage and monitor HADOOP clusters easily, while __ZooKeeper__
 provides a distributed synchronization (for maintaining configuration information and naming) through a centralized service.

### About HADOOP 2

_Most of the following information have been taken from the articles [_What is Apache Tez?_](https://www.infoq.com/articles/apache-tez-saha-murthy)
and [_Hadoop 2 vs 1_](http://www.tomsitpro.com/articles/hadoop-2-vs-1,2-718.html). We encourage you to read them for more in-depth explanations._


The major changes between HADOOP 1 and HADOOP 2 are the introduction of HDFS federation and the YARN resource manager.
There is also a new execution engine, Tez, which  generalizes the MapReduce paradigm to a more powerful framework
based on expressing computations as a _dataflow graph_.

 ![hadoop 2](images/hadoop2.png)

In Hadoop 1, a single Namenode managed the entire namespace for a Hadoop cluster.
With __HDFS federation__, multiple Namenode servers manage namespaces and this allows for horizontal scaling,
performance improvements, and multiple namespaces.

With __YARN__ , HADOOP users are no longer limited to working the I/O intensive, high latency MapReduce framework, but can
 run other processing models. YARN also simplifies the management of resources and brings significant performance
 improvements to HADOOP.

 __Tez__ is one of the new processing models of HADOOP 2. It allows developers to build end-user applications (such as
Hive and Pig) with much better performance and flexibility. It gets around some limitations imposed by MapReduce and
makes near-real-time query processing possible.


------------------------

## Daplab Software Versions

|                  | Version        | 
|:-----------------|:---------------| 
| YARN             | 2.7.3          | 
| HDFS             | 2.7.3          | 
| MapReduce2       | 2.7.3          | 
| Tez              | 0.7.0          | 
| Hive             | 1.2.1          | 
| Pig              | 0.16.0         | 
| Sqoop            | 1.4.6          | 
| ZooKeeper        | 2.4.6          | 
| Ambari           | 2.5            | 
| Apache Spark     | 1.6.3          | 
| Apache Spark2    | 2.1.0          | 
| Apache Kafka     | 0.10.1         | 
| Apache Cassandra | 3.11.0         | 

-------------------------

## Daplab Physical Architecture

DAPLAB Architecture follows a typical Data Lake architecture.

![High level architecture](images/architecture.png)

Users have physical SSH access to so-called __Gateways or Edge servers__, and interact with Hadoop services from there.
Users have also access to user interaces such as [Ambari](https://admin.daplab.ch) or [Hue](https://hue.daplab.ch/).
User Gateways have __home directories__ mounted on a SAN via NFS in order to share home folders between gateways.

__Applications__ are either run as long living YARN applications, or have dedicated gateways simply called
Application Gateways. The rational behind that is that Users Gateways tend to have unpredictable workload,
highly correlated to users mood. Applications might require more predictable workload and are thus separated.
Note that these Application and Users Gateways would be good candidates to run on VMs.

The servers running Hadoop & friends are split in two categories with two distinct hardware configurations:
storage and non-storage.

The __storage nodes__ usually contains 12 spinning 2TB drives or more. They have reasonably small SSDs for the OS,
dual E5-XXXX v3 CPUs and 128GB of RAM. They are used as HDFS datanodes and YARN nodemanagers, with some added services as well. 
We also bond two of their NIC to achieve 20Gb/s of bandwidth between the servers !

The second type of servers, __non-storage nodes__, have 2 to 4 bigger SSDs and are intended to run master processes such as Zookeeper,
Namenode, Resource Manager as well as Kafka brokers.  <!-- TODO -->

The last type of servers are called __Utility servers__, and are primarily hosting mandatory services to run the
Hadoop platform such as DHCP, DNS, Kerberos, LDAP etc. These ones also run Postgresql in master-slave mode
to store Ambari, Hive, Hue and Oozie databases.


----------------------

## DAPLAB Hardware

DAPLAB hardware dedicated to Big Data: <br>
&nbsp;&nbsp;&nbsp; ➙ &nbsp; _Total Cores_ : __402__ <br>
&nbsp;&nbsp;&nbsp;  ➙ &nbsp; _Total Disk_  :  __527 TB__ <br>
&nbsp;&nbsp;&nbsp;  ➙ &nbsp; _Total RAM_   :  __3.196 TB__ <br>
{: .vscc-notify-info }

DAPLAB currently uses hardware of the following families:

 - [Dell PowerEdge 2950 Server](pdfs/PowerEdge_2950.pdf){:target="_blank"}
 - [Dell PowerEdge R430](pdfs/PowerEdge_R430.pdf){:target="_blank"}
 - [Supermicro SuperServer 6017R-73THDP+](pdfs/SYS-6017R-73THDP.pdf){:target="_blank"}
 - [Supermicro  SuperServer 6028TP-HTTR](pdfs/SYS-6028TP-HTTR.pdf){:target="_blank"}
 - [Supermicro SuperServer F618H6­FTPTL+](pdfs/SYS-F618H6-FTPTL+.pdf){:target="_blank"}
 - [Supermicro X9DRFF­7G+](pdfs/X9DRFF-7G+.pdf){:target="_blank"}
 - [QNAP TS-863U-RP](pdfs/QNAP_TS-863U-RP.pdf){:target="_blank"}

 Below is a summary of their specifications:


#### Storage nodes <!-- wn-21/26, wn-31-42 -->

 | # machines      | Hardware      | CPU           | RAM (GB) | Disk capacity (TB)
 |:---------------:|:--------------|:--------------|:--------:|:---------------------:|
 6 | SuperServer 6017R-73THDP+  | Intel xeon E5-2620 v3 @ 2.1GHz | 128| 24 | 
12 | SuperServer F618H6­FTPTL+   | Intel xeon E5-2630 v3 @ 2.4GHz | 128 | 24 |

_Total_: 2.3 TB of RAM, 432 TB of storage.

-----------------

#### Non-storage nodes <!--  wn-10/15, rt -->

 | # machines      | Hardware      | CPU           | RAM (GB) | Disk capacity (TB)
 |:---------------:|:--------------|:--------------|:--------:|:---------------------:|
5 | PowerEdge 2950          | Intel Xeon 5XXXX               | 32 | 2.4 - 4.2 |
4 | Superserver 6028TP-HTTR | Intel xeon E5-2630 v3 @ 2.4GHz | 128 | 4.8 |

_Total_: 672 GB of RAM, 28.6 TB of storage.

-----------------

#### Utility servers <!-- gw, app-extra-un -->

 | # machines      | Hardware      | CPU           | RAM (GB) | Disk capacity (TB)
 |:---------------:|:--------------|:--------------|:--------:|:---------------------:|
2 | PowerEdge R430 | Intel xeon E5-2630 v3 @ 2.4GHz | 32 | 8 |
5 | PowerEdge 2950 | Intel Xeon 5XXXX               | 32 | 0.7-2.4 GB |

_Total_: 224 GB of RAM, 7'361 GB of storage.

-----------------

<!--  |Number of machines| Hardware        | CPU           | U  | RAM | Disk capacity/U | Disk capacity (total)
 | --------------- |:--------------|:--:|:----|:---------------:|:---------------------:|
 10 | PowerEdge 2950  | Quad-Core Intel Xeon 5300 8 cores | 2 | 20/32GB | 744 GB - 4.288 TB | 27 TB |
 2 | PowerEdge R430  | Intel® Xeon®, Intel Pentium®, Intel CoreTM i3 16 cores | 1 | 32 GB | 4x2TB | 16TB |
 4 | SuperServer 6017R-73THDP+  |  Intel Xeon E5-2600 v1/v2  24 cores| 1 | 128 GB | 12x2 TB |96 TB |
 1 | SuperServer 6028TP-HTTR  |  Intel Xeon E5-2600 v3 24 cores  | 2 | 128 GB | 8 x 2TB + 4 x 1TB(ssd)  | 20 TB |
 1 | SuperServer F618H6­FTPTL+ |  Intel Xeon E5-2600 v4 32 cores/U  | 4 |  130 GB/U => 520 GB | 4x12x2 TB | 96 TB |
 2 |  X9DRFF­7G+ |  Intel Xeon E5-2600 v2 24 cores | 1 |  130 GB | 12x2TB | 48 TB |
 1 | QNAP TS-863U-RP | Quad-core 64-bit AMD 2.0GHz | 2 | 4GB | 20 TB | 20 TB |
 -->

In total, the DAPLAB has __402 cores__,  __527 TB__ of disk space and about __4 TB__ or RAM solely __dedicated to Big Data__. 
Moreover, some machines are reserved for projects such as an OpenStack infrastructure. Counting those, 
we have 1168 cores and more than 6 TB of RAM in our park. 

# OpenStack 

The _EPFL (École Polytechnique de Lausanne)_ gave us 13 machines that we are currently using to setup an OpenStack infrastruture. The goal is to provide an IaaS (_infrastructure-as-a-service_) for virtual servers and resources able to communicate with our Hadoop platform. 

#### OpenStack hardware <!-- cn -->

 | # machines      | Hardware      | CPU           | RAM (GB) | Disk capacity (TB)
 |:---------------:|:--------------|:--------------|:--------:|:---------------------:|
13 | IBM System X3755 M3 | AMD Opteron 6176 QuadCore @ 2.3GHz | 192 | 2.25 - 6.25 |

_Total_: 624 cores, 2.5 TB of RAM, 47.65 TB of storage.


