# Portfolio optimisation with spectral measures

This repository contains an implementation of the portfolio optimisation model proposed in the paper (Acerbi 2002) that I wrote for a friend.

The implementation takes O(n2) time to run, which makes it unappealing for larger problems. It turns out that there is an efficient way to implement the model that requires only O(n) computational time. Unfortunately, I only discovered this after I had written this script, but that is just part of the learning journey. 

Since the objective function contains a term of the form max(0, f(x)), the model is not in linear form. 
The inefficient way to optimise the objective function is to introduce a new variable in place of the term and add two new constraints. In this way, it is possible to optimise the objective function using the simplex algorithm (linear programming). However, the complexity of the model grows exponentially, making any implementation completely useless.
The efficient way to optimise the objective function is to perform gradient descent by taking partial gradients of the function. 

Since I have chosen the first option, when the script is run, the user is asked to choose the end of the time series, which must meet the following condition: n <= 150, so that a normal computer can run the script without memory problems.
