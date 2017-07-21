using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_oper_log_dal : BaseDAL<sys_oper_log>
    {
        private static sys_oper_log_dal dal = new sys_oper_log_dal();

        /// <summary>
        /// 新增日志
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="entity"></param>
        /// <param name="objId"></param>
        /// <param name="userId"></param>
        /// <param name="type"></param>
        /// <param name="cate"></param>
        /// <param name="remark"></param>
        public static void InsertLog<T>(object entity, long objId, long userId, DicEnum.OPER_LOG_TYPE type, DicEnum.OPER_LOG_OBJ_CATE cate, string remark="") where T : class
        {
            sys_oper_log log = new sys_oper_log();
            log.user_id = userId;
            log.user_cate = "用户";
            log.name = "";
            log.phone = "";
            log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            log.oper_object_cate_id = (int)cate;
            log.oper_object_id = objId;// 操作对象id
            log.oper_type_id = (int)type;
            log.oper_description = dal.AddValue<T>(entity as T);
            log.remark = remark;
        }
    }
}
