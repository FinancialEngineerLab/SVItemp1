using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WuhuaTianbao
{
    public partial class DataExhibit : Form
    {
        private DataSet dsOutputData;
        private string strTitle;

        public DataExhibit(DataSet dsOutputData_ = null, string strTitle_ = null)
        {
            dsOutputData = dsOutputData_;
            strTitle = strTitle_;
            InitializeComponent();
            refreshDataGridView();
        }

        public void refreshDataGridView()
        {
            dataGridView1.DataSource = dsOutputData.Tables[0];
            label1.Text = strTitle;
        }
    }
}
