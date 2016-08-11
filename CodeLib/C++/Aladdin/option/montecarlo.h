
#pragma once

#include "Aladdin\xll\oper.h"

double payoff_call(double s, double k);
double payoff_put(double s, double k);



typedef struct PayoffParams{
	int iPathDep;
	int iOptionType;  // 0 - put, 1 - call, 2 - straddel
	double dStrike;
	int  iUseRatio;

	double dMargin;

	double dUpbarrierOnPayoff;
	double dDownbarrierOnPayoff;
	double dUpbarrierOnPath;
	double dDownbarrierOnPath;

	// straddle
	double dUpRatio;  
	double dDownRatio;

	int iDeltaHedging;   // 0 - no, 1 - yes

	double dCommision;


} sPayoffParams,*PAYOFFPARAMS;


typedef struct MCParams{
	int iNbPath;
	int iNbTimeStep;
	int iVarReduction; //0  - none, 1 - Antithetic Variates, 2 - Control Variates
	double dDeltaHedgingSize;  //
} sMCParams,*MCPARAMS;

void init_payoff_params(PAYOFFPARAMS* pPayoffParams);
void init_MC_pricing_params(MCPARAMS* pMCParams);

double mc_option_payoff    (double s, 
							double r,
							double sigma,
							double time,
							PAYOFFPARAMS pPayoffParams,
							MCPARAMS     pMCParams);


double* mc_option_price	   (double s, 
							double r,
							double sigma,
							double time,
							PAYOFFPARAMS pPayoffParams,
							MCPARAMS     pMCParams);

double* mc_delta_hedging_price	   (double s, 
				                    double r,
				                    double sigma,
				                    double time,
				                    PAYOFFPARAMS pPayoffParams,
				                    MCPARAMS     pMCParams);

double* mc_main			   (double s, 
							double r,
							double sigma,
							double time,
							OPERX oPayoffRange,
							OPERX oMCRange);

OPERX export_option_payoff (  OPERX oSpotAtMatRange,
							   OPERX oPayoffRange);

