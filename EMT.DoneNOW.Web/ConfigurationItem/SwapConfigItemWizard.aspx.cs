using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class SwapConfigItemWizard : BasePage
    {
        protected crm_installed_product thisInsPro;
        protected List<sdk_task> noCloseTicket;
        protected InstalledProductBLL insProBll = new InstalledProductBLL();
        protected ivt_product thisProduct;
        protected List<ivt_warehouse> wareList;
        protected crm_account thisAccount;
        protected List<crm_contact> contactList;
        protected ctt_contract thisContract;
        protected List<crm_subscription> thisSubList;
        protected string subNames;
        protected void Page_Load(object sender, EventArgs e)
        {
            var insProId = Request.QueryString["insProId"];
            long id = 0;
            if (!string.IsNullOrEmpty(insProId)&&long.TryParse(insProId,out id))
                thisInsPro = insProBll.GetById(id);
            if (thisInsPro == null)
            {
                Response.Write("<script>alert('未获取到相关配置项！');window.close();</script>");
                return;
            }
            noCloseTicket = new DAL.sdk_task_dal().GetNoDoneByInsPro(thisInsPro.id);
            thisProduct = new ProductBLL().GetProduct(thisInsPro.product_id);
            wareList = new DAL.ivt_warehouse_dal().GetAllWareList();
            if (thisInsPro.account_id != null)
            {
                thisAccount = new CompanyBLL().GetCompany((long)thisInsPro.account_id);
                contactList = new ContactBLL().GetContactByCompany((long)thisInsPro.account_id);
            }
            if (thisInsPro.contract_id != null)
                thisContract = new ContractBLL().GetContract((long)thisInsPro.contract_id);
            var thisSubAllList = new DAL.crm_subscription_dal().GetSubByInsProId(thisInsPro.id);
            thisSubList = new InstalledProductBLL().ReturnSubIds(thisSubAllList);
            if (thisSubList != null && thisSubList.Count > 0)
            {
                thisSubList.ForEach(_ => {
                    subNames += _.name + ',';
                });
                if (!string.IsNullOrEmpty(subNames))
                    subNames = subNames.Substring(0, subNames.Length - 1);
            }

            if (IsPostBack)
            {
                var result = new InstalledProductBLL().SwapConfigItem(GetParam(),LoginUserId);
                Response.Write($"<script>self.opener.location.reload();alert('替换{(result?"成功":"失败")}!');window.close();</script>");
            }
        }

        protected SwapConfigItemDto GetParam()
        {
            SwapConfigItemDto param = new SwapConfigItemDto();
            param.outSwapId = thisInsPro.id;
            if (!string.IsNullOrEmpty(Request.Form["CkToWarehouse"]) && Request.Form["CkToWarehouse"].Equals("on"))
                param.CkToWarehouse = true;
            if (!string.IsNullOrEmpty(Request.Form["ToTargetId"]))
                param.inWareProId = long.Parse(Request.Form["ToTargetId"]);
            if (!string.IsNullOrEmpty(Request.Form["ToTargetXuLie"]))
                param.inWareProSnId = long.Parse(Request.Form["ToTargetXuLie"]);
            if (param.CkToWarehouse)
            {
                if (!string.IsNullOrEmpty(Request.Form["ckInven"]) && Request.Form["ckInven"].Equals("exist"))
                {
                    param.isExist = true;
                    if (!string.IsNullOrEmpty(Request.Form["ExistInvId"]))
                        param.existWareProId = long.Parse(Request.Form["ExistInvId"]);
                    if (!string.IsNullOrEmpty(Request.Form["ExistInvSeriNum"]))
                        param.existWareProSn = Request.Form["ExistInvSeriNum"];
                }
                else if (!string.IsNullOrEmpty(Request.Form["ckInven"]) && Request.Form["ckInven"].Equals("new"))
                {
                    param.isNew = true;
                    long.TryParse(Request.Form["ckInven"],out param.newWareId);
                    param.newSerNum = Request.Form["newSerNum"];
                    param.newRefNumber = Request.Form["newRefNumber"];
                    param.newBin = Request.Form["newBin"];
                    int.TryParse(Request.Form["newMin"], out param.newMin);
                    int.TryParse(Request.Form["newMax"], out param.newMax);
                    param.newQuan = 1;
                }
            }
            if(noCloseTicket!=null&& noCloseTicket.Count > 0)
            {
                param.ticketList = new Dictionary<long, string>();
                noCloseTicket.ForEach(_=> {
                    var dealType = Request.Form["ck"+_.id.ToString()];
                    if (!string.IsNullOrEmpty(dealType))
                        param.ticketList.Add(_.id,dealType);
                });
            }
            return param;
        }
    }
}