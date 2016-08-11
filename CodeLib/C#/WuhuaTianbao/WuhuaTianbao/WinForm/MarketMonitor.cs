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
using System.Runtime.InteropServices;
using UtilityLib;
using System.Configuration;
using WuhuaTianbao.WinForm;
using System.Collections.Specialized;

namespace WuhuaTianbao
{
    public partial class MarketMonitor : Form
    {
        private bool bWorking = false;
        private bool bAlert = false;
        private int iInterval = 0;
        private System.Threading.Thread t1;
        private System.Threading.Thread t2;

        public MarketMonitor()
        {
            InitializeComponent();
            GlobalWind.windEnsureStart();
        }

        private void buttonStartMonitor_Click(object sender, EventArgs e)
        {
            int iStockNum = int.Parse(textBox_Count.Text);
            int iCount = 0;
            double dLimit = double.Parse(textBox_UpperBound.Text) / 100;           
            object objSender;
            List<List<string>> listListWindCode;
            List<object> listInputParams;
            List<string> lIndustryName;

            iInterval = int.Parse(textBox_Freq.Text);

            lIndustryName = UtilityTools.LoadSelectedItem(checkedListBox_Shenwan);
            listListWindCode = ConfigHelper.FetchShenWanIndustryCode(lIndustryName);

            if (!volumneCheck(listListWindCode))
            {
                MessageBox.Show("一周提取数据量超过50万条，建议减少选择板块数量或提取数据频率！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }

            if (dLimit < 0)
            {
                MessageBox.Show("输入值为板块个股涨跌幅限制条件的绝对值，故请输入正值！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }

            if (dLimit > 0.10)
            {
                MessageBox.Show("提示上涨幅度应小于10%，请检查！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }

            if (!UtilityTime.isTradeHour(DateTime.Now))
            {
                MessageBox.Show("当前不是交易时间！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }

            /*传递参数*/
            listInputParams = new List<object>();
            listInputParams.Add(iStockNum);
            listInputParams.Add(dLimit);
            listInputParams.Add(listListWindCode);
            listInputParams.Add(lIndustryName);
            objSender = (object)listInputParams;

            bWorking = true;
            for (int i = 0; i < listListWindCode.Count(); i++)
            {
                iCount += listListWindCode[i].Count();
            }
            label5.Text = "总计" + iCount + "只股票正在监控.....";

            CancelThread();
            t1 = new System.Threading.Thread(new ParameterizedThreadStart(priceMonitor));  
            t2 = new System.Threading.Thread(new ParameterizedThreadStart(UtilityThread.BackgroundFlashing));
            t1.IsBackground = true;
            t2.IsBackground = true;
            t1.Start(objSender);
            t2.Start((object)label5);
        }

        private bool volumneCheck(List<List<string>> listListWindCode)
        {
            int iCount = 0;
            int iSum = 500000;

            for (int i = 0; i < listListWindCode.Count(); i++)
            {
                iCount += listListWindCode[i].Count();
            }

            if (iCount * 4 * 60 * iInterval * 5 > iSum)
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        private void priceMonitor(Object objSender)
        {
            int iLimitNum;   
            double dLimit;
            List<List<string>> listListWindCode;   
            List<string> listIndustryName;
            DataTable dtResult;

            iLimitNum = (int)((List<object>)objSender)[0];             // 达标个股数
            dLimit = (double)((List<object>)objSender)[1];              // 个股涨幅条件
            listListWindCode = (List<List<string>>)((List<object>)objSender)[2];    // 板块成分代码
            listIndustryName = (List<string>)((List<object>)objSender)[3];          // 板块名称

            while (bWorking)
            {
                // 处于交易时间
                if (UtilityTime.isTradeHour(DateTime.Now))
                {
                    for (int i = 0; i < listListWindCode.Count(); i++)
                    {
                        dtResult = triggerAlert(listListWindCode[i], iLimitNum, dLimit);
                        if (dtResult.Rows.Count > 0)
                        {
                            MarketMonitorAlert mmh = new MarketMonitorAlert(listIndustryName[i], dtResult);
                            mmh.ShowDialog();
                            // mmh.TopMost = true;
                        }
                    }
                    
                }
                if (DateTime.Now > DateTime.Now.Date.AddHours(15))
                {
                    MessageBox.Show("今日已收盘！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                    return;
                }
                System.Threading.Thread.Sleep(60 / iInterval * 1000);
            }
        }

        private void buttonPauseMonitor_Click(object sender, EventArgs e)
        {
            bWorking = false;

            label5.Text = "暂停中...........";
            label5.BackColor = Color.Transparent;
            CancelThread();
        }

        private void CancelThread()
        {
            if (t1 != null)
            {
                t1.Abort();
            }
            if (t2 != null)
            {
                t2.Abort();
            }
        }

        private DataTable triggerAlert(List<string> listWindCode, int iLimitNum, double dLimit)
        {      
            List<double> listPctChg;
            DataTable dtResult;
            DataTable dtPrice;
            DataView dvResult;

            // 获取价格并排序（从小到大）
            listPctChg = UtilityWindData.getWindPctChg(listWindCode).ToList();

            // 创建表格
            dtResult = new DataTable("Stocks Fits Conditions");
            dtResult.Columns.Add("触发时间", Type.GetType("System.DateTime"));
            dtResult.Columns.Add("股票代码", Type.GetType("System.String"));
            dtResult.Columns.Add("股票名称", Type.GetType("System.String"));
            dtResult.Columns.Add("涨跌幅", Type.GetType("System.String"));

            dtPrice = new DataTable("Price");
            dtPrice.Columns.Add("股票代码", Type.GetType("System.String"));
            dtPrice.Columns.Add("涨跌幅", Type.GetType("System.Double"));
            for (int i = 0; i < listWindCode.Count; i++)
            {
                DataRow dr = dtPrice.NewRow();
                dr["股票代码"] = listWindCode[i];
                dr["涨跌幅"] = listPctChg[i];
                dtPrice.Rows.Add(dr);
            }

            dvResult = dtPrice.DefaultView;
            dvResult.Sort = "涨跌幅 DESC";


            // 价格符合条件，并且前刻未触发
            if (double.Parse(dvResult[iLimitNum - 1]["涨跌幅"].ToString()) > dLimit)
            {
                if (bAlert == false)
                {
                    bAlert = true;
                    for (int i = 0; i < dtPrice.Rows.Count; i++)
                    {
                        if(double.Parse(dvResult[i]["涨跌幅"].ToString()) > dLimit)
                        {
                            DataRow dr = dtResult.NewRow();
                            dr["触发时间"] = DateTime.Now;
                            dr["股票代码"] = dvResult[i]["股票代码"];
                            dr["涨跌幅"] = Double.Parse(dvResult[i]["涨跌幅"].ToString()).ToString("0.00%");
                            dr["股票名称"] = UtilityWindData.getStockName(dr["股票代码"].ToString());
                            dtResult.Rows.Add(dr);
                        }
                    }
                }
            }
            else if (double.Parse(dvResult[dtPrice.Rows.Count - 1 - iLimitNum]["涨跌幅"].ToString()) < -dLimit)
            {
                if (bAlert == false)
                {
                    bAlert = true;
                    for (int i = dtPrice.Rows.Count - 1; i >= 0; i--)
                    {
                        if (double.Parse(dvResult[i]["涨跌幅"].ToString()) < -dLimit)
                        {
                            DataRow dr = dtResult.NewRow();
                            dr["触发时间"] = DateTime.Now;
                            dr["股票代码"] = dvResult[i]["股票代码"];
                            dr["涨跌幅"] = Double.Parse(dvResult[i]["涨跌幅"].ToString()).ToString("0.00%");
                            dr["股票名称"] = UtilityWindData.getStockName(dr["股票代码"].ToString());
                            dtResult.Rows.Add(dr);
                        }
                    }
                }
            }
            else
            {
                bAlert = false;
            }

            return dtResult;
        }
    }
}
