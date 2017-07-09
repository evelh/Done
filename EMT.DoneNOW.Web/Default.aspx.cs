using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class _Default : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Write("<script>alert('hello!'); </script>");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            string strData = "<script>";
            strData += "var t = document.getElementById('mytable123');";
            strData += "t.innerHTML='";
            for (int i=1;i<=10;++i)
            {
                strData += "<tr>";
                for (int j = 1; j <= 3; ++j)
                {
                    strData += "<td>" + (i*10+j).ToString() + "</td>";
                }
                strData += "</tr>";
            }
            strData += "';</script>";
            Response.Write(strData);
        }
    }
}