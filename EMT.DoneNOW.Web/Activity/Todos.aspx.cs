using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class Todos : BasePage
    {
        protected com_activity note = null;
        protected List<crm_contact> contactList = null;             // 可选联系人列表
        protected List<crm_opportunity> opportunityList = null;     // 可选商机列表
        protected List<d_general> actionTypeList;                   // 活动类型列表
        protected List<DictionaryEntryDto> resourceList;            // 负责人列表
        private ActivityBLL bll = new ActivityBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            actionTypeList = bll.GetCRMActionType();
            resourceList = new UserResourceBLL().GetResourceList();

            if (!IsPostBack)
            {
                long noteid;
                if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out noteid))
                {
                    note = bll.GetActivity(noteid);
                    contactList = new ContactBLL().GetContactByCompany((long)note.account_id);
                    opportunityList = new OpportunityBLL().GetOpportunityByCompany((long)note.account_id);
                }
            }
            else
            {
                com_activity activity = AssembleModel<com_activity>();
                if (activity.contact_id == 0)
                    activity.contact_id = null;
                activity.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["start_date2"]));
                activity.end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["end_date2"]));

                if (!string.IsNullOrEmpty(Request.Form["is_completed"]) && Request.Form["is_completed"].Equals("on"))
                {
                    activity.status_id = (int)DicEnum.ACTIVITY_STATUS.COMPLETED;
                    activity.complete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(Request.Form["complete_time1"]));
                }
                else
                {
                    activity.status_id = (int)DicEnum.ACTIVITY_STATUS.NOT_COMPLETED;
                    activity.complete_description = null;
                }
                
                if (string.IsNullOrEmpty(Request.Form["id"]))
                    bll.AddTodo(activity, GetLoginUserId());
                else
                    bll.EditTodo(activity, GetLoginUserId());

                if (Request.Form["action"] != null && Request.Form["action"].Equals("SaveNew"))
                    Response.Write("<script>alert('保存待办成功');window.location.href='Notes.aspx';self.opener.location.reload();</script>");
                else
                    Response.Write("<script>alert('保存待办成功');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}