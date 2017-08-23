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
    public class SysSecurityLevelBLL
    {
        private readonly sys_limit_dal _dal = new sys_limit_dal();
        public List<sys_limit> GetAll()
        {
            return _dal.FindAll().ToList<sys_limit>();
        }
        public Dictionary<int, string> GetDownList(int parent_id)
        {
            Dictionary<int, string> dic = new Dictionary<int, string>();
            return new d_general_dal().FindListBySql($"select * from d_general where parent_id ={parent_id}").ToDictionary(d => d.id, d => d.name);

        }
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("HAVE_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.HAVE_NONE));                       //有无
            dic.Add("ALL_PART_MINE_NONE",GetDownList((int)DicEnum.LIMIT_TYPE.ALL_PART_MINE_NONE));      // 全部部分我的无
            dic.Add("ALL_MINE_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.ALL_MINE_NONE));               // 全部无
            dic.Add("ALL_NONE", GetDownList((int)DicEnum.LIMIT_TYPE.ALL_NONE));                         // task
            dic.Add("TASK", GetDownList((int)DicEnum.LIMIT_TYPE.TASK));                                 // ticket
            dic.Add("CONTACT", GetDownList((int)DicEnum.LIMIT_TYPE.CONTACT));                           // contact
            dic.Add("NOT_REQUIRE", GetDownList((int)DicEnum.LIMIT_TYPE.NOT_REQUIRE));                   // 无需权限
            return dic;
        }
        public List<sys_resource> GetResourceList(int id) {
            return new sys_resource_dal().FindListBySql<sys_resource>($"SELECT `name`,is_active  FROM  sys_resource WHERE	security_level_id ={id} ORDER BY `name` ").ToList();
        }


        public sys_security_level GetSecurityLevel(long id)
        {
            return new sys_security_level_dal().FindById(id);
        }
        public ERROR_CODE Save(sys_security_level_limit sqt, long user_id)
        {
            sys_security_level_limit_dal sslld = new sys_security_level_limit_dal();
            var da=sslld.FindSignleBySql<sys_security_level_limit>($"select * from sys_security_level_limit where security_level_id={sqt.security_level_id} and limit_id={sqt.limit_id}");
            if (da!=null)//判断是否已经保存过权限点数据
            {
                if (sqt.limit_id != da.limit_id) {
                    sqt.id = da.id;
                    sslld.Update(sqt);//把数据保存到数据库表
                    var user = UserInfoBLL.GetUserInfo(user_id);
                    if (user == null)
                    {   // 查询不到用户，用户丢失
                        return ERROR_CODE.USER_NOT_FIND;
                    }
                    var add_account_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = "",
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
                    name = "",
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
            seclev.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            seclev.update_user_id = user_id;
           bool k= new sys_security_level_dal().Update(seclev);
            if (k == false) {
                return ERROR_CODE.ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SECURITY_LEVEL,
                oper_object_id = seclev.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(seclev),
                remark = "新增权限点关联模板"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }
    }
}
