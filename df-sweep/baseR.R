library(microbenchmark)

x_d <- runif(3e8)
x_i <- sample(1:100, 3e8, replace = TRUE) 

microbenchmark(max(x_d), max(x_i), times = 5)

