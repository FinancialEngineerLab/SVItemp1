#if defined(HAVE_CONFIG_H)
#include <qlo/config.hpp>
#endif

#include <qlo/structuredproduct.hpp>



namespace QuantLibAddin {

	BarrierKOKOPayoff::BarrierKOKOPayoff(
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
		bool permanent) : StrikedTypePayoff(properties, permanent) {
			libraryObject_ = boost::shared_ptr<QuantLib::BarrierKOKOPayoff>(
				new QuantLib::BarrierKOKOPayoff(
				underlyingSpot,
				margin,
				gearing1,
				gearing2,
				lowerBarrier,
				upperBarrier,
				lowerInBarrier,
				upperInBarrier,
				payoffMethod));    
	}
}