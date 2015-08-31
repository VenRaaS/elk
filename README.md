# TOC
* [Introduction](#introduction)
* [Prerequisite](#prerequisite)
* [Elasticsearch](#elasticsearch)  
  * [Installation](#installation)
  * [Create indices](#create-indices)
  * [Counting API requests](#counting-api-requests)

### Introduction

This project applies [ELS](https://www.elastic.co/webinars/introduction-elk-stack) to make a nearly real time recommention system.   
All configuration and binary of [Elasticsearch, Logstash and Kibana](https://www.elastic.co/) are placed here.

### Prerequisite
* Java runtime (JRE) 1.7+

### Elasticsearch

#### Installation
1. download and extract from [Github](https://github.com/VenRaaS/elk.git), i.e. click [Download ZIP](https://github.com/VenRaaS/elk/archive/master.zip)
2. enter [CLI](https://en.wikipedia.org/wiki/Command-line_interface) mode and change working dir to `elasticsearch-1.7.1_ik\`
3. execute `bin\elasticsearch.bat`, (or `bin/elasticsearch` if linux like OS)
4. browse `http://localhost:9200` and check whether the response message looks as below.  
   `{"status" : 200, "name" : "Thing", "cluster_name" : "elasticsearch", ... }`
5. browse `http://localhost:9200/_plugin/head/` for [elasticsearch-head](http://mobz.github.io/elasticsearch-head/)

For more info, see [elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html).

#### Preliminary 
Data in ES is able to be access by the restful API, e.g. http://localhost:9200/{index}/{type}/{id}.
The concept of the major data structure of ES could be thought as following picture.
![](https://drive.google.com/uc?id=0B78KhWqVkVmtWkhRWTludU1FOFU)

#### Create indices

Each customer (tenant) consists of 4 indices (DB) for different purposes.
* **{custName}_bat** - batch data
* **{custName}_bill** - api calling count for billing
* **{custName}_oua** - online user alignment
* **{custName}_op**f - online prefernce pool

An index creation can be performed using a **restful api** request.  
For example, 
if our customer is titled `goshopping`, then the creation requests of the 4 indices look like follows.

* ```
 POST 
 http://localhost:9200/goshopping_bat/

* ```
 POST 
 http://localhost:9200/goshopping_bill/

* ```
 POST 
 http://localhost:9200/goshopping_oua/

* ```
 POST 
 http://localhost:9200/goshopping_opf/

For each request, Elasticsearch responds as follows if the index has been created successfully.
```
{
  "acknowledged": true
}
```

#### Counting API requests 
We stores daily recom'd API request counting information under **{custName}_bill/rec_ap/{yyyMMdd}**.  

##### API to increamt the count of recom'd requests
```
POST
http://localhost:9200/goshopping_bill/api_rec/20150829/_update
{
  "script": "ctx._source.count += 1",
  "upsert": {
    "count": 1,
    "update_time": "2015-08-29 10:24:09"
  }
}
```

##### API to query counting information
Query all daily count info from 2015-08-29
```
GET 
http://140.96.83.31:9200/goshopping_bill/api_rec/_search?q=update_time:[2015-08-29 TO *]
```

