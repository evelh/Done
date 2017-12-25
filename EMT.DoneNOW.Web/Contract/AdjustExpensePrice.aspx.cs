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
    public partial class AdjustExpensePrice : BasePage
    {
        protected sdk_expense thisExp = null;
        protected crm_account thisAcc = null;
        protected void Page_Load(object sender, EventArgs e)
        {

            try
            {
                var thisId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisExp = new sdk_expense_dal().FindNoDeleteById(long.Parse(thisId));
                    if (thisExp != null)
                    {
                        thisAcc = new CompanyBLL().GetCompany(thisExp.account_id);
                    }
                }

                if (thisExp == null|| thisAcc==null)
                {
                    Response.Write("<script>alert('未找到该工时信息！');window.close();self.opener.location.reload();</script>");
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }

        protected void Save_Close_Click(object sender, EventArgs e)
        {
            decimal? amount_deduction = null;
            if (!string.IsNullOrEmpty(Request.Form["amount_deduction"]))
            {
                amount_deduction = decimal.Parse(Request.Form["amount_deduction"]);
            }
            var result = new ApproveAndPostBLL().EditExpApp(thisExp.id, amount_deduction, LoginUserId);

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