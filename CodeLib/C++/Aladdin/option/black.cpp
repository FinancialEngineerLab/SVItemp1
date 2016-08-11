#include <cmath>
#include <stdexcept>
#include "MathCalc.h"
#include "normal.h"
#include "black.h"
#include "Aladdin\xll\utility\ensure.h"



	inline double
	d2(double f, double sigma, double k, double t)
	{
		ensure (f > 0);
		ensure (sigma > 0);
		ensure (t > 0);
		ensure (k != 0);

		double srt = sigma*sqrt(t);

		return log(f/fabs(k))/srt - srt/2;
	}

	inline double
	d1(double f, double sigma, double k, double t)
	{
		ensure (f > 0);
		ensure (sigma > 0);
		ensure (t > 0);
		ensure (k != 0);

		double srt = sigma*sqrt(t);

		return log(f/fabs(k))/srt + srt/2;
	}

	inline double
	Nd1(double f, double sigma, double k, double t)
	{
		return normal_cdf<ooura>(d1(f, sigma, k, t));
	}

	inline double
	Nd2(double f, double sigma, double k, double t)
	{
		return normal_cdf<ooura>(d2(f, sigma, k, t));
	}


	// Black call/put option price and greeks.
	// !!!Note this *increments* the pointer values!!! Handy for portfolios.
	inline double
	black(double f, double sigma, double k, double t, double* df = 0, double* ddf = 0, double* ds = 0, double* dt = 0)
	{
		ensure (f >= 0);
		ensure (sigma >= 0);
		ensure (t >= 0);

		double c = 1;
		// negative strike means put
		if (k < 0) {
			c = -1;
			k = -k;
		}

		// boundary cases
		if (f == 0 || sigma == 0 || t == 0) {
			if (df) *df += 1.*(c*f > c*k);
			if (ddf) *ddf += 0; // really delta function at k

			return c*f > c*k ? c*(f - k) : 0;
		}

		if (k == 0) {
			if (df) *df += 1;

			return f;
		}

		double srt = sigma*sqrt(t);
		double d2 = log(f/k)/srt - srt/2;
		double d1 = d2 + srt;
		double Nd1 = normal_cdf<ooura>(c*d1);
		double Nd2 = normal_cdf<ooura>(c*d2);
		double nd1(0);

		if (ddf || ds || dt)
			nd1 = normal_pdf(d1);

		if (df)
			*df += c*Nd1;

		if (ddf)
			*ddf += nd1/(f*srt);

		if (ds)
			*ds += f*srt*nd1/sigma;

		if (dt)
			*dt += -f*srt*nd1/(2*t); // negative of dv/dt

		return c*(f*Nd1 - k*Nd2);
	}

	inline double
	value(double f, double sigma, double k, double t)
	{
		return black(f, sigma, k, t);
	}
	inline double
	delta(double f, double sigma, double k, double t)
	{
		double v(0);

		black(f, sigma, k, t, &v);

		return v;
	}
	inline double
	gamma(double f, double sigma, double k, double t)
	{
		double v(0);

		black(f, sigma, k, t, 0, &v);

		return v;
	}
	inline double
	vega(double f, double sigma, double k, double t)
	{
		double v(0);

		black(f, sigma, k, t, 0, 0, &v);

		return v;
	} 
	inline double
	theta(double f, double sigma, double k, double t)
	{
		double v(0);

		black(f, sigma, k, t, 0, 0, 0, &v);

		return v;
	} 

	inline double
	implied_volatility(double f, double p, double k, double t, double s0, double eps, int max_iteration_count)
	{
		double c = 1, s1, p1;
		
//		eps *= p;
		ensure (eps != 0);

		if (k < 0) {
			c = -1;
			k = -k;
		}

		// ensure price in 0 - infty vol range
		ensure (t > 0);
		ensure (p > __max(c*(f - k),0.));
		ensure ((c == 1 && p < f) || (c == -1 && p < k));

		double p0 = black(f, s0, c*k, t) - p;

		// lucky guess
		if (fabs(p0) < eps)
			return s0;

		// bracket the root
		double m = 1.4;
		if (p0 > 0) {
			s1 = s0/m;
			p1 = black(f, s1, c*k, t) - p;
			while (p1 > 0) {
				s0 = s1;
				p0 = p1;
				s1 = s0/m;
				p1 = black(f, s1, c*k, t) - p;
			}
		}
		else {
			s1 = s0*m;
			p1 = black(f, s1, c*k, t) - p;
			while (p1 < 0) {
				s0 = s1;
				p0 = p1;
				s1 = s0*m;
				p1 = black(f, s1, c*k, t) - p;
			}
		}

		if (fabs(p1) < eps)
			return s1;

		ensure (p0*p1 < 0);

		// polish
		double ds = 0;
		double s2 = s0 - p0*(s1 - s0)/(p1 - p0);
		double p2 = black(f, s2, c*k, t, 0, 0, &ds) - p;

		// if sigma is too small use bisection
		if (ds < 1e-4) {
			while (fabs(p2) > eps) {
				if (p0*p2 < 0) {
					s1 = s2;
				}
				else {
					ensure (p1*p2 < 0);
					s0 = s2;
				}
				s2 = (s1 + s0)/2;
				p2 = black(f, s2, c*k, t) - p;
			}

			return s2;
		}

		// Newton-Raphson
		s0 = s2;
		p0 = p2;
		for (int i = 0; fabs(p0) > eps; ++i) {
			ensure (i < max_iteration_count);
			ensure (ds != 0);
			
			s1 = s0 - p0/ds;
			if (s1 < 0)
				s1 = s0/2;
			ds = 0;
			s0 = s1;
			p0 = black(f, s0, c*k, t, 0, 0, &ds) - p;
		}

		return s0;
	}

	inline double
	implied_volatility(double f, double p, double k, double t)
	{
		return implied_volatility(f, p, k, t, 0.2, 1e-10, 100);
	}

	inline double
	implied_forward(double v, double sigma, double k, double t, double f0, double eps, int max_iteration_count, double thresh)
	{
		double f1, p1;
		
		ensure (v/fabs(k) > thresh);
		ensure (k != 0);
		ensure (sigma > 0);
		ensure (eps != 0);
		ensure (k > 0 || v < -k);

		double p0 = black(f0, sigma, k, t) - v;

		// lucky guess
		if (fabs(p0) < eps)
			return f0;

		// bracket the root
		double m = 1.4;
		if (p0 > 0) {
			f1 = f0/m;
			p1 = black(f1, sigma, k, t) - v;
			while (p1 > 0) {
				ensure (--max_iteration_count);
				f0 = f1;
				p0 = p1;
				f1 = f0/m;
				p1 = black(f1, sigma, k, t) - v;
			}
		}
		else {
			f1 = f0*m;
			p1 = black(f1, sigma, k, t) - v;
			while (p1 < 0) {
				ensure (--max_iteration_count);
				f0 = f1;
				p0 = p1;
				f1 = f0*m;
				p1 = black(f1, sigma, k, t) - v;
			}
		}

		if (fabs(p1) < eps)
			return f1;

		ensure (p0*p1 < 0);

		// polish
		double df = 0;
		double f2 = f0 - p0*(f1 - f0)/(p1 - p0);
		double p2 = black(f2, sigma, k, t, &df) - v;

		// if delta is too small use bisection
		if (df < 1e-4) {
			while (fabs(p2) > eps) {
				ensure (--max_iteration_count);
				if (p0*p2 < 0) {
					f1 = f2;
				}
				else {
					ensure (p1*p2 < 0);
					f0 = f2;
				}
				f2 = (f1 + f0)/2;
				p2 = black(f2, sigma, k, t) - v;
			}

			return f2;
		}

		// Newton-Raphson
		f0 = f2;
		p0 = p2;
		while (fabs(p0) > eps) {
			ensure (--max_iteration_count);
			ensure (df != 0);
			
			f1 = f0 - p0/df;
			if (f1 < 0)
				f1 = f0/2;
			df = 0;
			f0 = f1;
			p0 = black(f0, sigma, k, t, &df) - v;
		}

		return f0;
	}
	inline double
	implied_forward(double v, double sigma, double k, double t)
	{
		return implied_forward(v, sigma, k, t, fabs(k), 1e-10, 100, 1e-5);
	}

	// stochastic volatility inspired
	inline double gatheral_svi(double a, double b, double sigma, double rho, double m, double k)
	{
		return a + b*(rho*(k - m) + sqrt((k - m)*(k - m) + sigma*sigma));
	}




		void ensure_option_positive_params(double s,       // spot (underlying) price
										   double k,       // strike (exercise) price,
										   double r,       // interest rate
										   double sigma,   // volatility 
										   double time)    // time to maturity 
	{
		ensure(s>=0);
		ensure(k>=0);
		ensure(r>=0);
		ensure(sigma>=0);
		ensure(time>=0);

	}

	double option_price_call_black_scholes(double s,       // spot (underlying) price
										   double k,       // strike (exercise) price,
										   double r,       // interest rate
										   double sigma,   // volatility 
										   double time)    // time to maturity 
	{  
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
		d2 = d1-(sigma*time_sqrt);
		
		return s*normal_cdf(d1) - k*exp(-r*time)*normal_cdf(d2);
	}

	double option_price_put_black_scholes(double s,       // spot (underlying) price
										   double k,       // strike (exercise) price,
										   double r,       // interest rate
										   double sigma,   // volatility 
										   double time)    // time to maturity 
	{
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
		d2 = d1-(sigma*time_sqrt);

		return k*exp(-r*time)*normal_cdf(-d2) - s*normal_cdf(-d1);
	}


	double option_price_delta_call_black_scholes(double s,       // spot (underlying) price
											   double k,       // strike (exercise) price,
											   double r,       // interest rate
											   double sigma,   // volatility 
											   double time)    // time to maturity 
	{
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
		
		return normal_cdf(d1);
	}

	double option_price_delta_put_black_scholes(double s,       // spot (underlying) price
											   double k,       // strike (exercise) price,
											   double r,       // interest rate
											   double sigma,   // volatility 
											   double time)    // time to maturity 
	{
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
		
		return -normal_cdf(-d1);
	}

	void option_price_partials_call_black_scholes( double s,       // spot (underlying) price
												   double k,       // strike (exercise) price,
												   double r,       // interest rate
												   double sigma,   // volatility 
												   double time,  // time to maturity
												   double& Delta, //  partial wrt S
												   double& Gamma, //  second prt wrt S
												   double& Theta, // partial wrt time
												   double& Vega,  //  partial wrt sigma
												   double& Rho)   // partial wrt r
	{   
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
	
		Delta = normal_cdf(d1);
		Gamma = normal_pdf(d1)/(s*sigma*time_sqrt);
		Theta = -(s*sigma*normal_pdf(d1))/(2*time_sqrt) - r*k*exp( -r*time)*normal_cdf(d2);
		Vega  = s * time_sqrt*normal_pdf(d1);
		Rho   = k*time*exp(-r*time)*normal_cdf(d2);
	}

		void option_price_partials_put_black_scholes( double s,       // spot (underlying) price
													   double k,       // strike (exercise) price,
													   double r,       // interest rate
													   double sigma,   // volatility 
													   double time,  // time to maturity
													   double& Delta, //  partial wrt S
													   double& Gamma, //  second prt wrt S
													   double& Theta, // partial wrt time
													   double& Vega,  //  partial wrt sigma
													   double& Rho)   // partial wrt r
	{   
		double time_sqrt = 0;
		double d1 = 0;
		double d2 = 0;

		ensure_option_positive_params(s,k,r,sigma,time);

		time_sqrt = sqrt(time);
		d1 = (log(s/k)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt; 
	
		Delta = -normal_cdf(-d1);
		Gamma = normal_pdf(d1)/(s*sigma*time_sqrt);
		Theta = -(s*sigma*normal_pdf(d1))/(2*time_sqrt) + r*k*exp( -r*time)*normal_cdf(-d2);
		Vega  = s * time_sqrt*normal_pdf(d1);
		Rho   = -k*time*exp(-r*time)*normal_cdf(-d2);
	}

	double option_price_black_scholes(double s,       // spot (underlying) price
									double k,       // strike (exercise) price,
									double r,       // interest rate
									double sigma,   // volatility 
									double time,     // time to maturity 
									int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionPrice = 0;

		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			dOptionPrice = option_price_call_black_scholes(s,k,r,sigma,time);
		else
			dOptionPrice = option_price_put_black_scholes(s,k,r,sigma,time);
		return dOptionPrice;
	}

	double option_delta_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionDelta = 0;
		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			dOptionDelta = option_price_delta_call_black_scholes(s,k,r,sigma,time);
		else
			dOptionDelta = option_price_delta_put_black_scholes(s,k,r,sigma,time);
		return dOptionDelta;
	}

	double option_gamma_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionDelta = 0;
		double dOptionGamma = 0;
		double dOptionTheta = 0;
		double dOptionVega = 0;
		double dOptionRho = 0;
		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			option_price_partials_call_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		else
			option_price_partials_put_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		return dOptionGamma;
	}

	double option_theta_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionDelta = 0;
		double dOptionGamma = 0;
		double dOptionTheta = 0;
		double dOptionVega = 0;
		double dOptionRho = 0;
		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			option_price_partials_call_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		else
			option_price_partials_put_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		return dOptionTheta;
	}

	double option_vega_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionDelta = 0;
		double dOptionGamma = 0;
		double dOptionTheta = 0;
		double dOptionVega = 0;
		double dOptionRho = 0;
		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			option_price_partials_call_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		else
			option_price_partials_put_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		return dOptionVega;
	}

	double option_rho_black_scholes(double s,       // spot (underlying) price
										double k,       // strike (exercise) price,
										double r,       // interest rate
										double sigma,   // volatility 
										double time,     // time to maturity 
										int iCallOrPut)  // 1: call, 0 : put  
	{
		double dOptionDelta = 0;
		double dOptionGamma = 0;
		double dOptionTheta = 0;
		double dOptionVega = 0;
		double dOptionRho = 0;
		ensure_option_positive_params(s,k,r,sigma,time);
		ensure((iCallOrPut==1)||(iCallOrPut==0));

		if(iCallOrPut == 1) 
			option_price_partials_call_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		else
			option_price_partials_put_black_scholes(s,k,r,sigma,time,dOptionDelta,dOptionGamma, dOptionTheta, dOptionVega,dOptionRho);
		return dOptionRho;
	}

	//********************************************************************************************************//
	// Implied volatility 
	double option_price_implied_volatility_black_scholes_newton(double s,
																double k, 
																double r,
																double time,
																double option_price,
																int    iCallOrPut) 
	{
			//ensure_option_positive_params(s,k,r,1.0,time);
			

			int MAX_ITERATIONS = 100;
			double ACCURACY    = 1.0e-5; 
			double price = 0;
			double diff = 0;
			double t_sqrt = 0;
			double sigma = 0;
			double d1 = 0;
			double vega = 0;
			
			if (option_price<0.99*(s-k*exp(-time*r))) {  // check for arbitrage violations. Option price is too low if this happens
				return 0.0;
			};

			t_sqrt = sqrt(time);
			sigma = (option_price/s)/(0.398*t_sqrt);    // find initial value
			
			for (int i = 0;i < MAX_ITERATIONS;i++){
				price = option_price_black_scholes(s,k,r,sigma,time,iCallOrPut);
				diff = option_price -price;
				if (fabs(diff)<ACCURACY) 
					return sigma;
				//d1 = (log(s/k)+r*time)/(sigma*t_sqrt) + 0.5*sigma*t_sqrt; 
				//vega = s * t_sqrt * normal_pdf(d1);
				vega = option_vega_black_scholes(s,k,r,sigma,time,iCallOrPut);
				sigma = sigma + diff/vega;
			};

			throw std::runtime_error("Error: implied vol iteration does not coverge");  // something screwy happened, should throw exception
	};


	double option_price_implied_volatility_black_scholes_bisect(double s,
																double k, 
																double r,
																double time,
																double option_price,
																int    iCallOrPut) 
	{
			//ensure_option_positive_params(s,k,r,1.0,time);
			

			int MAX_ITERATIONS = 1000;
			double ACCURACY    = 1.0e-15; 
			double HIGH_VALUE = 1e10;
			double price = 0;
			double t_sqrt = 0;
			double test = 0;
			double sigma = 0;
			double sigma_low=1e-5;
			double sigma_high=0.3;
			
			if (option_price<0.99*(s-k*exp(-time*r)) &&(iCallOrPut == 1)) {  // check for arbitrage violations. Option price is too low if this happens
				return 0.0;
			};
			if (option_price<0.99*(k*exp(-time*r)-s) &&(iCallOrPut == 0)) {  // check for arbitrage violations. Option price is too low if this happens
				return 0.0;
			};

			
			// want to bracket sigma. first find a maximum sigma by finding a sigma
			// with a estimated price higher than the actual price.
			price = option_price_black_scholes(s,k,r,sigma_high,time,iCallOrPut);
			
			while (price < option_price) {  
				sigma_high = 2.0 * sigma_high; // keep doubling.
				price = option_price_black_scholes(s,k,r,sigma_high,time,iCallOrPut);
				if (sigma_high>HIGH_VALUE) 
					goto ERR; // panic, something wrong.
			};
			for (int i=0;i<MAX_ITERATIONS;i++){
				sigma = (sigma_low+sigma_high)*0.5;
				price = option_price_black_scholes(s,k,r,sigma,time,iCallOrPut);
				test =  (price-option_price);
				if (fabs(test)<ACCURACY) { return sigma; };
				if (test < 0.0) { sigma_low = sigma; }
				else 
				{ sigma_high = sigma; }
			};

ERR:
			throw std::runtime_error("Error: implied vol iteration does not coverge");  // something screwy happened, should throw exception
	};



	double option_price_implied_volatility_steven_formula(double s,
														double k, 
														double r,
														double time,
														double option_price) 
	{
		double rho = 0;
		double eta = 0;
		double K = 0;
		double alpha = 0;
		double zeta = 0;
		double sigma = 0;
		double x = 0;
		
		//ensure_option_positive_params(s,k,r,1.0,time);

		K = k*exp(-r*time);
		eta = K/s;
		rho = abs(eta - 1)/((option_price/s)*(option_price/s));
		alpha = sqrt(2*M_PI)/(1+eta)*(2*option_price/s + eta - 1);
		zeta = cos(1.0/3.0*acos(3*alpha/sqrt(32.0)));

		if( rho <= 0.4)
		{
			sigma = 2*sqrt(2.0)/sqrt(time)*zeta - 1/sqrt(time)*sqrt(8*zeta*zeta - 6*alpha/(sqrt(2.0)*zeta));
		}
		else
		{
			x = alpha *alpha - 4*(eta - 1)*(eta-1)/(1+eta);
			sigma = alpha+sqrt(alpha*alpha - x);
			sigma = sigma /(2*sqrt(time));
		}
		return sigma;

	}

	double option_implied_volatility(double s,
									double k, 
									double r,
									double time,
									double option_price,
									int    iCallOrPut,
									int    iMode)
	{
		ensure((iMode == 1)||(iMode ==2));

		if(iMode == 1)
			return option_price_implied_volatility_black_scholes_bisect(s,k,r,time,option_price,iCallOrPut);
		else
			return option_price_implied_volatility_steven_formula(s,k,r,time,option_price);
	}
	

	

	
