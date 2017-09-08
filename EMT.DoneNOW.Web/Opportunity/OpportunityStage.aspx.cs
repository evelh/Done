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
    public partial class OpportunityStage :BasePage
    {
        protected long id;
        private d_general stage = new d_general();
        private GeneralBLL sobll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            //id = 40;//测试
            if (!IsPostBack) {
                if (id > 0) {
                    //修改
                   stage = new GeneralBLL().GetSingleGeneral(id);
                    if (stage == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else {
                        this.Name.Text = stage.name.ToString();
                        if (stage.remark != null && !string.IsNullOrEmpty(stage.remark.ToString())){
                            this.Description.Text = stage.remark.ToString();
                        }
                        if (stage.ext1!=null&&Convert.ToInt32(stage.ext1.ToString()) > 0) {
                            this.Won.Checked = true;
                        }
                        if (stage.ext2!=null&&Convert.ToInt32(stage.ext2.ToString()) > 0) {
                            this.Lost.Checked = true;
                        }
                        if (stage.code != null && !string.IsNullOrEmpty(stage.code.ToString()))
                        {
                            this.Sort_Order.Text = stage.code.ToString();
                        }
                    }
                }
            }

        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>alert('商机阶段添加成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                Response.Write("<script>alert('商机阶段添加失败！');window.close();self.opener.location.reload();</script>");
            }

        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
        private bool save_deal() {
            if (id > 0) {
                stage = new GeneralBLL().GetSingleGeneral(id);
            }
            stage.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim())) {
                stage.name = this.Description.Text.Trim().ToString();
            }
            if (this.Won.Checked)
            {
                stage.ext1 = "1";
            }
            else {
                stage.ext1 = "0";
            }
            if (this.Lost.Checked)
            {
                stage.ext2 = "1";
            }
            else {
                stage.ext2 = "0";
            }
            stage.code = this.Sort_Order.Text.Trim().ToString();
            if (id > 0)
            {
                //修改更新
                var result = sobll.Update(stage,GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS) {
                    return true;
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
            else {
                //新增
                stage.general_table_id= (int)GeneralTableEnum.OPPORTUNITY_STAGE;
                var result = sobll.Insert(stage,GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    return true;
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
            return false;
        }
    }
}