using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using WAPIWrapperCSharp;
using System.Configuration;
using System.Collections.Specialized;
using System.Runtime.InteropServices;
using UtilityLib;
using System.IO;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using WuhuaTianbao.Xaml;

namespace WuhuaTianbao
{
    public partial class Main : Form
    {
        private int iPower = 0;
        private string strTimes;
        private string strNames;

        // 计算周期频率
        public static int[] iHorizon = new int[6] { 1, 5, 10, 60, 120, 250 };
        int iSize = iHorizon.Length;        

        public Main(int iPower_ = 0, string strTimes_ = null, string strNames_ = null)
        {
            iPower = iPower_;
            strTimes = strTimes_;
            strNames = strNames_;
            InitializeComponent();
        }

        private void Main_Load(object sender, EventArgs e)
        {
            switch(iPower)
            {
                case 1: toolStripStatusLabel1.Text = "用户权限：" + "普通用户(L1)"; break; // 仅净值数据可读
                case 2: toolStripStatusLabel1.Text = "用户权限：" + "普通用户(L2)"; break;
                case 3: toolStripStatusLabel1.Text = "用户权限：" + "普通用户(L3)"; break; 
                case 4: toolStripStatusLabel1.Text = "用户权限：" + "超级用户"; break;     // 所有策略和数据可读
                case 5: toolStripStatusLabel1.Text = "用户权限：" + "管理员"; break;       // 所有策略和数据可读写
            }
            toolStripStatusLabel2.Text = "登录用户名：" + strNames;
            toolStripStatusLabel3.Text = "登录时间：" + strTimes;
            tabControl1.TabPages[0].Text = "行业追踪";
        }
        

        // 更改密码
        private void MainFrom_PwdChange_ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Pwd pwd = new Pwd();
            pwd.names = strNames;
            pwd.ShowDialog();
        }

        // 切换账户
        private void MainForm_Quit_ToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            if (MessageBox.Show("确定退出本系统吗？", "提示", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation) == DialogResult.OK)
            {
                System.Environment.Exit(0); 
            }
        }

        // 切换账户
        private void MainForm_ChangeAcc_ToolStripMenuItem_Click_1(object sender, EventArgs e)
        {
            if (MessageBox.Show("确定要切换账户吗？", "提示", MessageBoxButtons.OKCancel, MessageBoxIcon.Exclamation) == DialogResult.OK)
            {
                Login login = new Login();
                login.Show();
                this.Close();
            }
        }

        // 产品净值查询
        private void MainForm_NetValCheck_ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
        }

        // 市场指数查询
        private void MainForm_IdxCheck_ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DataRead dr = new DataRead();
            dr.Show();
        }

        // 数据保存
        private void MainForm_DataContrib_ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 5))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            DataContrib ds = new DataContrib();
            ds.Show();
        }

       

        private void IndustryExcessReturn_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            IndustryAnalysis isel = new IndustryAnalysis();
            isel.Show();
        }     

        // 进行策略运算
        private void ProgramRun_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            
            if (null == treeView1.SelectedNode)
            {
                MessageBox.Show("请先选择策略！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
            else if (treeView1.SelectedNode.Text == "PEAD业绩快报")
            {
                Params ys = new Params(this);
                ys.Show();
            }
            else if (treeView1.SelectedNode.Text == "PEAD选股策略")
            {
                MessageBox.Show("请进一步选择策略类型！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
            else if (treeView1.SelectedNode.Text == "业绩快报策略")
            {
                WuhuaTianbao.WinForm.YejiKuaibaoParams ys = new WuhuaTianbao.WinForm.YejiKuaibaoParams(this);
                ys.Show();
            }
            else if (treeView1.SelectedNode.Text == "事件驱动策略")
            {
                MessageBox.Show("请进一步选择策略类型！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
        }

        // 将DataGridView中的数据保存到Excel文件中
        private void DataTableSave_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }

            if (dataGridView1.CurrentRow != null)
            {
                UtilityExcel.saveDataGridViewtoExcel(dataGridView1);
            }
            else
            {
                MessageBox.Show("窗口为空，请先进行计算！", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                return;
            }
            
        }

        private void IHArbButton_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            OptionArbs oa = new OptionArbs();
            oa.Show();
        }

        private void MarketDaily_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            RongziRongquan rzrq = new RongziRongquan();
            rzrq.Show();

            //沪港通数据
            //SHHKStock sh = new SHHKStock();
            //sh.Show();

            IndustryReport ir = new IndustryReport();
            ir.Show();
            LargeCapShare lcs = new LargeCapShare();
            lcs.Show();
            SmallCapShare scs = new SmallCapShare();
            scs.Show();
            ZZ800EqualWeight zzew = new ZZ800EqualWeight();
            zzew.Show();


            ZZ800ExcessReturn zzer = new ZZ800ExcessReturn();
            zzer.Show();
        }
        [STAThread]
        private void MarketStyleTrack_Click(object sender, EventArgs e)
        {
            if (!UtilityAccessRight.hasAccessRight(iPower, 4))
            {
                UtilityAccessRight.accessRightWarning();
                return;
            }
            ZZ800EqualWeight zzew = new ZZ800EqualWeight();
            zzew.Show();
            ZZ800ExcessReturn zzer = new ZZ800ExcessReturn();
            zzer.Show();
            ZZ800EqualWeightII zzewII = new ZZ800EqualWeightII();
            zzewII.Show();
        }

        private void InterestCommodityMarket_Click(object sender, EventArgs e)
        {
            EconViewer ev = new EconViewer();
            ev.Show();
            CommodityMkt cm = new CommodityMkt();
            cm.Show();
        }

        private void Main_FormClosed(object sender, FormClosedEventArgs e)
        {
            System.Environment.Exit(0); 
        }

        private void button市场监控_Click(object sender, EventArgs e)
        {
            MarketMonitor mm = new MarketMonitor();
            mm.Show();
        }

    }
}
