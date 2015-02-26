
#### Sweeping thru data

Wondering how fast can H2O sweep thru data, i.e. read thru the data and do some simple 
computation (such as `sum`). Will compare with R's vectors (single threaded).

Running latest stable H2O (2.8.4.4) on c4.4xlarge (16-core, 30GB RAM) EC2 nodes (1 and then 2 nodes).

Generating data (200 million doubles, 1.5GB):
```
dx <- h2o.createFrame(srvx, key = "sweep.hex", 
    rows = 2e8, cols = 1, missing_fraction = 0,
    categorical_fraction = 0, binary_fraction = 0, integer_fraction = 0)
```

Sweeping:
```
sum(dx$C1)
```

Running on 1 and 2 nodes, increasing number of cores:
```
taskset -c 1,2,3,4 java -Xmx25g -jar h2o-2.8.4.4/h2o.jar 
```

Run times:
nodes | cores | time(sec)
----- | ----- | --------
1     |   1   | 5.51
1     |   2   | 2.89
1     |   4   | 1.65
1     |   8   | 1.24
1     |  16   | 1.29
----- | ----- | -------
2     |   2   | 3.49
2     |   4   | 2.19
2     |   8   | 1.14
2     |  16   | 1.00
2     |  32   | 0.84


In contrast, in base R:
```
x <- runif(2e8)
sum(x)
```
it takes 0.23 sec.




