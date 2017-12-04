using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System.Reflection;

namespace EMT.DoneNOW.BLL
{
    public class OperLogBLL
    {
        private static sys_oper_log_dal dal = new sys_oper_log_dal();

        /// <summary>
        /// 插入日志
        /// </summary>
        /// <param name="objId">操作对象id</param>
        /// <param name="userId">userid</param>
        /// <param name="type">操作类型</param>
        /// <param name="cate">操作对象种类</param>
        /// <param name="operDesc">操作内容</param>
        /// <param name="remark">备注</param>
        public static void OperLog(long objId, long userId, DicEnum.OPER_LOG_TYPE type, DicEnum.OPER_LOG_OBJ_CATE cate, string operDesc, string remark)
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
            OperLog(objId, userId, DicEnum.OPER_LOG_TYPE.ADD, cate, desc, remark);
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
            OperLog(objId, userId, DicEnum.OPER_LOG_TYPE.UPDATE, cate, desc, remark);
        }

        public static void OperLogUpdate(string desc, long objId, long userId, DicEnum.OPER_LOG_OBJ_CATE cate, string remark)
        {
            OperLog(objId, userId, DicEnum.OPER_LOG_TYPE.UPDATE, cate, desc, remark);
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
            OperLog(objId, userId, DicEnum.OPER_LOG_TYPE.DELETE, cate, desc, remark);
        }

        /// <summary>
        /// 比较两个类中的属性值是否有变化,返回有变化的属性，并将旧的和新的值记录下来
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="old_value">旧的值</param>
        /// <param name="new_value">新的值</param>
        /// <returns></returns>
        public static string CompareValue<T>(T old_value, T new_value) where T : class
        {
            if (old_value == null || new_value == null)
                return null;
            //  List<ObjUpdateDto> list = new List<ObjUpdateDto>();// 类型更改的类集合
            Dictionary<string, string> dict = new Dictionary<string, string>();
            Type t = typeof(T);// 首先获取T的类
            PropertyInfo[] properties = t.GetProperties();// 获取到T中的所有的属性

            foreach (PropertyInfo p in properties)// 循环遍历所有的属性
            {
                if (p.Name == "update_time" || p.Name == "update_user_id")
                    continue;
                if (!GetObjectPropertyValue(old_value, p.Name).Equals(GetObjectPropertyValue(new_value, p.Name)))// 将旧的和新的进行比较，将不同放入集合中
                {
                    dict.Add(p.Name, GetObjectPropertyValue(old_value, p.Name) + "→" + GetObjectPropertyValue(new_value, p.Name));
                }
            }
            if (dict.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(dict);
        }

        /// <summary>
        /// 获取到T模板中的属性的值
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <param name="propertyname"></param>
        /// <returns></returns>
        private static string GetObjectPropertyValue<T>(T t, string propertyname)
        {
            // T模板类型
            Type type = typeof(T);
            // 获得属性
            PropertyInfo property = type.GetProperty(propertyname);
            // 属性非空判断
            if (property == null) return string.Empty;
            // 获取Value
            object o = property.GetValue(t, null);
            // Value非空判断
            if (o == null) return string.Empty;
            // 返回Value
            return o.ToString();
        }
    }
}
