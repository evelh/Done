﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 字典项相关
    /// </summary>
    public class GeneralBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();
        /// <summary>
        /// 根据tableId获取字典值列表
        /// </summary>
        /// <param name="tableId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetDicValues(GeneralTableEnum tableId)
        {
            var table = new d_general_table_dal().GetById((int)tableId);
            return new d_general_dal().GetDictionary(table);
        }

        /// <summary>
        /// 根据字典项的table name和字典项name获取字典项id
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="generalName"></param>
        /// <returns></returns>
        public long GetGeneralId(string tableName, string generalName)
        {
            var tableDal = new d_general_table_dal();
            var generalDal = new d_general_dal();
            var table = tableDal.GetSingle(tableDal.QueryStringDeleteFlag($"SELECT * FROM d_general_table WHERE name='{tableName}'")) as d_general_table;
            if (table == null)
                return 0;
            var general = generalDal.GetSingle(generalDal.QueryStringDeleteFlag($"SELECT * FROM d_general WHERE general_table_id={table.id} AND name='{generalName}'")) as d_general;
            if (general == null)
                return 0;
            return general.id;
        }
        /// <summary>
        /// 通过id获取一个d_general对象，并返回
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_general GetSingleGeneral(long id) {
            return _dal.FindById(id);
        }
        /// <summary>
        /// 通过name和general_table_id获取一个d_general对象，并返回
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public d_general GetSingleGeneral(string name,int general_table_id) {
            return _dal.FindSignleBySql<d_general>($"select * from d_general where name='{name}' and general_table_id={general_table_id} and delete_time=0");
        }
        /// <summary>
        /// 通过table_id返回，所有字典项
        /// </summary>
        /// <param name="general_table_id"></param>
        /// <returns></returns>
        public List<d_general> GetGeneralList(int general_table_id) {
            return _dal.FindListBySql<d_general>($"select * from d_general where general_table_id={general_table_id} and delete_time=0 ORDER BY id,sort_order,`code`").ToList();
        }
        /// <summary>
        /// 通过id获取d_general_table的名称
        /// </summary>
        /// <param name="general_table_id"></param>
        /// <returns></returns>
        public string GetGeneralTableName(int general_table_id) {
            return new d_general_table_dal().FindById(general_table_id).name;
        }
        /// <summary>
        /// 通过id获取字典项的名称
        /// </summary>
        /// <param name="parent_id"></param>
        /// <returns></returns>
        public string GetGeneralParentName(int parent_id)
        {
            return _dal.FindSignleBySql<d_general>($"select * from d_general where id={parent_id} and delete_time=0 ").name;
        }
        /// <summary>
        /// 日历显示模式
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetCalendarField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("View", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.CALENDAR_DISPLAY)));         
            return dic;
        }
        /// <summary>
        /// 向d_general表插入一条数据
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(d_general data, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = user_id;
            var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res != null)
            {
                return ERROR_CODE.EXIST;
            }
            _dal.Insert(data);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data),
                remark = "新增d_general表，general_table_id="+data.general_table_id
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新一条数据
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(d_general data, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res != null && res.id != data.id)
            {
                return ERROR_CODE.EXIST;
            }
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
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
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(data),
                remark = "修改d_general表，general_table_id=" + data.general_table_id
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除字典项之前进行校验
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <param name="table_id"></param>
        /// <param name="n"></param>
        /// <returns></returns>
        public ERROR_CODE Delete_Validate(long id, long user_id, long table_id,out int n) {
            var user = UserInfoBLL.GetUserInfo(user_id);
            n = 0;
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
            //市场领域删除
            if (table_id == (int)GeneralTableEnum.MARKET_SEGMENT)
            {
                var mar = new crm_account_dal().FindListBySql($"select * from crm_account where market_segment_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.MARKET_USED;//
                }
            }
            //客户地域删除
            if (table_id == (int)GeneralTableEnum.TERRITORY)
            {
                var mar = new crm_account_dal().FindListBySql($"select * from crm_account where territory_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.TERRITORY_USED;//
                }
            }
            //竞争对手删除
            if (table_id == (int)GeneralTableEnum.COMPETITOR)
            {
                var mar = new crm_account_dal().FindListBySql($"select * from crm_account where competitor_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.COMPETITOR_USED;//
                }
            }
            //商机来源
            if (table_id == (int)GeneralTableEnum.OPPORTUNITY_SOURCE)
            {
                var mar = new crm_opportunity_dal().FindListBySql($"select * from crm_opportunity where source_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.OPPORTUNITY_SOURCE_USED;//
                }
            }
            //活动类型
            if (table_id == (int)GeneralTableEnum.ACTION_TYPE)
            {
                var mar = new com_activity_dal().FindListBySql($"select * from com_activity where action_type_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.ACTION_TYPE_USED;//
                }
            }
            //商机阶段
            if (table_id == (int)GeneralTableEnum.OPPORTUNITY_STAGE)
            {
                var mar = new crm_opportunity_dal().FindListBySql($"select * from com_activity where stage_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.OPPORTUNITY_STAGE_USED;//
                }
            }
            //关闭商机的原因
            if (table_id == (int)GeneralTableEnum.OPPORTUNITY_WIN_REASON_TYPE) {

                var mar = new crm_opportunity_dal().FindListBySql($"select * from crm_opportunity where win_reason_type_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.WIN_OPPORTUNITY_REASON_USED;//
                }
            }
            //丢失商机的原因
            if (table_id == (int)GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE) {
                var mar = new crm_opportunity_dal().FindListBySql($"select * from crm_opportunity where loss_reason_type_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.LOSS_OPPORTUNITY_REASON_USED;//
                }
            }
            //合同类别
            if (table_id == (int)GeneralTableEnum.CONTRACT_CATE)
            {
                var mar = new ctt_contract_dal().FindListBySql($"select * from ctt_contract where cate_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    n = mar.Count;
                    return ERROR_CODE.CONTRACT_TYPE_USED;//
                }
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除一个
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(long id, long user_id,long table_id)
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
            string remark="删除通用代码信息";
            //市场
            if (table_id == (int)GeneralTableEnum.MARKET_SEGMENT)
            {
                crm_account_dal a_dal = new crm_account_dal();
                var mar = a_dal.FindListBySql($"select * from crm_account where market_segment_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    foreach (var account in mar) {
                        account.market_segment_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account)) {
                            return ERROR_CODE.ERROR;
                        }
                        remark = "删除市场信息";
                    }
                }
            }
            //地域
            if (table_id == (int)GeneralTableEnum.TERRITORY)
            {
                crm_account_dal a_dal = new crm_account_dal();
                var mar = a_dal.FindListBySql($"select * from crm_account where territory_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    foreach (var account in mar)
                    {
                        account.territory_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        remark = "删除地域信息";
                    }
                }
            }
            //竞争对手
            if (table_id == (int)GeneralTableEnum.COMPETITOR)
            {
                crm_account_dal a_dal = new crm_account_dal();
                var mar = a_dal.FindListBySql($"select * from crm_account where competitor_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    foreach (var account in mar)
                    {
                        account.competitor_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        remark = "删除竞争对手信息";
                    }
                }
            }
            //商机来源
            if (table_id == (int)GeneralTableEnum.OPPORTUNITY_SOURCE)
            {
                crm_opportunity_dal a_dal = new crm_opportunity_dal();
                var mar = a_dal.FindListBySql($"select * from crm_opportunity where source_id={id} and delete_time=0");
                if (mar.Count > 0)
                {
                    foreach (var opp in mar)
                    {
                        opp.source_id = null;
                        opp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        opp.update_user_id = user.id;
                        if (!a_dal.Update(opp))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        remark = "删除商机来源信息";
                    }
                }
            }

            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            if (!_dal.Update(data))
            {              
                return ERROR_CODE.ERROR;
            }
            //更新日志
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//员工
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                oper_description = _dal.AddValue(data),
                remark = remark
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志
            return ERROR_CODE.SUCCESS;
        }


        /// <summary>
        /// 激活
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Active(long id, long user_id)
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
            if (data.is_active > 0)
            {
                return ERROR_CODE.ACTIVATION;
            }
            data.is_active = 1;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 失活
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
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_active==0)
            {
                return ERROR_CODE.NO_ACTIVATION;
            }
            data.is_active = 0;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
    }
}
