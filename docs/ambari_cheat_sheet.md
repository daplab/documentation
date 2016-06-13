Ambari Cheat Sheet
----

[http://ambari.apache.org Ambari] is the web frontend to administer the Hadoop platform.
DAPLAB is running Ambari v2. Official documentation for Ambari and how to use
it is available either on the Ambari wiki or in the 
[HortonWorks documentation](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/bk_Ambari_Users_Guide/content/ch_Overview_Ambari_Users_Guide.html).
This page aims at giving some tips and tricks, and contextualizing to the DAPLAB
infrastructure the examples found online.

In all the examples below, `${ambari_credentials}` refers to your `username` and `password`
used to log into Ambari UI, concatenated with `:` -- `admin:admin` by default:

```bash
ambari_credentials="admin:admin"
```

# REST API

* [https://github.com/apache/ambari/blob/trunk/ambari-server/docs/api/v1/index.md](https://github.com/apache/ambari/blob/trunk/ambari-server/docs/api/v1/index.md)

List all the hosts:

```bash
curl -v -X GET -u ${ambari_credentials} -H 'X-Requested-By:ambari' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/hosts
```

* `-u` to provide credentials
* `-X GET` is optional, but show how to send a `-X POST` or `-X DELETE` request for instance
* `-H 'X-Requested-By:ambari'` is a mandatory magic argument __avoiding__ CSRS
* `-v` gives more details about the response, including the [HTTP status code](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes)


# Alerts Definition

* http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/bk_Ambari_Users_Guide/content/_alert_definitions_and_instances.html
* https://github.com/apache/ambari/blob/trunk/ambari-server/docs/api/v1/alert-definitions.md

```bash
curl -v -X GET -u ${ambari_credentials} -H 'X-Requested-By:ambari' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/alert_definitions
```

curl -v -X GET -u ${ambari_credentials} -H 'X-Requested-By:ambari' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/alert_definitions?AlertDefinition/service_name=HIVE




/usr/local/bin/ambari_check_test.sh

curl -v -X POST --data "$payload" -u ${ambari_credentials} -H 'X-Requested-By:ambari' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/alert_definitions

payload='{
  "AlertDefinition" : {
    "cluster_name" : "DAPLAB02",
    "component_name" : "PIG",
    "description" : "abcd",
    "enabled" : true,
    "ignore_host" : false,
    "interval" : 1,
    "label" : "Custom Check3",
    "name" : "custom_check_3",
    "scope" : "SERVICE",
    "service_name" : "PIG",
    "source" : {
      "parameters" : [ ],
      "path" : "/usr/local/bin/ambari_check_test.py",
      "type" : "SCRIPT"
    }
  }
}'

curl -v -X DELETE -u ${ambari_credentials} -H 'X-Requested-By:ambari' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/alert_definitions/102




# Deleting a Journal Node

Source: https://cwiki.apache.org/confluence/display/AMBARI/Using+APIs+to+delete+a+service+or+all+host+components+on+a+host

```
cluster=DAPLAB02
host=daplab-wn-24.fri.lan
```

1. Ensure the JournalNode is stopped

    ```curl -u ${ambari_credentials} -H 'X-Requested-By: Ambari' -X PUT -d '{"RequestInfo":{"context":"Install JournalNode"},"Body":{"HostRoles":{"state":"INSTALLED"}}}' https://admin.daplab.ch/api/v1/clusters/${cluster}/hosts/${host}/host_components/JOURNALNODE```

2. Delete the JournalNode

    ```curl -u ${ambari_credentials} -H 'X-Requested-By: Ambari' -X DELETE https://admin.daplab.ch/api/v1/clusters/${cluster}/hosts/${host}/host_components/JOURNALNODE```


Assign JournalNode
Assign the role of JournalNode using the following command:
curl -u ${ambari_credentials} -H 'X-Requested-By: Ambari' -X POST https://admin.daplab.ch/api/v1/clusters/DAPLAB02/hosts/daplab-wn-24.fri.lan/host_components/JOURNALNODE
Install Journalnode
Now go ahead and install the JournalNode.
curl -u ${ambari_credentials} -H 'X-Requested-By: Ambari' -X PUT -d '{"RequestInfo":{"context":"Install JournalNode"},"Body":{"HostRoles":{"state":"INSTALLED"}}}' https://admin.daplab.ch/api/v1/clusters/DAPLAB02/hosts/daplab-wn-24.fri.lan/host_components/JOURNALNODE

(reference: http://zdatainc.com/2015/09/add-journalnode-to-ambari-managed-hadoop-cluster/)

