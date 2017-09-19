using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Invoice
{
    public partial class InvoiceWizard : BasePage
    {
        protected Dictionary<string, object> dic = new InvoiceBLL().GetField();
        protected crm_account_deduction accDed = null;
        protected crm_account account = null;
        protected List<crm_account_deduction> accDedList = null;
        protected crm_account_deduction_dal accDedDal = new crm_account_deduction_dal();
        protected List<UserDefinedFieldDto> contract_udfList = null;
        //protected List<UserDefinedFieldValue> contract_udfValueList = null; //company
        protected string isCheckSunAccountPara;  // 是否勾选客户的子客户
        protected string itemStartDatePara;
        protected string itemEndDatePara;
        protected string contractTypePara;
        protected string contractCatePara;
        protected string prijectItemPara;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var account_id = Request.QueryString["account_id"];
                contract_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
                account = new CompanyBLL().GetCompany(long.Parse(account_id));


                PageDataBind();
            }
            catch (Exception)
            {
                Response.End();
            }
        }

        /// <summary>
        /// 为页面上的数据源赋值
        /// </summary>
        protected void PageDataBind()
        {
            invoice_tmpl_id.DataValueField = "id";
            invoice_tmpl_id.DataTextField = "name";
            invoice_tmpl_id.DataSource = dic.FirstOrDefault(_ => _.Key == "invoice_tmpl").Value;
            invoice_tmpl_id.DataBind();
            invoice_tmpl_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            
            department_id.DataValueField = "id";
            department_id.DataTextField = "name";
            department_id.DataSource = dic.FirstOrDefault(_ => _.Key == "department").Value;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
            // contract_type_id
            contract_type_id.DataValueField = "val";
            contract_type_id.DataTextField = "show";
            contract_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "contract_type").Value;
            contract_type_id.DataBind();
            contract_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            contract_cate_id.DataValueField = "val";
            contract_cate_id.DataTextField = "show";
            contract_cate_id.DataSource = dic.FirstOrDefault(_ => _.Key == "contract_cate").Value;
            contract_cate_id.DataBind();
            contract_cate_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            tax_region.DataTextField = "show";
            tax_region.DataValueField = "val";
            tax_region.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
            tax_region.DataBind();
            tax_region.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });




            account_idHidden.Value = account.id.ToString();
           
        }
        /// <summary>
        /// 根据第一页的查询条件，显示第二页的内容
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void lbnext_Click(object sender, EventArgs e)
        {
            var accountId = account_idHidden.Value;
            var showChildAcc = ckchildAccounts.Checked;
            var showserviceContract = ckserviceContract.Checked;
            var showFixPrice = ckFixPrice.Checked;
            var showPriceZero = ckPirceZero.Checked;
            var project_id = project_idHidden.Value;
            var department = department_id.SelectedValue;
            var startDate = itemStartDate.Value;
            var endDate = itemEndDate.Value;
            var contractType = contract_type_id.SelectedValue;
            var contractCate = contract_cate_id.SelectedValue;
            var projectItem = project_item.SelectedIndex;
            // var type = type_id.SelectedIndex;  // 条目类型-多选--toTest

            var cadDal = new crm_account_deduction_dal();

            var chooseAccount = new CompanyBLL().GetCompany(long.Parse(accountId));
            if (chooseAccount == null)
                return;
            accDedList = cadDal.GetAccDed(chooseAccount.id);
            if (accDedList == null)
                accDedList = new List<crm_account_deduction>();
            if (showChildAcc) // 代表用户选中展示子客户条目
            {
                var childAccList = new crm_account_dal().GetSubsidiariesById(chooseAccount.id);
                if(childAccList!=null&& childAccList.Count > 0)
                {
                    foreach (var childAcc in childAccList)
                    {
                        var childAccDedList = cadDal.GetAccDed(childAcc.id);
                        accDedList.AddRange(childAccDedList); // 循环添加子客户条目
                    }
                }
            }

            // todo 其余三个Show的过滤

            if (string.IsNullOrEmpty(project_id))
            {
                
            }



        }

        protected void finish_Click(object sender, EventArgs e)
        {

        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        protected void GetParam()
        {

        }
    }
}