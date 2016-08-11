using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Threading;
using System.Timers;
using System.Reflection;
using System.Runtime.InteropServices;
using UtilityLib;

namespace WuhuaTianbao
{
    public partial class OptionMonitor : Form
    {
        private bool bFlag = false;
        private string strFutContract = null;
        private string strCallOption = null;
        private string strPutOption = null;
        private static string strCode = null;
        public delegate void SendToParent();
        private double dExePrice = 0;
        private double dAlertVal = 0;

        public OptionMonitor(string strFutContract_, string strCallOption_, string strPutOption_, double dAlertVal_)
        {
            InitializeComponent();

            object objCode = null;
            strFutContract = strFutContract_;
            strCallOption = strCallOption_;
            strPutOption = strPutOption_;
            strCode = strFutContract + "," + strCallOption + "," + strPutOption;
            dAlertVal = dAlertVal_;

            objCode = (object)strCode;

            label42.Text = strFutContract;
            label43.Text = strCallOption;
            label44.Text = strPutOption;

            bFlag = true;
            GlobalWind.windEnsureStart();

            object[, ] objOptionInfo = UtilityWindData.getOptionInfo(strCallOption);
            dExePrice = (double)(objOptionInfo[0, 0]);
            label76.Text = UtilityWindData.getFutureLastTradingDate(strFutContract).ToShortDateString();
            label73.Text = ((DateTime)(objOptionInfo[0,1])).ToShortDateString();
            label77.Text = dExePrice.ToString("0.000");

            System.Threading.Thread t1 = new System.Threading.Thread(new ParameterizedThreadStart(UpdateScreen));
            t1.IsBackground = true;
            t1.Start(objCode);
        }

        private void UpdateScreen(object objCode)
        {
            while (true == bFlag)
            {
                double[,] dLatestData = UtilityWindData.getWindOptionBuyAndSellRTD(objCode.ToString());
                double dETFPrice = UtilityWindData.getAskOnePrice("510050.SH");
                double dYield = UtilityMath.getIHArbitrageYield(dExePrice, dLatestData[0, 5], dETFPrice, dLatestData[2, 5], dLatestData[1, 0]);
                double dSpread = UtilityWindData.getLiveSpread(strFutContract);

                if (dYield >= dAlertVal)
                {
                    UtilityTools.BeepHint();
                }

                UtilityThread.SetControlPropertyValue(label84, "text", dSpread.ToString("0.00"));
                //**************************************** 收益率 ******************************************************//
                UtilityThread.SetControlPropertyValue(label75, "text", dYield.ToString("0.00%"));
                //**************************************** 50ETF ******************************************************//
                UtilityThread.SetControlPropertyValue(label79, "text", dETFPrice.ToString("0.000"));
                //**************************************** 期货合约 ******************************************************//
                UtilityThread.SetControlPropertyValue(label92, "text", dLatestData[0, 0].ToString("0.000"));
                UtilityThread.SetControlPropertyValue(label69, "text", dLatestData[0, 5].ToString("0.000"));
                UtilityThread.SetControlPropertyValue(label83, "text", dLatestData[0, 10].ToString());
                UtilityThread.SetControlPropertyValue(label64, "text", dLatestData[0, 15].ToString());
                //*************************************** 认购期权合约 ****************************************************//
                UtilityThread.SetControlPropertyValue(label62, "text", dLatestData[1, 0].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label60, "text", dLatestData[1, 1].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label54, "text", dLatestData[1, 2].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label46, "text", dLatestData[1, 3].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label41, "text", dLatestData[1, 4].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label26, "text", dLatestData[1, 5].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label27, "text", dLatestData[1, 6].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label28, "text", dLatestData[1, 7].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label29, "text", dLatestData[1, 8].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label30, "text", dLatestData[1, 9].ToString("0.0000"));

                UtilityThread.SetControlPropertyValue(label40, "text", dLatestData[1, 10].ToString());
                UtilityThread.SetControlPropertyValue(label39, "text", dLatestData[1, 11].ToString());
                UtilityThread.SetControlPropertyValue(label38, "text", dLatestData[1, 12].ToString());
                UtilityThread.SetControlPropertyValue(label37, "text", dLatestData[1, 13].ToString());
                UtilityThread.SetControlPropertyValue(label36, "text", dLatestData[1, 14].ToString());
                UtilityThread.SetControlPropertyValue(label21, "text", dLatestData[1, 15].ToString());
                UtilityThread.SetControlPropertyValue(label22, "text", dLatestData[1, 16].ToString());
                UtilityThread.SetControlPropertyValue(label23, "text", dLatestData[1, 17].ToString());
                UtilityThread.SetControlPropertyValue(label24, "text", dLatestData[1, 18].ToString());
                UtilityThread.SetControlPropertyValue(label25, "text", dLatestData[1, 19].ToString());
                //*************************************** 认沽期权合约 ****************************************************//
                UtilityThread.SetControlPropertyValue(label15, "text", dLatestData[2, 0].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label14, "text", dLatestData[2, 1].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label13, "text", dLatestData[2, 2].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label12, "text", dLatestData[2, 3].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label11, "text", dLatestData[2, 4].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label6, "text", dLatestData[2, 5].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label7, "text", dLatestData[2, 6].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label8, "text", dLatestData[2, 7].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label9, "text", dLatestData[2, 8].ToString("0.0000"));
                UtilityThread.SetControlPropertyValue(label10, "text", dLatestData[2, 9].ToString("0.0000"));

                UtilityThread.SetControlPropertyValue(label58, "text", dLatestData[2, 10].ToString());
                UtilityThread.SetControlPropertyValue(label57, "text", dLatestData[2, 11].ToString());
                UtilityThread.SetControlPropertyValue(label56, "text", dLatestData[2, 12].ToString());
                UtilityThread.SetControlPropertyValue(label55, "text", dLatestData[2, 13].ToString());
                UtilityThread.SetControlPropertyValue(label53, "text", dLatestData[2, 14].ToString());
                UtilityThread.SetControlPropertyValue(label48, "text", dLatestData[2, 15].ToString());
                UtilityThread.SetControlPropertyValue(label49, "text", dLatestData[2, 16].ToString());
                UtilityThread.SetControlPropertyValue(label50, "text", dLatestData[2, 17].ToString());
                UtilityThread.SetControlPropertyValue(label51, "text", dLatestData[2, 18].ToString());
                UtilityThread.SetControlPropertyValue(label52, "text", dLatestData[2, 19].ToString());

                System.Threading.Thread.Sleep(1000);
            }            
        }

        

        

        private void label10_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label10);
        }

        private void label9_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label9);
        }

        private void label8_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label8);
        }

        private void label7_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label7);
        }

        private void label6_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label6);
        }

        private void label52_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label52);
        }

        private void label51_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label51);
        }

        private void label50_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label50);
        }

        private void label49_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label49);
        }

        private void label48_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label48);
        }

        private void label15_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label15);
        }

        private void label14_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label14);
        }

        private void label13_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label13);
        }

        private void label12_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label12);
        }

        private void label11_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label11);
        }

        private void label58_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label58);
        }

        private void label57_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label57);
        }

        private void label56_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label56);
        }

        private void label55_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label55);
        }

        private void label53_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label53);
        }

        private void label69_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label69);
        }

        private void label64_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label64);
        }

        private void label92_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label92);
        }

        private void label83_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label83);
        }

        private void label30_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label30);
        }

        private void label25_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label25);
        }

        private void label29_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label29);
        }

        private void label24_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label24);
        }

        private void label28_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label28);
        }

        private void label23_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label23);
        }

        private void label27_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label27);
        }

        private void label22_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label22);
        }

        private void label26_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label26);
        }

        private void label21_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label21);
        }

        private void label62_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label62);
        }

        private void label40_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label40);
        }

        private void label60_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label60);
        }

        private void label39_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label39);
        }

        private void label54_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label54);
        }

        private void label38_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label38);
        }

        private void label46_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label46);
        }

        private void label37_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label37);
        }

        private void label41_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label41);
        }

        private void label36_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label36);
        }

        private void label79_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label79);
        }

        private void label75_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label75);
        }

        private void label84_TextChanged(object sender, EventArgs e)
        {
            UtilityThread obj = new UtilityThread();
            Thread th = new Thread(new ParameterizedThreadStart(obj.ContentChangeEffect));
            th.IsBackground = true;
            th.Start((object)label84);
        }

        private void OptionMonitor_FormClosing(object sender, FormClosingEventArgs e)
        {
            bFlag = false;
        }
    }
}
