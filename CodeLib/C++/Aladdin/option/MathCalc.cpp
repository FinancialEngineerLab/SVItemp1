#pragma once
#include "MathCalc.h"
#include "normal.h"
#include "GeneralUtility.h"
#include "Aladdin\xll\utility\ensure.h"
#include <stdexcept>
#include <cstdlib>
#include <random>
#include <ctime>


// Check if a vector of double is all negative or positive
int isConsecutiveTrend(double* dInputVector, int iSize, int iPosOrNeg)
{
	int iResult = 1;
	if(iPosOrNeg == 1) // want to check postiveness
	{
		for( int i =0; i < iSize; i++)
		{
			if(dInputVector[i] >0)
				continue;
			else
			{
				iResult = 0;
				break;
			}
		}
	}
	else if(iPosOrNeg == 0)
	{
		for( int i =0; i < iSize; i++)
		{
			if(dInputVector[i] <0)
				continue;
			else
			{
				iResult = 0;
				break;
			}
		}
	}
	else
	{
		throw std::runtime_error("Err: iPosOrNeg value must be 0 or 1");
	}

	return iResult;
}



double random_uniform_0_1(void)
{
	//srand((unsigned) time(0));
    return double(rand())/double(RAND_MAX); // this uses the C library random number generator. 
};


double random_std_normal(void) // return the std normal variable
{
	return normal_inv(random_uniform_0_1());
}


double rand_normal(double mean, double stddev)
{//Box muller method
    static double n2 = 0.0;
    static int n2_cached = 0;
    if (!n2_cached)
    {
        double x, y, r;
        do
        {
            x = 2.0*rand()/RAND_MAX - 1;
            y = 2.0*rand()/RAND_MAX - 1;

            r = x*x + y*y;
        }
        while (r == 0.0 || r > 1.0);
        {
            double d = sqrt(-2.0*log(r)/r);
            double n1 = x*d;
            n2 = y*d;
            double result = n1*stddev + mean;
            n2_cached = 1;
            return result;
        }
    }
    else
    {
        n2_cached = 0;
        return n2*stddev + mean;
    }
}



double sim_lognorm_var(double s, double r, double sigma, double time)
{
	double dDrift = 0;
	double dVol = 0;
	//double dNormalStd = 0;
	/*
	std::random_device rd;
    std::mt19937 gen(rd());
	std::normal_distribution<double> distribution(0.0,1.0);
	dNormalStd = distribution(gen);
	*/
	dDrift = (r - 0.5 * sigma * sigma)*time;
	dVol = sigma *sqrt(time);

	return s*exp(dDrift + dVol*random_std_normal());
	//return s*exp(dDrift + dVol*rand_normal(0,1));
	//return s*exp(dDrift + dVol*dNormalStd);
}



double find_max_then_replace(double dMax, double dCurrent)
{ 
	return dMax<dCurrent? dCurrent:dMax;
};

double find_min_then_replace(double dMin, double dCurrent)
{ 
	return dMin>dCurrent? dCurrent:dMin;
};

double* diff_series(double* dInputVector, int iSize)
{
	double* dDiffVector = NULL;
	dDiffVector = dvector(iSize-1);

	for(int i = 0; i<iSize-1; i++)
	{
		dDiffVector[i] = dInputVector[i+1] - dInputVector[i];
	}

	return dDiffVector;
}

double find_max_drawdown(double* dInputVector, int iSize, int iIsNAV=0, int iMode =0)
{
	double dMaxDrawdown = 0;
	double dDrawdownCurrent = 0;
	double* dCalcVector = NULL;
	int     iCalcSize = 0;
	double dMaxNAV = 0;

	
	if((iIsNAV == 0)||((iIsNAV == 1)&&(iMode == 1)))
	{
		dCalcVector = dvector(iSize);
		memcpy(dCalcVector, dInputVector, iSize*sizeof(double));
		iCalcSize = iSize;
	}
	else
	{
		dCalcVector = diff_series(dInputVector, iSize);
		iCalcSize = iSize - 1;
	}


	
	if(iMode == 0)
	{
		// Compute the max consecutive drawdown
		dMaxDrawdown = dCalcVector[0];
		dDrawdownCurrent = dMaxDrawdown;
		for( int i = 1; i < iCalcSize; i++)
		{
			if(dCalcVector[i] < 0)
			{
				//dDrawdownCurrent += dInputVector[i];
				dDrawdownCurrent += dCalcVector[i];
				dMaxDrawdown = find_min_then_replace(dMaxDrawdown,dDrawdownCurrent);
			}
			else
			{
				dDrawdownCurrent = 0;
			}
		
		}
	}
	else
	{
		// Compute the max drawdown
		ensure(iIsNAV>0);
		dMaxNAV = dCalcVector[0];
		dMaxDrawdown = 0;
		dDrawdownCurrent = dMaxDrawdown;
		for( int i = 1; i < iCalcSize; i++)
		{
			dMaxNAV = find_max_then_replace(dMaxNAV,dCalcVector[i]);
			dDrawdownCurrent = dMaxNAV - dCalcVector[i];
			dMaxDrawdown = find_max_then_replace(dMaxDrawdown,dDrawdownCurrent);
		}

	}
	return dMaxDrawdown;
}


double cap_on_value(double dCap, double dValue)
{
	return dCap>dValue? dValue:dCap;
}

double floor_on_value(double dFloor, double dValue)
{
	return dFloor<dValue? dValue:dFloor;
}