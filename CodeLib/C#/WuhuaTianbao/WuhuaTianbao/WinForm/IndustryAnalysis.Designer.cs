namespace WuhuaTianbao
{
    partial class IndustryAnalysis
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.comboBox2 = new System.Windows.Forms.ComboBox();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(42, 44);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 7;
            this.label1.Text = "申万行业";
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Items.AddRange(new object[] {
            "建筑装饰",
            "银行",
            "休闲服务",
            "交通运输",
            "农林牧渔",
            "有色金属",
            "食品饮料",
            "采掘",
            "公用事业",
            "房地产",
            "建筑材料",
            "钢铁",
            "家用电器",
            "商业贸易",
            "传媒",
            "非银金融",
            "医药生物",
            "化工",
            "机械设备",
            "汽车",
            "通信",
            "纺织服装",
            "轻工制造",
            "综合",
            "计算机",
            "电气设备",
            "电子",
            "国防军工"});
            this.comboBox1.Location = new System.Drawing.Point(145, 41);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(160, 20);
            this.comboBox1.TabIndex = 1;
            this.comboBox1.Text = "建筑装饰";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(42, 89);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 12);
            this.label2.TabIndex = 8;
            this.label2.Text = "基准指数";
            // 
            // comboBox2
            // 
            this.comboBox2.FormattingEnabled = true;
            this.comboBox2.Items.AddRange(new object[] {
            "上证综指",
            "上证A指",
            "上证B指",
            "上证380",
            "上证180",
            "上证红利",
            "上证50",
            "沪深300",
            "中证1000",
            "中证100",
            "中证500",
            "中证800",
            "深证成指",
            "深证100R",
            "中小板指",
            "创业板指",
            "中小300",
            "创业300",
            "中小板综",
            "创业板综",
            "深证综指",
            "深圳A指",
            "深证B指",
            "深证300R",
            "万得全A"});
            this.comboBox2.Location = new System.Drawing.Point(145, 89);
            this.comboBox2.Name = "comboBox2";
            this.comboBox2.Size = new System.Drawing.Size(160, 20);
            this.comboBox2.TabIndex = 9;
            this.comboBox2.Text = "沪深300";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(98, 139);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(140, 30);
            this.button1.TabIndex = 10;
            this.button1.Text = "提取数据";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.ParamsImport_Click);
            // 
            // IndustryAnalysis
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(355, 181);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.comboBox2);
            this.Controls.Add(this.label2);
            this.Name = "IndustryAnalysis";
            this.Text = "行业分析";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox comboBox2;
        private System.Windows.Forms.Button button1;
    }
}