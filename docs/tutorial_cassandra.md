
This page aims at creating a "copy-paste"-like tutorial to run your first 
[Cassandra](https://cassandra.apache.org) queries.


This tutorial assumes you have a [proper environment setup](getting_started.md) 
to access the DAPLAB cluster.
{: .vscc-notify-info }

# Resources 

* The [official documentation from Datastax on CQL](http://docs.datastax.com/en/cql/3.3/cql/cqlIntro.html),
  the query language of Cassandra

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

