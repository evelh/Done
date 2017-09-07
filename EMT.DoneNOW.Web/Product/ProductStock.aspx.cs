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
    public partial class ProductStock :BasePage 
    {
        protected long id;//库存表id
        private ProductBLL probll = new ProductBLL();
        private ivt_warehouse_product ware = new ivt_warehouse_product();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            if (!IsPostBack) {
                this.warehouse_id.DataTextField = "value";
                this.warehouse_id.DataValueField = "key";
                this.warehouse_id.DataSource = probll.GetWarehouseDownList();
                this.warehouse_id.DataBind();
                this.warehouse_id.Items.Insert(0, new ListItem() { Value= "0", Text = "    ", Selected = true });
                if (id > 0)//修改
                {
                    ware = probll.Getwarehouse_product(id);
                    if (ware == null) {
                        //获取相关信息失败
                        Response.Write("<script>alert('获取库存信息失败，无法修改，返回上一级！');window.close();</script>");
                    } else {
                        if (ware.warehouse_id!=null&&!string.IsNullOrEmpty(ware.warehouse_id.ToString())) {
                            this.warehouse_id.SelectedValue = ware.warehouse_id.ToString();
                        }
                        this.quantity_minimum.Text = ware.quantity_minimum.ToString();
                        this.quantity_maximum.Text = ware.quantity_maximum.ToString();
                        this.quantity.Text = ware.quantity.ToString();
                        if (ware.bin != null && !string.IsNullOrEmpty(ware.bin.ToString()))
                        {
                            this.bin.Text = ware.bin.ToString();
                        }
                        if (ware.reference_number != null && !string.IsNullOrEmpty(ware.reference_number.ToString())) {
                            this.reference_number.Text = ware.reference_number.ToString();
                        }
                    }
                }
            }
        }
        private void save_deal() {
            ware= AssembleModel<ivt_warehouse_product>();
            if (id > 0)
            {
                var result = probll.UpdateProductStock(ware, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.EXIST: Response.Write("<script>alert(\"该仓库已经存在产品，请修改后保存！\");</script>"); break; //存在相同名称产品
                    case ERROR_CODE.ERROR: Response.Write("<script>alert(\"保存失败！\");</script>"); break; //操作失败
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("../Login.aspx"); ; break;//获取操作者信息失败
                    case ERROR_CODE.SUCCESS: Response.Write("<script>alert(\"库存信息修改成功！\");</script>"); break;//成功
                    default: Response.Write("<script>alert('异常错误，返回上一级！');window.close();self.opener.location.reload();</script>"); ; break;//失败
                }

            }
            else {
                var result = probll.InsertProductStock(ware, GetLoginUserId());
                switch (result)
                {
                    case ERROR_CODE.EXIST: Response.Write("<script>alert(\"该仓库已经存在产品，请修改后保存！\");</script>"); break; //存在相同名称产品
                    case ERROR_CODE.ERROR: Response.Write("<script>alert(\"保存失败！\");</script>"); break; //操作失败
                    case ERROR_CODE.USER_NOT_FIND:
                        Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                        Response.Redirect("../Login.aspx"); ; break;//获取操作者信息失败
                    case ERROR_CODE.SUCCESS: Response.Write("<script>alert(\"库存信息新增成功！\");</script>"); break;//成功
                    default: Response.Write("<script>alert('异常错误，返回上一级！');window.close();self.opener.location.reload();</script>"); ; break;//失败
                }
            }



        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            save_deal();
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }

        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            save_deal();
            Response.Write("<script>window.location.href='ProductStock.aspx';</script>");
        }
    }
}