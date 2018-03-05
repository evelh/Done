using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractNoteShow : BasePage
    {
        protected ctt_contract thisContract = null;
        protected sdk_task thisTask = null;
        protected crm_account thisAccount = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisContractId = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(thisContractId))
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById(long.Parse(thisContractId));
                }
                if (thisContract != null)
                {
                    ShowNoteList.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_NOTE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_NOTE + "&con1054=" + thisContract.id ;
                }

                var taskId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(taskId));
                }
                if (thisTask != null)
                {
                    ShowNoteList.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_NOTE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_NOTE + "&con1054=" + thisTask.id;
                    thisAccount = new BLL.CompanyBLL().GetCompany(thisTask.account_id);
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}