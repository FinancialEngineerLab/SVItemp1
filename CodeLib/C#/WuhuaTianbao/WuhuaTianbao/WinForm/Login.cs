using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using UtilityLib;
using System.Data.OleDb;

namespace WuhuaTianbao
{
    public partial class Login : Form
    {

        DataSet dsUserInfo = new DataSet();
        
        public Login()
        {
            
            InitializeComponent();
        }

        // 登陆按钮
        private void button1_Click(object sender, EventArgs e)
        {
#if DEBUG
            Main main = new Main(5, DateTime.Now.ToShortDateString(), "Admin");
            main.Show();
            this.Hide();
#endif

#if !DEBUG
            if (textName.Text == "")
            {
                MessageBox.Show("请输入用户名", "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                if (textPwd.Text == "")
                {
                    MessageBox.Show("请输入密码", "警告", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    if (checkBox1.CheckState == CheckState.Unchecked)
                    {
                        string strDBType = "MySQL";
                        DBConnect sqlConn = new DBConnect(strDBType);
                        string strQuery = "select * from User where UserName = '" + textName.Text + "' and Password = '" + textPwd.Text + "'";
                        dsUserInfo = sqlConn.Select(strQuery);

                        try
                        {
                            if (dsUserInfo.Tables.Count > 0)
                            {
                                int iPower = int.Parse(dsUserInfo.Tables[0].Rows[0][2].ToString());
                                string strTime = DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
                                Main main = new Main(iPower, strTime, textName.Text);
                                main.Show();
                                this.Hide();
                            }
                            else
                            {
                                MessageBox.Show("用户名或密码错误");
                            }
                        }
                        catch (IndexOutOfRangeException)
                        {
                            MessageBox.Show("用户名或密码错误");
                        }
                    }
                    else if (checkBox1.CheckState == CheckState.Checked)
                    {
                        OleDbConnection odcConnection = new OleDbConnection(@"Provider = Microsoft.Jet.OLEDB.4.0; Data Source = C:\temp\LoginInfo.mdb");
                        odcConnection.Open();

                        OleDbCommand odCommand = odcConnection.CreateCommand();
                        odCommand.CommandText = "SELECT UserName, password, Power FROM User WHERE UserName=" + textName.Text;

                        OleDbDataReader odReader = odCommand.ExecuteReader();

                    }

                }
            } 
#endif
        }


        // 输入合法数据后，按下enter建能够触发处理事件进入系统
        private void textPwd_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == 13)
            {
                button1_Click(sender, e);
            }
        }

        private void Login_Load(object sender, EventArgs e)
        {
            this.skinEngine1.SkinFile = "MacOS.ssk";

        }

    }
}
