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
    public class UserResourceBLL
    {
        private readonly sys_resource_dal _dal = new sys_resource_dal();
        private readonly sys_user_dal _dal1 = new sys_user_dal();
        //对页面SysManage.aaspx的数据填充
        public Dictionary<string, object> GetDownList()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("DateFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.DATE_DISPLAY_FORMAT)));              // 日期格式
            dic.Add("NumberFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NUMBER_DISPLAY_FORMAT)));              // 数字格式
            dic.Add("TimeFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TIME_DISPLAY_FORMAT)));              // 时间格式（正数）
            dic.Add("EmailType", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.EMAILTYPE)));
            dic.Add("Sex", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.SEX)));
            dic.Add("NameSuffix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));

            //权限
            var Security_Level = new sys_security_level_dal().FindListBySql("select id,name from sys_security_level where delete_time=0");
            dic.Add("Security_Level", Security_Level);

            //地址
            var Position = new sys_organization_location_dal().FindListBySql("select id,name from sys_organization_location where delete_time=0");
            dic.Add("Position", Position);
            // Position
            dic.Add("Outsource_Security", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OUTSOURCE_SECURITY)));
            //var location=new sys_organization_location_dal()
            //Position
            return dic;

        }
        /// <summary>
        /// 新增员工信息
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(SysUserAddDto data, long user_id,out long id) {
            id = data.sys_res.id = (int)(_dal.GetNextIdCom());
            if (_dal.FindSignleBySql<sys_resource>($"select * from sys_resource where `name`='{data.sys_res.name}'") != null) {
                return ERROR_CODE.SYS_NAME_EXIST;
            }
            if (new sys_user_dal().FindSignleBySql<sys_user>($"select * from sys_user where `name`='{data.sys_user.name}'") != null)
            {
                return ERROR_CODE.EXIST;
            }
            data.sys_res.create_user_id = data.sys_res.update_user_id = user_id;
            data.sys_res.create_time = data.sys_res.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Insert(data.sys_res);
            //操作日志新增一条日志,操作对象种类：员工
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name =user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,//员工
                oper_object_id = data.sys_res.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data.sys_res),
                remark = "保存员工信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            data.sys_user.id = id;
            //MD5加密
           data.sys_user.password = new Tools.Cryptographys().MD5Encrypt(data.sys_user.password,false);
            new sys_user_dal().Insert(data.sys_user);

          add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
              name = user.name,
              phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = data.sys_user.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data.sys_user),
                remark = "保存客户信息"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新员工信息
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(SysUserAddDto data, long user_id,long id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var nameex = _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where `name`='{data.sys_res.name}'");
            if (nameex != null&& nameex.id!=id)
            {
                return ERROR_CODE.SYS_NAME_EXIST;
            }
            var username = new sys_user_dal().FindSignleBySql<sys_user>($"select * from sys_user where `name`='{data.sys_res.name}'");
            if (username != null && username.id != id)
            {
                return ERROR_CODE.EXIST;
            }
            var old = GetSysResourceSingle(id);
            data.sys_res.id = id;
            data.sys_res.update_user_id = user_id;
            data.sys_res.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Update(data.sys_res);
            //操作日志新增一条日志,操作对象种类：员工            
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,//员工
                oper_object_id = data.sys_res.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,data.sys_res),
                remark = "更新员工信息"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            var userdata = GetSysUserSingle(id);
            data.sys_user.id = id;
            if (userdata.password!=data.sys_user.password)
                data.sys_user.password = new Tools.Cryptographys().MD5Encrypt(data.sys_user.password, false);
            new sys_user_dal().Update(data.sys_user);
            add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = data.sys_user.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = new sys_user_dal().CompareValue(userdata,data.sys_user),
                remark = "更新员工信息"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 通过id获得员工资源信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_resource GetSysResourceSingle(long id) {
           return  _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where id={id} and delete_time=0");
        }
        /// <summary>
        /// 返回员工账户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_user GetSysUserSingle(long id)
        {
            return _dal1.FindSignleBySql<sys_user>($"select * from sys_user where id={id}");
        }
        /// <summary>
        /// 获取所有
        /// </summary>
        /// <returns></returns>
        public List<sys_resource> GetAllSysResource() {
            return _dal.FindListBySql<sys_resource>($"select * from sys_resource where delete_time=0").ToList();
        }
        public void UpdatePermission(sys_resource res, long user_id) {
            res.update_user_id = user_id;
            res.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (_dal.Update(res)) {
                var add_account_log = new sys_oper_log();
                var user = UserInfoBLL.GetUserInfo(user_id);
                add_account_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                    oper_object_id = res.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.AddValue(res),
                    remark = "更新客户信息权限"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_account_log);
            }
        }
    }
}
