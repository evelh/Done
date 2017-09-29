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
    public class OperLogBLL
    {
        private static sys_oper_log_dal dal = new sys_oper_log_dal();

        /// <summary>
        /// 插入日志
        /// </summary>
        /// <typeparam name="T">日志对象类</typeparam>
        /// <param name="entity">操作对象</param>
        /// <param name="objId">操作对象id</param>
        /// <param name="userId">userid</param>
        /// <param name="type">操作类型</param>
        /// <param name="cate">操作对象种类</param>
        /// <param name="operDesc">操作内容</param>
        /// <param name="remark">备注</param>
        public static void OperLog<T>(T entity, long objId, long userId, DicEnum.OPER_LOG_TYPE type, DicEnum.OPER_LOG_OBJ_CATE cate, string operDesc, string remark) where T : class
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
            log.oper_description = operDesc;
            log.remark = remark;

            dal.Insert(log);
        }

        /// <summary>
        /// 插入新增日志
        /// </summary>
        /// <typeparam name="T">日志对象类</typeparam>
        /// <param name="entity">操作对象</param>
        /// <param name="objId">操作对象id</param>
        /// <param name="userId">userid</param>
        /// <param name="cate">操作对象种类</param>
        /// <param name="remark">备注</param>
        public static void OperLogAdd<T>(T entity, long objId, long userId, DicEnum.OPER_LOG_OBJ_CATE cate, string remark) where T : class
        {
            string desc = dal.AddValue<T>(entity);
            OperLog<T>(entity, objId, userId, DicEnum.OPER_LOG_TYPE.ADD, cate, desc, remark);
        }

        /// <summary>
        /// 插入更新日志
        /// </summary>
        /// <typeparam name="T">日志对象类</typeparam>
        /// <param name="entity">操作对象</param>
        /// <param name="entityOld">操作对象旧值</param>
        /// <param name="objId">操作对象id</param>
        /// <param name="userId">userid</param>
        /// <param name="cate">操作对象种类</param>
        /// <param name="remark">备注</param>
        public static void OperLogUpdate<T>(T entity, T entityOld, long objId, long userId, DicEnum.OPER_LOG_OBJ_CATE cate, string remark) where T : class
        {
            string desc = dal.CompareValue<T>(entityOld, entity);
            OperLog<T>(entity, objId, userId, DicEnum.OPER_LOG_TYPE.UPDATE, cate, desc, remark);
        }

        /// <summary>
        /// 插入删除日志
        /// </summary>
        /// <typeparam name="T">日志对象类</typeparam>
        /// <param name="entity">操作对象</param>
        /// <param name="objId">操作对象id</param>
        /// <param name="userId">userid</param>
        /// <param name="cate">操作对象种类</param>
        /// <param name="remark">备注</param>
        public static void OperLogDelete<T>(T entity, long objId, long userId, DicEnum.OPER_LOG_OBJ_CATE cate, string remark) where T : class
        {
            string desc = dal.AddValue<T>(entity);
            OperLog<T>(entity, objId, userId, DicEnum.OPER_LOG_TYPE.DELETE, cate, desc, remark);
        }
    }
}
