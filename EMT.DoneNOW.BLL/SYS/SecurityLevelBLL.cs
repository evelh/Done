using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class SecurityLevelBLL
    {
        private readonly sys_limit_dal _dal = new sys_limit_dal();
        private readonly sys_security_level_dal ss_dal = new sys_security_level_dal();
        private readonly sys_security_level_limit_dal ssl_dal = new sys_security_level_limit_dal();
        public List<sys_limit> GetAll()
        {
            return _dal.FindAll().ToList<sys_limit>();
        }
        /// <summary>
        /// //通过security_level的id获取security_level_limit
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_security_level_limit> GetSecurity_limit(int id) {
            return ssl_dal.FindListBySql($"select * from sys_security_level_limit where security_level_id={id} ").ToList();            
        }
        /// <summary>
        /// 通过security_level的id获取module
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_module> GetSecurity_module(int id)
        {
            return new sys_module_dal().FindListBySql($"select DISTINCT `name`  from sys_security_level_module a,sys_module b where security_level_id={id} and a.module_id=b.id").ToList();
        }
        /// <summary>
        /// 获取对应的权限类型
        /// </summary>
        /// <param name="parent_id"></param>
        /// <returns></returns>
        public Dictionary<int, string> GetDownList(int parent_id)
        {
            Dictionary<int, string> dic = new Dictionary<int, string>();
            return new d_general_dal().FindListBySql($"select * from d_general where parent_id ={parent_id}").ToDictionary(d => d.id, d => d.name);
        }
        //public Dictionary<string, object> GetField()
        //{
        //    Dictionary<string, object> dic = new Dictionary<string, object>();
        //    dic.Add("HAVE_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.HAVE_NONE));                       //有无
        //    dic.Add("ALL_PART_MINE_NONE",GetDownList((int)DicEnum.LIMIT_TYPE.ALL_PART_MINE_NONE));      // 全部部分我的无
        //    dic.Add("ALL_MINE_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.ALL_MINE_NONE));               // 全部无
        //    dic.Add("ALL_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.ALL_NONE));                         // task
        //    dic.Add("TASK", GetDownList((int)DicEnum.LIMIT_TYPE.TASK));                                 // ticket
        //    dic.Add("CONTACT", GetDownList((int)DicEnum.LIMIT_TYPE.CONTACT));                           // contact
        //    dic.Add("NOT_REQUIRE", GetDownList((int)DicEnum.LIMIT_TYPE.NOT_REQUIRE));                   // 无需权限
        //    return dic;
        //}
        /// <summary>
        /// 通过权限等级id获取，此权限等级下所有的员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_resource> GetResourceList(int id) {
            return new sys_resource_dal().FindListBySql<sys_resource>($"SELECT `name`,is_active  FROM  sys_resource WHERE	security_level_id ={id} and delete_time=0 ORDER BY `name` ").ToList();
        }
        /// <summary>
        /// 通过id,范回一个权限等级对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_security_level GetSecurityLevel(long id)
        {
            return new sys_security_level_dal().FindById(id);
        }
        /// <summary>
        /// 保存权限等级，主要使用更新操作
        /// </summary>
        /// <param name="sqt"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Save(sys_security_level_limit sqt, long user_id)
        {
            sys_security_level_limit_dal sslld = new sys_security_level_limit_dal();
            var da=sslld.FindSignleBySql<sys_security_level_limit>($"select * from sys_security_level_limit where security_level_id={sqt.security_level_id} and limit_id={sqt.limit_id} ");
            if (da!=null)//判断是否已经保存过权限点数据
            {
                if (sqt.limit_type_value_id != da.limit_type_value_id) {
                    sslld.Update(sqt);
                    var user = UserInfoBLL.GetUserInfo(user_id);
                    if (user == null)
                    {   // 查询不到用户，用户丢失
                        return ERROR_CODE.USER_NOT_FIND;
                    }
                    var add_account_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                        oper_object_id = sqt.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(sqt),
                        remark = "新增权限点关联模板"

                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
                }                
            }
            else {
                sqt.id = (int)(_dal.GetNextIdCom());
                sslld.Insert(sqt);//把数据保存到数据库表
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user == null)
                {   // 查询不到用户，用户丢失
                    return ERROR_CODE.USER_NOT_FIND;
                }
                var add_account_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                    oper_object_id = sqt.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(sqt),
                    remark = "新增权限点关联模板"

                };          // 创建日志
                new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            }


            
            return ERROR_CODE.SUCCESS;
        }

        public ERROR_CODE UpdateSecurityLevel(sys_security_level seclev, long user_id) {            
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var old = GetSecurityLevel(seclev.id);
            seclev.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            seclev.update_user_id = user_id;
            bool k = new sys_security_level_dal().Update(seclev);
            if (k == false)
            {
                return ERROR_CODE.ERROR;
            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                oper_object_id = seclev.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = new sys_security_level_dal().CompareValue(old,seclev),
                remark = "修改权限点关联模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        } 
        /// <summary>
        /// 激活安全等级
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE ActiveSecurityLevel(long user_id, int id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var old = GetSecurityLevel(id);
            // sys_security_level sclev = new sys_security_level();
            var seclev = old;
            if (seclev == null) {
                return ERROR_CODE.ERROR;
            }
            if (seclev.is_active!=null&& seclev.is_active > 0) {
                return ERROR_CODE.ACTIVATION;//已经激活
            }
            seclev.is_active = 1;
            seclev.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            seclev.update_user_id = user_id;
            if (ss_dal.Update(seclev)==false) {
                return ERROR_CODE.ERROR;//更新激活状态失败
            }
           
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                oper_object_id = seclev.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ss_dal.CompareValue(old,seclev),
                remark = "修改权限点关联模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 设置为失活状态
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE NOActiveSecurityLevel(long user_id, int id) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var seclev = ss_dal.FindById(id);
            var old = seclev;
            if (seclev == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (seclev.is_active == null || seclev.is_active == 0)
            {
                return ERROR_CODE.NO_ACTIVATION;
            }
            seclev.is_active = 0;
            seclev.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            seclev.update_user_id = user_id;
            if (ss_dal.Update(seclev) == false)
            {
                return ERROR_CODE.ERROR;//更新激活状态失败
            }           
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                oper_object_id = seclev.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ss_dal.CompareValue(old,seclev),
                remark = "修改权限点关联模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除安全等级
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE DeleteSecurityLevel(long user_id, int id) {
            var seclev = ss_dal.FindById(id);
            seclev.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            seclev.delete_user_id = user_id;
            return ERROR_CODE.ERROR;
        }
        /// <summary>
        /// 复制安全等级
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <param name="copy_id"></param>
        /// <returns></returns>
        public bool CopySecurityLevel(long user_id, int id, out int copy_id) {
            var s1 = new sys_security_level_dal().FindById(id);
            copy_id = -1;
            if (s1 == null)
                return false;
            sys_security_level s = new sys_security_level();
            s.id = copy_id = (int)(_dal.GetNextIdCom());
            s.name = "（copy of）" + s1.name;
            s.is_active = 1;
            s.is_active = 0;
            s.license_type_id = s1.license_type_id;
            s.create_time = s.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            s.create_user_id =s.update_user_id= user_id;
            ss_dal.Insert(s);
            //更新复制插入语句
            //insert into sys_security_level_limit(id,security_level_id,limit_id,limit_type_value_id)  select (select f_nextval('seq_com')),3,limit_id,limit_type_value_id from  sys_security_level_limit where security_level_id=2

            try {
                if (ssl_dal.ExecuteSQL($"insert into sys_security_level_limit(id,security_level_id,limit_id,limit_type_value_id)  select (select f_nextval('seq_com')),{copy_id},limit_id,limit_type_value_id from  sys_security_level_limit where security_level_id={id}") != 130)
                {
                    return false;
                }
            } catch {
                return false;
            }

            sys_security_level_module_dal ssm_dal = new sys_security_level_module_dal();
            try {
                if (ssm_dal.ExecuteSQL($"insert into `sys_security_level_module` (`id`, `security_level_id`, `module_id`, `module_limit_id`, `module_limit_value`, `module_value`) select (select f_nextval('seq_com')),{copy_id}, `module_id`, `module_limit_id`, `module_limit_value`, `module_value` from sys_security_level_module where security_level_id={id}")<=0) {
                    return false;
                }
            } catch {
                return false;
            }

            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return false;
            }
            try {
                var add_account_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                    oper_object_id = s.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = ss_dal.AddValue(s),
                    remark = "新增权限点关联模板"

                };          // 创建日志
                new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            } catch {
            }          

            return true;
        }
    }
}
