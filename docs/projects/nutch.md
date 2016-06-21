Crawling Internet with Nutch
========

## Pointers

* [Apache Nutch](http://nutch.apache.org/)
* [Nutch Tutorial](https://wiki.apache.org/nutch/NutchTutorial)

## Abstract

First, export some environment variables:
```
export HADOOP_CONF=/etc/hadoop/conf
export NUTCH_HOME=/usr/local/apache-nutch
export HADOOP_CLASSPATH=.:$NUTCH_HOME/conf:$NUTCH_HOME/runtime/local/lib
export PATH=$PATH:/usr/local/apache-nutch/runtime/deploy/bin
export NUTCH_CONF=/usr/local/apache-nutch/conf
```

Then, run nutch:
```
> nutch
> crawl urlsdir crawl 1
```
