/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*
 Copyright (C) 2006, 2012 Ferdinando Ametrano
 Copyright (C) 2006 Cristina Duminuco
 Copyright (C) 2007 Eric Ehlers

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

#ifndef qla_pricingengine_hpp
#define qla_pricingengine_hpp

#include <oh/libraryobject.hpp>

#include <ql/option.hpp>

namespace QuantLib {
    class Date;
    class SimpleQuote;
    class AffineModel;
    class MarketModelFactory;
    class SwaptionVolatilityStructure;
    class OptionletVolatilityStructure;
    class BlackCapFloorEngine;
    class AnalyticCapFloorEngine;
    class MarketModelCapFloorEngine;
    class BlackCalculator;
    class StrikedTypePayoff;
    class PricingEngine;
    class Quote;
    class YieldTermStructure;
    class DayCounter;
    class DiscountingBondEngine;
    class DiscountingSwapEngine;
    class GeneralizedBlackScholesProcess;
	class MCVanillaParams;

	// aladdin
	class MCParams;
    template <class T>
    class Handle;
}

namespace QuantLibAddin {

    class PricingEngine : public ObjectHandler::LibraryObject<QuantLib::PricingEngine> {
      public:
        // PricingEngines - without timesteps
        PricingEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const std::string& engineID,
            const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
            bool permanent);
        // PricingEngines - with timesteps
        PricingEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const std::string& engineID,
            const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
            const long& timeSteps,
            bool permanent);
		//PricingEngines - with Monte Carlo variants - aladdin
		PricingEngine::PricingEngine(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			const std::string& engineID,
			const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
			const long& timeSteps,
			const bool& brownianBridge,
			const bool& antitheticVariate,
			const long& Samples,
			const double& absoluteTolerance,
			const long& maxSamples,
			const long& seed,
			bool permanent);
		PricingEngine::PricingEngine(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			const std::string& engineID,
			const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
			const boost::shared_ptr<QuantLib::MCVanillaParams>& pMCVanillaParams,
			bool permanent);
      protected:
        OH_LIB_CTOR(PricingEngine, QuantLib::PricingEngine);
    };

    class DiscountingSwapEngine : public PricingEngine {
      public:
        DiscountingSwapEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>&,
            bool includeSettlementDateFlows,
            const QuantLib::Date& settlementDate,
            const QuantLib::Date& npvDate,
            bool permanent);
    };

    class BlackSwaptionEngine : public PricingEngine {
      public:
          BlackSwaptionEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>&,
            const QuantLib::Handle<QuantLib::Quote>& vol,
            const QuantLib::Real displacement,
            const QuantLib::DayCounter& dayCounter,
            bool permanent);
          BlackSwaptionEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>&,
            const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>&,
            const QuantLib::Real displacement,
            bool permanent);
    };

    class BlackCapFloorEngine : public PricingEngine {
      public:
        BlackCapFloorEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>&,
            const QuantLib::Handle<QuantLib::Quote>& vol,
            const QuantLib::Real displacement,
            const QuantLib::DayCounter& dayCounter,
            bool permanent);
        BlackCapFloorEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>&,
            const QuantLib::Handle<QuantLib::OptionletVolatilityStructure>&,
            const QuantLib::Real displacement,
            bool permanent);
    };

    class AnalyticCapFloorEngine : public PricingEngine {
      public:
        AnalyticCapFloorEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::AffineModel>& model,
            bool permanent);
    };

    class BlackCalculator : public ObjectHandler::LibraryObject<QuantLib::BlackCalculator> {
      public:
        BlackCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            QuantLib::Option::Type optionType,
            QuantLib::Real strike,
            QuantLib::Real forward,
            QuantLib::Real variance,
            QuantLib::DiscountFactor discount,
            bool permanent);
        BlackCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::StrikedTypePayoff>& payoff,
            QuantLib::Real forward,
            QuantLib::Real variance,
            QuantLib::DiscountFactor discount,
            bool permanent);
      protected:
        OH_LIB_CTOR(BlackCalculator, QuantLib::BlackCalculator);
    };

    class BlackScholesCalculator : public BlackCalculator {
      public:
        BlackScholesCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            QuantLib::Option::Type optionType,
            QuantLib::Real strike,
            QuantLib::Real spot,
            QuantLib::DiscountFactor growth,
            QuantLib::Real variance,
            QuantLib::DiscountFactor discount,
            bool permanent);
        BlackScholesCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::StrikedTypePayoff>& payoff,
            QuantLib::Real spot,
            QuantLib::DiscountFactor growth,
            QuantLib::Real variance,
            QuantLib::DiscountFactor discount,
            bool permanent);
    };

    class BondEngine : public PricingEngine {
      public:
          BondEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
            bool permanent);
    };


	OH_LIB_CLASS(MCParams, QuantLib::MCParams);
	class MCVanillaParams:  public MCParams{
	public:	
		MCVanillaParams( 
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			QuantLib::Size timeSteps,
			//QuantLib::Size timeStepsPerYear,
			bool brownianBridge,
			bool antitheticVariate,
			bool controlVariate,
			QuantLib::Size requiredSamples,
			QuantLib::Real requiredTolerance,
			QuantLib::Size maxSamples,
			QuantLib::BigNatural seed,
			bool permanent);	
	};
}

#endif
