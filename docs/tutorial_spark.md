
This page aims at creating a "copy-paste"-like tutorial to run your first 
[Spark](https://spark.apache.org) job.


This tutorial assumes you have a [proper environment setup](getting_started.md) 
to access the DAPLAB cluster.
{: .vscc-notify-info }

# Resources 

* The [official Spark documentation](https://spark.apache.org/docs/1.4.1/) is an
  excellent starting point.

# Running Spark

The following command will run the HDP version of Spark, 1.4.1 at the time of writing.

```bash
spark-shell --master yarn-master --conf spark.ui.port=$(shuf -i 2000-65000 -n 1)

  ...
  Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.4.1
      /_/
```

# First Example

```scala
val meteodata = sc.textFile("hdfs://daplab2/shared/meteo/2015/06/28/*")
meteodata.count()
```

Woot! Enjoy running Spark!


# SparkSQL

[SparkQL](https://spark.apache.org/sql/0 is a module of Spark to work with structured data, 
i.e. data is an associated schema or metadata. It is seamlessly associated with Hive. 
The following few lines show how query Hive from Spark:

```scala
// (inside Spark repl)
val sqlContext = new org.apache.spark.sql.hive.HiveContext(sc)
  
sqlContext.sql("FROM meteo SELECT date, temperature, station WHERE station = 'SMA'").collect().foreach(println)
```

Or, as an example, you can filter in Spark instead of in Hive:

```scala
sqlContext.sql("FROM meteo SELECT date, temperature, station").filter(r => r(2) == "SMA").collect().foreach(println)
```

* TODO: what is the different execution plan between filtering in Hive versus filtering in Spark?
