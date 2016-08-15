/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 Copyright (C) 2006, 2007 Ferdinando Ametrano

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


#ifndef qla_optimization_hpp
#define qla_optimization_hpp

#include <oh/libraryobject.hpp>

#include <ql/types.hpp>

namespace QuantLib {
    class EndCriteria;
    class OptimizationMethod;
    class LineSearch;
	class Array;
	class Matrix;
	class OneDimensionalPolynomialDegreeN;
	class NonhomogeneousBoundaryConstraint;
	class Problem;
	class CostFunction;
	class Constraint;
}

namespace QuantLibAddin {

    inline std::string qlSecondsToString(QuantLib::Real elapsed) {
        QuantLib::Integer seconds = static_cast<QuantLib::Integer>(elapsed);
        QuantLib::Integer hours = seconds/3600;
        seconds -= hours * 3600;
        QuantLib::Integer minutes = seconds/60;
        seconds -= minutes * 60;
        std::ostringstream out;
        out << hours << ":" << minutes << ":" << seconds;
        return out.str();
    }

	OH_LIB_CLASS(CostFunction, QuantLib::CostFunction);
	OH_LIB_CLASS(Constraint, QuantLib::Constraint);
	OH_LIB_CLASS(Problem, QuantLib::Problem);

    class EndCriteria :
        public ObjectHandler::LibraryObject<QuantLib::EndCriteria> {
      public:
        EndCriteria(const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
                    QuantLib::Size maxIterations,
                    QuantLib::Size maxStationaryStateIterations,
                    QuantLib::Real rootEpsilon,
                    QuantLib::Real functionEpsilon,
                    QuantLib::Real gradientNormEpsilon,
                    bool permanent);
    };

    OH_LIB_CLASS(OptimizationMethod, QuantLib::OptimizationMethod);

    class Simplex : public OptimizationMethod {
      public:
        Simplex(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            QuantLib::Real lambda,
            bool permanent);
    };

    class LevenbergMarquardt : public OptimizationMethod {
      public:
        LevenbergMarquardt(const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
                           QuantLib::Real epsfcn,
                           QuantLib::Real xtol,
                           QuantLib::Real gtol,
                           bool permanent);
    };
   
    OH_LIB_CLASS(LineSearch, QuantLib::LineSearch);

    class ArmijoLineSearch : public LineSearch {
      public:
        ArmijoLineSearch(const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
                         QuantLib::Real eps,
                         QuantLib::Real alpha,
                         QuantLib::Real beta,
                         bool permanent);
    };

    OH_OBJ_CLASS(LineSearchBasedMethod, OptimizationMethod);

    class ConjugateGradient : public LineSearchBasedMethod {
      public:
        ConjugateGradient(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::LineSearch>&,
            bool permanent);
    };

    class SteepestDescent : public LineSearchBasedMethod {
      public:
        SteepestDescent(
            const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
            const boost::shared_ptr<QuantLib::LineSearch>&,
            bool permanent);
    };


	class OneDimensionalPolynomialDegreeN:
		public CostFunction{
	public:
		OneDimensionalPolynomialDegreeN(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			const std::vector<QuantLib::Real> coeff,
			bool permanent);
	}; 


	class NonhomogeneousBoundaryConstraint:
		public Constraint{
	public:
		NonhomogeneousBoundaryConstraint(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			const std::vector<QuantLib::Real> low,
			const std::vector<QuantLib::Real> high,
			bool permanent);
	};

	class OptimizationProblem:
		public Problem{
	public:
		OptimizationProblem(
			const boost::shared_ptr<ObjectHandler::ValueObject>& properties,
			boost::shared_ptr<QuantLib::CostFunction> costFunction,
			boost::shared_ptr<QuantLib::Constraint> constraint,
			const std::vector<QuantLib::Real> initValues,
			bool permanent
			);

	};

	QuantLib::Matrix optimizedResult(
		boost::shared_ptr<QuantLib::Problem> problem,
		boost::shared_ptr<QuantLib::EndCriteria> endCriteria,
		boost::shared_ptr<QuantLib::OptimizationMethod> optimMethod);
	
}

#endif
