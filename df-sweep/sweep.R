
library(h2o)
library(microbenchmark)

generate_frame <- function(type = c("int","double")) {
  type <- match.arg(type)
  int_frac = switch(type, int = 1, double = 0)
  
  h2o.createFrame(srvx, key = "sweep.hex", 
                  rows = 3e8, cols = 1, missing_fraction = 0,
                  categorical_fraction = 0, binary_fraction = 0, integer_fraction = int_frac)
}

for (type in c("double","int")) {
  for (k in c(1,2,3,4,6,8,10,12,14)) {
    
    srvx <- h2o.init(startH2O = TRUE, max_mem_size = "30G", nthreads = k) 
    Sys.sleep(5)
    
    cat("======= type: ",type," === cores: ",k," =======\n")
    print(microbenchmark(dx <- generate_frame(type), times = 1))
    print(microbenchmark(max(dx$C1), times = 5))
    
    h2o.shutdown(srvx, prompt = FALSE)
    Sys.sleep(5)
    
  }
}

