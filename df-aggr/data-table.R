
library(data.table)

d <- fread("/tmp/d.csv")
## 30 s

colnames(d) <- c("x","y")


system.time(
  d[, mean(y), by=x]
)
## 12 s


system.time(
  d[, .N, by=x]
)
## 6 s


system.time(
  max(d$x)
)
## 0.2 s
