
#### Doing tabular data aggegates with H2O

While H2O has not been designed for this, I'm trying to see how fast it can do aggregates
with tabular data (e.g. average of one column grouped by other column). Will compare
with R/data.table ([fast](http://datascience.la/dplyr-and-a-very-basic-benchmark/),
but single threaded).

Running latest stable H2O (2.8.4.4) on 16-core single node, 64GB RAM.

Generated 100-million row CSV file with 2 columns: `x` int 1..10^6 and `y` float [0,1].

```
time R --vanilla --quiet << EOF
set.seed(123)
n <- 100e6
m <- 1e6
d <- data.frame(x = sample(m, n, replace=TRUE), y = runif(n))
write.table(d, file = "/tmp/d.csv", row.names = FALSE, col.names = FALSE, sep = ",")
EOF
```

Runs 3 minutes and creates 2.4GB file.


##### Prep

H2O: start the server and then:
```
library(h2o)
srvx <- h2o.init(startH2O = FALSE) 
```

data.table:
```
library(data.table)
```


##### Reading the CSV

H2O:
```
dx <- h2o.importFile(srvx, path = "/tmp/d.csv", key = "d.hex") 
colnames(dx) <- c("x","y")
```

data.table:
```
d <- fread("/tmp/d.csv")
colnames(d) <- c("x","y")
```

H2O 20 seconds, data.table 30 seconds.


##### Aggregate

Looking to do what in SQL would be:
```
select x, avg(y) from T group by x
```

H2O:
```
fun <- function(df) { mean(df[,2]) }
h2o.addFunction(srvx, fun)

h2o.ddply(dx, "x", fun)
```

data.table:
```
d[, mean(y), by=x]
```

H2O's ddply was very slow (had to kill after not finishing in 5 minutes),
data.table 12 seconds.


##### Counts

If I can't do aggregates, I still can do counts:
```
select x, count(*) from T group by x
```

H2O:
```
h2o.table(dx$x)
```

data.table:
```
d[, .N, by=x]
```

H2O 12 sec, data.table 6 sec. (Note data.table is single threaded, H2O saturates
all cores.)


##### Max

Maybe if I just do sweeping over the data (and some simple computation) H2O is
gonna win with multi-core.

H2O:
```
max(dx$x)
```

data.table:
```
max(d$x)
```

H2O 2 sec, data.table 0.2 sec.


##### Conclusion

This was more like an exercise, how fast would H2O be as a tabular data aggregation
engine. For machine learning this kind of stuff is probably totally irrelevant, the
engine will spend most time doing way more complex computations. data.table is just
for tabular data filtering/aggregates/joins and it's pretty good at it even with
single node-single thread restriction. 


