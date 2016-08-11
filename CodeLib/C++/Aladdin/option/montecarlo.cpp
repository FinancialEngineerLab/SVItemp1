#pragma once
#include <cmath>
#include <stdexcept>
#include "MathCalc.h"
#include "montecarlo.h"
#include "normal.h"
#include "params.h"
#include "GeneralUtility.h"
#include "black.h"
#include "Aladdin\xll\utility\ensure.h"
#include <fstream>
using namespace std;



void init_payoff_params(PAYOFFPARAMS *pPayoffParams)
{
	(*pPayoffParams) = (PayoffParams*)malloc(sizeof(PayoffParams));
	(*pPayoffParams)->iPathDep = 0;
	(*pPayoffParams)->iOptionType = 1;  // by default = call
	
	(*pPayoffParams)->dMargin = 0;
	(*pPayoffParams)->dStrike = 0;
	
	(*pPayoffParams)->dDownbarrierOnPath = 0;
	(*pPayoffParams)->dUpbarrierOnPath = 0;
	(*pPayoffParams)->dDownbarrierOnPayoff =0;
	(*pPayoffParams)->dUpbarrierOnPayoff = 0;

	(*pPayoffParams)->dUpRatio = 1.0;
	(*pPayoffParams)->dDownRatio = 1.0;
	(*pPayoffParams)->iDeltaHedging = 0;
	(*pPayoffParams)->dCommision = 0.0;

}

void init_MC_pricing_params(MCPARAMS *pMCParams)
{
	(*pMCParams) = (MCParams*) malloc(sizeof(MCParams));
	(*pMCParams)->iNbPath = 1;
	(*pMCParams)->iNbTimeStep = 1;
	(*pMCParams)->iVarReduction = 0;
	(*pMCParams)->dDeltaHedgingSize= 0.005;
}

 // use ratio means the payoff is a function of spot/strike, the payoff barrier is on spot/strike
double payoff_call(double s, double k,double dUpBarrierOnSpot, double dDownBarrierOnSpot, int iUseRatio = 0)
{
	double dPayoff = 0;
	double dGrowth = 0;
	if(iUseRatio)
	{
		dPayoff =  __max(0.0,s/k - 1); 
		dGrowth = s/k;
		if(dGrowth < dDownBarrierOnSpot)
		{
			return 0;
		}
		else if(dGrowth <dUpBarrierOnSpot)
		{
			return __max(0.0,s/k - 1); 
		}
		else
		{
			return 0;
		}
	}
	else
	{
		
		if(s < dDownBarrierOnSpot)
		{
			return 0;
		}
		else if(s <dUpBarrierOnSpot)
		{
			return __max(0.0,s - k); 
		}
		else
		{
			return 0;
		}

	}
	
	return dPayoff;

};

double payoff_put(double s, double k,double dUpBarrierOnSpot, double dDownBarrierOnSpot, int iUseRatio = 0)
{
	double dPayoff = 0;
	double dGrowth = 0;
	if(iUseRatio)
	{
		dGrowth = s/k;
		if(dGrowth < dDownBarrierOnSpot)
		{
			return 0;
		}
		else if(dGrowth <dUpBarrierOnSpot)
		{
			return __max(0.0,1 - s/k); 
		}
		else
		{
			return 0;
		}
	}
	else
	{
		if(s < dDownBarrierOnSpot)
		{
			return 0;
		}
		else if(s <dUpBarrierOnSpot)
		{
			return  __max(0.0,k - s); ; 
		}
		else
		{
			return 0;
		}
		
	}
	
};

double payoff_straddle(double s, double k, double dUpBarrierOnSpot, double dUpRatio, double dDownBarrierOnSpot, double dDownRatio,int iUseRatio=1)
{
	double dGrowth;

	if(iUseRatio)
	{
		dGrowth = s/k;
		if(dGrowth < dDownBarrierOnSpot)
		{
			return 0;
		}
		else if(dGrowth <1)
		{
			return (1-dGrowth)*dDownRatio;
		}
		else if(dGrowth < dUpBarrierOnSpot)
		{
			return (dGrowth-1)*dUpRatio; 
		}
		else
		{
			return 0;
		}
		
	}
	else
	{
		throw std::runtime_error("Error: currrently payoff of straddle must be a ratio!");
	}


}

double payoff_option(double s, PAYOFFPARAMS pPayoffParams)
{
	ensure((pPayoffParams->iOptionType==0)||(pPayoffParams->iOptionType==1)|| (pPayoffParams->iOptionType==2))
	if(pPayoffParams->iOptionType == 0)
	{
		return payoff_put(s,pPayoffParams->dStrike, pPayoffParams->dUpbarrierOnPayoff, pPayoffParams->dDownbarrierOnPayoff,pPayoffParams->iUseRatio);
	}
	else if(pPayoffParams->iOptionType == 1)
	{
		return payoff_call(s,pPayoffParams->dStrike, pPayoffParams->dUpbarrierOnPayoff, pPayoffParams->dDownbarrierOnPayoff,pPayoffParams->iUseRatio);
	}
	else
	{
		return payoff_straddle(s,
							   pPayoffParams->dStrike,
							   pPayoffParams->dUpbarrierOnPayoff, 
							   pPayoffParams->dUpRatio, 
							   pPayoffParams->dDownbarrierOnPayoff,
							   pPayoffParams->dDownRatio,
							   pPayoffParams->iUseRatio);

	}
}


void check_barrier(double dCheckBarrier, double dDownbarrierOnPath, double dUpbarrierOnPath, int* iKnockOut)
{
	if(dCheckBarrier < dDownbarrierOnPath || dCheckBarrier > dUpbarrierOnPath)
	{
		(*iKnockOut) = 1;
	}
}

double* mc_option_price	   (double s, 
							double r,
							double sigma,
							double time,
							PAYOFFPARAMS pPayoffParams,
							MCPARAMS     pMCParams)




{



	double dPrice = 0;
	double dVar = 0;
	double dUndPrice = 0;
	double dPayoff = 0;
	int    iKnockout = 0;
	double dCheckBarrier = 0;
	double* dOutputResult = NULL;
	double dUndPriceEur = 0;
	double dPayoffEur = 0;
	double dUndPricePlus = 0;
	double dUndPriceMinus = 0;
	double dCheckBarrierPlus = 0;
	double dCheckBarrierMinus = 0;
	double dPriceEurBS = 0;

	for (int i = 0; i < pMCParams->iNbPath ; i++)
	{
		dUndPrice = s;
		dUndPricePlus = s;
		dUndPriceMinus = s;
		if(pPayoffParams->iPathDep) // path dependent
		{
			
			for( int j = 0; j < pMCParams->iNbTimeStep; j++)
			{
				if( pMCParams->iVarReduction == 1) // antithetic
				{	
					dUndPricePlus = sim_lognorm_var(dUndPricePlus,r,sigma,time/pMCParams->iNbTimeStep);
					dUndPriceMinus = sim_lognorm_var(dUndPriceMinus,r,-sigma,time/pMCParams->iNbTimeStep); // variance reduction
					if(pPayoffParams->iUseRatio)
					{
						//dCheckBarrier = dUndPrice / s; 
						dCheckBarrierPlus = dUndPricePlus /pPayoffParams->dStrike; 
						dCheckBarrierMinus = dUndPriceMinus /pPayoffParams->dStrike;

					}
					else
					{	
						dCheckBarrierPlus = dUndPricePlus; 
						dCheckBarrierMinus = dUndPriceMinus;
					}
					check_barrier(dCheckBarrierPlus,pPayoffParams->dDownbarrierOnPath, pPayoffParams->dUpbarrierOnPath,&iKnockout);
					check_barrier(dCheckBarrierMinus,pPayoffParams->dDownbarrierOnPath, pPayoffParams->dUpbarrierOnPath,&iKnockout);
				}
				else
				{
				    dUndPrice = sim_lognorm_var(dUndPrice,r,sigma,time/pMCParams->iNbTimeStep);
					if(pPayoffParams->iUseRatio)
					{
						//dCheckBarrier = dUndPrice / s; 
						dCheckBarrier = dUndPrice /pPayoffParams->dStrike; 

					}
					else
					{	
						dCheckBarrier = dUndPrice;
					}
					check_barrier(dCheckBarrier,pPayoffParams->dDownbarrierOnPath, pPayoffParams->dUpbarrierOnPath,&iKnockout);
				}
				
				if(iKnockout == 1)   //knock out 
				{
					break;
				}
			}			
		}
		else  // non path dependent
		{
			if( pMCParams->iVarReduction == 1)
			{		
			     dUndPricePlus = sim_lognorm_var(dUndPrice,r,sigma,time);
				 dUndPriceMinus = sim_lognorm_var(dUndPrice,r,-sigma,time); // variance reduction
				  
			}
			else
			{
			      dUndPrice = sim_lognorm_var(s,r,sigma,time);
			}
		}

		if(iKnockout)
		{
			dPayoff = 0;
			iKnockout = 0;
		}
		else
		{
			if( pMCParams->iVarReduction == 1)// antithetic
			{		
			    dPayoff = 0.5*payoff_option(dUndPricePlus,pPayoffParams)+0.5*payoff_option(dUndPriceMinus,pPayoffParams);
				  
			}
			/*
			if ( pMCParams->iVarReduction == 2 )             //control variate
			{
				
				dUndPriceEur = sim_lognorm_var(s,r,sigma,time);
				dPayoffEur =payoff_call(dUndPriceEur,pPayoffParams->dStrike, 
										pPayoffParams->dUpbarrierOnPayoff, 
										pPayoffParams->dDownbarrierOnPayoff,
										pPayoffParams->iUseRatio);  //call: MAX(St-K)
				dPayoff = dPayoff-dPayoffEur;
		
			}*/
			else
			{
				dPayoff = payoff_option(dUndPrice,pPayoffParams);
			}
		}
		
		//dPrice += dPayoff;
		/*
	    if ( pMCParams->iVarReduction == 2 )             //control variate
		{
		   dUndPriceEur = sim_lognorm_var(s,r,sigma,time);
		   dPayoffEur =payoff_call(dUndPriceEur,pPayoffParams->dStrike, pPayoffParams->dUpbarrierOnPayoff, pPayoffParams->dDownbarrierOnPayoff,pPayoffParams->iUseRatio);  //call: MAX(St-K)
      
		   dPayoff = dPayoff-dPayoffEur;
		}*/

		if( i == 0)
		{
			dPrice += dPayoff;
			dVar += dPayoff * dPayoff;
			
		}
		else
		{
			dPrice = dPrice * double(i)/(i+1) + dPayoff/(i+1);
			dVar = dVar * double(i)/(i+1) + (dPayoff * dPayoff)/(i+1);

		}
	}

	dVar= dVar - dPrice * dPrice;
	dPrice = dPrice*exp(-r*time);


	/*
	if( pMCParams->iVarReduction == 2 )
	{
	 double dPriceEurBS = option_price_black_scholes(s,pPayoffParams->dStrike,r,sigma,time,1); 
	 // call european
	 if(pPayoffParams->iUseRatio)
	 {
		 dPrice = dPrice + dPriceEurBS/pPayoffParams->dStrike;
	 }
	 else 
	 {
		 dPrice = dPrice + dPriceEurBS;
	 }
	}
	*/
    
	// first row = price
	// second row = variance
	dOutputResult = dvector(2); 
	dOutputResult[0] = dPrice;
	dOutputResult[1] = dVar;
	
	return dOutputResult;
}


double mc_option_delta(double s, 
				        double r,
				        double sigma,
				        double time,
				        PAYOFFPARAMS pPayoffParams,
				        MCPARAMS     pMCParams)
{
	double dDelta = 0.0;
	double *dPricePlus = NULL;
	double *dPriceMinus = NULL;

	dPricePlus = dvector(2);
	dPriceMinus = dvector(2);

	dPricePlus = mc_option_price(s*(1+pMCParams->dDeltaHedgingSize),r,sigma,time,pPayoffParams,pMCParams);
	dPriceMinus = mc_option_price(s*(1-pMCParams->dDeltaHedgingSize),r,sigma,time,pPayoffParams,pMCParams);

	dDelta = (dPricePlus[0] - dPriceMinus[0])/(2*pMCParams->dDeltaHedgingSize*s);

	dDelta = __min(1.0,dDelta);
	dDelta = __max(-1.0, dDelta);

	free_dvector(dPricePlus);
	free_dvector(dPriceMinus);

	return dDelta;

}

double* mc_delta_hedging_price	   (double s, 
				                    double r,
				                    double sigma,
				                    double time,
				                    PAYOFFPARAMS pPayoffParams,
				                    MCPARAMS     pMCParams)




{

	double* dDelta = NULL;
	double dUndPrice = 0;
	double dPayoff = 0;
	int    iKnockout = 0;
	double dCheckBarrier = 0;
    double dGainsHedge = 0;
    double dAdjust = 0;
    double dPrice = 0;
	double dVar = 0;
	double* dOutputResult = NULL;
	int iKnockOutStep = 0;
	double* dPricePlus = NULL;
	double* dPriceMinus = NULL;
	double dBank = 0;
	
    dDelta = dvector(2);
	dDelta[0] = 0;
	dDelta[1] = 0;

	/*
	ofstream outfile("target.txt",ios::out); //open target.txt
	if (!outfile)
	{
		cerr<<"open error!"<<endl;
		exit(1);
	}
	*/

	for (int i = 0; i < pMCParams->iNbPath ; i++)
    {
		
       dUndPrice = s;
	   dGainsHedge = 0;
	   iKnockOutStep = 0;

	   dDelta[0] =  mc_option_delta(dUndPrice,r,sigma,time,pPayoffParams,pMCParams);
	   //outfile<<dDelta[0]<<"  ";
	   

	   dBank = -dDelta[0] * dUndPrice - fabs(dDelta[0]*dUndPrice) * pPayoffParams->dCommision;  //borrow money initially
	   for(int j = 0; j < pMCParams->iNbTimeStep; j++)
	   {
		   // next time step  
		  dUndPrice = sim_lognorm_var(dUndPrice,r,sigma,time/pMCParams->iNbTimeStep);  //dDeltaRecord changed here
		  // realized gain at each rehedging times  (delta_0 - delta_1)*S_1         

          if(pPayoffParams->iPathDep) // path dependent                            
		  {
               if(pPayoffParams->iUseRatio)
			   {
					dCheckBarrier = dUndPrice /pPayoffParams->dStrike;
				}
				else
				{	
					dCheckBarrier = dUndPrice; 	
				}
				
			   check_barrier(dCheckBarrier,pPayoffParams->dDownbarrierOnPath, pPayoffParams->dUpbarrierOnPath,&iKnockout);
					
			}
				
			if(iKnockout == 1)   //knock out 
			{
				iKnockOutStep = j;
				break;
			}
			
		  if( pMCParams->iNbTimeStep > 1) // rehedging is needed only when iNbTimeStep >1
		  {
			  dDelta[1] = mc_option_delta(dUndPrice,r,sigma,time*(1-double(j+1)/pMCParams->iNbTimeStep),pPayoffParams,pMCParams);

			  /*
			  outfile<<dDelta[1]<<"  ";
			  if (j==pMCParams->iNbTimeStep-1) //putout to .txt
			  {outfile<<"\n";}
			  */
 
			  dAdjust = dDelta[0] - dDelta[1];
			  dGainsHedge += exp(r*time*(1-double(j+1)/pMCParams->iNbTimeStep)) * (dAdjust * dUndPrice - fabs(dAdjust) * dUndPrice * pPayoffParams->dCommision);
			  dDelta[0] = dDelta[1];
		  }   
	   }	

	   if(iKnockout)
	   {
	      //dPayoff = dGainsHedge - (dDelta[0] * dUndPrice - fabs(dDelta[0]) * dUndPrice *pPayoffParams->dCommision)* exp(r * time * (1 - double(iKnockOutStep)/pMCParams->iNbTimeStep));
	      // if knocked out, the payoff to client is zero
		  dPayoff = dGainsHedge + dBank*exp(r*time)+ (dDelta[0]*dUndPrice - fabs(dDelta[0])*dUndPrice*pPayoffParams->dCommision)*exp(r*time*(1-double(iKnockOutStep)/pMCParams->iNbTimeStep)); 
		  iKnockout = 0;
		  // take negative value of payoff
		  dPayoff = -dPayoff;
		   
		  if(pPayoffParams->iUseRatio == 1)
		  {
			  dPayoff = dPayoff/pPayoffParams->dStrike;
		  }
	    }
	    else
	    {
          // Profit or Loss is the sum of the actualized gains from trading + what was in the bank at the begining+what is held in stock - payments to the client
		  dPayoff = dGainsHedge + dBank*exp(r*time) + dDelta[0]*dUndPrice - fabs(dDelta[0])*dUndPrice*pPayoffParams->dCommision -  payoff_option(dUndPrice,pPayoffParams);

		  // take negative value of payoff
		  dPayoff = -dPayoff;

		  if(pPayoffParams->iUseRatio == 1)
		  {
			dPayoff = dPayoff/pPayoffParams->dStrike;
		  } 
		 
	    }

	   if( i == 0) 
	   {
		   dPrice += dPayoff;
		   dVar += dPayoff * dPayoff;
	    }
	    else
	    {
			dPrice = dPrice * double(i)/(i+1) + dPayoff/(i+1);
			dVar = dVar * double(i)/(i+1) + (dPayoff * dPayoff)/(i+1);
	    }
		
   }

	//outfile.close();  //close .txt
	
    dVar= dVar - dPrice * dPrice;
	dPrice = dPrice*exp(-r*time);
	dOutputResult = dvector(2+pMCParams->iNbPath); 
	dOutputResult[0] = dPrice;
	dOutputResult[1] = dVar;
	
	free_dvector(dPricePlus);
	free_dvector(dPriceMinus);
	//free_dvector(dOutputResult);

	return dOutputResult;
}


double* mc_main			   (double s, 
							double r,
							double sigma,
							double time,
							OPERX oPayoffRange,
							OPERX oMCRange)
{
	double* dResult = 0;
	PAYOFFPARAMS pPayoffParams = NULL;
	MCPARAMS     pMCParams = NULL;

	dResult = dvector(2); //changed

	init_MC_pricing_params(&pMCParams);
	init_payoff_params(&pPayoffParams);

	readMCParams(oMCRange,&pMCParams);
	readPayoffParams(oPayoffRange,&pPayoffParams);


	if (pPayoffParams->iDeltaHedging == 0)
	{
	  dResult = mc_option_price(s,r,sigma,time,pPayoffParams,pMCParams);
	}
	else
	{
	  dResult = mc_delta_hedging_price(s,r,sigma,time,pPayoffParams,pMCParams);
	}
	

	return dResult;

}



// Output option payoff
OPERX export_option_payoff (  OPERX oSpotAtMatRange,
					   OPERX oPayoffRange)
{
	PAYOFFPARAMS pPayoffParams = NULL;
	int iSize = 0;
	double* dSpotVector = NULL;
	double* dPayoff = NULL;
	OPERX oOutput = NULL;

	iSize = oSpotAtMatRange.rows();
	
	init_payoff_params(&pPayoffParams);
	readPayoffParams(oPayoffRange,&pPayoffParams);

	convert_opex_to_dvector(oSpotAtMatRange,&dSpotVector,iSize);

	dPayoff = dvector(iSize);
	for(int i = 0; i < iSize; i++)
	{
		dPayoff[i] = payoff_option(dSpotVector[i],pPayoffParams);
	}

	convert_dvector_to_opex(&oOutput,dPayoff,iSize);
	
	return oOutput;
}