# HBase tutorial

Here, we cover the use of hbase interactive shell for basic manipulations.

# HBase shell and general commands

In the command line, type the following to enter the HBase shell:

```
$ hbase shell
```

Then, run some general commands:

__status__: `status` gives details about the system like the number of servers and the average load.
By default, you will get only a summary. Use `status 'simple'` or `status 'detailed'` for more output (notice the simple quotes for the command arguments).

__version__: `version` outputs the current version of HBase.

__table help__: `table_help` is like a _man commands_, it gives you explanations and example of
how to manipulate tables in hbase.

__whoami__: `whoami` returns the current HBase user information from the HBase cluster.

# Table manipulation

Now, here is the interesting stuff.

Table manipulations commands have similar names than SQL, but their syntax is quite different. Here is a list of available commands:

- Create
- List
- Describe
- Disable
- Disable_all
- Enable
- Enable_all
- Drop
- Drop_all
- Show_filters
- Alter
- Alter_status

Here, you cover only some of them.

## Create a table and add data to it

Create a simple table named _students_ with two column families:

```
create 'students','account','address'
```

You can now ask the system about the table you created by running:

```
describe 'students'

COLUMN FAMILIES DESCRIPTION                                                                             
{NAME => 'account', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => '
FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', COMPRESSION => 'NONE', MIN_VERSIONS => '0', BLO
CKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}                                      
{NAME => 'address', BLOOMFILTER => 'ROW', VERSIONS => '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS => '
FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL => 'FOREVER', COMPRESSION => 'NONE', MIN_VERSIONS => '0', BLO
CKCACHE => 'true', BLOCKSIZE => '65536', REPLICATION_SCOPE => '0'}                                      
2 row(s) in 0.1240 seconds
```
The table seems fine and the two column families are present. Note also the "VERSIONS" here, which is set to 1. It means that when you update a record, the previous values will not be kept.

Now, let's add data.

Adding data to a table is not like SQL. Indeed, we use one `put` command for each new column in a row. A row is determined by its _row key_. Here, we create four rows/students, with information scattered across two column families:

```
put 'students','student1','account:name','Alice'
put 'students','student1','address:street','123 Ballmer Av'
put 'students','student1','address:zipcode','12345'
put 'students','student1','address:state','CA'
put 'students','student2','account:name','Bob'
put 'students','student2','address:street','1 Infinite Loop'
put 'students','student2','address:zipcode','12345'
put 'students','student2','address:state','CA'
put 'students','student3','account:name','Frank'
put 'students','student3','address:street','435 Walker Ct'
put 'students','student3','address:zipcode','12345'
put 'students','student3','address:state','CA'
put 'students','student4','account:name','Mary'
put 'students','student4','address:street','56 Southern Pkwy'
put 'students','student4','address:zipcode','12345'
put 'students','student4','address:state','CA'
```

It is also possible to save the above into a txt file and then run the command `data.txt | hbase shell`.


# Run simple queries

First, let check that the data were properly inserted:
```
count 'students'
=> 4
```
We have four rows. Let's display them:
```
scan 'students'

ROW        COLUMN+CELL
student1   column=account:name, timestamp=1466600657594, value=Alice
student1   column=address:state, timestamp=1466600657801, value=CA
...  
```

As you can see, each "line" we inserted contains more than the information we put. Indeed, column families must be defined during the creation of the table, but after that, you can put whatever column you want. It is even possible to have completely different columns for each row.
So, for each column of a row, you have its name (`<column family>:<column name>`), its value and a timestamp. This timestamp is used for versioning.

The `scan` command can be pretty time consuming: avoid it if you have a large amount of data.
{: .vscc-notify-warn }

The `get` command let's your retrieve information about one row only. The basic syntax is:

```
get 'students', 'student1'

COLUMN              CELL
account:name        timestamp=1466601407693, value=Alice   
address:state       timestamp=1466600657801, value=CA  
address:street      timestamp=1466600657733, value=123 Ballmer Av  
address:zipcode     timestamp=1466600657777, value=12345  
```

To get information about a specific column, we need to use a filter. For example:

```
get 'students', 'student1', {COLUMN => 'account:name'}

COLUMN             CELL
 account:name      timestamp=1466601407693, value=Alice
```

# Run more complex queries

We have covered the basic `scan` and `get`. Now, we will have a look at the filters. A filter, or query parameter, is enclosed in brackets at the end of the query and has the form `{ FILTER => 'the filter' }`. Most filters have the name of the Java class implementing them.

You can find the list of available filters, as well as some examples, in the [cloudera documentation](http://www.cloudera.com/documentation/enterprise/5-5-x/topics/admin_hbase_filtering.html).
{: .vscc-notify-info }

We already tested the `COLUMN` filter, which is also available for the `scan` command.

Now, let's query all students with a name containing the letter "a". Since we want multiple rows, we use `scan`:

```
scan 'students', { COLUMN => 'account:name', FILTER => "ValueFilter(=, 'substring:a')" }
```

Let's find students living in California:
```
scan 'students', { FILTER => "ValueFilter(=, 'binary:CA')" } // less performant
scan 'students', { COLUMN => 'address:state', FILTER => "ValueFilter(=, 'binary:CA')" }
```

Here are some more complex queries:
```
scan 'students', {COLUMNS => ['address:state', 'account:name'], LIMIT => 2, STARTROW => 'student2'}
scan 'students', {FILTER => "ColumnPrefixFilter ('s')" } // address:state, address:street
```
