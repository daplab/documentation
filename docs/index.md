DAPLAB Technical Documentation
==============================

DAPLAB, acronym of <u>D</u>ata <u>A</u>nalytics and <u>P</u>rocessing <u>Lab</u>,
is meant for learning and sharing knowledge around [Hadoop](http://hadoop.apache.org/)
and related technologies, including HDFS, YARN, [Kafka](http://kafka.apache.org/),
[Spark](http://spark.apache.org/) and [Cassandra](http://cassandra.apache.org/).

In this wiki, you'll find plenty of training material and examples, as
well as crunchy infrastructure details. Feel free to get some inspiration, and
send your remarks and comments

> In vain have you acquired knowledge if you have not imparted it to others. <br/> 
> -- [Deuteronomy Rabbah](https://en.wikipedia.org/wiki/Deuteronomy_Rabbah) 
> (c.900, commentary on the [Book of Deuteronomy](http://en.wikipedia.org/wiki/Book_of_Deuteronomy))


The DAPLAB platform is currently running 
[**HDP 2.3**](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/index.html)
based on **Hadoop 2.7**, with 
[Ambari 2.1.2](http://docs.hortonworks.com/HDPDocuments/Ambari-2.1.2.1/index.html) 
for management.
{: .vscc-notify-info }


Access to the DAPLAB Platform
-----------------------------

### User Interfaces

-   Hue: <https://api.daplab.ch>
-   Ambari: <https://admin.daplab.ch>

### Programmatic Interfaces

-   SSH: `ssh <yourusername>@pubgw1.daplab.ch`

Tutorials
---------

This section is referencing all the available tutorials one can run
easily and quickly on the DAPLAB platform. These tutorials are open and
community driven, don't hesitate to update, enhance or just fix a typo.

### Basic tutorials, *copy-paste*-style

- [HDFS Hello World](tutorial_hdfs.md) -- Quick introduction to HDFS command line interface
- [Hive Hello World](tutorial_hdfs.md) -- Hello world introduction to [Hive](https://hive.apache.org/)
- [Pig Hello World](tutorial_hdfs.md) -- Hello world introduction to [Pig](https://pig.apache.org/)
- [Spark Hello World](tutorial_hdfs.md) -- Hello world introduction to [Spark](https://spark.apache.org/)
- [Kafka Hello World](tutorial_hdfs.md) -- Hello world introduction to [Kafka](https://kafka.apache.org/)

### Data Science

> A good decision is based on knowledge and not on numbers. -- Plato, Greek Philosoph

- [UDF Starter](tutorial_hive_udf.md) -- Writing User Defined Function (UDF) for Hive
- [Spark MLlib Hello World](tutorial_spark_mllib.md) -- Hello world introduction to [Spark MLlib](https://spark.apache.org/docs/latest/mllib-guide.html)
- [PigPythonSupervisedLearning]()

### Data Eng

- [Kafka-Starter](https://github.com/daplab/kafka-starter) -- starter [maven](https://maven.apache.org/) 
  project to read and write into [Kafka](https://kafka.apache.org/)
- [Yarn-Starter](https://github.com/daplab/yarn-starter) -- simple [maven](https://maven.apache.org/)
  project to start deploying [YARN](http://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-site/YARN.html) application
- [Ingesting Twitter Firehose in YARN](tutorial_twitter_firehose.md) -- YARN application reading from [Twitter Firehose](https://dev.twitter.com/streaming/firehose)
  and storing into HDFS.