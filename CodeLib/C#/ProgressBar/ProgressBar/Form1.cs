using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace ProgressBar
{
    public partial class Form1 : Form
    {
        
        public Form1()
        {
            InitializeComponent();
            Shown += new EventHandler(Form1_Shown);
            this.CenterToScreen();
            this.TopMost = true;

            // To report progress from the background worker we need to set this property
            backgroundWorker1.WorkerReportsProgress = true;
            // This event will be raised on the worker thread when the worker starts
            backgroundWorker1.DoWork += new DoWorkEventHandler(backgroundWorker1_DoWork);
            // This event will be raised when we call ReportProgress
            backgroundWorker1.ProgressChanged += new ProgressChangedEventHandler(backgroundWorker1_ProgressChanged);

            backgroundWorker1.RunWorkerCompleted += new RunWorkerCompletedEventHandler(backgroundWorker1_RunWorkerCompleted);

        }

        void Form1_Shown(object sender, EventArgs e)
        {
            // Start the background worker
            backgroundWorker1.RunWorkerAsync();
        }
        // On worker thread so do our thing!

        void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            // Your background task goes here
            for (int i = 0; i <= 100; i += 2)     // 100与progress bar最大值相同，用于调整滚动时间
            {
                // Report progress to 'UI' thread
                backgroundWorker1.ReportProgress(i);
                // Simulate long task
                //System.Threading.Thread.Sleep(10);

                // to add 

                if (i == 100)
                {
                    string FileName = @"C:\\temp\PtfMonitor.xls";    //打开的文件必须在该程序exe同目录下

                    string fileToCopy = @"\\10.200.100.180\lhtz\PtfMonitor\PtfMonitor.xls";
                    string fileDesination = @"c:\\temp\PtfMonitor.xls";
                    FileInfo file = new FileInfo(fileToCopy);
                    if (file.Exists)
                    {
                        file.CopyTo(fileDesination, true);
                    }

                    System.Diagnostics.Process.Start(FileName);
                }

                
            }

           
            
        }
        // Back on the 'UI' thread so we can update the progress bar

        void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            // The progress percentage is a property of e
            progressBar1.Value = e.ProgressPercentage;
        }


        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            //
            // Receive the result from DoWork, and display it.
            //
            this.Close();

            //
            // Will display "6 3" in title Text (in this example)
            //
        }

       

       
    }
}