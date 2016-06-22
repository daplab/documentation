This tutorial assumes you have a [proper environment setup](getting_started.md)
to access the DAPLAB cluster.
{: .vscc-notify-info }

This page aims at creating a "copy-paste"-like tutorial to run your first
[Hive](https://hive.apache.org) query.

-------------------------------------
# Introduction

Hive is a "pluggable software" runing on top of YARN/HDFS. Its primary goal was is
to facilitate reading, writing, and managing large datasets residing in distributed storage using SQL.

With Hive, it is possible to project a structure onto data already in storage and to write
__Hive Query Language (HQL)__ statements that are similar to standard SQL statements. Of course, Hive
implements only a limited subset of SQL commands, but is still quite helpful.

Under the hood, HQL statement are translated into _MapReduce_ jobs and executed across a Hadoop cluster.

----------------------------------------


# Resources

This tutorial is heavily inspired from the HortonWorks tutorial and is illustrated in command-line.

* [http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-hive/](http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-hive/)

# Creating a database, a table and loading data

Note: In order to have this tutorial to work for everybody,
it will create a database prefixed by your username (`${env:USER}` inside hive)

## Pre-steps

1) Download the data and uncompress it:

```bash
wget http://seanlahman.com/files/database/lahman591-csv.zip
unzip lahman591-csv.zip
```


2) Copy the locally unzipped data into your home folder in HDFS
(the tailing "." points you to `/user/$(whoami)`):
See [HDFS tutorial](tutorial_hdfs.md) if you're not familiar with HDFS.

```bash
hdfs dfs -copyFromLocal *.csv .
```

## Create a database in Hive

```bash
$ hive

create database ${env:USER}_test;
```

## Create a temp table to load the file into

```sql
$ hive

use ${env:USER}_test;
create table temp_batting (col_value STRING);
LOAD DATA INPATH '/user/${env:USER}/Batting.csv' OVERWRITE INTO TABLE temp_batting;
```

## Create the final table and insert the data into

```sql
$ hive

use ${env:USER}_test;
create table batting (player_id STRING, year INT, runs INT);
insert overwrite table batting  
 SELECT  
    regexp_extract(col_value, '^(?:([^,]*)\,?){1}', 1) player_id,  
    regexp_extract(col_value, '^(?:([^,]*)\,?){2}', 1) year,  
    regexp_extract(col_value, '^(?:([^,]*)\,?){9}', 1) run  
  from temp_batting;
```

# Run your first query

```sql
$ hive --database ${USER}_test

SELECT year, max(runs) FROM batting GROUP BY year;
```

## Run a more complex query

```sql
$ hive --database ${USER}_test

SELECT a.year, a.player_id, a.runs from batting a  
JOIN (SELECT year, max(runs) runs FROM batting GROUP BY year ) b  
ON (a.year = b.year AND a.runs = b.runs) ;
```

Woot!

# Hive on Tez

Weel, there is nothing to do, since HDP 2.3 Tez (see [about hadoop 2](../architecture/#about-hadoop-2)) is the default execution engine!

Woot #2!


# Hive external table

As you might have noticed, with hive "normal" tables, you need to upload the data in HDFS,
create a temp table, load the data into this temp table, create another, final,
table and eventually copy and format the data from the temp table to the final one.
You kill a unicorn when doing all that...

Another idea is to rely on hive external table, which will read the data directly from the CSV file.

Let's create a table mapping the CSV file and run a query on top of it.

There's one gotcha here, the external table location (where the data is physically stored)
**MUST** be a folder. We'll change the directory structure to accommodate this requirement.

```bash
hdfs dfs -mkdir Batting
hdfs dfs -copyFromLocal Batting.csv Batting # note here that the file needs to be re-uploaded because the LOAD DATA consumed (and removed the file)
```

And then create the external table

```sql
$ hive --database ${USER}_test

create EXTERNAL table batting_ext (player_id STRING, year INT, stint STRING, team STRING, lg STRING, G STRING, G_batting STRING, AB STRING, runs INT, H STRING, x2B STRING, x3B STRING, HR STRING, RBI STRING, SB STRING, CS STRING, BB STRING, SO STRING, IBB STRING, HBP STRING, SH STRING, SF STRING, GIDP STRING, G_Old STRING)
  ROW FORMAT
  DELIMITED FIELDS TERMINATED BY ','
  LINES TERMINATED BY '\n'
  STORED AS TEXTFILE
  LOCATION '/user/${env:USER}/Batting/';
```

Let's run the two queries

```sql
$ hive --database ${USER}_test

SELECT year, max(runs) FROM batting_ext GROUP BY year;

SELECT a.year, a.player_id, a.runs from batting_ext a  
  JOIN (SELECT year, max(runs) runs FROM batting_ext GROUP BY year ) b  
  ON (a.year = b.year AND a.runs = b.runs) ;
```

And of course external tables can also be used with Hive on Tez.

# Cleanup

Once you're done, you can cleanup your environment, deleting the tables and the database.

```sql
$ hive

drop table temp_batting;
drop table batting;
drop table batting_ext;
drop database ${env:USER}_test;
```

# Job Failing in OutOfMemory?

Since Hive is using Tez by default as execution engine, you need to increase the Tez
container size.

* In Hive, you can

```
SET hive.tez.container.size=8192
SET hive.tez.java.opts=-Xmx7168m
```

* From the command line, you can

```
hive --hiveconf hive.tez.container.size=8192 --hiveconf hive.tez.java.opts=-Xmx7168m ...
```
