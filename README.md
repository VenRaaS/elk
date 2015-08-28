# Introduction

This project applies ELS to make a nearly real time recommention system.   
All configuration and binary of Elasticsearch, Logstash and Kibana are placed here.

### Elasticsearch
#### Installation
* download and extract from [Github](https://github.com/VenRaaS/elk.git)
* execute `bin\elasticsearch.bat`, (or `bin\elasticsearch.bat` if linux link OS)
* browse `localhost:9200` check response message
```
{
    status: 200,
    name: "Thing",
    cluster_name: "elasticsearch",
    ...
}
```
