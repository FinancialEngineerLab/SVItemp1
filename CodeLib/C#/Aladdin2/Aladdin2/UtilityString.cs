using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace UtilityLib
{
    class UtilityString
    {
        public static string[] convertObjectArrayToString(object[] obArray)
        {
            string[] strArray = new string[obArray.Length];

            for (int i = 0; i < obArray.Length; i++)
            {
                strArray[i] = obArray[i].ToString();
            }

            return strArray;
        }


        public static void isTableFits(object[,] InsertDataRange, object[] InsertDataHead, DataTable dsFieldsName)
        {
            if (dsFieldsName.Rows.Count == 0)
            {
                throw new InvalidOperationException("数据库字段名为空!");
            }

            if (InsertDataHead.Length != InsertDataRange.Length / InsertDataRange.GetLength(0))
            {
                throw new InvalidOperationException("输入字段名数目与输入数据不相等!");
            }

            for (int i = 0; i < InsertDataHead.Length; i++)
            {
                if ((dsFieldsName.Select("Field = '" + InsertDataHead[i] + "'")).Length == 0)
                {
                    throw new InvalidOperationException("输入的字段名：" + InsertDataHead[i] + "不存在");
                }
            }
            for (int i = 0; i < InsertDataRange.GetLength(0); i++)
            {
                for (int j = 0; j < InsertDataRange.Length / InsertDataRange.GetLength(0); j++)
                {
                    if (InsertDataRange[i, j].ToString() == "ExcelDna.Integration.ExcelEmpty")
                    {
                        throw new InvalidOperationException("输入数据存在空白单元格，请检查！");
                    }
                }
            }
        }
    }
}
