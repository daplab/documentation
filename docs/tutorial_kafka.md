
This page aims at creating a "copy-paste"-like tutorial to publish and receive your first 
[Kafka](https://kafka.apache.org) messages.

This tutorial assumes you have a [proper environment setup](getting_started.md) 
to access the DAPLAB cluster.
{: .vscc-notify-info }

# Resources 

* [http://sookocheff.com/post/kafka/kafka-in-a-nutshell/](http://sookocheff.com/post/kafka/kafka-in-a-nutshell/)
* [https://gist.github.com/ashrithr/5811266](https://gist.github.com/ashrithr/5811266)
* [http://blog.cloudera.com/blog/2014/09/apache-kafka-for-beginners/](http://blog.cloudera.com/blog/2014/09/apache-kafka-for-beginners/)
* [http://kafka.apache.org/documentation.html](http://kafka.apache.org/documentation.html)

# Consumers

Kafka has two types of consumers: Group Consumers and Simple Consumer.

* Group Consumer provides high-level abstraction to read from topics, with less
  fine-grained control over what you're doing.
* Simple Consumer on the other hand provides really low API to read from anywhere within
  a partition, but lots or retry logic is deferred to the caller.

It's thus always a trade-off to decide which one to pick, depending what you're trying 
to build. Lots of softwares are using both Simple and Group consumer, 
depending the task to achieve. 

# Listing existing topics

```bash
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper zookeeper1.fri.lan --list
```

# Create a new topic

```bash
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create \
  --zookeeper zookeeper1.fri.lan \
  --replication-factor 2 \
  --partitions 1 \
  --topic test-$(whoami)
```

Mind that this example creates a topic with **one single** partition. 
You can obviously create more partitions within your topic, but the consuming examples
must be slightly adapted.
{: .vscc-notify-warning }

# Publishing messages

```bash
echo -e "message1\nmessage2\nmessage3" | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh \
  --broker-list kafka1.fri.lan:6667 \
  --topic test-$(whoami)
```

# Read topic offset

This command line call helps you validating if your messages have been properly published

```bash
/usr/hdp/current/kafka-broker/bin/kafka-run-class.sh kafka.tools.GetOffsetShell \
  --broker-list kafka1.fri.lan:6667 \
  --time -1 \
  --topic test-$(whoami)
```

# Reading messages

Read the 3 first messages from partition 0 of the topic:

```bash
/usr/hdp/current/kafka-broker/bin/kafka-simple-consumer-shell.sh \
  --broker-list kafka1.fri.lan:6667 \
  --topic test-$(whoami) \
  --offset -2 \
  --max-messages 3 \
  --partition 0
```

Read the first 3 messages of the topic, if you have more than one partition

```bash
/usr/hdp/current/kafka-broker/bin/kafka-console-consumer.sh \
  --zookeeper zookeeper1.fri.lan \
  --topic test-$(whoami) \
  --from-beginning \
  --max-messages 3
```

## Java Code

Please checkout [Kafka Starter](https://github.com/daplab/kafka-starter) project 
to get a complete Java, Maven-based project to import in your IDE, including 
embedded Kafka server for testing.

```bash
## Clone the project
git clone https://github.com/daplab/kafka-starter.git

## Build it
mvn clean install
```
