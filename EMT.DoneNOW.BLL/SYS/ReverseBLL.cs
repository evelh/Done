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
    /// <summary>
    /// 系统管理--合同与撤销审批
    /// </summary>
    /// 
    public class ReverseBLL
    {
        private readonly crm_account_deduction_dal cad_dal = new crm_account_deduction_dal();
        /// <summary>
        /// /撤销成本审批
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public ERROR_CODE Revoke_Expense(long user_id, string ids,out string re)
        {
            re = string.Empty;
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            crm_account_deduction cad = new crm_account_deduction();
            ctt_contract_block ccb = new ctt_contract_block();
            ctt_contract_cost ccc = new ctt_contract_cost();
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();
            StringBuilder returnvalue = new StringBuilder();
            //该条目已经生成发票（发票ID：发票ID），请先作废该发票
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                   cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票");
                    }
                    else {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        if (cad_dal.Update(cad))
                        {
                             // 插入日志


                            //合同成本
                           var oldccc= ccc = ccc_dal.FindSignleBySql<ctt_contract_cost>($"select * from ctt_contract_cost where id={cad.object_id} and delete_time=0");
                            if(ccc!=null){
                                ccc.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                ccc.update_user_id = user.id;
                                ccc.bill_status = 1;
                                ccc.extended_price = ccc.unit_price * ccc.quantity;
                                var add_log = new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = (int)user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,
                                    oper_object_id = cad.id,// 操作对象id
                                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                    oper_description = cad_dal.CompareValue(oldccc,ccc),
                                    remark = "修改合同成本"
                                };          // 创建日志
                            new sys_oper_log_dal().Insert(add_log);       // 插入日志
                            if (ccc_dal.Update(ccc))
                                {

                                }
                                else {

                                }
                                if (ccc.contract_block_id != null)
                                {
                                    //合同预付
                                    ccb = ccb_dal.FindSignleBySql<ctt_contract_block>($" select * from ctt_contract_block where id={ccc.contract_block_id} and delete_time=0");
                                    if (ccb != null)
                                    {
                                        ccb.status_id = 1;
                                        ccb.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                        ccb.update_user_id = user.id;

                                        if (ccb_dal.Update(ccb))
                                        {

                                        }
                                        else {

                                        }
                                    }
                                }

                            }
                        }
                        else {

                        }

                    }
                }
            }
            if (!string.IsNullOrEmpty(returnvalue.ToString())) {
                re = returnvalue.ToString();
                return ERROR_CODE.EXIST;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 撤销定期服务审批
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public ERROR_CODE Revoke_Recurring_Services(long user_id, string ids, out string re)
        {
            re = string.Empty;
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            StringBuilder returnvalue = new StringBuilder();
            crm_account_deduction cad = new crm_account_deduction();
            ctt_contract_cost ccc = new ctt_contract_cost();
            ctt_contract cc = new ctt_contract();
            ctt_contract_service_period ccsp = new ctt_contract_service_period();
            ctt_contract_service_adjust ccsa = new ctt_contract_service_adjust();

            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票");
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        if (cad_dal.Update(cad))
                        {
                           
                        }
                    }
                }
            }
            if (!string.IsNullOrEmpty(returnvalue.ToString()))
            {
                re = returnvalue.ToString();
                return ERROR_CODE.EXIST;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 撤销里程碑审批
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public ERROR_CODE Revoke_Milestones(long user_id, string ids, out string re)
        {
            re = string.Empty;
            StringBuilder returnvalue = new StringBuilder();
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            crm_account_deduction cad = new crm_account_deduction();
            ctt_contract_milestone ccm = new ctt_contract_milestone();
            ctt_contract_milestone_dal ccm_dal = new ctt_contract_milestone_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票");
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        if (cad_dal.Update(cad))
                        {
                        }
                        else { }


                    }
                    //里程碑
                    if (cad.object_id != null) {
                       var oldccm= ccm = ccm_dal.FindSignleBySql<ctt_contract_milestone>($"select * from ctt_contract_milestone where id={cad.object_id} and delete_time=0");
                        ccm.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        ccm.update_user_id = user.id;
                        ccm.status_id = (int)MILESTONE_STATUS.READY_TO_BILL;
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE,
                            oper_object_id = ccm.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = cad_dal.CompareValue(oldccm, ccm),
                            remark = "修改合同里程碑"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                    }
                }
            }
            if (!string.IsNullOrEmpty(returnvalue.ToString()))
            {
                re = returnvalue.ToString();
                return ERROR_CODE.EXIST;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 撤销订阅审批
        /// </summary>
        /// <param name="user_id"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public ERROR_CODE Revoke_Subscriptions(long user_id, string ids, out string re)
        {
            re = string.Empty;
            StringBuilder returnvalue = new StringBuilder();
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            crm_account_deduction cad = new crm_account_deduction();
            crm_subscription cs = new crm_subscription();
            crm_subscription_dal cs_dal = new crm_subscription_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票");
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        if (cad_dal.Update(cad))
                        {
                        }
                        else { }

                    }
                    //订阅
                    if (cad.object_id != null)
                    {
                        var oldcs = cs = cs_dal.FindSignleBySql<crm_subscription>($"select * from crm_subscription where id={cad.object_id} and delete_time=0");







                    }
                }
            }
            if (!string.IsNullOrEmpty(returnvalue.ToString()))
            {
                re = returnvalue.ToString();
                return ERROR_CODE.EXIST;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 审核并提交
        /// </summary>
        /// <returns></returns>
        public crm_account_deduction GetAccountDed(long id) {
            return cad_dal.FindSignleBySql<crm_account_deduction>($"select * from crm_account_deduction where id={id} and delete_time=0");
        }
    }
}
