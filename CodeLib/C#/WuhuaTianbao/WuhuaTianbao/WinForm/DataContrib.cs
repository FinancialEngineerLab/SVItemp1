using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Configuration;
using UtilityLib;
using System.IO;
using System.Collections.Specialized;
using WAPIWrapperCSharp;

namespace WuhuaTianbao
{
    public partial class DataContrib : Form
    {
        public DataContrib()
        {
            InitializeComponent();
        }

        private void IndustrySave_Click(object sender, EventArgs e)
        {
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string[] strCode = new string[NCSection.Count - 1];
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                strCode[i] = NCSection[i];
            }
            string strWindCode = UtilityArray.getCodeConnectByComma(strCode);
            int iIndustryNumber = int.Parse(NCSection["number"].ToString());

            // Save today's data

            DateTime dtBegin = dateTimePicker1.Value.Date;
            DateTime dtEnd = dateTimePicker2.Value.Date; ;
            string strQuery = null;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "industry_close"))
            {
                return;
            }

            WindData wd = UtilityWindData.getWindHistoryPrice(strWindCode, dtBegin, dtEnd, "close");
            double[,] dIndustryIndex = ((double[,])wd.getDataByFunc("wsd"));
            DateTime[] dtDateArray = wd.timeList;

            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtDateArray.Length; i++)
            {

                strQuery = "insert into industry_close values('" + dtDateArray[i].ToString() + "'";
                for (int j = 0; j < iIndustryNumber; j++)
                {
                    strQuery = strQuery + ",'" + dIndustryIndex[i, j].ToString() + "'";
                }
                strQuery = strQuery + ")";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            if (lsQuery.Count != 1)
            {
                sqlConn.BatchInsertDBMySql(lsQuery);
            }
            else
            {
                sqlConn.Insert(lsQuery[0]);
            }
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void IndexSave_Click(object sender, EventArgs e)
        {
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("IndexNameToCode");
            string[] strCode = new string[NCSection.Count - 1];
            for (int i = 0; i < NCSection.Count - 1; i++)
            {
                strCode[i] = NCSection[i];
            }
            string strWindCode = UtilityArray.getCodeConnectByComma(strCode);
            int iNumber = int.Parse(NCSection["number"].ToString());
             
            DateTime dtBegin = dateTimePicker3.Value.Date;
            DateTime dtEnd = dateTimePicker4.Value.Date; ;
            string strQuery = null;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "index_close"))
            {
                return;
            }
                
            WindData wd = UtilityWindData.getWindHistoryPrice(strWindCode, dtBegin, dtEnd, "close");
            double[,] dIndex = ((double[,])wd.getDataByFunc("wsd"));
            DateTime[] dtDateArray = wd.timeList;

            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtDateArray.Length; i++)
            {
                strQuery = "insert into index_close values('" + dtDateArray[i].ToString() + "'";
                for (int j = 0; j < iNumber; j++)
                {
                    strQuery = strQuery + ",'" + dIndex[i, j].ToString() + "'";
                }
                strQuery = strQuery + ")";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            if (lsQuery.Count != 1)
            {
                sqlConn.BatchInsertDBMySql(lsQuery);
            }
            else
            {
                sqlConn.Insert(lsQuery[0]);
            }

            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void Premium_Click(object sender, EventArgs e)
        {
            
            double[] dIndexHistoryPrice = null;
            double[] dIndustryHistoryPrice = null;
            DateTime dtBegin = dateTimePicker6.Value.Date;
            DateTime dtEnd = dateTimePicker5.Value.Date;
            DateTime dtNow = DateTime.Now;

            // 参考系沪深300
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("IndexNameToCode");
            string strIndexCode = NCSection["沪深300"].ToString();

            DateTime dtRetrieve = dtBegin.AddDays(-400);

            NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string strIndustryCode = UtilityArray.getCodeConnectByAccent(NCSection);

            // 获取历史数据
            DBConnect dbConn = new DBConnect("MySQL");
            DataSet dsIndexHistoryPrice = dbConn.Select("SELECT date,`" + strIndexCode + "` FROM index_close WHERE date>'"+ dtRetrieve.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString() + "'");
            DataSet dsIndustryHistoryPrice = dbConn.Select("SELECT * FROM industry_close WHERE date>'"+ dtRetrieve.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString()+ "'");

            DataTable dtTemp = (dbConn.Select("SELECT * FROM industry_close WHERE date>='"+ dtBegin.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString()+ "'")).Tables[0];
            int iCount = dtTemp.Rows.Count;

            int iRowsIndex = dsIndexHistoryPrice.Tables[0].Rows.Count;
            int iRowsIndustry = dsIndustryHistoryPrice.Tables[0].Rows.Count;
            DateTime dtIndexEnd = (DateTime)(dsIndexHistoryPrice.Tables[0].Rows[iRowsIndex - 1][0]);
            DateTime dtIndustryEnd = (DateTime)(dsIndustryHistoryPrice.Tables[0].Rows[iRowsIndustry - 1][0]);

            if (dtEnd > dtIndexEnd)
            {
                MessageBox.Show("请先更新大盘指数数据！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
            if (dtEnd > dtIndustryEnd)
            {
                MessageBox.Show("请先更新行业指数数据！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }

            string[] strTableName = {"超额收益1日","超额收益5日","超额收益10日","超额收益60日","超额收益120日","超额收益250日"};

            for (int k = 0 ; k < strTableName.Length; k++)
            {
                if (!inputTimeAcceptable(dtBegin, dtEnd, strTableName[k]))
                {
                    return;
                }


                dIndexHistoryPrice = UtilityArray.getColFromTable(dsIndexHistoryPrice.Tables[0], 1);
                List<string> lsQuery = new List<string>();
                for (int j = 0; j < iCount; j++)
                {
                    string strQuery = "INSERT INTO "+ strTableName[k] + " (date) VALUES ('" + dtTemp.Rows[j][0] + "')";
                    lsQuery.Add(strQuery);
                }
                DBConnect sqlConn = new DBConnect("MySQL");
                if (lsQuery.Count != 1)
                {
                    sqlConn.BatchInsertDBMySql(lsQuery);
                }
                else
                {
                    sqlConn.Insert(lsQuery[0]);
                }


                for (int i = 0; i < int.Parse(NCSection["number"].ToString()); i++)
                {
                    dIndustryHistoryPrice = UtilityArray.getColFromTable(dsIndustryHistoryPrice.Tables[0], i + 1);

                    // 计算超额收益
                    List<List<double>> plPermium = UtilityMath.getMultiPeriodExcessReturnOverIndex(dIndustryHistoryPrice, dIndexHistoryPrice, Main.iHorizon);

                    lsQuery = new List<string>();
                    sqlConn = new DBConnect("MySQL");
                    for (int j = 0; j < iCount; j++)
                    {
                        string strQuery = "UPDATE " + strTableName[k] + " SET " + NCSection.AllKeys[i] + " = " + plPermium[0][j] + " WHERE date = '" + dtTemp.Rows[j][0] + "'";
                        lsQuery.Add(strQuery);
                    }
                    if (lsQuery.Count != 1)
                    {
                        sqlConn.BatchInsertDBMySql(lsQuery);
                    }
                    else
                    {
                        sqlConn.Insert(lsQuery[0]);
                    }
                }
            }
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private bool inputTimeAcceptable(DateTime dtBegin, DateTime dtEnd, string strDataTable)
        {

            DateTime dtNow = DateTime.Now.Date;
            if (dtBegin > dtEnd)
            {
                MessageBox.Show("开始日期必须早于结束日期！请重新调整", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return false ;
            }

            DBConnect dbCheck = new DBConnect("MySQL");
            string strQuery = "select date from " + strDataTable + " order by date desc limit 1";
            DataSet dtCheck = dbCheck.Select(strQuery);
            
            // 若输入日期为昨日，万德无法返回数据，手动改为今天
            try
            {
                DateTime dtCheckTimeLast = (DateTime)dtCheck.Tables[0].Rows[0][0];
                DateTime dtCheckTimeNew = UtilityTime.getPrevTradeDay(dtCheckTimeLast, -1);

                if (dtEnd > dtNow)
                {
                    MessageBox.Show("结束日期不能晚于今天！请重新调整", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }

                if (!UtilityTime.isTradeDay(dtBegin) && (dtNow == dtBegin))
                {
                    MessageBox.Show("今天不是交易日，不能更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }
                if (DateTime.Now < dtBegin.Date.AddHours(15) && dtBegin == dtNow)
                {
                    MessageBox.Show("今天还未收盘，不能更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }

                if (DateTime.Compare(dtCheckTimeNew, dtBegin) < 0)
                {
                    MessageBox.Show("数据更新存在空档期！数据库最新一次更新日期为：" + dtCheckTimeLast.ToShortDateString() + " 开始日期应设为：" + dtCheckTimeNew.ToShortDateString(), "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }
                if (DateTime.Compare(dtCheckTimeNew, dtBegin) > 0)
                {
                    MessageBox.Show("存在数据覆盖现象！数据库最新一次更新日期为：" + dtCheckTimeLast.ToShortDateString() + " 开始日期应设为：" + dtCheckTimeNew.ToShortDateString(), "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }
                return true;
            }
            catch (NullReferenceException)
            {
                DateTime dtCheckTimeLast = (DateTime)dtCheck.Tables[0].Rows[0][0];
                DateTime dtCheckTimeNew = DateTime.Now.Date;
                if (DateTime.Compare(dtCheckTimeNew, dtBegin) > 0)
                {
                    MessageBox.Show("存在数据覆盖现象！数据库最新一次更新日期为：" + dtCheckTimeLast.ToShortDateString() + " 开始日期应设为：" + dtCheckTimeNew.ToShortDateString(), "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }
                return true;
            }
            catch (IndexOutOfRangeException)
            {
                return true;
            }
        }

        private void volumeWeekly_Click(object sender, EventArgs e)
        {
            DateTime dtBegin = dateTimePicker12.Value.Date;
            DateTime dtEnd = dateTimePicker11.Value.Date;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "周成交量"))
            {
                return;
            }
            if (dtEnd == DateTime.Now.Date && (dtEnd.DayOfWeek.ToString() != "Friday"))
            {
                MessageBox.Show("本周数据还未更新，请等待至周五再行更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }


            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");

            DataTable dtVolumn = UtilityWindData.getVolumnWeekly(NCSection, dtBegin, dtEnd);

            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtVolumn.Rows.Count; i++)
            {
                string strKey = "date";
                string strVal = "'" + (dtVolumn.Rows[i][0]).ToString() + "'";
                for (int j = 1; j < dtVolumn.Columns.Count; j++)
                {
                    strKey = strKey + "," + NCSection.AllKeys[j - 1];
                    strVal = strVal + "," + dtVolumn.Rows[i][j];
                }
                string strQuery ="insert into 周成交量 (" + strKey + ") VALUES (" + strVal + ");";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(lsQuery);
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void amountWeekly_Click(object sender, EventArgs e)
        {
            DateTime dtBegin = dateTimePicker10.Value.Date;
            DateTime dtEnd = dateTimePicker9.Value.Date;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "周成交额"))
            {
                return;
            }
            if (dtEnd == DateTime.Now.Date && (dtEnd.DayOfWeek.ToString() != "Friday"))
            {
                MessageBox.Show("本周数据还未更新，请等待至周五再行更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }


            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");

            DataTable dtVolumn = UtilityWindData.getAmountWeekly(NCSection, dtBegin, dtEnd);

            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtVolumn.Rows.Count; i++)
            {
                string strKey = "date";
                string strVal = "'" + (dtVolumn.Rows[i][0]).ToString() + "'";
                for (int j = 1; j < dtVolumn.Columns.Count; j++)
                {
                    strKey = strKey + "," + NCSection.AllKeys[j - 1];
                    strVal = strVal + "," + dtVolumn.Rows[i][j];
                }
                string strQuery = "insert into 周成交额 (" + strKey + ") VALUES (" + strVal + ");";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(lsQuery);
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void Turnover_Click(object sender, EventArgs e)
        {
            DateTime dtBegin = dateTimePicker8.Value.Date;
            DateTime dtEnd = dateTimePicker7.Value.Date;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "周频换手率"))
            {
                return;
            }
            if (dtEnd == DateTime.Now.Date && (dtEnd.DayOfWeek.ToString() != "Friday"))
            {
                MessageBox.Show("本周数据还未更新，请等待至周五再行更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }
            
            string strWholeCode = "ShenWanIndustryNameToCode";
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(strWholeCode);

            DataTable dtFreeTurn = UtilityWindData.getWindIndustryFreeTurnWeekly(strWholeCode, dtBegin, dtEnd);


            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtFreeTurn.Rows.Count; i++)
            {
                string strKey = "date";
                string strVal = "'" + (dtFreeTurn.Rows[i][0]).ToString() + "'";
                for (int j = 1; j < dtFreeTurn.Columns.Count; j++)
                {
                    strKey = strKey + "," + NCSection.AllKeys[j - 1];
                    strVal = strVal + "," + dtFreeTurn.Rows[i][j];
                }
                string strQuery = "insert into 周频换手率 (" + strKey + ") VALUES (" + strVal + ");";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(lsQuery);
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void LMR_Click(object sender, EventArgs e)
        {
            DateTime dtBegin = dateTimePicker14.Value.Date;
            DateTime dtEnd = dateTimePicker13.Value.Date;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "周频量比"))
            {
                return;
            }
            if (dtEnd == DateTime.Now.Date && (dtEnd.DayOfWeek.ToString() != "Friday"))
            {
                MessageBox.Show("本周数据还未更新，请等待至周五再行更新", "提示", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            string strWholeCode = "ShenWanIndustryNameToCode";
            NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(strWholeCode);

            DataTable dtFreeTurn = UtilityWindData.getIndustryLBWeekly(strWholeCode, dtBegin, dtEnd);

            List<string> lsQuery = new List<string>();
            for (int i = 0; i < dtFreeTurn.Rows.Count; i++)
            {
                string strKey = "date";
                string strVal = "'" + (dtFreeTurn.Rows[i][0]).ToString() + "'";
                for (int j = 1; j < dtFreeTurn.Columns.Count; j++)
                {
                    strKey = strKey + "," + NCSection.AllKeys[j - 1];
                    strVal = strVal + "," + dtFreeTurn.Rows[i][j];
                }
                string strQuery = "insert into 周频量比 (" + strKey + ") VALUES (" + strVal + ");";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(lsQuery);
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
        }

        private void RongZiRongQuan_Click(object sender, EventArgs e)
        {
            DateTime dtBegin = dateTimePicker16.Value.Date;
            DateTime dtEnd = dateTimePicker15.Value.Date;

            GlobalWind.windEnsureStart();
            if (!inputTimeAcceptable(dtBegin, dtEnd, "RongziRongquan"))
            {
                return;
            }

            List<Object> lResult = UtilityWindData.getWindRongZiRongQuanBalance(dtBegin.ToShortDateString(), dtEnd.ToShortDateString());

            List<string> lsQuery = new List<string>();
            int iRecords = ((DateTime[])lResult[0]).Length;
            for (int i = 0; i < iRecords; i++)
            {
                string strVal = "'" + ((DateTime[])lResult[0])[i].ToShortDateString() + "', " + (((double[])lResult[1])[i]/10000).ToString();
                string strQuery = "insert into RongziRongquan VALUES (" + strVal + ");";
                lsQuery.Add(strQuery);
            }
            DBConnect sqlConn = new DBConnect("MySQL");
            sqlConn.Insert(lsQuery);
            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);          
        }

        /// <summary>
        /// 数据自动保存函数
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonAutoSave_Click(object sender, EventArgs e)
        {
            DateTime[] dtLoadDate = new DateTime[2];
            GlobalWind.windEnsureStart();

            // 保存行业指数
            saveMktIdx("industry_close", "ShenWanIndustryNameToCode");

            // 保存大盘指数
            saveMktIdx("index_close", "IndexNameToCode");
            
            // 保存行业超额收益
            saveExcessReturn();

            // 保存周成交量信息
            saveWeeklyTradeInfo("周成交量");

            // 保存周成交额信息
            saveWeeklyTradeInfo("周成交额");

            // 保存周换手率信息
            saveWeeklyTradeInfo("周频换手率");

            // 保存周频量比信息
            saveWeeklyTradeInfo("周频量比");

            MessageBox.Show("数据导入成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);     
        }

        /// <summary>
        /// 获取需要写入的首末日期
        /// </summary>
        /// <param name="strDataTableName"></param>
        /// <returns></returns>
        private DateTime[] fetchInputDate(string strDataTableName)
        {
            DateTime[] dtResult = new DateTime[2];
            dtResult[0] = fetchStartDate(strDataTableName);
            dtResult[1] = fetchEndDate(strDataTableName);

            if (dtResult[0].Date > dtResult[1].Date )
            {
                return null;
            }
            else
            {
                return dtResult;
            }
        }

        /// <summary>
        /// 获取最近一组需要写入数据的日期
        /// </summary>
        /// <param name="strDataTableName">需要查询的表名</param>
        /// <returns></returns>
        private DateTime fetchStartDate(string strDataTableName)
        {
            // 建立连接
            DBConnect dbCheckConn = new DBConnect("MySQL");

            // 读取数据库中最新一条数据的日期
            string strSQLQuery = "SELECT date FROM " + strDataTableName + " ORDER BY date DESC LIMIT 1";
            DataSet dtLastRecordDate = dbCheckConn.Select(strSQLQuery);
            DateTime dtLastDate = (DateTime)dtLastRecordDate.Tables[0].Rows[0][0];

            // 获取向后一个交易日
            DateTime dtNewestRecordDate = UtilityTime.getPrevTradeDay(dtLastDate, -1);
            return dtNewestRecordDate;
        }


        /// <summary>
        /// 获取最近一组需要写入数据的结束日期
        /// </summary>
        /// <param name="strDataTableName">需要查询的表名</param>
        /// <returns></returns>
        private DateTime fetchEndDate(string strDataTableName)
        {
            // 可每日写入数据的表格
            if (strDataTableName == "industry_close" || strDataTableName == "index_close" || strDataTableName == "超额收益1日" ||
                strDataTableName == "超额收益5日" || strDataTableName == "超额收益10日" || strDataTableName == "超额收益60日" ||
                strDataTableName == "超额收益120日" || strDataTableName == "超额收益250日")
            {
                if (UtilityTime.isTradeDay(DateTime.Now))
                {
                    if (UtilityTime.isAfterTradeHour(DateTime.Now))
                    {
                        return DateTime.Now.Date;
                    }
                    else
                    {
                        return UtilityTime.getPrevTradeDay(DateTime.Now, 1);
                    }
                }
                else
                {
                    return UtilityTime.getPrevTradeDay(DateTime.Now, 0);
                }
            }
            else if (strDataTableName == "周成交量" || strDataTableName == "周频量比" 
                || strDataTableName == "周频换手率" || strDataTableName == "周成交额")
            {
                int iDays = (int)DateTime.Now.DayOfWeek - 5;
                if (iDays == 0)
                {
                    return DateTime.Now.Date;
                }
                else if (iDays > 0)
                {
                    return UtilityTime.getPrevTradeDay(DateTime.Now.AddDays(iDays), 0);
                }
                else
                {
                    return UtilityTime.getPrevTradeDay(DateTime.Now.AddDays(-7 - iDays), 0);
                }
            }
            else
            {
                return new DateTime();
            }
        }

        /// <summary>
        /// 获取指定区间指数并保存到MySQL数据库中（申万一级行业指数、大盘指数）
        /// </summary>
        /// <param name="dtBegin">读取开始日期</param>
        /// <param name="dtEnd">读取结束日期</param>
        /// <param name="strIndexName">指数名称</param>
        private void saveMktIdx(string strTableName, string strIndexName)
        {
            string strQuery = null;

            DateTime[] dtLoadDate = fetchInputDate(strTableName);
            if (dtLoadDate != null)
            {
                DateTime dtBegin = dtLoadDate[0];
                DateTime dtEnd = dtLoadDate[1];

                // 获取申万一级行业代码和数量
                NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection(strIndexName);
                string[] strCode = new string[NCSection.Count - 1];
                for (int i = 0; i < NCSection.Count - 1; i++)
                {
                    strCode[i] = NCSection[i];
                }
                string strWindCode = UtilityArray.getCodeConnectByComma(strCode);
                int iIndustryNumber = int.Parse(NCSection["number"].ToString());

                // 读取区间内行业指数
                WindData wd = UtilityWindData.getWindHistoryPrice(strWindCode, dtBegin, dtEnd, "close");
                double[,] dIndustryIndex = ((double[,])wd.getDataByFunc("wsd"));
                DateTime[] dtDateArray = wd.timeList;

                List<string> lsQuery = new List<string>();
                for (int i = 0; i < dtDateArray.Length; i++)
                {

                    strQuery = "insert into " + strTableName + " values('" + dtDateArray[i].ToString() + "'";
                    for (int j = 0; j < iIndustryNumber; j++)
                    {
                        strQuery = strQuery + ",'" + dIndustryIndex[i, j].ToString() + "'";
                    }
                    strQuery = strQuery + ")";
                    lsQuery.Add(strQuery);
                }
                DBConnect sqlConn = new DBConnect("MySQL");
                if (lsQuery.Count != 1)
                {
                    sqlConn.BatchInsertDBMySql(lsQuery);
                }
                else
                {
                    sqlConn.Insert(lsQuery[0]);
                }
            }  
        }

        /// <summary>
        /// 保存申万一级行业指数超额收益
        /// </summary>
        private void saveExcessReturn()
        {

            string[] strTableName = { "超额收益1日", "超额收益5日", "超额收益10日", 
                                        "超额收益60日", "超额收益120日", "超额收益250日" };
            double[] dHS300IndexHistoricPrice = null;
            double[] dIndustryHistoryPrice = null;

            // 参考系沪深300
            System.Collections.Specialized.NameValueCollection NCSection
                = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("IndexNameToCode");
            string strHS300Code = NCSection["沪深300"].ToString();

            // 获取申万一级行业代码
            NCSection =
                (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            string strShenWanIndustryCode = UtilityArray.getCodeConnectByAccent(NCSection);

            for (int k = 0; k < strTableName.Length; k++)
            {
                DateTime[] dtLoad = fetchInputDate(strTableName[k]);
                if (dtLoad != null)
                {
                    DateTime dtBegin = dtLoad[0];
                    DateTime dtEnd = dtLoad[1];

                    // 获取400日前至今范围内的数据，以计算最多250个交易日的超额收益
                    DateTime dtRetrieve = dtBegin.AddDays(-400);

                    DBConnect dbConn = new DBConnect("MySQL");

                    // 获取基准指数：沪深300指数
                    DataSet dsHS300Index
                        = dbConn.Select("SELECT date,`" + strHS300Code + "` FROM index_close WHERE date>'"
                        + dtRetrieve.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString() + "'");
                    // 获取申万一级行业指数
                    DataSet dsShenWanIndustryIndex
                        = dbConn.Select("SELECT * FROM industry_close WHERE date>'"
                        + dtRetrieve.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString() + "'");
                    // 计算日期之间共有多少个交易日（使用MySQL语句减少Wind数据使用量）
                    DataTable dtTemp
                        = (dbConn.Select("SELECT * FROM industry_close WHERE date>='"
                        + dtBegin.ToShortDateString() + "' AND date<='" + dtEnd.ToShortDateString() + "'")).Tables[0];
                    int iCount = dtTemp.Rows.Count;

                    // 获取沪深300指数
                    dHS300IndexHistoricPrice = UtilityArray.getColFromTable(dsHS300Index.Tables[0], 1);
                    // 针对表格插入日期列
                    List<string> lsQuery = new List<string>();
                    for (int j = 0; j < iCount; j++)
                    {
                        string strQuery = "INSERT INTO " + strTableName[k] + " (date) VALUES ('" + dtTemp.Rows[j][0] + "')";
                        lsQuery.Add(strQuery);
                    }
                    DBConnect sqlConn = new DBConnect("MySQL");
                    if (lsQuery.Count != 1)
                    {
                        sqlConn.BatchInsertDBMySql(lsQuery);
                    }
                    else
                    {
                        sqlConn.Insert(lsQuery[0]);
                    }


                    for (int i = 0; i < int.Parse(NCSection["number"].ToString()); i++)
                    {
                        // 获取每个行业的指数数据
                        dIndustryHistoryPrice = UtilityArray.getColFromTable(dsShenWanIndustryIndex.Tables[0], i + 1);

                        // 计算超额收益
                        List<List<double>> plPermium = UtilityMath.getMultiPeriodExcessReturnOverIndex(dIndustryHistoryPrice, dHS300IndexHistoricPrice, Main.iHorizon);

                        lsQuery = new List<string>();
                        sqlConn = new DBConnect("MySQL");
                        for (int j = 0; j < iCount; j++)
                        {
                            string strQuery = "UPDATE " + strTableName[k] + " SET " + NCSection.AllKeys[i] + " = " + plPermium[0][j] + " WHERE date = '" + dtTemp.Rows[j][0] + "'";
                            lsQuery.Add(strQuery);
                        }
                        if (lsQuery.Count != 1)
                        {
                            sqlConn.BatchInsertDBMySql(lsQuery);
                        }
                        else
                        {
                            sqlConn.Insert(lsQuery[0]);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 保存周频数据函数（周成交量、成交额、换手、量比）
        /// </summary>
        /// <param name="strTableName">所需更新表格的名称</param>
        private void saveWeeklyTradeInfo(string strTableName)
        {
            DateTime[] dtDateNeededtoLoad = fetchInputDate(strTableName);

            if (dtDateNeededtoLoad != null)
            {
                DateTime dtBegin = dtDateNeededtoLoad[0];
                DateTime dtEnd = dtDateNeededtoLoad[1];

                NameValueCollection NCSection = (NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");

                List<string> lsQuery = new List<string>();
                DBConnect sqlConn = new DBConnect("MySQL");

                DataTable dtWeeklyData = new DataTable();

                if (strTableName == "周成交量")
                {
                     dtWeeklyData = UtilityWindData.getVolumnWeekly(NCSection, dtBegin, dtEnd); 
                }
                else if (strTableName == "周成交额")
                {
                    dtWeeklyData = UtilityWindData.getAmountWeekly(NCSection, dtBegin, dtEnd);
                }
                else if (strTableName == "周频换手率")
                {
                    dtWeeklyData = UtilityWindData.getWindIndustryFreeTurnWeekly("ShenWanIndustryNameToCode", dtBegin, dtEnd);
                }
                else if (strTableName == "周频量比")
                {
                    dtWeeklyData = UtilityWindData.getIndustryLBWeekly("ShenWanIndustryNameToCode", dtBegin, dtEnd);
                }

                for (int i = 0; i < dtWeeklyData.Rows.Count; i++)
                {
                    string strKey = "date";
                    string strVal = "'" + (dtWeeklyData.Rows[i][0]).ToString() + "'";
                    for (int j = 1; j < dtWeeklyData.Columns.Count; j++)
                    {
                        strKey = strKey + "," + NCSection.AllKeys[j - 1];
                        strVal = strVal + "," + dtWeeklyData.Rows[i][j];
                    }
                    string strQuery = "insert into " + strTableName + " (" + strKey + ") VALUES (" + strVal + ");";
                    lsQuery.Add(strQuery);
                }
                sqlConn.Insert(lsQuery);
            }
        }
    }
}
