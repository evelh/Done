﻿using EMT.DoneNOW.BLL;
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
    public partial class OpportunityLossReason : BasePage
    {
        protected long id;
        private d_general lossreason = new d_general();
        private GeneralBLL sobll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt64(Request.QueryString["id"]);
            if (!IsPostBack) {
                if (id > 0)
                {
                    lossreason = new GeneralBLL().GetSingleGeneral(id);
                    if (lossreason == null)
                    {
                        Response.Write("<script>alert('获取相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Name.Text = lossreason.name.ToString();
                        if (lossreason.remark != null && !string.IsNullOrEmpty(lossreason.remark.ToString()))
                        {
                            this.Description.Text = lossreason.remark.ToString();
                        }
                        if (Convert.ToInt32(lossreason.is_active) > 0)
                        {
                            this.Active.Checked = true;
                        }
                    }
                }
                else {
                    this.Active.Checked = true;
                }
            }
            
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
            }
        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();</script>");
        }
        private bool save_deal()
        {
            if (id > 0)
            {
                lossreason = new GeneralBLL().GetSingleGeneral(id);
            }
            lossreason.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim()))
            {
                lossreason.remark = this.Description.Text.Trim().ToString();
            }
            if (this.Active.Checked)
            {
                lossreason.is_active = 1;
            }
            else
            {
                lossreason.is_active = 0;
            }

            if (id > 0)
            {
                //修改更新
                var result = sobll.Update(lossreason, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('丢失商机原因修改成功！');</script>");
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
            else
            {
                //新增
                lossreason.general_table_id=(int)GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE;
                var result = sobll.Insert(lossreason, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('丢失商机原因添加成功！');</script>");
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