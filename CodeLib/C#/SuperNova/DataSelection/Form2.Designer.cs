namespace SuperNova
{
    partial class Form2
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
            this.dataGridView_ZhongcangGu = new System.Windows.Forms.DataGridView();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView_ZhongcangGu)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView_ZhongcangGu
            // 
            this.dataGridView_ZhongcangGu.AllowUserToAddRows = false;
            this.dataGridView_ZhongcangGu.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView_ZhongcangGu.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGridView_ZhongcangGu.Location = new System.Drawing.Point(0, 0);
            this.dataGridView_ZhongcangGu.Name = "dataGridView_ZhongcangGu";
            this.dataGridView_ZhongcangGu.RowTemplate.Height = 23;
            this.dataGridView_ZhongcangGu.Size = new System.Drawing.Size(1405, 533);
            this.dataGridView_ZhongcangGu.TabIndex = 0;
            this.dataGridView_ZhongcangGu.RowPostPaint += new System.Windows.Forms.DataGridViewRowPostPaintEventHandler(this.DataGridView_ZhongcangGu_RowPostPaint);
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1405, 533);
            this.Controls.Add(this.dataGridView_ZhongcangGu);
            this.Location = new System.Drawing.Point(0, 400);
            this.Name = "Form2";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "重仓股 V1.5";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView_ZhongcangGu)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        public System.Windows.Forms.DataGridView dataGridView_ZhongcangGu;
    }
}