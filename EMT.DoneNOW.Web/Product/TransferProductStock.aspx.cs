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
    public partial class TransferProductStock : BasePage
    {
        protected long id;//库存表id
        private ProductBLL probll = new ProductBLL();
        private ivt_warehouse_product ware = new ivt_warehouse_product();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);//获取id
            if (!IsPostBack)
            {
                if (id > 0)//修改
                {
                    ware = probll.Getwarehouse_product(id);
                    if (ware == null)
                    {
                        //获取相关信息失败
                        Response.Write("<script>alert('获取库存信息失败，无法修改，返回上一级！');window.close();</script>");
                    }
                    else
                    {
                        this.warehouse_id.DataTextField = "value";
                        this.warehouse_id.DataValueField = "key";
                        this.warehouse_id.DataSource = probll.GetWarehouseDownList(ware.product_id);
                        this.warehouse_id.DataBind();
                        this.warehouse_id.Items.Insert(0, new ListItem() { Value = "0", Text = "    ", Selected = true });

                        this.product_name.Text = probll.GetProduct(ware.product_id).name;
                        string text = this.warehouse.Text = this.warehouse_id.Items.FindByValue(ware.warehouse_id.ToString()).ToString();
                        this.warehouse_id.Items.Remove(new ListItem() { Value = ware.warehouse_id.ToString(), Text = text });
                        this.quantity.Text = ware.quantity.ToString();
                    }
                }
                else {
                    //获取相关信息失败
                    Response.Write("<script>alert('获取库存信息失败，无法修改，返回上一级！');window.close();</script>");
                }
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (id > 0)//修改
            {
                ware = probll.Getwarehouse_product(id);
                if (ware == null)
                {
                    //获取相关信息失败
                    Response.Write("<script>alert('获取库存信息失败，无法修改，返回上一级！');window.close();</script>");
                }
                else
                {
                    ivt_inventory_transfer tran = new ivt_inventory_transfer();//转移库存的信息

                    long warehouse2= Convert.ToInt64(this.warehouse_id.SelectedValue.ToString());
                    var wareproduc = probll.Getwarehouse_product(ware.product_id, warehouse2);
                    int qu = Convert.ToInt32(this.remove_quantity.Text.Trim().ToString());//转移数量
                    if (wareproduc != null)
                    {
                        wareproduc.quantity = wareproduc.quantity + qu;//转入仓库增加
                        ware.quantity = ware.quantity - qu;//转出仓库减少
                        //转移记录
                        tran.product_id = ware.product_id;//转移的产品
                        tran.transfer_from_warehouse_id = Convert.ToInt64(ware.warehouse_id);//转出仓库
                        tran.transfer_to_warehouse_id = Convert.ToInt64(wareproduc.warehouse_id);//转入仓库
                        tran.transfer_quantity = qu;//转移的数量
                        tran.notes = this.note.Text;//备注信息
                        var result = probll.inventory_transfer(tran, ware, wareproduc, GetLoginUserId());
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
                }
            }
            Response.Write("<script>window.opener.parent.parent.refrekkk();window.close();</script>");

        }
        protected void Cancel_Click(object sender, EventArgs e)
        {
            Response.Write("<script>window.opener.parent.parent.refrekkk();window.close();</script>");
        }
    }
}