/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*
 Copyright (C) 2006, 2007, 2012 Ferdinando Ametrano
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

#include <qlo/pricingengines.hpp>
#include <qlo/swaption.hpp>
#include <qlo/enumerations/factories/pricingenginesfactory.hpp>

#include <ql/pricingengines/blackscholescalculator.hpp>
#include <ql/pricingengines/capfloor/analyticcapfloorengine.hpp>
#include <ql/pricingengines/capfloor/blackcapfloorengine.hpp>
#include <ql/pricingengines/swap/discountingswapengine.hpp>
#include <ql/pricingengines/bond/discountingbondengine.hpp>
#include <ql/processes/blackscholesprocess.hpp>
#include <ql/pricingengines/mcsimulation.hpp>

namespace QuantLibAddin {

    // PricingEngines - without timesteps
    PricingEngine::PricingEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const std::string& engineID,
            const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
            bool permanent) : ObjectHandler::LibraryObject<QuantLib::PricingEngine>(properties, permanent)
    {
        libraryObject_ = ObjectHandler::createPricingEngine(engineID, process);
    }

    // PricingEngines - with timesteps
    PricingEngine::PricingEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const std::string& engineID,
            const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
            const long& timeSteps,
            bool permanent) : ObjectHandler::LibraryObject<QuantLib::PricingEngine>(properties, permanent)
    {
        libraryObject_ = ObjectHandler::createPricingEngine(engineID, process, timeSteps);
    }
	//PricingEngines - with timesteps and Monte Carlo variants - aladdin
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
		bool permanent): ObjectHandler::LibraryObject<QuantLib::PricingEngine>(properties,permanent)
	{
		libraryObject_=ObjectHandler::createPricingEngine(engineID,process,timeSteps,brownianBridge,antitheticVariate,Samples,absoluteTolerance,maxSamples,seed);
	}

	PricingEngine::PricingEngine(
		const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
		const std::string& engineID,
		const boost::shared_ptr<QuantLib::GeneralizedBlackScholesProcess>& process,
		const boost::shared_ptr<QuantLib::MCVanillaParams>& pMCVanillaParams,
		bool permanent): ObjectHandler::LibraryObject<QuantLib::PricingEngine>(properties,permanent)
	{
		libraryObject_=ObjectHandler::createPricingEngine(engineID,
														  process,
														  pMCVanillaParams->getTimeSteps(),
														  pMCVanillaParams->getBrownianBridge(),
														  pMCVanillaParams->getAntitheticVariate(),
														  pMCVanillaParams->getRequiredSamples(),
														  pMCVanillaParams->getRequiredTolerance(),
														  pMCVanillaParams->getMaxSamples(),
														  pMCVanillaParams->getSeed());
	}



    DiscountingSwapEngine::DiscountingSwapEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& hYTS,
        bool includeSettlementDateFlows,
        const QuantLib::Date& settlementDate,
        const QuantLib::Date& npvDate,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::DiscountingSwapEngine(hYTS, includeSettlementDateFlows,
                                            settlementDate, npvDate));
    }

    BlackSwaptionEngine::BlackSwaptionEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& hYTS,
        const QuantLib::Handle<QuantLib::Quote>& vol,
        const QuantLib::Real displacement,
        const QuantLib::DayCounter& dayCounter,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::BlackSwaptionEngine(hYTS, vol, dayCounter, displacement));
    }

    BlackSwaptionEngine::BlackSwaptionEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& hYTS,
        const QuantLib::Handle<QuantLib::SwaptionVolatilityStructure>& vol,
        const QuantLib::Real displacement,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::BlackSwaptionEngine(hYTS, vol, displacement));
    }

    BlackCapFloorEngine::BlackCapFloorEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& hYTS,
        const QuantLib::Handle<QuantLib::Quote>& vol,
        const QuantLib::Real displacement,
        const QuantLib::DayCounter& dayCounter,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::BlackCapFloorEngine(hYTS, vol, dayCounter, displacement));
    }

    BlackCapFloorEngine::BlackCapFloorEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const QuantLib::Handle<QuantLib::YieldTermStructure>& hYTS,
        const QuantLib::Handle<QuantLib::OptionletVolatilityStructure>& vol,
        const QuantLib::Real displacement,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
			QuantLib::BlackCapFloorEngine(hYTS, vol, displacement));
    }

    AnalyticCapFloorEngine::AnalyticCapFloorEngine(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const boost::shared_ptr < QuantLib::AffineModel >& model,
        bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::AnalyticCapFloorEngine(model));
    }

    BlackCalculator::BlackCalculator(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        QuantLib::Option::Type optionType,
        QuantLib::Real strike,
        QuantLib::Real forward,
        QuantLib::Real stdDev,
        QuantLib::DiscountFactor discount,
        bool permanent)
        : ObjectHandler::LibraryObject<QuantLib::BlackCalculator>(properties, permanent) {
        libraryObject_ = boost::shared_ptr<QuantLib::BlackCalculator>(new
            QuantLib::BlackCalculator(optionType, strike,
                                      forward, stdDev, discount));
    }

    BlackCalculator::BlackCalculator(
        const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
        const boost::shared_ptr<QuantLib::StrikedTypePayoff>& payoff,
        QuantLib::Real forward,
        QuantLib::Real stdDev,
        QuantLib::DiscountFactor discount,
        bool permanent)
        : ObjectHandler::LibraryObject<QuantLib::BlackCalculator>(properties, permanent) {
        libraryObject_ = boost::shared_ptr<QuantLib::BlackCalculator>(new
            QuantLib::BlackCalculator(payoff,
                                      forward, stdDev, discount));
    }

    BlackScholesCalculator::BlackScholesCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            QuantLib::Option::Type optionType,
            QuantLib::Real strike,
            QuantLib::Real spot,
            QuantLib::DiscountFactor growth,
            QuantLib::Real stdDev,
            QuantLib::DiscountFactor discount,
            bool permanent) : BlackCalculator(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::BlackCalculator>(new
            QuantLib::BlackScholesCalculator(optionType, strike,
                                             spot, growth, stdDev, discount));
    }

    BlackScholesCalculator::BlackScholesCalculator(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::StrikedTypePayoff>& payoff,
            QuantLib::Real spot,
            QuantLib::DiscountFactor growth,
            QuantLib::Real stdDev,
            QuantLib::DiscountFactor discount,
            bool permanent) : BlackCalculator(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::BlackCalculator>(new
            QuantLib::BlackScholesCalculator(payoff,
                                             spot, growth, stdDev, discount));
    }

    BondEngine::BondEngine(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const QuantLib::Handle<QuantLib::YieldTermStructure>& discountCurve,
            bool permanent) : PricingEngine(properties, permanent)
    {
        libraryObject_ = boost::shared_ptr<QuantLib::PricingEngine>(new
            QuantLib::DiscountingBondEngine(discountCurve));
    }


	MCVanillaParams::MCVanillaParams(
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
		bool permanent):MCParams(properties, permanent)
	{
		libraryObject_ = boost::shared_ptr<QuantLib::MCParams>(new
			QuantLib::MCVanillaParams( timeSteps,
										QL_NULL_INTEGER,
										brownianBridge,
										antitheticVariate,
										controlVariate,
										requiredSamples,
										requiredTolerance,
										maxSamples,
										seed));
	}
}

