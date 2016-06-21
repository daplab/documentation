
This page aims at creating a _copy-paste_-like tutorial to familiarize with 
[HDFS commands](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSCommands.html).
It mainly focuses on user commands (uploading and downloading data into HDFS).

This tutorial assumes you have a [proper environment setup](getting_started.md) 
to access the DAPLAB cluster.
{: .vscc-notify-info }

# Resources

While the source of truth for HDFS commands is the code source, the documentation page 
describing the `hdfs dfs` commands is really useful:

* [http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)

<br/>

In HDFS, user's folders are stored in `/user` and not `/home` like traditional Unix/Linux
filesystems.
{: .vscc-notify-warning }

# Basic Manipulations

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

1. Permissions, in [http://en.wikipedia.org/wiki/File_system_permissions#Notation_of_traditional_Unix_permissions unix-style] syntax
2. Replication factor (RF in short), default being 3 for a file. Directories have a RF of 0.
3. Owner
4. Group owning the file
5. Size of the file, in bytes. Note that to compute the physical space used, this number should be multiplied by the RF.
6. Modification date. As HDFS is mostly a ''[http://en.wikipedia.org/wiki/Write_once_read_many write-once-read-many]'' filesystem, this date often means creation date
7. Modification time. Same as date.
8. Filename, within the listed folder

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

