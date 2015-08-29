# Introduction

This project applies [ELS](https://www.elastic.co/webinars/introduction-elk-stack) to make a nearly real time recommention system.   
All configuration and binary of [Elasticsearch, Logstash and Kibana](https://www.elastic.co/) are placed here.

### Elasticsearch
#### Installation
1. download and extract from [Github](https://github.com/VenRaaS/elk.git), i.e. click [Download ZIP](https://github.com/VenRaaS/elk/archive/master.zip)
2. enter [CLI](https://en.wikipedia.org/wiki/Command-line_interface) mode and change working dir to `elasticsearch-1.7.1_ik\`
2. execute `bin\elasticsearch.bat`, (or `bin/elasticsearch` if linux like OS)
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
   
#### Create indices
Each customer (tenant) consists of 4 indices (DB) for different purposes.
* **${custName}_bat** - batch data
* **${custName}_bill** - api calling count for billing
* **${custName}_oua** - online user alignment
* **${custName}_op**f - online prefernce pool

An index creation can be performed using a **restful api** request.  
For example, 
if our customer is titled `goshopping`, then the creation requests of the 4 indices look like follows.

* ```POST http://localhost:9200/goshopping_bat/``` 
* ```POST http://localhost:9200/goshopping_bill/``` 
* ```POST http://localhost:9200/goshopping_oua/``` 
* ```POST http://localhost:9200/goshopping_opf/``` 

For each request, Elasticsearch responds as follows if the index has been created successfully.
```
{
  "acknowledged": true
}
```


```
POST http://140.96.83.31:9200/x_bill/api_rec/20150829/_update
{
  "script": "ctx._source.count += 1",
  "upsert": {
    "count": 1,
    "update_time": "2015-08-29 10:24:09"
  }
}
```
