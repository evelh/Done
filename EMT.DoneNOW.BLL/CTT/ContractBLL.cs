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
    public class ContractBLL
    {
        private readonly ctt_contract_dal dal = new ctt_contract_dal();

        /// <summary>
        /// 合同相关字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            GeneralBLL genBll = new GeneralBLL();
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("cate", genBll.GetDicValues(GeneralTableEnum.CONTRACT_CATE));                   // 合同类别
            dic.Add("periodType", genBll.GetDicValues(GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE));    // 计费周期类型
            dic.Add("billPostType", genBll.GetDicValues(GeneralTableEnum.BILL_POST_TYPE));          // 工时计费设置
            dic.Add("chargeType", genBll.GetDicValues(GeneralTableEnum.CHARGE_TYPE));// 合同成本类型
            dic.Add("chargeStatus", genBll.GetDicValues(GeneralTableEnum.CHARGE_STATUS));

            return dic;// 
        }

        /// <summary>
        /// 根据合同id获取合同的编辑信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ContractEditDto GetContractEdit(long id)
        {
            ContractEditDto dto = new ContractEditDto();

            ctt_contract contract = dal.FindById(id);
            if (contract == null || contract.delete_time > 0)
                return null;

            dto.contract = contract;
            dto.accountName = new CompanyBLL().GetCompany(contract.account_id).name;
            if (contract.contact_id != null)
                dto.contactName = new ContactBLL().GetContact((long)contract.contact_id).name;
            else
                dto.contactName = "";

            if (contract.bill_to_account_id != null)
                dto.billToAccount = new CompanyBLL().GetCompany((long)contract.bill_to_account_id).name;
            else
                dto.billToAccount = "";

            if (contract.bill_to_contact_id != null)
                dto.billToContact = new ContactBLL().GetContact((long)contract.bill_to_contact_id).name;
            else
                dto.billToContact = "";

            if (contract.setup_fee_cost_code_id != null)
            {
                var costCode = new d_cost_code_dal().FindById((long)contract.setup_fee_cost_code_id);
                dto.costCode = costCode.name;
            }
            else
                dto.costCode = "";

            return dto;
        }

        /// <summary>
        /// 新增合同
        /// </summary>
        /// <param name="dto"></param>
        /// <param name="userId"></param>
        /// <returns>新增合同Id</returns>
        public long Insert(ContractAddDto dto, long userId)
        {
            // 新增合同
            dto.contract.id = dal.GetNextIdCom();
            dto.contract.create_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            dto.contract.create_user_id = userId;
            dto.contract.update_time = dto.contract.create_time;
            dto.contract.update_user_id = userId;
            dto.contract.status_id = 1; // 激活
            if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
            {
                if(dto.contract.occurrences!=null&&dto.contract.occurrences>0)
                {
                    if (dto.contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        dto.contract.end_date = dto.contract.start_date.AddMonths((int)(dto.contract.occurrences) * 6).AddDays(-1);
                    else if (dto.contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        dto.contract.end_date = dto.contract.start_date.AddMonths((int)(dto.contract.occurrences) * 1).AddDays(-1);
                    else if (dto.contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        dto.contract.end_date = dto.contract.start_date.AddMonths((int)(dto.contract.occurrences) * 3).AddDays(-1);
                    else if (dto.contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        dto.contract.end_date = dto.contract.start_date.AddMonths((int)(dto.contract.occurrences) * 12).AddDays(-1);
                    else
                        throw new Exception("新增合同，周期类型错误");
                }
            }
            dal.Insert(dto.contract);

            //var user = UserInfoBLL.GetUserInfo(userId);

            // 新增日志
            OperLogBLL.OperLogAdd<ctt_contract>(dto.contract, dto.contract.id, userId, OPER_LOG_OBJ_CATE.CONTRACT, "新增合同");

            // 合同自定义字段
            var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);  // 获取合同的自定义字段信息
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTRACTS, userId,
                dto.contract.id, udf_list, dto.udf, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION); // 保存合同自定义字段值

            // TODO: 邮件通知

            #region 不同合同类型不同处理
            if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
            {
                ctt_contract_service_dal serDal = new ctt_contract_service_dal();
                ivt_service_dal ivtSerDal = new ivt_service_dal();
                // 处理合同服务/服务包
                foreach (var ser in dto.serviceList)
                {
                    ctt_contract_service service = new ctt_contract_service();
                    service.id = serDal.GetNextIdCom();
                    service.contract_id = dto.contract.id;
                    service.object_type = 1;
                    service.object_id = ser.serviceId;
                    service.quantity = (int)ser.number;
                    service.unit_price = ser.price;
                    service.adjusted_price = ser.price * service.quantity;
                    service.unit_cost = ivtSerDal.FindById(ser.serviceId).unit_cost;
                    service.effective_date = dto.contract.start_date;
                    service.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    service.create_user_id = userId;
                    service.update_user_id = userId;
                    service.update_time = service.create_time;

                    serDal.Insert(service);

                    OperLogBLL.OperLogAdd<ctt_contract_service>(service, service.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "新增合同添加服务");
                }
            }
            else
            {
                if (dto.contract.type_id == (int)DicEnum.CONTRACT_TYPE.FIXED_PRICE)
                {
                    // 处理里程碑
                    if (dto.milestone != null && dto.milestone.Count > 0)
                    {
                        ctt_contract_milestone_dal milestoneDal = new ctt_contract_milestone_dal();
                        foreach (var mil in dto.milestone)
                        {
                            ctt_contract_milestone milestone = new ctt_contract_milestone();
                            milestone.name = mil.name;
                            milestone.dollars = mil.dollars;
                            milestone.due_date = mil.due_date;
                            milestone.cost_code_id = mil.cost_code_id;

                            milestone.id = milestoneDal.GetNextIdCom();
                            milestone.contract_id = dto.contract.id;
                            milestone.create_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            milestone.create_user_id = userId;
                            milestone.update_time = milestone.create_time;
                            milestone.update_user_id = userId;
                            milestoneDal.Insert(milestone);

                            // 新增日志
                            OperLogBLL.OperLogAdd<ctt_contract_milestone>(milestone, milestone.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "新增合同里程碑信息");
                        }
                    }
                }

                // 除定期服务合同和事件合同，处理角色费率
                if (dto.contract.type_id != (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
                {
                    ctt_contract_rate_dal rateDal = new ctt_contract_rate_dal();
                    foreach (var rate in dto.rateList)
                    {
                        ctt_contract_rate roleRate = new ctt_contract_rate();
                        roleRate.id = rateDal.GetNextIdCom();
                        roleRate.contract_id = dto.contract.id;
                        roleRate.role_id = rate.roleId;
                        roleRate.rate = rate.rate;
                        roleRate.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        roleRate.create_user_id = userId;
                        roleRate.update_time = roleRate.create_time;
                        roleRate.update_user_id = userId;

                        rateDal.Insert(roleRate);
                        OperLogBLL.OperLogAdd<ctt_contract_rate>(roleRate, roleRate.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_RATE, "新增合同角色费率");
                    }
                }
            }
            #endregion

            return dto.contract.id;
        }

        /// <summary>
        /// 编辑合同
        /// </summary>
        /// <param name="ct"></param>
        /// <param name="userId"></param>
        public void EditContract(ctt_contract ct, long userId)
        {
            var contract = dal.FindById(ct.id);
            var contractOld = dal.FindById(ct.id);

            contract.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contract.update_user_id = userId;
            contract.status_id = ct.status_id;
            contract.cate_id = ct.cate_id;
            contract.name = ct.name;
            contract.contact_id = ct.contact_id;
            contract.description = ct.description;
            contract.opportunity_id = ct.opportunity_id;
            contract.bill_post_type_id = ct.bill_post_type_id;
            contract.timeentry_need_begin_end = ct.timeentry_need_begin_end;
            contract.is_sdt_default = ct.is_sdt_default;
            contract.external_no = ct.external_no;
            contract.sla_id = ct.sla_id;
            contract.bill_to_account_id = ct.bill_to_account_id;
            contract.bill_to_contact_id = ct.bill_to_contact_id;
            contract.purchase_order_no = ct.purchase_order_no;
            if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)   // 服务合同
            {
                contract.setup_fee = ct.setup_fee;
                contract.setup_fee_cost_code_id = ct.setup_fee_cost_code_id;
                if (ct.occurrences == null)
                {
                    contract.occurrences = null;
                    contract.end_date = ct.end_date;
                }
                else
                {
                    contract.occurrences = ct.occurrences;

                    if (contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        contract.end_date = contract.start_date.AddMonths((int)(contract.occurrences) * 6).AddDays(-1);
                    else if (contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        contract.end_date = contract.start_date.AddMonths((int)(contract.occurrences) * 1).AddDays(-1);
                    else if (contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        contract.end_date = contract.start_date.AddMonths((int)(contract.occurrences) * 3).AddDays(-1);
                    else if (contract.period_type == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        contract.end_date = contract.start_date.AddMonths((int)(contract.occurrences) * 12).AddDays(-1);
                    else
                        throw new Exception("修改合同，周期类型错误");
                }

                // TODO: 修改合同，修改周期
            }
            else
            {
                contract.start_date = contract.start_date;
                contract.end_date = contract.end_date;
                contract.dollars = ct.dollars;
                contract.cost = ct.cost;
                contract.hours = ct.hours;
                if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                {
                    contract.enable_overage_billing_rate = ct.enable_overage_billing_rate;
                    contract.overage_billing_rate = ct.overage_billing_rate;
                }
                if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
                {
                    contract.overage_billing_rate = ct.overage_billing_rate;
                }
            }

            dal.Update(contract);
            OperLogBLL.OperLogUpdate<ctt_contract>(contract, contractOld, contract.id, userId, OPER_LOG_OBJ_CATE.CONTACTS, "修改合同");
        }

        #region 删除合同
        /// <summary>
        /// 删除合同
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteContract(long id, long userId)
        {
            ctt_contract contract = dal.FindById(id);

            // 判断是否可以删除，关联以下对象时不能被删除：项目、工单、配置项、合同成本、已计费条目、工时、taskfire（本期不实现 TODO:）
            int count = 0;
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM pro_project WHERE contract_id={id} AND delete_time=0");             // 项目
            if (count > 0)
                return false;
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM sdk_task WHERE contract_id={id} AND delete_time=0");                // 工单
            if (count > 0)
                return false;
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM crm_installed_product WHERE contract_id={id} AND delete_time=0");   // 配置项
            if (count > 0)
                return false;
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM ctt_contract_cost WHERE contract_id={id} AND delete_time=0");       // 合同成本
            if (count > 0)
                return false;   
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM crm_account_deduction WHERE contract_id={id} AND delete_time=0");   // 已计费条目
            if (count > 0)
                return false;
            count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM sdk_work_entry WHERE contract_id={id} AND delete_time=0");          // 工时
            if (count > 0)
                return false;

            new ContractBlockBLL().DeleteContractBlockByContractId(id, userId);     // 合同预付费用、合同成本
            new ContractServiceBLL().DeleteServiceByContractId(id, userId);         // 服务/服务包及调整和周期信息
            DeleteContractCostDefault(id, userId);      // 默认成本
            DeleteContractInternalCost(id, userId);     // 内部成本
            DeleteContractExclusionRole(id, userId);    // 不计费角色
            DeleteContractExclusionCode(id, userId);    // 例外因素
            DeleteContractMilestone(id, userId);        // 里程碑
            DeleteContractNotifyRule(id, userId);       // 通知规则

            contract.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contract.delete_user_id = userId;
            dal.Update(contract);
            OperLogBLL.OperLogDelete<ctt_contract>(contract, contract.id, userId, OPER_LOG_OBJ_CATE.CONTACTS, "删除合同");

            return true;
        }

        /// <summary>
        /// 删除对应id合同的默认成本
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractCostDefault(long contractId, long userId)
        {
            ctt_contract_cost_default_dal cdDal = new ctt_contract_cost_default_dal();
            while(true)
            {
                var entity = cdDal.GetSinCostDef(contractId);
                if (entity == null)
                    break;
                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                cdDal.Update(entity);
                OperLogBLL.OperLogDelete<ctt_contract_cost_default>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_DEFAULT_COST, "删除合同默认成本");
            }
        }

        /// <summary>
        /// 删除对应合同id的所有内部成本
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractInternalCost(long contractId, long userId)
        {
            ctt_contract_internal_cost_dal icDal = new ctt_contract_internal_cost_dal();
            var list = icDal.FindListByContractId(contractId);
            foreach(var entity in list)
            {
                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                icDal.Update(entity);

                OperLogBLL.OperLogDelete<ctt_contract_internal_cost>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_INTERNAL_COST, "删除合同内部成本");
            }
        }

        /// <summary>
        /// 删除对应合同id的所有不计费角色
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractExclusionRole(long contractId, long userId)
        {
            ctt_contract_exclusion_role_dal icDal = new ctt_contract_exclusion_role_dal();
            var list = icDal.FindListByContractId(contractId);
            foreach (var entity in list)
            {
                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                icDal.Update(entity);

                OperLogBLL.OperLogDelete<ctt_contract_exclusion_role>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_EXCLUSTION_ROLE, "删除合同不计费角色");
            }
        }

        /// <summary>
        /// 删除对应合同id的所有例外因素
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractExclusionCode(long contractId, long userId)
        {
            ctt_contract_exclusion_cost_code_dal icDal = new ctt_contract_exclusion_cost_code_dal();
            var list = icDal.FindListByContractId(contractId);
            foreach (var entity in list)
            {
                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                icDal.Update(entity);

                OperLogBLL.OperLogDelete<ctt_contract_exclusion_cost_code>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_EXCLUSTION_COST, "删除合同例外因素");
            }
        }

        /// <summary>
        /// 删除对应合同id的所有里程碑
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractMilestone(long contractId, long userId)
        {
            ctt_contract_milestone_dal icDal = new ctt_contract_milestone_dal();
            var list = icDal.FindListByContractId(contractId);
            foreach (var entity in list)
            {
                if (entity.status_id == (int)DicEnum.MILESTONE_STATUS.BILLED)   // 已计费的不删除
                    continue;

                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                icDal.Update(entity);

                OperLogBLL.OperLogDelete<ctt_contract_milestone>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "删除合同里程碑");
            }
        }

        /// <summary>
        /// 删除对应合同id的所有通知规则
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        private void DeleteContractNotifyRule(long contractId, long userId)
        {
            ctt_contract_notify_rule_dal icDal = new ctt_contract_notify_rule_dal();
            var list = icDal.FindListByContractId(contractId);
            foreach (var entity in list)
            {
                entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                entity.delete_user_id = userId;
                icDal.Update(entity);
            }
        }
        #endregion

        /// <summary>
        /// 合同类型值转换为合同类型
        /// </summary>
        /// <param name="typeId"></param>
        /// <returns></returns>
        public string GetContractTypeName(int typeId)
        {
            string contractTypeName = "";
            switch (typeId)
            {
                case 1199:
                    contractTypeName = "定期服务合同";
                    break;
                case 1200:
                    contractTypeName = "工时及物料合同";
                    break;
                case 1201:
                    contractTypeName = "固定价格合同";
                    break;
                case 1202:
                    contractTypeName = "预付时间合同";
                    break;
                case 1203:
                    contractTypeName = "预付费合同";
                    break;
                case 1204:
                    contractTypeName = "事件合同";
                    break;
                default:
                    contractTypeName = "";
                    break;
            }
            return contractTypeName;
        }

        /// <summary>
        /// 获取SLA列表
        /// </summary>
        /// <returns></returns>
        public List<d_sla> GetSLAList()
        {
            return new d_sla_dal().GetList();
        }

        /// <summary>
        /// 修改合同的一个自定义字段值
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="udfId"></param>
        /// <param name="value">修改的自定义字段值</param>
        /// <param name="desc">修改描述</param>
        /// <param name="userId"></param>
        public void EditUdf(long contractId, int udfId, string value, string desc, long userId)
        {
            // 更新自定义字段值
            var bll = new UserDefinedFieldsBLL();
            var udfList = bll.GetUdf(DicEnum.UDF_CATE.CONTRACTS);
            var udfValues = bll.GetUdfValue(DicEnum.UDF_CATE.CONTRACTS, contractId, udfList);
            var user = new UserResourceBLL().GetSysUserSingle(userId);
            int index = udfValues.FindIndex(f => f.id == udfId);
            object oldVal = udfValues[index].value;
            udfValues[index].value = value;

            bll.UpdateUdfValue(DicEnum.UDF_CATE.CONTRACTS, udfList, contractId, udfValues, 
                new UserInfoDto { id = userId, name = user.name }, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION);

            // 记录备注
            var contract = dal.FindById(contractId);
            com_activity_dal actDal = new com_activity_dal();
            com_activity act = new com_activity
            {
                id = actDal.GetNextIdCom(),
                cate_id = (int)ACTIVITY_CATE.CONTRACT_NOTE,
                action_type_id = (int)ACTIVITY_TYPE.CONTRACT_UDF_EDIT,
                parent_id = null,
                object_id = contractId,
                object_type_id = (int)OBJECT_TYPE.CONTRACT,
                account_id = contract.account_id,
                contact_id = contract.contact_id,
                resource_id = null,
                contract_id = contract.id,
                opportunity_id = contract.opportunity_id,
                ticket_id = null,
                start_date = 0,
                end_date = 0,
                description = udfList.Find(f => f.id == udfId).name + "修改:" + oldVal.ToString() + "→" + value + "。原因:" + desc,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            };
            actDal.Insert(act);
            OperLogBLL.OperLogAdd<com_activity>(act, act.id, user.id, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
        }
     
        /// <summary>
        /// 新增/修改 合同内部成本
        /// </summary>
        /// <param name="cis"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool ConIntCostAddOrUpdate(ctt_contract_internal_cost cis, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                var cisDal = new ctt_contract_internal_cost_dal();
                if (cis.id == 0)
                {
                    if(cis.resource_id == 0 || cis.role_id == 0)
                    {
                        return false;
                    }
                    cis.id = cisDal.GetNextIdCom();
                    //  todo 新增时 resource_id 从何处取值呢
                    cis.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    cis.create_user_id = user.id;
                    cis.update_user_id = user.id;
                    cis.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    cisDal.Insert(cis);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_INTERNAL_COST,
                        oper_object_id = cis.id,// 操作对象id
                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                        oper_description = dal.AddValue(cis),
                        remark = "添加合同内部成本"
                    });
                }
                else
                {
                    var oldCost = cisDal.FindNoDeleteById(cis.id);
                    if (oldCost != null && user != null)
                    {
                        cis.create_time = oldCost.create_time;
                        cis.create_user_id = oldCost.create_user_id;
                        cis.update_user_id = user.id;
                        cis.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        cis.oid = oldCost.oid;
                        cis.resource_id = oldCost.resource_id;
                        cisDal.Update(cis);
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_INTERNAL_COST,
                            oper_object_id = cis.id,// 操作对象id
                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                            oper_description = dal.CompareValue(oldCost, cis),
                            remark = "修改合同内部成本"
                        });
                    }
                    else
                    {
                        return false;
                    }
                }
                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        /// <summary>
        /// 删除合同内部成本
        /// </summary>
        /// <param name="cicId"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteConIntCost(long cicId,long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var cisDal = new ctt_contract_internal_cost_dal();
            var oldIntCost = cisDal.FindNoDeleteById(cicId);
            if (user != null && oldIntCost != null)
            {
                oldIntCost.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                oldIntCost.delete_user_id = user.id;

                cisDal.Update(oldIntCost);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_INTERNAL_COST,
                    oper_object_id = oldIntCost.id,// 操作对象id
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.DELETE,
                    oper_description = dal.AddValue(oldIntCost),
                    remark = "删除合同内部成本"
                });

            }


            return false;
        }

        #region 里程碑
        /// <summary>
        /// 获取里程碑状态字典
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetMilestoneStatuDic()
        {
            return new GeneralBLL().GetDicValues(GeneralTableEnum.CONTRACT_MILESTONE);
        }

        /// <summary>
        /// 新增合同里程碑
        /// </summary>
        /// <param name="milestone"></param>
        /// <param name="userId"></param>
        public void AddMilestone(ctt_contract_milestone milestone, long userId)
        {
            ctt_contract_milestone_dal milDal = new ctt_contract_milestone_dal();
            milestone.id = milDal.GetNextIdCom();
            milestone.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            milestone.create_user_id = userId;
            milestone.update_time = milestone.create_time;
            milestone.update_user_id = userId;
            milDal.Insert(milestone);
            OperLogBLL.OperLogAdd<ctt_contract_milestone>(milestone, milestone.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "新增合同里程碑");
        }

        /// <summary>
        /// 编辑合同里程碑
        /// </summary>
        /// <param name="milestone"></param>
        /// <param name="userId"></param>
        public void UpdateMilestone(ctt_contract_milestone milestone, long userId)
        {
            ctt_contract_milestone_dal milDal = new ctt_contract_milestone_dal();
            var oldMil = milDal.FindById(milestone.id);

            milestone.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            milestone.update_user_id = userId;
            new ctt_contract_milestone_dal().Update(milestone);
            OperLogBLL.OperLogUpdate<ctt_contract_milestone>(milestone, oldMil, milestone.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "编辑合同里程碑");
        }

        /// <summary>
        /// 获取里程碑信息
        /// </summary>
        /// <param name="milestoneId"></param>
        /// <returns></returns>
        public ctt_contract_milestone GetMilestone(long milestoneId)
        {
            return new ctt_contract_milestone_dal().FindById(milestoneId);
        }

        /// <summary>
        /// 删除合同里程碑
        /// </summary>
        /// <param name="milestoneId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteMilestone(long milestoneId, long userId)
        {
            ctt_contract_milestone_dal milDal = new ctt_contract_milestone_dal();
            var entity = milDal.FindById(milestoneId);

            if (entity.status_id == (int)DicEnum.MILESTONE_STATUS.BILLED)   // 已计费里程碑不可删除
                return false;

            entity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            entity.delete_user_id = userId;
            milDal.Update(entity);

            OperLogBLL.OperLogDelete<ctt_contract_milestone>(entity, entity.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_MILESTONE, "删除合同里程碑");

            return true;
        }
        #endregion

        /// <summary>
        /// 根据合同id获取合同概要视图信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public v_contract_summary GetContractSummary(long id)
        {
            return new v_contract_summary_dal().FindByContractId(id);
        }

        /// <summary>
        /// 根据合同id获取合同信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ctt_contract GetContract(long id)
        {
            return dal.FindById(id);
        }
    }
}
