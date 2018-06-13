using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.Web.General
{
    public partial class GeneralManage : BasePage
    {
        protected int tableId;
        protected d_general_table thisTable;
        protected bool isAdd = true;
        protected d_general thisGeneral;
        protected GeneralBLL genBll = new GeneralBLL();
        protected List<d_general> tempList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["tableId"]))
                int.TryParse(Request.QueryString["tableId"],out tableId);
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                thisGeneral = genBll.GetSingleGeneral(id);
            if (thisGeneral != null)
            {
                isAdd = false;
                tableId = thisGeneral.general_table_id;
            }

            if (tableId == 0)
            {
                Response.Write("<script>alert('未获取到相关信息，请刷新页面后重试！');window.close();</script>");
                return;
            }
            thisTable = new DAL.d_general_table_dal().FindById(tableId);
            if (tableId == (int)GeneralTableEnum.TICKET_STATUS)
            {
                tempList = genBll.GetGeneralByTable((int)GeneralTableEnum.SLA_EVENT_TYPE);
            }
            if (tableId == (int)GeneralTableEnum.PROJECT_STATUS && thisGeneral != null && thisGeneral.is_system == 1)
            {
                Response.Write("<script>alert('系统状态，不能编辑！');window.close();</script>");
                return;
            }

        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            d_general pageDic = AssembleModel<d_general>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageDic.is_active = 1;
            else
                pageDic.is_active = 0;
            pageDic.general_table_id = tableId;

            if (tableId == (int)GeneralTableEnum.TASK_LIBRARY_CATE)
            {
                pageDic.is_active = 1;
            }
            if (!isAdd)
            {
                thisGeneral.name = pageDic.name;
                thisGeneral.is_active = pageDic.is_active;
                if (tableId == (int)DTO.GeneralTableEnum.TASK_SOURCE_TYPES)
                {
                    thisGeneral.sort_order = pageDic.sort_order;
                }
                else if (tableId == (int)GeneralTableEnum.TICKET_STATUS)
                {
                    thisGeneral.ext1 = pageDic.ext1;
                }
                else if (tableId == (int)GeneralTableEnum.TASK_LIBRARY_CATE)
                {
                    thisGeneral.status_id = pageDic.status_id;
                    thisGeneral.remark= pageDic.remark;
                }
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddGeneral(pageDic, LoginUserId);
            else
                result = genBll.EditGeneral(thisGeneral, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}