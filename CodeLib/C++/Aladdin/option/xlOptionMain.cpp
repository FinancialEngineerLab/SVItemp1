
#pragma once
#include "black.h"
#include "GeneralUtility.h"
#include "MathCalc.h"
#include "datemain.h"
#include "Aladdin\xll\xll.h"
#include "montecarlo.h"

#define ALADDIN_VERSION "1.52" // version of ALADDIN project 

using namespace xll;





static AddIn xai_version("?xll_version",
						 XLL_CSTRING,
						 "ALADDINVersion",
						 "",
						 "Jiahe-Aladdin",
						 "Return the version of Aladdin project");




static AddIn xai_black_scholes_value(
	// C function name, C function signature
	"?xll_black_scholes_value", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BS", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option price using Black Scholes formula."
);

static AddIn xai_black_scholes_delta(
	// C function name, C function signature
	"?xll_black_scholes_delta", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BSDelta", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option delta using Black Scholes formula."
);


static AddIn xai_black_scholes_gamma(
	// C function name, C function signature
	"?xll_black_scholes_gamma", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BSGamma", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option gamma using Black Scholes formula."
);


static AddIn xai_black_scholes_theta(
	// C function name, C function signature
	"?xll_black_scholes_theta", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BSTheta", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option theta using Black Scholes formula."
);

static AddIn xai_black_scholes_vega(
	// C function name, C function signature
	"?xll_black_scholes_vega", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BSVega", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option vega using Black Scholes formula."
);

static AddIn xai_black_scholes_rho(
	// C function name, C function signature
	"?xll_black_scholes_rho", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"BSRho", "Underlying spot price,Strike price, Risk free rate,Volatility, Time to maturity, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Option rho using Black Scholes formula."
);


static AddIn xai_implied_vol(
	// C funfunctionctio name, C function signature
	"?xll_implied_vol", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"ImpliedVol", "Underlying spot price,Strike price, Risk free rate, Time to maturity, Option price, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Implied volatility of an option "
);

static AddIn xai_implied_vol_approx(
	// C function name, C function signature
	"?xll_implied_vol_approx", XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_SHORT,
	// Excel function name, Excel function argument text
	"ImpliedVolApprox", "Underlying spot price,Strike price, Risk free rate,Time to maturity,Option price, CallOrPut: 1-Call 0-Put",
	// Category, Function help
	"Jiahe-Aladdin", "Implied volatility of an option using Steven Li approximation formula "
);

static AddIn xai_get_unique_list(
	// C function name, C function signature
	"?xll_get_unique_list", XLL_LPOPERX XLL_LPOPERX,
	// Excel function name, Excel function argument text
	"GetUniqueList", "Input array range",
	// Category, Function help
	"Jiahe-Aladdin", "Return a list of element with no duplicates "
);

static AddIn xai_check_consecutive_trend(
	// C function name, C function signature
	"?xll_check_consecutive_trend", XLL_SHORT XLL_LPOPERX XLL_SHORT,
	// Excel function name, Excel function argument text
	"isConsecutiveTrend", "Input array range, Check postive or negative: 1-Positve 0-Negative",
	// Category, Function help
	"Jiahe-Aladdin", "To check if every cell of range is positive or negative "
);

static AddIn xai_remove_zero(
	// C function name, C function signature
	"?xll_remove_zero_values", XLL_LPOPERX XLL_LPOPERX,
	// Excel function name, Excel function argument text
	"RemoveZeroValue", "Input array range",
	// Category, Function help
	"Jiahe-Aladdin", "Remove zero values in the range "
);

static AddIn xai_merge_range(
	// C function name, C function signature
	"?xll_merge_range", XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX,
	// Excel function name, Excel function argument text
	"MergeRange", "Input array range1, Input array range2,Input array range3,Input array range4,Input array range5,Input array range6",
	// Category, Function help
	"Jiahe-Aladdin", "Merge different ranges "
);


static AddIn xai_find_max_drawdown(
	// C function name, C function signature
	"?xll_find_max_drawdown", XLL_DOUBLE XLL_LPOPERX XLL_SHORT XLL_SHORT,
	// Excel function name, Excel function argument text
	"GetMaxDrawdown", "Input return array range, 1-NAV 0-Return(default), 0-Consectuvie drawdown 1-Nonconsecutive drawdown ",
	// Category, Function help
	"Jiahe-Aladdin", "Find out the maximum drawdown of returns "
);

static AddIn xai_eqd_dev_mc_pricing(
	// C function name, C function signature
	"?xll_MC_pricing", XLL_LPOPERX XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_DOUBLE XLL_LPOPERX XLL_LPOPERX,
	// Excel function name, Excel function argument text
	"OptionMCPricing", "Underlying spot price, Risk free rate, Volatility, Time to maturity, Payoff parameters, MC parameters",
	// Category, Function help
	"Jiahe-Aladdin", "Compute the option price using MC simulations "
);

static AddIn xai_option_payoff(
	// C function name, C function signature
	"?xll_output_option_payoff", XLL_LPOPERX XLL_LPOPERX XLL_LPOPERX,
	// Excel function name, Excel function argument text
	"ExportOptionPayoff", "Underlying price at maturity, Payoff parameters",
	// Category, Function help
	"Jiahe-Aladdin", "Export the option payoff "
);




//-------------------------------------Date Functions---------------------------------------------------
static AddIn xai_add_tenor(
	// C function name, C function signature
	"?xll_add_tenor", XLL_LONG XLL_LONG XLL_LONG XLL_LPOPERX XLL_SHORT,
	// Excel function name, Excel function argument text
	"AddTenor", "Current date, Added unit,Tenor(D,BD,M,Y),Convention(default 0 - Following, 1 - Unadjusted)",
	// Category, Function help
	"Jiahe-Aladdin", "Return date based on given tenors "
);


//------------------------------------------------------------------------------------------------------------------


/*
static AddInX xai_black_value(
	FunctionX(XLL_DOUBLEX, _T("?xll_black_value"), PREFIX _T("BLACK.VALUE"))
	.Num(_T("Forward"), IS_FORWARD, 100)
	.Num(_T("Volatility"), IS_VOLATILITY, .2)
	.Num(_T("Strike"),	IS_STRIKE, 100)
	.Num(_T("Expiration"), IS_EXPIRATION, .25)
	.Category(CATEGORY)
	.FunctionHelp(_T("Returns the value of a Black call or put option"))
	.Documentation(
		_T("If you prefer a call/put flag of ") ENT_plusmn _T("1 use <codeInline>flag*strike</codeInline> as the ")
		_T("<codeInline>strike</codeInline> argument to this function. ")
/*		,
		xml::xlink(_T("BLACK.IMPLIED"))
*/	/*)
);*/



//*********************************************************************************************************************************//


char* WINAPI xll_version()
{
#pragma XLLEXPORT
	static char cVersion[100];
	strcpy_s(cVersion,"ALADDIN VERSION ");
	strcat_s(cVersion, ALADDIN_VERSION);

	
	return cVersion;
}



//Black Schols price
double WINAPI xll_black_scholes_value(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_price_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Greeks
// Delta
double WINAPI xll_black_scholes_delta(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_delta_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Gamma
double WINAPI xll_black_scholes_gamma(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_gamma_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Theta
double WINAPI xll_black_scholes_theta(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_theta_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Vega
double WINAPI xll_black_scholes_vega(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_vega_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Rho
double WINAPI xll_black_scholes_rho(double s, double k, double r, double sigma, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
		x = option_rho_black_scholes(s,k,r,sigma,t,iCallOrPut);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Implied vol
double WINAPI xll_implied_vol(double s, double k, double r, double t,double price, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
			x = option_implied_volatility(s,k,r,t,price,iCallOrPut,1);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

// Implied vol using Steven Li formula
double WINAPI xll_implied_vol_approx(double s, double k, double r, double price, double t, int iCallOrPut)
{
#pragma XLLEXPORT
	double x = std::numeric_limits<double>::quiet_NaN();

	try {
			x = option_implied_volatility(s,k,r,price,t,iCallOrPut,2);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return x;
}

//-----------------------------------------------------------------------------------
// Utility 


LPOPERX WINAPI xll_get_unique_list(LPOPERX lListRange)
{
#pragma XLLEXPORT
	static OPERX oList;
	int iInputSize = 0;
	int iOutputSize = 0;
	char** output_array = NULL;
	char** input_array = NULL;
	//input_array = cvector((*lListRange).rows(),500);
	
	get_range_values((*lListRange),&input_array,&iInputSize);

	output_array = get_unique_element_list(input_array, iInputSize, &iOutputSize);

	convert_char_to_opex(&oList,output_array,iOutputSize);

	//oList.xltype = xltypeStr;

	return &oList;
}


int WINAPI xll_check_consecutive_trend(LPOPERX lListRange, int iPosOrNeg)
{
#pragma XLLEXPORT
	int iResult = 1;
	int iSize = 0;
	iSize = (*lListRange).rows();
	double* dVector = NULL;

	try {
			convert_opex_to_dvector((*lListRange),&dVector, iSize);
			iResult = isConsecutiveTrend(dVector,iSize,iPosOrNeg);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return iResult;


}

LPOPERX WINAPI xll_remove_zero_values(LPOPERX lListRange)
{
	#pragma XLLEXPORT
	static OPERX oList = NULL;
	int iInputSize = 0;
	int iOutputSize = 0;

	iInputSize = (*lListRange).rows();
	for(int i = 0; i < iInputSize; i++)
	{
		if((*lListRange).val.array.lparray[i].val.str != 0) // remove black cells
		{
			iOutputSize++;
			oList.resize(iOutputSize,1);
			oList(iOutputSize-1,0) = (*lListRange)(i,0);
		}
	}
	return &oList;

}

LPOPERX WINAPI xll_merge_range(LPOPERX lListRange1,LPOPERX lListRange2,LPOPERX lListRange3,LPOPERX lListRange4,LPOPERX lListRange5,LPOPERX lListRange6)
{
#pragma XLLEXPORT
	static OPERX oList = NULL;
	int iSize1 = 0;
	int iSize2 = 0;
	int iSize3 = 0;
	int iSize4 = 0;
	int iSize5 = 0;
	int iSize6 = 0;
	int iOutputSize = 0;

	iSize1 = (*lListRange1).rows();
	iSize2 = (*lListRange2).rows();
	iSize3 = (*lListRange3).rows();
	iSize4 = (*lListRange4).rows();
	iSize5 = (*lListRange5).rows();
	iSize6 = (*lListRange6).rows();



	if(iSize1) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize1; i++)
		{
			if((*lListRange1).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange1)(i,0);
			}
		}
	}

	if(iSize2) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize2; i++)
		{
			if((*lListRange2).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange2)(i,0);
			}
		}
	}

	if(iSize3) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize3; i++)
		{
			if((*lListRange3).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange3)(i,0);
			}
		}
	}

	if(iSize4) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize4; i++)
		{
			if((*lListRange4).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange4)(i,0);
			}
		}
	}

	if(iSize5) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize5; i++)
		{
			if((*lListRange5).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange5)(i,0);
			}
		}
	}

	if(iSize6) // without this line the code will crush, to be improved 
	{
		for(int i = 0; i < iSize6; i++)
		{
			if((*lListRange6).val.array.lparray[i].xltype != 256) // remove black cells
			{
				iOutputSize++;
				oList.resize(iOutputSize,1);
				oList(iOutputSize-1,0) = (*lListRange6)(i,0);
			}
		}
	}


	return &oList;
}


double WINAPI xll_find_max_drawdown(LPOPERX lListRange, int iIsNAV, int iMode)
{
#pragma XLLEXPORT
	double dMaxDrawdown = 0;
	int iSize = 0;
	double* dVector = NULL;

	iSize = (*lListRange).rows();

	try {
			convert_opex_to_dvector((*lListRange),&dVector, iSize);
			dMaxDrawdown = find_max_drawdown(dVector,iSize,iIsNAV,iMode);
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return dMaxDrawdown;
}

LPOPERX WINAPI xll_MC_pricing(double s, double r, double sigma, double time, LPOPERX lPayoffParams, LPOPERX lMCParams)
{
#pragma XLLEXPORT
	double* dOutputResult = NULL;
	static OPERX oOutputResult; 
	oOutputResult.resize(2,1);
	dOutputResult = dvector(2);

	try {
			dOutputResult = mc_main(s,r,sigma,time,(*lPayoffParams),(*lMCParams));
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	oOutputResult(0,0) = dOutputResult[0]; //Price
	oOutputResult(1,0) = dOutputResult[1];  // Variance
	return &oOutputResult;
}


LPOPERX WINAPI xll_output_option_payoff(LPOPERX lSpotRange,LPOPERX lPayoffParams)
{
#pragma XLLEXPORT
	static OPERX oPayoff;
	
	try {
			oPayoff = export_option_payoff((*lSpotRange),(*lPayoffParams));
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return &oPayoff;
}




long WINAPI xll_add_tenor(long lToday, long n, LPOPERX lTenor,int iConvention)
{
#pragma XLLEXPORT
	long lDate = 0;
	TimeUnit iTimeUnit = Days;
	BusinessDayConvention bConvention = Following;
	int iInputSize = 0;
	char** output_tenor_array = NULL;
	
	try {
		if((*lTenor).rows())
		{
			get_range_values((*lTenor),&output_tenor_array,&iInputSize); // it will only output one element in input_array
			iTimeUnit = read_tenor(output_tenor_array[0]);
			if(iConvention == 1)
			{
				bConvention = Unadjusted;
			}
			lDate =add_tenor(lToday,n, iTimeUnit,bConvention,0);
		}
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return lDate;
}




/*

//Shichen

LPOPERX WINAPI xll_return_analysis(LPOPERX lListRange)
{
#pragma XLLEXPORT
	
	static OPERX oReturnOutput;

	try {
			
	}
	catch (const std::exception& ex) {
		XLL_ERROR(ex.what());
	}

	return &oReturnOutput;
}*/