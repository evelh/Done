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
        private readonly crm_contact_dal cc_dal = new crm_contact_dal();//合同处理
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

                }
                else
                {

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
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null);//转换时间格式
            if (cip.contract_id != null)
                cad.contract_id = (long)cip.contract_id;//合同
            cad.extended_price = csp.period_price;//总价
            cad.account_id = (long)cip.account_id;//客户id
            cad.bill_create_user_id = cs.create_user_id;//订阅创建人
            cad.purchase_order_number = cs.purchase_order_number;//采购订单号

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
        /// 审批成本
        /// </summary>
        /// <param name="id"></param>
        /// <param name="date"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        public ERROR_CODE Post_Charges(int id, int date, UserInfoDto user)
        {
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
            cad.posted_date = DateTime.ParseExact(date.ToString(), "yyyyMMdd", null);//转换时间格式
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
                oper_object_id = cad.id,// 操作对象id
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
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES) {

            }
            return null;
        }
        /// <summary>
        /// 修改订阅周期
        /// </summary>
        /// <param name="csp"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateSubscriptionPeriod(int id, decimal period_price, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {
                // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
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

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 恢复初始值
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool Restore_Initial(int id, int type, long user_id)
        {
            //订阅
            if (type == (long)QueryType.APPROVE_SUBSCRIPTIONS)
            {
                decimal period_price = 0;
                var cs = new crm_subscription_dal().FindSignleBySql<crm_subscription>($"select a.* from crm_subscription a,crm_subscription_period b where b.id=878 and a.id=b.subscription_id and a.delete_time=0 and b.approve_and_post_date is null");
                if (cs != null)
                {
                    period_price = cs.period_price;
                }
                else
                {
                    return false;
                }
                if (UpdateSubscriptionPeriod(id, period_price, user_id) != ERROR_CODE.SUCCESS)
                {
                    return false;
                }
            }
            //服务
            if (type == (long)QueryType.APPROVE_RECURRING_SERVICES) {
                return false;
            }
                return true;
        }
    }
}
