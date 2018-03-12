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
    public partial class TicketManage : BasePage
    {
        protected sdk_task thisTicket = null;   // 当前工单
        protected bool isAdd = true;            // 新增还是编辑
        protected bool isCopy = false;          // 复制
        protected crm_account thisAccount = null;  // 工单的客户
        protected crm_contact thisContact = null;  // 工单的联系人
        protected sys_resource priRes = null;      // 工单的主负责人
        protected sys_resource_department proResDep = null; // 工单的主负责人
        protected crm_installed_product insPro = null; // 工单的配置项
        protected ctt_contract thisContract = null;    // 工单的合同
        protected d_cost_code thisCostCode = null;     //  工单的工作类型
        protected List<d_sla> slaList = new d_sla_dal().GetList();
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("",(int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<sys_resource_department> ticketResList = null;  // 工单的员工
        protected string ticketResIds = "";   
        protected string CallBack = "";
        protected List<UserDefinedFieldDto> tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;
        protected List<sdk_task_checklist> ticketCheckList = null;   // 工单的检查单集合

        protected Dictionary<string, object> slaDic = null;    // 时间轴显示
        protected List<d_general> ticketNoteTypeList = null;  // 工单备注类型
        protected List<sdk_work_entry> entryList = null;  // 显示工单 工时剩余时间
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    Bind();  // 绑定页面下拉数据
                }
                CallBack = Request.QueryString["CallBack"];

                var accountId = Request.QueryString["account_id"];
                if (!string.IsNullOrEmpty(accountId))
                {
                    thisAccount = new CompanyBLL().GetCompany(long.Parse(accountId));
                }
                var contractId = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(contractId))
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contractId));
                }

                var taskId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(taskId));
                    if (thisTicket != null)
                    {
                        var isCopyString = Request.QueryString["isCopy"];
                        if (string.IsNullOrEmpty(isCopyString))
                            isAdd = false;
                        else
                            isCopy = true;
                        if (!IsPostBack)
                        {
                            cate_id.ClearSelection();
                            cate_id.SelectedValue = thisTicket.cate_id.ToString();
                            this.ticket_type_id.SelectedValue = thisTicket.ticket_type_id.ToString();
                            this.status_id.SelectedValue = thisTicket.status_id.ToString();
                            if (thisTicket.priority_type_id != null)
                            {
                                priority_type_id.SelectedValue = thisTicket.priority_type_id.ToString();
                            }
                            if (thisTicket.issue_type_id != null)
                            {
                                issue_type_id.SelectedValue = thisTicket.issue_type_id.ToString();
                            }
                            if (thisTicket.source_type_id != null)
                            {
                                source_type_id.SelectedValue = thisTicket.source_type_id.ToString();
                            }
                            if (thisTicket.issue_type_id != null)
                            {
                                issue_type_id.SelectedValue = thisTicket.issue_type_id.ToString();
                            }
                            if (thisTicket.sla_id != null)
                            {
                                sla_id.SelectedValue = thisTicket.sla_id.ToString();
                            }
                        }
                        ticketUdfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, thisTicket.id, tickUdfList);
                        thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                        if (thisTicket.contact_id != null)
                        {
                            thisContact = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
                        }

                        if (thisTicket.owner_resource_id != null && thisTicket.role_id != null)
                        {
                            
                            var resDepList= new sys_resource_department_dal().GetResDepByResAndRole((long)thisTicket.owner_resource_id, (long)thisTicket.role_id);
                            if(resDepList!=null&& resDepList.Count>0)
                            {
                                proResDep = resDepList[0];
                                priRes = new sys_resource_dal().FindNoDeleteById((long)thisTicket.owner_resource_id);
                            }
                        }

                        if (thisTicket.installed_product_id != null)
                        {
                            insPro = new crm_installed_product_dal().FindNoDeleteById((long)thisTicket.installed_product_id);
                        }

                        if (thisTicket.contract_id != null)
                        {
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisTicket.contract_id);
                        }

                        if (thisTicket.cost_code_id != null)
                        {
                            thisCostCode = new d_cost_code_dal().FindNoDeleteById((long)thisTicket.cost_code_id);
                        }
                        var otherResList = new sdk_task_resource_dal().GetTaskResByTaskId(thisTicket.id);
                        if(otherResList!=null&& otherResList.Count > 0)
                        {
                            foreach (var item in otherResList)
                            {
                                if (item.resource_id != null && item.role_id != null)
                                {
                                    var resDepList = new sys_resource_department_dal().GetResDepByResAndRole((long)item.resource_id, (long)item.role_id);
                                    if(resDepList!=null&& resDepList.Count > 0)
                                    {
                                        ticketResIds += resDepList[0].id + ",";
                                    }
                                }
                               
                            }

                            if (ticketResIds != "")
                            {
                                ticketResIds = ticketResIds.Substring(0, ticketResIds.Length-1);
                            }
                        }

                        ticketCheckList = new sdk_task_checklist_dal().GetCheckByTask(thisTicket.id);
                        if(ticketCheckList!=null&& ticketCheckList.Count > 0)
                        {
                            ticketCheckList = ticketCheckList.OrderBy(_=>_.sort_order).ToList();
                        }
                        #region 时间轴显示相关 工单备注类型获取
                        var slaValue = new sdk_task_dal().GetSlaTime(thisTicket);
                        string slaTimeValue = "";
                        if (slaValue != null)
                            slaTimeValue = slaValue.ToString();
                        if (!string.IsNullOrEmpty(slaTimeValue))
                        {
                            if (slaTimeValue.Substring(0, 1) == "{")
                                slaDic = new EMT.Tools.Serialize().JsonToDictionary(slaTimeValue);
                        }
                        var actList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
                        if (actList != null && actList.Count > 0)
                            ticketNoteTypeList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                        #endregion
                        entryList = new sdk_work_entry_dal().GetList(thisTicket.id);
                    }
                }
                

                var ticket_type_id = Request.QueryString["ticket_type_id"];
                if (!string.IsNullOrEmpty(ticket_type_id))
                {
                    this.ticket_type_id.ClearSelection();
                    this.ticket_type_id.SelectedValue = ticket_type_id;
                }

            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('"+ msg.Message + "');window.close();</script>");
            }
        }
        /// <summary>
        /// 页面数据源赋值
        /// </summary>
        public void Bind()
        {
            status_id.DataValueField = "id";
            status_id.DataTextField = "name";
            status_id.DataSource = ticStaList;
            status_id.DataBind();
            status_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            
            priority_type_id.DataValueField = "id";
            priority_type_id.DataTextField = "name";
            priority_type_id.DataSource = priorityList;
            priority_type_id.DataBind();
            priority_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            issue_type_id.DataValueField = "id";
            issue_type_id.DataTextField = "name";
            issue_type_id.DataSource = issueTypeList;
            issue_type_id.DataBind();
            issue_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            
            source_type_id.DataValueField = "id";
            source_type_id.DataTextField = "name";
            source_type_id.DataSource = sourceTypeList;
            source_type_id.DataBind();
            source_type_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            cate_id.DataValueField = "id";
            cate_id.DataTextField = "name";
            cate_id.DataSource = ticketCateList;
            cate_id.DataBind();
            cate_id.SelectedValue = ((int)DicEnum.TICKET_CATE.STANDARD).ToString();

            ticket_type_id.DataValueField = "id";
            ticket_type_id.DataTextField = "name";
            ticket_type_id.DataSource = ticketTypeList;
            ticket_type_id.DataBind();

            department_id.DataValueField = "id";
            department_id.DataTextField = "name";
            department_id.DataSource = depList;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
            
            sla_id.DataValueField = "id";
            sla_id.DataTextField = "name";
            sla_id.DataSource = slaList;
            sla_id.DataBind();
            sla_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            notify_id.DataValueField = "id";
            notify_id.DataTextField = "name";
            notify_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TICKET_CREATED_EDITED);
            notify_id.DataBind();
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var para = GetParam();
            if (para != null)
            {
                string faileReason;
                var result = false;
                if (isAdd)
                    result =  new TicketBLL().AddTicket(para, LoginUserId, out faileReason);
                else
                    result =  new TicketBLL().EditTicket(para, LoginUserId, out faileReason);
                if (result)
                {
                    if (!string.IsNullOrEmpty(CallBack))
                    {

                    }
                    else
                    {
                        // 跳转到查看页面  暂时关闭
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存成功');location.href='../ServiceDesk/TicketView?id={para.ticket.id}';self.opener.location.reload();</script>");
                    }
                    
                }
                else
                {

                }
            }
        }
        /// <summary>
        ///  获取页面参数
        /// </summary>
        protected TicketManageDto GetParam()
        {
            // 为方便页面处理 owner_resource_id 存储的是 sys_resource_department 的id ，存储时需要转换
            long? owner_resource_id = null;
            long? role_id = null;
            var priResString = Request.Form["owner_resource_id"];
            if (!string.IsNullOrEmpty(priResString))
            {
                var resDep = new sys_resource_department_dal().FindById(long.Parse(priResString));
                if (resDep != null)
                {
                    owner_resource_id = resDep.resource_id;
                    role_id = resDep.role_id;
                }
            }
            TicketManageDto param = new TicketManageDto();
            var pageTicket = AssembleModel<sdk_task>();
            pageTicket.owner_resource_id = owner_resource_id;
            pageTicket.role_id = role_id;
            var dueDate = Request.Form["DueDate"];
            var dueTime = Request.Form["DueTime"];
            if (!string.IsNullOrEmpty(dueTime) && !string.IsNullOrEmpty(dueDate))
            {
                var dueDateTime = dueDate + " " + dueTime; // 获取到截止时间
                var dueD = DateTime.Parse(dueDateTime);
                pageTicket.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(dueD);
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('未获取到相关截止时间，请重新填写！');</script>");
                return null;
            }
            #region 如果sla设置自动计算截止时间 ，保存时计算出工单的结束时间
            if (pageTicket.sla_id != null)
            {
                var thisSla = new d_sla_dal().FindNoDeleteById((long)pageTicket.sla_id);
                if (thisSla != null && thisSla.set_ticket_due_date == 1)
                {
                    if (pageTicket.sla_start_time == null)
                        pageTicket.sla_start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    var slaValue = new sdk_task_dal().GetSlaTime(pageTicket);
                    string slaTimeValue = "";
                    if (slaValue != null)
                        slaTimeValue = slaValue.ToString();
                    if (!string.IsNullOrEmpty(slaTimeValue)&& slaTimeValue.Substring(0, 1) == "{")
                    {
                        var slaDic = new EMT.Tools.Serialize().JsonToDictionary(slaTimeValue);
                        if(slaDic!=null&& slaDic.Count > 0)
                        {
                            var duteDateDic = slaDic.FirstOrDefault(_=>_.Key=="截止时间");
                            if(!default(KeyValuePair<string, object>).Equals(duteDateDic))
                            {
                                var duteDate = DateTime.Parse(duteDateDic.Value.ToString());
                                pageTicket.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(duteDate);
                            }
                        }
                    }
                }
            }
            #endregion

            if (isAdd)
            {
                pageTicket.type_id = (int)DTO.DicEnum.TASK_TYPE.SERVICE_DESK_TICKET;
                param.ticket = pageTicket;
            }
            else
            {
                #region 获取页面相关值
                thisTicket.account_id = pageTicket.account_id;
                thisTicket.contract_id = pageTicket.contract_id;
                thisTicket.status_id = pageTicket.status_id;
                thisTicket.priority = pageTicket.priority;
                thisTicket.issue_type_id = pageTicket.issue_type_id;
                thisTicket.sub_issue_type_id = pageTicket.sub_issue_type_id;
                thisTicket.source_type_id = pageTicket.source_type_id;
                thisTicket.estimated_end_time = pageTicket.estimated_end_time;
                thisTicket.estimated_hours = pageTicket.estimated_hours;
                thisTicket.sla_id = pageTicket.sla_id;
                thisTicket.department_id = pageTicket.department_id;
                thisTicket.owner_resource_id = pageTicket.owner_resource_id;
                thisTicket.role_id = pageTicket.role_id;
                thisTicket.installed_product_id = pageTicket.installed_product_id;
                thisTicket.service_id = pageTicket.service_id;
                thisTicket.cost_code_id = pageTicket.cost_code_id;
                thisTicket.purchase_order_no = pageTicket.purchase_order_no;
                thisTicket.cate_id = pageTicket.cate_id;
                thisTicket.ticket_type_id = pageTicket.ticket_type_id;
                thisTicket.title = pageTicket.title;
                thisTicket.description = pageTicket.description;
                thisTicket.resolution = pageTicket.resolution;
                #endregion
                param.ticket = thisTicket;
            }
            param.resDepIds = Request.Form["OtherResId"];
            var AddSoule = Request.Form["AddSoule"];
            if (AddSoule == "on")
            {
                param.isAppSlo = true;
            }
            param.completeReason = Request.Form["reason"];
            param.repeatReason = Request.Form["RepeatReason"]; 
            #region 检查单相关
            var CheckListIds = Request.Form["CheckListIds"];  // 检查单Id
            if (!string.IsNullOrEmpty(CheckListIds))
            {
                List<CheckListDto> ckList = new List<CheckListDto>();
                var checkIdArr = CheckListIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                foreach (var checkId in checkIdArr)
                {
                    if (string.IsNullOrEmpty(Request.Form[checkId + "_item_name"]))  // 条目名称为空 不添加
                        continue;
                    var is_complete = Request.Form[checkId+"_is_complete"];
                    var is_import = Request.Form[checkId + "_is_import"];
                    var sortOrder = Request.Form[checkId + "_sort_order"];
                    decimal? sort = null;
                    if (!string.IsNullOrEmpty(sortOrder))
                    {
                        sort = decimal.Parse(sortOrder);
                    }
                    var thisCheck = new CheckListDto() {
                        ckId=long.Parse(checkId),
                        isComplete = is_complete=="on",
                        itemName = Request.Form[checkId + "_item_name"],
                        isImport = is_import=="on",
                        sortOrder = sort,
                    };
                    ckList.Add(thisCheck);
                }
                param.ckList = ckList;
            }
            #endregion
            #region 工单自定义字段,页面暂无自定义
            if (tickUdfList != null && tickUdfList.Count > 0)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in tickUdfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = string.IsNullOrEmpty(Request.Form[udf.id.ToString()]) ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);
                }
                if (isAdd)
                {
                    param.udfList = list;
                }
                else
                {
                    param.udfList = ticketUdfValueList;
                }
                
            }
            #endregion
            return param;
        }
        /// <summary>
        /// 完成操作
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnComplete_Click(object sender, EventArgs e)
        {
            // 获取保存类型,进行相关操作
            var saveType = Request.Form["SaveType"];
            var para = GetParam();
            if (para != null)
            {
                string faileReason;
                var result = false;
                if (isAdd)
                    result = new TicketBLL().AddTicket(para, LoginUserId, out faileReason);
                else
                    result = new TicketBLL().EditTicket(para, LoginUserId, out faileReason);
                if (result)
                {
                    if (!string.IsNullOrEmpty(CallBack))
                    {

                    }
                    else
                    {
                        // 跳转到查看页面  暂时关闭
                        ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功');self.opener.location.reload();window.close();</script>");
                    }

                }
                else
                {

                }
            }
        }
        /// <summary>
        /// 重新打开操作
        /// </summary>
        protected void btnRepeat_Click(object sender, EventArgs e)
        {
            // 获取保存类型,进行相关操作
            var saveType = Request.Form["SaveType"];
            var para = GetParam();
            if (para != null)
            {
                string faileReason;
                var result = false;
                if (isAdd)
                    result = new TicketBLL().AddTicket(para, LoginUserId, out faileReason);
                else
                    result = new TicketBLL().EditTicket(para, LoginUserId, out faileReason);
                if (!string.IsNullOrEmpty(CallBack))
                {

                }
                else
                {
                      // 跳转到查看页面 
                      ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}');self.opener.location.reload();location.href='TicketManage?id="+ para.ticket.id + "';</script>");
                }
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var para = GetParam();
            if (para != null)
            {
                string faileReason;
                var result = false;
                if (isAdd)
                    result = new TicketBLL().AddTicket(para, LoginUserId, out faileReason);
                else
                    result = new TicketBLL().EditTicket(para, LoginUserId, out faileReason);
               if (!string.IsNullOrEmpty(CallBack))
                {
                }
                else
                {
                     // 跳转到查看页面  暂时关闭
                     ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}');self.opener.location.reload();window.close();</script>");
                }
            }
        }
    }
}