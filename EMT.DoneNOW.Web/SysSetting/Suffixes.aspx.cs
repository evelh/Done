using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class Suffixes : BasePage
    {
        public long id;
        private d_general suffix = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id =Convert.ToInt64(Request.QueryString["id"]);
            if (id > 0)
            {
                suffix = new GeneralBLL().GetSingleGeneral(id);
                if (suffix == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    this.Suffix_name.Text = suffix.name.ToString();
                    if (suffix.is_active>0)
                    {
                        this.Active.Checked = true;
                    }
                }
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (id > 0)
            {
                suffix = new GeneralBLL().GetSingleGeneral(id);
                if (suffix == null)
                {
                    Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                }
            }
                suffix.name = this.Suffix_name.Text.Trim().ToString();
            if (this.Active.Checked) {
                suffix.is_active = 1;
            }
            if (id > 0)
            {
                //修改
            }
            else {
                //新增
            }
        }
    }
}