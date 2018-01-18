using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;


namespace EMT.DoneNOW.Web.TimeSheet
{
    public partial class ExpenseReportDetail : BasePage
    {
        protected sdk_expense_report thisReport = null;
        protected List<sdk_expense> expList = null;       // 报表下的费用
        protected List<com_attachment> attList = null;    // 报表下的附件
        protected bool isReport = true;   // 代表列表显示的是费用还是附件
        protected bool isSubmit = false;  // 费用报表是否是未提交或已拒绝状态（这两种状态会有很多操作）
        protected bool isRefuse = false;
        protected bool isCheck = false;   // 页面是否提供checkbox 提供选择
        protected List<d_cost_code> cateList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY);
        protected List<d_general> accTypeList = new d_general_dal().GetGeneralByTableId((int)DTO.GeneralTableEnum.ACCOUNT_TYPE);
        protected List<d_general> payTypeList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.PAYMENT_TYPE);
        protected CompanyBLL cBLL = new CompanyBLL();
        protected crm_account defAcc = null;
        protected sdk_task_dal stDal = new sdk_task_dal();
        protected pro_project_dal ppDal = new pro_project_dal();
        protected void Page_Load(object sender, EventArgs e)
        {
            var thisId = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(thisId))
            {
                thisReport = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(thisId));
            }
            if (thisReport == null)
            {
                Response.Write("<script>alert('报表已删除');window.close();</script>");
            }
            else
            {
                defAcc = cBLL.GetDefaultAccount();
                if (thisReport.status_id==(int)DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED|| thisReport.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.HAVE_IN_HAND)
                {
                    isSubmit = true;
                    if (thisReport.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED)
                    {
                        isRefuse = true;
                    }
                }
                var isAtt = Request.QueryString["ShowAtt"];
                if (!string.IsNullOrEmpty(isAtt))
                {
                    isReport = false;
                }
                var isCk = Request.QueryString["isCheck"];
                if (!string.IsNullOrEmpty(isCk))
                {
                    isCheck = true;
                }
                attList = new com_attachment_dal().GetAttListByOid(thisReport.id);
                expList = new sdk_expense_dal().GetExpByReport(thisReport.id);
            }
        }
    }
}