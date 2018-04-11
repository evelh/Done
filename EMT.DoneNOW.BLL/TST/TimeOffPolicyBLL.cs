using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class TimeOffPolicyBLL
    {
        private tst_timeoff_policy_dal dal = new tst_timeoff_policy_dal();

        /// <summary>
        /// 获取休假策略
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public tst_timeoff_policy GetPolicyById(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 获取休假策略列表
        /// </summary>
        /// <returns></returns>
        public List<tst_timeoff_policy> GetPolicyList()
        {
            return dal.FindListBySql($"select * from tst_timeoff_policy where delete_time=0");
        }

        /// <summary>
        /// 新增休假策略
        /// </summary>
        /// <param name="policy">休假策略</param>
        /// <param name="resAss">关联员工信息</param>
        /// <param name="items">休假策略类别</param>
        /// <param name="tier">休假策略分类-级别</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddPolicy(tst_timeoff_policy policy, TimeoffAssociateResourceDto resAss, List<tst_timeoff_policy_item> items, TimeoffPolicyTierListDto tier, long userId)
        {
            policy.id = dal.GetNextIdCom();
            policy.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            policy.update_time = policy.create_time;
            policy.create_user_id = userId;
            policy.update_user_id = userId;
            policy.is_system = 0;
            dal.Insert(policy);
            OperLogBLL.OperLogAdd<tst_timeoff_policy>(policy, policy.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_POLICY, "新增休假策略");

            if (resAss != null && resAss.items.Count > 0)
            {
                tst_timeoff_policy_resource_dal resDal = new tst_timeoff_policy_resource_dal();
                foreach (var itm in resAss.items)
                {
                    AddTimeoffResource(itm.resourceId, policy.id, itm.effBeginDate, userId);
                }
            }

            tst_timeoff_policy_item_dal itemDal = new tst_timeoff_policy_item_dal();
            tst_timeoff_policy_item_tier_dal tierDal = new tst_timeoff_policy_item_tier_dal();
            foreach (var itm in items)
            {
                itm.id = itemDal.GetNextIdCom();
                itm.timeoff_policy_id = policy.id;
                itm.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                itm.update_time = itm.create_time;
                itm.create_user_id = userId;
                itm.update_user_id = userId;
                itemDal.Insert(itm);
                OperLogBLL.OperLogAdd<tst_timeoff_policy_item>(itm, itm.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM, "新增假期策略类别");

                if (tier != null)
                {
                    foreach (var itmTier in tier.items)
                    {
                        if (itmTier.cate != itm.cate_id)
                            continue;
                        tst_timeoff_policy_item_tier itemTier = new tst_timeoff_policy_item_tier();
                        itemTier.id = tierDal.GetNextIdCom();
                        itemTier.timeoff_policy_item_id = itm.id;
                        itemTier.annual_hours = itmTier.annualHours;
                        itemTier.cap_hours = itmTier.capHours;
                        itemTier.eligible_starting_months = itmTier.eligibleMonths;
                        if (itemTier.annual_hours != null)
                        {
                            if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DAY)
                                itemTier.hours_accrued_per_period = itemTier.annual_hours / 365;
                            if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.WEEK)
                                itemTier.hours_accrued_per_period = itemTier.annual_hours / 52;
                            if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK)
                                itemTier.hours_accrued_per_period = itemTier.annual_hours / 26;
                            if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH)
                                itemTier.hours_accrued_per_period = itemTier.annual_hours / 24;
                            if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.MONTH)
                                itemTier.hours_accrued_per_period = itemTier.annual_hours / 12;
                        }
                        itemTier.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        itemTier.update_time = itemTier.create_time;
                        itemTier.create_user_id = userId;
                        itemTier.update_user_id = userId;

                        tierDal.Insert(itemTier);
                        OperLogBLL.OperLogAdd<tst_timeoff_policy_item_tier>(itemTier, itemTier.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "新增休假策略分类级别");
                    }
                }
            }

            return true;
        }

        public bool EditPolicy(tst_timeoff_policy policy, long userId)
        {
            return false;
        }

        /// <summary>
        /// 删除休假策略
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeletePolicy(long id, long userId)
        {
            var policy = dal.FindById(id);
            if (policy == null)
                return false;
            int assResCnt = dal.FindSignleBySql<int>($"select count(0) from tst_timeoff_policy_resource where timeoff_policy_id={id} and delete_time=0");
            if (assResCnt > 0)
                return false;

            policy.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            policy.delete_user_id = userId;
            dal.Update(policy);
            OperLogBLL.OperLogDelete<tst_timeoff_policy>(policy, id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_POLICY, "删除休假策略");

            return true;
        }

        /// <summary>
        /// 获取休假策略的休假策略类别
        /// </summary>
        /// <param name="policyId"></param>
        /// <returns></returns>
        public List<tst_timeoff_policy_item> GetPolicyItemByPolicyId(long policyId)
        {
            if (policyId == 0)      // 新增休假策略
            {
                List<tst_timeoff_policy_item> items = new List<tst_timeoff_policy_item>();
                items.Add(new tst_timeoff_policy_item { cate_id = 35 });
                items.Add(new tst_timeoff_policy_item { cate_id = 25 });
                items.Add(new tst_timeoff_policy_item { cate_id = 23 });
                items.Add(new tst_timeoff_policy_item { cate_id = 27 });

                return items;
            }
            else
            {
                return dal.FindListBySql<tst_timeoff_policy_item>($"select * from tst_timeoff_policy_item where timeoff_policy_id={policyId} and delete_time=0 order by cate_id asc");
            }
        }

        /// <summary>
        /// 新增休假策略关联员工
        /// </summary>
        /// <param name="resIds">员工id列表</param>
        /// <param name="policyId">休假策略id</param>
        /// <param name="effDate">生效日期</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddTimeoffResource(string resIds, long policyId, DateTime effDate, long userId)
        {
            tst_timeoff_policy_resource_dal plcResDal = new tst_timeoff_policy_resource_dal();
            bool addUpdate = false; // 是否有新增/更新操作
            var policyResList = plcResDal.FindListBySql($"select * from tst_timeoff_policy_resource where timeoff_policy_id={policyId} and delete_time=0 and resource_id in({resIds})");
            var resList = resIds.Split(',');
            foreach (var resId in resList)
            {
                var policyRes = policyResList.Find(_ => _.resource_id.ToString().Equals(resId));
                if (policyRes == null)  
                {
                    policyRes = new tst_timeoff_policy_resource();
                    policyRes.id = plcResDal.GetNextIdCom();
                    policyRes.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    policyRes.create_user_id = userId;
                    policyRes.update_time = policyRes.create_time;
                    policyRes.update_user_id = userId;
                    policyRes.effective_date = effDate;
                    policyRes.timeoff_policy_id = policyId;
                    policyRes.resource_id = long.Parse(resId);
                    plcResDal.Insert(policyRes);
                    OperLogBLL.OperLogAdd<tst_timeoff_policy_resource>(policyRes, policyRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "新增休假策略关联员工");
                    addUpdate = true;
                }
                else    // 该员工已关联当前休假策略，判断生效日期，生效日期提前则更新
                {
                    if (effDate > policyRes.effective_date)
                    {
                        tst_timeoff_policy_resource policyResOld = plcResDal.FindById(policyRes.id);
                        policyRes.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        policyRes.update_user_id = userId;
                        policyRes.effective_date = effDate;
                        plcResDal.Update(policyRes);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_policy_resource>(policyResOld, policyRes), policyRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "编辑休假策略关联员工");
                        addUpdate = true;
                    }
                }
            }

            return addUpdate;
        }

        /// <summary>
        /// 取消关联休假策略关联员工
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteTimeoffResource(long id, long userId)
        {
            tst_timeoff_policy_resource_dal plcResDal = new tst_timeoff_policy_resource_dal();
            var tr = plcResDal.FindById(id);
            if (tr == null)
                return false;
            tr.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            tr.delete_user_id = userId;
            plcResDal.Update(tr);
            OperLogBLL.OperLogDelete<tst_timeoff_policy_resource>(tr, tr.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "删除休假策略关联员工");
            return true;
        }

        /// <summary>
        /// 新增假期策略级别
        /// </summary>
        /// <param name="tier"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddTimeoffItemTier(tst_timeoff_policy_item_tier tier, long userId)
        {
            tst_timeoff_policy_item_tier_dal tierDal = new tst_timeoff_policy_item_tier_dal();
            tier.id = tierDal.GetNextIdCom();
            tier.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            tier.update_time = tier.create_time;
            tier.create_user_id = userId;
            tier.update_user_id = userId;
            tierDal.Insert(tier);
            OperLogBLL.OperLogAdd<tst_timeoff_policy_item_tier>(tier, tier.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "新增假期策略级别");
            return true;
        }

        /// <summary>
        /// 删除假期策略级别
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteTimeoffItemTier(long id, long userId)
        {
            tst_timeoff_policy_item_tier_dal tierDal = new tst_timeoff_policy_item_tier_dal();
            var tier = tierDal.FindById(id);
            if (tier == null)
                return false;
            tier.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            tier.delete_user_id = userId;
            tierDal.Update(tier);
            OperLogBLL.OperLogDelete<tst_timeoff_policy_item_tier>(tier, id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "删除假期策略级别");
            return true;
        }

        /// <summary>
        /// 根据员工和日期获取相关的休假时长
        /// </summary>
        public List<tst_timeoff_request> GetTimeOffByResDate(long resId, DateTime date)
        {
            return dal.FindListBySql<tst_timeoff_request>($"SELECT * from tst_timeoff_request where delete_time = 0 and resource_id = {resId} and request_date = '{date.ToString("yyyy-MM-dd")}'");
        }
    }
}
