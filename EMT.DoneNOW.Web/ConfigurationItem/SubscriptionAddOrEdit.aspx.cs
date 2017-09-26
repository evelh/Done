using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class SubscriptionAddOrEdit : BasePage
    {
        protected bool isAdd = true;
        protected crm_subscription subscription = null;
        protected crm_installed_product iProduct = null;
        protected Dictionary<string, object> dic = new InstalledProductBLL().GetField();
        protected List<crm_subscription_period> subPeriodList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                #region 下拉框配数据源
                period_type_id.DataTextField = "show";
                period_type_id.DataValueField = "val";
                period_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "period_type").Value;
                period_type_id.DataBind();
                period_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                #endregion

                var iProduct_id = Request.QueryString["insProId"];
                if (!string.IsNullOrEmpty(iProduct_id))
                {
                    iProduct = new crm_installed_product_dal().GetInstalledProduct(long.Parse(iProduct_id));
                }
                  
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    subscription = new crm_subscription_dal().GetSubscription(long.Parse(id));
                    iProduct = new crm_installed_product_dal().GetInstalledProduct(subscription.installed_product_id);
                    period_type_id.SelectedValue = subscription.period_type_id.ToString();
                    // period_type_id.Enabled = false;
                    isAdd = false;
                    subPeriodList = new crm_subscription_period_dal().GetSubPeriodByWhere($" and subscription_id = {subscription.id}");
                }
                if (iProduct == null)
                {
                    Response.End();
                }

       



                if (!IsPostBack)
                {
                    
                    if (subscription != null )
                    {
                        if(subscription.status_id != 1)
                        {
                            status_id.SelectedValue = subscription.status_id.ToString();
                        }
                        else
                        {
                            status_id.SelectedValue = "1";
                        }

                    }
                    else
                    {
                        status_id.SelectedValue = "1";
                    }
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void save_click_Click(object sender, EventArgs e)
        {
            var result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new InstalledProductBLL().SubscriptiomInsert(GetParam(),GetLoginUserId());
            }
            else
            {
                result = new InstalledProductBLL().SubscriptiomEdit(GetParam(),GetLoginUserId());
            }
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    if (isAdd)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加成功！');window.close();</script>");
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改成功！');window.close();</script>");
                    }
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('未找到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }


        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new InstalledProductBLL().SubscriptiomInsert(GetParam(), GetLoginUserId());
            }
            else
            {
                result = new InstalledProductBLL().SubscriptiomEdit(GetParam(), GetLoginUserId());
            }
            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    if (isAdd)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('添加成功！');location.href='SubscriptionAddOrEdit.aspx?insProId=" + subscription.installed_product_id + "';</script>");
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('修改成功！');location.href='SubscriptionAddOrEdit.aspx?insProId=" + subscription.installed_product_id + "';</script>");
                    }
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写');</script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('未找到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }

        public crm_subscription GetParam()
        {
            var id = subscription == null ? 0 : subscription.id;
            subscription = AssembleModel<crm_subscription>();
            //subscription.status_id = isActive.Checked ? 1 : 0;/
            if (!isAdd)
            {
                subscription.id = id;
            }
            return subscription;
        }
    }
}