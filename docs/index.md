DAPLAB Technical Documentation
==============================

DAPLAB, acronym of <u>D</u>ata <u>A</u>nalytics and <u>P</u>rocessing <u>Lab</u>,
is meant for learning and sharing knowledge around [Hadoop](http://hadoop.apache.org/)
and related technologies, including HDFS, YARN, [Kafka](http://kafka.apache.org/),
[Spark](http://spark.apache.org/) and [Cassandra](http://cassandra.apache.org/).

In this documentation, you'll find plenty of training material and examples, as
well as crunchy infrastructure details. Feel free to get some inspiration, and
send your remarks and comments, or even [contribute](https://help.github.com/articles/fork-a-repo/)
to enhance the documentation by submitting pull requests of the
[Github project hosting the DAPLAB documentation](https://github.com/daplab/documentation).

> In vain have you acquired knowledge if you have not imparted it to others. <br/> 
> -- [Deuteronomy Rabbah](https://en.wikipedia.org/wiki/Deuteronomy_Rabbah) 
> (c.900, commentary on the [Book of Deuteronomy](http://en.wikipedia.org/wiki/Book_of_Deuteronomy))


The DAPLAB platform is currently running 
[**HDP 2.3.x**](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/index.html)
based on **Hadoop 2.7.x**, with 
[Ambari 2.1.x](http://docs.hortonworks.com/HDPDocuments/Ambari-2.1.2.1/index.html) 
for management.
{: .vscc-notify-success }


Access to the DAPLAB Platform
-----------------------------

The DAPLAB cluster follows typical Hadoop deployment, i.e. it provides gateways and 
web interfaces as endpoints to interact with the Hadoop components, and no direct access
to the servers running the components. See the architecture page for more details.

### Web Interfaces

-   Hue: <https://api.daplab.ch>
-   Ambari: <https://admin.daplab.ch>

### Programmatic Interfaces

-   SSH: `ssh <yourusername>@pubgw1.daplab.ch`

Audience
---------

No need to have a Ph.D. in Data Scientist to be interested in data, and to have
a valuable perspective when looking at data. Indeed, when searching the needle in the 
data haystack, the wider background and broader perspective the better. 

The DAPLAB follows this reality and is thus open to everyone, 
the only requirement is to have a computer :)

Tutorials
---------

This documentation is putting a strong focus on having up-to-date training material.
The training material break down into three main categories:

* _Copy-paste_-style Hello World tutorials: the users can copy and paste a set of command
  or instructions, which will produce a result. Very low entry barrier, but limited scope
* Starter repos: [git](https://git-scm.com/) repos containing source code and unit/integration
  tests to run quickly code in your favorite IDE. Low entry barrier, focus on a particular
  technology.
* Advanced selected topics: some topics are covered more in depth. Higher entry barrier 
  and some prerequisites.

Please navigate through the links in the "Tutorial" tab at the very top of this page, or
go to the page referencing [all the tutorials](tutorial_all.md).

