# Introduction

This project applies [ELS](https://www.elastic.co/webinars/introduction-elk-stack) to make a nearly real time recommention system.   
All configuration and binary of Elasticsearch, Logstash and Kibana are placed here.

### Elasticsearch
#### Installation
1. download and extract from [Github](https://github.com/VenRaaS/elk.git), i.e. click [Download ZIP](https://github.com/VenRaaS/elk/archive/master.zip)
2. enter [CLI](https://en.wikipedia.org/wiki/Command-line_interface) mode and change working dir to `elasticsearch-1.7.1_ik\`
2. execute `bin\elasticsearch.bat`, (or `bin\elasticsearch` if linux link OS)
3. browse `http://localhost:9200` and check whether the response message looks as below.  
```
{
  "status" : 200,
  "name" : "Thing",
  "cluster_name" : "elasticsearch",
  ...
}
```
for more info, see [elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html). 
   
