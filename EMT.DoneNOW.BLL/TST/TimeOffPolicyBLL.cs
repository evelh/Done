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
        /// 获取一个休假策略关联的员工个数
        /// </summary>
        /// <param name="timeoffPolicyId"></param>
        /// <returns></returns>
        public int GetTierResourceCnt(long timeoffPolicyId)
        {
            return dal.FindSignleBySql<int>($"select count(0) from tst_timeoff_policy_resource where timeoff_policy_id={timeoffPolicyId} and delete_time=0");
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

            if (resAss != null && resAss.items.Count > 0)
            {
                tst_timeoff_policy_resource_dal resDal = new tst_timeoff_policy_resource_dal();
                foreach (var itm in resAss.items)
                {
                    AddTimeoffResource(itm.resourceId, policy.id, itm.effBeginDate, userId);
                }
            }

            return true;
        }

        /// <summary>
        /// 编辑休假策略
        /// </summary>
        /// <param name="policy"></param>
        /// <param name="items"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditPolicy(tst_timeoff_policy policy, List<tst_timeoff_policy_item> items, long userId)
        {
            var plcy = dal.FindById(policy.id);
            var plcyOld = dal.FindById(policy.id);
            plcy.name = policy.name;
            plcy.description = policy.description;
            plcy.is_active = policy.is_active;
            plcy.is_default = policy.is_default;

            var desc = OperLogBLL.CompareValue<tst_timeoff_policy>(plcyOld, plcy);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(plcy);
                OperLogBLL.OperLogUpdate(desc, plcy.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_POLICY, "编辑休假策略");
            }

            tst_timeoff_policy_item_dal itemDal = new tst_timeoff_policy_item_dal();
            tst_timeoff_policy_item_tier_dal tierDal = new tst_timeoff_policy_item_tier_dal();
            foreach (var itm in items)
            {
                var item = itemDal.FindSignleBySql<tst_timeoff_policy_item>($"select * from tst_timeoff_policy_item where timeoff_policy_id={policy.id} and cate_id={itm.cate_id} and delete_time=0");
                if (item == null)
                {
                    item = new tst_timeoff_policy_item();
                    item.cate_id = itm.cate_id;
                    item.task_id = itm.cate_id;
                    item.accrual_period_type_id = itm.accrual_period_type_id;
                    item.id = itemDal.GetNextIdCom();
                    item.timeoff_policy_id = policy.id;
                    item.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    item.update_time = item.create_time;
                    item.create_user_id = userId;
                    item.update_user_id = userId;
                    itemDal.Insert(item);
                    OperLogBLL.OperLogAdd<tst_timeoff_policy_item>(item, item.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM, "新增假期策略类别");
                }
                if (item.accrual_period_type_id != itm.accrual_period_type_id)
                {
                    var itemOld = itemDal.FindById(item.id);
                    item.accrual_period_type_id = itm.accrual_period_type_id;
                    item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    item.update_user_id = userId;
                    desc = OperLogBLL.CompareValue<tst_timeoff_policy_item>(itemOld, item);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        itemDal.Update(item);
                        OperLogBLL.OperLogUpdate(desc, item.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM, "编辑休假策略类别");

                        var tierList = tierDal.FindListBySql($"select * from tst_timeoff_policy_item_tier where timeoff_policy_item_id={item.id} and delete_time=0");
                        foreach (var itemTier in tierList)
                        {
                            if (itemTier.annual_hours != null)
                            {
                                var tierOld = tierDal.FindById(itemTier.id);

                                if (itm.accrual_period_type_id == null)
                                    itemTier.hours_accrued_per_period = null;
                                else if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DAY)
                                    itemTier.hours_accrued_per_period = itemTier.annual_hours / 365;
                                else if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.WEEK)
                                    itemTier.hours_accrued_per_period = itemTier.annual_hours / 52;
                                else if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK)
                                    itemTier.hours_accrued_per_period = itemTier.annual_hours / 26;
                                else if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH)
                                    itemTier.hours_accrued_per_period = itemTier.annual_hours / 24;
                                else if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.MONTH)
                                    itemTier.hours_accrued_per_period = itemTier.annual_hours / 12;

                                itemTier.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                itemTier.update_user_id = userId;

                                desc = OperLogBLL.CompareValue<tst_timeoff_policy_item_tier>(tierOld, itemTier);
                                if (!string.IsNullOrEmpty(desc))
                                {
                                    tierDal.Update(itemTier);
                                    OperLogBLL.OperLogUpdate(desc, itemTier.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "编辑休假策略级别");
                                }
                            }
                        }
                    }
                }
            }

            return true;
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
            List<tst_timeoff_policy_item> items = new List<tst_timeoff_policy_item>();
            if (policyId != 0)
            {
                items = dal.FindListBySql<tst_timeoff_policy_item>($"select * from tst_timeoff_policy_item where timeoff_policy_id={policyId} and delete_time=0 order by cate_id asc");
            }

            List<tst_timeoff_policy_item> rtn = new List<tst_timeoff_policy_item>();
            SysSettingBLL setBll = new SysSettingBLL();
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_PERSONAL) == "1")
            {
                var find = items.Find(_ => _.cate_id == (int)CostCode.Personal);
                if (find == null)
                {
                    rtn.Add(new tst_timeoff_policy_item
                    {
                        id = 0,
                        cate_id = (int)CostCode.Personal
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_VACATION) == "1")
            {
                var find = items.Find(_ => _.cate_id == (int)CostCode.Vacation);
                if (find == null)
                {
                    rtn.Add(new tst_timeoff_policy_item
                    {
                        id = 0,
                        cate_id = (int)CostCode.Vacation
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_SICK) == "1")
            {
                var find = items.Find(_ => _.cate_id == (int)CostCode.Sick);
                if (find == null)
                {
                    rtn.Add(new tst_timeoff_policy_item
                    {
                        id = 0,
                        cate_id = (int)CostCode.Sick
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_FLOAT) == "1")
            {
                var find = items.Find(_ => _.cate_id == (int)CostCode.Floating);
                if (find == null)
                {
                    rtn.Add(new tst_timeoff_policy_item
                    {
                        id = 0,
                        cate_id = (int)CostCode.Floating
                    });
                }
                else
                    rtn.Add(find);
            }

            return rtn;
        }

        /// <summary>
        /// 检查用户关联的休假策略是否有日期重复
        /// </summary>
        /// <param name="resIds"></param>
        /// <param name="effDate"></param>
        /// <returns></returns>
        public string AddTimeoffResourceCheck(string resIds, DateTime effDate)
        {
            tst_timeoff_policy_resource_dal plcResDal = new tst_timeoff_policy_resource_dal();
            var policyResList = plcResDal.FindListBySql($"select * from tst_timeoff_policy_resource where resource_id in({resIds}) and delete_time=0");
            var resList = resIds.Split(',');
            string names = "";
            foreach (var resId in resList)
            {
                var policyRes = policyResList.Find(_ => _.resource_id.ToString().Equals(resId) && _.effective_date == effDate);
                if (policyRes != null)
                {
                    var name = new UserResourceBLL().GetResourceById(policyRes.resource_id).name;
                    if (names == "")
                        names = name;
                    else
                        names += "," + name;
                }
            }
            if (names != "")
                names = "员工" + names + "已在该日期关联休假策略，此关联将不会生效";

            return names;
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
            var policyResList = plcResDal.FindListBySql($"select * from tst_timeoff_policy_resource where resource_id in({resIds}) and delete_time=0");
            var resList = resIds.Split(',');
            foreach (var resId in resList)
            {
                var policyRes = policyResList.Find(_ => _.resource_id.ToString().Equals(resId) && _.effective_date == effDate);
                if (policyRes != null)  // 该员工该日期已关联休假策略
                    continue;

                policyRes = policyResList.Find(_ => _.resource_id.ToString().Equals(resId) && _.timeoff_policy_id == policyId);
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

                    RecalcResTimeoffActBalance(policyRes.resource_id, effDate, userId);
                    //CalcResTimeoffActivity(long.Parse(resId), userId);
                }
                else    // 该员工已关联当前休假策略，判断生效日期，生效日期提前则更新
                {
                    if (effDate < policyRes.effective_date)
                    {
                        tst_timeoff_policy_resource policyResOld = plcResDal.FindById(policyRes.id);
                        policyRes.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        policyRes.update_user_id = userId;
                        policyRes.effective_date = effDate;
                        plcResDal.Update(policyRes);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_policy_resource>(policyResOld, policyRes), policyRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "编辑休假策略关联员工");
                        addUpdate = true;

                        RecalcResTimeoffActBalance(policyRes.resource_id, effDate, userId);
                        //CalcResTimeoffActivity(long.Parse(resId), userId);
                    }
                }
            }

            return addUpdate;
        }

        /// <summary>
        /// 新增编辑用户关联的休假策略
        /// </summary>
        /// <param name="assId">关联id，新增则为0</param>
        /// <param name="resId"></param>
        /// <param name="policyId"></param>
        /// <param name="effDate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddEditTimeoffResource(long assId, long resId, long policyId, DateTime effDate, long userId)
        {
            tst_timeoff_policy_resource_dal plcResDal = new tst_timeoff_policy_resource_dal();
            tst_timeoff_policy_resource policyRes;
            var policyResFind = plcResDal.FindSignleBySql<tst_timeoff_policy_resource>($"select * from tst_timeoff_policy_resource where resource_id={resId} and timeoff_policy_id={policyId} and delete_time=0");
            if (assId == 0 && policyResFind == null)    // 当前员工未关联此休假策略
            {
                policyRes = new tst_timeoff_policy_resource();
                policyRes.id = plcResDal.GetNextIdCom();
                policyRes.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                policyRes.create_user_id = userId;
                policyRes.update_time = policyRes.create_time;
                policyRes.update_user_id = userId;
                policyRes.effective_date = effDate;
                policyRes.timeoff_policy_id = policyId;
                policyRes.resource_id = resId;
                plcResDal.Insert(policyRes);
                OperLogBLL.OperLogAdd<tst_timeoff_policy_resource>(policyRes, policyRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "新增休假策略关联员工");
                
                RecalcResTimeoffActBalance(policyRes.resource_id, effDate, userId);
            }
            else
            {
                if (assId == 0)
                    policyRes = policyResFind;
                else
                    policyRes = plcResDal.FindById(assId);

                if (effDate < policyRes.effective_date) // 判断生效日期，生效日期提前则更新
                {
                    tst_timeoff_policy_resource policyResOld = plcResDal.FindById(policyRes.id);
                    policyRes.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    policyRes.update_user_id = userId;
                    policyRes.effective_date = effDate;
                    plcResDal.Update(policyRes);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_policy_resource>(policyResOld, policyRes), policyRes.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_RESOURCE, "编辑休假策略关联员工");
                    
                    RecalcResTimeoffActBalance(policyRes.resource_id, effDate, userId);
                }
            }

            return true;
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

            RecalcResTimeoffActBalance(tr.resource_id, tr.effective_date, userId);

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

            // 计算每周期时间
            if (tier.annual_hours != null)
            {
                var itm = new tst_timeoff_policy_item_dal().FindById(tier.timeoff_policy_item_id);
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DAY)
                    tier.hours_accrued_per_period = tier.annual_hours.Value / 365;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.WEEK)
                    tier.hours_accrued_per_period = tier.annual_hours.Value / 52;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK)
                    tier.hours_accrued_per_period = tier.annual_hours.Value / 26;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH)
                    tier.hours_accrued_per_period = tier.annual_hours.Value / 24;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.MONTH)
                    tier.hours_accrued_per_period = tier.annual_hours.Value / 12;
            }

            tierDal.Insert(tier);
            OperLogBLL.OperLogAdd<tst_timeoff_policy_item_tier>(tier, tier.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "新增假期策略级别");
            return true;
        }

        /// <summary>
        /// 编辑假期策略级别
        /// </summary>
        /// <param name="tier"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditTimeoffItemTier(tst_timeoff_policy_item_tier tier, long userId)
        {
            tst_timeoff_policy_item_tier_dal tierDal = new tst_timeoff_policy_item_tier_dal();
            tst_timeoff_policy_item_tier tr = tierDal.FindById(tier.id);
            tst_timeoff_policy_item_tier trOld = tierDal.FindById(tier.id);

            tr.annual_hours = tier.annual_hours;
            tr.cap_hours = tier.cap_hours;
            tr.eligible_starting_months = tier.eligible_starting_months;
            tr.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            tr.update_user_id = userId;

            // 总时间有变化，重新计算每周期时间
            if (tier.annual_hours != null && tier.annual_hours != trOld.annual_hours)
            {
                var itm = new tst_timeoff_policy_item_dal().FindById(tr.timeoff_policy_item_id);
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DAY)
                    tr.hours_accrued_per_period = tr.annual_hours.Value / 365;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.WEEK)
                    tr.hours_accrued_per_period = tr.annual_hours.Value / 52;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK)
                    tr.hours_accrued_per_period = tr.annual_hours.Value / 26;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH)
                    tr.hours_accrued_per_period = tr.annual_hours.Value / 24;
                if (itm.accrual_period_type_id == (int)DicEnum.TIMEOFF_PERIOD_TYPE.MONTH)
                    tr.hours_accrued_per_period = tr.annual_hours.Value / 12;
            }
            else if (tier.annual_hours == null)
                tr.hours_accrued_per_period = null;

            var desc = OperLogBLL.CompareValue<tst_timeoff_policy_item_tier>(trOld, tr);
            if (!string.IsNullOrEmpty(desc))
            {
                tierDal.Update(tr);
                OperLogBLL.OperLogUpdate(desc, tr.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_ITEM_TIER, "编辑假期策略级别");
            }
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
        /// 获取假期策略级别
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public tst_timeoff_policy_item_tier GetTimeoffItemTier(long id)
        {
            return new tst_timeoff_policy_item_tier_dal().FindById(id);
        }

        /// <summary>
        /// 获取休假策略类别
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public tst_timeoff_policy_item GetTimeoffItem(long id)
        {
            return new tst_timeoff_policy_item_dal().FindById(id);
        }

        /// <summary>
        /// 更新指定员工指定日期（包含）之后的假期余额表的余额
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="date"></param>
        /// <param name="cate">请假类型</param>
        /// <returns></returns>
        public void UpdateTimeoffBalance(long resId, DateTime date, CostCode cate)
        {
            new tst_timeoff_balance_dal().ReCalcResourceTimeoffBalance(resId, cate, date);
            //tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            //decimal balance = GetBalanceHour(resId, date);
            //string ids = GetUpdateBalanceActIds(resId, date);
            //if (!string.IsNullOrEmpty(ids))
            //{
            //    if (changeHour > 0)
            //        dal.ExecuteSQL($"update tst_timeoff_balance set balance=balance+{changeHour} where object_id in({ids})");
            //    else
            //        dal.ExecuteSQL($"update tst_timeoff_balance set balance=balance-{0 - changeHour} where object_id in({ids})");
            //}

            //return balance;
        }

        /// <summary>
        /// 获取员工在一个时间点的休假余额
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        private decimal GetBalanceHour(long resId, DateTime date)
        {
            string sql = $"SELECT balance FROM v_timeoff_activity_summary WHERE resource_id ={resId} and activity_date<= '{date.ToString("yyyy-MM-dd mm:ss")}' ORDER BY activity_date DESC, id DESC LIMIT 1";
            var balance = dal.FindSignleBySql<string>(sql);
            decimal bal;
            if (decimal.TryParse(balance, out bal))
                return bal;
            else
                return 0;
        }

        /// <summary>
        /// 获取员工在一个时间点需要更新的休假余额对象id
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="date"></param>
        /// <returns>,号分割的假期余额表object_id</returns>
        private string GetUpdateBalanceActIds(long resId, DateTime date)
        {
            string ids = "";
            var idList= dal.FindListBySql<string>($"SELECT entity_id FROM v_timeoff_activity_request WHERE resource_id={resId} and activity_date>'{date.ToString("yyyy-MM-dd mm:ss")}'");
            foreach (var id in idList)
            {
                ids += id + ",";
            }
            if (!string.IsNullOrEmpty(ids))
                ids = ids.Remove(ids.Length - 1, 1);

            return ids;
        }

        /// <summary>
        /// 重新计算用户的假期分配和余额
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="effDate">重新计算的生效日期</param>
        /// <param name="userId"></param>
        public void RecalcResTimeoffActBalance(long resId, DateTime effDate, long userId)
        {
            dal.ReCalcResourceTimeoffActivityBalance(resId, effDate);
        }

        /// <summary>
        /// 计算假期分配
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="userId"></param>
        private void CalcResTimeoffActivity(long resId, long userId)
        {
            List<tst_timeoff_policy_resource> resPolicyList = dal.FindListBySql<tst_timeoff_policy_resource>($"select * from tst_timeoff_policy_resource where resource_id={resId} and delete_time=0 order by effective_date asc");
            if (resPolicyList.Count == 0)
                return;
            var res = new UserResourceBLL().GetResourceById(resId);
            
            for (int i = 0; i < resPolicyList.Count;i++)
            {
                DateTime start, end;
                start = resPolicyList[i].effective_date;
                if (i == resPolicyList.Count - 1)
                    end = DateTime.MaxValue;
                else
                    end = resPolicyList[i + 1].effective_date.AddDays(-1);

                CalcResTimeoffActivityOnePolicy(resPolicyList[i].id, resId, start, end, res.hire_date.Value, userId);
            }
        }

        /// <summary>
        /// 计算员工一个休假策略的假期分配
        /// </summary>
        /// <param name="policyId"></param>
        /// <param name="resId"></param>
        /// <param name="start"></param>
        /// <param name="end"></param>
        /// <param name="hireDate"></param>
        /// <param name="userId"></param>
        private void CalcResTimeoffActivityOnePolicy(long policyId, long resId, DateTime start, DateTime end, DateTime hireDate, long userId)
        {
            var policy = dal.FindById(policyId);
            if (policy == null || policy.is_active == 0 || policy.delete_time > 0)
                return;

            if (end == DateTime.MaxValue)
                end = new DateTime(start.Year, 12, 31);

            decimal balHour = decimal.MinValue;

            tst_timeoff_activity_dal actDal = new tst_timeoff_activity_dal();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            var items = dal.FindListBySql<tst_timeoff_policy_item>($"select * from tst_timeoff_policy_item where timeoff_policy_id={policyId} and delete_time=0");
            foreach (var item in items)
            {
                if (item.accrual_period_type_id == null)
                    continue;

                DateTime actTime = start;
                var tiers = dal.FindListBySql<tst_timeoff_policy_item_tier>($"select * from tst_timeoff_policy_item_tier where timeoff_policy_item_id={item.id} and delete_time=0");
                foreach (var tier in tiers)
                {
                    // 入职起始月后开始有假期
                    if (tier.eligible_starting_months > 0)
                        actTime = start.AddMonths(tier.eligible_starting_months);
                    if (actTime > end)
                        continue;

                    bool calcFirstPeriod = false;
                    while (actTime <= end)
                    {
                        DateTime pend;
                        decimal percent = 1;
                        if (calcFirstPeriod)
                        {
                            pend = GetNextPeriodStart(actTime, (DicEnum.TIMEOFF_PERIOD_TYPE)item.accrual_period_type_id);
                            if (pend > end.AddDays(1))
                            {
                                percent = percent * ((end - actTime).Days + 1) / (pend - actTime).Days;
                                pend = end.AddDays(1);
                            }
                        }
                        else
                        {
                            pend = GetSecondPeriodStart(actTime, (DicEnum.TIMEOFF_PERIOD_TYPE)item.accrual_period_type_id, out percent);
                            calcFirstPeriod = true;
                            if (pend > end.AddDays(1))
                            {
                                percent = percent * ((end - actTime).Days + 1) / (pend - actTime).Days;
                                pend = end.AddDays(1);
                            }
                        }

                        tst_timeoff_activity act = new tst_timeoff_activity();
                        act.id = actDal.GetNextIdCom();
                        act.resource_id = resId;
                        act.task_id = (long)item.task_id;
                        act.activity_time = Tools.Date.DateHelper.ToUniversalTimeStamp(actTime);
                        act.timeoff_policy_item_tier_id = tier.id;
                        act.type_id = 2204;
                        act.hours = decimal.Round(tier.hours_accrued_per_period.Value * percent, 4);
                        actDal.Insert(act);

                        tst_timeoff_balance bal = new tst_timeoff_balance();
                        if (balHour == decimal.MinValue)
                        {
                            tst_timeoff_balance pre = balDal.FindSignleBySql<tst_timeoff_balance>($"select * from tst_timeoff_balance where resource_id={resId} order by id desc limit 1");
                            if (pre == null)
                                balHour = 0;
                            else
                                balHour = pre.balance;
                        }
                        bal.object_id = act.id;
                        bal.object_type_id = 2216;
                        bal.task_id = act.task_id;
                        bal.balance = balHour + act.hours;
                        balDal.Insert(bal);

                        actTime = pend;
                    }
                }
            }
        }

        /// <summary>
        /// 计算下个周期的开始日期
        /// </summary>
        /// <param name="start"></param>
        /// <param name="periodType"></param>
        /// <returns></returns>
        private DateTime GetNextPeriodStart(DateTime start, DicEnum.TIMEOFF_PERIOD_TYPE periodType)
        {
            switch (periodType)
            {
                case DicEnum.TIMEOFF_PERIOD_TYPE.MONTH:
                    return start.AddMonths(1);
                case DicEnum.TIMEOFF_PERIOD_TYPE.DAY:
                    return start.AddDays(1);
                case DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK:
                    return start.AddDays(14);
                case DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH:
                    if (start.Day == 1)
                        return new DateTime(start.Year, start.Month, (start.AddMonths(1).AddDays(-1).Day / 2) + 1);
                    else
                        return start.AddDays(1 - start.Day).AddMonths(1);
                case DicEnum.TIMEOFF_PERIOD_TYPE.WEEK:
                    return start.AddDays(7);
                default:
                    return start;
            }
        }

        /// <summary>
        /// 计算第二个周期开始日期
        /// </summary>
        /// <param name="start"></param>
        /// <param name="periodType"></param>
        /// <param name="percent">第一个周期占整周期的比例（8位精度）</param>
        /// <returns></returns>
        private DateTime GetSecondPeriodStart(DateTime start, DicEnum.TIMEOFF_PERIOD_TYPE periodType, out decimal percent)
        {
            DateTime nxtStart;
            percent = 1;
            switch (periodType)
            {
                case DicEnum.TIMEOFF_PERIOD_TYPE.MONTH:
                    nxtStart = start.AddDays(1 - start.Day).AddMonths(1);
                    percent = decimal.Round(((nxtStart.AddDays(-1).Day - start.Day + 1) / nxtStart.AddDays(-1).Day), 8);
                    return nxtStart;
                case DicEnum.TIMEOFF_PERIOD_TYPE.DAY:
                    return start.AddDays(1);
                case DicEnum.TIMEOFF_PERIOD_TYPE.DOUBLE_WEEK:
                    int days = start.DayOfYear;
                    days = (days - 1) % 14;
                    percent = decimal.Round((14 - days) / 14, 8);
                    return start.AddDays(14 - days);
                case DicEnum.TIMEOFF_PERIOD_TYPE.HALF_MONTH:
                    DateTime nextMonth = start.AddDays(1 - start.Day).AddMonths(1); // 下个月第一天
                    int crtMonthDays = nextMonth.AddDays(-1).Day;   // 该月有几天
                    int halfMonthDay = crtMonthDays / 2;
                    if (start.Day <= halfMonthDay)  // 上半月
                    {
                        percent = decimal.Round((halfMonthDay - start.Day + 1) / halfMonthDay, 8);
                        return new DateTime(start.Year, start.Month, halfMonthDay + 1);
                    }
                    else    // 下半月
                    {
                        percent = decimal.Round((crtMonthDays - start.Day + 1) / (crtMonthDays - halfMonthDay), 8);
                        return new DateTime(nextMonth.Year, nextMonth.Month, 1);
                    }
                case DicEnum.TIMEOFF_PERIOD_TYPE.WEEK:
                    days = start.DayOfYear;
                    days = (days - 1) % 7;
                    percent = decimal.Round((7 - days) / 7, 8);
                    return start.AddDays(7 - days);
                default:
                    return start;
            }
        }


        #region 休假请求
        /// <summary>
        /// 新增休假请求
        /// </summary>
        /// <param name="req">休假请求参数</param>
        /// <param name="startDate">休假开始日期</param>
        /// <param name="endDate">休假结束日期</param>
        /// <param name="onlyWorkday">是否只休工作日</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddTimeoffRequest(tst_timeoff_request req, DateTime startDate, DateTime endDate, bool onlyWorkday, long userId)
        {
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            tst_timeoff_request_dal rqDal = new tst_timeoff_request_dal();
            long batchId = rqDal.GetNextId("seq_entry_batch");
            var bll = new WorkEntryBLL();
            var approverList = bll.GetApproverList(userId);  // 该员工的审批人列表
            List<sdk_work_entry_report> reportList = null;
            if (approverList.Exists(_ => _.approver_resource_id == userId && _.tier == 1))
                reportList = bll.GetWorkEntryReportListByDate(startDate, endDate, userId);

            while (startDate <= endDate)
            {
                // 排除周末
                if (onlyWorkday && (startDate.DayOfWeek == DayOfWeek.Saturday || startDate.DayOfWeek == DayOfWeek.Sunday))
                {
                    startDate = startDate.AddDays(1);
                    continue;
                }

                tst_timeoff_request rq = new tst_timeoff_request
                {
                    resource_id = userId,
                    task_id = req.task_id,
                    status_id = (int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT,
                    request_hours = req.request_hours,
                    request_reason = req.request_reason,
                    request_date = startDate,
                    batch_id = batchId
                };
                rq.id = rqDal.GetNextIdCom();
                rq.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                rq.update_time = rq.create_time;
                rq.update_user_id = userId;
                rq.create_user_id = userId;

                rqDal.Insert(rq);
                OperLogBLL.OperLogAdd<tst_timeoff_request>(rq, rq.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST, "新增休假请求");

                if (rq.task_id != (long)CostCode.Holiday)   // 修改休假余额
                {
                    UpdateTimeoffBalance(rq.resource_id, rq.request_date.Value, (CostCode)rq.task_id);
                    //tst_timeoff_balance bal = new tst_timeoff_balance();
                    //bal.object_id = rq.id;
                    //bal.object_type_id = 2215;
                    //bal.task_id = rq.task_id;
                    //bal.resource_id = rq.resource_id;
                    //bal.balance = balance + rq.request_hours;
                    //balDal.Insert(bal);
                }

                if (approverList.Exists(_ => _.approver_resource_id == userId && _.tier == 1))  // 该员工是自己的一级审批人
                {
                    var report = reportList.Find(_ => _.start_date != null && _.end_date != null && startDate >= _.start_date && startDate <= _.end_date);

                    if (report == null || report.status_id != (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND)   // 没有生成工时表或者不是提交状态，可以自动审批休假请求
                    {
                        tst_timeoff_request_log_dal logDal = new tst_timeoff_request_log_dal();
                        tst_timeoff_request_log rqLog = new tst_timeoff_request_log();
                        rqLog.id = logDal.GetNextIdCom();
                        rqLog.timeoff_request_id = rq.id;
                        rqLog.oper_user_id = userId;
                        rqLog.oper_type_id = (int)DicEnum.TIMEOFF_REQUEST_OPER.PASS;
                        rqLog.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        rqLog.tier = 1;
                        logDal.Insert(rqLog);
                        OperLogBLL.OperLogAdd<tst_timeoff_request_log>(rqLog, rqLog.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST_LOG, "新增休假自动审批");

                        if (!approverList.Exists(_ => _.tier == 2))     // 该员工只有一级审批人
                        {
                            var rqUpd = rqDal.FindById(rq.id);
                            var rqOld = rqDal.FindById(rq.id);
                            rqUpd.status_id = (int)DicEnum.TIMEOFF_REQUEST_STATUS.APPROVAL;
                            rqUpd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            rqUpd.update_user_id = userId;
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_request>(rqOld, rqUpd), rq.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST, "新增休假自动审批");

                            // 审批后生成工时
                            sdk_work_entry_dal weDal = new sdk_work_entry_dal();
                            sdk_work_entry we = new sdk_work_entry();
                            we.id = dal.GetNextIdCom();
                            we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            we.update_time = we.create_time;
                            we.create_user_id = userId;
                            we.update_user_id = userId;
                            we.task_id = rq.task_id;
                            we.resource_id = rq.resource_id;
                            we.cost_code_id = rq.task_id;
                            we.hours_billed = rq.request_hours;
                            we.hours_worked = rq.request_hours;
                            we.offset_hours = 0;
                            we.is_billable = 0;
                            we.show_on_invoice = 0;
                            we.batch_id = batchId;
                            we.timeoff_request_id = rq.id;
                            weDal.Insert(we);
                            OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "生成工时");
                        }
                    }

                }

                startDate = startDate.AddDays(1);
            }

            return true;
        }

        /// <summary>
        /// 取消休假请求
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool CancleTimeoffRequest(long id, long userId)
        {
            tst_timeoff_request_dal rqDal = new tst_timeoff_request_dal();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            var rq = rqDal.FindById(id);

            if (rq.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.CANCLE
                || rq.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.REFUSE)
                return false;

            if (rq.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.APPROVAL)
            {
                // 有对应工时，且工时已审批提交，则不能取消休假申请
                var we = rqDal.FindSignleBySql<sdk_work_entry>($"select * from sdk_work_entry where timeoff_request_id={rq.id} and delete_time=0 and approve_and_post_user_id is not null");
                if (we != null)
                    return false;

                if (we.hours_worked == rq.request_hours)
                {
                    we.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    we.delete_user_id = userId;
                    new sdk_work_entry_dal().Update(we);
                    OperLogBLL.OperLogDelete<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "删除工时");
                }
            }

            var rqOld = rqDal.FindById(id);
            rq.status_id = (int)DicEnum.TIMEOFF_REQUEST_STATUS.CANCLE;
            rq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            rq.update_user_id = userId;
            rqDal.Update(rq);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_request>(rqOld, rq), rq.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST, "取消休假请求");

            if (rq.task_id != (long)CostCode.Holiday)   // 修改休假余额
            {
                UpdateTimeoffBalance(rq.resource_id, rq.request_date.Value, (CostCode)rq.task_id);
                //var balance = UpdateTimeoffBalance(rq.resource_id, rq.request_date.Value, rq.request_hours);
                //balDal.ExecuteSQL($"delete from tst_timeoff_balance where object_id={rq.id}");
            }

            tst_timeoff_request_log log = new tst_timeoff_request_log();
            tst_timeoff_request_log_dal logDal = new tst_timeoff_request_log_dal();
            log.id = logDal.GetNextIdCom();
            log.timeoff_request_id = rq.id;
            log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            log.oper_type_id = (int)DicEnum.TIMEOFF_REQUEST_OPER.CANCLE;
            log.oper_user_id = userId;
            logDal.Insert(log);
            OperLogBLL.OperLogAdd<tst_timeoff_request_log>(log, log.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST_LOG, "取消休假请求记录");

            return true;
        }

        /// <summary>
        /// 审批批准休假请求
        /// </summary>
        /// <param name="ids">,号分割的多个休假请求id</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public int ApproveTimeoffRequest(string ids, long userId)
        {
            int appCnt = 0;
            var rqstDal = new tst_timeoff_request_dal();
            var logDal = new tst_timeoff_request_log_dal();
            var weDal = new sdk_work_entry_dal();
            var bll = new WorkEntryBLL();
            var requests = rqstDal.FindListBySql($"select * from tst_timeoff_request where id in({ids}) and status_id={(int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT} and delete_time=0");
            if (requests == null || requests.Count == 0)
                return appCnt;

            var user = new UserResourceBLL().GetResourceById(userId);
            foreach (var request in requests)
            {
                var reportList = bll.GetWorkEntryReportListByDate(request.request_date.Value, request.request_date.Value, requests[0].resource_id);
                if (reportList.Count != 0
                    && (reportList[0].status_id == (int)DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND
                    || reportList[0].status_id == (int)DicEnum.WORK_ENTRY_REPORT_STATUS.PAYMENT_BEEN_APPROVED))   // 已生成工时表且是提交或已审批状态，不能审批休假请求
                    continue;

                // 判断用户是否在当前可以审批休假请求
                int tier = GetTimeoffCurrentApproveTier(request.id);
                if (tier == 3)
                    continue;
                var aprvResList = bll.GetApproverList((long)request.resource_id);
                tier++;
                if (user.security_level_id == 1 || aprvResList.Exists(_ => _.tier == tier && _.approver_resource_id == userId)) // 用户可以审批下一级
                {
                    tst_timeoff_request_log log = new tst_timeoff_request_log();
                    log.id = logDal.GetNextIdCom();
                    log.timeoff_request_id = request.id;
                    log.oper_user_id = userId;
                    log.oper_type_id = (int)DicEnum.TIMEOFF_REQUEST_OPER.PASS;
                    log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    log.tier = tier;

                    logDal.Insert(log);
                    OperLogBLL.OperLogAdd<tst_timeoff_request_log>(log, log.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST_LOG, "休假请求审批");

                    appCnt++;
                    
                    if (aprvResList.Count == 0 || aprvResList.Max(_ => _.tier) == tier)
                    {

                        // 是最后一级审批人
                        var requestOld = rqstDal.FindById(request.id);
                        request.status_id = (int)DicEnum.TIMEOFF_REQUEST_STATUS.APPROVAL;
                        request.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        request.update_user_id = userId;
                        request.approved_resource_id = userId;
                        rqstDal.Update(request);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_request>(requestOld, request), request.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST, "休假请求审批");
                        

                        sdk_work_entry we = new sdk_work_entry();
                        we.id = weDal.GetNextIdCom();
                        we.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        we.update_time = we.create_time;
                        we.create_user_id = userId;
                        we.update_user_id = userId;
                        we.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(request.request_date.Value);
                        we.end_time = we.start_time;
                        we.task_id = request.task_id;
                        we.resource_id = request.resource_id;
                        we.cost_code_id = request.task_id;
                        we.hours_worked = request.request_hours;
                        we.hours_billed = request.request_hours;
                        we.offset_hours = 0;
                        we.is_billable = 0;
                        we.show_on_invoice = 0;
                        we.batch_id = (long)request.batch_id;
                        we.timeoff_request_id = request.id;
                        weDal.Insert(we);
                        OperLogBLL.OperLogAdd<sdk_work_entry>(we, we.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "审批休假请求创建工时");
                    }
                }
            }

            return appCnt;
        }

        /// <summary>
        /// 审批拒绝休假请求
        /// </summary>
        /// <param name="ids">,号分割的多个休假请求id</param>
        /// <param name="reason">拒绝原因</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool RejectTimeoffRequest(string ids, string reason, long userId)
        {
            var rqstDal = new tst_timeoff_request_dal();
            var logDal = new tst_timeoff_request_log_dal();
            var weDal = new sdk_work_entry_dal();
            tst_timeoff_balance_dal balDal = new tst_timeoff_balance_dal();
            var bll = new WorkEntryBLL();
            var requests = rqstDal.FindListBySql($"select * from tst_timeoff_request where id in({ids}) and status_id={(int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT} and delete_time=0");
            if (requests == null || requests.Count == 0)
                return false;

            var user = new UserResourceBLL().GetResourceById(userId);
            foreach (var request in requests)
            {
                // 判断用户是否在当前可以审批休假请求
                int tier = GetTimeoffCurrentApproveTier(request.id);
                if (tier == 3)
                    continue;
                var aprvResList = bll.GetApproverList((long)request.resource_id);
                tier++;
                if (user.security_level_id == 1 || aprvResList.Exists(_ => _.tier == tier && _.approver_resource_id == userId)) // 用户可以审批下一级
                {
                    var requestOld = rqstDal.FindById(request.id);
                    request.status_id = (int)DicEnum.TIMEOFF_REQUEST_STATUS.REFUSE;
                    request.approved_resource_id = userId;
                    request.reject_reason = reason;
                    request.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    request.update_user_id = userId;
                    rqstDal.Update(request);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<tst_timeoff_request>(requestOld, request), request.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST, "休假请求审批拒绝");

                    if (request.task_id != (long)CostCode.Holiday)   // 修改休假余额
                    {
                        UpdateTimeoffBalance(request.resource_id, request.request_date.Value, (CostCode)request.task_id);
                        //var balance = UpdateTimeoffBalance(request.resource_id, request.request_date.Value, request.request_hours);
                        //balDal.ExecuteSQL($"delete from tst_timeoff_balance where object_id={request.id}");
                    }

                    tst_timeoff_request_log log = new tst_timeoff_request_log();
                    log.id = logDal.GetNextIdCom();
                    log.timeoff_request_id = request.id;
                    log.oper_user_id = userId;
                    log.oper_type_id = (int)DicEnum.TIMEOFF_REQUEST_OPER.REJECT;
                    log.oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    log.tier = tier;

                    logDal.Insert(log);
                    OperLogBLL.OperLogAdd<tst_timeoff_request_log>(log, log.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TIMEOFF_REQUEST_LOG, "休假请求审批");
                }
            }

            return true;
        }

        /// <summary>
        /// 获取休假请假已审批的最高一级
        /// </summary>
        /// <param name="requestId"></param>
        /// <returns>0:未审批过、1、2、3</returns>
        public int GetTimeoffCurrentApproveTier(long requestId)
        {
            var log = dal.FindSignleBySql<tst_timeoff_request_log>($"select * from tst_timeoff_request_log where timeoff_request_id={requestId} order by tier desc limit 1 ");
            if (log == null)
                return 0;
            return log.tier;
        }

        /// <summary>
        /// 获取员工所有类型的休假汇总信息
        /// </summary>
        /// <param name="resourceId"></param>
        /// <param name="year"></param>
        /// <returns></returns>
        public List<v_timeoff_total> GetResourceTimeoffTotal(long resourceId, int year)
        {
            var list = new v_timeoff_total_dal().GetResourceTimeoffTotal(resourceId, year);

            var rtn = new List<v_timeoff_total>();
            SysSettingBLL setBll = new SysSettingBLL();
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_FLOAT) == "1")
            {
                var find = list.Find(_ => _.task_id == (long)CostCode.Floating);
                if (find == null)
                {
                    rtn.Add(new v_timeoff_total
                    {
                        task_id = (long)CostCode.Floating
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_PERSONAL) == "1")
            {
                var find = list.Find(_ => _.task_id == (long)CostCode.Personal);
                if (find == null)
                {
                    rtn.Add(new v_timeoff_total
                    {
                        task_id = (long)CostCode.Personal
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_SICK) == "1")
            {
                var find = list.Find(_ => _.task_id == (long)CostCode.Sick);
                if (find == null)
                {
                    rtn.Add(new v_timeoff_total
                    {
                        task_id = (long)CostCode.Sick
                    });
                }
                else
                    rtn.Add(find);
            }
            if (setBll.GetValueById(SysSettingEnum.TIMEOFF_ALLOW_VACATION) == "1")
            {
                var find = list.Find(_ => _.task_id == (long)CostCode.Vacation);
                if (find == null)
                {
                    rtn.Add(new v_timeoff_total
                    {
                        task_id = (long)CostCode.Vacation
                    });
                }
                else
                    rtn.Add(find);
            }
            
            return rtn;
        }

        /// <summary>
        /// 获取一个员工在一年内的休假信息
        /// </summary>
        /// <param name="year"></param>
        /// <param name="resId"></param>
        /// <returns></returns>
        public List<TimeoffInfoDto> GetResourceTimeoffInfo(int year, long resId)
        {
            var list = dal.FindListBySql<TimeoffInfoDto>($"SELECT t.request_date as timeoffDate,GROUP_CONCAT(concat((select name from d_cost_code where id = t.task_id)," +
                $" '(', round(t.request_hours, 2), ') ', (select name from d_general where id = t.status_id)) SEPARATOR '<br />' )tooltip," +
                $"min(t.status_id)status_id FROM  tst_timeoff_request t where delete_time = 0 and resource_id = {resId} and year(request_date)={year} GROUP BY request_date");
            foreach (var to in list)
            {
                to.monthDay = to.timeoffDate.ToString("mmdd");
                if (to.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.COMMIT)
                    to.status = "已提交";
                else if (to.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.APPROVAL)
                    to.status = "已审批";
                else if (to.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.REFUSE)
                    to.status = "已拒绝";
                else if (to.status_id == (int)DicEnum.TIMEOFF_REQUEST_STATUS.CANCLE)
                    to.status = "取消";
            }

            return list;
        }
        #endregion

		/// <summary>
        /// 根据员工和日期获取相关的休假时长
        /// </summary>
        public List<tst_timeoff_request> GetTimeOffByResDate(long resId, DateTime date)
        {
            return dal.FindListBySql<tst_timeoff_request>($"SELECT * from tst_timeoff_request where delete_time = 0 and resource_id = {resId} and request_date = '{date.ToString("yyyy-MM-dd")}'");
        }

    }
}
