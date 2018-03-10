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

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class CopyToProject : BasePage
    {
        protected crm_account thisAccount = null;
        protected List<sdk_task> ticketList = null;
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.DEPARTMENT);
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var ticketIds = Request.QueryString["ticketIds"];
                if (!IsPostBack)
                {
                    if (!string.IsNullOrEmpty(ticketIds))
                        ticketList = new sdk_task_dal().GetTicketByIds(ticketIds);
                    if (ticketList == null || ticketList.Count == 0)
                        Response.Write($"<script>alert('未查询到相关工单信息');window.close();</script>");
                    else if (ticketList.Count == 0)
                        thisAccount = new CompanyBLL().GetCompany(ticketList[0].account_id);
                }
                else
                {
                    var accountId = Request.Form["accountId"];
                    var projectId = Request.Form["projectId"];
                    var departmentId = Request.Form["departmentId"];
                    long? phaseId = null;
                    if(!string.IsNullOrEmpty(Request.Form["phaseId"]))
                        phaseId = long.Parse(Request.Form["phaseId"]);
                    if(!string.IsNullOrEmpty(accountId)&& !string.IsNullOrEmpty(projectId) && !string.IsNullOrEmpty(departmentId))
                    {
                        var result = new TicketBLL().CopyToProject(ticketIds,long.Parse(projectId),long.Parse(departmentId), phaseId,LoginUserId);
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');self.opener.location.reload();window.close();</script>");
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('必填参数丢失');</script>");
                    }
                }
                
            }
            catch (Exception msg)
            {
                Response.Write($"<script>alert('{msg.Message}');window.close();</script>");
            }
        }
    }
}