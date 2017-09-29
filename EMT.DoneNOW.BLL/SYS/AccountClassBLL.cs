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
    public class AccountClassBLL
    {
        private readonly d_account_classification_dal _dal = new d_account_classification_dal();
        /// <summary>
        /// 通过客户类别id获取一个类别对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_account_classification GetSingel(long id) {
            return _dal.FindSignleBySql<d_account_classification>($"select * from d_account_classification where id={id} and delete_time=0");
        }
        /// <summary>
        /// 插入
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(d_account_classification data, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var cla = _dal.FindSignleBySql<d_account_classification>($"select * from d_account_classification where name='{data.name}' and delete_time=0");
            if (cla != null) {
                return ERROR_CODE.EXIST;
            }
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = user_id;
            _dal.Insert(data);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNTCLASS,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data),
                remark = "新增客户类别信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新修改
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(d_account_classification data, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var cla = _dal.FindSignleBySql<d_account_classification>($"select * from d_account_classification where name='{data.name}' and delete_time=0");
            if (cla != null&&cla.id!=data.id)
            {
                return ERROR_CODE.EXIST;
            }
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data)) {
                return ERROR_CODE.ERROR;
            }
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNTCLASS,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(data),
                remark = "修改客户类别信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 通过id删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_system > 0) {
                return ERROR_CODE.SYSTEM;
            }
            var mar = new crm_account_dal().FindListBySql($"select * from crm_account where classification_id={id} and delete_time=0");
            if (mar.Count > 0)
            {
                foreach (var acc in mar) {
                    acc.classification_id = null;
                    acc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    acc.update_user_id = user_id;
                    if (!new crm_account_dal().Update(acc)) {
                        return ERROR_CODE.ERROR;
                    }
                }
            }
            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNTCLASS,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(data),
                remark = "删除客户类别信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除前校验
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete_Validate(long id, long user_id,out int n)
        {
            n = 0;
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_system > 0)
            {
                return ERROR_CODE.SYSTEM;
            }
            var mar = new crm_account_dal().FindListBySql($"select * from crm_account where classification_id={id} and delete_time=0");
            if (mar.Count>0) {
                n = mar.Count;
                return ERROR_CODE.ACCOUNT_TYPE_USED;
            }
            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 激活
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Active(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = GetSingel(id);
            if (data == null) {
                return ERROR_CODE.ERROR;
            }
            if (Convert.ToInt32(data.status_id) == 1) {
                return ERROR_CODE.ACTIVATION;
            }
            data.status_id = 1;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 设置为失活状态
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE NoActive(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = GetSingel(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (Convert.ToInt32(data.status_id) == 0)
            {
                return ERROR_CODE.NO_ACTIVATION;
            }
            data.status_id = 0;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        public List<d_account_classification> GetAll() {
            return _dal.FindListBySql<d_account_classification>($"select * from d_account_classification where delete_time=0 order by id,sort_order").ToList();
        }
    }
}
