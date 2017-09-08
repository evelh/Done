using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
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
                var result = new GeneralBLL().Update(suffix, GetLoginUserId());
                if (result == ERROR_CODE.ERROR)
                {
                    Response.Write("<script>alert('区域修改失败，返回！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            else {
                //新增
                suffix.general_table_id = (int)GeneralTableEnum.NAME_SUFFIX;
                var result = new GeneralBLL().Insert(suffix, GetLoginUserId());
                if (result == ERROR_CODE.ERROR)
                {
                    Response.Write("<script>alert('区域修改失败，返回！');window.close();self.opener.location.reload();</script>");
                }
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
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
}