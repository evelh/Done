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
   public class DepartmentBLL
    {
        private readonly sys_department_dal _dal = new sys_department_dal();
        /// <summary>
        /// 获取地址下拉框
        /// </summary>
        /// <returns></returns>
        public Dictionary<long, string> GetDownList()
        {
            Dictionary<long, string> dic = new Dictionary<long, string>();
            return new sys_organization_location_dal().FindListBySql<sys_organization_location>($"select * from sys_organization_location where delete_time=0").ToDictionary(d => d.id, d =>d.name);
        }
        /// <summary>
        /// 根据地址id获取时区//具体显示后期需要修改8-24
        /// </summary>
        /// <returns></returns>
        public string GetTime_zone(int id) {
            var location = new sys_organization_location_dal().FindById(id);
            if (location != null) {
                var timezone = new d_time_zone_dal().FindById(location.time_zone_id);
                if (timezone != null)
                {
                    return timezone.standard_name;
                }
            }
            return "";
        }
        public ERROR_CODE Insert(sys_department sd,long user_id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var de = _dal.FindSignleBySql<sys_department>($"select * from  sys_department where name='{sd.name}' and delete_time=0");
            if (de != null) {
                return ERROR_CODE.EXIST;
            }
            sd.id= (int)(_dal.GetNextIdCom());
            sd.create_time=sd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sd.create_user_id = user_id;
            sd.cate_id =(int)DEPARTMENT_CATE.DEPARTMENT;
            _dal.Insert(sd);

            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.DEPARTMENT,//部门
                oper_object_id = sd.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(sd),
                remark = "保存部门信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志


            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE Update(sys_department sd, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var de = _dal.FindSignleBySql<sys_department>($"select * from  sys_department where name='{sd.name}' and delete_time=0");
            var old = _dal.FindSignleBySql<sys_department>($"select * from  sys_department where id={sd.id} and delete_time=0");
            if (de != null&&de.id!=sd.id)
            {
                return ERROR_CODE.EXIST;
            }
            sd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            sd.update_user_id = user_id;
            sd.cate_id = (int)DEPARTMENT_CATE.DEPARTMENT;
            
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.DEPARTMENT,//部门
                oper_object_id = sd.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,sd),
                remark = "修改部门信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            if (!_dal.Update(sd))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除部门
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(long id, long user_id,out string returnvalue)
        {
            returnvalue = string.Empty;
            StringBuilder re = new StringBuilder();
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var res = new sys_resource_dal().FindListBySql<sys_resource>($"select a.* from sys_resource a,sys_resource_department b where a.id=b.resource_id and a.delete_time=0 and b.department_id={id}");
            if (res.Count > 0) {
                re.Append("部门不能被删除，因为它被以下对象引用：");
                int n = 1;
                foreach (var ii in res) {
                    re.Append("N" + (n++) + "\t\t" +ii.name+ "\n");
                }
                returnvalue = re.ToString();
                return ERROR_CODE.EXIST;
            }

            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.DEPARTMENT,//部门
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(data),
                remark = "删除部门信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        ///通过id查找一个sys_department对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_department GetOne(int id) {
            return _dal.FindById(id);
        }
        /// <summary>
        /// 返回该部门的员工信息
        /// </summary>
        /// <param name="did"></param>
        /// <returns></returns>
        public DataTable resourcelist(int did)
        {
            string sql = $" select u.id as 员工id, u.name as 姓名, r.name as 角色名称, (case when d.is_default= 1 then '√' end) as  默认部门和角色,(case when d.is_lead=1 then '√' end) as 部门主管,(case when u.is_active=1 then '√' end) as 激活 from sys_resource u left join sys_resource_department d on d.resource_id = u.id left join sys_role r on d.role_id = r.id where d.department_id={did} and  u.delete_time= 0   order by u.name";
            return _dal.ExecuteDataTable(sql);
        }
        /// <summary>
        /// 返回该部门的工作类型信息
        /// </summary>
        /// <param name="did"></param>
        /// <returns></returns>
        public DataTable worklist(int did) {
            string sql = $"select c.id as 工作类型id, (select name from d_general where id = c.cate_id) as 工作类型名称,c.external_id as 外部码,(select name from d_general where id = c.general_ledger_id) as 总账代码,(case when c.show_on_invoice in (1333,1334) then '√' end) as 是否计费 from d_cost_code c left join sys_department d on c.department_id = d.id where c.delete_time= 0 and d.id={did}  order by 工作类型名称";
            return _dal.ExecuteDataTable(sql);
        }
    }
}
