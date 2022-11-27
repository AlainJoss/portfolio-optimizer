# Portfolio Optimisation with Spectral Measures

This repository contains an implementation of the portfolio optimisation model proposed in the paper, which I did for a friend.

The implementation takes O(n2) time to compute, which makes it not really appealing for larger problems. It turns out that there is another way to optimise non-linear objective functions of the form max(0, f(x)) that requires only O(n) computational time. Unfortunately, I discovered it way after writing this script, but this is an integral part of the learning process. The way around this inconvenience is explained below.

Since the linearisation of the objective function makes the matrix of constraints grow exponentially,
the selected time series should satisfy the following condition: n <= 150, 
so that the R implementation can be executed without memory problems.
