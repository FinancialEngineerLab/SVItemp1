using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Windows.Forms;
using System.Drawing;

namespace UtilityLib
{
    class UtilityThread
    {
        delegate void SetControlValueCallback(Control oControl, string strPropName, object objPropVal); 

        public static void SetControlPropertyValue(Control oControl, string strPropName, object objPropVal)
        {
            if (oControl.InvokeRequired)
            {
                SetControlValueCallback d = new SetControlValueCallback(SetControlPropertyValue);
                oControl.Invoke(d, new object[] { oControl, strPropName, objPropVal });
            }
            else
            {
                Type t = oControl.GetType();
                PropertyInfo[] props = t.GetProperties();
                foreach (PropertyInfo p in props)
                {
                    if (p.Name.ToUpper() == strPropName.ToUpper())
                    {
                        p.SetValue(oControl, objPropVal, null);
                    }
                }
            }
        }

        public void ContentChangeEffect(object objControl)
        {
            Control oControl = (Control)objControl;
            UtilityThread.SetControlPropertyValue(oControl, "BackColor", Color.Pink);
            System.Threading.Thread.Sleep(500);
            UtilityThread.SetControlPropertyValue(oControl, "BackColor", Color.Transparent);
        }

        public static void BackgroundFlashing(Object objSender)
        {
            bool bChange = true;
            Control oControl = (Control)objSender;
            while (bChange)
            {
                UtilityThread.SetControlPropertyValue(oControl, "BackColor", Color.Pink);
                System.Threading.Thread.Sleep(500);
                UtilityThread.SetControlPropertyValue(oControl, "BackColor", Color.Transparent);
                System.Threading.Thread.Sleep(500);
            }
        }
    }
}
