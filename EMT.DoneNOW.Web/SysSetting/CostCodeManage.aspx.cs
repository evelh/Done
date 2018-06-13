using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class CostCodeManage : BasePage
    {
        protected bool isAdd = true;
        protected d_cost_code code;
        protected d_cost_code_rule codeRule;
        protected long cateId;
        protected CostCodeBLL codeBll = new CostCodeBLL();
        protected d_general cateGeneral;
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment();
        protected List<d_general> ledgerList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.GENERAL_LEDGER);
        protected List<d_general> taxCateList = new GeneralBLL().GetGeneralByTable((long)GeneralTableEnum.QUOTE_ITEM_TAX_CATE);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["cateId"]))
                long.TryParse(Request.QueryString["cateId"],out cateId);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                code = codeBll.GetCodeById(id);
            if (code != null)
            {
                isAdd = false;
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {

        }
    }
}