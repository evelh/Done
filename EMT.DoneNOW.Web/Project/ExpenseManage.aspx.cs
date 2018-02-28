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

namespace EMT.DoneNOW.Web.Project
{
    public partial class ExpenseManage : BasePage
    {
        protected bool isAdd = true;
        protected sdk_task thisTask = null;
        protected pro_project thisProject = null;
        protected sdk_expense thisExpense = null;
        protected sdk_expense_report thisExpRep = null;
        protected crm_account thisAccount = null;
        protected sdk_task thisTicket = null;   // 从工单进行新增费用操作
        protected bool isShowWorkType = true;
        protected bool isFromReport = false;  // 是否从报表页面进行新增操作
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    PageDataBind();
                }
               isShowWorkType = new SysSettingBLL().GetValueById(SysSettingEnum.SDK_EXPENSE_SHOW_WORK_TYPE)=="1";// SDK_EXPENSE_SHOW_WORK_TYPE
                var seDal = new sdk_expense_dal();
                var stDal = new sdk_task_dal();
                var eId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(eId))
                {
                    thisExpense = seDal.FindNoDeleteById(long.Parse(eId));
                    if (thisExpense != null)
                    {
                        if (thisExpense.approve_and_post_date != null || thisExpense.approve_and_post_user_id!=null)
                        {
                            Response.Write("<script>alert('审批提交的费用不可以更改！')window.close();</script>");
                            Response.End();
                        }
                        if(!new TaskBLL().CanEditExpense(thisExpense.id))
                        {
                            Response.Write("<script>alert('相关报表状态已经更改，不可以进行编辑！');window.close();</script>");
                            Response.End();
                        }

                        isAdd = false;

                        if (!IsPostBack)
                        {
                            if (thisExpense.cost_code_id != null)
                            {
                                cost_code_id.SelectedValue = thisExpense.cost_code_id.ToString();
                            }
                           expense_cost_code_id.SelectedValue = thisExpense.expense_cost_code_id.ToString();
                            RDAddExiRep.Checked = true;
                            isBillable.Checked = thisExpense.is_billable == 1;
                            payment_type_id.SelectedValue = thisExpense.payment_type_id.ToString();
                            hasReceipt.Checked = thisExpense.has_receipt==1;
                            if (thisExpense.project_id != null)
                            {
                                rbAssProTask.Checked = true;
                            }
                            else
                            {
                                rbAssNone.Checked = true;

                            }
                        }

                        if (thisExpense.project_id != null)
                        {
                            thisProject = new pro_project_dal().FindNoDeleteById((long)thisExpense.project_id);
                        }
                        if (thisExpense.project_id != null&&thisExpense.task_id != null)
                        {
                            thisTask = new sdk_task_dal().FindNoDeleteById((long)thisExpense.task_id);
                        }
                        if(thisExpense.project_id==null&& thisExpense.task_id != null)
                        {
                            thisTicket = new sdk_task_dal().FindNoDeleteById((long)thisExpense.task_id);
                        }
                        thisAccount = new crm_account_dal().FindNoDeleteById(thisExpense.account_id);
                        thisExpRep = new sdk_expense_report_dal().FindNoDeleteById(thisExpense.expense_report_id);
                    }
                }
                var task_id = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(task_id))
                {
                    thisTask = stDal.FindNoDeleteById(long.Parse(task_id));
                    if (thisTask != null&&thisTask.project_id!=null)
                    {
                        thisProject = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                        if (thisProject != null)
                        {
                            thisAccount = new crm_account_dal().FindNoDeleteById(thisProject.account_id);
                        }
                    }
                }
                var project_id = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                    if (thisProject != null)
                    {
                        thisAccount = new crm_account_dal().FindNoDeleteById(thisProject.account_id);
                    }
                }

                var report_id = Request.QueryString["report_id"];
                if (!string.IsNullOrEmpty(report_id))
                {
                    thisExpRep = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(report_id));
                    if (thisExpRep != null)
                    {
                        isFromReport = true;
                        thisAccount = new CompanyBLL().GetDefaultAccount();
                    }
                }

                var ticket_id = Request.QueryString["ticket_id"];
                if (!string.IsNullOrEmpty(ticket_id))
                {
                    thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticket_id));
                    if (thisTicket != null)
                    {
                        thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                    }
                }

            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 页面数据绑定
        /// </summary>
        private void PageDataBind()
        {
            var cateList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY);
            expense_cost_code_id.DataTextField = "name";
            expense_cost_code_id.DataValueField = "id";
            expense_cost_code_id.DataSource = cateList;
            expense_cost_code_id.DataBind();

            var workList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
            cost_code_id.DataTextField = "name";
            cost_code_id.DataValueField = "id";
            cost_code_id.DataSource = workList;  
            cost_code_id.DataBind();

            var payTypeList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.PAYMENT_TYPE);
            payment_type_id.DataTextField = "name";
            payment_type_id.DataValueField = "id";
            payment_type_id.DataSource = payTypeList;
            payment_type_id.DataBind();


            RDAddRep.Checked = true;
            rbAssProTask.Checked = true;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {

            var result = GetResult();
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存费用成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存费用失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        private ExpenseDto GetParam()
        {
            var param = new ExpenseDto();
            if (RDAddRep.Checked)
            {
                var repTitle = Request.Form["title"];
                var repEndDate = Request.Form["end_date"];
                var reprAmount = Request.Form["report_amount"];
                if (!string.IsNullOrEmpty(repTitle) && !string.IsNullOrEmpty(repEndDate))
                {
                    var expRep = new sdk_expense_report() {
                        title = repTitle,
                        end_date = DateTime.Parse(repEndDate),
                    };
                    if (!string.IsNullOrEmpty(reprAmount))
                    {
                        expRep.cash_advance_amount = decimal.Parse(reprAmount);
                    }
                    param.thisExpReport = expRep;
                }
            }
            else if (RDAddExiRep.Checked)
            {
                var expense_report_id = Request.Form["expense_report_id"];
                if (!string.IsNullOrEmpty(expense_report_id))
                {
                    var expRep = new sdk_expense_report_dal().FindNoDeleteById(long.Parse(expense_report_id));
                    if (expRep != null)
                    {
                        param.thisExpReport = expRep;
                    }
                }
            }
            var pageExp = new sdk_expense();
            pageExp.add_date = DateTime.Parse(Request.Form["add_date"]);
            pageExp.is_billable = (sbyte)(isBillable.Checked?1:0);
            if (isShowWorkType)
            {
                var cost_code_id = Request.Form["cost_code_id"];
                if (!string.IsNullOrEmpty(cost_code_id))
                {
                    pageExp.cost_code_id = long.Parse(cost_code_id);
                }
            }
            pageExp.description = Request.Form["description"];

            pageExp.expense_cost_code_id = int.Parse(Request.Form["expense_cost_code_id"]);
            if (pageExp.expense_cost_code_id == (int)CostCode.ENTERTAINMENT_EXPENSE)
            {
                pageExp.location = Request.Form["location"];
            }
            else if(pageExp.expense_cost_code_id == (int)CostCode.MILEAGE)
            {
                pageExp.from_loc = Request.Form["from_loc"];
                pageExp.to_loc = Request.Form["to_loc"];
                var odometer_start = Request.Form["odometer_start"];
                if (!string.IsNullOrEmpty(odometer_start))
                {
                    pageExp.odometer_start = decimal.Parse(odometer_start);
                }
                
                pageExp.odometer_end = decimal.Parse(Request.Form["odometer_end"]);
                var miles = Request.Form["miles"];
                if (!string.IsNullOrEmpty(miles))
                {
                    pageExp.miles = decimal.Parse(miles);
                }
                else
                {
                    pageExp.miles = pageExp.odometer_end - pageExp.odometer_start;
                }
              
            }
            else
            {
                //var amount = long.Parse(Request.Form["amount"]);
                //var moneyHidden = Request.Form["moneyHidden"];
                //if (!string.IsNullOrEmpty(moneyHidden))
                //{
                //    var money = decimal.Parse(moneyHidden);
                //    if (amount > money)
                //    {
                //        var overdraft_policy_id = Request.Form["overdraft_policy_id"];
                //    }
                //    else
                //    {
                //        pageExp.amount = amount;
                //    }
                //}
                //else
                //{
                    //pageExp.amount = amount;
                //}
            }
            pageExp.amount = decimal.Parse(Request.Form["amount"]);
            var esType = new d_cost_code_dal().FindNoDeleteById((long)pageExp.expense_cost_code_id);
            if (esType != null&& esType.expense_type_id!=null)
            {
                pageExp.type_id = (int)esType.expense_type_id;
            }

            pageExp.payment_type_id = int.Parse(Request.Form["payment_type_id"]);
            var thisPay = new d_general_dal().FindNoDeleteById(pageExp.payment_type_id);
            if (thisPay != null)
            {

            }
            pageExp.has_receipt = (sbyte)(hasReceipt.Checked?1:0);
            pageExp.account_id = long.Parse(Request.Form["account_id"]);
            if (rbAssTask.Checked)
            {
                var ticket_id = Request.Form["ticket_id"];
                if (!string.IsNullOrEmpty(ticket_id))
                {
                    pageExp.task_id = long.Parse(ticket_id);
                }
            }
            else if (rbAssProTask.Checked)
            {
                pageExp.project_id = long.Parse(Request.Form["project_id"]);

                var task_id = Request.Form["task_id"];
                if (!string.IsNullOrEmpty(task_id))
                {
                    pageExp.task_id = long.Parse(task_id);
                }
            }
            pageExp.purchase_order_no = Request.Form["purchase_order_no"];
            if (!isAdd)
            {
                pageExp.id = thisExpense.id;
                pageExp.oid = thisExpense.oid;
                pageExp.create_user_id = thisExpense.create_user_id;
                pageExp.create_time = thisExpense.create_time;
                pageExp.is_approved = thisExpense.is_approved;
                pageExp.approve_and_post_user_id = thisExpense.approve_and_post_user_id;
                pageExp.approve_and_post_date = thisExpense.approve_and_post_date;
                pageExp.amountrate = thisExpense.amountrate;
                pageExp.purpose = thisExpense.purpose;
                pageExp.extacctitemid = thisExpense.extacctitemid;
                pageExp.web_service_date = thisExpense.web_service_date;
                pageExp.currency_id = thisExpense.currency_id;
            }
            param.thisExpense = pageExp;
            return param;
        }

        private bool GetResult()
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                result = new TaskBLL().AddExpense(param,GetLoginUserId());
            }
            else
            {
                result = new TaskBLL().EditExpense(param,GetLoginUserId());
            }
            return result;
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = false;
            if (isAdd)
            {
                result = new TaskBLL().AddExpense(param, GetLoginUserId());
            }
            else
            {
                result = new TaskBLL().EditExpense(param, GetLoginUserId());
            }
            if (result)
            {
                var thisurl = Request.Url;
                var url = "ExpenseManage?";
                if (param.thisExpense.project_id!=null)
                {
                    url += "project_id="+ param.thisExpense.project_id;
                    if (param.thisExpense.task_id != null)
                    {
                        url += "&task_id="+ param.thisExpense.task_id;
                    }
                }
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存费用成功！');self.opener.location.reload();location.href='" + thisurl + "';</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存费用失败！');window.close();self.opener.location.reload();</script>");
            }
        }
    }
}