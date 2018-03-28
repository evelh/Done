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
using System.IO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class MasterTicket : BasePage
    {
        protected sdk_task thisTicket = null;   // 当前工单
        protected sdk_recurring_ticket thisticketRes = null;  // 当前工单的周期
        protected bool isAdd = true;            // 新增还是编辑
        protected bool isCopy = false;          // 复制
        protected crm_account thisAccount = null;  // 工单的客户
        protected crm_contact thisContact = null;  // 工单的联系人
        protected sys_resource priRes = null;      // 工单的主负责人
        protected sys_role thisRole = null;        // 工单的主负责人的角色
        protected sys_resource_department proResDep = null; // 工单的主负责人
        protected crm_installed_product insPro = null; // 工单的配置项
        protected ivt_product thisProduct = null;    // 工单配置项 的产品
        protected ctt_contract thisContract = null;    // 工单的合同
        protected d_cost_code thisCostCode = null;     //  工单的工作类型
        protected List<d_sla> slaList = new d_sla_dal().GetList();
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<d_cost_code> costList = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
        protected List<sys_resource_department> ticketResList = null;  // 工单的员工
        protected List<UserDefinedFieldDto> tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;
        protected List<sdk_task_checklist> ticketCheckList = null;   // 工单的检查单集合

        protected List<d_general> publishList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.NOTE_PUBLISH_TYPE);
        protected List<d_general> noteTypeList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
        protected long objectId = -1;  // 添加附件的对象ID
        protected sdk_service_call_task thisTicketCall = null;   // 主工单的服务预定
        protected List<sys_notify_tmpl> tempList = new sys_notify_tmpl_dal().GetTempByEvent(((int)DicEnum.NOTIFY_EVENT.RECURRENCE_MASTER_CREATED_EDITED).ToString()+','+ ((int)DicEnum.NOTIFY_EVENT.TICKET_CREATED_EDITED).ToString()+','+ ((int)DicEnum.NOTIFY_EVENT.TICKET_ATTACHMENT_ADDED).ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Bind();  // 绑定页面下拉数据
            if (noteTypeList != null && noteTypeList.Count > 0)
                noteTypeList = noteTypeList.Where(_ => _.ext2 == ((int)DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER).ToString()).ToList();
            if (publishList != null && publishList.Count > 0)
                publishList = publishList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TICKET_NOTE).ToString()).ToList();
            var ticketId = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(ticketId))
            {
                thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(ticketId));
            }
            if (thisTicket != null)
            {
                isAdd = false;
                objectId = thisTicket.id;
                #region 获取工单基本信息
                thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                if (thisTicket.contact_id != null)
                    thisContact = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
                if (thisTicket.owner_resource_id != null && thisTicket.role_id != null)
                {
                    priRes = new sys_resource_dal().FindNoDeleteById((long)thisTicket.owner_resource_id);
                    thisRole = new sys_role_dal().FindNoDeleteById((long)thisTicket.role_id);
                    var resDepList = new sys_resource_department_dal().GetResDepByResAndRole((long)thisTicket.owner_resource_id, (long)thisTicket.role_id);
                    if (resDepList != null && resDepList.Count > 0)
                        proResDep = resDepList[0];
                }
                if (thisTicket.contract_id != null)
                    thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisTicket.contract_id);
                status_id.SelectedValue = thisTicket.status_id.ToString();
                if (thisTicket.priority_type_id != null)
                    priority_type_id.SelectedValue = thisTicket.priority_type_id.ToString();
                if (thisTicket.issue_type_id != null)
                    issue_type_id.SelectedValue = thisTicket.issue_type_id.ToString();
                if (thisTicket.source_type_id != null)
                    source_type_id.SelectedValue = thisTicket.source_type_id.ToString();
                if (thisTicket.cate_id != null)
                    cate_id.SelectedValue = thisTicket.cate_id.ToString();
                if (thisTicket.cost_code_id != null)
                    cost_code_id.SelectedValue = thisTicket.cost_code_id.ToString();
                if (thisTicket.department_id != null)
                    department_id.SelectedValue = thisTicket.department_id.ToString();
                if (thisTicket.installed_product_id != null)
                    insPro = new crm_installed_product_dal().FindNoDeleteById((long)thisTicket.installed_product_id);
                if (insPro != null)
                    thisProduct = new ivt_product_dal().FindNoDeleteById(insPro.product_id);
                #endregion

                #region 获取工单周期信息
                thisticketRes = new sdk_recurring_ticket_dal().GetByTicketId(thisTicket.id);
                #endregion
                ticketUdfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, thisTicket.id, tickUdfList);
            }
        }
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

            ticketCateList = ticketCateList.Where(_ => _.id == (int)DicEnum.TICKET_CATE.STANDARD).ToList(); // 暂时只支持标准一种类型
            cate_id.DataValueField = "id";
            cate_id.DataTextField = "name";
            cate_id.DataSource = ticketCateList;
            cate_id.DataBind();
            cate_id.SelectedValue = ((int)DicEnum.TICKET_CATE.STANDARD).ToString();

            //ticket_type_id.DataValueField = "id";
            //ticket_type_id.DataTextField = "name";
            //ticket_type_id.DataSource = ticketTypeList;
            //ticket_type_id.DataBind();

            cost_code_id.DataValueField = "id";
            cost_code_id.DataTextField = "name";
            cost_code_id.DataSource = costList;
            cost_code_id.DataBind();
            cost_code_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            department_id.DataValueField = "id";
            department_id.DataTextField = "name";
            department_id.DataSource = depList;
            department_id.DataBind();
            department_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            //sla_id.DataValueField = "id";
            //sla_id.DataTextField = "name";
            //sla_id.DataSource = slaList;
            //sla_id.DataBind();
            //sla_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });

            //notify_id.DataValueField = "id";
            //notify_id.DataTextField = "name";
            //notify_id.DataSource = new sys_notify_tmpl_dal().GetTempByEvent(DicEnum.NOTIFY_EVENT.TICKET_CREATED_EDITED);
            //notify_id.DataBind();
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var para = GetParam();
            if (para == null)
                return; 
            bool result = false;
            if (isAdd)
                result = new TicketBLL().AddMasterTicket(para, LoginUserId);
            else
                result = new TicketBLL().EditMasterTicket(para, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');location.href='MasterTicket?id="+ para.masterTicket.id+ "';</script>");
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var para = GetParam();
            if (para == null)
                return;
            bool result = false;
            if (isAdd)
                result = new TicketBLL().AddMasterTicket(para, LoginUserId);
            else
                result = new TicketBLL().EditMasterTicket(para, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}！');window.close();</script>");
        }

        protected MasterTicketDto GetParam()
        {
            MasterTicketDto param = new MasterTicketDto();
            #region 定期工单相关参数获取
            var pageTicket = AssembleModel<sdk_task>();
            #region 获取主负责人和相关角色
            var dueTime = Request.Form["dueTime"];
            if (isAdd)
            {
                var resDepId = Request.Form["resDepId"];
                long? roleId = null;
                long? resId = null;
                if (!string.IsNullOrEmpty(resDepId))   // department_id
                {
                    var resDep = new sys_resource_department_dal().FindById(long.Parse(resDepId));
                    if (resDep != null)
                    {
                        roleId = resDep.role_id;
                        resId = resDep.resource_id;
                    }
                }
                pageTicket.role_id = roleId;
                pageTicket.owner_resource_id = resId;
                #endregion

                
                if (!string.IsNullOrEmpty(dueTime))
                    pageTicket.estimated_end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + dueTime));
                else
                    return null;
                param.masterTicket = pageTicket;
            }
            else
            {
                #region 修改获取相关参数
                //thisTicket.account_id = pageTicket.account_id;
                //thisTicket.title = pageTicket.title;
                //thisTicket.description = pageTicket.description;
                //thisTicket.contact_id = pageTicket.contact_id;
                //thisTicket.department_id = pageTicket.department_id;
                //thisTicket.owner_resource_id = pageTicket.owner_resource_id;
                //thisTicket.role_id = pageTicket.role_id;
                //thisTicket.source_type_id = pageTicket.source_type_id;
                //thisTicket.issue_type_id = pageTicket.issue_type_id;
                //thisTicket.sub_issue_type_id = pageTicket.sub_issue_type_id;
                //thisTicket.estimated_end_time = pageTicket.estimated_end_time;
                //thisTicket.estimated_hours = pageTicket.estimated_hours;
                //thisTicket.status_id = pageTicket.status_id;
                //thisTicket.priority_type_id = pageTicket.priority_type_id;
                //thisTicket.contract_id = pageTicket.contract_id;
                //thisTicket.cost_code_id = pageTicket.cost_code_id;
                //thisTicket.cate_id = pageTicket.cate_id;
                //thisTicket.installed_product_id = pageTicket.installed_product_id;
                //thisTicket.purchase_order_no = pageTicket.purchase_order_no;
                #endregion
                param.masterTicket = thisTicket;
            }
            #endregion

            #region 周期相关参数获取
            var pageRecurr = AssembleModel<sdk_recurring_ticket>();
            var ckActive = Request.Form["ckActive"];
            if (!string.IsNullOrEmpty(ckActive) && ckActive.Equals("on"))
                pageRecurr.is_active = 1;
            else
                pageRecurr.is_active = 0;
            if (isAdd)
            {
                pageRecurr.recurring_start_date = DateTime.Parse(pageRecurr.recurring_start_date.ToString("yyyy-MM-dd") + " " + dueTime);
                var rdoFreq = Request.Form["rdoFreq"];
                switch (rdoFreq)
                {
                    case "Daily":
                        pageRecurr.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY;
                        var day_eve_day = Request.Form["day_eve_day"];
                        if (!string.IsNullOrEmpty(day_eve_day))
                            param.day_day = int.Parse(day_eve_day);
                        else
                            return null;
                        var ckNotInSat = Request.Form["ckNotInSat"];
                        if (!string.IsNullOrEmpty(ckNotInSat) && ckNotInSat.Equals("on"))
                            param.day_no_sat = true;
                        var ckNotInSun = Request.Form["ckNotInSun"];
                        if (!string.IsNullOrEmpty(ckNotInSun) && ckNotInSun.Equals("on"))
                            param.day_no_sun = true;
                        break;
                    case "Weekly":
                        pageRecurr.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK;
                        var week_eve_week = Request.Form["week_eve_week"];
                        if (!string.IsNullOrEmpty(week_eve_week))
                            param.week_week = int.Parse(week_eve_week);
                        else
                            return null;
                        var ckWeekMon = Request.Form["ckWeekMon"];
                        if (!string.IsNullOrEmpty(ckWeekMon) && ckWeekMon.Equals("on"))
                            param.week_mon = true;
                        var ckWeekTus = Request.Form["ckWeekTus"];
                        if (!string.IsNullOrEmpty(ckWeekTus) && ckWeekTus.Equals("on"))
                            param.week_tus = true;
                        var ckWeekWed = Request.Form["ckWeekWed"];
                        if (!string.IsNullOrEmpty(ckWeekWed) && ckWeekWed.Equals("on"))
                            param.week_wed = true;
                        var ckWeekThu = Request.Form["ckWeekThu"];
                        if (!string.IsNullOrEmpty(ckWeekThu) && ckWeekThu.Equals("on"))
                            param.week_thu = true;
                        var ckWeekFri = Request.Form["ckWeekFri"];
                        if (!string.IsNullOrEmpty(ckWeekFri) && ckWeekFri.Equals("on"))
                            param.week_fri = true;
                        var ckWeekSat = Request.Form["ckWeekSat"];
                        if (!string.IsNullOrEmpty(ckWeekSat) && ckWeekSat.Equals("on"))
                            param.week_sat = true;
                        var ckWeekSun = Request.Form["ckWeekSun"];
                        if (!string.IsNullOrEmpty(ckWeekSun) && ckWeekSun.Equals("on"))
                            param.week_sun = true;
                        break;
                    case "Monthly":
                        pageRecurr.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH;
                        var radioMonthly = Request.Form["radioMonthly"];
                        if (radioMonthly == "Day")
                        {
                            param.month_type = "1";
                            var month_month_num = Request.Form["month_month_num"];
                            var month_month_day = Request.Form["month_month_day"];
                            if (!string.IsNullOrEmpty(month_month_num) && !string.IsNullOrEmpty(month_month_day))
                            {
                                param.month_month = int.Parse(month_month_num);
                                param.month_day = int.Parse(month_month_day);
                            }
                            else
                                return null;
                        }
                        else if (radioMonthly == "The")
                        {
                            param.month_type = "2";
                            var month_month_eve_num = Request.Form["month_month_eve_num"];
                            if (!string.IsNullOrEmpty(month_month_eve_num))
                                param.month_month = int.Parse(month_month_eve_num);
                            else return null;
                            param.month_week_num = Request.Form["ddlOccurance_ATDropDown"];
                            param.month_week_day = Request.Form["ddlDayofweeks_ATDropDown"];
                        }
                        else
                            return null;
                        break;
                    case "Yearly":
                        pageRecurr.recurring_frequency = (int)DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR;
                        var rdoYearlyDue = Request.Form["rdoYearlyDue"];
                        if (rdoYearlyDue == "DueEvery")
                        {
                            var year_month_day = Request.Form["year_month_day"];
                            if (!string.IsNullOrEmpty(year_month_day))
                                param.year_month_day = int.Parse(year_month_day);
                            else return null;
                            param.year_type = "1";
                            param.year_month = Request.Form["year_every_month"];
                        }
                        else if (rdoYearlyDue == "The")
                        {
                            param.year_type = "2";
                            param.year_month = Request.Form["year_the_month"];
                            param.year_month_week_num = Request.Form["year_month_week_num"];
                            param.year_month_week_day = Request.Form["year_the_week"];
                        }
                        else return null;
                        break;
                    default:
                        return null;
                        break;
                }
                param.masterRecurr = pageRecurr;
            }
            else
            {
                if (thisticketRes.recurring_end_date != null)
                    thisticketRes.recurring_end_date = pageRecurr.recurring_end_date;
                if(thisticketRes.recurring_instances!=null)
                    thisticketRes.recurring_instances = pageRecurr.recurring_instances;
                thisticketRes.is_active = pageRecurr.is_active;
                param.masterRecurr = thisticketRes;
            }
            
            #endregion

            #region 附件相关
            param.filtList = GetSessAttList(objectId);
            #endregion

            #region 备注相关参数
            param.noteTitle = Request.Form["note_title"];
            if (!string.IsNullOrEmpty(Request.Form["note_publish_id"]))
                param.publishId = long.Parse(Request.Form["note_publish_id"]);
            if (!string.IsNullOrEmpty(Request.Form["note_type"]))
                param.noteTypeId = long.Parse(Request.Form["note_type"]);
            param.noteDescription = Request.Form["txtNotesDescription"];
            #endregion

            #region 通知相关
            param.ccCons = Request.Form["notifyConIds"];
            param.ccRes = Request.Form["notifyResIds"];
            param.appText = Request.Form["notify_description"];
            param.subject = Request.Form["notify_title"];
            param.otherEmail = Request.Form["notify_others"];
            if (!string.IsNullOrEmpty(Request.Form["notify_temp"]))
                param.tempId = int.Parse(Request.Form["notify_temp"]);
            var ccMe = Request.Form["ccMe"];
            if (!string.IsNullOrEmpty(ccMe) && ccMe.Equals("on"))
                param.ccMe = true;
            var ccAccMan = Request.Form["ccAccMan"];
            if (!string.IsNullOrEmpty(ccAccMan) && ccMe.Equals("on"))
                param.ccAccMan = true;
            var sendFromSys = Request.Form["sendFromSys"];
            if (!string.IsNullOrEmpty(sendFromSys) && ccMe.Equals("on"))
                param.sendFromSys = true;
            var ccOwn = Request.Form["ccOwn"];
            if (!string.IsNullOrEmpty(ccOwn) && ccMe.Equals("on"))
                param.ccOwn = true;
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
                param.udfList = list;
            }
            #endregion

            return param;
        }

        private List<AddFileDto> GetSessAttList(long objectId)
        {

            var attList = Session[objectId + "_Att"] as List<AddFileDto>;
            if (attList != null && attList.Count > 0)
            {
                foreach (var thisAtt in attList)
                {
                    if (thisAtt.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                    {
                        string saveFilename = "";

                        try
                        {
                            SavePic(thisAtt, out saveFilename);
                        }
                        catch (Exception msg)
                        {
                            continue;
                        }
                        thisAtt.fileSaveName = saveFilename;

                    }
                }
            }
            return attList;
        }

        private string SavePic(AddFileDto thisAttDto, out string saveFileName)
        {
            saveFileName = "";
            string fileExtension = Path.GetExtension(thisAttDto.old_filename).ToLower();    //取得文件的扩展名,并转换成小写
            string filepath = $"/Upload/Attachment/{DateTime.Now.ToString("yyyyMM")}/";
            if (Directory.Exists(Server.MapPath(filepath)) == false)    //如果不存在就创建文件夹
            {
                Directory.CreateDirectory(Server.MapPath(filepath));
            }
            string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
            string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
            //FileStream fs = new FileStream(oldPath, FileMode.Open, FileAccess.ReadWrite);
            File.WriteAllBytes(mappath, thisAttDto.files as Byte[]);
            //  fileForm.SaveAs(mappath);//保存图片
            //fs.Close();
            saveFileName = virpath;
            return "";
        }

    }
}