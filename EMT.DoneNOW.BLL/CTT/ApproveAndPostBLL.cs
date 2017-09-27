using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 审批并提交
    /// </summary>
    public class ApproveAndPostBLL
    {
        private readonly crm_account_deduction_dal cad_dal = new crm_account_deduction_dal();//审批并提交处理
        private readonly ctt_contract_dal cc_dal = new ctt_contract_dal();//合同处理
        private crm_account_deduction cad = new crm_account_deduction();//审批提交
        /// <summary>
        ///单条审批
        /// </summary>
        /// <param name="id">里程碑id</param>
        /// <param name="date">提交日期</param>
        /// <param name="type">审批类型</param>
        /// <returns></returns>
        public ERROR_CODE Post(int id, int date, long type, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }

            //成本
            if (type == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES)
            {
                var result = Post_Charges(id, date, user);
                if (result == ERROR_CODE.SUCCESS)
                {
                    return ERROR_CODE.SUCCESS;
                }
                else
                {

                }

            }

            //审批里程碑
            if (type == (long)QueryType.APPROVE_MILESTONES)
            {
                var result = Post_Milestone(id, date, user);
                if (result == ERROR_CODE.SUCCESS)
                {
                    return ERROR_CODE.SUCCESS;
                }
                else
                {

                }

            }
            //定期服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES)
            {
                var result = Post_Recurring_Services(id, date, user);
                if (result == ERROR_CODE.SUCCESS)
                {
                    return ERROR_CODE.SUCCESS;
                }
                else
                {

                }

            }
            //订阅周期
            if (type == (long)QueryType.APPROVE_SUBSCRIPTIONS)
            {
                var result = Post_Subscriptions(id, date, user);
                if (result == ERROR_CODE.SUCCESS)
                {
                    return ERROR_CODE.SUCCESS;
                }
                else
                {

                }

            }

            return ERROR_CODE.ERROR;
        }
        /// <summary>
        /// 审批定期服务
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Recurring_Services(int id, int date, UserInfoDto user)
        {
            crm_account_deduction cad = new crm_account_deduction();//审批并提交表实体对象
            crm_account ca = new crm_account();//客户实体对象
            d_cost_code dcc = new d_cost_code();//物料代码
            GeneralBLL gbll = new GeneralBLL();//字典项 
            crm_account_dal ca_dal = new crm_account_dal();//客户处理
            ctt_contract_dal cc_dal = new ctt_contract_dal();//合同处理
            ctt_contract_service_adjust_dal ccsa_dal = new ctt_contract_service_adjust_dal();//合同服务调整
            ctt_contract_service_period_dal ccsp_dal = new ctt_contract_service_period_dal();//合同服务周期
            crm_account_deduction_dal cad_dal = new crm_account_deduction_dal();//审批并提交
            //通过id判断
            var cc = cc_dal.FindNoDeleteById(id);
            var ccsa = ccsa_dal.FindNoDeleteById(id);
            var ccsp = ccsp_dal.FindNoDeleteById(id);
            if (cc != null & ccsa != null || cc != null && ccsp != null || ccsa != null && ccsp != null || cc == null && ccsa == null && ccsp == null)
            {
                return ERROR_CODE.ERROR;
            }
            //合同
            if (cc != null)
            {
                cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.INITIAL_COST;//类型(合同初始费用)
                cad.object_id = id;//对象
                cad.contract_id = id;//合同id
                cad.quantity = 1;
                cad.bill_create_user_id = cc.create_user_id;//条目创建人
                cad.account_id = cc.account_id;//客户
                cad.extended_price = cc.adjust_setup_fee;//总收入  
                dcc = new d_cost_code_dal().FindNoDeleteById((long)cc.setup_fee_cost_code_id);
            }
            //合同服务调整
            if (ccsa != null)
            {
                cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST;//类型（合同服务调整）
                cad.object_id = id;//对象
                cad.contract_id = ccsa.contract_id;//合同id
                cad.extended_price = ccsa.adjust_prorated_price_change;//总收入
                cad.quantity = ccsa.quantity_change;//数量
                cc = cc_dal.FindNoDeleteById(ccsa.contract_id);
                cad.account_id = cc.account_id;//客户id
                cad.bill_create_user_id = ccsa.create_user_id;//条目创建人
                dcc = new d_cost_code_dal().FindNoDeleteById(new ivt_service_dal().FindNoDeleteById(ccsa.object_id).cost_code_id);
            }
            //合同服务周期
            if (ccsp != null)
            {
                cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.SERVICE_ADJUST;//类型（合同服务调整）
                cad.object_id = id;//对象
                cad.contract_id = ccsp.contract_id;//合同id
                cad.extended_price = ccsp.period_adjusted_price;//总收入
                cad.quantity = ccsp.quantity;//数量
                cc = cc_dal.FindNoDeleteById(ccsp.contract_id);
                cad.account_id = cc.account_id;//客户id
                cad.bill_create_user_id = ccsp.create_user_id;//条目创建人
                dcc = new d_cost_code_dal().FindNoDeleteById(new ivt_service_dal().FindNoDeleteById(ccsp.object_id).cost_code_id);
            }

            ca = ca_dal.FindNoDeleteById(cc.account_id);

            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;
            cad.id = (int)(cad_dal.GetNextIdCom());//id
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率
            if (ca.is_tax_exempt != 1)
            {
                cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额
            }
            cad.create_user_id = cad.update_user_id = user.id;
            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cad_dal.Insert(cad);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                oper_object_id = cad.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = cad_dal.AddValue(cad),
                remark = "新增审批并提交"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志


            //修改日志
            //合同
            if (cc != null)
            {
                var old = cc;
                cc.setup_fee_approve_and_post_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
                cc.setup_fee_approve_and_post_user_id = user.id;
                cc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cc.update_user_id = user.id;
                if (cc_dal.Update(cc))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT,//合同
                        oper_object_id = cc.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = cc_dal.CompareValue(old, cc),
                        remark = "审批合同初始费用"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
                else
                {
                    return ERROR_CODE.ERROR;
                }

            }
            //合同服务调整
            if (ccsa != null)
            {
                var old = ccsa;
                ccsa.approve_and_post_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
                ccsa.approve_and_post_user_id = user.id;
                ccsa.update_user_id = user.id;
                ccsa.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                if (ccsa_dal.Update(ccsa))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST,//合同服务调整
                        oper_object_id = ccsa.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = ccsa_dal.CompareValue(old, ccsa),
                        remark = "审批合同服务调整"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
                else
                {
                    return ERROR_CODE.ERROR;
                }
            }
            //合同服务周期 
            if (ccsp != null)
            {
                var old = ccsp;
                ccsp.approve_and_post_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
                ccsp.approve_and_post_user_id = user.id;
                ccsp.update_user_id = user.id;
                ccsp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                if (ccsp_dal.Update(ccsp))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD,//合同服务调整
                        oper_object_id = ccsp.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = ccsp_dal.CompareValue(old, ccsp),
                        remark = "审批合同服务调整"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
                else
                {
                    return ERROR_CODE.ERROR;
                }
            }



            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 审批订阅
        /// </summary>
        /// <param name="id">订阅周期表id</param>
        /// <param name="date">提交日期</param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Subscriptions(int id, int date, UserInfoDto user)
        {
            crm_subscription_period_dal csp_dal = new crm_subscription_period_dal();
            GeneralBLL gbll = new GeneralBLL();//字典项 
            var csp = csp_dal.FindSignleBySql<crm_subscription_period>($"select * from crm_subscription_period where id={id} and approve_and_post_date is null");//订阅周期
            var cs = new crm_subscription_dal().FindSignleBySql<crm_subscription>($"select * from crm_subscription where id={csp.subscription_id} and delete_time=0");//订阅
            var cip = new crm_installed_product_dal().FindSignleBySql<crm_installed_product>($"select * from crm_installed_product where id={cs.installed_product_id} and delete_time=0");//配置项
            var dcc = new d_cost_code_dal().FindSignleBySql<d_cost_code>($"select * from d_cost_code where id={cs.cost_code_id} and delete_time=0");//物料代码
            var ca = new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={cip.account_id} and delete_time=0");//客户
            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;
            cad.id = (int)(cad_dal.GetNextIdCom());
            cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.SUBSCRIPTIONS;
            cad.object_id = id;
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            if (cip.contract_id != null)
                cad.contract_id = (long)cip.contract_id;//合同
            cad.extended_price = csp.period_price;//总价
            cad.account_id = (long)cip.account_id;//客户id
            cad.bill_create_user_id = cs.create_user_id;//订阅创建人
            cad.purchase_order_no = cs.purchase_order_no;//采购订单号

            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率
                                              //判断客户是否免税
            if (ca.is_tax_exempt != 1)
            {
                cad.tax_dollars = tax_rate * Convert.ToDecimal(csp.period_price);//税额
            }
            cad.create_user_id = cad.update_user_id = user.id;
            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cad_dal.Insert(cad);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                oper_object_id = cad.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = cad_dal.AddValue(cad),
                remark = "新增审批并提交"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            var oldcsp = csp;
            csp.approve_and_post_date = cad.posted_date;
            csp.approve_and_post_user_id = user.id;
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION_PERIOD,//订阅周期
                oper_object_id = csp.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = csp_dal.CompareValue(oldcsp, csp),
                remark = "订阅周期审批"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
            if (!csp_dal.Update(csp))
            {
                return ERROR_CODE.ERROR;
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 当成本关联预付费或时间，预付不足时：
        /// a/自动生成预付费、
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="op"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Charges_a(int id, int date, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            GeneralBLL gbll = new GeneralBLL();//字典项  
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();
            var ccc = ccc_dal.FindNoDeleteById(id);//合同成本
            var cc = cc_dal.FindNoDeleteById((long)ccc.contract_id);//合同
            var dcc = new d_cost_code_dal().FindSignleBySql<d_cost_code>($"select * from d_cost_code where id={ccc.cost_code_id} and delete_time=0");//物料代码
            var ca = new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={cc.account_id} and delete_time=0");//客户
            //成本类型不能是预付费用、预付时间、事件
            if (dcc.cate_id == (int)COST_CODE_CATE.BLOCK_PURCHASE || dcc.cate_id == (int)COST_CODE_CATE.TICKET_PURCHASE || dcc.cate_id == (int)COST_CODE_CATE.RETAINER_PURCHASE)
            {
                return ERROR_CODE.ERROR;
            }
            var ccnr = new ctt_contract_notify_rule_dal().FindSignleBySql<ctt_contract_notify_rule>($"select * from ctt_contract_notify_rule where contract_id={ccc.contract_id} and delete_time=0");
            if (ccnr == null)
            {
                return ERROR_CODE.ERROR;
            }

            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;
            cad.object_id = id;//成本表id
            cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.CHARGE;
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            cad.task_id = ccc.task_id;//任务id           
            cad.quantity = ccc.quantity;//数量
            cad.contract_id = ccc.contract_id;//合同id
            cad.account_id = cc.account_id;//客户id
            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率

            var ccbList = ccb_dal.FindListBySql<ctt_contract_block>($"select * from ctt_contract_block where contract_id={ccc.contract_id} and is_billed=0 and status_id=1");
            decimal extend = 0;
            foreach (var ccb in ccbList)
            {
                extend += ccb.quantity * ccb.rate;
                if (ccc.extended_price != null)
                {
                    cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                    cad.contract_block_id = ccb.id;
                    if (extend < ccc.extended_price)
                    {
                        cad.extended_price = ccb.quantity * ccb.rate;
                        if (ca.is_tax_exempt != 1)
                        {
                            cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                        }
                        cad.create_user_id = cad.update_user_id = user.id;
                        cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad_dal.Insert(cad);
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = cad_dal.AddValue(cad),
                            remark = "新增审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                        var oldccb = ccb;
                        ccb.is_billed = 1;
                        ccb.status_id = 0;
                        ccb.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        ccb.update_user_id = user.id;
                        ccb_dal.Update(ccb);
                        var add2_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                            oper_object_id = ccc.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = ccc_dal.CompareValue(oldccb, ccb),
                            remark = "修改合同成本预付时间或费用"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                    }
                }
            }
            extend = (decimal)ccc.extended_price - extend;
            extend = decimal.Divide(extend, (decimal)ccnr.rate);
            int n = decimal.ToInt32(extend);
            decimal m = extend - n;
            for (int i = 0; i < n; i++)
            {
                ctt_contract_block ccb1 = new ctt_contract_block();
                ccb1.id = (int)ccb_dal.GetNextIdCom();
                ccb1.rate = (decimal)ccnr.rate;//费率
                ccb1.contract_id = (long)ccc.contract_id;//合同id
                ccb1.start_date = cc.start_date;
                ccb1.end_date = cc.end_date;
                ccb1.quantity = 1;
                ccb1.is_billed = 0;
                ccb1.status_id = 1;
                ccb1.date_purchased = DateTime.Now.Date;//购买日期
                ccb1.create_time = ccb1.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccb1.create_user_id = ccb1.update_user_id = user.id;
                ccb_dal.Insert(ccb1);
                var add4_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                    oper_object_id = ccb1.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = ccb_dal.AddValue(ccb1),
                    remark = "新增(自动续费功能)合同成本预付时间或费用"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add4_log);       // 插入日志

                //审批
                cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                cad.contract_block_id = ccb1.id;
                cad.extended_price = ccb1.quantity * ccb1.rate;
                if (ca.is_tax_exempt != 1)
                {
                    cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                }
                cad.create_user_id = cad.update_user_id = user.id;
                cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cad_dal.Insert(cad);
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                    oper_object_id = cad.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = cad_dal.AddValue(cad),
                    remark = "新增审批并提交"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志



            }
            if (m > 0)
            {
                //多余部分
                ctt_contract_block ccb2 = new ctt_contract_block();
                ccb2.id = (int)ccb_dal.GetNextIdCom();
                ccb2.rate = (decimal)ccnr.rate;//费率
                ccb2.contract_id = (long)ccc.contract_id;//合同id
                ccb2.start_date = cc.start_date;
                ccb2.end_date = cc.end_date;
                ccb2.quantity = 1 - m;
                ccb2.is_billed = 0;
                ccb2.status_id = 1;
                ccb2.date_purchased = DateTime.Now.Date;//购买日期
                ccb2.create_time = ccb2.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccb2.create_user_id = ccb2.update_user_id = user.id;
                ccb_dal.Insert(ccb2);
                var add5_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                    oper_object_id = ccb2.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = ccb_dal.AddValue(ccb2),
                    remark = "新增(自动续费功能)合同成本预付时间或费用"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add5_log);       // 插入日志



                //审批
                cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                cad.contract_block_id = ccb2.id;
                cad.extended_price = ccb2.quantity * ccb2.rate;
                if (ca.is_tax_exempt != 1)
                {
                    cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                }
                cad.create_user_id = cad.update_user_id = user.id;
                cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cad_dal.Insert(cad);
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                    oper_object_id = cad.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = cad_dal.AddValue(cad),
                    remark = "新增审批并提交"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志
            }


            var olaccc = ccc;
            ccc.bill_status = 1;//已计费
            ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            ccc.update_user_id = user.id;
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                oper_object_id = ccc.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ccc_dal.CompareValue(olaccc, ccc),
                remark = "修改合同成本"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志



            if (!ccc_dal.Update(ccc))
            {
                return ERROR_CODE.ERROR;
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 当成本关联预付费或时间，预付不足时：
        /// b/强制生成（不够的部分单独生成一个条目）
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="op"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Charges_b(int id, int date, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;

            }
            GeneralBLL gbll = new GeneralBLL();//字典项  
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();
            var ccc = ccc_dal.FindNoDeleteById(id);//合同成本
            var cc = cc_dal.FindSignleBySql<crm_contact>($"select * from crm_contact where id={ccc.contract_id} and delete_time=0");//合同
            var dcc = new d_cost_code_dal().FindSignleBySql<d_cost_code>($"select * from d_cost_code where id={ccc.cost_code_id} and delete_time=0");//物料代码
            var ca = new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={cc.account_id} and delete_time=0");//客户
            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;
            cad.object_id = id;//成本表id
            cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.CHARGE;
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            cad.task_id = ccc.task_id;//任务id           
            cad.quantity = ccc.quantity;//数量
            cad.contract_id = ccc.contract_id;//合同id
            cad.account_id = cc.account_id;//客户id
            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率

            var ccbList = ccb_dal.FindListBySql<ctt_contract_block>($"select * from ctt_contract_block where contract_id={ccc.contract_id} and is_billed=0 and status_id=1");
            decimal extend = 0;
            foreach (var ccb in ccbList)
            {
                extend += ccb.quantity * ccb.rate;
                if (ccc.extended_price != null)
                {
                    cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                    cad.contract_block_id = ccb.id;
                    if (extend < ccc.extended_price)
                    {
                        cad.extended_price = ccb.quantity * ccb.rate;
                        if (ca.is_tax_exempt != 1)
                        {
                            cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                        }
                        cad.create_user_id = cad.update_user_id = user.id;
                        cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cad_dal.Insert(cad);
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                            oper_object_id = cad.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = cad_dal.AddValue(cad),
                            remark = "新增审批并提交"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                        var oldccb = ccb;
                        ccb.is_billed = 1;
                        ccb.status_id = 0;
                        ccb.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        ccb.update_user_id = user.id;
                        ccb_dal.Update(ccb);
                        var add2_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                            oper_object_id = ccc.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = ccc_dal.CompareValue(oldccb, ccb),
                            remark = "修改合同成本预付时间或费用"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                    }

                }
            }
            cad.id = (int)(cad_dal.GetNextIdCom());//序列号
            cad.contract_block_id = null;
            cad.extended_price = extend - ccc.extended_price;
            if (ca.is_tax_exempt != 1)
            {
                cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
            }
            cad.create_user_id = cad.update_user_id = user.id;
            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cad_dal.Insert(cad);
            var add3_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                oper_object_id = cad.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = cad_dal.AddValue(cad),
                remark = "新增审批并提交"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add3_log);       // 插入日志

            var olaccc = ccc;
            ccc.bill_status = 1;//已计费
            ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            ccc.update_user_id = user.id;
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                oper_object_id = ccc.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ccc_dal.CompareValue(olaccc, ccc),
                remark = "修改合同成本"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
            if (!ccc_dal.Update(ccc))
            {
                return ERROR_CODE.ERROR;
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 审批成本
        /// </summary>
        /// <param name="id">成本表id</param>
        /// <param name="date"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Charges(int id, int date, UserInfoDto user)
        {
            GeneralBLL gbll = new GeneralBLL();//字典项  
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();
            crm_account ca = new crm_account();
            var ccc = ccc_dal.FindNoDeleteById(id);//合同成本
            //工单(待整理) sdk_task
            if (ccc.ticket_id != null)
            {
               ca= new crm_account_dal().FindSignleBySql<crm_account>($"select a.* from crm_account a,sdk_task b,ctt_contract_cost c where c.ticket_id=b.id and a.id=b.account_id and a.delete_time=0 and b.delete_time=0 and c.delete_time=0 and c.id={id}");//客户
            }//项目(待整理) pro_project
            else if (ccc.project_id != null)
            {
                ca = new crm_account_dal().FindSignleBySql<crm_account>($"select a.* from crm_account a,pro_project b,ctt_contract_cost c where c.ticket_id=b.id and a.id=b.account_id and a.delete_time=0 and b.delete_time=0 and c.delete_time=0 and c.id={id}");//客户
            }
            else
            {
                ca = new crm_account_dal().FindSignleBySql<crm_account>($"select a.* from crm_account a,ctt_contract_cost b,ctt_contract c where a.id=c.account_id and b.contract_id=c.id and a.delete_time=0 and b.delete_time=0 and c.delete_time=0 and b.id={id}");//客户
            }           

            var dcc = new d_cost_code_dal().FindSignleBySql<d_cost_code>($"select * from d_cost_code where id={ccc.cost_code_id} and delete_time=0");//物料代码
         
            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;
            cad.object_id = id;//成本表id
            cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.CHARGE;
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            cad.task_id = ccc.task_id;//任务id           
            cad.quantity = ccc.quantity;//数量
            cad.contract_id = ccc.contract_id;//合同id
            cad.account_id = ca.id;//客户id
            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率
            cad.purchase_order_no = ccc.purchase_order_no;//采购订单号
                                              //判断客户是否免税
                                              //成本/工时 不 需要从预付费用/预付时间中扣除
            var ccbList = ccb_dal.FindListBySql<ctt_contract_block>($"select * from ctt_contract_block where contract_id={ccc.contract_id} and is_billed=0 and status_id=1");
            if (ccbList.Count <= 0)
            {
                cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                cad.extended_price = ccc.extended_price;//总价
                if (ca.is_tax_exempt != 1)
                {
                    cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                }
                cad.create_user_id = cad.update_user_id = user.id;
                cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cad_dal.Insert(cad);
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                    oper_object_id = cad.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = cad_dal.AddValue(cad),
                    remark = "新增审批并提交"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志
            }//需要
            else
            {
                decimal extend = 0;
                foreach (var ccb in ccbList)
                {
                    extend += ccb.quantity * ccb.rate;
                    if (ccc.extended_price != null)
                    {
                        cad.id = (int)(cad_dal.GetNextIdCom());//序列号
                        cad.contract_block_id = ccb.id;
                        if (extend <= ccc.extended_price)
                        {
                            cad.extended_price = ccb.quantity * ccb.rate;
                            if (ca.is_tax_exempt != 1)
                            {
                                cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                            }
                            cad.create_user_id = cad.update_user_id = user.id;
                            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            cad_dal.Insert(cad);
                            var add3_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                                oper_object_id = cad.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                oper_description = cad_dal.AddValue(cad),
                                remark = "新增审批并提交"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add3_log);       // 插入日志

                            var oldccb = ccb;
                            ccb.is_billed = 1;
                            ccb.status_id = 0;
                            ccb.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccb.update_user_id = user.id;
                            ccb_dal.Update(ccb);
                            var add2_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                                oper_object_id = ccc.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                oper_description = ccc_dal.CompareValue(oldccb, ccb),
                                remark = "修改合同成本预付时间或费用"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                            if (extend == ccc.extended_price)
                            {
                                break;
                            }
                        }
                        else
                        {
                            cad.extended_price = ccb.quantity * ccb.rate - (extend - (decimal)ccc.extended_price);
                            if (ca.is_tax_exempt != 1)
                            {
                                cad.tax_dollars = tax_rate * Convert.ToDecimal(cad.extended_price);//税额                    
                            }
                            cad.create_user_id = cad.update_user_id = user.id;
                            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            cad_dal.Insert(cad);
                            var add_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                                oper_object_id = cad.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                oper_description = cad_dal.AddValue(cad),
                                remark = "新增审批并提交"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add_log);       // 插入日志
                            ccb.quantity = (extend - (decimal)ccc.extended_price) / ccb.rate;
                            ccb.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccb.update_user_id = user.id;
                            ccb_dal.Update(ccb);
                            var oldccb = ccb;
                            var add2_log = new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_BLOCK,//合同成本预付
                                oper_object_id = ccc.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                oper_description = ccc_dal.CompareValue(oldccb, ccb),
                                remark = "修改合同成本预付时间或费用"
                            };          // 创建日志
                            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
                            break;
                        }
                    }
                }

            }
            var olaccc = ccc;
            ccc.bill_status = 1;//已计费
            ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            ccc.update_user_id = user.id;
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                oper_object_id = ccc.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ccc_dal.CompareValue(olaccc, ccc),
                remark = "修改合同成本"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
            if (!ccc_dal.Update(ccc))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 里程碑审批
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Milestone(int id, int date, UserInfoDto user)
        {

            GeneralBLL gbll = new GeneralBLL();//字典项            
            ctt_contract_milestone_dal ccm_dal = new ctt_contract_milestone_dal();//里程碑处理
            var ccm = ccm_dal.FindSignleBySql<ctt_contract_milestone>($"select * from ctt_contract_milestone where id={id} and delete_time=0");//里程碑
            var cc = cc_dal.FindSignleBySql<crm_contact>($"select * from crm_contact where id={ccm.contract_id} and delete_time=0");//合同
            var dcc = new d_cost_code_dal().FindSignleBySql<d_cost_code>($"select * from d_cost_code where id={ccm.cost_code_id} and delete_time=0");//物料代码
            var ca = new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={cc.account_id} and delete_time=0");//客户
            string tax_category_name = null;//税收种类
            string tax_region_name = null;//税区
            decimal tax_rate = 0;//税率
            if (dcc.tax_category_id != null)
                tax_category_name = gbll.GetGeneralName((int)dcc.tax_category_id);
            if (ca.tax_region_id != null)
                tax_region_name = gbll.GetGeneralName((int)ca.tax_region_id);
            if (dcc.tax_category_id != null && ca.tax_region_id != null)
                tax_rate = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id='ca.tax_region_id' and tax_cate_id='dcc.tax_category_id' ").total_effective_tax_rate;

            cad.id = (int)(cad_dal.GetNextIdCom());
            cad.type_id = (int)ACCOUNT_DEDUCTION_TYPE.MILESTONES;
            cad.object_id = id;
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null).Date;//转换时间格式
            cad.contract_id = ccm.contract_id;//合同id
            cad.extended_price = ccm.dollars;//里程碑金额
            cad.quantity = null;
            cad.account_id = cc.account_id;//客户id
            cad.bill_create_user_id = ccm.create_user_id;//里程碑创建人

            cad.tax_category_name = tax_category_name;//税收种类name
            cad.tax_region_name = tax_region_name;//税区
            cad.effective_tax_rate = tax_rate;//税率
                                              //判断客户是否免税
            if (ca.is_tax_exempt != 1)
            {
                cad.tax_dollars = tax_rate * Convert.ToDecimal(ccm.dollars);//税额
            }
            cad.create_user_id = cad.update_user_id = user.id;
            cad.create_time = cad.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cad_dal.Insert(cad);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACCOUNT_DEDUCTION,//审批并提交
                oper_object_id = cad.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = cad_dal.AddValue(cad),
                remark = "新增审批并提交"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志

            var olaccm = ccm;
            ccm.status_id = (int)MILESTONE_STATUS.BILLED;//已计费
            ccm.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            ccm.update_user_id = user.id;
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE,//里程碑
                oper_object_id = ccm.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = ccm_dal.CompareValue(olaccm, ccm),
                remark = "修改里程碑"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
            if (!ccm_dal.Update(ccm))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 返回调整对象名称，调整前的价格
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetAdjustExtend(int id, long type, out decimal extend)
        {
            extend = 0;
            //订阅
            if (type == (long)QueryType.APPROVE_SUBSCRIPTIONS)
            {
                var csp = new crm_subscription_period_dal().FindSignleBySql<crm_subscription_period>($"select * from crm_subscription_period where id={id} and approve_and_post_date is null");
                extend = csp.period_price;
                var cs = new crm_subscription_dal().FindSignleBySql<crm_subscription>($"select * from crm_subscription where id={csp.subscription_id} and delete_time=0");
                return cs.name;
            }
            //定期服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES)
            {
                //通过id判断
                var cc = cc_dal.FindNoDeleteById(id);
                var ccsa = new ctt_contract_service_adjust_dal().FindNoDeleteById(id);
                var ccsp = new ctt_contract_service_period_dal().FindNoDeleteById(id);
                if (cc != null & ccsa != null || cc != null && ccsp != null || ccsa != null && ccsp != null || cc == null && ccsa == null && ccsp == null)
                {
                    return null;
                }
                //合同
                if (cc != null)
                {
                    extend = Convert.ToDecimal(cc.adjust_setup_fee);
                    return cc.name;
                }
                //合同服务调整
                if (ccsa != null)
                {
                    extend = ccsa.adjust_prorated_price_change;
                    cc = cc_dal.FindNoDeleteById(ccsa.contract_id);
                    return cc.name;
                }
                //合同服务周期
                if (ccsp != null)
                {
                    extend = Convert.ToDecimal(ccsp.period_adjusted_price);
                    cc = cc_dal.FindNoDeleteById(ccsp.contract_id);
                    return cc.name;
                }
                return null;
            }
            //成本
            if (type == (long)QueryType.APPROVE_CHARGES)
            {
                var ccc = new ctt_contract_cost_dal().FindNoDeleteById(id);
                if (ccc != null)
                {
                    extend = Convert.ToDecimal(ccc.extended_price);
                    return ccc.name;
                }
            }
            return null;
        }
        /// <summary>
        /// 调整订阅周期、定期服务（服务、服务调整、服务包、服务包调整、初始费用）、成本的计费总价
        /// </summary>
        /// <param name="csp"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateExtendedPrice(int id, decimal period_price, long user_id, long type = 0)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //订阅
            if (type == (long)QueryType.APPROVE_SUBSCRIPTIONS)
            {
                var csp = new crm_subscription_period_dal().FindSignleBySql<crm_subscription_period>($"select * from crm_subscription_period where id={id} and approve_and_post_date is null");
                var oldcsp = csp;
                csp.period_price = period_price;
                if (!new crm_subscription_period_dal().Update(csp))
                {
                    return ERROR_CODE.ERROR;
                }
                var add1_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SUBSCRIPTION_PERIOD,//订阅周期
                    oper_object_id = csp.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = new crm_subscription_period_dal().CompareValue(oldcsp, csp),
                    remark = "修改订阅周期"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add1_log);       // 插入日志
            }
            //定期服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES)
            {
                //通过id判断
                var cc = cc_dal.FindNoDeleteById(id);
                var ccsa = new ctt_contract_service_adjust_dal().FindNoDeleteById(id);
                var ccsp = new ctt_contract_service_period_dal().FindNoDeleteById(id);
                if (cc != null & ccsa != null || cc != null && ccsp != null || ccsa != null && ccsp != null || cc == null && ccsa == null && ccsp == null)
                {
                    return ERROR_CODE.ERROR;
                }
                //合同
                if (cc != null)
                {
                    var old = cc;
                    cc.adjust_setup_fee = period_price;
                    cc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    cc.update_user_id = user.id;

                    if (cc_dal.Update(cc))
                    {
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT,//合同
                            oper_object_id = cc.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = cc_dal.CompareValue(old, cc),
                            remark = "审批合同初始费用"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                    }
                    else
                    {
                        return ERROR_CODE.ERROR;
                    }
                }
                //合同服务调整
                if (ccsa != null)
                {
                    var old = ccsa;
                    ccsa.adjust_prorated_price_change = period_price;
                    ccsa.update_user_id = user.id;
                    ccsa.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                    if (new ctt_contract_service_adjust_dal().Update(ccsa))
                    {
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST,//合同服务调整
                            oper_object_id = ccsa.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = new ctt_contract_service_adjust_dal().CompareValue(old, ccsa),
                            remark = "恢复初始值合同服务调整"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                    }
                    else
                    {
                        return ERROR_CODE.ERROR;
                    }
                }
                //合同服务周期
                if (ccsp != null)
                {
                    var old = ccsp;
                    ccsp.period_adjusted_price = period_price;
                    ccsp.update_user_id = user.id;
                    ccsp.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    if (new ctt_contract_service_period_dal().Update(ccsp))
                    {
                        var add1_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD,//合同服务调整
                            oper_object_id = ccsp.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = new ctt_contract_service_period_dal().CompareValue(old, ccsp),
                            remark = "恢复初始值合同服务调整"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                    }
                    else
                    {
                        return ERROR_CODE.ERROR;
                    }
                }
                return ERROR_CODE.ERROR;
            }
            //成本
            if (type == (long)QueryType.APPROVE_CHARGES)
            {
                var ccc = new ctt_contract_cost_dal().FindNoDeleteById(id);
                var old = ccc;
                ccc.extended_price = period_price;
                ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccc.update_user_id = user.id;

                if (new ctt_contract_cost_dal().Update(ccc))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                        oper_object_id = ccc.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = new ctt_contract_cost_dal().CompareValue(old, ccc),
                        remark = "恢复初始值合同成本"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
                else
                {
                    return ERROR_CODE.ERROR;
                }


            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 恢复订阅周期、定期服务（服务、服务调整、服务包、服务包调整、初始费用）、成本的计费总价
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool Restore_Initial(int id, int type, long user_id)
        {
            //订阅
            if (type == (long)QueryType.APPROVE_SUBSCRIPTIONS)
            {
                decimal period_price = 0;
                var cs = new crm_subscription_dal().FindSignleBySql<crm_subscription>($"select a.* from crm_subscription a,crm_subscription_period b where b.id={id} and a.id=b.subscription_id and a.delete_time=0 and b.approve_and_post_date is null");
                if (cs != null)
                {
                    period_price = cs.period_price;
                }
                else
                {
                    return false;
                }
                if (UpdateExtendedPrice(id, period_price, user_id, type) != ERROR_CODE.SUCCESS)
                {
                    return false;
                }
            }
            //服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES)
            {
                //通过id判断
                var cc = cc_dal.FindNoDeleteById(id);
                var ccsa = new ctt_contract_service_adjust_dal().FindNoDeleteById(id);
                var ccsp = new ctt_contract_service_period_dal().FindNoDeleteById(id);
                if (cc != null & ccsa != null || cc != null && ccsp != null || ccsa != null && ccsp != null || cc == null && ccsa == null && ccsp == null)
                {
                    return false;
                }
                //合同
                if (cc != null)
                {
                    if (UpdateExtendedPrice(id, Convert.ToDecimal(cc.setup_fee), user_id, type) != ERROR_CODE.SUCCESS)
                    {
                        return false;
                    }
                }
                //合同服务调整
                if (ccsa != null)
                {
                    if (UpdateExtendedPrice(id, Convert.ToDecimal(ccsa.prorated_price_change), user_id, type) != ERROR_CODE.SUCCESS)
                    {
                        return false;
                    }
                }
                //合同服务周期
                if (ccsp != null)
                {
                    if (UpdateExtendedPrice(id, Convert.ToDecimal(ccsp.period_price), user_id, type) != ERROR_CODE.SUCCESS)
                    {
                        return false;
                    }
                }
                return false;
            }
            //成本
            if (type == (long)QueryType.APPROVE_CHARGES)
            {
                var ccc = new ctt_contract_cost_dal().FindNoDeleteById(id);
                decimal ex = 0;
                if (ccc.quantity != null && ccc.unit_price != null)
                    ex = (decimal)ccc.quantity * (decimal)ccc.unit_price;
                if (UpdateExtendedPrice(id, ex, user_id, type) != ERROR_CODE.SUCCESS)
                {
                    return false;
                }
            }
            return true;
        }
        /// <summary>
        /// 设置为不可计费
        /// </summary>
        /// <param name="id"></param>
        /// <param name="type"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool NoBilling(int id, int type, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return false;
            }
            var ccc = new ctt_contract_cost_dal().FindNoDeleteById(id);
            var old = ccc;
            if (ccc != null)
            {
                if (ccc.is_billable == 0)
                {
                    return false;
                }
                ccc.is_billable = 0;
                if (ccc.quantity != null && ccc.unit_price != null)
                {
                    ccc.extended_price = (decimal)ccc.quantity * (decimal)ccc.unit_price;
                }
                else
                {
                    ccc.extended_price = 0;
                }
                ccc.status_last_modified_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccc.status_last_modified_user_id = user.id;
                ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccc.update_user_id = user.id;
                if (new ctt_contract_cost_dal().Update(ccc))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                        oper_object_id = ccc.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = new ctt_contract_cost_dal().CompareValue(old, ccc),
                        remark = "设置合同成本为不可计费"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
            }
            return true;
        }
        /// <summary>
        /// 设置为可计费
        /// </summary>
        /// <param name="id"></param>
        /// <param name="type"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool Billing(int id, int type, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return false;
            }
            var ccc = new ctt_contract_cost_dal().FindNoDeleteById(id);
            var old = ccc;
            if (ccc != null)
            {
                if (ccc.is_billable == 1)
                {
                    return false;
                }
                ccc.is_billable = 1;
                if (ccc.quantity != null && ccc.unit_price != null)
                {
                    ccc.extended_price = (decimal)ccc.quantity * (decimal)ccc.unit_price;
                }
                else
                {
                    ccc.extended_price = 0;
                }
                ccc.status_last_modified_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccc.status_last_modified_user_id = user.id;
                ccc.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ccc.update_user_id = user.id;
                if (new ctt_contract_cost_dal().Update(ccc))
                {
                    var add1_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,//合同成本
                        oper_object_id = ccc.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = new ctt_contract_cost_dal().CompareValue(old, ccc),
                        remark = "设置合同成本为可计费"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add1_log);       // 插入日志
                }
            }
            return true;
        }
        /// <summary>
        ///如果成本关联预付费合同，则需要从预付费中扣除费用。
        ///系统需要判断预付费是否足够，
        /// </summary>
        /// <param name="id">成本id</param>
        /// <returns>true代表不足够</returns>
        public ERROR_CODE ChargeBlock(int id)
        {
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();//成本处理
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();//预付费
            var ccc = ccc_dal.FindNoDeleteById(id);
            var cc = new ctt_contract_dal().FindNoDeleteById((long)ccc.contract_id);
            var ccbList = ccb_dal.FindListBySql<ctt_contract_block>($"select * from ctt_contract_block where contract_id={ccc.contract_id} and is_billed=0 and status_id=1");
            if (cc!= null&&cc.type_id == (int)CONTRACT_TYPE.RETAINER)
            {
                var ccnr = new ctt_contract_notify_rule_dal().FindSignleBySql<ctt_contract_notify_rule>($"select * from ctt_contract_notify_rule where contract_id={ccc.contract_id} and delete_time=0");
                //费率为空的判断
                if (ccnr.rate == null || ccnr.rate == 0)
                {
                    return ERROR_CODE.NOTIFICATION_RULE_RATE_NULL;
                }
                if (ccbList.Count <= 0)
                {//没有关联预付费合同
                    return ERROR_CODE.SUCCESS;
                }
                decimal extended_price = 0;
                foreach (var ccb in ccbList)
                {
                    extended_price += ccb.quantity * ccb.rate;
                }
                if (ccc.extended_price != null && ccc.extended_price > extended_price)
                {
                    return ERROR_CODE.SUCCESS;
                }
            }
            return ERROR_CODE.ERROR;
        }
        /// <summary>
        /// 返回成本名称、客户名称、计费金额
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ApprovePostDto.ChargesSelectList charge(int id) {
            ctt_contract_cost_dal ccc_dal = new ctt_contract_cost_dal();//成本处理
            ctt_contract_block_dal ccb_dal = new ctt_contract_block_dal();//预付费
            var kk =new ApprovePostDto.ChargesSelectList();
            var ccc = ccc_dal.FindNoDeleteById(id);
            var cc = new ctt_contract_dal().FindNoDeleteById((long)ccc.contract_id);
            var ca = new crm_account_dal().FindNoDeleteById(cc.account_id);
            kk.accountname = ca.name;
            kk.costname = ccc.name;
            kk.extendprice = ccc.extended_price.ToString();
            return kk;
        }
        /// <summary>
        /// 查看合同详情，返回合同id
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="type"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public int ContractDetails(int id, int date, long type, long user_id) {
            //成本
            if (type == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES)
            {
                return (int)new ctt_contract_cost_dal().FindNoDeleteById(id).contract_id;
            }
            //审批里程碑
            if (type == (long)QueryType.APPROVE_MILESTONES)
            {
                return (int)new ctt_contract_milestone_dal().FindNoDeleteById(id).contract_id;
            }
            //定期服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES)
            {
                //通过id判断
                var cc = cc_dal.FindNoDeleteById(id);
                var ccsa = new ctt_contract_service_adjust_dal().FindNoDeleteById(id);
                var ccsp = new ctt_contract_service_period_dal().FindNoDeleteById(id);
                if (cc != null & ccsa != null || cc != null && ccsp != null || ccsa != null && ccsp != null || cc == null && ccsa == null && ccsp == null)
                {
                    return -1;
                }
                //合同
                if (cc != null)
                {
                    return id;
                }
                //合同服务调整
                if (ccsa != null)
                {
                    return (int)ccsa.contract_id;
                }
                //合同服务周期
                if (ccsp != null)
                {
                    return (int)ccsp.contract_id;
                }
            }
            return -1;
        }      

    }
}
