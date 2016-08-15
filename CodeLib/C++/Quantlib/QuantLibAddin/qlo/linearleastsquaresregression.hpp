
#ifndef qla_linearleastsquaresregression_hpp
#define qla_linearleastsquaresregression_hpp

#include <ql/math/linearleastsquaresregression.hpp>


// aladdin
namespace QuantLibAddin {

	QuantLib::Matrix LinearRegression(QuantLib::Matrix x_values, std::vector<QuantLib::Real> y_values);
}
#endif