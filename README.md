# Optimized solutions for Advent of Code 2020

This repository contains optimized solutions written in Julia for the [Advent of Code 2020](https://adventofcode.com/2020) coding challenge.
I wrote these in early 2021 and then forgot to upload them here.
They make use of vectorization using [SIMD.jl](https://github.com/eschnett/SIMD.jl), a little bit of LLVM code, and an (unsafe) custom IO buffer.
Some of these solutions draw inspiration from [Voltara's optimized C++ solutions](https://github.com/Voltara/advent2020-fast).

My original (unoptimized) solutions have been moved to the [`original` branch](https://github.com/dsiem/aoc2020/tree/original).


## Benchmarks

Here are benchmark results obtained via [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) on an i7-11850H @ 2.50GHz:

### Day 1
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  2.793 μs …  11.893 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     3.060 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   3.352 μs ± 554.455 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

     ▃▆█▂
  ▂▃▆█████▃▂▂▂▂▁▂▁▂▂▃▄▅███▇▅▄▄▃▃▂▂▃▂▂▂▂▂▂▃▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂ ▃
  2.79 μs         Histogram: frequency by time        4.99 μs <

 Memory estimate: 1.80 KiB, allocs estimate: 2.
```

### Day 2
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  7.657 μs …  19.132 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     8.243 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   8.272 μs ± 216.196 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                               ▁▅█▇▃
  ▂▂▂▂▂▂▂▂▂▂▁▂▁▁▂▂▁▂▂▂▂▃▃▃▃▃▃▃▅█████▇▄▃▂▃▄▅▆▆▆▄▃▂▂▂▂▂▂▂▂▂▂▂▂▂ ▃
  7.66 μs         Histogram: frequency by time        8.73 μs <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 3
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  2.144 μs …  15.035 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     2.384 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   2.654 μs ± 606.841 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

      ▅██▁
  ▂▃▄▄████▄▂▂▂▁▂▁▁▁▂▂▂▂▃▃▄▆▇▆▅▄▃▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂ ▃
  2.14 μs         Histogram: frequency by time         4.3 μs <

 Memory estimate: 1.36 KiB, allocs estimate: 2.
```

### Day 4
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  8.547 μs …  30.402 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     9.131 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   9.092 μs ± 306.306 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                       ▁         ▃▇█▃
  ▂▂▂▂▂▂▁▁▂▂▂▂▃▂▂▂▁▂▂▄▆██▇▄▃▂▂▂▃▆████▇▄▃▂▂▂▂▂▂▁▂▂▂▂▂▂▁▁▂▁▂▂▂▂ ▃
  8.55 μs         Histogram: frequency by time        9.62 μs <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 5
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  1.584 μs …  14.900 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.765 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.763 μs ± 187.919 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                                   ▅█▄▁   ▁  ▂▁▁   ▁
  ▁▃▃▃▂▁▂▂▂▂▂▂▁▁▁▁▁▁▂▂▁▁▁▂▂▃▃▃▂▂▂▄▆████▅▅██▇████▆▄▇█▆▄▃▂▁▂▁▁▁ ▃
  1.58 μs         Histogram: frequency by time        1.86 μs <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 6
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  7.038 μs …  23.354 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     7.665 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   7.703 μs ± 265.552 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                                 ▃▇█▄
  ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▃▂▂▂▂▂▂▁▂▂▂▃▅█████▅▄▄▃▄▅▇▆▆▅▄▃▃▂▂▂▂▁▂▂▂▂▂ ▃
  7.04 μs         Histogram: frequency by time        8.11 μs <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 7
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  21.056 μs … 846.072 μs  ┊ GC (min … max): 0.00% … 86.41%
 Time  (median):     22.502 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   24.256 μs ±  29.792 μs  ┊ GC (mean ± σ):  6.29% ±  4.93%

             ▁▁▂▃▅▄▅▅▆▅▇██▇▇▄▄▃▂
  ▁▁▁▁▂▃▄▄▅██████████████████████▇▆▆▅▄▄▄▃▃▂▃▂▂▃▂▂▂▂▂▂▂▂▂▂▂▂▁▁▁ ▄
  21.1 μs         Histogram: frequency by time         24.9 μs <

 Memory estimate: 146.64 KiB, allocs estimate: 7.
```

### Day 8
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  2.743 μs …  1.013 ms  ┊ GC (min … max):  0.00% … 94.96%
 Time  (median):     2.989 μs              ┊ GC (median):     0.00%
 Time  (mean ± σ):   3.502 μs ± 17.649 μs  ┊ GC (mean ± σ):  11.57% ±  2.33%

     ▃▅▇█▅▇▄▂▁
  ▂▃▇██████████▇▆▅▅▄▄▄▃▂▂▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ ▃
  2.74 μs        Histogram: frequency by time        4.41 μs <

 Memory estimate: 28.92 KiB, allocs estimate: 5.
```

### Day 9
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  36.017 μs …  1.267 ms  ┊ GC (min … max): 0.00% … 96.96%
 Time  (median):     37.345 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   37.508 μs ± 12.510 μs  ┊ GC (mean ± σ):  0.33% ±  0.97%

            ▁▃▃▅▅█▇▇▇▅▃▂▃▂▁▄▄▄▅█▆▇▇▇▆▃▅▃▁
  ▁▁▁▁▂▃▄▄▆▇██████████████████████████████▇▅▅▃▃▃▂▃▂▂▂▂▂▂▂▂▁▁▂ ▅
  36 μs           Histogram: frequency by time          39 μs <

 Memory estimate: 7.97 KiB, allocs estimate: 2.
```

### Day 10
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  687.000 ns …   9.184 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     790.000 ns               ┊ GC (median):    0.00%
 Time  (mean ± σ):     1.051 μs ± 445.174 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

  ▅▇█▇▅▁             ▁▄▆▆▅▄▄▄▂     ▁      ▁                     ▂
  ██████▇▅▃▃▃▁▄▃▄▁▄▃▆█████████▇▆▅▇███▇▄▅▆██████▆▅▄▄▃▄▄▆▅▆▆▆▆▅▅▆ █
  687 ns        Histogram: log(frequency) by time       2.68 μs <

 Memory estimate: 1.48 KiB, allocs estimate: 2.
```

### Day 11
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  144.008 μs …  1.255 ms  ┊ GC (min … max): 0.00% … 77.79%
 Time  (median):     152.950 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   155.114 μs ± 25.717 μs  ┊ GC (mean ± σ):  0.44% ±  2.36%

               ▁█▂   ▄▂
  ▂▄▇▆▃▃▃▅▅▃▂▁▂███▄▃▅██▄▂▂▁▁▂▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▂▂▂▂▂▁▁▁▁ ▂
  144 μs          Histogram: frequency by time          180 μs <

 Memory estimate: 52.41 KiB, allocs estimate: 7.
```

### Day 12
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  1.650 μs …  12.782 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     1.830 μs               ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.825 μs ± 160.684 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                                    ▆▄▅▂     ▅█▆▁
  ▂▂▄▄▃▂▂▂▁▁▁▁▁▁▁▁▃▄▆▅▅▃▂▂▂▂▃▃▃▂▂▂▃▇████▆▄▃▄█████▆▄▃▂▂▂▁▁▁▁▁▁ ▃
  1.65 μs         Histogram: frequency by time        1.94 μs <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 13
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  230.000 ns …  3.811 μs  ┊ GC (min … max): 0.00% … 0.00%
 Time  (median):     258.000 ns              ┊ GC (median):    0.00%
 Time  (mean ± σ):   258.309 ns ± 44.188 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

                     ▆▃▃▂▂█ ▂▁▁█
  ▂▃▄▅▇▃▄▄▅▇▄▅▄▅█▆▆▆▆███████████▇▆▆▆▇▃▃▃▃▄▂▂▂▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁ ▃
  230 ns          Histogram: frequency by time          302 ns <

 Memory estimate: 32 bytes, allocs estimate: 1.
```

### Day 14
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  1.347 ms …   2.611 ms  ┊ GC (min … max): 0.00% … 31.88%
 Time  (median):     1.394 ms               ┊ GC (median):    0.00%
 Time  (mean ± σ):   1.430 ms ± 172.213 μs  ┊ GC (mean ± σ):  2.30% ±  6.82%

  ▃▆▇█▆▃                                                  ▁▂▃ ▂
  ███████▅▅▃▆▄▄▁▁▁▁▁▁▃▁▃▅▇▄▃▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▄▇███ █
  1.35 ms      Histogram: log(frequency) by time      2.21 ms <

 Memory estimate: 1.99 MiB, allocs estimate: 62.
```

### Day 15
```
BenchmarkTools.Trial: 696 samples with 1 evaluation.
 Range (min … max):  141.467 ms … 202.668 ms  ┊ GC (min … max): 0.29% … 28.64%
 Time  (median):     143.449 ms               ┊ GC (median):    2.02%
 Time  (mean ± σ):   143.674 ms ±   3.121 ms  ┊ GC (mean ± σ):  2.13% ±  1.36%

                           ▄▁▄▆▄█▇▇█▅▃▁▇▄▁▂
  ▂▁▁▁▂▁▁▃▂▃▁▄▂▂▄▃▃▁▄▄▄▅▇▆▇████████████████▆▄▅▄▄▄▄▃▃▃▄▃▃▃▃▂▁▁▁▂ ▄
  141 ms           Histogram: frequency by time          145 ms <

 Memory estimate: 118.02 MiB, allocs estimate: 6.
```

### Day 16
```
BenchmarkTools.Trial: 10000 samples with 1 evaluation.
 Range (min … max):  14.348 μs …  1.827 ms  ┊ GC (min … max): 0.00% … 98.64%
 Time  (median):     15.712 μs              ┊ GC (median):    0.00%
 Time  (mean ± σ):   16.055 μs ± 18.257 μs  ┊ GC (mean ± σ):  1.12% ±  0.99%

               ▁▃▃▄▆███▇▇▅▅▃▂▁
  ▁▁▁▁▁▂▂▂▂▄▅▆▇█████████████████▇▆▆▅▅▅▅▅▄▄▄▃▃▃▃▂▂▂▂▂▂▁▁▁▁▁▁▁▁ ▄
  14.3 μs         Histogram: frequency by time        17.9 μs <

 Memory estimate: 4.91 KiB, allocs estimate: 7.
```
