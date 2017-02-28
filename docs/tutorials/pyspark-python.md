This tutorial assumes you have a [proper environment setup](/getting_started.md)
to access the DAPLAB cluster and that you have a basic understanding of [Spark](spark.md).
{: .vscc-notify-info }

This page will familiarize you to Python Spark. We will first expriment with
the PySpark Python interpreter, then try to launch a real
[PySpark](https://spark.apache.org/docs/0.9.0/python-programming-guide.html){:target="\_blank"} job.

-------------------------------------
# Introduction

PySpark is the Spark API for python. The key differences with Java or Scala are:

- Python is dynamically typed, so RDDs can hold objects of multiple types.
- PySpark does not yet support a few API calls, such as lookup and non-text input files, though these will be added in future releases.
- PySpark is less performant, since it is basically a wrapper (yet another layer) above Spark scala.

Spark basic concepts are explained in our [Spark](spark.md) tutorial.
{: .vscc-notify-info }

--------------------------------------

# Resources

Here are some pretty good tutorials and resources online:

- [Spark Python Programming Guide](https://spark.apache.org/docs/0.9.0/python-programming-guide.html){target="\_blank"}
- [PySpark snippets and examples](http://spark.apache.org/examples.html){target="\_blank"}
- [Revisiting the wordcount example](http://www.mccarroll.net/blog/pyspark2/index.html){target="\_blank"}
- [Statistical and Mathematical Functions with DataFrames in Apache Spark](https://databricks.com/blog/2015/06/02/statistical-and-mathematical-functions-with-dataframes-in-spark.html){target="\_blank"}

# Environment

PySpark is available on the DAPLAB. To use it, follow these simple steps:

1) choose which python version you will use (instructions[here](../modules.md))

2) set the pyspark interpreter to the correct python version (python2.7 or python3):

```sh
export PYSPARK_PYTHON=/usr/bin/python3 # we will use python3 for this tutorial
```

3) set the spark home variable:

```sh
export SPARK_HOME=/usr/hdp/current/spark-client/
export PYTHONPATH=${SPARK_HOME}/python:${SPARK_HOME}/python/build:${SPARK_HOME}/python/lib/py4j-0.8.2.1-src.zip
```

4) make hadoop libraries available to pyspark:

```sh
export HADOOP_HOME=/usr/hdp/current/hadoop
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native/:$LD_LIBRARY_PATH
```

To ease everything, you can put all the export statements in your `.bashrc`. Don't forget to then reload it: `source ~/.bashrc`.

You are ready to go !

# PySpark interpreter

Launch the interpreter with the command `pyspark`. In the interpreter, the spark context is already created for us and available through the `sc` variable. By default, it runs applications _locally_ with a
single core.

## WordCount

Before starting, download the text of alice in wonderland and load it into hdfs (from the terminal, not pyspark):

```
wget https://www.gutenberg.org/ebooks/11.txt.utf-8
hdfs dfs -put 11.txt.utf-8 /user/USERNAME/alice_in_wonderland.txt
```
In pyspark, we will count the recurrence of every word and list the ten most used ones.

First, load the content of the file into an RDD using `sc.textFile` and remove blank lines:
```
alice = "/user/USERNAME/alice_in_wonderland.txt"
lines = sc.textFile(alice).filter(lambda x: len(x) > 0)
```
We have the RDD, let's work on it:
```python
import re
words = lines.flatMap(lambda x: re.split(r" +", x)).filter(lambda x: len(x) > 0)
counts = words.map(lambda word: (word, 1)).reduceByKey(lambda a, b: a+b)
counts.take(10)

    [('hastily', 7), ('ornamented', 2), ('volunteer', 1), ('sea.', 3), ("'tis", 2), ('Just', 5), ('dark', 3), ("can,'", 1), ("procession,'", 1), ('positively', 1)]
```
SO, first we split lines into words and filter empty words. Then, we create a tuple with count 1 for each word and ask spark to _reduce by key_: the key here is the first field of the tuple (the word). The lambda argument of `reduceByKey` defines what to do with the values: here we just sum them.

We can rewrite it (and improve it) in a single pipeline of transformations like this:

```
import re

wordcounts = lines.map( lambda x: re.sub(r'[^A-Za-z]+', ' ', x).lower()) \
        .flatMap(lambda x: x.split()) \
        .map(lambda x: (x, 1)) \
        .reduceByKey(lambda x,y:x+y) \
        .map(lambda x:(x[1],x[0])) \
        .sortByKey(False)

wordcounts.take(10)

    [(1818, 'the'), (940, 'and'), (809, 'to'), (690, 'a'), (631, 'of'), (610, 'it'), (553, 'she'), (545, 'i'), (481, 'you'), (462, 'said')]
```

Here, we replace all non-ascii character by space and also sort the results in descending order. To go further, add a `map` stage to also filter all words of length less than 4.

## Working with DataFrames

In Spark, a __DataFrame__ is a distributed collection of data organized into named columns. Users can use __DataFrame API__ to perform various relational operations on both external data sources (Cassandra, SQL, etc) and Spark’s built-in distributed collections without providing specific procedures for processing data.

The advantages ? You get a more structured RDD and programs based on DataFrame API will be automatically optimized by Spark’s built-in optimizer, __Catalyst__.

For more information, have a look at [this article](http://www.sparktutorials.net/Getting+Started+with+Apache+Spark+DataFrames+in+Python+and+Scala){target="\_blank"}.
{: .vscc-notify-info }

First, download [flights-2008.csv](../resources/flights-2008.csv){target="\_blank"} and put it in your hdfs folder. It contains some flight information in csv format.

For this example, we will use `spark-csv`, which requires to start the console with the command `pyspark --packages com.databricks:spark-csv_2.11:1.1.0`
{: .vscc-notify-warn }


```python
df = sqlContext.read.format("com.databricks.spark.csv").option("header", "true").load("2008.csv")
df.count()
df.printSchema()
```
Here, we just loaded the csv file. Since it has headers, spark can automatically infer the columns, but they are all considered strings. To change that, we define a function which casts a column, then insert it back into the schema:

```python
def convertColumn(df, name, new_type):
    # 1. rename col
    # 2. cast the column into new_type
    # 3. add the casted column to the df, under name
    # 4. drop the old column
    df_1 = df.withColumnRenamed(name, "swap")
    return df_1.withColumn(name, df_1["swap"].cast(new_type)).drop("swap")

df = convertColumn(df, "FlightNum", "int")
df = convertColumn(df, "DepDelay", "int")
df = convertColumn(df, "ArrDelay", "int")
```

Ok, now let's play with the data:

```python
from pyspark.sql import functions as F # use SQL concepts
averageDelays = df.groupBy(df["FlightNum"]).agg(F.avg(df["ArrDelay"]), F.avg(df["DepDelay"]))
averageDelays.show()
```
Result:

```txt
+---------+------------------+-------------+
|FlightNum|     avg(ArrDelay)|avg(DepDelay)|
+---------+------------------+-------------+
|     3231|               2.0|         19.0|
|     3831|              17.0|         25.0|
|      231|               5.0|         12.0|
|     2631|              45.0|         60.0|
|      631|               6.0|          4.0|
|     1232|              11.0|         12.0|
|     2032|              20.0|         26.0|
|     2632|              32.0|         47.0|
|      632|              63.0|         77.0|
|     3232|              21.5|         34.0|
|     1032|              22.0|         20.0|
|      232|              35.0|         31.0|
|      832|              -7.0|         -4.0|
|     3832|              96.0|        101.0|
|      432|              24.0|         12.0|
|      433|30.666666666666668|         22.0|
|     3233|               3.0|          2.0|
|       33|              17.0|         24.5|
|     1033|               0.0|         17.0|
|     1034|               9.0|         -5.0|
+---------+------------------+-------------+
```

Other examples (see [the doc](https://spark.apache.org/docs/1.5.2/api/python/pyspark.sql.html){target="\_blank"} for all available functions):
```python
 # Correlation between two columns
df.corr("ArrDelay", "DepDelay") # = 0.9647874675196805
# compute statistics for numeric columns
df.describe().show()
# select distinct cells
df.select("FlightNum").distinct().count()
```
# pyspark standalone programs

To use the power of spark on YARN clusters, we must write a PySpark standalone application and launch it with `spark-submit`.

## Template

The basic template of a pyspark application is the following:
```python
## Spark Application - execute with spark-submit

## Imports
from pyspark import SparkConf, SparkContext

## Module Constants
APP_NAME = "My Spark Application"

## Closure Functions

## Main functionality

def main(sc):
    pass

if __name__ == "__main__":
    # the app name can be used to track the app
    # status with yarn application --list or through
    # the spark UI
    conf = SparkConf().setAppName(APP_NAME)

    # the line below is optional: you can also configure
    # the master mode with the option spark-submit --master
    # conf = conf.setMaster("local[*]")

    # create the spark context
    sc   = SparkContext(conf=conf)

    # Execute Main functionality
    main(sc)
```

## launch commands

!! In the daplab, don't forget to load the correct python module and to export the environment variables as described at the beginning of the article before proceeding.

```sh
# basic submission using default values
spark-submit my_script.py
# more complex example:
spark-submit --master yarn-client \
    --num-executors 10 \
    --driver-memory 20G \
    --executor-memory 10g \
    --conf spark.akka.frameSize=100 \
           spark.shuffle.manager=SORT \
           spark.yarn.executor.memoryOverhead=4096 \
     my_script.py
```
