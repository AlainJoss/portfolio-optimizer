# Portfolio Optimisation with Spectral Measures

The repository contains two implementations of the portfolio optimisation model proposed in the paper, 
one in Excel and one in R.
The R implementation reads the raw data from its corresponding Excel file
and calculates the optimal portfolio weights according to the model. 
The Excel implementation is a scaled-down version of the model that allows to visualise its appearance (congruent to R)
and to verify the correctness of the implementation in R.

As the linearisation of the function to be optimised makes the matrix of constraints grow exponentially,
the selected time series should fulfil the following condition: n <= 150, 
so that the R implementation can run without experiencing memory issues.

