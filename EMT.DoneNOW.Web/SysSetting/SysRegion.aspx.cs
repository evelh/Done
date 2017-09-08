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
    public partial class SysRegion :BasePage
    {
        public long id;
        public d_general region = new d_general();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                if (id > 0) {
                    //修改操作
                    region = new GeneralBLL().GetSingleGeneral(id);
                    this.Region_Name.Text = region.name;
                    if (region.remark != null && !string.IsNullOrEmpty(region.remark.ToString())) {
                        this.Region_Description.Text = region.remark.ToString();
                    }
                }
            }
        }

        protected void Save_close_Click(object sender, EventArgs e)
        {
            save_deal();
            Response.Write("<script>alert('区域添加成功！');window.close();self.opener.location.reload();</script>");
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            save_deal();
            Response.Write("<script>alert('区域添加成功！');window.location.href = 'SysRegion.aspx';</script>");
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        /// <summary>
        /// 处理需要保存的数据
        /// </summary>
        public void save_deal() {
            if(id>0)
                region = new GeneralBLL().GetSingleGeneral(id);
            region.name = this.Region_Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Region_Description.Text.Trim().ToString()))
            {
                region.remark = this.Region_Description.Text.Trim().ToString();
            }
            if (id > 0)
            {
                var result = new GeneralBLL().Update(region, GetLoginUserId());
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
                region.general_table_id = (int)GeneralTableEnum.REGION;
                var result = new GeneralBLL().Insert(region, GetLoginUserId());
                if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
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