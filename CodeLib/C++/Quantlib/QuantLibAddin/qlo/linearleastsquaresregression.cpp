#if defined(HAVE_CONFIG_H)
#include <qlo/config.hpp>
#endif

#include <qlo/linearleastsquaresregression.hpp>
#include <ql/math/linearleastsquaresregression.hpp>

namespace QuantLibAddin {
	QuantLib::Matrix LinearRegression(QuantLib::Matrix x_values_matrix, std::vector<QuantLib::Real> y_values)
	{
		
		QuantLib::Array aryCoef;
		QuantLib::Array aryStdErr;
		QuantLib::Size szDim;

		std::vector<std::vector<QuantLib::Real> >  x_values = QuantLib::to2DVector(x_values_matrix);
		QL_REQUIRE(x_values.size() == y_values.size(),"x row size and y vector size not equal");

		QuantLib::LinearRegression lsRegression(x_values, y_values);
		aryCoef = lsRegression.coefficients();
		aryStdErr = lsRegression.standardErrors();
		szDim = lsRegression.dim();

		QuantLib::Matrix mResult(3,szDim,0.0);

		for(int i = 0; i < szDim; i++)
		{
			mResult[0][i] = i;
			mResult[1][i] = aryCoef[i];
			mResult[2][i] = aryStdErr[i];
		}

		return mResult;
	}
}

