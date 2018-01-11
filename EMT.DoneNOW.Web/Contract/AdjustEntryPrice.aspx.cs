using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class AdjustEntryPrice : BasePage
    {
        protected sdk_work_entry thisEntry = null;
        protected sdk_task thisTask = null;
        protected decimal? searchRate = null;  // 该员工的实际的费率
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var thisId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisEntry = new sdk_work_entry_dal().FindNoDeleteById(long.Parse(thisId));
                    if (thisEntry != null)
                    {
                        thisTask = new sdk_task_dal().FindNoDeleteById(thisEntry.task_id);
                    }
                  
                    
                }

                if (thisEntry == null|| thisTask==null)
                {
                    Response.Write("<script>alert('未找到该工时信息！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    if (thisEntry.contract_id != null)
                    {
                        var thisObject = new sdk_work_entry_dal().GetSingle($"select f_get_labor_rate({(long)thisEntry.contract_id},{thisEntry.cost_code_id.ToString()},{thisEntry.role_id.ToString()})");
                        if (thisObject != null)
                        {
                            searchRate = (decimal)thisObject;
                        }
                    }
                }

            }
            catch (Exception)
            {
                Response.End();
            }
            
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {

            decimal? hours_billed_deduction = null;
            decimal? hours_rate_deduction = null;
            if (!string.IsNullOrEmpty(Request.Form["hours_billed_deduction"]))
            {
                hours_billed_deduction = decimal.Parse(Request.Form["hours_billed_deduction"]);
            }
            if (!string.IsNullOrEmpty(Request.Form["hours_rate_deduction"]))
            {
                hours_rate_deduction = decimal.Parse(Request.Form["hours_rate_deduction"]);
            }
            var result = new ApproveAndPostBLL().EditEntryApp(thisEntry.id, hours_billed_deduction, hours_rate_deduction,LoginUserId);

            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload(); </script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close();self.opener.location.reload(); </script>");
            }
            
        }
    }
}