#include <cmath>
#include "xll/xll.h"

using namespace xll;


static AddIn xai_exp(
	// C functio name, C function signature
	"?xll_exp", XLL_DOUBLE XLL_DOUBLE,
	// Excel function name, Excel function argument text
	"XLL.EXP", "Number",
	// Category, Function help
	"Jiahe-Aladdin", "Exponential function."
);



double WINAPI xll_exp(double number)
{
#pragma XLLEXPORT

	return exp(number);
}