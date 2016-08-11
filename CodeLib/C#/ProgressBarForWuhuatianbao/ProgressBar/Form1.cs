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
        static int iRun = 0;
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
            
            if (iRun > 0)
            {
                // this is stupid, will study this later
            }
            else
            {// Your background task goes here
                for (int i = 0; i <= progressBar1.Maximum; i += 1)     // 100与progress bar最大值相同，用于调整滚动时间
                {
                    // Report progress to 'UI' thread

                    if (i % 6 == 0)
                    {
                        backgroundWorker1.ReportProgress(i / 6);
                    }

                    // Simulate long task
                    System.Threading.Thread.Sleep(5);
                }

                string FileName = @"C:\\temp\WuhuaTianbao\WuhuaTianbao\Wuhuatianbao.exe";    //打开的文件必须在该程序exe同目录下

                //string fileToCopy = @"\\10.200.100.180\lhtz\WuhuaTianbao\WuhuaTianbao.exe";
                //string fileDesination = @"c:\\temp\Wuhuatianbao.exe";

                string strFolderPath = @"\\10.200.100.180\lhtz\WuhuaTianbao";
                string strFolderDestination = @"c:\\temp\WuhuaTianbao";

                string strFlag = CopyFolder(strFolderPath, strFolderDestination);

                //FileInfo file = new FileInfo(fileToCopy);
                //if (file.Exists)
                //{
                //    if (!System.IO.Directory.Exists(@"c:\\temp"))
                //    {
                //        System.IO.Directory.CreateDirectory(@"c:\\temp"); 
                //    }
                //    file.CopyTo(fileDesination, true);
                //}

                System.Diagnostics.Process.Start(FileName);
            }
            iRun += 1;
        }
        // Back on the 'UI' thread so we can update the progress bar

        void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            // The progress percentage is a property of e
            progressBar1.Value = e.ProgressPercentage * progressBar1.Maximum /100;
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

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        public string CopyFolder(string strPath, string strDestination)
        {
            string flag = "success";

            try
            {
                // 创建文件夹
                if (!Directory.Exists(strDestination))
                {
                    Directory.CreateDirectory(strDestination);
                }

                //拷贝文件
                DirectoryInfo sDir = new DirectoryInfo(strPath);
                FileInfo[] fileArray = sDir.GetFiles();
                foreach (FileInfo file in fileArray)
                {
                    file.CopyTo(strDestination + "\\" + file.Name, true);
                }

                // 循环子文件夹
                DirectoryInfo dDir = new DirectoryInfo(strDestination);
                DirectoryInfo[] subDirArray = sDir.GetDirectories();
                foreach (DirectoryInfo subDir in subDirArray)
                {
                    CopyFolder(subDir.FullName, strDestination + "//" + subDir.Name);
                }
            }
            catch (Exception ex)
            {
                flag = ex.ToString();
            }
            return flag;
        }

       
    }
}