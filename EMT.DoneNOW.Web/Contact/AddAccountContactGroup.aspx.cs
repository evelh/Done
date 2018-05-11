using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class AddAccountContactGroup : BasePage
    {
        protected crm_contact_group pageGroup;
        protected crm_account pageAccount;
        protected List<crm_contact> notInContract;    // 不在指定的联系人组的客户 联系人
        protected List<crm_contact> INContract;       // 已经在指定联系人组的 联系人
        protected ContactBLL conBll = new ContactBLL();
        protected List<crm_contact_group> pageGroupList;
        protected bool isDisGroup = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var accountId = Request.QueryString["accountId"];
                if (!string.IsNullOrEmpty(accountId))
                    pageAccount = new CompanyBLL().GetCompany(long.Parse(accountId));
                if (pageAccount == null)
                {
                    Response.Write($"<script>alert('为获取到联系人信息！');window.close();</script>");
                    return;
                }
                pageGroupList = conBll.GetAllGroup();
                var groupId = Request.QueryString["groupId"];
                if (!string.IsNullOrEmpty(groupId))
                    pageGroup = conBll.GetGroupById(long.Parse(groupId));
                var accContactList = conBll.GetContactByCompany(pageAccount.id);
                if (pageGroup == null)
                    notInContract = accContactList;
                else
                {
                    var groupContracList = conBll.GetAccountGroupContact(pageGroup.id, pageAccount.id);
                    if(groupContracList!=null&& groupContracList.Count > 0)
                    {
                        if(accContactList!=null&& accContactList.Count > 0)
                        {
                            INContract = accContactList.Where(_ => groupContracList.Any(g => g.contact_id == _.id)).ToList();
                            notInContract = accContactList.Where(_ => !groupContracList.Any(g => g.contact_id == _.id)).ToList();
                        }
                    }
                    else
                        notInContract = accContactList;
                }
                if (!string.IsNullOrEmpty(Request.QueryString["isDisGroup"]) && Request.QueryString["isDisGroup"] == "dis")
                    isDisGroup = true;
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }
        }
    }
}