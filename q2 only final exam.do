
clear all

* import q2 data
use "C:\Users\johnn\OneDrive\Desktop\q2 (5).dta"

	
* Summarize standard deviation of daily returns
summarize rtsla ramzn rwmt

* Estimate 1% one-day VaR using normal distribution
scalar VaR_amzn = invnormal(0.01) * r(sd) * 25000
display "1% Daily VaR for $25,000 in Amazon = $" VaR_amzn

** PART 2C
* Estimate GARCH(1,1) model
arch ramzn, arch(1) garch(1)

* Predict conditional variance
predict garch_variance_amzn, variance

* Convert variance to standard deviation
gen garch_sd_amzn = sqrt(garch_variance_amzn)

* Plot the conditional standard deviation
tsline garch_sd_amzn, name("amazon_volatility", replace) ///
    title("Predicted Volatility from GARCH(1,1) - Amazon") ///
    ytitle("Conditional Standard Deviation") xtitle("Time")


** PART 2D
* Compute the average of the predicted standard deviations
summarize garch_sd_amzn

* Use the mean predicted standard deviation to compute 1% VaR
scalar VaR_garch_amzn = invnormal(0.01) * r(mean) * 25000
display "1% Daily VaR for $25,000 in Amazon (GARCH) = $" VaR_garch_amzn

** PART 2E
* Estimate multivariate GARCH model
mgarch ccc (rtsla = L.rtsla) ramzn rwmt, arch(1) garch(1)

* Predict conditional variances
predict h*, variance

* Convert variances to standard deviations for each asset
gen sd_rtsla = sqrt(h_rtsla_rtsla)
gen sd_ramzn = sqrt(h_ramzn_ramzn)
gen sd_rwmt  = sqrt(h_rwmt_rwmt)

* FIX: summarize Tesla SD before assigning scalar
summarize sd_rtsla
scalar mean_sd_rtsla = r(mean)

* summarize other assets
summarize sd_ramzn
scalar mean_sd_ramzn = r(mean)

summarize sd_rwmt
scalar mean_sd_rwmt = r(mean)

* Compute 1% daily VaR for 1/3 of $25,000 investment in each stock
scalar VaR_rtsla = invnormal(0.01) * mean_sd_rtsla * (25000*(1/3))
scalar VaR_ramzn = invnormal(0.01) * mean_sd_ramzn * (25000*(1/3))
scalar VaR_rwmt  = invnormal(0.01) * mean_sd_rwmt  * (25000*(1/3))

* Display results
display "1% Daily VaR for 1/3 of $25,000 in Tesla  = $" VaR_rtsla
display "1% Daily VaR for 1/3 of $25,000 in Amazon = $" VaR_ramzn
display "1% Daily VaR for 1/3 of $25,000 in Walmart = $" VaR_rwmt




































