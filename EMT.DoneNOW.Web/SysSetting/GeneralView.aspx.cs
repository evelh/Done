using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class GeneralView : BasePage
    {
        public List<d_general> GeneralList = new List<d_general>();
        public int id;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            id = 2;
            if (!IsPostBack) {
                bind();
            }
        }
        private void bind()
        {
            GeneralList = new GeneralBLL().GetGeneralList(id);
            StringBuilder table = new StringBuilder();
            if (GeneralList.Count > 0)
            {
                foreach (var i in GeneralList)
                {
                    table.Append("<tr>");
                   // table.Append("<td class=\"Command\" style=\"text-align:center;width:30px; \"><img src = \"../Images/edit.png\" style=\"vertical-align:middle;\"/></td>");
                    table.Append(" <td class=\"Text\">" + i.name + "</td>");
                    if (i.remark!=null&&!string.IsNullOrEmpty(i.remark.ToString()))
                    {
                        table.Append("<td class=\"Boolean\" style=\"width: 80px; \">"+i.remark.ToString()+"</td>");
                    }
                    else
                    {
                        table.Append("<td class=\"Boolean\" style=\"width: 80px; \"></td>");
                    }
                    table.Append("</tr>");
                }
            }
            else
            {
                table.Append("<tr><td><div class=\"NoDataMessage\">There are no records.</div></td></tr>");
            }
            //this.table.Text = table.ToString();
        }
    }
}