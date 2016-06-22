This tutorial assumes you have a [proper environment setup](getting_started.md)
to access the DAPLAB cluster.
{: .vscc-notify-info }

This page aims at creating a "copy-paste"-like tutorial to run your first
[Pig](https://pig.apache.org) script.


-----------------------------------------------
# Introduction

Apache Pig lets you write complex MapReduce transformations using a simple scripting language called _Pig Latin_.
Pig is extensible, easily programmed and self-optimizing.
It translates the Pig Latin script into MapReduce so that it can be executed within YARN.

Pig is suited for:

- ETL (Extract, Transform, Load) data pipelines,
- research on raw data,
- iterative data processing.

Pig syntax is more verbose and less SQL-like than [Hive](hive.md), but it also gives you more control and
optimization over the flow of data. Furthermore, it is easier to write long and complex
dataflows. Finally, Pig is extensible, letting you write your own functions.

-----------------------------------------------
# Resources

This tutorial is a mix between several tutorials from HortonWorks, working on the DAPLAB platform in command-line.

* [http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-pig/](http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-pig/)
* [http://hortonworks.com/hadoop-tutorial/how-to-use-hcatalog-basic-pig-hive-commands/](http://hortonworks.com/hadoop-tutorial/how-to-use-hcatalog-basic-pig-hive-commands/)
* [http://hortonworks.com/hadoop-tutorial/faster-pig-tez/](http://hortonworks.com/hadoop-tutorial/faster-pig-tez/)

The Pig Latin (v0.15) reference is always good to keep close by too.

* [http://pig.apache.org/docs/r0.15.0/basic.html](http://pig.apache.org/docs/r0.15.0/basic.html)
* [http://pig.apache.org/docs/r0.15.0/func.html](http://pig.apache.org/docs/r0.15.0/func.html)

# Pig reading from HDFS

We already have some datasets in `hdfs://shared`, we'll use this file to save some time (and some space)

# Launching Pig

```bash
pig
```

## Loading the data

We'll use `CSVExcelStorage` to skip the header line.


```
register /usr/hdp/current/pig-client/lib/piggybank.jar
batting = LOAD '/shared/seanlahman/2011/Batting/Batting.csv' using org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'NO_MULTILINE', 'NOCHANGE', 'SKIP_INPUT_HEADER');
```

## Generating a structure

This step is not mandatory, but it's beneficial for sake of clarity in the next steps.

Note: this could also have been performed in the `LOAD` statement,
but as only 3 out of a dozen fields are used here, this is faster.

```
runs = FOREACH batting GENERATE $0 as player_id, $1 as year, $8 as runs;
```

## Filtering out row with no data

```
runs = FILTER runs BY runs != '';
```

## Grouping, maxing

```
grp_data = GROUP runs by (year);
max_runs = FOREACH grp_data GENERATE group as year, MAX(runs.runs) as max_runs;
```

## Displaying the output

Pig does not exectue any statement before either `STORE` or `DUMP` is called.
Here we'll call `DUMP`, which displays the output in the terminal, but as it might results in
a significant amount of data, we'll limit the size before.

```
max_runs = LIMIT max_runs 10;
DUMP max_runs;
```

# Pig with Hive binding (HCatalog)

This part relies on [Hive Tutorial](tutorial_hive.md) for uploading the data and
creating the table. We assume that a table `${USER}_test` exists.

## Running Pig with HCatalog

```
pig -useHCatalog -param username=$(whoami)
```

The `LOAD` is different, but the rest of the processing is similar.

```
runs = LOAD '${username}_test.batting' using org.apache.hive.hcatalog.pig.HCatLoader();
```

Note: as the Hive table has a schema, there's no need to do the project, `runs`
has directly the schema attached!

```
grp_data = GROUP runs by (year);
max_runs = FOREACH grp_data GENERATE group as year, MAX(runs.runs) as max_runs;
max_runs = LIMIT max_runs 10;
DUMP max_runs;
```

## Bonus -- Pig on Tez

In order to benefit from [Tez](../architecture#about-hadoop-2) executing engine in Pig, simply run:

```
pig -x tez
```
