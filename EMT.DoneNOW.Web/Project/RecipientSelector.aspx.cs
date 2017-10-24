using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class RecipientSelector : System.Web.UI.Page
    {
        protected List<sys_resource> resouList = null;
        protected List<crm_contact> conList = null;
        protected List<sys_department> depList = null;
        protected List<sys_workgroup> worList = null;
        protected string otherEmail = "";
        protected string thisType="";  // 
        protected crm_account account = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                var thisType = Request.QueryString["thisType"];
                var account_id = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(account_id))
                {
                    account = new CompanyBLL().GetCompany(long.Parse(account_id));
                }
                var resouIds = Request.QueryString["resouIds"];
                var projectLeadIds = Request.QueryString["projectLeadIds"];
                if (!string.IsNullOrEmpty(resouIds))
                {
                    resouList = new sys_resource_dal().GetListByIds(resouIds);
                }

                var conIds = Request.QueryString["conIds"];
                if (!string.IsNullOrEmpty(conIds))
                {
                    conList = new crm_contact_dal().GetContactByIds(conIds);
                }

                var depIds = Request.QueryString["depIds"];
                if (!string.IsNullOrEmpty(depIds))
                {
                    depList = new sys_department_dal().GetDepartment($" and id in ({depIds})");
                }

                var workIds = Request.QueryString["workIds"];
                if (!string.IsNullOrEmpty(workIds))
                {
                    worList = new sys_workgroup_dal().GetList($" and id in ({workIds})");
                }
                otherEmail = Request.QueryString["otherEmail"];


            }
            catch (Exception)
            {
                Response.Write("");
                Response.End();
            }
        }
    }
}