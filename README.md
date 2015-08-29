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
* ${custName}_bat - batch data
* ${custName}_bill - api calling count for billing
* ${custName}_oua - online user alignment
* ${custName}_opf - online prefernce pool

An index creation can be performed using a **restful api** request.  
The response message will show as below if the index has been created successfully.
```
{
  "acknowledged": true
}
```

The following examples create 4 indices regarding  a company, i.e. `goshopping`.

##### Create ${custName}_bat
```
POST http://localhost:9200/goshopping_bat/
```

##### Create ${custName}_bill
```
POST http://localhost:9200/goshopping_bill/
```

##### Create ${custName}_oua 
```
POST http://localhost:9200/goshopping_oua/
```

##### Create ${custName}_opf 
```
POST http://localhost:9200/goshopping_opf/
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
