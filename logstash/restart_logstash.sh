#!/bin/bash

PID_LOGSTASH_MOD="$(jps -m  | grep 'mod_file.conf' | awk '{print $1}')"
kill -9 ${PID_LOGSTASH_MOD}

nohup logstash/logstash-5.6.10/bin/logstash -f logstash/conf/mod_file.conf --path.data /tmp/logstash_data.mod_file.conf > /dev/null 2>&1 &

#nohup /home/itri/elk/logstash/logstash-5.6.10/bin/logstash -f /home/itri/elk/logstash/conf/update_gocc_file_ipd.json.conf --path.data /tmp/logstash_data.update_gocc_file_ipd.json.conf > /dev/null 2>&1 &
#nohup /home/itri/elk/logstash/logstash-5.6.10/bin/logstash -f /home/itri/elk/logstash/conf/gocc_file_ipd.json.conf --path.data /tmp/logstash_data.gocc_file_ipd.json.conf > /dev/null 2>&1 &
