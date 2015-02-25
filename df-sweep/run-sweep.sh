#!/bin/bash

Rscript sweep.R | tee sweep.out

cat sweep.out | egrep -A2 "median|= cores" | egrep "cores|sum\(" | grep == | sed 's/=//g' > _tmp-sweep1
cat sweep.out | egrep -A2 "median|= cores" | egrep "cores|sum\(" | cut -d" " -f6 | grep -v == > _tmp-sweep2
paste _tmp-sweep[12]


