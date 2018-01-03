using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractExclusions : BasePage
    {
        protected ctt_contract excContract = null;
        protected ctt_contract thisContract = null;
      
        protected List<d_cost_code> thisCodeList = null;
        protected List<d_cost_code> allCodeList = null;

        protected List<sys_role> thisRoleList = null;
        protected List<sys_role> allRoleList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ccDal = new DAL.ctt_contract_dal();
                var contractId = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(contractId))
                {
                    thisContract = ccDal.FindNoDeleteById(long.Parse(contractId));
                }
                if (thisContract == null)
                {
                    Response.End();
                }
                else
                {
                    if (thisContract.exclusion_contract_id != null)
                    {
                        excContract = ccDal.FindNoDeleteById((long)thisContract.exclusion_contract_id);
                    }
                    thisCodeList = new DAL.d_cost_code_dal().GetConExsCode(thisContract.id);
                    allCodeList = new DAL.d_cost_code_dal().GetNotConExsCode(thisContract.id);

                    thisRoleList = new DAL.sys_role_dal().GetConExcRole(thisContract.id);
                    allRoleList = new DAL.sys_role_dal().GetNotConExcRole(thisContract.id);


                }
            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
    }
}