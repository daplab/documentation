Hive Auto Partitioner
====

When ingesting data is not designed from ground up with [Hive](https://hive.apache.org)
in mind, it might quickly become painful go manage partitions on top of the folders.

Think about the following use case: team A is ingesting data via their prefered
path, and team B want to create an external Hive table around the data ingested
by team A. You might told me that team A should only deal with Hive-ready data, and
I would agree, but the reality is slightly different.

As a result, team B will start polling recursively team A directories and create
partitions when new folders are discovered. Repeate that multiple times with
several teams, and you start having a significant amount of RPC calls in HDFS
only for creating Hive partitions. Does it worth the price?

The answer obviously is not, and there is and awesome tool (disclaimer: I'm
part of the author of the tools, so I might be slightly baised :)) which is
solving this problem in an elegant way. The tool is called [Trumpet](https://github.com/verisign/trumpet)
and act as a sort of [iNotify](https://en.wikipedia.org/wiki/Inotify) for HDFS.
Instead of polling for files and directories creation or change, you can subscribe
to the event stream and got notified in case of interest.

The idea of this project is to combine Trumpet and Hive and solve a real life
Data Engineer problem.

The project is hosted in Github and all the implementations details are captured:

* **[https://github.com/daplab/hive-auto-partitioner](https://github.com/daplab/hive-auto-partitioner)**


If you find cool writing such piece of software, join us every Thursday evening for our weekly [Hacky Thursdays](http://daplab.ch/#hacky)!
{: .vscc-notify-info }
