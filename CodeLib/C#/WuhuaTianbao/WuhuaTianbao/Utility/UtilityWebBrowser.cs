
using System.Linq;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using System.Net;
using System.IO;
using System.Text.RegularExpressions;


namespace WuhuaTianbao
{
    class UtilityWebBrowser
    {
        
        private const int INTERNET_CONNECTION_MODEM = 1;

        private const int INTERNET_CONNECTION_LAN = 2;

        private const int INTERNET_CONNECTION_PROXY = 4;

        private const int INTERNET_CONNECTION_MODEM_BUSY = 8;

        [DllImport("winInet.dll ")]
        private static extern bool InternetGetConnectedState(
            ref  int Flag,
            int dwReserved
        );

        private static WebBrowser webBrowserCache;

        public static string isConnectToInternet()
        {
            int iFlag = 0;

            string strNetStates = "";

            if (!InternetGetConnectedState(ref iFlag, 0))
            {
                MessageBox.Show("Error" , "isConnectToInternet: 未连接入互联网", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return null;
            }
            else
            {
                if ((iFlag & INTERNET_CONNECTION_MODEM) != 0)

                    strNetStates += " Connect by MODEM /n";

                if ((iFlag & INTERNET_CONNECTION_LAN) != 0)

                    strNetStates += "Connect by LAN  /n";

                if ((iFlag & INTERNET_CONNECTION_PROXY) != 0)

                    strNetStates += "Connect by PROXY /n";

                if ((iFlag & INTERNET_CONNECTION_MODEM_BUSY) != 0)

                    strNetStates += " MODEM is busy  /n";
            }
            return strNetStates;
        }

        public static string getHttpAddress(string strAddress)
        {
            if (String.IsNullOrEmpty(strAddress))
            {
                MessageBox.Show("Error", "getHttpAddress: 输入地址为空", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return null;
            }
            if (strAddress.Equals("about:blank"))
            {
                MessageBox.Show("Error", "getHttpAddress: 输入地址为空白页", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return null;
            }
            if (!strAddress.StartsWith("http://"))
            {
                strAddress = "http://" + strAddress;
                return strAddress;
            }
            return strAddress;
        }
        
        public static void navigate(string strAddress)
        {
            string strHttpAddress;

            if (string.IsNullOrEmpty(isConnectToInternet()))
            {
                return;
            }

            if (string.IsNullOrEmpty(getHttpAddress(strAddress)))
            {
                return;
            }
            else
            {
                strHttpAddress = getHttpAddress(strAddress);
            }
            
            try 
            {
                webBrowserCache.Navigate(new Uri(strHttpAddress));
            }
            catch (System.UriFormatException)
            {
                MessageBox.Show("Error", "Navigate: 打开页面出错！", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public static string getHTMLcode(string strUrlToCrawl)
        {
            string strHttpAddress;

            if (string.IsNullOrEmpty(isConnectToInternet()))
            {
                return null;
            }

            if (string.IsNullOrEmpty(getHttpAddress(strUrlToCrawl)))
            {
                return null;
            }
            else
            {
                strHttpAddress = getHttpAddress(strUrlToCrawl);
            }

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(strHttpAddress);
            req.Method = "Get";
            HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
            string strHtmlCharset = "utf-8";
            Encoding htmlEncoding = Encoding.GetEncoding(strHtmlCharset);
            StreamReader sr = new StreamReader(resp.GetResponseStream(), htmlEncoding);
            string respHtml = sr.ReadToEnd();
            return respHtml;
        }        
    }
}
