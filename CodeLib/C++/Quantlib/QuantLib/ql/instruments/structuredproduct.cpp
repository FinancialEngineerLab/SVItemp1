#include <ql/instruments/structuredproduct.hpp>



namespace QuantLib {
	// aladdin
	// Double Sticky/Ratchet payoffs
	Real BarrierKOKOPayoff::operator()(Real forward) const {
		
		QL_REQUIRE(gearing1_>=0,
			"gearing1 must be non negative");
		QL_REQUIRE(gearing2_>=0,
			"gearing2 must be non negative");
		Real yield = 0;
		if(forward < lowerBarrier_)
			yield = margin_;
		else if(forward <= lowerInBarrier_){
			if(iPayoffMethod_ ==0 )//default method
			{
				yield = margin_ + (underlyingSpot_ - forward)/underlyingSpot_ *gearing1_;
			}
			else{
				yield = margin_ + (lowerInBarrier_ - forward)/underlyingSpot_ *gearing1_;
			}
		}
		else if(forward <= upperInBarrier_){
			yield = margin_;
		}
		else if(forward <= upperBarrier_ ){
			if(iPayoffMethod_ == 0 )//default method
			{
				yield = margin_ + (forward - underlyingSpot_)/underlyingSpot_ *gearing2_;
			}
			else{
				yield = margin_ + (forward - upperInBarrier_)/underlyingSpot_ *gearing2_;
			}
		}
		else{
			yield = margin_;
		}
		return yield;
	}


	std::string BarrierKOKOPayoff::description() const {
		std::ostringstream result;
		result << name();
		return result.str();
	}

	void BarrierKOKOPayoff::accept(AcyclicVisitor& v) {
		Visitor<BarrierKOKOPayoff>* v1 =
			dynamic_cast<Visitor<BarrierKOKOPayoff>*>(&v);
		if (v1 != 0)
			v1->visit(*this);
		else
			Payoff::accept(v);
	}

}