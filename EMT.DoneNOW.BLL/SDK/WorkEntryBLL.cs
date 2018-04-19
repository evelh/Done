using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class WorkEntryBLL
    {
        private sdk_work_entry_dal dal = new sdk_work_entry_dal();

        /// <summary>
        /// 获取工时可选的工作类型，排除年休假、私人时间、浮动时间三项
        /// </summary>
        /// <returns></returns>
        public List<d_cost_code> GetTimeCostCodeList()
        {
            var list = new d_cost_code_dal().GetListCostCode((int)DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE);
            list = (from code in list where code.id != 25 && code.id != 35 && code.id != 27 select code).ToList();
            return list;
        }

        /// <summary>
        /// 获取一个员工的工时表审批人列表
        /// </summary>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public List<sys_resource_approver> GetApproverList(long resourceId)
        {
            return dal.FindListBySql<sys_resource_approver>($"select * from sys_resource_approver where resource_id={resourceId} and approve_type_id={(int)DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE}");
        }

        /// <summary>
        /// 获取一个员工可以审批工时的员工列表
        /// </summary>
        /// <param name="approverId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetApproveResList(long approverId)
        {
            return dal.FindListBySql<DictionaryEntryDto>($"select id as `val`,name as `show` from sys_resource where delete_time=0 " +
                $"and (ID in(select resource_id from sys_resource_approver where approve_type_id={(int)DicEnum.APPROVE_TYPE.TIMESHEET_APPROVE} and approver_resource_id={approverId}) " +
                $"or (select security_level_id from sys_resource where id ={approverId}) =1 and 1=1) order by name");
        }

        /// <summary>
        /// 获取一个工时表的当前审批最高等级
        /// </summary>
        /// <param name="workEntryReporyId"></param>
        /// <returns>0:未审批过、1、2、3</returns>
        public int GetWorkEntryReportCurrentApproveTier(long workEntryReporyId)
        {
            var log = dal.FindSignleBySql<tst_work_entry_report_log>($"select * from tst_work_entry_report_log where work_entry_report_id={workEntryReporyId} order by tier desc limit 1 ");
            if (log == null)
                return 0;
            return log.tier;
        }

        /// <summary>
        /// 按批号获取常规工时列表
        /// </summary>
        /// <param name="batchId"></param>
        /// <returns></returns>
        public List<sdk_work_entry> GetWorkEntryByBatchId(long batchId)
        {
            return dal.FindListBySql($"select * from sdk_work_entry where batch_id={batchId} and task_id in(select id from d_cost_code where cate_id={(int)DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE}) and delete_time=0");
        }

        /// <summary>
        /// 新增工时
        /// </summary>
        /// <param name="weList"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddWorkEntry(List<sdk_work_entry> weList, long userId)
        {
            var bll = new TimeOffPolicyBLL();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            long batchId = dal.GetNextId("seq_entry_batch");
            foreach (var we in weList)
            {
                we.id = dal.GetNextIdCom();
                we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.update_time = we.create_time;
                we.create_user_id = userId;
                we.update_user_id = userId;
                we.batch_id = batchId;

                dal.Insert(we);
                OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");

                if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表添加记录
                {
                    var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), 0 - (decimal)we.hours_billed);
                    tst_timeoff_balance bal = new tst_timeoff_balance();
                    bal.object_id = we.id;
                    bal.object_type_id = 2214;
                    bal.task_id = we.task_id;
                    bal.resource_id = (long)we.resource_id;
                    bal.balance = balance - (decimal)we.hours_billed;
                    balDal.Insert(bal);
                }
            }

            return true;
        }

        /// <summary>
        /// 编辑工时
        /// </summary>
        /// <param name="weList">编辑后的工时列表</param>
        /// <param name="batchId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditWorkEntry(List<sdk_work_entry> weList,long batchId, long userId)
        {
            var bll = new TimeOffPolicyBLL();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            var weListOld = GetWorkEntryByBatchId(batchId);
            if (weListOld[0].approve_and_post_user_id != null) // 已审批提交不能编辑
                return false;

            foreach (var we in weListOld)
            {
                if (weList.Exists(_ => _.start_time == we.start_time))  // 原工时被编辑
                {
                    var weOld = dal.FindById(we.id);
                    var weEdit = weList.Find(_ => _.start_time == we.start_time);
                    we.internal_notes = weEdit.internal_notes;
                    we.summary_notes = weEdit.summary_notes;
                    we.hours_worked = weEdit.hours_worked;
                    we.hours_billed = weEdit.hours_billed;
                    we.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.update_user_id = userId;
                    var desc = OperLogBLL.CompareValue<sdk_work_entry>(weOld, we);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        dal.Update(we);
                        OperLogBLL.OperLogUpdate(desc, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时");

                        if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表修改记录
                        {
                            var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), (decimal)we.hours_billed - (decimal)weOld.hours_billed);
                            var bal = balDal.FindSignleBySql<tst_timeoff_balance>($"select * from tst_timeoff_balance where object_id={we.id}");
                            bal.balance = bal.balance + ((decimal)we.hours_billed - (decimal)weOld.hours_billed);
                            balDal.Update(bal);
                        }
                    }
                    weList.Remove(weEdit);
                }
                else    // 原工时被删除
                {
                    we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.delete_user_id = userId;
                    dal.Update(we);
                    OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时删除");

                    if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表删除记录
                    {
                        var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), 0 - (decimal)we.hours_billed);
                        balDal.ExecuteSQL($"delete from tst_timeoff_balance where object_id={we.id}");
                    }
                }
            }
            foreach (var we in weList)  // 剩余需要新增
            {
                we.id = dal.GetNextIdCom();
                we.batch_id = batchId;
                we.resource_id = weListOld[0].resource_id;
                we.cost_code_id = weListOld[0].cost_code_id;
                we.task_id = weListOld[0].task_id;
                we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.update_time = we.create_time;
                we.create_user_id = userId;
                we.update_user_id = userId;

                dal.Insert(we);
                OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "编辑工时新增");

                if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表添加记录
                {
                    var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), (decimal)we.hours_billed);
                    tst_timeoff_balance bal = new tst_timeoff_balance();
                    bal.object_id = we.id;
                    bal.object_type_id = 2214;
                    bal.task_id = we.task_id;
                    bal.balance = balance + (decimal)we.hours_billed;
                    balDal.Insert(bal);
                }
            }

            return true;
        }

        /// <summary>
        /// 删除工时
        /// </summary>
        /// <param name="batchId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteWorkEntry(long batchId, long userId)
        {
            var weList = dal.FindListBySql($"select * from sdk_work_entry where batch_id={batchId} and delete_time=0");
            if (weList.Count == 0)
                return false;

            bool rtn = true;
            var costcode = new d_cost_code_dal().FindById(weList[0].task_id);
            if (costcode.cate_id != (int)DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)   // 任务工时
            {
                string reason;
                var taskbll = new TaskBLL();
                foreach (var we in weList)
                {
                    if (!taskbll.DeleteEntry(we.id, userId, out reason))
                        rtn = false;
                }
            }
            else
            {
                var bll = new TimeOffPolicyBLL();
                tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();

                foreach (var we in weList)
                {
                    if (we.timeoff_request_id != null)  // 休假请求生成的工时
                    {
                        bll.CancleTimeoffRequest(we.timeoff_request_id.Value, userId);
                    }
                    else    // 常规工时
                    {
                        we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        we.delete_user_id = userId;
                        dal.Update(we);
                        OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");

                        if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表删除记录
                        {
                            var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), 0 - (decimal)we.hours_billed);
                            balDal.ExecuteSQL($"delete from tst_timeoff_balance where object_id={we.id}");
                        }
                    }
                }
            }

            return rtn;
        }

        /// <summary>
        /// 删除工时表
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="resourceId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteWorkEntryReport(DateTime startDate, long resourceId, long userId)
        {
            sdk_work_entry_report_dal rptDal = new sdk_work_entry_report_dal();
            var find = rptDal.FindSignleBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and start_date='{startDate}' and delete_time=0");
            if (find != null && find.status_id != (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND)
                return false;

            var weList = GetWorkEntryListByStartDate(startDate, resourceId);
            if (weList.Count == 0)
                return false;

            var bll = new TimeOffPolicyBLL();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            //var weList = GetWorkEntryByBatchId(batchId);
            //if (weList.Count == 0)
            //    return true;
            //if (weList[0].approve_and_post_user_id != null) // 已审批提交不能删除
            //    return false;

            foreach (var we in weList)
            {
                we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                we.delete_user_id = userId;
                dal.Update(we);
                OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");

                if (we.task_id == (long)CostCode.Sick)  // 病假需要在假期余额表删除记录
                {
                    var balance = bll.UpdateTimeoffBalance((long)we.resource_id, Tools.Date.DateHelper.TimeStampToDateTime((long)we.start_time), 0 - (decimal)we.hours_billed);
                    balDal.ExecuteSQL($"delete from tst_timeoff_balance where object_id={we.id}");
                }
            }

            if (find != null)
            {
                find.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                find.delete_user_id = userId;
                rptDal.Update(find);
                OperLogBLL.OperLogDelete<sdk_work_entry_report>(find, find.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "删除工时表");
            }
            return true;
        }

        /// <summary>
        /// 查询工时表是否可以提交、取消提交
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="resourceId"></param>
        /// <returns>1:可以提交;2:可以取消提交;0:其他</returns>
        public int GetTimesheetSubmitStatus(DateTime startDate, long resourceId)
        {
            sdk_work_entry_report_dal rptDal = new sdk_work_entry_report_dal();
            var find = rptDal.FindSignleBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and start_date='{startDate}' and delete_time=0");

            if (find == null)
                return 1;
            if (find.status_id == (int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL)
                return 2;
            if (find.status_id == (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND
                || find.status_id == (int)DicEnum.WORK_ENTRY_REPORT_STATUS.REJECTED)
                return 1;
            return 0;
        }

        /// <summary>
        /// 获取本批次工时是否常规工时
        /// </summary>
        /// <param name="batchId"></param>
        /// <param name="workEntryId"></param>
        /// <returns></returns>
        public bool GetTimesheetIsRegural(long batchId, out long workEntryId)
        {
            workEntryId = 0;
            var list = dal.FindListBySql($"select * from sdk_work_entry where batch_id={batchId} and task_id in(select id from d_cost_code where cate_id<>{(int)DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE}) and delete_time=0");
            if (list.Count == 0)
                return true;

            workEntryId = list[0].id;
            return false;
        }

        /// <summary>
        /// 工时表提交
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="resourceId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SubmitWorkEntry(DateTime startDate, long resourceId, long userId)
        {
            var weList = GetWorkEntryListByStartDate(startDate, resourceId);
            if (weList.Count == 0)
                return false;

            sdk_work_entry_report report = new sdk_work_entry_report();
            sdk_work_entry_report_dal rptDal = new sdk_work_entry_report_dal();

            var find = rptDal.FindSignleBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and start_date='{startDate}' and delete_time=0");
            if (find != null && find.status_id != (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND && find.status_id != (int)DicEnum.WORK_ENTRY_REPORT_STATUS.REJECTED)
                return false;

            if (find == null)
            {
                report.id = rptDal.GetNextIdCom();
                report.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                report.update_time = report.create_time;
                report.create_user_id = userId;
                report.update_user_id = userId;
                report.resource_id = resourceId;
                report.start_date = startDate;
                report.end_date = startDate.AddDays(6);
                report.status_id = (int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL;
                report.submit_time = report.create_time;
                report.submit_user_id = userId;
                rptDal.Insert(report);
                OperLogBLL.OperLogAdd<sdk_work_entry_report>(report, report.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时表提交");

                foreach (var we in weList)
                {
                    var weOld = dal.FindById(we.id);
                    we.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.update_user_id = userId;
                    we.work_entry_report_id = report.id;
                    dal.Update(we);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sdk_work_entry>(weOld, we), we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "工时表提交");
                }
            }
            else
            {
                sdk_work_entry_report reportOld = rptDal.FindById(find.id);
                find.status_id = (int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL;
                find.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                find.update_user_id = userId;
                find.submit_time = find.update_time;
                find.submit_user_id = userId;
                rptDal.Update(find);
                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sdk_work_entry_report>(reportOld, find), find.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时表提交");
            }

            return true;
        }

        /// <summary>
        /// 取消提交工时表
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="resourceId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool CancleSubmitWorkEntry(DateTime startDate, long resourceId, long userId)
        {
            var weList = GetWorkEntryListByStartDate(startDate, resourceId);
            if (weList.Count == 0)
                return false;

            sdk_work_entry_report_dal rptDal = new sdk_work_entry_report_dal();

            var find = rptDal.FindSignleBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and start_date='{startDate}' and delete_time=0");
            if (find == null || find.status_id != (int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL)
                return false;

            sdk_work_entry_report reportOld = rptDal.FindById(find.id);
            find.status_id = (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND;
            find.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            find.update_user_id = userId;
            find.submit_time = find.update_time;
            find.submit_user_id = userId;
            rptDal.Update(find);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sdk_work_entry_report>(reportOld, find), find.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时表取消提交");

            return true;
        }

        /// <summary>
        /// 获取一个员工在一个星期内的工时
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="resId"></param>
        /// <returns></returns>
        public List<sdk_work_entry> GetWorkEntryListByStartDate(DateTime startDate, long resId)
        {
            DateTime endDate = startDate.AddDays(6);
            return dal.FindListBySql($"select * from sdk_work_entry where resource_id={resId} and start_time>={Tools.Date.DateHelper.ToUniversalTimeStamp(startDate)} and start_time<={Tools.Date.DateHelper.ToUniversalTimeStamp(endDate)} and delete_time=0");
        }


        #region 工时报表
        /// <summary>
        /// 获取工时报表
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sdk_work_entry_report GetWorkEntryReportById(long id)
        {
            return new sdk_work_entry_report_dal().FindById(id);
        }

        /// <summary>
        /// 获取员工在指定日期内的工时表
        /// </summary>
        /// <param name="start"></param>
        /// <param name="end"></param>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public List<sdk_work_entry_report> GetWorkEntryReportListByDate(DateTime start, DateTime end, long resourceId)
        {
            return dal.FindListBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and end_date>='{start}' and start_date<='{end}' and delete_time=0");
        }

        /// <summary>
        /// 工时表审批
        /// </summary>
        /// <param name="ids">,号分割的多个工时表id</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public int ApproveWorkEntryReport(string ids, long userId)
        {
            int appCnt = 0;
            var rptDal = new sdk_work_entry_report_dal();
            var logDal = new tst_work_entry_report_log_dal();
            var reports = rptDal.FindListBySql($"select * from sdk_work_entry_report where id in({ids}) and status_id={(int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL} and delete_time=0");
            if (reports == null || reports.Count == 0)
                return appCnt;

            var user = new UserResourceBLL().GetResourceById(userId);
            foreach (var report in reports)
            {
                // 判断用户是否在当前可以审批工时表
                int tier = GetWorkEntryReportCurrentApproveTier(report.id);
                if (tier == 3)
                    continue;
                var aprvResList = GetApproverList((long)report.resource_id);
                tier++;
                if (user.security_level_id == 1 || aprvResList.Exists(_ => _.tier == tier && _.approver_resource_id == userId)) // 用户是管理员或用户可以审批下一级
                {
                    tst_work_entry_report_log log = new tst_work_entry_report_log();
                    log.id = logDal.GetNextIdCom();
                    log.work_entry_report_id = report.id;
                    log.oper_user_id = userId;
                    log.oper_type_id = (int)DicEnum.WORK_ENTRY_REPORT_OPER_TYPE.APPROVAL;
                    log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    log.tier = tier;

                    logDal.Insert(log);
                    OperLogBLL.OperLogAdd<tst_work_entry_report_log>(log, log.id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORK_ENTRY_REPORT_LOG, "工时表审批");

                    appCnt++;

                    int maxTier = aprvResList.Max(_ => _.tier);
                    if (maxTier == tier)    // 是最后一级审批人
                    {
                        var rptOld = rptDal.FindById(report.id);
                        report.status_id = (int)DicEnum.WORK_ENTRY_REPORT_STATUS.PAYMENT_BEEN_APPROVED;
                        report.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        report.update_user_id = userId;
                        report.approve_time = report.update_time;
                        report.approve_user_id = userId;
                        rptDal.Update(report);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sdk_work_entry_report>(rptOld, report), report.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时表审批");
                    }
                }
            }

            return appCnt;
        }

        /// <summary>
        /// 工时表审批拒绝
        /// </summary>
        /// <param name="ids">,号分割的多个工时表id</param>
        /// <param name="reason">拒绝原因</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool RejectWorkEntryReport(string ids, string reason, long userId)
        {
            var rptDal = new sdk_work_entry_report_dal();
            var logDal = new tst_work_entry_report_log_dal();
            var reports = rptDal.FindListBySql($"select * from sdk_work_entry_report where id in({ids}) and status_id={(int)DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL} and delete_time=0");
            if (reports == null || reports.Count == 0)
                return false;

            var user = new UserResourceBLL().GetResourceById(userId);
            foreach (var report in reports)
            {
                // 判断用户是否在当前可以审批工时表
                int tier = GetWorkEntryReportCurrentApproveTier(report.id);
                if (tier == 3)
                    continue;
                var aprvResList = GetApproverList((long)report.resource_id);
                tier++;
                if (user.security_level_id == 1 || aprvResList.Exists(_ => _.tier == tier && _.approver_resource_id == userId)) // 用户可以审批下一级
                {
                    tst_work_entry_report_log log = new tst_work_entry_report_log();
                    log.id = logDal.GetNextIdCom();
                    log.work_entry_report_id = report.id;
                    log.oper_user_id = userId;
                    log.oper_type_id = (int)DicEnum.WORK_ENTRY_REPORT_OPER_TYPE.REJECT;
                    log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    log.description = reason;
                    log.tier = tier;

                    logDal.Insert(log);
                    OperLogBLL.OperLogAdd<tst_work_entry_report_log>(log, log.id, userId, DicEnum.OPER_LOG_OBJ_CATE.WORK_ENTRY_REPORT_LOG, "工时表审批拒绝");
                    
                    var rptOld = rptDal.FindById(report.id);
                    report.status_id = (int)DicEnum.WORK_ENTRY_REPORT_STATUS.REJECTED;
                    report.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    report.update_user_id = userId;
                    report.approve_time = report.update_time;
                    report.approve_user_id = userId;
                    rptDal.Update(report);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sdk_work_entry_report>(rptOld, report), report.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_RECORD, "工时表审批拒绝");
                }
            }

            return true;
        }

        /// <summary>
        /// 获取一个员工最近的最多10条工时表记录
        /// </summary>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public List<sdk_work_entry_report> GetTenWorkEntryReportList(long resourceId)
        {
            return dal.FindListBySql<sdk_work_entry_report>($"select * from sdk_work_entry_report where resource_id={resourceId} and delete_time=0 order by start_date desc limit 10");
        }
        #endregion
    }
}
