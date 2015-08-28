# Introduction

This project applies [ELS](https://www.elastic.co/webinars/introduction-elk-stack) to make a nearly real time recommention system.   
All configuration and binary of Elasticsearch, Logstash and Kibana are placed here.

### Elasticsearch
#### Installation
1. download and extract from [Github](https://github.com/VenRaaS/elk.git)
2. execute `bin\elasticsearch.bat`, (or `bin\elasticsearch.bat` if linux link OS)
3. browse `localhost:9200` check response message, which should look like as below.
```
{
  "status" : 200,
  "name" : "Thing",
  "cluster_name" : "elasticsearch",
  ...
}
```
   For more info, see [elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html).
