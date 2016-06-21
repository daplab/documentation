This tutorial assumes you have a [proper environment setup](getting_started.md)
to access the DAPLAB cluster.
{: .vscc-notify-info }

In order to use HADOOP, it is crucial that you understand the basic functioning of HDFS, as well as some of its constraints.
After a brief introduction of core HDFS concepts, this page presents _copy-paste_-like tutorial to familiarize with
[HDFS commands](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html).
It mainly focuses on user commands (uploading and downloading data into HDFS).

-----------------------------------

# Introduction

HDFS (_Hadoop Distributed File System_) is one of the core components of HADOOP.

The HDFS is a distributed file system designed to run on commodity hardware. Very powerful,
it should ensure that data are replicated across a wide variety of nodes, making the system
fault tolerant and suitable for large data sets and gives high throughput.

To have a better understanding of how HDFS works, we strongly encourage you to check out
[the HDFS Architecture Guide](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html){:target="_blank"}.
{: .vscc-notify-info }

__Some remarks on HDFS__

HDFS uses a __simple coherency model__: applications mostly need a _write-once-read-many_ access model
for files. As a result, a file once created, written to and closed becomes read-only. It is possible
to append to an HDFS file only if the system was explicitly configured to.

HDFS is tuned to deal with __large files__. A typical file in HDFS is gigabytes to terabytes in size. As a result, try to
avoid scattering your data in numerous small files.

HDFS is designed more for __batch processing__ rather than interactive use (high throughput versus low latency), and
 provides only sequential access of data. If your application has other needs, check out tools like _HBase_, _Hive_,
 _Apache Spark_, etc.

> “Moving Computation is Cheaper than Moving Data”

__HDFS architecture__

As the [the HDFS Architecture Guide](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html){:target="_blank"} explains,
HDFS has a __master/slave architecture__.

An HDFS cluster consists of a single __NameNode__, a master server that manages the file system namespace and regulates access to files by clients. In addition, there are a number of __DataNodes__, usually one per node in the cluster, which manage storage attached to the nodes that they run on. HDFS exposes a file system namespace and allows user data to be stored in files. Internally, a file is split into one or more blocks and these blocks are stored in a set of DataNodes. The NameNode executes file system namespace operations like opening, closing, and renaming files and directories. It also determines the mapping of blocks to DataNodes. The DataNodes are responsible for serving read and write requests from the file system’s clients. The DataNodes also perform block creation, deletion, and replication upon instruction from the NameNode.


![HDFS architecture](../images/hdfs-architecture.png)

-------------------- ----------

# Resources

While the source of truth for HDFS commands is the code source, the documentation page
describing the `hdfs dfs` commands is really useful:

* [http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html){:target="_blank"}

A good and simpler cheat sheet is also available [here](http://www.dummies.com/how-to/content/hadoop-for-dummies-cheat-sheet.html){:target="_blank"}.

<br/>

# Basic Manipulations

In HDFS, user's folders are stored in `/user` and not `/home` like traditional Unix/Linux
filesystems.
{: .vscc-notify-warning }

## Listing a folder

### Your home folder

```
 $ hdfs dfs -ls
 Found 28 items
 ...
 -rw-r--r--   3 bperroud daplab_users   6398990 2015-03-13 11:01 data.csv
 ...
 ^^^^^^^^^^   ^ ^^^^^^^^ ^^^^^^^^^^^^   ^^^^^^^ ^^^^^^^^^^ ^^^^^ ^^^^^^^^
          1   2        3            4         5          6     7        8
```

Columns, as numbered below, represent:

1. Permissions, in [http://en.wikipedia.org/wiki/File_system_permissions#Notation_of_traditional_Unix_permissions unix-style] syntax;
2. Replication factor (RF in short), default being 3 for a file. Directories have a RF of 0;
3. Owner;
4. Group owning the file;
5. Size of the file, in bytes. Note that to compute the physical space used, this number should be multiplied by the RF;
6. Modification date. As HDFS is mostly a ''[write-once-read-many](http://en.wikipedia.org/wiki/Write_once_read_many){:target="_blank"}'' filesystem,
this date often means creation date;
7. Modification time. Same as date;
8. Filename, within the listed folder.

### Listing the `/tmp` folder

```
$ hdfs dfs -ls /tmp
```

## Uploading a file

### In `/tmp`

```
$ hdfs dfs -copyFromLocal localfile.txt /tmp/
```

The first arguments after `-copyFromLocal` point to local files or folders,
while the last argument is a file (if only one file listed as source) or directory in HDFS.

Note that `-copyFromLocal` and `-copyToLocal` also support wildcards and the copy of
directories.

`hdfs dfs -put` is doing about the same thing, but `-copyFromLocal` is more explicit
when you're uploading a local file and thus preferred.
{: .vscc-notify-info }

## Downloading a file

### From `/tmp`

```
$ hdfs dfs -copyToLocal /tmp/remotefile.txt .
```

The first arguments after `-copyToLocal` point to files or folder in HDFS, while the last
argument is a local file (if only one file listed as source) or directory.

`hdfs dfs -get` is doing about the same thing, but `-copyToLocal` is more explicit when
you're downloading a file and thus preferred.
{: .vscc-notify-info }

## Creating a folder

### In your home folder

```
$ hdfs dfs -mkdir dummy-folder
```

### In `/tmp`

```
$ hdfs dfs -mkdir /tmp/dummy-folder
```

Note that relative paths points to your home folder,  `/user/bperroud` for instance.

# Advanced Manipulations

the `hdfs dfs` command support several actions that any linux user is already familiar with. Most
of their paramters are the same, but not that the shortcuts (`-rf` instead of `-r -f` for example)
are not supported. Here is a non-exhaustive list:

- `-rm [-r] [-f]`: remove a file or directory;
- `-cp [-r]`: copy a file or directory;
- `-mv`: move/rename a file or directory;
- `-cat`: display the content of a file;
- `-chmod`: manipulate file permissions;
- `-chown`: manipulate file ownership;
- `-tail|-touch|`etc.

Other useful commands include:

- `-moveFromLocal|-moveToLocal`: same as `-copyFromLocal|-copyToLocal`, but remove the source;
- `-stat`: display information about the specified path;
- `-count`: counts the number of directories, files, and bytes under the paths;
- `-du`: display the size of the specified file, or the sizes of files and directories that are contained in the specified directory;
- `-dus`: display a summary of the file sizes;
- `-getmerge`: concatenate the files in src and writes the result to the specified local destination file. To add a newline character at the end of each file, specify the `addnl` option: `hdfs dfs -getmerge <src> <localdst> [addnl]`
- `-setrep [-R]`: change the replication factor for a specified file or directory;
