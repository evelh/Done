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

namespace EMT.DoneNOW.Web.Contract
{
    public partial class AddCharges : BasePage
    {
        protected bool isAdd = true;
        protected ctt_contract_cost conCost = null;
        protected ctt_contract contract = null;
        protected Dictionary<string, object> dic = new ContractBLL().GetField();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var cost_id = Request.QueryString["id"];
                var contract_id = Request.QueryString["contract_id"];
                #region 下拉框赋值
                cost_type_id.DataTextField = "show";
                cost_type_id.DataValueField = "val";
                cost_type_id.DataSource = dic.FirstOrDefault(_ => _.Key == "chargeType").Value;
                cost_type_id.DataBind();
                cost_type_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                cost_type_id.SelectedValue = ((int)DicEnum.COST_TYPE.OPERATIONA).ToString();
                
                // status_id
                status_id.DataTextField = "show";
                status_id.DataValueField = "val";
                status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "chargeStatus").Value;
                status_id.DataBind();
                status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                status_id.SelectedValue = ((int)DicEnum.COST_STATUS.PENDING_DELIVERY).ToString();
                #endregion
                contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                if (contract != null)
                {
                    if (!IsPostBack)
                    {
                        isbillable.Checked = true;
                    }
                    if (!string.IsNullOrEmpty(cost_id))
                    {
                        conCost = new ctt_contract_cost_dal().FindNoDeleteById(long.Parse(cost_id));
                        if (conCost != null)
                        {
                            isAdd = false;
                            cost_type_id.SelectedValue = conCost.cost_type_id == null ? ((int)DicEnum.COST_TYPE.OPERATIONA).ToString() : conCost.cost_type_id.ToString();
                            status_id.SelectedValue = conCost.status_id.ToString();
                            if (!IsPostBack)
                            {
                                isbillable.Checked = conCost.is_billable == 1;
                                AddConfigItem.Checked = conCost.create_ci == 1;
                            }

                            
                        }
                    }
                  
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 获取到页面参数
        /// </summary>
        /// <returns></returns>
        protected AddChargeDto GetParam()
        {
            var thisConCost = AssembleModel<ctt_contract_cost>();
            AddChargeDto param = new AddChargeDto();
            param.isAddCongigItem = AddConfigItem.Checked;
            thisConCost.is_billable = (sbyte)(isbillable.Checked?1:0);
            //thisConCost.create_ci = (sbyte)(AddConfigItem.Checked ? 1 : 0);
            if (!isAdd)
            {
                thisConCost.id = conCost.id;
                thisConCost.contract_block_id = conCost.contract_block_id;
                thisConCost.project_id = conCost.project_id;
                thisConCost.ticket_id = conCost.ticket_id;
                thisConCost.opportunity_id = conCost.opportunity_id;
                thisConCost.quote_item_id = conCost.quote_item_id; 
                thisConCost.creatorobjectid = conCost.creatorobjectid; 
                thisConCost.create_time = conCost.create_time; 
                thisConCost.create_user_id = conCost.create_user_id;
                thisConCost.extended_price = thisConCost.unit_price * thisConCost.quantity;


            }
            thisConCost.contract_id = contract.id;
            param.cost = thisConCost;
            return param;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param,GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId());
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close(); </script>");
                    if (param.isAddCongigItem)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "打开新窗口", "<script>alert('保存成功！');window.close(); </script>");
                    }
                  
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param, GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId());
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！'); </script>");
                    Response.Redirect("AddCharges.aspx?contract_id=" + contract.id + "&id=" + param.cost.id);
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param, GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId());
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！'); </script>");
                    Response.Redirect("AddCharges.aspx?contract_id=" + contract.id);
                    break;
                case ERROR_CODE.PARAMS_ERROR:
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失，请重新填写'); </script>");
                    break;
                case ERROR_CODE.USER_NOT_FIND:
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                    break;
                default:
                    break;
            }
        }
    }
}