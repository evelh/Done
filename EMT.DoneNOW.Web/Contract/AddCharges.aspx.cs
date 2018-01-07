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
        protected pro_project thisProject = null;
        protected sdk_task thisTask = null;
        protected Dictionary<string, object> dic = new ContractBLL().GetField();
        protected d_cost_code costCode = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var cost_id = Request.QueryString["id"];
                var contract_id = Request.QueryString["contract_id"];
                var project_id = Request.QueryString["project_id"];
                var task_id = Request.QueryString["task_id"];

                var costCodeId = Request.QueryString["cost_code_id"];
                if (!string.IsNullOrEmpty(costCodeId))
                {
                    costCode = new d_cost_code_dal().FindNoDeleteById(long.Parse(costCodeId));

                }

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
                var statuList =   dic.FirstOrDefault(_ => _.Key == "chargeStatus").Value as List<DictionaryEntryDto>;
               
                #endregion
                if (!string.IsNullOrEmpty(contract_id))
                {
                    contract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                    if (contract != null)
                    {
                        if (!IsPostBack)
                        {
                            isbillable.Checked = true;
                        }
                    }
                }
                if (!string.IsNullOrEmpty(cost_id))
                {
                    conCost = new ctt_contract_cost_dal().FindNoDeleteById(long.Parse(cost_id));
                    if (conCost != null)
                    {
                        isAdd = false;
                        costCode = new d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);

                        cost_type_id.SelectedValue = conCost.cost_type_id == null ? ((int)DicEnum.COST_TYPE.OPERATIONA).ToString() : conCost.cost_type_id.ToString();
                        if (!IsPostBack)
                        {
                            status_id.SelectedValue = conCost.status_id.ToString();
                        }
                        
                        
                        if (conCost.contract_id != null) {
                            contract = new ctt_contract_dal().FindNoDeleteById((long)conCost.contract_id);
                        }
                        if (conCost.project_id != null)
                        {
                            thisProject = new pro_project_dal().FindNoDeleteById((long)conCost.project_id);
                        }
                        if (conCost.task_id != null)
                        {
                            thisTask = new sdk_task_dal().FindNoDeleteById((long)conCost.task_id);
                        }

                        if (!IsPostBack)
                        {
                            isbillable.Checked = conCost.is_billable == 1;
                            AddConfigItem.Checked = conCost.create_ci == 1;
                        }

                        if (conCost.status_id == (int)DicEnum.COST_STATUS.UNDETERMINED)
                        {
                            statuList = statuList.Where(_ => _.val == (conCost.status_id).ToString() || _.val == ((int)DicEnum.COST_STATUS.PENDING_PURCHASE).ToString() || _.val == ((int)DicEnum.COST_STATUS.CANCELED).ToString()).ToList();
                        }else if (conCost.status_id == (int)DicEnum.COST_STATUS.CANCELED)
                        {
                            statuList = statuList.Where(_ => _.val == (conCost.status_id).ToString() || _.val == ((int)DicEnum.COST_STATUS.PENDING_PURCHASE).ToString() || _.val == ((int)DicEnum.COST_STATUS.CANCELED).ToString()).ToList();
                        }
                        else
                        {
                            statuList = statuList.Where(_ => _.val == (conCost.status_id).ToString() || _.val == ((int)DicEnum.COST_STATUS.CANCELED).ToString()).ToList();
                        }


                    }
                }
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                }
                if (!string.IsNullOrEmpty(task_id))
                {
                    thisTask = new sdk_task_dal().FindNoDeleteById(long.Parse(task_id));
                    if (thisTask != null&& thisTask.project_id!=null)
                    {
                        thisProject = new pro_project_dal().FindNoDeleteById((long)thisTask.project_id);
                    }
                }

                status_id.DataSource = statuList;
                status_id.DataBind();
                //status_id.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                if (!IsPostBack)
                {
                    if (isAdd)
                    {
                        status_id.SelectedValue = ((int)DicEnum.COST_STATUS.PENDING_DELIVERY).ToString();
                    }
                    
                }
                

            }
            catch (Exception msg)
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
            thisConCost.bill_status = 0;
            AddChargeDto param = new AddChargeDto();
            param.isAddCongigItem = AddConfigItem.Checked;
            thisConCost.is_billable = (sbyte)(isbillable.Checked?1:0);
            //thisConCost.create_ci = (sbyte)(AddConfigItem.Checked ? 1 : 0);
            if (!isAdd)
            {
                thisConCost.id = conCost.id;
                thisConCost.contract_block_id = conCost.contract_block_id;
                thisConCost.project_id = conCost.project_id;
                thisConCost.task_id = conCost.task_id;
                thisConCost.opportunity_id = conCost.opportunity_id;
                thisConCost.quote_item_id = conCost.quote_item_id; 
                thisConCost.creatorobjectid = conCost.creatorobjectid; 
                thisConCost.create_time = conCost.create_time; 
                thisConCost.create_user_id = conCost.create_user_id;
                thisConCost.extended_price = thisConCost.unit_price * thisConCost.quantity;
                thisConCost.contract_id = conCost.contract_id;
                thisConCost.sub_cate_id = conCost.sub_cate_id;
                thisConCost.create_time = conCost.create_time;
                thisConCost.create_user_id = conCost.create_user_id;
            }
            if (contract != null)
            {

                thisConCost.contract_id = contract.id;
                thisConCost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
                
            }
            if (thisTask != null)
            {
                thisConCost.task_id = thisTask.id;
                if (thisConCost.changeorder != null&& thisConCost.changeorder !=0)
                {
                    thisTask.projected_variance += (decimal)thisConCost.changeorder;
                    new TaskBLL().OnlyEditTask(thisTask,LoginUserId);  // 修改任务的预估偏差
                }
                var change_order_hours = Request.Form["change_order_hours"];
                if (!string.IsNullOrEmpty(change_order_hours))
                {
                    thisConCost.change_order_hours = decimal.Parse(change_order_hours);
                }
                else
                {
                    thisConCost.change_order_hours = 0;
                }
                //thisConCost.change_order_hours = thisConCost.change_order_hours;
                thisConCost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.TICKET_COST;
            }
            if (thisProject != null)
            {
                thisConCost.project_id = thisProject.id;
                thisConCost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.PROJECT_COST;
            }
            param.cost = thisConCost;
            return param;
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();

            bool isDelShipCost = false;  // 是否删除 配送的运费成本  为true 时，代表需要删除的成本已经审批提交，此时提示用户

            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param,GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId(),out isDelShipCost);
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                  
                    if (param.isAddCongigItem)
                    {
                        var url = "../ConfigurationItem/ConfigItemWizard.aspx?&cost_id=" + param.cost.id;
                        if (contract != null)
                        {
                            url += "&contract_id="+contract.id;
                        }
                        if (thisTask != null)
                        {
                            url += "&task_id=" + thisTask.id;
                        }
                        if (thisProject != null)
                        {
                            url += "&project_id=" + thisProject.id;
                        }
                        if (isDelShipCost)
                        {
                            // 运费成本已审批并提交，无法删除。
                            ClientScript.RegisterStartupScript(this.GetType(), "运费成本信息提示", "<script>alert('运费成本已审批并提交，无法删除！');</script>");
                        }
                        ClientScript.RegisterStartupScript(this.GetType(), "打开新窗口", "<script>alert('保存成功！');window.close();window.open('"+url+"','" + (int)EMT.DoneNOW.DTO.OpenWindow.InstalledProductIwarid + "','left= 200, top = 200, width = 960, height = 750', false);self.opener.location.reload();</script>");
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload(); </script>");
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
            bool isDelShipCost = false;  // 是否删除 配送的运费成本  为true 时，代表需要删除的成本已经审批提交，此时提示用户
            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param, GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId(),out isDelShipCost);
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                   
                    if (param.isAddCongigItem)
                    {
                        var url = "../ConfigurationItem/ConfigItemWizard.aspx?&cost_id=" + param.cost.id;
                        if (contract != null)
                        {
                            url += "&contract_id=" + contract.id;
                        }
                        if (thisTask != null)
                        {
                            url += "&task_id=" + thisTask.id;
                        }
                        if (thisProject != null)
                        {
                            url += "&project_id=" + thisProject.id;
                        }
                        if (isDelShipCost)
                        {
                            // 运费成本已审批并提交，无法删除。
                            ClientScript.RegisterStartupScript(this.GetType(), "运费成本信息提示", "<script>alert('运费成本已审批并提交，无法删除！');</script>");
                        }
                        ClientScript.RegisterStartupScript(this.GetType(), "打开新窗口", "<script>alert('保存成功！');location.href='AddCharges.aspx?id=" + param.cost.id + "';window.open('"+url+"','" + (int)EMT.DoneNOW.DTO.OpenWindow.InstalledProductIwarid + "','left= 200, top = 200, width = 960, height = 750', false);self.opener.location.reload();</script>");
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>debugger;alert('保存成功！');location.href='AddCharges.aspx?id=" + param.cost.id + "';self.opener.location.reload(); </script>");
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

        protected void save_add_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            bool isDelShipCost = false;  // 是否删除 配送的运费成本  为true 时，代表需要删除的成本已经审批提交，此时提示用户
            ERROR_CODE result = ERROR_CODE.SUCCESS;
            if (isAdd)
            {
                result = new ContractCostBLL().InsertCost(param, GetLoginUserId());
            }
            else
            {
                result = new ContractCostBLL().UpdateCost(param, GetLoginUserId(),out isDelShipCost);
            }

            switch (result)
            {
                case ERROR_CODE.SUCCESS:
                    var thisURL = Request.Url;
                    if (param.isAddCongigItem)
                    {
                        
                        var url = "../ConfigurationItem/ConfigItemWizard.aspx?&cost_id=" + param.cost.id;
                        if (contract != null)
                        {
                            url += "&contract_id=" + contract.id;
                        }
                        if (thisTask != null)
                        {
                            url += "&task_id=" + thisTask.id;
                        }
                        if (thisProject != null)
                        {
                            url += "&project_id=" + thisProject.id;
                        }
                        if (isDelShipCost)
                        {
                            // 运费成本已审批并提交，无法删除。
                            ClientScript.RegisterStartupScript(this.GetType(), "运费成本信息提示", "<script>alert('运费成本已审批并提交，无法删除！');</script>");
                        }
                        ClientScript.RegisterStartupScript(this.GetType(), "打开新窗口", "<script>alert('保存成功！');location.href='"+ thisURL + "';window.open('"+url+"','" + (int)EMT.DoneNOW.DTO.OpenWindow.InstalledProductIwarid + "','left= 200, top = 200, width = 960, height = 750', false);self.opener.location.reload();</script>");
                    }
                    else
                    {

                        // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');location.href='AddCharges.aspx?contract_id=" + contract.id + "';self.opener.location.reload(); </script>");
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');location.href='"+ thisURL + "';self.opener.location.reload(); </script>");
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
    }
}