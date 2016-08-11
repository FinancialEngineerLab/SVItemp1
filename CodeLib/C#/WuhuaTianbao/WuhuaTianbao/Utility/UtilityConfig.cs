using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Configuration;
using System.Collections.Specialized;
namespace UtilityLib
{
    public static class ConfigHelper
    {
        //依据连接串名字connectionName返回数据连接字符串  
        public static string GetConnectionStringsConfig(string strConnectionName)
        {
            //指定config文件读取
            string strFile = System.Windows.Forms.Application.ExecutablePath;
            System.Configuration.Configuration config = ConfigurationManager.OpenExeConfiguration(strFile);
            string strConnectionString =
                config.ConnectionStrings.ConnectionStrings[strConnectionName].ConnectionString.ToString();
            return strConnectionString;
        }
    

    /*   
    ///<summary> 
        ///更新连接字符串  
        ///</summary> 
        ///<param name="newName">连接字符串名称</param> 
        ///<param name="newConString">连接字符串内容</param> 
        ///<param name="newProviderName">数据提供程序名称</param> 
        public static void UpdateConnectionStringsConfig(string strNewName, string strNewConString, string strNewProviderName)
        {
            //指定config文件读取
            string strFile = System.Windows.Forms.Application.ExecutablePath;
            Configuration config = ConfigurationManager.OpenExeConfiguration(strFile);

            bool bExist = false; //记录该连接串是否已经存在  
            //如果要更改的连接串已经存在  
            if (config.ConnectionStrings.ConnectionStrings[strNewName] != null)
            {
                bExist = true;
            }
            // 如果连接串已存在，首先删除它  
            if (bExist)
            {
                config.ConnectionStrings.ConnectionStrings.Remove(strNewName);
            }
            //新建一个连接字符串实例  
            ConnectionStringSettings mySettings =
                new ConnectionStringSettings(strNewName, strNewConString, strNewProviderName);
            // 将新的连接串添加到配置文件中.  
            config.ConnectionStrings.ConnectionStrings.Add(mySettings);
            // 保存对配置文件所作的更改  
            config.Save(ConfigurationSaveMode.Modified);
            // 强制重新载入配置文件的ConnectionStrings配置节  
            ConfigurationManager.RefreshSection("ConnectionStrings");
        }
    */
         
        //返回*.exe.config文件中appSettings配置节的value项  
      
        public static string GetAppConfig(string strKey)
        {
            string strFile = System.Windows.Forms.Application.ExecutablePath;
            Configuration config = ConfigurationManager.OpenExeConfiguration(strFile);
            foreach (string key in config.AppSettings.Settings.AllKeys)
            {
                if (key == strKey)
                {
                    return config.AppSettings.Settings[strKey].Value.ToString();
                }
            }
            return null;
        }
        //返回*.exe.config文件中自定义配置节的value项
        public static string GetAppConfig(string strKey,string strSname)
        {
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection(strSname);
            return NCSection[strKey].ToString();
        }

        public static string[] GetAppConfigArray(string[] strKey, string strSecName)
        {
            string[] strConfigArray = new string[strKey.Length];
            for (int i = 0; i < strConfigArray.Length; i++)
            {
                strConfigArray[i] = GetAppConfig(strKey[i], strSecName);
            }
            return strConfigArray;
        }

        public static string[] GetAppConfigWholeArray(string strSecName)
        {
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection(strSecName);
            string[] strConfigArray = new string[NCSection.Count - 1];
            for (int i = 0; i < strConfigArray.Length; i++)
            {
                strConfigArray[i] = NCSection[i];
            }
            return strConfigArray;
        }

        public static List<List<string>> FetchShenWanIndustryCode(List<string> lIndustryName)
        {
            List<List<string>> listListWindCode = new List<List<string>>();
            List<string> lIndustryCode = new List<string>();

            //获取板块个股代码
            System.Collections.Specialized.NameValueCollection NCSection =
                (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection("ShenWanIndustryNameToCode");
            for (int i = 0; i < lIndustryName.Count; i++)
            {
                string strIndustryCode = NCSection[lIndustryName[i]].ToString();
                lIndustryCode.Add(strIndustryCode);
            }
            for (int i = 0; i < lIndustryCode.Count; i++)
            {
                string strGroupName = "SI" + lIndustryCode[i].Substring(0, 6) + "GroupMember";
                string[] strConfigArray = ConfigHelper.GetAppConfigWholeArray(strGroupName);

                listListWindCode.Add(strConfigArray.ToList());
            }

            return listListWindCode;
        }

        public static string[] GetAppKeyWholeArray(string strSecName)
        {
            System.Collections.Specialized.NameValueCollection NCSection = (System.Collections.Specialized.NameValueCollection)ConfigurationManager.GetSection(strSecName);
            string[] strConfigArray = new string[NCSection.Count - 1];
            for (int i = 0; i < strConfigArray.Length; i++)
            {
                strConfigArray[i] = NCSection.AllKeys[i];
            }
            return strConfigArray;
        }
         //在*.exe.config文件中appSettings配置节增加一对键值对  
         public static void UpdateAppConfig(string strNewKey, string strNewValue)
        {
            string strFile = System.Windows.Forms.Application.ExecutablePath;
            Configuration config = ConfigurationManager.OpenExeConfiguration(strFile);
            bool bExist = false;
            foreach (string key in config.AppSettings.Settings.AllKeys)
            {
                if (key == strNewKey)
                {
                    bExist = true;
                }
            }
            if (bExist)
            {
                config.AppSettings.Settings.Remove(strNewKey);
            }
            config.AppSettings.Settings.Add(strNewKey, strNewValue);
            config.Save(ConfigurationSaveMode.Modified);
            ConfigurationManager.RefreshSection("appSettings");
           
        }

    }
}