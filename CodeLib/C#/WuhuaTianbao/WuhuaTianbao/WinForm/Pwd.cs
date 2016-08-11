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

namespace WuhuaTianbao
{
    public partial class Pwd : Form
    {
        public Pwd()
        {
            InitializeComponent();
        }

        public string names;
        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "")
            {
                MessageBox.Show("请输入密码");
                textBox1.Focus();
            }
            else
            {
                if (textBox2.Text != textBox1.Text)
                {
                    MessageBox.Show("两次密码不一致");
                    textBox2.Focus();
                }
                else
                {
                    string strDBName = "MySQL";
                    UtilityLib.DBConnect sqlConn = new UtilityLib.DBConnect(strDBName);
                    string strUpdate = "update User set Password='" + textBox1.Text + "' where UserName='" + names + "'";
                    sqlConn.Update(strUpdate);
                    
                    if (MessageBox.Show("密码修改成功", "提示", MessageBoxButtons.OK, MessageBoxIcon.Asterisk) == DialogResult.OK)
                    {
                        this.Close();
                    }
                }
            }   
        }       

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBox2_TextChanged(object sender, EventArgs e)
        {
        
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
