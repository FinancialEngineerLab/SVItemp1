// black.h - Fischer Black model that uses forwards and no rates.
// Copyright (c) 2006-2009 KALX, LLC. All rights reserved. No warranty is made.
#pragma once


double option_price_black_scholes(double s,       // spot (underlying) price
									double k,       // strike (exercise) price,
									double r,       // interest rate
									double sigma,   // volatility 
									double time,     // time to maturity 
									int iCallOrPut);  // 1: call, 0 : put  


double option_delta_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut);  // 1: call, 0 : put  


double option_gamma_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut); // 1: call, 0 : put  


double option_theta_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut);  // 1: call, 0 : put  


double option_vega_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut);  // 1: call, 0 : put  

double option_rho_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut);  // 1: call, 0 : put  

double option_implied_volatility(double s,
									double k, 
									double r,
									double time,
									double option_price,
									int    iCallOrPut,
									int    iMode);
	