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
        public ERROR_CODE Revoke_CHARGES(long user_id, string ids, out string re)
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
                    var oldcad = cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        var ci = new ctt_invoice_dal().FindNoDeleteById((long)cad.invoice_id);
                        if (ci.is_voided != 1)
                        {
                            returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票\n");
                        }
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = cad_dal.CompareValue(oldcad, cad),
                            remark = "删除审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                        if (!cad_dal.Update(cad))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        //合同成本
                        var oldccc = ccc = ccc_dal.FindSignleBySql<ctt_contract_cost>($"select * from ctt_contract_cost where id={cad.object_id} and delete_time=0");
                        if (ccc != null)
                        {
                            ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccc.update_user_id = user.id;
                            ccc.bill_status = 0;
                            ccc.extended_price = ccc.unit_price * ccc.quantity;
                            var add_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,
                                oper_object_id = ccc.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                oper_description = cad_dal.CompareValue(oldccc, ccc),
                                remark = "修改合同成本"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add_log);       // 插入日志
                            if (!ccc_dal.Update(ccc))
                            {
                                return ERROR_CODE.ERROR;
                            }
                            if (cad.contract_block_id != null)
                            {
                                //合同预付
                                var oldccb = ccb = ccb_dal.FindSignleBySql<ctt_contract_block>($" select * from ctt_contract_block where id={cad.contract_block_id} and delete_time=0");
                                if (ccb != null)
                                {
                                    ccb.is_billed = 0;
                                    ccb.status_id = 1;
                                    ccb.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                    ccb.update_user_id = user.id;
                                    var add3_log = new sys_oper_log()
                                    {
                                        user_cate = "用户",
                                        user_id = (int)user.id,
                                        name = user.name,
                                        phone = user.mobile == null ? "" : user.mobile,
                                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,
                                        oper_object_id = ccc.id,// 操作对象id
                                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                        oper_description = cad_dal.CompareValue(oldccb, ccb),
                                        remark = "修改合同预付"
                                    };          // 创建日志
                                    new sys_oper_log_dal().Insert(add3_log);       // 插入日志
                                    if (!ccb_dal.Update(ccb))
                                    {
                                        return ERROR_CODE.ERROR;
                                    }
                                }
                            }
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
            crm_account_deduction cad = new crm_account_deduction();//审批并提交
            ctt_contract_cost ccc = new ctt_contract_cost();//成本
            ctt_contract cc = new ctt_contract();//合同
            ctt_contract_service_period ccsp = new ctt_contract_service_period();//合同服务周期
            ctt_contract_service_adjust ccsa = new ctt_contract_service_adjust();//合同服务调整
            ctt_contract_service_period_dal ccsp_dal = new ctt_contract_service_period_dal();
            ctt_contract_service_adjust_dal ccsa_dal = new ctt_contract_service_adjust_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    var oldcad = cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        var ci = new ctt_invoice_dal().FindNoDeleteById((long)cad.invoice_id);
                        if (ci.is_voided != 1)
                        {
                            returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票\n");
                        }
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = cad_dal.CompareValue(oldcad, cad),
                            remark = "删除审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                        if (!cad_dal.Update(cad))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        //类型为服务
                        if (cad.type_id == (int)ACCOUNT_DEDUCTION_TYPE.SERVICE)
                        {
                            var oldccsp = ccsp = ccsp_dal.FindSignleBySql<ctt_contract_service_period>($"select * from ctt_contract_service_period where contract_id={cad.contract_id} and delete_time=0");
                            ccsp.approve_and_post_date = null;
                            ccsp.approve_and_post_user_id = null;
                            ccsp.period_adjusted_price = ccsp.period_price * ccsp.quantity;
                            ccsp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccsp.update_user_id = user.id;
                            var add2_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD,//
                                oper_object_id = ccsp.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                                oper_description = cad_dal.CompareValue(oldccsp, ccsp),
                                remark = "修改合同服务周期"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                            if (!ccsp_dal.Update(ccsp))
                            {
                                return ERROR_CODE.ERROR;
                            }


                        }
                        //类型为服务调整
                        if (cad.type_id == (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST)
                        {
                            var oldccsa = ccsa = ccsa_dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_id={cad.contract_id} and delete_time=0");
                            cc = new ctt_contract_dal().FindSignleBySql<ctt_contract>($"select * from ctt_contract where id={cad.contract_id} and delete_time=0");
                            ccsa.approve_and_post_date = null;
                            ccsa.approve_and_post_user_id = null;
                            ccsa.adjust_prorated_price_change = (decimal)cc.setup_fee;
                            ccsa.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccsa.update_user_id = user.id;
                            var add2_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST,//
                                oper_object_id = ccsp.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                                oper_description = cad_dal.CompareValue(oldccsa, ccsa),
                                remark = "修改合同服务调整"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                            if (ccsp_dal.Update(ccsp)) { }

                        }
                        //类型为初始费用
                        if (cad.type_id == (int)ACCOUNT_DEDUCTION_TYPE.INITIAL_COST)
                        {
                            var oldcc = cc = new ctt_contract_dal().FindSignleBySql<ctt_contract>($"select * from ctt_contract where id={cad.contract_id} and delete_time=0");
                            cc.adjust_setup_fee = cc.setup_fee;
                            cc.setup_fee_approve_and_post_user_id = null;
                            cc.setup_fee_approve_and_post_date = null;
                            cc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            cc.update_user_id = user.id;
                            var add2_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                                oper_object_id = cad.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                oper_description = cad_dal.CompareValue(oldcc, cc),
                                remark = "修改合同初始费用"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                            if (!new ctt_contract_dal().Update(cc))
                            {
                                return ERROR_CODE.ERROR;
                            }
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
                    var oldcad = cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        var ci = new ctt_invoice_dal().FindNoDeleteById((long)cad.invoice_id);
                        if (ci.is_voided != 1)
                        {
                            returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票\n");
                        }
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = cad_dal.CompareValue(oldcad, cad),
                            remark = "删除审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                        if (!cad_dal.Update(cad))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        else { }


                    }
                    //里程碑
                    if (cad.object_id != null)
                    {
                        var oldccm = ccm = ccm_dal.FindSignleBySql<ctt_contract_milestone>($"select * from ctt_contract_milestone where id={cad.object_id} and delete_time=0");
                        ccm.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
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
                        if (!ccm_dal.Update(ccm))
                        {
                            return ERROR_CODE.ERROR;
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
            crm_subscription cs = new crm_subscription();//订阅表
            crm_subscription_period csp = new crm_subscription_period();//订阅周期表
            crm_subscription_dal cs_dal = new crm_subscription_dal();
            crm_subscription_period_dal csp_dal = new crm_subscription_period_dal();
            if (!string.IsNullOrEmpty(ids))
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    var oldcad = cad = GetAccountDed(long.Parse(id));
                    if (cad.invoice_id != null)
                    {
                        var ci = new ctt_invoice_dal().FindNoDeleteById((long)cad.invoice_id);
                        if (ci.is_voided != 1) {
                            returnvalue.Append(id + "条目已经生成发票（发票ID：" + cad.invoice_id + "），请先作废该发票\n");
                        }                        
                    }
                    else
                    {
                        cad.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad.delete_user_id = user.id;
                        // 插入日志
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                            oper_description = cad_dal.CompareValue(oldcad, cad),
                            remark = "删除审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                        if (!cad_dal.Update(cad))
                        {
                            return ERROR_CODE.ERROR;
                        }
                        else { }

                    }
                    //订阅
                    if (cad.object_id != null)
                    {                       
                        var oldcsp = csp = csp_dal.FindSignleBySql<crm_subscription_period>($"select * from crm_subscription_period where id={cad.object_id}");
                        cs = cs_dal.FindNoDeleteById(csp.subscription_id);
                        csp.approve_and_post_user_id = null;
                        csp.approve_and_post_date = null;
                        csp.period_price = cs.period_price;
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION_PERIOD,//订阅周期
                            oper_object_id = csp.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = cad_dal.CompareValue(oldcsp, csp),
                            remark = "修改订阅周期"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志

                        if (!csp_dal.Update(csp))
                        {
                            return ERROR_CODE.ERROR;
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
        /// 审核并提交
        /// </summary>
        /// <returns></returns>
        public crm_account_deduction GetAccountDed(long id)
        {
            return cad_dal.FindSignleBySql<crm_account_deduction>($"select * from crm_account_deduction where id={id} and delete_time=0");
        }
        /// <summary>
        /// 撤销工时审批
        /// </summary>
        public ERROR_CODE REVOKE_LABOUR(long user_id, string ids, out string re)
        {
            re = "";
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                var cadDal = new crm_account_deduction_dal();
                var sweDal = new sdk_work_entry_dal();
                var ccbDal = new ctt_contract_block_dal();
                StringBuilder returnvalue = new StringBuilder();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                foreach (var accId in idArr)
                {
                    var thisCad = cadDal.FindNoDeleteById(long.Parse(accId));
                    if (thisCad != null)
                    {
                        if(thisCad.invoice_id!=null)
                        {
                            var ci = new ctt_invoice_dal().FindNoDeleteById((long)thisCad.invoice_id);
                            if (ci!=null&&ci.is_voided != 1)
                            {
                                returnvalue.Append(accId + "条目已经生成发票（发票ID：" + thisCad.invoice_id + "），请先作废该发票\n");
                            }
                        }
                        else
                        {
                            #region 删除条目信息
                            // var oldCad = cadDal.FindNoDeleteById(long.Parse(accId));
                            cadDal.SoftDelete(thisCad,user_id);
                            OperLogBLL.OperLogDelete<crm_account_deduction>(thisCad, thisCad.id, user_id, OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION, "删除审批并提交条目");
                            #endregion

                            #region 修改工时表
                            if (thisCad.object_id != null)
                            {
                                var swe = sweDal.FindNoDeleteById((long)thisCad.object_id);
                                if (swe != null)
                                {
                                    var oldSwe = sweDal.FindNoDeleteById((long)thisCad.object_id);
                                    swe.approve_and_post_date = null;
                                    swe.approve_and_post_user_id = null;
                                    swe.hours_billed_deduction = null;
                                    swe.hours_rate_deduction = null;
                                    swe.update_time = timeNow;
                                    swe.update_user_id = user_id;
                                    sweDal.Update(swe);
                                    OperLogBLL.OperLogUpdate<sdk_work_entry>(swe, oldSwe, swe.id, user_id, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "修改工时");
                                }
                            }
                            #endregion

                            #region 修改预付费信息
                            if (thisCad.contract_block_id != null)
                            {
                                var thisCcb = ccbDal.FindNoDeleteById((long)thisCad.contract_block_id);
                                if (thisCcb != null)
                                {
                                    var oldCcb = ccbDal.FindNoDeleteById((long)thisCad.contract_block_id);
                                    thisCcb.is_billed = 0;
                                    thisCcb.status_id = 1;
                                    thisCcb.update_time = timeNow;
                                    thisCcb.update_user_id = user_id;
                                    ccbDal.Update(thisCcb);
                                    OperLogBLL.OperLogUpdate<ctt_contract_block>(thisCcb, oldCcb, thisCcb.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_BLOCK, "修改合同预付");
                                }

                            }
                            #endregion
                        }

                    }
                    else
                    {

                    }

                }

            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 撤销费用审批
        /// </summary>
        public ERROR_CODE REVOKE_EXPENSE(long user_id, string ids, out string re)
        {
            re = "";
            if (!string.IsNullOrEmpty(ids))
            {
                var idArr = ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var cadDal = new crm_account_deduction_dal();
                var seDal = new sdk_expense_dal();
                StringBuilder returnvalue = new StringBuilder();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                foreach (var accId in idArr)
                {
                    var thisCad = cadDal.FindNoDeleteById(long.Parse(accId));
                    if (thisCad != null)
                    {
                        if (thisCad.invoice_id != null)
                        {
                            var ci = new ctt_invoice_dal().FindNoDeleteById((long)thisCad.invoice_id);
                            if (ci != null && ci.is_voided != 1)
                            {
                                returnvalue.Append(accId + "条目已经生成发票（发票ID：" + thisCad.invoice_id + "），请先作废该发票\n");
                            }
                        }
                        else
                        {
                            #region 删除条目信息
                            // var oldCad = cadDal.FindNoDeleteById(long.Parse(accId));
                            cadDal.SoftDelete(thisCad, user_id);
                            OperLogBLL.OperLogDelete<crm_account_deduction>(thisCad, thisCad.id, user_id, OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION, "删除审批并提交条目");
                            #endregion

                            #region 修改费用表
                            if (thisCad.object_id != null)
                            {
                                var se = seDal.FindNoDeleteById((long)thisCad.object_id);
                                if (se != null)
                                {
                                    var oldSe = seDal.FindNoDeleteById((long)thisCad.object_id);
                                    se.approve_and_post_date = null;
                                    se.approve_and_post_user_id = null;
                                    se.amount_deduction = null;
                                    se.update_time = timeNow;
                                    se.update_user_id = user_id;
                                    seDal.Update(se);
                                    OperLogBLL.OperLogUpdate<sdk_expense>(se, oldSe, se.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE, "修改费用");
                                }
                            }
                            #endregion
                        }
                    }
                }
            }
            return ERROR_CODE.SUCCESS;
        }
    }
}
