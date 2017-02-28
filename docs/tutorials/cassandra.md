
This tutorial assumes you have a [proper environment setup](/getting_started.md)
to access the DAPLAB cluster.
{: .vscc-notify-info }

This page aims at creating a "copy-paste"-like tutorial to run your first
[Cassandra](https://cassandra.apache.org) queries.

--------------------------------------------------------------
# Introduction


We assume that you understand the basic concepts of column-oriented databases. If not, please google a bit and then come back.
{: .vscc-notify-info }

As explained [here](http://www.planetcassandra.org/what-is-apache-cassandra/){:target:"_blank"},
Cassandra is a distributed database for managing large amounts of structured data across many commodity servers, while providing highly available service and no single point of failure. Born at Facebook, it is built on Amazon's Dynamo and Google's BigTable.  It also features a powerful query language, __CQL__, to interact with.

One of the originalities of Cassandra is its architecture. Rather than using a legacy _master-slave_ or a manual sharded architecture,
it has what is called a __masterless “ring” design__.  In Cassandra, all nodes play an identical role; there is no concept of a master node, with all nodes communicating with each other equally. This means that Cassandra has no single point of failure and it is easy to add/remove nodes from the ring.

We use the word "ring" because Cassandra uses a consistent hashing algorithm to distribute data among a cluster.
At start up each node is assigned a token range which determines its position in the cluster and the rage of data stored by the node. Thus, each node in a Cassandra cluster is responsible for a certain set of data which is determined by the partitioner. A __partitioner__ is a hash function for computing the resultant token for a particular row key. This token is then used to determine the node which will store the first replica.  

Since the machine holding the data is derived from the row key, the lookup is very fast. One drawback, though, is that Cassandra does not support _partial row key_ queries. It is also very important to choose wisely your row keys, to ensure that data are evenly spread across nodes.

Keys in Cassandra are important and somewhat difficult to wrasp. In short, with __simple primary keys__, the former is also called a _partition key_ and determines the node in which data are stored. But it is also possible to use _compound (composite) primary keys_. 

A __compound primary key__ consists of the partition key and one or more additional columns that determine clustering. The partition key determines which node stores the data. It is responsible for data distribution across the nodes. The additional columns determine per-partition clustering. Clustering is a storage engine process that sorts data within the partition.


--------------------------------------------------------------

# Resources

* The [official documentation from Datastax on CQL](http://docs.datastax.com/en/cql/3.3/cql/cqlIntro.html),
  the query language of Cassandra

# Usage

To interact with Cassandra, `cqlsh` will be used

```bash
cqlsh cassandra1.fri.lan
```

## Create a keyspace

```sql
CREATE KEYSPACE test_bperroud WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2 } ;
```

## Create a table

```sql
CREATE TABLE test_bperroud.table1 (
    k text,
    r text,
    v int,
    PRIMARY KEY (k, r)
) WITH CLUSTERING ORDER BY (r ASC);
```

You can `use test_bperroud` to avoid typing the keyspace name everytime
{: .vscc-notify-info }


## Insert data

```sql
USE test_bperroud;
INSERT INTO table1 (k, r, v) VALUES ('a', '1', 12);
INSERT INTO table1 (k, r, v) VALUES ('a', '2', 13);
INSERT INTO table1 (k, r, v) VALUES ('a', '3', 14);
INSERT INTO table1 (k, r, v) VALUES ('a', '4', 15);
INSERT INTO table1 (k, r, v) VALUES ('a', '5', 16);
INSERT INTO table1 (k, r, v) VALUES ('b', '1', 17);
INSERT INTO table1 (k, r, v) VALUES ('b', '3', 18);
INSERT INTO table1 (k, r, v) VALUES ('b', '5', 19);
INSERT INTO table1 (k, r, v) VALUES ('c', '2', 20);
INSERT INTO table1 (k, r, v) VALUES ('c', '3', 21);
INSERT INTO table1 (k, r, v) VALUES ('c', '4', 22);
```

The data inserted previously, represented in a tabular format, would give something like:

| key |   '1'   |   '2'   |   '3'   |   '4'   |   '5'  |
| --- | :-----: | :-----: | :-----: | :-----: | :----: |
| 'a' | v = 12  | v = 13  | v = 14  | v = 15  | v = 16 |
| 'c' |         | v = 20  | v = 21  | v = 22  |        |
| 'b' | v = 17  |         | v = 18  |         | v = 9  |


## Query the data

```sql
select * from table1;
```

Cassandra will return a non-tabular view of the data though:

```
 k | r | v
---+---+----
 a | 1 | 12
 a | 2 | 13
 a | 3 | 14
 a | 4 | 15
 a | 5 | 16
 c | 2 | 20
 c | 3 | 21
 c | 4 | 22
 b | 1 | 17
 b | 3 | 18
 b | 5 | 19

(11 rows)
```

## More queries

* Select for a particular key

```sql
select * from table1 where k = 'a'
```

* Select particular columns (for a given key)

```sql
select * from table1 where k = 'a' and r >= 2 and r <= 4
```

## Truncate or drop the table

```sql
TRUNCATE TABLE table1;
```

```sql
DROP TABLE table1;
```

# Installation

Hopefully Cassandra is already installed in the DAPLAB environment, and you don't need to
care about that.

In a nutshell, Cassandra install is really straight forward. Debian/Ubuntu has a few trick
in there, but you can always refer to the
[proper documentation](http://docs.datastax.com/en/cassandra/2.0/cassandra/install/installDeb_t.html)

On Redhat/CentOS, at the time of writing:
```bash
yum install cassandra22 cassandra22-tools
```

On Debian/Ubuntu
```bash
apt-get install cassandra=2.2.3 cassandra-tools=2.2.3
```

Important config options in `/etc/cassandra/conf/cassandra.yaml` are:

- `cluster_name`: the name of the cluster, current value is 'DAPLAB1'
- `num_tokens`: number of tokens (i.e. ranges) a node own in the ring, values are 256 and 512
- `listen_address` and `rpc_address`: ip addresses the node is listening to,
   current value is the public ip address
- `data_file_directories`: directories where the data is stored.
