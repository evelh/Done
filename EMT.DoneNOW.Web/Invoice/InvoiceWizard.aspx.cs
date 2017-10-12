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
using System.Text;

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
        protected string projectItemPara;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var account_id = Request.QueryString["account_id"];
                itemStartDatePara = Request.QueryString["stareDate"];
                itemEndDatePara = Request.QueryString["endDate"];
                contractTypePara = Request.QueryString["contract_type"];
                contractCatePara = Request.QueryString["contract_cate"];
                projectItemPara = Request.QueryString["itemDeal"];


                contract_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);
                account = new CompanyBLL().GetCompany(long.Parse(account_id));

                if (!IsPostBack)
                {
                    PageDataBind();
                    if (!string.IsNullOrEmpty(itemStartDatePara))
                    {
                        itemStartDate.Value = itemStartDatePara;
                    }
                    if (!string.IsNullOrEmpty(itemEndDatePara))
                    {
                        itemEndDate.Value = itemEndDatePara;
                    }
                    if (!string.IsNullOrEmpty(contractTypePara))
                    {
                        contract_type_id.SelectedValue = contractTypePara;
                    }
                    if (!string.IsNullOrEmpty(contractCatePara))
                    {
                        contract_cate_id.SelectedValue = contractCatePara;
                    }
                    if (!string.IsNullOrEmpty(projectItemPara))
                    {

                    }
                 
                    var childAccList = new crm_account_dal().GetSubsidiariesById(account.id);
                    if(childAccList!=null&& childAccList.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(isCheckSunAccountPara))
                        {
                            ckchildAccounts.Checked = true;
                        }
                    }
                    else
                    {
                        ckchildAccounts.Enabled = false;
                    }

                }
                
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
            // payment_term
            tax_region.DataTextField = "show";
            tax_region.DataValueField = "val";
            tax_region.DataSource = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value;
            tax_region.DataBind();
            tax_region.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });

            payment_term_id.DataTextField = "show";
            payment_term_id.DataValueField = "val";
            payment_term_id.DataSource = dic.FirstOrDefault(_ => _.Key == "payment_term").Value;
            payment_term_id.DataBind();
            payment_term_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });




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
            var project_item = projectItem.SelectedValue;
            var type = thisItemTypeId.Value;  // 条目类型-多选--toTest
            var cadDal = new crm_account_deduction_dal();

            var chooseAccount = new CompanyBLL().GetCompany(long.Parse(accountId));
            if (chooseAccount == null)
                return;
          
            //accDedList = cadDal.GetAccDed(chooseAccount.id);  // 将要在页面上显示的条目
            //if (accDedList == null)
            //    accDedList = new List<crm_account_deduction>();

            StringBuilder sqlWhere = new StringBuilder();

            if (!string.IsNullOrEmpty(project_id))
            {
                sqlWhere.Append($" and project_id={project_id}");
            }
            if ((!string.IsNullOrEmpty(department)) && (department != "0"))
            {
                sqlWhere.Append($" and department_id={department}");
            }
            if (!string.IsNullOrEmpty(startDate))
            {
                sqlWhere.Append($" and item_date>='{startDate}'");
            }
            if (!string.IsNullOrEmpty(endDate))
            {
                sqlWhere.Append($" and item_date<='{endDate}'");
            }
            if (!string.IsNullOrEmpty(type))
            {
                sqlWhere.Append($" and item_type in ({type}) ");
            }
            if((!string.IsNullOrEmpty(contractType))&& contractType != "0")
            {
                sqlWhere.Append($" and contract_type_id={contractType}");
            }
            if ((!string.IsNullOrEmpty(contractCate)) && contractCate != "0")
            {
                sqlWhere.Append($" and contract_cate_id={contractCate}");
            }
            if (project_item == "onlyProject")
            {
                sqlWhere.Append($" and project_id is not null");
            }
            if (project_item == "onlyNoProject")
            {
                sqlWhere.Append($" and project_id is null");
            }

            // todo 其余三个Show的过滤

            if (!showserviceContract)
            {
                sqlWhere.Append($" and (item_type in(1318,1319) and contract_type_id not in(1199) or  item_type not in(1318,1319) )");
            }
            if (!showFixPrice)
            {
                sqlWhere.Append($" and  (item_type in(1318,1319) and contract_type_id not in(1201) or  item_type not in(1318,1319) )");
            }
            if (showPriceZero)
            {
                sqlWhere.Append($" and dollars <>0");
            }

            List<InvoiceDeductionDto> deeList = null;
            var sortOrder = Request.QueryString["sortOrder"];
            switch (sortOrder)
            {
                case "1":    // 客户
                    deeList = cadDal.GetInvDedDtoList(sqlWhere.ToString() + " and account_id=" + chooseAccount.id.ToString() + " and    invoice_id is null and purchase_order_no is null");
                    break;
                case "2":    // ticket
                    deeList = cadDal.GetInvDedDtoList(sqlWhere.ToString() + " and account_id=" + chooseAccount.id.ToString() + " and    invoice_id is null and purchase_order_no is null AND project_id is null");
                    break;
                case "3":    // 项目
                    var thisProject = Request.QueryString["thisProject"];
                    deeList = cadDal.GetInvDedDtoList(sqlWhere.ToString() + " and account_id=" + chooseAccount.id.ToString() + " and    invoice_id is null and purchase_order_no is null AND project_id = " + thisProject);
                    break;
                case "4":    // 采购订单
                    var thisPurOrder = Request.QueryString["thisPurOrder"];
                    if (!string.IsNullOrEmpty(thisPurOrder))
                    {
                        thisPurOrder = thisPurOrder.Substring(5, thisPurOrder.Length - 5);
                        deeList = cadDal.GetInvDedDtoList(sqlWhere.ToString() + " and account_id=" + chooseAccount.id.ToString() + " and    invoice_id is null and purchase_order_no =" + thisPurOrder);
                    }
                    break;
                default:
                    break;
            }


            #region  加上子公司的条目
            if (showChildAcc) // 代表用户选中展示子客户条目
            {
                var childAccList = new crm_account_dal().GetSubsidiariesById(chooseAccount.id);
                if (childAccList != null && childAccList.Count > 0)
                {
                    foreach (var childAcc in childAccList)
                    {
                        var childAccDedList = cadDal.GetInvDedDtoList(sqlWhere.ToString()+ " and account_id=" + childAcc.id);  //+ " and bill_account_id <>"+ chooseAccount.id
                        if (childAccDedList != null && childAccDedList.Count > 0)
                        {
                            childAccDedList.ForEach(_ => {                        
                                    _.isSub = "1";
                            });
                            deeList.AddRange(childAccDedList); // 循环添加子客户条目
                        }
                    }
                }
            }
            StringBuilder dedHtml = new StringBuilder();
            if (deeList != null && deeList.Count > 0)
            {
                deeList = deeList.Distinct().ToList();
                foreach (var invDedDto in deeList)
                {
                    // 1 代表是不可选的子客户
                    // 2 待定 可选但是默认不选
                    var ischeck = invDedDto.isSub == "1" ? "disabled" : invDedDto.isSub == "2"?"": "checked";

                    var imgSrc = invDedDto.type_icon; // 根据类型选择图片位置

                    var itemName = invDedDto.item_name;  // todo 部分有下标名
                    var rate = invDedDto.rate == null ? "" : ((decimal)invDedDto.rate).ToString("#0.00");
                    var quantity = invDedDto.quantity == null ? "" : ((decimal)invDedDto.quantity).ToString("#0.00");
                    var dollars = invDedDto.dollars == null ? "" : ((decimal)invDedDto.dollars).ToString("#0.00");
                    var bill_to_parent = string.IsNullOrEmpty(invDedDto.bill_to_parent) ? "" : "√";
                    var bill_to_sub = string.IsNullOrEmpty(invDedDto.bill_to_sub) ? "" : "√";

                    dedHtml.Append($"<tr><td align='center' style='width: 20px;'><input type='checkbox' class='thisDedCheck' style='margin: 0;' value='{invDedDto.id}' {ischeck}></td><td width='20px' align='center'><img src='{imgSrc}' /></td> <td width='20' align='center'>{invDedDto.item_date}</td><td>{itemName}</td><td>{invDedDto.account_name}</td><td>{invDedDto.contract_name}</td><td>{invDedDto.department_name}</td><td>{invDedDto.cost_code_name}</td><td>{invDedDto.resource_name}</td><td>{invDedDto.role_name}</td><td>{invDedDto.project_name}</td><td>{rate}</td><td>{quantity}</td><td>{dollars}</td><td>{invDedDto.tax_category_name}</td><td>{bill_to_parent}</td><td>{bill_to_sub}</td></tr>");
                    //showAccountDed
                  
                }
                //ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script></script>");
            }


            ClientScript.RegisterStartupScript(this.GetType(), "页面跳转", "<script>document.getElementById('showAccountDed').innerHTML=\"" + dedHtml.ToString() + "\";document.getElementsByClassName('Workspace1')[0].style.display = 'none';document.getElementsByClassName('Workspace2')[0].style.display = '';document.getElementById('date_range_from').value=\""+ startDate + "\";document.getElementById('date_range_to').value=\"" + endDate + "\";</script>");

            #endregion




        }

        protected void finish_Click(object sender, EventArgs e)
        {
            FinishInvoice();
        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        protected InvoiceDealDto GetParam()
        {
            var param = AssembleModel<InvoiceDealDto>();
            //var invoice = AssembleModel<ctt_invoice>();
            param.ids = Request.Form["accDedIds"];
            param.payment_term_id = param.payment_term_id == 0 ? null : param.payment_term_id;
            param.invoice_template_id = int.Parse(Request.Form["invoice_tmpl_id"]);
            param.isShowPrint = invShow.Checked;
            param.isShowEmail = emailShow.Checked;
            param.isQuickBooks = quickBookShow.Checked;

            if (contract_udfList != null && contract_udfList.Count > 0)                      
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in contract_udfList)                          
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                param.udf = list;
            }
            return param;
        }

        protected void finishNowC3_Click(object sender, EventArgs e)
        {
            FinishInvoice();
        }

        protected void FinishNowC4_Click(object sender, EventArgs e)
        {
            FinishInvoice();
        }
        /// <summary>
        /// 生成发票向导完成事件
        /// </summary>
        protected void FinishInvoice()
        {
            var param = GetParam();
            var result = new InvoiceBLL().ProcessInvoice(param, GetLoginUserId());
            if (result)
            {
                // 根据页面选择，展示不同的显示--暂时只支持打印预览
                if (param.isShowPrint)
                {

                }
            }
            else
            {

            }
        }
    }
}