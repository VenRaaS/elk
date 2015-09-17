# TOC
* [Introduction](#introduction)
* [Prerequisite](#prerequisite)
* [Elasticsearch](#elasticsearch)
  * [Installation](#installation)
  * [Create indices](#create-indices)
    * [Customer data structure](#customer-data-structure)
    * [Preliminary](#preliminary)
    * [VenRaaS AAA sync](#venraas-aaa-sync)
  * [Counting API requests](#counting-api-requests)
* [Logstash](#logstash)
* [Kibana](#kibana)

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
5. check `http://localhost:9200/_plugin/head/` for managemnet console [elasticsearch-head](http://mobz.github.io/elasticsearch-head/)

For more info, see [elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html).

#### Preliminary 
Data in ES is able to be access by the restful API, e.g. `http://localhost:9200/{index}/{type}/{id}`.  
The concept of the data structure relationship regarding {index}, {type} and {id} in ES could be thought as following picture.

![](https://drive.google.com/uc?id=0B78KhWqVkVmtS0djcjU3QWZsYnc)

#### Create indices
##### Overview of indices
The structure of indices and typies with respect to venraas and customers illustrates with following image.

<img src="https://drive.google.com/uc?id=0B78KhWqVkVmtczFPNlN2Y2JPQW8" width="700">

##### Customer data structure

Each customer (tenant) consists of 4 indices (DB) for different purposes.
* **{cust}_bat** - batch data
* **{cust}_bill** - api calling count for billing
* **{cust}_oua** - online user alignment
* **{cust}_opp** - online preference pool

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
 http://localhost:9200/goshopping_opp/

For each request, Elasticsearch responds as follows if the index has been created successfully.
```
{
  "acknowledged": true
}
```

##### VenRaaS AAA sync
The AAA (authentication, authorization, and accounting) info is available under `http://localhost:9200/venraas/com_pkgs`

venraas index creation:
```
POST 
http://localhost:9200/venraas
```

sync info of AAA:
```
POST
http://localhost:9200/venraas/com_pkgs
{
  "webServerTime": "2015-08-04 12:11:22",
  "companies": [
    {
      "comId": 1,
      "comName": "goshopping",
      "domainName": "www.goshopping.com",
      "UUID": "xyzxxxx",
      "package": {
        "packageId": 68,
        "packageName": "A suit",
        "packageEnableed": true,
        "apiRequestMax": 21000123,
        "userAccountMax": 11,
        "authList": [
          {
            "authId": 100,
            "authName": "總和 all 總覽 overview",
            "authEnabled": true,
            "authType": "TYPE_1_REPORT"
          },
          ...
        ]
      }
    }
  ]
}
```


#### Counting API requests 
We stores daily recom'd API request counting information under **{cust}_bill/api_count**.  

##### API for counting of recom'd requests
```
POST
http://localhost:9200/gohappy_bill/api_count
{
  "page_type": "gop",
  "algo_id": "b01",
  "count": 1,
  "update_time": "2015-09-02 13:15:10"
}
```
* [page_type](https://github.com/VenRaaS/venraas-user-guide/wiki/page-tagging#definition-of-page-type)

##### API to query counting information
* Query the histogram of hourly api request counting sum

  ```
POST 
http://localhost:9200/gohappy_bill/api_count/_search
{
  "size": 0,
  "query": {
    "query_string": {
      "query": "*"
    }
  },
  "aggs": {
    "name_histo": {
      "date_histogram": {
        "field": "update_time",
        "interval": "1h"
      },
      "aggs": {
        "name_cnt": {
          "sum": {
            "field": "count"
          }
        }
      }
    }
  }
}
```

* Query the histogram of hourly api request counting sum with the specified page type (Category)

  ```
POST
http://localhost:9200/gohappy_bill/api_count/_search
{
  "size": 0,
  "query": {
    "query_string": {
      "query": "page_type:cap"
    }
  },
  "aggs": {
    "name_histo": {
      "date_histogram": {
        "field": "update_time",
        "interval": "1h"
      },
      "aggs": {
        "name_cnt": {
          "sum": {
            "field": "count"
          }
        }
      }
    }
  }
}
```

### Logstash
TODO ...

### Kibana
TODO ...
