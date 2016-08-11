using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace UtilityLib
{
    public class UtilityAccessRight
    {
        public static bool hasAccessRight(int iUserPower, int iAccessThreshhold)
        {
            if (iUserPower < iAccessThreshhold)
                return false;
            else
                return true;
        }

        public static void accessRightWarning()
        {
            MessageBox.Show("本账户没有权限操作，请联系管理员", "提示", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning);
        }

    }
}
