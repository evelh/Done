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
    public partial class OppportunityAdvancedField :BasePage
    {
        private long id;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                if (id > 0) {
                    var field = new GeneralBLL().GetSingleGeneral(id);
                    if (field == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，返回上一个页面');window.close();</script>");
                    }
                    else {
                        this.Name.Text = field.name.ToString();
                        if (field.ext1!=null&&Convert.ToInt32(field.ext1.ToString())>0) {
                            this.Active.Checked = true;
                        }
                    }
                } else {
                    Response.Write("<script>alert('获取相关信息失败，返回上一个页面');window.close();</script>");
                }

            }
           
        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            var field = new GeneralBLL().GetSingleGeneral(id);
            field.name = this.Name.Text.Trim().ToString();
            if (this.Active.Checked)
            {
                field.ext1 = "1";
            }
            else {
                field.ext1 = "0";
            }
            var result = new GeneralBLL().Update(field, GetLoginUserId());
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                Response.Write("<script>alert('销售指标度量修改成功！');self.opener.location.reload();window.close();</script>");
            }
            else if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("../Login.aspx");
            }
            else if (result == DTO.ERROR_CODE.EXIST)
            {
                Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
            }
        }
    }
}