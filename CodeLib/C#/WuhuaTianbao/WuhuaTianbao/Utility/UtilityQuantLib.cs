using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using QuantLib;

namespace WuhuaTianbao
{
    class UtilityQuantLib
    {
        
        

        public double impliedVolatility(double dTargetValue, double dAccuracy, uint iMaxEvaluations, double dMinVol, double dMaxVol)
        {
            double dImpliedVolatility = 0;

            CalibrationHelper ch = new CalibrationHelper();
            dImpliedVolatility = ch.impliedVolatility(dTargetValue, dAccuracy, iMaxEvaluations, dMinVol, dMaxVol);

            return dImpliedVolatility;
        }
    }
}
