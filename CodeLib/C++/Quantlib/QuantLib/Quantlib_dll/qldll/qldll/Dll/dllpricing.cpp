
#include <qldll/qldll/Dll/dlldefines.h>
#include <qldll/qldll/Option/optiontype.h>
#include <ql/quantlib.hpp>

#ifdef BOOST_MSVC
/* Uncomment the following lines to unmask floating-point
   exceptions. Warning: unpredictable results can arise...

   See http://www.wilmott.com/messageview.cfm?catid=10&threadid=9481
   Is there anyone with a definitive word about this?
*/
// #include <float.h>
// namespace { unsigned int u = _controlfp(_EM_INEXACT, _MCW_EM); }
#endif

using namespace QuantLib;


DLLEXPORT Real alBS(char* strOptionType, Real strike, Real spot, Volatility vol, Real riskFreeRate, Real maturity)
{
	Real ret = 0.0;
	Option::Type  OptionTypeEnum = getOptionEnumType(strOptionType);
	ret = BlackScholesFormula(OptionTypeEnum,strike,spot,vol,riskFreeRate,maturity);
	return ret;
}