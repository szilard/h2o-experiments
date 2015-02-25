library(microbenchmark)

x_d <- runif(3e8)
x_i <- sample(1:100, 3e8, replace = TRUE) 

microbenchmark(sum(x_d), sum(x_i), times = 5)

