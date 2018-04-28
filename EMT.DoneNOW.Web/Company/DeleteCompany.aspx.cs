using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Company
{
    public partial class DeleteCompany : BasePage
    {
        protected crm_account crm_account = null;
        protected Dictionary<string, object> dic = null;
        protected CompanyBLL companyBll = new CompanyBLL();
        protected List<crm_contact> contactList;
        protected List<crm_opportunity> opportunityList;
        protected List<com_activity> todoList;
        protected List<crm_installed_product> insProList;
        protected List<com_activity> noteList;
        protected List<pro_project> projectList;
        protected List<sdk_expense_report> expReportList;
        protected List<sdk_task> accTicketList;          // 客户的工单
        protected List<sdk_task> accMasterTicketList;    // 客户的定期主工单
        protected List<ctt_contract> contractList;
        protected List<ctt_contract> contractNoBillList; // 客户还没有开始计费的合同
        protected List<ivt_product> productList;
        protected List<crm_sales_order> saleOrderList;
        protected List<ivt_service> serviceList;
        protected List<ivt_transfer> transferList;
        protected List<ivt_product> AllProductList = new DAL.ivt_product_dal().GetProList();
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (id != null)
            {
                if (AuthBLL.GetUserCompanyAuth(LoginUserId, LoginUser.security_Level_id, Convert.ToInt64(id)).CanDelete == false)  // 权限验证
                {
                    Response.End();
                    return;
                }
                crm_account = new CompanyBLL().GetCompany(Convert.ToInt64(id));
                dic = companyBll.GetField();
                if (crm_account != null)
                {
                    contactList = new ContactBLL().GetContactByCompany(crm_account.id);
                    opportunityList = new OpportunityBLL().GetOpportunityByCompany(crm_account.id);
                    todoList = new DAL.com_activity_dal().GetNoteByAccount(crm_account.id,(int)DicEnum.ACTIVITY_CATE.TODO);
                    noteList = new DAL.com_activity_dal().GetNoteByAccount(crm_account.id);
                    insProList = new DAL.crm_installed_product_dal().FindByAccountId(crm_account.id);
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

        /// <summary>
        /// 获取到当前操作的客户
        /// </summary>
        /// <returns></returns>
        public  crm_account GetAccount()
        {
            return crm_account;
        }
        /// <summary>
        /// 获取到客户的默认地址
        /// </summary>
        /// <returns></returns>
        public crm_location GetDefaultLocation()
        {
            return new LocationBLL().GetLocationByAccountId(crm_account.id);
        }

        /// <summary>
        /// 获取到客户的主要联系人，可能为null
        /// </summary>
        /// <returns></returns>
        public crm_contact GetDefaultContact()
        {
            return new ContactBLL().GetDefaultByAccountId(crm_account.id);
        }

        protected void Delete_Click(object sender, EventArgs e)
        {
            var id = Convert.ToInt64(Request.QueryString["id"]);
            var result = new CompanyBLL().DeleteCompany(id, GetLoginUserId());
            if (result)
            {
                Response.Write("<script>alert('删除客户成功！');window.close();</script>");  //  关闭添加页面的同时，刷新父页面
                // self.opener.location.reload();
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('删除客户失败!');</script>");
                //Response.Write("<script>alert('删除客户失败！');</script>");
            }
        }
    }
}