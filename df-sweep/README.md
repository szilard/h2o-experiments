
#### Sweeping thru data

Wondering how fast can H2O sweep thru data, i.e. read thru the data and do some simple 
computation (such as `sum`). Will compare with R's vectors (single threaded).

Running latest stable H2O (2.8.4.4) on 16-core single node, 64GB RAM.

2 cases: random doubles (very little compression) and random ints (significant 
compression). Generate vectors of length 300 million, doubles will take 2.3GB, ints will be compressed and take 280MB only.

Generating data:
```
dx <- h2o.createFrame(srvx, key = "sweep.hex", 
    rows = 3e8, cols = 1, missing_fraction = 0,
    categorical_fraction = 0, binary_fraction = 0, integer_fraction = int_frac)
```
where `int_frac` is 0 for doubles and 1 for ints.

Sweeping:
```
sum(dx$C1)
```

Measure time for sweeping (calculating `sum`) for int/double by changing the 
number of cores `1,2,3,...`
```
 type:  double   cores:  1      11.37794
 type:  double   cores:  2      7.040553
 type:  double   cores:  3      6.426214
 type:  double   cores:  4      5.835844
 type:  double   cores:  6      5.522211
 type:  double   cores:  8      5.977422
 type:  double   cores:  10     5.312882
 type:  double   cores:  12     5.781204
 type:  double   cores:  14     6.106652
 type:  int   cores:  1         19.45165
 type:  int   cores:  2         10.53066
 type:  int   cores:  3         8.147421
 type:  int   cores:  4         6.655807
 type:  int   cores:  6         6.19305
 type:  int   cores:  8         5.958051
 type:  int   cores:  10        6.050966
 type:  int   cores:  12        6.254027
 type:  int   cores:  14        7.814335
 ```
 
 Processing speed ~0.5 GB/sec (GB raw data). Strangely, there is no improvement for running
 on more than 4 cores for doubles or on more than 6 cores for ints (I assume the higher threshold
 is because of need for decompress the data). Therefore best case 5 sec for doubles, 6 for ints.
 
 In contrast, in base R:
 ```
x_d <- runif(3e8)
x_i <- sample(1:100, 3e8, replace = TRUE) 
sum(x_d)
sum(x_i)
```
it takes 0.48 sec for doubles, 0.42 sec for ints, 10x faster than H2O.




