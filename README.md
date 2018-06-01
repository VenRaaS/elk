# TOC
* [Introduction](#introduction)
* [Prerequisite](#prerequisite)
* [Elasticsearch](#elasticsearch)
  * [Installation](#installation)
  * [System Configuration](#system-configuration)
  * [Preliminary](#preliminary)
  * [Create indices](#create-indices)
    * [Overview](#overview)
    * [Customer data structure](#customer-data-structure)
    * [VenRaaS AAA sync](#venraas-aaa-authentication-authorization-and-accounting-sync)
  * [Counting API requests](#counting-api-requests)
* [Logstash](#logstash)
* [Kibana](#kibana)

### Introduction

This project applies [ELS](https://www.elastic.co/webinars/introduction-elk-stack) to make a nearline tier of the recommention system.   
All configuration and binary of [Elasticsearch, Logstash and Kibana](https://www.elastic.co/) are placed here.

### Prerequisite
* Java runtime (JRE/JDK) 1.8+  
`apt-get install openjdk-8-jdk`, on ubuntu 14.04 LTS or above

### Elasticsearch
#### System Configuration
all of following instructions references from [https://www.elastic.co/guide/en/elasticsearch/reference/5.6/system-config.html](https://www.elastic.co/guide/en/elasticsearch/reference/5.3/system-config.html)
* [/etc/security/limits.conf](https://www.elastic.co/guide/en/elasticsearch/reference/current/setting-system-settings.html#limits.conf)
  * set the maximum number of open files for the elasticsearch user, e.g. elk
  * [ubuntu and `limits.conf`](https://www.elastic.co/guide/en/elasticsearch/reference/current/setting-system-settings.html#limits.conf)
    * to enable the `limits.conf` file, uncomment the following line `session required pam_limits.so` in `/etc/pam.d/su`
  * grant elasticsearch user permission to lock memory 
```
# /etc/security/limits.conf
elk    -    nofile       65536                                  
elk    -    memlock      unlimited
```  
  
* [mmapfs](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)
  * increase the limits of mmap count, and run `sysctl vm.max_map_count` to verify
```
# /etc/sysctl.conf
vm.max_map_count=262144
```

#### Installation
1. download and extract from [Github](https://github.com/VenRaaS/elk.git), i.e. click [Download ZIP](https://github.com/VenRaaS/elk/archive/master.zip)
2. enter [CLI](https://en.wikipedia.org/wiki/Command-line_interface) mode and change working dir to `elasticsearch\`
3. enlarge [heap size](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/heap-size.html) to performance (optional, reserves at least half memory to OS)
   - [jvm.options](https://github.com/VenRaaS/elk/blob/master/elasticsearch/config/jvm.options)
5. start elasticsearch instance  
   - `bin/elasticsearch` (`bin/elasticsearch -d` demon mode) if linux like OS
6. browse `http://localhost:9200` and check whether the response message looks as below.  
   `{"status" : 200, "name" : "Thing", "cluster_name" : "elasticsearch", ... }`
7. install Chrome extension [ElasticSearch Head](https://chrome.google.com/webstore/detail/elasticsearch-head/ffmkiejjmecolpfloofpjologoblkegm/)
8. check `http://localhost:9200/_plugin/head/` for managemnet console.  
   see [elasticsearch-head](https://github.com/mobz/elasticsearch-head) for detail.

For more info, see [elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html).

#### Preliminary 
Data in ES is able to be access by the restful API, e.g. `http://localhost:9200/{index}/{type}/{id}`.  
The concept of the data structure relationship regarding {index}, {type} and {id} in ES could be thought as following picture.

![](https://drive.google.com/uc?id=0B78KhWqVkVmtS0djcjU3QWZsYnc)

#### Create indices
##### Overview
The structure of indices and typies with respect to venraas and customers illustrates with following image.

<img src="https://drive.google.com/uc?id=1dOmpNGHPpwCfty8_c8W-FStu4Wp0AmG_" width="700">

##### Customer data structure

Each customer (tenant) consists of 4 indices (DB) for different purposes.
* **{cust}_gocc** - batch data of Goods, Order, Category (and GoodsCateCode), Customer
* **{cust}_mod** - recom'd models
* **{cust}_oua** - online user alignment
* **{cust}_opp** - online preference pool

An index creation can be performed using a **restful api** request.  
For example, 
if our customer is titled `goshopping`, then the creation requests of the 4 indices look like follows.

* `POST http://localhost:9200/goshopping_gocc/`

* `POST http://localhost:9200/goshopping_mod/`

* `POST http://localhost:9200/goshopping_oua/`

* `POST http://localhost:9200/goshopping_opp/`

For each request, Elasticsearch responds as follows if the index has been created successfully.
```
{
  "acknowledged": true
}
```

##### VenRaaS AAA (authentication, authorization, and accounting) sync
venraas index creation:
```
POST 
http://localhost:9200/venraas
```

The AAA info is available under 
* `http://localhost:9200/venraas/action` stores an action content per record.
* `http://localhost:9200/venraas/package` stores all package information per record.
* `http://localhost:9200/venraas/company` stores all company information per record.

sync info of AAA:
```
POST
http://localhost:9200/venraas/action
{  
  "updateTime":"2015-10-08 17:26:01",
  "account":"eric@goshopping.com",
  "accountId":1,
  "actionType":"新增公司",
  "actionContent":{  
    "companyId":19,
    "companyName":"goshopping",
    "codename":"goshopping",
    "domainName":"www.goshopping.com",
    "companyEnabled":true,
    "offlinemodelstatus":true,
    "token":"5Lc57e8WpD3",
    "userAdminId":163,
    "venraasptstatus":true,
    "packageId":68
  }
}
```
```
POST
http://localhost:9200/venraas/company
{  
  "updateTime":"2015-10-08 17:26:01",
  "companies":[  
    {  
      "companyId":1,
      "domainName":"www.goshopping.com",
      "companyName":"goshopping",
      "companyEnabled":true,
      "codename":"goshopping",
      "token":"5Lc57e8WpD3",
      "offlinemodelstatus":true,
      "venraasptstatus":true,
      "package":{  
        "packageId":69,
        "packageName":"B套餐",
        "packageEnabled":true,
        "apiRequestMax":1000,
        "userAccountMax":2,
        "fee":0,
        "extraImpressionFee":0
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
  "fea_id": "b01",
  "count": 1,
  "update_time": "2015-09-02 13:15:10"
}
```
* [page_type](https://github.com/VenRaaS/venraas-user-guide/wiki/page-tagging#definition-of-page-type)

##### API to query counting information
* Query the histogram of hourly api request count
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

* Query the histogram of hourly api request count with the specified page type, i.e. Category
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

* Query the histogram grouped by $index and $page_type for daily api request count within a specific duration, i.e. Category
```
POST
http://localhost:9200/*_bill/api_count/
{
  "size": 0,
  "query": {
    "filtered": {
      "query": {
        "query_string": {
          "query": "_type:api_count AND update_time:[2015-10-01 TO 2015-10-6]",
          "analyze_wildcard": true
        }
      }
    }
  },
  "aggs": {
    "group_by_index": {
      "terms": {
        "field": "_index"
      },
      "aggs": {
        "group_by_pageType": {
          "terms": {
            "field": "page_type"
          },
          "aggs": {
            "day_sum": {
              "date_histogram": {
                "field": "update_time",
                "interval": "1d"
              },
              "aggs": {
                "sum_count": {
                  "sum": {
                    "field": "count"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
```

* Query the overall histogram of hourly api request count
``` 
POST http://localhost:9200/*/api_count/_search
```
  
### Logstash
#### Installation
1. `cd logstash` to switch working dir
2. `tar -xvzf logstash-${version}.tar.gz` to unpack package
3. `rm ~/.since*` to reset sync cursor
4. (optional, package updated)  
   `./logstash-1.5.4/bin/plugin update logstash-input-lumberjack` update lumberjack plugin.(Ref: elk/wiki/Logstash-Configuration-for-Lumberjack-Input) 
5. `./logstash-1.5.4/bin/logstash -f conf/weblog.conf` to instance a logstash for weblog
 * `nohup ./logstash-1.5.4/bin/logstash -f conf/weblog.conf > /dev/null 2>&1 &` run in backgroud and nohup

#### Reference
* [Breaking changes 2.x => 5.x](https://www.elastic.co/guide/en/logstash/5.x/breaking-changes.html)
