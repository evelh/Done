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
    public partial class LedgerAccountManage : BasePage
    {
        protected d_general ledger;
        protected bool isAdd = true;
        protected List<d_cost_code> codeList;
        protected GeneralBLL genBll = new GeneralBLL();
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                ledger = genBll.GetSingleGeneral(id);
            if (ledger != null&&ledger.delete_time==0)
            {
                isAdd = false;
                codeList = new CostCodeBLL().GetWorkCodeByLedger(ledger.id);
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageGen = AssembleModel<d_general>();
            pageGen.general_table_id = (int)GeneralTableEnum.GENERAL_LEDGER;
            if (!isAdd)
            {
                ledger.name = pageGen.name;
                ledger.remark = pageGen.remark;
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddGeneral(pageGen, LoginUserId);
            else
                result = genBll.EditGeneral(ledger, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}