using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class DispatchBLL
    {
        private sdk_appointment_dal saDal = new sdk_appointment_dal();
        private sdk_task_dal stDal = new sdk_task_dal();

        #region 约会相关 增删改
        /// <summary>
        /// 新增约会
        /// </summary>
        public bool AddAppointment(sdk_appointment dispatch,long userId)
        {
            if (dispatch == null)
                return false;
            dispatch.id = saDal.GetNextIdCom();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            dispatch.create_time = timeNow;
            dispatch.update_time = timeNow;
            dispatch.create_user_id = userId;
            dispatch.update_user_id = userId;
            saDal.Insert(dispatch);
            OperLogBLL.OperLogAdd<sdk_appointment>(dispatch, dispatch.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_APPOINTMENT, "新增约会");
            return true;
        }
        /// <summary>
        /// 编辑约会
        /// </summary>
        public bool EditAppointment(sdk_appointment dispatch, long userId)
        {
            var oldDis = saDal.FindNoDeleteById(dispatch.id);
            if (oldDis == null)
                return false;
            string desc = saDal.CompareValue<sdk_appointment>(oldDis, dispatch);
            if (string.IsNullOrEmpty(desc))
                return true;
            dispatch.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            dispatch.update_user_id = userId;
            saDal.Update(dispatch);
            OperLogBLL.OperLogUpdate<sdk_appointment>(dispatch, oldDis, dispatch.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_APPOINTMENT, "编辑约会");
            return true;
        }
        /// <summary>
        /// 删除约会
        /// </summary>
        public bool DeleteAppointment(long dId, long userId)
        {
            var oldDis = saDal.FindNoDeleteById(dId);
            if (oldDis == null)
                return false;
            saDal.SoftDelete(oldDis,userId);
            OperLogBLL.OperLogDelete<sdk_appointment>(oldDis, oldDis.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_APPOINTMENT, "删除约会");
            return true;
        }
        /// <summary>
        /// 获取到所有的约会信息
        /// </summary>
        public List<sdk_appointment> GetAppList()
        {
            return saDal.FindListBySql("SELECT * from sdk_appointment where delete_time = 0");
        }
        /// <summary>
        /// 根据员工和日期获取相关的约会
        /// </summary>
        public List<sdk_appointment> GetAppByResDate(long resId,DateTime date)
        {
            var thisTimeStamp = Tools.Date.DateHelper.ToUniversalTimeStamp(date);
            return saDal.FindListBySql($"SELECT * from sdk_appointment where delete_time = 0 and resource_id = {resId} and (FROM_UNIXTIME(start_time/1000,'%Y-%m-%d') = '{date.ToString("yyyy-MM-dd")}' or (start_time<={thisTimeStamp} and end_time>={thisTimeStamp}))");
        }
        /// <summary>
        /// 编辑约会
        /// </summary>
        public bool EditAppointment(long appId,string startTime,decimal duraHours,long resId,long userId)
        {
            var thisApp = saDal.FindNoDeleteById(appId);
            if (thisApp == null)
                return false;
            var startDate = DateTime.Parse(startTime);
            thisApp.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
            thisApp.end_time = thisApp.start_time + (long)(duraHours * 60 * 60 * 1000);
            thisApp.resource_id = resId;
            return EditAppointment(thisApp,userId);
        }
        #endregion

        /// <summary>
        /// 编辑约会
        /// </summary>
        public bool EditTodo(long tId, string startTime, decimal duraHours, long resId, long userId)
        {
            var caDal = new com_activity_dal();
            var thisTodo = caDal.FindNoDeleteById(tId);
            if (thisTodo == null)
                return false;
            var startDate = DateTime.Parse(startTime);
            thisTodo.start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
            thisTodo.end_date = thisTodo.start_date + (long)(duraHours * 60 * 60 * 1000);
            thisTodo.resource_id = resId;
            thisTodo.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisTodo.update_user_id = userId;
            var oldTodo = caDal.FindNoDeleteById(tId);
            caDal.Update(thisTodo);
            OperLogBLL.OperLogUpdate<com_activity>(thisTodo, oldTodo, thisTodo.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY, "编辑待办");
            return true;
        }

            #region 调度视图相关 增删改
            /// <summary>
            /// 新增约会
            /// </summary>
            public bool AddDispatchView(sdk_dispatcher_view disView, long userId)
        {
            if (disView == null)
                return false;
            var sdDal = new sdk_dispatcher_view_dal();
            disView.id = saDal.GetNextIdCom();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            disView.create_time = timeNow;
            disView.update_time = timeNow;
            disView.create_user_id = userId;
            disView.update_user_id = userId;
            sdDal.Insert(disView);
            OperLogBLL.OperLogAdd<sdk_dispatcher_view>(disView, disView.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_DISPATCHER_VIEW, "新增调度工作室视图");
            return true;
        }
        /// <summary>
        /// 编辑约会
        /// </summary>
        public bool EditDispatchView(sdk_dispatcher_view disView, long userId)
        {
            var sdDal = new sdk_dispatcher_view_dal();
            var oldDis = sdDal.FindNoDeleteById(disView.id);
            if (oldDis == null)
                return false;
            string desc = saDal.CompareValue<sdk_dispatcher_view>(oldDis, disView);
            if (string.IsNullOrEmpty(desc))
                return true;
            disView.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            disView.update_user_id = userId;
            sdDal.Update(disView);
            OperLogBLL.OperLogUpdate<sdk_dispatcher_view>(disView, oldDis, disView.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_DISPATCHER_VIEW, "编辑调度工作室视图");
            return true;
        }
        /// <summary>
        /// 删除约会
        /// </summary>
        public bool DeleteDispatchView(long dId, long userId)
        {
            var sdDal = new sdk_dispatcher_view_dal();
            var oldDis = sdDal.FindNoDeleteById(dId);
            if (oldDis == null)
                return false;
            sdDal.SoftDelete(oldDis, userId);
            OperLogBLL.OperLogDelete<sdk_dispatcher_view>(oldDis, oldDis.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_DISPATCHER_VIEW, "删除调度工作室视图");
            return true;
        }

        /// <summary>
        /// 获取到所有的调度视图信息
        /// </summary>
        public List<sdk_dispatcher_view> GetDisViewList()
        {
            var sdDal = new sdk_dispatcher_view_dal();
            return sdDal.FindListBySql("SELECT * from sdk_dispatcher_view where delete_time = 0");
        }
        #endregion

        #region 快速服务预定
        /// <summary>
        /// 快速新增
        /// </summary>
        public bool AddQuickCall(ServiceCallDto param,long userId)
        {
            // 新增工单
            var tBll = new TicketBLL();
            param.thisTicket.type_id = (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET;
            param.thisTicket.status_id = (int)DicEnum.TICKET_STATUS.NEW;
            tBll.InsertTicket(param.thisTicket,userId);
            // 新增自定义
            var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                param.thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
            // 新增其他负责人
            if (!string.IsNullOrEmpty(param.resIds))
                tBll.TicketResManage(param.thisTicket.id, param.resIds, userId);
            // 新增服务预定
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            tBll.AddCallOnly(param.call,userId);
            var ssctDal = new sdk_service_call_task_dal();
            var taskRes = new sdk_service_call_task()
            {
                id = ssctDal.GetNextIdCom(),
                create_time = timeNow,
                create_user_id = userId,
                service_call_id = param.call.id,
                task_id = param.thisTicket.id,
                update_time = timeNow,
                update_user_id = userId,
            };
            ssctDal.Insert(taskRes);
            OperLogBLL.OperLogAdd<sdk_service_call_task>(taskRes, taskRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL_TICKET, "新增服务预定关联工单");
            if (!string.IsNullOrEmpty(param.resIds))
                tBll.CallTicketResManage(param.call.id, param.resIds,userId);
            return true;
        }
        /// <summary>
        /// 根据员工部门Id 获取相关员工ID
        /// </summary>
        public string GetResByResDep(string resDepIds)
        {
            string resIds = "";
            if (!string.IsNullOrEmpty(resDepIds))
            {
                var resDepList = new sys_resource_department_dal().GetListByIds(resDepIds, false);
                if(resDepList!=null&& resDepList.Count > 0)
                {
                    var dic = resDepList.GroupBy(_=>_.resource_id).ToDictionary(_ => _.Key, _=>_.ToList());
                    foreach (var key in dic)
                    {
                        resIds += key.Key.ToString() + ',';
                    }
                }
            }
            if (resIds != "")
                resIds = resIds.Substring(0, resIds.Length-1);
            return resIds;
        }
        #endregion
        /// <summary>
        /// 拖拽后修改服务预定
        /// </summary>
        public bool EditServiceCall(long callId,long? oldResId,long newResId,long? roleId, string startTime,decimal duraHours,long userId)
        {
            var tBLL = new TicketBLL();
            var sscDal = new sdk_service_call_dal();
            var thisCall = sscDal.FindNoDeleteById(callId);
            if (thisCall == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var oldStartDate = Tools.Date.DateHelper.ConvertStringToDateTime(thisCall.start_time);
            var newStartDate = DateTime.Parse(startTime);
            thisCall.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(newStartDate);
            thisCall.end_time = thisCall.start_time + (long)(duraHours * 60 * 60 * 1000);
            thisCall.update_time = timeNow;
            thisCall.update_user_id = userId;
            var oldSer = sscDal.FindNoDeleteById(callId);
            sscDal.Update(thisCall);
            OperLogBLL.OperLogUpdate<sdk_service_call>(thisCall, oldSer, thisCall.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL, "编辑服务预定");
            if (oldResId != newResId && roleId == null)
                return false;
            var ssctrDal = new sdk_service_call_task_resource_dal();
            var ssctDal = new sdk_service_call_task_dal();
            if (oldResId != newResId)
            {
                var thisDep = new sys_resource_department_dal().GetResDepByResAndRole(newResId, (long)roleId);
                if (thisDep == null || thisDep.Count == 0)
                    return false;
                if (oldResId != null)
                {
                    var oldResList = ssctrDal.GetResByCallRes(callId, (long)oldResId);
                    oldResList.ForEach(_ => {
                        ssctrDal.SoftDelete(_, userId);
                        OperLogBLL.OperLogDelete<sdk_service_call_task_resource>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "删除服务预定负责人");
                    });
                }
                var thisCallTicket = stDal.GetTciketByCall(callId);
                if (thisCallTicket != null && thisCallTicket.Count > 0)
                {
                    var strDal = new sdk_task_resource_dal();
                    thisCallTicket.ForEach(_ => {
                        // 为服务预定添加该负责人
                        var thisCallTask = ssctDal.GetSingTaskCall(callId,_.id);
                        if (thisCallTask != null)
                        {
                            var resList = ssctrDal.GetTaskResList(thisCallTask.id);
                            if(!resList.Any(r=>r.resource_id== newResId))
                            {
                                var ssct = new sdk_service_call_task_resource()
                                {
                                    id = ssctrDal.GetNextIdCom(),
                                    create_time = timeNow,
                                    create_user_id = userId,
                                    resource_id = newResId,
                                    service_call_task_id = thisCallTask.id,
                                    update_time = timeNow,
                                    update_user_id = userId,
                                };
                                ssctrDal.Insert(ssct);
                                OperLogBLL.OperLogAdd<sdk_service_call_task_resource>(ssct, ssct.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SERVICE_CALL_RESOURCE, "新增服务预定负责人");
                            }
                        }

                        // 为工单团队添加负责人
                        if (!tBLL.IsHasRes(_.id, newResId))
                        {
                            var item = new sdk_task_resource()
                            {
                                id = strDal.GetNextIdCom(),
                                task_id = _.id,
                                role_id = roleId,
                                resource_id = newResId,
                                department_id = (int)thisDep[0].department_id,
                                create_user_id = userId,
                                update_user_id = userId,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            strDal.Insert(item);
                            OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
                        }
                    });
                }
            }
            return true;
        }

    }
}
