using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace UtilityLib
{
    class UtilityTools
    {
        [DllImport("kernel32.dll")]
        private static extern int Beep(int dwFreq, int dwDuration);

        public static void BeepHint(int dwFreq = 500, int dwDuration = 1000)
        {
            Beep(dwFreq, dwDuration);
        }

        public static List<string> LoadSelectedItem(CheckedListBox clbItem)
        {
            List<string> listSelectedItem = new List<string>();


            //获取选中板块
            for (int i = 0; i < clbItem.Items.Count; i++)
            {
                if (clbItem.GetItemChecked(i))
                {
                    listSelectedItem.Add(clbItem.Items[i].ToString());
                }
            }

            return listSelectedItem;
        }
    }
}
