using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WAPIWrapperCSharp;
using QuantLib;

namespace UtilityLib
{
    public class UtilityMath
    {
        // 计算index在data数组中的分位数
        // data -> 从低到高排列
        public static double QF(double[] data, double index)
        {
            double result = 0;
            int ilen = data.Length;
            List<double> lSortedHistoryPrice = data.ToList();
            lSortedHistoryPrice.Sort();
            for (result = 0; result < ilen; result++)
            {
                if (index <= lSortedHistoryPrice[(int)result])
                    break;
            }
            return result / ilen;
        }

        // 给定一个排序好的序列， 返回对应percentile的序列成员
        public static double getPercentile(double[] dData, double p)
        {
            double[] dSortedData = UtilityArray.getDoubleArraySorted(dData);
            // algo derived from Aczel pg 15 bottom
            if (p >= 100.0)
            {
                return dSortedData[dSortedData.Length - 1];
            }

            double dPosition = (double)(dSortedData.Length + 1) * p / 100.0;
            double dLeftNumber = 0.0;
            double dRightNumber = 0.0;

            double n = p * (dSortedData.Length - 1) / 100.0;

            if (dPosition >= 1)
            {
                dLeftNumber = dSortedData[(int)System.Math.Floor(n) - 1];
                dRightNumber = dSortedData[(int)System.Math.Floor(n)];
            }
            else
            {
                dLeftNumber = dSortedData[0]; // first data
                dRightNumber = dSortedData[1]; // first data
            }

            if (dLeftNumber == dRightNumber)
                return dLeftNumber;
            else
            {
                double part = n - System.Math.Floor(n);
                return dLeftNumber + part * (dRightNumber - dLeftNumber);
            }
        } 

        //得到单日超额收益数组
        public static double[] getAccessReturnOverIndex(double[] dStockPrice, double[] dIndexPrice, int iDays)
        {
            double[] dAccessReturn = null;
            int iSize = 0;
            iSize = dStockPrice.Length - iDays;
            dAccessReturn = new double[iSize];
            for (int i = 0; i < iSize; i++)
            {
                dAccessReturn[i] = (dStockPrice[i + iDays] - dStockPrice[i]) / dStockPrice[i] - (dIndexPrice[i + iDays] - dIndexPrice[i]) / dIndexPrice[i];
            }
            return dAccessReturn;
        }

        // 计算超额收益组（多周期）
        public static List<List<double>> getMultiPeriodExcessReturnOverIndex(double[] dStockPrice, double[] dIndexPrice, int[] iDays)
        {
            int iSize = dStockPrice.Length;
            List<List<double>> plResult = new List<List<double>>();
 
            for (int i = 0; i < iDays.Length; i++)
            {
                List<double> lResult = new List<double>();
                double[] dTemp = null;
                dTemp = getAccessReturnOverIndex(dStockPrice, dIndexPrice, iDays[i]);
                for (int j = 0; j < dTemp.Length; j++)
                {
                    lResult.Add(dTemp[j]); 
                }
                plResult.Add(lResult);
            }

            return plResult;
        }
       
        // 计算分位数（多周期）
        public static List<List<double>> getMultiPeriodFractile(List<List<double>> plExcessReturn, int[] iDays)
        {
            // 从第301天起计算分位数
            int iStart = 300;

            List<List<double>> plResult = new List<List<double>>();

            for (int i = 0; i < iDays.Length; i++)
            {
                List<double> lResult = new List<double>();

                for (int j = iStart; j < plExcessReturn[i].Count; j++)
                {
                    double dNow = plExcessReturn[i][j];
                    double[] dHist = new double[j];
                    for (int k = 0; k < j; k++)
                    {
                        dHist[k] = plExcessReturn[i][k];
                    }
                    lResult.Add(QF(dHist, dNow));
                }
                plResult.Add(lResult);
            }
            return plResult;
        }

        public static double getIHArbitrageYield(double dOptExePrice, double dFutPrice, double dETFPrice, double dPutPrice, double dCallPrice)
        {
            double dYield = 0;

            dYield = (dOptExePrice - dFutPrice / 1000 - dPutPrice + dCallPrice) / dETFPrice;

            return dYield;
        }        
    }
}
