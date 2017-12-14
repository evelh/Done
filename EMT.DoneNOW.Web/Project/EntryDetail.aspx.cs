using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Project
{
    public partial class EntryDetail : BasePage
    {
        protected sdk_work_entry thisEntry = null;
        protected crm_account thisAccount = null;
        protected sdk_task thisTask = null;
        protected pro_project thisProject = null;
        protected ctt_contract thisContract = null;
        protected d_cost_code thisCost = null;
        protected decimal? thisRate = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisEntry = new sdk_work_entry_dal().FindNoDeleteById(long.Parse(id));
                }
                if (thisEntry == null)
                {
                    Response.End();
                }
                else
                {
                    if (thisEntry.cost_code_id != null)
                    {
                        thisCost = new d_cost_code_dal().FindNoDeleteById((long)thisEntry.cost_code_id);
                        thisRate = new ContractRateBLL().GetRateByCodeAndRole((long)thisEntry.cost_code_id, (long)thisEntry.role_id);
                    }
                    thisTask = new sdk_task_dal().FindNoDeleteById(thisEntry.task_id);

                    if (thisTask != null&&thisTask.project_id!=null)
                    {
                        thisProject = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                        if (thisProject != null)
                        {
                            thisAccount = new CompanyBLL().GetCompany(thisProject.account_id);
                        }
                    }
                    if (thisEntry.contract_id != null)
                    {
                        thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisEntry.contract_id);
                    }
                    
                    
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}