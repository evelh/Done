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
            return saDal.FindListBySql($"SELECT * from sdk_appointment where delete_time = 0 and resource_id = {resId} and FROM_UNIXTIME(start_time/1000,'%Y-%m-%d') = '{date.ToString("yyyy-MM-dd")}'");
        }
        #endregion


        #region 调度试图相关 增删改
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

    }
}
