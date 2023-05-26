#!/usr/bin/env bash

set -e

for wf in *cwl; do
    name=`basename ${wf} .cwl`
    cwltool --pack $wf > tmp.json
    python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < tmp.json > ${name}_packed.cwl
    rm tmp.json
done


