#ifndef quantlib_structured_product_hpp
#define quantlib_structured_product_hpp



#include <ql/option.hpp>
#include <ql/instruments/payoffs.hpp>


namespace  QuantLib {
	//aladdin
	class BarrierKOKOPayoff: public StrikedTypePayoff {
	public:
		BarrierKOKOPayoff(  Real underlyingSpot,
			Real margin,
			Real gearing1, 
			Real gearing2,
			Real lowerBarrier,
			Real upperBarrier,
			Real lowerInBarrier,
			Real upperInBarrrier,
			Natural iPayoffMethod = 0) 
			: StrikedTypePayoff(Option::Type::Barrier, underlyingSpot_),underlyingSpot_(underlyingSpot),margin_(margin),gearing1_(gearing1),gearing2_(gearing2),
			lowerBarrier_(lowerBarrier),upperBarrier_(upperBarrier), lowerInBarrier_(lowerInBarrier), upperInBarrier_(upperInBarrrier),iPayoffMethod_(iPayoffMethod)
		{
			QL_REQUIRE(lowerBarrier_< upperBarrier_,
				"lower barrier must be less than upper barrier");
			QL_REQUIRE(lowerInBarrier_<= upperInBarrier_,
				"lower-in barrier must be no bigger than upper-in barrier");
			QL_REQUIRE(lowerBarrier_< lowerInBarrier_,
				"lower barrier must be less than lower-in barrier");
			QL_REQUIRE(upperInBarrier_< upperBarrier_,
				"upper barrier must be less than upper-in barrier");


		}//aladdin: it is somehow stupid that i apply a striketypepayoff inheritance, to be used for barrieroptionpricing engine

		Real operator()(Real forward) const;
		std::string description() const;
		std::string name() const {return "BarrierKOKO";};
		virtual void accept(AcyclicVisitor&);
		Real underlyingSpot() {return underlyingSpot_;};
		Real margin() {return margin_;};
		Real gearing1() {return gearing1_;};
		Real gearing2() {return gearing2_;};
		Real lowerBarrier() {return lowerBarrier_;};
		Real upperBarrier() {return upperBarrier_;};
		Real lowerInBarrier() {return lowerInBarrier_;};
		Real upperInBarrier() {return upperInBarrier_;};
		int payoffMethod() {return iPayoffMethod_;};
	protected:
		Real underlyingSpot_;
		Real margin_;
		Real gearing1_,gearing2_;
		Real lowerBarrier_, upperBarrier_;
		Real lowerInBarrier_, upperInBarrier_;
		Natural  iPayoffMethod_;
	};


}

#endif