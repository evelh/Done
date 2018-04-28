using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Company
{
    public partial class CrmDashboard : BasePage
    {


        protected int todayTodoCount;
        protected int overdueTodoCount;       // 过期的待办
        protected int myAsignToOtherCount;    // 我指派给别人的代办数量  创建人是我，负责人不是我
        protected int needEditOppoCount;      // 需要更新的商机数量 - 状态时活跃，预计关闭时间在今天之前

        protected int yesTicketCount;          // 昨天创建的工单 - 创建日期是昨天 根据工单的客户进行过滤（客户的客户经理，地域所包含员工）
        protected int todayTicketCount;        // 今天创建的工单

        protected int monthLostOppo;           // 这个月丢失的商机  - 商机负责人，状态是丢失85   actual_closed_time 是在本月
        protected int monthCloseOppo;          // 这个月等待关闭的商机  - 状态是 激活 预计关闭时间在本月内
        protected int monthClosedOppo;         // 这个月已经关闭的商机  - 商机负责人，状态是关闭   actual_closed_time 是在本月
        protected List<crm_opportunity> monthClosedOppoList;
        protected decimal monthAmount;     // 月商机总收入
        protected decimal prodessAmount;   // 专业服务
        protected decimal trainsAmount;    // 培训费用
        protected decimal hardwareAmount;  // 硬件费用
        protected decimal monthFeeAmount;  // 月度使用费用
        protected decimal otherAmount;     // 其他费用
        // 选择全部区域之后，目标为统计所有员工的木匾
        protected decimal quotaAmount;       // 目标收入
        protected decimal quotaProdess;      // 目标专业
        protected decimal quotaTrains;       // 目标培训
        protected decimal quotaHardware;     // 目标硬件
        protected decimal quotaMonthFee;     // 目标月度
        protected decimal quotaOther;        // 目标其他
        protected int updateOppoNoteCount;   // 本月更新商机的日志的数量   - 备注  负责人  活动类型-商机更新 创建时间在本月

        protected int accountCount;          // 客户数量
        protected int activeOppoCount;       // 活跃的商机数量
        protected int newOppoMonthCount;     // 这个月新建的商机数量
        protected List<crm_opportunity> activeOppoList;

        protected Dictionary<long, int> terrAccDic = new Dictionary<long, int>();   // 每个区域对应的客户数量
        protected Dictionary<long, int> classAccDic = new Dictionary<long, int>();   // 每个类别对应的客户数量


        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();                                           // 所有的员工列表
        protected List<d_general> terrList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TERRITORY);          // 客户地域集合
        protected List<d_account_classification> accClassList = new DAL.d_account_classification_dal().GetAccClassList();          // 客户类别集合
        protected List<d_general> oppoStageList = new DAL.d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.OPPORTUNITY_STAGE);          // 客户地域集合

        protected string queryType;          // 查询方式   R|0 代表全部员工
        protected long? resourceId;          // 员工Id
        protected long? terrId;              // 区域Id
        protected string terResIds;          // 该区域下的所有负责人的Id 集合
        protected OpportunityBLL oppBLl = new OpportunityBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            // 今天生成的待办数量
            // 过期的待办
            // 打开的指派给其他人的待办

            //  需要更新的商机
            // 昨天的工单 | 今天的工单
            queryType = Request.QueryString["queryType"];
            if (string.IsNullOrEmpty(queryType))
                queryType = "R|"+LoginUserId.ToString();
            var queryArr = queryType.Split('|');
            if (queryArr[0] == "T"&& queryArr.Count()==2)
                terrId = long.Parse(queryArr[1]);
            else if(queryArr[0] == "R" && queryArr.Count() == 2)
                resourceId = long.Parse(queryArr[1]);
            else
                resourceId = LoginUserId;
            // 今天的开始结束时间
            var start = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + "00:00:00");
            var end = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd") + " " + "23:59:59");
            // 昨天的开始结束时间
            var yesStart = DateTime.Parse(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") + " " + "00:00:00");
            var yesEnd = DateTime.Parse(DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") + " " + "23:59:59");
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            // 本月的开始结束时间
            var monthStart = DateTime.Parse(DateTime.Now.AddDays(-1).ToString("yyyy-MM") + "-01 " + "00:00:00");
            var monthDay = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month);
            var monthEnd = DateTime.Parse(DateTime.Now.AddDays(-1).ToString("yyyy-MM") + "-"+ monthDay.ToString() + " " + "23:59:59");

            string accClassWhere = "";

            var aa = Tools.Date.DateHelper.ToUniversalTimeStamp();
            var caDal = new DAL.com_activity_dal();
            // 客户： {"row":"1","t1":"ca","col1":"1,2,3","col2":"1,2"}  
            var accLimitJson = "{\"row\":\"1\",\"t1\":\"ca\",\"col1\":\"1,2,3\",\"col2\":\"1,2\"}";
            // 商机： {"row":"2","t1":"o","col1":"11"}
            var oppoLimtJson = "{\"row\":\"2\",\"t1\":\"cp\",\"col1\":\"11\"}";

            var accountLimitSql = Convert.ToString(caDal.GetSingle($"select f_rpt_getsql_limit('{accLimitJson}',{LoginUserId.ToString()})"));
            var oppoLimitSql = Convert.ToString(caDal.GetSingle($"select f_rpt_getsql_limit('{oppoLimtJson}',{LoginUserId.ToString()})"));
            if (terrId != null)
            {
                var terResList = new DAL.sys_resource_territory_dal().GetByTerrId((long)terrId);
                if (terResList != null && terResList.Count > 0)
                    terResList.ForEach(_ => { terResIds += _.resource_id.ToString() + ","; });
                if (!string.IsNullOrEmpty(terResIds))
                    terResIds = terResIds.Substring(0, terResIds.Length-1);
                string terrResWhere = "";
                if (terrId != 0)
                {
                    if (!string.IsNullOrEmpty(terResIds))
                        terrResWhere = $" and ca.resource_id in({terResIds})";
                    else
                        terrResWhere = $" and ca.resource_id in('')";
                }

                #region 摘要查询数量
               

                overdueTodoCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from com_activity act INNER JOIN crm_account ca on act.account_id = ca.id  where act.cate_id = {(int)DTO.DicEnum.ACTIVITY_CATE.TODO} and ca.delete_time = 0 and act.delete_time = 0  and act.status_id = {(int)DTO.DicEnum.ACTIVITY_STATUS.NOT_COMPLETED} and act.end_date<={timeNow} "+ accountLimitSql + (terrId == 0 ? $"" : $" and act.resource_id in({(string.IsNullOrEmpty(terResIds) ? "''" : terResIds)})")));
                myAsignToOtherCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from com_activity act INNER JOIN crm_account ca on act.account_id = ca.id  where act.cate_id = {(int)DTO.DicEnum.ACTIVITY_CATE.TODO} and ca.delete_time = 0 and act.delete_time = 0 "+ accountLimitSql + (terrId ==0?$" and create_user_id <> resource_id" : $" and act.create_user_id in({(string.IsNullOrEmpty(terResIds)?"''": terResIds)})")));

                needEditOppoCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity cp  where cp.delete_time = 0  and projected_close_date < '{DateTime.Now.ToString("yyyy-MM-dd")}' and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE} "+ oppoLimitSql + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and cp.resource_id in('')" : $" and cp.resource_id in({terResIds})"))));
                yesTicketCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) FROM sdk_task st INNER JOIN crm_account ca on st.account_id = ca.id where st.type_id in (1809,1818)  and st.create_time <={Tools.Date.DateHelper.ToUniversalTimeStamp(yesEnd)} and st.create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(yesStart)}" + (string.IsNullOrEmpty(terResIds) ? "" : $" and ca.resource_id in({terResIds})")));

                todayTicketCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) FROM sdk_task st INNER JOIN crm_account ca on st.account_id = ca.id where st.type_id in (1809,1818)  and st.create_time <={Tools.Date.DateHelper.ToUniversalTimeStamp(end)} and st.create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(start)}" + terrResWhere));

                monthLostOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.LOST}" + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})"))));

                //monthClosedOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.CLOSED}" + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? "''" : $" and resource_id in({terResIds})"))));

                monthCloseOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and projected_close_date <= {monthEnd.ToString("yyyy-MM-dd")} and projected_close_date >= {monthStart.ToString("yyyy-MM-dd")} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE}" + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})"))));

                monthClosedOppoList = caDal.FindListBySql<crm_opportunity>($"SELECT * from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.CLOSED}" + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})")));
                #endregion

                accountCount = Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 "+ (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})"))));
                activeOppoList = caDal.FindListBySql<crm_opportunity>($"SELECT * from crm_opportunity where delete_time = 0 and status_id = {(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE} " + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})")));
                newOppoMonthCount = Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_opportunity where delete_time = 0 and create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and create_time<={Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} " + (terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and resource_id in('')" : $" and resource_id in({terResIds})"))));

                // 
                updateOppoNoteCount = Convert.ToInt32(caDal.GetSingle($"SELECT * from com_activity ca INNER JOIN crm_opportunity co on ca.opportunity_id = co.id where ca.action_type_id = {(int)DicEnum.ACTIVITY_TYPE.OPPORTUNITYUPDATE} and ca.cate_id = {(int)DicEnum.ACTIVITY_CATE.NOTE} and ca.delete_time = 0 and co.delete_time = 0 and ca.create_time>{Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and ca.create_time<={Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} "+(terrId == 0 ? "" : (string.IsNullOrEmpty(terResIds) ? " and co.resource_id in('')" : $" and co.resource_id in({terResIds})"))));
                if (terrId == 0)
                {
                    if(terrList!=null&& terrList.Count > 0)
                        terrList.ForEach(_ => {
                            terrAccDic.Add(_.id, Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 and territory_id =" + _.id.ToString())));
                        });
                }
                else
                    terrAccDic.Add((long)terrId, Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 and territory_id ="+ terrId.ToString())));
                if (terrId != 0)
                {
                    if (!string.IsNullOrEmpty(terResIds))
                        accClassWhere = $" and resource_id in({terResIds})";
                    else
                        accClassWhere = $" and resource_id in('')";
                }

            }
            else if (resourceId != null)
            {
                string terIds = "";  // 该负责人下的所有区域的Id 集合
                var terList = new DAL.sys_resource_territory_dal().GetListByResourceId((long)resourceId);
                if (terList != null && terList.Count > 0)
                    terList.ForEach(_ => { terIds += _.resource_id.ToString() + ","; });
                if (!string.IsNullOrEmpty(terIds))
                    terIds = terIds.Substring(0, terIds.Length - 1);
                #region 摘要查询数量
                todayTodoCount = caDal.GetTodoCountByRes((long)resourceId,$" and create_time <={Tools.Date.DateHelper.ToUniversalTimeStamp(end)} and create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(start)}");
                overdueTodoCount = caDal.GetTodoCountByRes((long)resourceId,$" and status_id = {(int)DTO.DicEnum.ACTIVITY_STATUS.NOT_COMPLETED} and end_date<={timeNow}");
                myAsignToOtherCount = caDal.GetTodoCountByRes(0, resourceId==0?$" and create_user_id <> resource_id" :$" and create_user_id= {resourceId} and resource_id<>{resourceId}");

                needEditOppoCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity cp inner join crm_account ca on cp.account_id = ca.id where  cp.delete_time = 0 and projected_close_date < '{DateTime.Now.ToString("yyyy-MM-dd")}' and cp.status_id ={(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE} "+ accountLimitSql + oppoLimitSql + (resourceId==0?"":$" and cp.resource_id = {(long)resourceId}")));

                yesTicketCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) FROM sdk_task st INNER JOIN crm_account ca on st.account_id = ca.id where st.type_id in (1809,1818)  and st.create_time <={Tools.Date.DateHelper.ToUniversalTimeStamp(yesEnd)} and st.create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(yesStart)}" + (resourceId == 0 ? "" : $" and ca.resource_id = {(long)resourceId}")));

                todayTicketCount = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) FROM sdk_task st INNER JOIN crm_account ca on st.account_id = ca.id where st.type_id in (1809,1818)  and st.create_time <={Tools.Date.DateHelper.ToUniversalTimeStamp(end)} and st.create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(start)}" + (resourceId == 0 ? "" : $" and ca.resource_id = {(long)resourceId}")));

                // 
                monthLostOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.LOST}"+ (resourceId == 0 ? "" : $" and resource_id = {(long)resourceId}")));

                monthClosedOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.CLOSED}" + (resourceId == 0 ? "" : $" and resource_id = {(long)resourceId}")));

                monthCloseOppo = Convert.ToInt32(caDal.GetSingle($"SELECT count(1) from crm_opportunity where delete_time = 0 and projected_close_date <= {monthEnd.ToString("yyyy-MM-dd")} and projected_close_date >= {monthStart.ToString("yyyy-MM-dd")} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE}" + (resourceId == 0 ? "" : $" and resource_id = {(long)resourceId}")));

                monthClosedOppoList = caDal.FindListBySql<crm_opportunity>($"SELECT * from crm_opportunity where delete_time = 0 and actual_closed_time <= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} and actual_closed_time >= {Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and status_id ={(int)DicEnum.OPPORTUNITY_STATUS.CLOSED}" + (resourceId == 0 ? "" : $" and resource_id = {(long)resourceId}"));
                #endregion

                accountCount = Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 " + (resourceId!=0? "  and resource_id ="+ resourceId.ToString() : "")));
                activeOppoList = caDal.FindListBySql<crm_opportunity>($"SELECT * from crm_opportunity where delete_time = 0 and status_id = {(int)DicEnum.OPPORTUNITY_STATUS.ACTIVE} " + (resourceId != 0 ? "  and resource_id =" + resourceId.ToString() : ""));
                newOppoMonthCount = Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_opportunity where delete_time = 0 and create_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and create_time<={Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} " + (resourceId != 0 ? "  and resource_id =" + resourceId.ToString() : "")));

                updateOppoNoteCount = Convert.ToInt32(caDal.GetSingle($"SELECT * from com_activity ca INNER JOIN crm_opportunity co on ca.opportunity_id = co.id where ca.action_type_id = {(int)DicEnum.ACTIVITY_TYPE.OPPORTUNITYUPDATE} and ca.cate_id = {(int)DicEnum.ACTIVITY_CATE.NOTE} and ca.delete_time = 0 and co.delete_time = 0 and ca.create_time>{Tools.Date.DateHelper.ToUniversalTimeStamp(monthStart)} and ca.create_time<={Tools.Date.DateHelper.ToUniversalTimeStamp(monthEnd)} " + (resourceId != 0 ? "  and co.resource_id =" + resourceId.ToString() : "")));
                if (resourceId == 0)
                {
                    // 全部员工时获取所有的区域信息
                    if (terrList != null && terrList.Count > 0)
                        terrList.ForEach(_ => {
                            terrAccDic.Add(_.id, Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 and territory_id =" + _.id.ToString())));
                        });
                }
                else
                {
                    accClassWhere= $" and resource_id ={resourceId.ToString()}";
                    // 单个员工时，获取单个员工下的所有区域信息
                    if (terList != null&& terList.Count>0)
                        terList.ForEach(_ => {
                            terrAccDic.Add(_.territory_id, Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 and territory_id =" + _.id.ToString())));
                        });
                }
               

            }
            if (monthClosedOppoList != null && monthClosedOppoList.Count > 0)
            {
                
                monthClosedOppo = monthClosedOppoList.Count;
                monthClosedOppoList.ForEach(_ => {
                    prodessAmount += (_.ext1 ?? 0);
                    trainsAmount += (_.ext2 ?? 0);
                    hardwareAmount += (_.ext3 ?? 0);
                    monthFeeAmount += (_.ext4 ?? 0);
                    otherAmount += (_.ext5 ?? 0);
                    monthAmount += oppBLl.ReturnOppoRevenue(_.id);
                });
            }
            if(activeOppoList!=null&& activeOppoList.Count > 0)
            {
                activeOppoCount = activeOppoList.Count;
            }
                
            if(accClassList!=null&& accClassList.Count > 0)
            {
                accClassList.ForEach(_ => {
                    classAccDic.Add(_.id, Convert.ToInt32(caDal.GetSingle($"SELECT COUNT(1) from crm_account where delete_time = 0 and classification_id ="+_.id.ToString() + accClassWhere)));
                })
;            }
        }
    }
}