
#### Sweeping thru data

Wondering how fast can H2O sweep thru data, i.e. read thru the data and do some simple 
computation (such as `max`). Will compare with R's vectors (single threaded).

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
max(dx$C1)
```

Measure time for sweeping (calculating `max`) for int/double by changing the 
number of cores `1,2,3,...`
```
 type:  double   cores:  1      10.62789
 type:  double   cores:  2      7.183226
 type:  double   cores:  3      5.68945
 type:  double   cores:  4      5.927154
 type:  double   cores:  6      5.492565
 type:  double   cores:  8      5.581005
 type:  double   cores:  10     5.128422
 type:  double   cores:  12     5.983976
 type:  double   cores:  14     5.62017
 type:  int   cores:  1         18.66733
 type:  int   cores:  2         10.48401
 type:  int   cores:  3         7.69993
 type:  int   cores:  4         6.529482
 type:  int   cores:  6         5.852742
 type:  int   cores:  8         5.939421
 type:  int   cores:  10        5.851672
 type:  int   cores:  12        6.327242
 type:  int   cores:  14        7.43186
 ```
 
 Processing speed ~GB/sec (GB raw data). Strangely, the is no improvement for running
 of more than 3 cores for doubles or more than 6 cores for ints (I assume the higher throshold
 is because of need for decompress the data).
 
 
 


