using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class SysRoleInfoBLL
    {
        private readonly sys_role_dal _dal = new sys_role_dal();
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("Tax_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)));        // 税收种类
            return dic;
        }
        public ERROR_CODE Insert(sys_role role, long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            var ro = _dal.FindSignleBySql<sys_role>($"select * from sys_role where name={role.name} and delete_time=0 ");
            if (ro != null) {
                return ERROR_CODE.EXIST;
            }

            role.id=(int)(_dal.GetNextIdCom());
            role.create_time=role.update_time=Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            role.create_user_id = role.update_user_id = user_id;           
            role.create_user_id = user.id;
            _dal.Insert(role);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ROLE,//员工
                oper_object_id =role.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(role),
                remark = "新增角色"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }

        public ERROR_CODE Update(sys_role role, long user_id)
        {
           role.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            role.update_user_id = user.id;
            var ro = _dal.FindSignleBySql<sys_role>($"select * from sys_role where name={role.name} and delete_time=0 ");
            if (ro != null&&ro.id!=role.id)
            {
                return ERROR_CODE.EXIST;
            }

            if (_dal.Update(role) == false) {
                return ERROR_CODE.ERROR;
            }
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ROLE,//员工
                oper_object_id = role.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(role),
                remark = "修改角色"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 返回一个角色对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_role GetOneData(int id) {
            return _dal.FindById(id);
        }
        /// <summary>
        /// 返回与角色关联的部门员工集合
        /// </summary>
        /// <param name="rid"></param>
        /// <returns></returns>
        public DataTable resourcelist(int rid) {
            string sql =$"select u.id as 员工id,u.name as 员工姓名,(select name from sys_department where id=d.department_id) as 所属部门 from sys_resource u left join sys_resource_department d on d.resource_id=u.id left join sys_role r on d.role_id = r.id where u.delete_time=0 and r.id={rid} order by u.name";
            return _dal.ExecuteDataTable(sql);
        }
        
    }
}
