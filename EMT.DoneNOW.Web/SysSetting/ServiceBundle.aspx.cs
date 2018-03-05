using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ServiceBundleManage : BasePage
    {
        protected bool isAdd = true;
        protected ivt_service_bundle serviceBundle = null;
        protected List<d_sla> slaList = new ContractBLL().GetSLAList();
        protected List<DictionaryEntryDto> periodType;
        private ServiceBLL bll = new ServiceBLL();
        protected List<ivt_service_bundle_service> serList;
        protected void Page_Load(object sender, EventArgs e)
        {
            periodType = new GeneralBLL().GetDicValues(GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE);
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    serviceBundle = bll.GetServiceBundleById(long.Parse(Request.QueryString["id"]));
                    if (serviceBundle != null)
                    {
                        isAdd = false;
                        serList = bll.GetServiceListByServiceBundleId(serviceBundle.id);
                    }
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    serviceBundle = bll.GetServiceBundleById(long.Parse(Request.QueryString["id"]));
                    if (serviceBundle != null)
                        isAdd = false;
                }

                var pageServiceBundle = AssembleModel<ivt_service_bundle>();
                if (!string.IsNullOrEmpty(Request.Form["active"]) && Request.Form["active"].Equals("on"))
                    pageServiceBundle.is_active = 1;
                else
                    pageServiceBundle.is_active = 0;
                var serIds = Request.Form["ServiceIds"];

                var other_price = Request.Form["other_price"];
                if (!string.IsNullOrEmpty(other_price))
                    pageServiceBundle.old_selected_service_sum = decimal.Parse(other_price);
                else
                    pageServiceBundle.old_selected_service_sum = null;

                var extended_price = Request.Form["extended_price"];
                if (!string.IsNullOrEmpty(extended_price))
                    pageServiceBundle.unit_price = decimal.Parse(extended_price);
                else
                    pageServiceBundle.unit_price = 0;

                var discount_dollars_calc = Request.Form["discount_dollars_calc"];
                if (!string.IsNullOrEmpty(discount_dollars_calc))
                    pageServiceBundle.discount = decimal.Parse(discount_dollars_calc);
                else
                    pageServiceBundle.discount = null;

                var discount_percent = Request.Form["discount_percent"];
                if (!string.IsNullOrEmpty(discount_percent))
                    pageServiceBundle.discount_percent = decimal.Parse(discount_percent);
                else
                    pageServiceBundle.discount_percent = null;


                var result = false;
                if (isAdd)
                    result = bll.AddServiceBundle(pageServiceBundle, LoginUserId,serIds??"");
                else
                {
                    pageServiceBundle.id = serviceBundle.id;
                    pageServiceBundle.oid = serviceBundle.oid;
                    pageServiceBundle.vendor_account_id = serviceBundle.vendor_account_id;
                    pageServiceBundle.create_time = serviceBundle.create_time;
                    pageServiceBundle.create_user_id = serviceBundle.create_user_id;
                    result = bll.EditServiceBundle(pageServiceBundle, LoginUserId, serIds ?? "");
                }
                    

                var SaveType = Request.Form["SaveType"];
                if(SaveType == "SaveNew")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');self.opener.location.reload();location.href = 'ServiceBundle';</script>");
                }
                else 
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');self.opener.location.reload();window.close();</script>");
                }
              

            }
        }
    }
}