using System;
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
        /// 根据tableId获取字典值列表
        /// </summary>
        /// <param name="tableId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetDicValues(long tableId)
        {
            var table = new d_general_table_dal().GetById((int)tableId);
            return new d_general_dal().GetDictionary(table);
        }

        /// <summary>
        /// 根据tableId和parent_id获取字典值列表
        /// </summary>
        /// <param name="tableId"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetDicValues(GeneralTableEnum tableId, long parentId)
        {
            return new d_general_dal().FindListBySql<DictionaryEntryDto>($"SELECT id as val,`name` as `show` FROM d_general WHERE general_table_id={(long)tableId} AND parent_id={parentId} AND delete_time=0 AND is_active=1");
        }
        /// <summary>
        /// 根据TableId 获取相关信息
        /// </summary>
        public List<d_general> GetGeneralByTable(long tableId)
        {
            return _dal.GetGeneralByTableId(tableId);
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
        public d_general GetSingleGeneral(long id,bool checkDelete = false) {
            if (checkDelete)
                return _dal.FindNoDeleteById(id);
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
        public string GetGeneralName(int id)
        {
            return _dal.FindSignleBySql<d_general>($"select * from d_general where id={id} and delete_time=0 ").name;
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
            var res = GetSingleGeneral(data.name, data.general_table_id);
            if (res != null)
            {
                return ERROR_CODE.EXIST;
            }
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = data.update_user_id= user_id;
            _dal.Insert(data);
            data = GetSingleGeneral(data.name, data.general_table_id);
            if (data == null) {
                return ERROR_CODE.ERROR;
            }
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
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
            var old = GetSingleGeneral(data.id);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old,data),
                remark = "修改d_general表，general_table_id=" + data.general_table_id
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }            
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
                var mar = new crm_opportunity_dal().FindListBySql($"select * from crm_opportunity where stage_id={id} and delete_time=0");
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
            //里程碑
            if (table_id == (int)GeneralTableEnum.CONTRACT_MILESTONE) {
                var mile = new ctt_contract_milestone_dal().FindListBySql<ctt_contract_milestone>($"select * from ctt_contract_milestone where status_id={id} and delete_time=0");
                if (mile.Count > 0) {
                    n = mile.Count;
                    return ERROR_CODE.CONTRACT_MILESTONE_USED;
                }
            }
            //区域
            if (table_id == (int)GeneralTableEnum.REGION)
            {
                var re = new crm_account_dal().FindListBySql<crm_account>($"select a.* from crm_account a,d_general b where a.territory_id=b.id and b.parent_id={id} and a.delete_time=0");
                if (re.Count > 0)
                {
                    n = re.Count;
                    return ERROR_CODE.REGION_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TASK_SOURCE_TYPES)
            {
                var ticketList = _dal.FindListBySql<sdk_task>("SELECT id from sdk_task where delete_time =0 and type_id = 1809 and source_type_id ="+id.ToString());
                if(ticketList!=null&& ticketList.Count > 0)
                {
                    n = ticketList.Count;
                    return ERROR_CODE.TICKET_SOURCE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TICKET_STATUS)
            {
                var ticketList = _dal.FindListBySql<sdk_task>("SELECT id from sdk_task where delete_time =0 and status_id =" + id.ToString());
                if (ticketList != null && ticketList.Count > 0)
                {
                    n = ticketList.Count;
                    return ERROR_CODE.TICKET_STATUS_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TASK_PRIORITY_TYPE)
            {
                var ticketList = _dal.FindListBySql<sdk_task>("SELECT id from sdk_task where delete_time =0 and type_id = 1809 and priority_type_id =" + id.ToString());
                if (ticketList != null && ticketList.Count > 0)
                {
                    n = ticketList.Count;
                    return ERROR_CODE.TICKET_PRIORITY_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TASK_ISSUE_TYPE)
            {
                var subIss = _dal.GetGeneralByParentId(id);
                if(subIss!=null&& subIss.Count > 0)
                {
                    return ERROR_CODE.TICKET_ISSUE_HAS_SUB;
                }
                var ticketList = _dal.FindListBySql<sdk_task>("SELECT id from sdk_task where delete_time =0 and type_id = 1809 and issue_type_id =" + id.ToString());
                if (ticketList != null && ticketList.Count > 0)
                {
                    n = ticketList.Count;
                    return ERROR_CODE.TICKET_ISSUE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.PROJECT_STATUS)
            {
                var proList = _dal.FindListBySql<pro_project>($"SELECT * from pro_project where delete_time = 0 and status_id ="+id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.TICKET_ISSUE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TASK_TYPE)
            {
                var proList = _dal.FindListBySql<pro_project>($"SELECT * from pro_project where delete_time = 0 and status_id =" + id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.TICKET_ISSUE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.GENERAL_LEDGER)
            {
                var proList = _dal.FindListBySql<d_cost_code>($"SELECT * from d_cost_code where delete_time = 0 and general_ledger_id =" + id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.LEDGER_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.PAYMENT_TERM)
            {
                var proList = _dal.FindListBySql<crm_quote>($"SELECT * from crm_quote where delete_time = 0 and payment_term_id =" + id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.PAY_TERM_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.PAYMENT_TYPE)
            {
                var proList = _dal.FindListBySql<crm_quote>($"SELECT * from crm_quote where delete_time = 0 and payment_type_id =" + id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.PAY_TYPE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.PAYMENT_SHIP_TYPE)
            {
                var proList = _dal.FindListBySql<crm_quote>($"SELECT * from crm_quote where delete_time = 0 and shipping_type_id =" + id.ToString());
                if (proList != null && proList.Count > 0)
                {
                    n = proList.Count;
                    return ERROR_CODE.SHIP_TYPE_USED;
                }
            }
            else if (table_id == (int)GeneralTableEnum.TAX_REGION)
            {
                if(!CheckTaxRegionDelete(id))
                    return ERROR_CODE.TAX_REGION_USED;
            }
            else if (table_id == (int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)
            {
                if (!CheckTaxCateDelete(id))
                    return ERROR_CODE.TAX_CATE_USED;
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
                        var old = account;
                        account.market_segment_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account)) {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = account.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = a_dal.CompareValue(old,account),
                            remark = remark
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
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
                        var old = account;
                        account.territory_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = account.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = a_dal.CompareValue(old, account),
                            remark = remark
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
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
                        var old = account;
                        account.competitor_id = null;
                        account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        account.update_user_id = user.id;
                        if (!a_dal.Update(account))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = account.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = a_dal.CompareValue(old, account),
                            remark = remark
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
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
                        var old = opp;
                        opp.source_id = null;
                        opp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        opp.update_user_id = user.id;
                        if (!a_dal.Update(opp))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                            oper_object_id = opp.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = a_dal.CompareValue(old, opp),
                            remark = remark
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                        remark = "删除商机来源信息";
                    }
                }
            }
            //区域
            if (table_id == (int)GeneralTableEnum.REGION)
            {
                crm_account_dal crm_dal = new crm_account_dal();
                var re = crm_dal.FindListBySql<crm_account>($"select a.* from crm_account a,d_general b where a.territory_id=b.id and b.parent_id={id} and a.delete_time=0");
                if (re.Count > 0)
                {
                    foreach (var i in re) {
                        var old = i;
                        i.territory_id = null;
                        i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        i.update_user_id = user.id;
                        if (!crm_dal.Update(i))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                            oper_object_id = i.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = crm_dal.CompareValue(old, i),
                            remark = remark
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                        remark = "删除区域信息";
                    }
                    
                }
            }
            if(table_id == (int)GeneralTableEnum.TASK_LIBRARY_CATE)
            {
                var taskLibList = _dal.FindListBySql<sdk_task_library>($"SELECT * from sdk_task_library where delete_time = 0 and cate_id = "+id.ToString());
                if (taskLibList != null && taskLibList.Count > 0)
                {
                    sdk_task_library_dal stlDal = new sdk_task_library_dal();
                    taskLibList.ForEach(_ => {
                        _.cate_id = null;
                        _.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        _.update_user_id = user_id;
                        stlDal.Update(_);
                    });
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
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,
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
        /// <summary>
        /// 新增时判断排序
        /// </summary>
        /// <param name="table_id"></param>
        /// <param name="sort_order"></param>
        /// <returns></returns>
        public bool sort_order(int table_id,decimal sort_order) {
            var kk = _dal.FindSignleBySql<d_general>($"select * from d_general where general_table_id={table_id} and sort_order={sort_order} and delete_time=0 ");
            if (kk != null) {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 修改是判断排序
        /// </summary>
        /// <param name="table_id"></param>
        /// <param name="sort_order"></param>
        /// <returns></returns>
        public bool update_sort_order(int id,int table_id, decimal sort_order)
        {
            var kk = _dal.FindSignleBySql<d_general>($"select * from d_general where general_table_id={table_id} and sort_order={sort_order} and delete_time=0 ");
            if (kk != null&&kk.id!=id)
            {
                return false;
            }
            return true;
        }
       /// <summary>
       /// 判断是否是默认关闭商机的原因
       /// </summary>
       /// <param name="id"></param>
       /// <returns></returns>
        public bool defulatwonreson(long id=0) {

            var kk = _dal.FindSignleBySql<d_general>($"select * from d_general where general_table_id=11 and ext2=1 and delete_time=0");
            if (kk != null) {
                if (kk.id != id||id==0) {
                    return true;
                }                
            }
            return false;
        }
        /// <summary>
        /// 判断是否为默认丢失商机的原因
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool defulatlossreson(long id=0)
        {
            var kk = _dal.FindSignleBySql<d_general>($"select * from d_general where general_table_id=11 and ext1=1 and delete_time=0");
            if (kk != null)
            {
                if (kk.id != id || id == 0)
                {
                    return true;
                }
            }
            return false;
        }
        /// <summary>
        /// 获取配送类型的物料代码table=1161
        /// </summary>
        /// <returns></returns>
        public Dictionary<long, string> GetCodeList() {
          return new d_cost_code_dal().FindListBySql<d_cost_code>($"select * from d_cost_code where cate_id={(int)COST_CODE_CATE.MATERIAL_COST_CODE} and delete_time=0").ToDictionary(_ => _.id, _ =>_.name);
        }
        /// <summary>
        /// 新增字典表（不做任何校验）
        /// </summary>
        public bool AddGeneral(d_general data,long userId)
        {
            if (data == null)
                return false;
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            // data.id = (int)_dal.GetNextIdCom();
            data.create_time = timeNow;
            data.update_time = timeNow;
            data.create_user_id = userId;
            data.update_user_id = userId;
            _dal.Insert(data);
            OperLogBLL.OperLogAdd<d_general>(data, data.id, userId, OPER_LOG_OBJ_CATE.General_Code, "新增字典项");
            return true;
        }
        /// <summary>
        /// 编辑字典表（不做任何校验）
        /// </summary>
        public bool EditGeneral(d_general data,long userId)
        {
            if (data == null)
                return false;
            var oldData = _dal.FindNoDeleteById(data.id);
            if (oldData == null)
                return false;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = userId;
            _dal.Update(data);
            OperLogBLL.OperLogUpdate<d_general>(data, oldData, data.id, userId, OPER_LOG_OBJ_CATE.General_Code, "编辑字典项");
            return true;
        }
        /// <summary>
        /// 删除员工技能字典表，同时删除resource_skill
        /// </summary>
        public bool DeleteResourceGeneral(long id,long userId)
        {
            var thisGeneral = _dal.FindNoDeleteById(id);
            if (thisGeneral == null)
                return true;
            sys_resource_skill_dal srsDal = new sys_resource_skill_dal();
            List<sys_resource_skill> skillList=null;
            List<d_general> generalList=null;
            if (thisGeneral.general_table_id == (int)GeneralTableEnum.RESOURCE_SKILL_TYPE)
                skillList = srsDal.GetSkillBType(id);
            else if (thisGeneral.general_table_id == (int)GeneralTableEnum.SKILLS_CATE)
            {
                skillList = srsDal.GetSkillByClass(id);
                generalList = _dal.GetGeneralByParentId(id);
            }
            if (generalList != null && generalList.Count > 0)
                generalList.ForEach(_ => {
                    DeleteResourceGeneral(_.id,userId);
                });
            if (skillList != null && skillList.Count > 0)
                skillList.ForEach(_ => {
                    srsDal.Delete(_);
                    OperLogBLL.OperLogAdd<sys_resource_skill>(_,_.id,userId,OPER_LOG_OBJ_CATE.RESOURCE,"");
                });
            _dal.SoftDelete(thisGeneral,userId);
            OperLogBLL.OperLogAdd<d_general>(thisGeneral, thisGeneral.id, userId, OPER_LOG_OBJ_CATE.General_Code, "");

            return true;

        }

        #region 节假日设置
        /// <summary>
        /// 新增节假日
        /// </summary>
        /// <param name="name"></param>
        /// <param name="desc"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddHolidaySet(string name, string desc, long userId)
        {
            d_general holiday = new d_general();
            holiday.id = (int)_dal.GetNextIdCom();
            holiday.name = name;
            holiday.remark = desc;
            holiday.is_active = 1;
            holiday.is_system = 0;
            holiday.general_table_id = (int)GeneralTableEnum.HOLIDAY_SET;
            holiday.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            holiday.update_time = holiday.create_time;
            holiday.create_user_id = userId;
            holiday.update_user_id = userId;
            _dal.Insert(holiday);
            OperLogBLL.OperLogAdd<d_general>(holiday, holiday.id, userId, OPER_LOG_OBJ_CATE.General_Code, "新增节假日");

            return true;
        }

        /// <summary>
        /// 编辑节假日
        /// </summary>
        /// <param name="id"></param>
        /// <param name="name"></param>
        /// <param name="desc"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditHolidaySet(long id, string name, string desc, long userId)
        {
            d_general holiday = _dal.FindById(id);
            d_general holidayOld = _dal.FindById(id);
            holiday.name = name;
            holiday.remark = desc;
            var dsc = OperLogBLL.CompareValue<d_general>(holidayOld, holiday);
            if (!string.IsNullOrEmpty(dsc))
            {
                holiday.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                holiday.update_user_id = userId;
                _dal.Update(holiday);
                OperLogBLL.OperLogUpdate(dsc, holiday.id, userId, OPER_LOG_OBJ_CATE.General_Code, "编辑节假日");
            }
            return true;
        }

        /// <summary>
        /// 删除节假日
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteHolidaySet(long id, long userId)
        {
            var holidayCnt = _dal.FindSignleBySql<int>($"select count(0) from d_holiday where holiday_set_id={id}");
            if (holidayCnt > 0)
                return false;

            var holiday = _dal.FindById(id);
            holiday.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            holiday.delete_user_id = userId;
            _dal.Update(holiday);
            OperLogBLL.OperLogDelete<d_general>(holiday, holiday.id, userId, OPER_LOG_OBJ_CATE.General_Code, "删除节假日");

            return true;
        }

        /// <summary>
        /// 获取节假日详情
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_holiday GetHoliday(long id)
        {
            return new d_holiday_dal().FindById(id);
        }

        /// <summary>
        /// 新增节假日详情
        /// </summary>
        /// <param name="holiday"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddHoliday(d_holiday holiday, long userId)
        {
            var dal = new d_holiday_dal();
            var find = dal.FindSignleBySql<int>($"select count(0) from d_holiday where holiday_set_id={holiday.holiday_set_id} and hd='{holiday.hd}'");
            if (find > 0)
                return false;

            dal.Insert(holiday);
            OperLogBLL.OperLogAdd<d_holiday>(holiday, 0, userId, OPER_LOG_OBJ_CATE.HOLIDAY, "新增假期日");
            return true;
        }

        /// <summary>
        /// 编辑节假日详情
        /// </summary>
        /// <param name="id"></param>
        /// <param name="name"></param>
        /// <param name="date"></param>
        /// <param name="type"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditHoliday(long id, string name, DateTime date, int type, long userId)
        {
            var dal = new d_holiday_dal();
            var holiday = dal.FindById(id);
            var find = dal.FindSignleBySql<int>($"select count(0) from d_holiday where id<>{id} holiday_set_id={holiday.holiday_set_id} and hd='{holiday.hd}'");
            if (find > 0)
                return false;

            var holidayOld = dal.FindById(id);
            holiday.description = name;
            holiday.hd = date;
            holiday.hd_type = type;
            var desc = OperLogBLL.CompareValue<d_holiday>(holidayOld, holiday);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(holiday);
                OperLogBLL.OperLogUpdate(desc, holiday.id, userId, OPER_LOG_OBJ_CATE.HOLIDAY, "编辑假期日");
            }

            return true;
        }

        /// <summary>
        /// 删除节假日详情
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteHoliday(long id, long userId)
        {
            var dal = new d_holiday_dal();
            var holiday = dal.FindById(id);
            if (holiday == null)
                return false;

            dal.Delete(holiday);
            OperLogBLL.OperLogDelete<d_holiday>(holiday, holiday.id, userId, OPER_LOG_OBJ_CATE.HOLIDAY, "删除假期日");

            return true;
        }
        #endregion
        /// <summary>
        /// 删除工单问题
        /// </summary>
        public bool DeleteGeneralSubIssue(string ids, long userId, ref string failReason)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                string[] idArr = ids.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                foreach (var thisId in idArr)
                {
                    var thisGeneral = _dal.FindNoDeleteById(long.Parse(thisId));
                    if (thisGeneral == null)
                        continue;
                    var ticketList = _dal.FindListBySql<sdk_task>("SELECT id from sdk_task where delete_time =0 and type_id = 1809 and sub_issue_type_id =" + thisId);
                    if (ticketList != null && ticketList.Count > 0)
                        failReason += thisGeneral.name + ',';
                    else
                    {
                        _dal.SoftDelete(thisGeneral,userId);
                        OperLogBLL.OperLogDelete<d_general>(thisGeneral, thisGeneral.id,userId,OPER_LOG_OBJ_CATE.General_Code,"");
                    }
                }
                if (!string.IsNullOrEmpty(failReason))
                {
                    failReason = failReason.Substring(0, failReason.Length-1);
                    failReason += "等被工单引用，不能删除";
                }
            }

            return true;
        }
        /// <summary>
        /// 校验税区是否可以删除
        /// </summary>
        public bool CheckTaxRegionDelete(long id)
        {
            var thisGen = GetSingleGeneral(id,true);
            if (thisGen == null||thisGen.is_system==1)
                return true;
            if (thisGen.general_table_id != (int)GeneralTableEnum.TAX_REGION)
                return false;
            var accList = _dal.FindListBySql<crm_account>("select id from crm_account where delete_time = 0 and tax_region_id = "+ id.ToString());
            if (accList != null && accList.Count > 0)
                return false;
            return true;
        }
        /// <summary>
        /// 校验税种是否可以删除
        /// </summary>
        public bool CheckTaxCateDelete(long id)
        {
            var thisGen = GetSingleGeneral(id, true);
            if (thisGen == null || thisGen.is_system == 1)
                return true;
            if (thisGen.general_table_id != (int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)
                return false;
            var codeList = new CostCodeBLL().GetCodeByTaxCate(id);
            if (codeList != null && codeList.Count > 0)
                return false;
            var roleList = _dal.FindListBySql<sys_role>("select id from sys_role where delete_time = 0 and tax_cate_id="+id.ToString());   //
            if (roleList != null && roleList.Count > 0)
                return false;
            return true;
        }
        /// <summary>
        /// 将当前税区设置成默认税区，
        /// </summary>
        public void SetDefaultRegion(long id,long userId)
        {
            var thisRegion = GetSingleGeneral(id,true);
            if (thisRegion == null || thisRegion.general_table_id != (int)GeneralTableEnum.TAX_REGION)
                return;
            if (thisRegion.ext1 != "1")
            {
                thisRegion.ext1 = "1";
                EditGeneral(thisRegion,userId);
            }

            List<d_general> defRegionList = _dal.FindListBySql($"SELECT * from d_general where general_table_id = { (int)GeneralTableEnum.TAX_REGION} and delete_time = 0 and ext1='1'");
            if (defRegionList != null && defRegionList.Count > 0)
                defRegionList.ForEach(_ => {
                    _.ext1 = "0";
                    EditGeneral(_, userId);
                });
        }
    }
}
