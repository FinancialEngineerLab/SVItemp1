using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using WAPIWrapperCSharp;

namespace UtilityLib
{ 
    //整个project的wind的全局变量
    public class GlobalWind
    {
        public static WindAPI w = new WindAPI();

        public static void windEnsureStart()
        {
            if (!GlobalWind.w.isconnected())
            {
                if (GlobalWind.w.start() != 0)
                {
                    throw new Exception("windEnsureStart: wind fails to start/connect");
                }
            }            
        }

        public static void windEnsureNoErr(WindData wd)
        {
            if (wd.errorCode != 0)
            {
                throw new Exception("windEnsureConnect: " + wd.GetErrorMsg());
            }
        }

        public static string windCodeCheck(string strWindCode, string strType)
        {
            int iTypeLens = strType.Length;
            int iCodeLens = strWindCode.Length;
            if (iCodeLens <= iTypeLens)
            {
                return strWindCode + strType;
            }
            string strGetType = strWindCode.Substring(iCodeLens - iTypeLens, iTypeLens);
            if (strGetType == strType)
            {
                return strWindCode;
            }
            else
            {
                return strWindCode + strType;
            }
        }
    }
}
