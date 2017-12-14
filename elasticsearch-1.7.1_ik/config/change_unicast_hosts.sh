#!/bin/bash
#
# Usage:
#   bash list_group_gces.sh
#

GROUP="instance-group-ww-es-v171"
SCRIPT_DIR="$(cd $(dirname $0) && pwd)"

#-- list instance names of a given group
col1_ary=($(gcloud compute instance-groups managed list-instances ${GROUP} --zone=asia-east1-b | awk '{print $1}'))

#-- remove header
inst_ary=${col1_ary[@]:1}

#-- expanding name within double-quotes
inst_str=$(printf ",\"%s\"" ${inst_ary[@]})

inst_str=${inst_str:1}
echo $inst_str
sed -i -e "s/REPLACE_TO_GROUP_LIST/${inst_str}/" ${SCRIPT_DIR}/elasticsearch.yml
