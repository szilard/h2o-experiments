#!/bin/bash

time R --vanilla --quiet << EOF
set.seed(123)
n <- 100e6
m <- 1e6
d <- data.frame(x = sample(m, n, replace=TRUE), y = runif(n))
write.table(d, file = "/tmp/d.csv", row.names = FALSE, col.names = FALSE, sep = ",")
EOF
## runs ~ 3 min

du -sh /tmp/d.csv 
## 2.4G    /tmp/d.csv

