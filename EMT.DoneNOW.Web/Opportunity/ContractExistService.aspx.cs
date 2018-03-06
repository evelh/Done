using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class ContractExistService : BasePage
    {
        protected Dictionary<long,string> serviceList = new Dictionary<long, string>();   // 所有的相同的服务
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var quote_id = Request.QueryString["quote_id"];
                var contract_id = Request.QueryString["contract_id"];
                if ((!string.IsNullOrEmpty(quote_id)) && (!string.IsNullOrEmpty(contract_id)))
                {
                    var itemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id={quote_id}");
                    var conSerList = new ctt_contract_service_dal().GetConSerList(long.Parse(contract_id));
                    if(itemList!=null&&itemList.Count>0&& conSerList != null && conSerList.Count > 0)
                    {
                        conSerList.ForEach(conser =>
                        {
                            if (itemList.Any(_ => _.object_id == conser.object_id))
                            {
                                if (serviceList.Count > 0)
                                {
                                    if (!serviceList.Any(ser => ser.Key == conser.object_id)) // 
                                    {
                                        serviceList.Add(conser.object_id, isServiceOrBag(conser.object_id));
                                    }
                                }
                                else
                                {
                                    serviceList.Add(conser.object_id, isServiceOrBag(conser.object_id));
                                }
                                
                            }

                        });
                    }
                    else
                    {
                        Response.End();
                    }
                }
                else
                {
                    Response.End();
                }
            }
            catch (Exception msg)
            {

                Response.End() ;
            }
        }

        public string isServiceOrBag(long object_id)
        {
            // GetSinService
            var service = new ivt_service_dal().GetSinService(object_id);
            if (service != null)
            {
                return service.name;
            }

            var serviceBundle = new ivt_service_bundle_dal().GetSinSerBun(object_id);
            if (serviceBundle != null)
            {
                return serviceBundle.name;
            }
            return "";
        }
    }
}