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
    public partial class Service : BasePage
    {
        protected bool isAdd = true;
        protected ivt_service service = null;   // 编辑的服务
        protected List<d_sla> slaList = new ContractBLL().GetSLAList();
        protected List<DictionaryEntryDto> periodType;
        private ServiceBLL bll = new ServiceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    isAdd = false;
                    service = bll.GetServiceById(long.Parse(Request.QueryString["id"]));
                }
                periodType = new GeneralBLL().GetDicValues(GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE);
            }
            else
            {
                service = AssembleModel<ivt_service>();
                if (!string.IsNullOrEmpty(Request.Form["active"]) && Request.Form["active"].Equals("on"))
                    service.is_active = 1;
                else
                    service.is_active = 0;

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    service.id = long.Parse(Request.QueryString["id"]);
                    bll.EditService(service, LoginUserId);
                }
                else
                    bll.AddService(service, LoginUserId);

                Response.Write("<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}