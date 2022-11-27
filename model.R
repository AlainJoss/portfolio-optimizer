# portfolio optimization with spectral measures

### LOAD ###

library("lpSolve")

timeseries <- read.csv("risk_function_and_returns.csv")

phi <- timeseries %>% select(phi)
r <- timeseries %>% select(-phi)

# USERINPUT: define number of points in time
n <- as.integer(readline(prompt="Enter end of time series: "))

# needed indices
m <- 7 # number of different shares
rows <- 2+n*(n-1)*2
cols <- m+n-1+n*(n-1)

### PREPARE CONSTRAINTS ###

# calculate delta_phi
delta_phi <- rep(0, n-1)
for (i in 1:(n-1))
  delta_phi[i] <- phi[i+1,]-phi[i,]

# calculate sum_r and av_r
sum_r <- rep(0, m)
av_r <- rep(0, m)
for (i in 1:m) {
  sum_r[i] <- sum(r)
  av_r[i] <- mean(r[, i])
}

# array of signs for objective function
signs <- c(rep(-1, m), rep(1, n-1), rep(-1, n*(n-1)))

# calculate phis for objective function
phis <- rep(0, cols)
for (i in 1:m) 
  phis[i] <- phi[n,]
for (i in 1:(n-1)) 
  phis[i+m] <- delta_phi[i]
for (i in 1:(n-1)) {
  for (j in 1:n) {
    phis[j+m+(n-1)+(i-1)*n] <- delta_phi[i]
  }
}

# varius elements needed for objective function
varius <- rep(0, cols)
for (i in 1:m) 
  varius[i] <- sum_r[i]
for (i in 1:(n-1)) 
  varius[i+m] <- i
for (i in 1:(n*(n-1))) {
  varius[i+m+(n-1)] <- 1
}

# calculate coefficients of objective function
coeff <- rep(0, cols)
for (i in 1:cols)
  coeff[i] <- signs[i]*phis[i]*varius[i]

# build constraints matrix
constr_mat <- matrix(0, rows, cols) 

for (i in 1:m) { # weights and requested return for st_0
    constr_mat[1,i] <- 1
    constr_mat[2,i] <- av_r[i]
}

for (i in 1:m) { # fill weights columns for st_1
  for (l in 1:(n-1)){
     for (j in 1:n) {
      constr_mat[2+j+(l-1)*n,i] <- r[j,i]
    }
  }
}

for (i in (m+1):(m+n-1)) { # fill phi columns for st_1
  for (l in 1:(n-1)) {
    for (j in 1:n) {
      if (i-m == l) {
        constr_mat[2+j+(l-1)*n,i] <- -1
      } 
    }
  }
}

for (i in (m+n-1+1):cols) { # fill z columns for st_1
  for (j in 1:((rows-2)/2)) {
    if (i-(m+n-1) == j) {
      constr_mat[2+j,i] <- 1
    } 
  }
}

for (i in (m+n-1+1):cols) { # fill z columns for st_2
  for (j in ((rows-2)/2+1):(rows-2)) {
    if (i-(m+n-1) == j-((rows-2)/2)) {
      constr_mat[2+j,i] <- 1
    } 
  }
}

### PREPARE OBJECTIVE FUNCTION ###

# constraints' directions
constr_dir <- c(rep("=", 2), rep(">=", rows-2))

# USERINPUT: define the requested return
min_r <- as.character(round(min(av_r),5))
max_r <- as.character(round(max(av_r),5))
req_r <- as.double(readline(prompt=paste("Enter required return (between", min_r, "and", max_r, "):")))

# constraints' rhs
constr_rhs <- c(1, req_r, rep(0, rows-2))

### COMPUTE OPTIMUM ###

# calculate optimum
optimum <- lp(direction="min", coeff, constr_mat,
              constr_dir, constr_rhs)

### PRINT PARAMETERS AND OPTIMUM ###

# print optimum
print("Risk:")
print(optimum) # for displysing the minimal risk

x <- optimum$solution # for displaying the portfolio weights
print("Portfolio weights:")
print(x[1:7])