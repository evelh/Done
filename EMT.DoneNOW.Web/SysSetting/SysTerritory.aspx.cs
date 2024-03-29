﻿using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class SysTerritory : BasePage
    {
        public int id = 0;
        protected d_general d = new d_general();
        protected TerritoryBLL stbll = new TerritoryBLL();
        public List<sys_resource> AccountList = new List<sys_resource>();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
           // id = 2;
            if (!IsPostBack) {
                //Region下拉框
                var dic = stbll.GetRegionDownList();
                this.Region.DataTextField = "show";
                this.Region.DataValueField = "val";
                this.Region.DataSource = dic.FirstOrDefault(_ => _.Key == "Region").Value;
                this.Region.DataBind();
                Region.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                //操作
                if (id > 0)//修改
                {
                    var a = new GeneralBLL().GetSingleGeneral(id);
                    if (a == null)
                    {
                        Response.Write("<script>alert('获取地域相关信息失败，无法修改！');window.close();self.opener.location.reload();</script>");
                    }
                    else
                    {
                        this.Territory_Name.Text = a.name.ToString();
                        if(a.parent_id!=null)
                        this.Region.SelectedValue = a.parent_id.ToString();
                        if (a.remark != null && !string.IsNullOrEmpty(a.remark.ToString()))
                        {
                            this.Territory_Description.Text = a.remark.ToString();
                        }
                    }
                    //获取地域所属员工
                    AccountList = stbll.GetAccountList(id);
                }
            }
           
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
           
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>window.location.href = 'SysTerritory.aspx';</script>");
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save_deal())
            {
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
            }
        }
        /// <summary>
        /// 数据保存处理
        /// </summary>
        private bool save_deal() {
            bool status = false;
            d_general terr = new d_general();
            if (id > 0) {
                terr= new GeneralBLL().GetSingleGeneral(id);
                status = true;
            }
            terr.name = this.Territory_Name.Text.Trim().ToString();
            if (Convert.ToInt32(this.Region.SelectedValue.ToString())>0)
            terr.parent_id = Convert.ToInt32(this.Region.SelectedValue.ToString());
            if (!string.IsNullOrEmpty(this.Territory_Description.Text.Trim().ToString())) {
                terr.remark= this.Territory_Description.Text.Trim().ToString();
            }
            var result = stbll.SaveTerritory(terr, GetLoginUserId(), ref id);
           if (result == DTO.ERROR_CODE.SUCCESS)
           {
                if (status)
                {
                    Response.Write("<script>alert('客户地域修改成功！');</script>");
                }
                else {
                    Response.Write("<script>alert('客户地域添加成功！');</script>");
                }               
                return true;
            } else
            if (result == DTO.ERROR_CODE.EXIST)
             {
                    Response.Write("<script>alert('已经存在该名称地域');</script>");
             }else
            if (result == DTO.ERROR_CODE.USER_NOT_FIND)               // 用户丢失
            {
                Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                Response.Redirect("../Login.aspx");
            }
            return false;
        }
    }
}