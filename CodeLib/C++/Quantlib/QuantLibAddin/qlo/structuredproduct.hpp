
#ifndef qla_structuredproduct_hpp
#define qla_structuredproduct_hpp

#include <oh/libraryobject.hpp>
#include <ql/instruments/structuredproduct.hpp>
#include <qlo/payoffs.hpp>

namespace QuantLibAddin {
	//aladdin
	class BarrierKOKOPayoff : public StrikedTypePayoff {
	public:
		BarrierKOKOPayoff(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			const QuantLib::Real underlyingSpot,
			const QuantLib::Real margin,
			const QuantLib::Real gearing1,
			const QuantLib::Real gearing2,
			const QuantLib::Real lowerBarrier,
			const QuantLib::Real upperBarrier,
			const QuantLib::Real lowerInBarrier,
			const QuantLib::Real upperInBarrier,
			const QuantLib::Natural payoffMethod,
			bool permanent);
	protected:
		OH_OBJ_CTOR(BarrierKOKOPayoff, StrikedTypePayoff);
	};
}





#endif