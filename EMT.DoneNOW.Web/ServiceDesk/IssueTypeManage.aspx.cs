using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class IssueTypeManage : BasePage
    {
        protected bool isAdd = true;
        protected d_general thisIssue;
        protected List<d_general> subIssueList = null;
        protected List<sys_department> depList = new DAL.sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected GeneralBLL genBll = new GeneralBLL();
        protected int tableId = (int)DTO.GeneralTableEnum.TASK_ISSUE_TYPE;
        int? parentId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["parentId"]))
                parentId = int.Parse(Request.QueryString["parentId"]);
            if (!string.IsNullOrEmpty(Request.QueryString["tableId"]))
                int.TryParse(Request.QueryString["tableId"],out tableId);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisIssue = genBll.GetSingleGeneral(id);
            if (thisIssue != null)
            {
                isAdd = false;
                tableId = thisIssue.general_table_id;
                if (tableId == (int)DTO.GeneralTableEnum.TASK_ISSUE_TYPE)
                {
                    subIssueList = new DAL.d_general_dal().GetGeneralByParentId(thisIssue.id);
                }
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            d_general pageDic = AssembleModel<d_general>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageDic.is_active = 1;
            else
                pageDic.is_active = 0;
            pageDic.parent_id = parentId;
            pageDic.general_table_id = tableId;
            if (!isAdd)
            {
                thisIssue.name = pageDic.name;
                thisIssue.is_active = pageDic.is_active;
                thisIssue.ext1 = pageDic.ext1;
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddGeneral(pageDic, LoginUserId);
            else
                result = genBll.EditGeneral(thisIssue, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}