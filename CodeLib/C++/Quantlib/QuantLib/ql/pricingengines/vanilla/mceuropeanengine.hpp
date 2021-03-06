/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*
 Copyright (C) 2000, 2001, 2002, 2003 RiskMap srl
 Copyright (C) 2003 Ferdinando Ametrano
 Copyright (C) 2007, 2008 StatPro Italia srl

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <http://quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

/*! \file mceuropeanengine.hpp
    \brief Monte Carlo European option engine
*/

#ifndef quantlib_montecarlo_european_engine_hpp
#define quantlib_montecarlo_european_engine_hpp

#include <ql/pricingengines/vanilla/mcvanillaengine.hpp>
#include <ql/processes/blackscholesprocess.hpp>
#include <ql/termstructures/volatility/equityfx/blackconstantvol.hpp>
#include <ql/termstructures/volatility/equityfx/blackvariancecurve.hpp>
#include <ql/instruments/structuredproduct.hpp>

namespace QuantLib {

    //! European option pricing engine using Monte Carlo simulation
    /*! \ingroup vanillaengines

        \test the correctness of the returned value is tested by
              checking it against analytic results.
    */
    template <class RNG = PseudoRandom, class S = Statistics>
    class MCEuropeanEngine : public MCVanillaEngine<SingleVariate,RNG,S> {
      public:
        typedef
        typename MCVanillaEngine<SingleVariate,RNG,S>::path_generator_type
            path_generator_type;
        typedef
        typename MCVanillaEngine<SingleVariate,RNG,S>::path_pricer_type
            path_pricer_type;
        typedef typename MCVanillaEngine<SingleVariate,RNG,S>::stats_type
            stats_type;
        // constructor
        MCEuropeanEngine(
             const boost::shared_ptr<GeneralizedBlackScholesProcess>& process,
             Size timeSteps,
             Size timeStepsPerYear,
             bool brownianBridge,
             bool antitheticVariate,
             Size requiredSamples,
             Real requiredTolerance,
             Size maxSamples,
             BigNatural seed);
      protected:
        boost::shared_ptr<path_pricer_type> pathPricer() const;
    };

    //! Monte Carlo European engine factory
    template <class RNG = PseudoRandom, class S = Statistics>
    class MakeMCEuropeanEngine {
      public:
        MakeMCEuropeanEngine(
                    const boost::shared_ptr<GeneralizedBlackScholesProcess>&);
        // named parameters
        MakeMCEuropeanEngine& withSteps(Size steps);
        MakeMCEuropeanEngine& withStepsPerYear(Size steps);
        MakeMCEuropeanEngine& withBrownianBridge(bool b = true);
        MakeMCEuropeanEngine& withSamples(Size samples);
        MakeMCEuropeanEngine& withAbsoluteTolerance(Real tolerance);
        MakeMCEuropeanEngine& withMaxSamples(Size samples);
        MakeMCEuropeanEngine& withSeed(BigNatural seed);
        MakeMCEuropeanEngine& withAntitheticVariate(bool b = true);
        // conversion to pricing engine
        operator boost::shared_ptr<PricingEngine>() const;
      private:
        boost::shared_ptr<GeneralizedBlackScholesProcess> process_;
        bool antithetic_;
        Size steps_, stepsPerYear_, samples_, maxSamples_;
        Real tolerance_;
        bool brownianBridge_;
        BigNatural seed_;
    };

    class EuropeanPathPricer : public PathPricer<Path> {
      public:
        EuropeanPathPricer(Option::Type type,
                           Real strike,
                           DiscountFactor discount);
        Real operator()(const Path& path) const;
      private:
        PlainVanillaPayoff payoff_;
        DiscountFactor discount_;
    };

	class EuropeanBarrierKOKOPathPricer: public PathPricer<Path> {
	public:
		EuropeanBarrierKOKOPathPricer(Real underlyingSpot,
			Real margin,
			Real gearing1, 
			Real gearing2,
			Real lowerBarrier,
			Real upperBarrier,
			Real lowerInBarrier,
			Real upperInBarrier,
			DiscountFactor discount):payoff_(underlyingSpot,margin,gearing1,gearing2,lowerBarrier,upperBarrier,lowerInBarrier, upperInBarrier),discount_(discount) {};
		Real operator()(const Path& path) const
		{
			QL_REQUIRE(path.length() > 0, "the path cannot be empty");
			return payoff_(path.back()) * discount_;
		};
	private:
		BarrierKOKOPayoff payoff_;
		DiscountFactor discount_;
	};

    // inline definitions

    template <class RNG, class S>
    inline
    MCEuropeanEngine<RNG,S>::MCEuropeanEngine(
             const boost::shared_ptr<GeneralizedBlackScholesProcess>& process,
             Size timeSteps,
             Size timeStepsPerYear,
             bool brownianBridge,
             bool antitheticVariate,
             Size requiredSamples,
             Real requiredTolerance,
             Size maxSamples,
             BigNatural seed)
    : MCVanillaEngine<SingleVariate,RNG,S>(process,
                                           timeSteps,
                                           timeStepsPerYear,
                                           brownianBridge,
                                           antitheticVariate,
                                           false,
                                           requiredSamples,
                                           requiredTolerance,
                                           maxSamples,
                                           seed) {}


    template <class RNG, class S>
    inline boost::shared_ptr<typename MCEuropeanEngine<RNG,S>::path_pricer_type>
    MCEuropeanEngine<RNG,S>::pathPricer() const {

		boost::shared_ptr<GeneralizedBlackScholesProcess> process =
			boost::dynamic_pointer_cast<GeneralizedBlackScholesProcess>(
			this->process_);
		QL_REQUIRE(process, "Black-Scholes process required");

		if(this->arguments_.payoff->name() == "BarrierKOKO")
		{
			boost::shared_ptr<BarrierKOKOPayoff> payoff =
				boost::dynamic_pointer_cast<BarrierKOKOPayoff>(
				this->arguments_.payoff);
			QL_REQUIRE(payoff, "KOKO option payoff failed to downcast");

			return boost::shared_ptr<
				typename MCEuropeanEngine<RNG,S>::path_pricer_type>(
				new EuropeanBarrierKOKOPathPricer(
				payoff->underlyingSpot(),
				payoff->margin(),
				payoff->gearing1(),
				payoff->gearing2(),
				payoff->lowerBarrier(),
				payoff->upperBarrier(),
				payoff->lowerInBarrier(),
				payoff->upperInBarrier(),
				process->riskFreeRate()->discount(this->timeGrid().back())));

		}
		else{
			boost::shared_ptr<PlainVanillaPayoff> payoff =
				boost::dynamic_pointer_cast<PlainVanillaPayoff>(
					this->arguments_.payoff);
			QL_REQUIRE(payoff, "non-plain payoff given");

			return boost::shared_ptr<
				typename MCEuropeanEngine<RNG,S>::path_pricer_type>(
				new EuropeanPathPricer(
				payoff->optionType(),
				payoff->strike(),
				process->riskFreeRate()->discount(this->timeGrid().back())));

		}
    }



    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>::MakeMCEuropeanEngine(
             const boost::shared_ptr<GeneralizedBlackScholesProcess>& process)
    : process_(process), antithetic_(false),
      steps_(Null<Size>()), stepsPerYear_(Null<Size>()),
      samples_(Null<Size>()), maxSamples_(Null<Size>()),
      tolerance_(Null<Real>()), brownianBridge_(false), seed_(0) {}

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withSteps(Size steps) {
        steps_ = steps;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withStepsPerYear(Size steps) {
        stepsPerYear_ = steps;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withSamples(Size samples) {
        QL_REQUIRE(tolerance_ == Null<Real>(),
                   "tolerance already set");
        samples_ = samples;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withAbsoluteTolerance(Real tolerance) {
        QL_REQUIRE(samples_ == Null<Size>(),
                   "number of samples already set");
        QL_REQUIRE(RNG::allowsErrorEstimate,
                   "chosen random generator policy "
                   "does not allow an error estimate");
        tolerance_ = tolerance;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withMaxSamples(Size samples) {
        maxSamples_ = samples;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withSeed(BigNatural seed) {
        seed_ = seed;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withBrownianBridge(bool brownianBridge) {
        brownianBridge_ = brownianBridge;
        return *this;
    }

    template <class RNG, class S>
    inline MakeMCEuropeanEngine<RNG,S>&
    MakeMCEuropeanEngine<RNG,S>::withAntitheticVariate(bool b) {
        antithetic_ = b;
        return *this;
    }

    template <class RNG, class S>
    inline
    MakeMCEuropeanEngine<RNG,S>::operator boost::shared_ptr<PricingEngine>()
                                                                      const {
        QL_REQUIRE(steps_ != Null<Size>() || stepsPerYear_ != Null<Size>(),
                   "number of steps not given");
        QL_REQUIRE(steps_ == Null<Size>() || stepsPerYear_ == Null<Size>(),
                   "number of steps overspecified");
        return boost::shared_ptr<PricingEngine>(new
            MCEuropeanEngine<RNG,S>(process_,
                                    steps_,
                                    stepsPerYear_,
                                    brownianBridge_,
                                    antithetic_,
                                    samples_, tolerance_,
                                    maxSamples_,
                                    seed_));
    }



    inline EuropeanPathPricer::EuropeanPathPricer(Option::Type type,
                                                  Real strike,
                                                  DiscountFactor discount)
    : payoff_(type, strike), discount_(discount) {
        QL_REQUIRE(strike>=0.0,
                   "strike less than zero not allowed");
    }

    inline Real EuropeanPathPricer::operator()(const Path& path) const {
        QL_REQUIRE(path.length() > 0, "the path cannot be empty");
        return payoff_(path.back()) * discount_;
    }

}


#endif
