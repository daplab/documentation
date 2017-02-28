

This page aims at creating a "copy-paste"-like tutorial to publish and receive your first 
[Kafka](https://kafka.apache.org) messages.

This tutorial assumes you have a [proper environment setup](/getting_started.md)
to access the DAPLAB cluster.
{: .vscc-notify-info }

# Resources 

* [http://docs.confluent.io/2.0.0/schema-registry/docs/index.html](http://docs.confluent.io/2.0.0/schema-registry/docs/index.html)

# Schema Registry

# Endpoint

Schema Registry is available in the following IP:

```
10.10.10.233:8081
```

# Quick Start

```
$ curl -X POST -i -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    --data '{"schema": "{\"type\": \"string\"}"}' \
    http://10.10.10.233:8081/subjects/test-$(whoami)-value/versions
```


```
# List all subjects
$ curl -X GET -i http://10.10.10.233:8081/subjects
```

```
$ curl -X GET -i http://10.10.10.233:8081/subjects/test-$(whoami)-value/versions
```

curl -X GET -i http://10.10.10.233:8081/subjects/test-$(whoami)-value/versions/1

curl -X GET -i http://10.10.10.233:8081/subjects/test-$(whoami)-value/versions/latest


curl -X DELETE -i http://10.10.10.233:8081/subjects/test-$(whoami)-value


Note: Delete are not allowed.


# Kafka REst


curl "http://10.10.10.233:8082/topics"

