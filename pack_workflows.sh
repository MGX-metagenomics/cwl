#!/usr/bin/env bash

set -e

export PATH=/vol/mgx-sw/bin:$PATH

rm -f *_packed.cwl

for wf in *cwl; do
    name=`basename ${wf} .cwl`
    cwltool --pack $wf > tmp.json
    python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' < tmp.json > ${name}_packed.cwl
    rm tmp.json
done


