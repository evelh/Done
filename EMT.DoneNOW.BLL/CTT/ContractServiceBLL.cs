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
    public class ContractServiceBLL
    {
        /// <summary>
        /// 删除合同对应的服务/服务包的周期/调整等信息
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        public void DeleteServiceByContractId(long contractId, long userId)
        {

        }

        /// <summary>
        /// 获取合同服务
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ctt_contract_service GetService(long id)
        {
            return new ctt_contract_service_dal().FindById(id);
        }

        /// <summary>
        /// 获取合同服务的服务名称
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public string GetServiceName(ctt_contract_service entity)
        {
            if (entity.object_type == 1)
                return new ServiceBLL().GetServiceById(entity.object_id).name;
            else if (entity.object_type == 2)
                return new ServiceBLL().GetServiceBundleById(entity.object_id).name;
            return "";
        }

        /// <summary>
        /// 获取合同的服务/服务包列表
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ContractServiceEntityDto> GetServiceList(long contractId)
        {
            ctt_contract_service_dal dal = new ctt_contract_service_dal();
            List<ContractServiceEntityDto> rslt = new List<ContractServiceEntityDto>();

            var serviceList = dal.FindListBySql<ContractServiceEntityDto>($"SELECT service.*,ivt_service.`name`,ivt_service.`vendor_account_id`,ivt_service.`period_type_id` FROM (SELECT * FROM ctt_contract_service WHERE contract_id={contractId} AND object_type=1 AND delete_time=0) as service JOIN ivt_service ON service.object_id=ivt_service.id");
            rslt.AddRange(serviceList);
            serviceList = dal.FindListBySql<ContractServiceEntityDto>($"SELECT service.*,ivt_service_bundle.`name`,ivt_service_bundle.`vendor_account_id`,ivt_service_bundle.`period_type_id` FROM (SELECT * FROM ctt_contract_service WHERE contract_id={contractId} AND object_type=2 AND delete_time=0) as service JOIN ivt_service_bundle ON service.object_id=ivt_service_bundle.id");
            rslt.AddRange(serviceList);

            return rslt;
        }

        /// <summary>
        /// 新增合同服务/服务包
        /// </summary>
        /// <param name="service"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddServiceServiceBundle(ctt_contract_service service, long userId)
        {
            if (service.object_type == 1)
                return AddService(service, userId);
            else if (service.object_type == 2)
                return AddServiceBundle(service, userId);
            else
                return false;
        }

        /// <summary>
        /// 新增合同服务
        /// </summary>
        /// <param name="service"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddService(ctt_contract_service service, long userId)
        {
            ctt_contract_service_dal dal = new ctt_contract_service_dal();
            var contract = new ContractBLL().GetContract(service.contract_id);

            if (service.adjusted_price == null)
                return false;

            // 插入合同服务表ctt_contract_service
            ctt_contract_service cs = new ctt_contract_service();
            cs.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cs.create_user_id = userId;
            cs.update_user_id = userId;
            cs.update_time = cs.create_time;
            cs.id = dal.GetNextIdCom();
            cs.contract_id = service.contract_id;
            cs.object_id = service.object_id;
            cs.object_type = 1;
            cs.quantity = service.quantity;
            cs.unit_price = service.unit_price;
            cs.unit_cost = service.unit_cost;
            cs.effective_date = service.effective_date;
            cs.adjusted_price = service.quantity * service.unit_price;

            dal.Insert(cs);
            OperLogBLL.OperLogAdd<ctt_contract_service>(cs, cs.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "新增合同服务");

            var ivtService = new ServiceBLL().GetServiceById(service.object_id);
            // 插入合同服务周期表ctt_contract_service_period
            DateTime dtStart = service.effective_date;
            ctt_contract_service_period_dal spDal = new ctt_contract_service_period_dal();
            DateTime tmp1;  // 周期开始时间
            DateTime tmp2;  // 周期结束时间
            tmp1 = contract.start_date;
            if (dtStart != contract.start_date)     // 生效时间不是合同开始时间
            {
                tmp2 = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);   // 下一周期开始时间
                int periodDaysCnt = (tmp2 - tmp1).Days;
                while (true)    // 寻找服务生效的首周期开始结束时间
                {
                    if (dtStart <= tmp2.AddDays(-1))
                        break;
                    if (tmp2 >= contract.end_date)
                        break;
                    tmp1 = tmp2;
                    tmp2 = GetNextPeriodStart(tmp2, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                }
                //dtStart = tmp1;
                //dtStart = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                tmp2 = tmp2.AddDays(-1);

                // 计算调整后的首周期天数
                if (tmp2 > contract.end_date)
                    tmp2=contract.end_date;
                int adjustDaysCnt = (tmp2 - dtStart).Days + 1;

                if (adjustDaysCnt != periodDaysCnt)     // 生效时间不是周期开始时间
                {
                    ctt_contract_service_adjust_dal saDal = new ctt_contract_service_adjust_dal();
                    ctt_contract_service_adjust sa = new ctt_contract_service_adjust();
                    sa.id = saDal.GetNextIdCom();
                    sa.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    sa.update_time = sa.create_time;
                    sa.create_user_id = userId;
                    sa.update_user_id = userId;
                    sa.contract_id = service.contract_id;
                    sa.object_id = cs.object_id;
                    sa.object_type = cs.object_type;
                    sa.quantity_change = cs.quantity;
                    sa.contract_service_id = cs.id;
                    sa.effective_date = dtStart;
                    sa.end_date = tmp2;
                    if (sa.end_date > contract.end_date)
                        sa.end_date = contract.end_date;
                    sa.prorated_cost_change = (decimal)service.adjusted_price;
                    sa.adjust_prorated_price_change = service.quantity * (decimal)service.unit_price * adjustDaysCnt / periodDaysCnt;
                    sa.prorated_price_change = sa.adjust_prorated_price_change;

                    saDal.Insert(sa);
                    OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "新增合同服务调整");

                    dtStart = tmp2.AddDays(1);
                }
            }
            while(true)
            {
                if (dtStart > contract.end_date)
                    break;
                ctt_contract_service_period sp = new ctt_contract_service_period();
                sp.id = spDal.GetNextIdCom();
                sp.contract_id = contract.id;
                sp.contract_service_id = cs.id;
                sp.object_id = cs.object_id;
                sp.object_type = cs.object_type;
                sp.period_begin_date = dtStart;
                dtStart = GetNextPeriodStart(dtStart, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                sp.period_end_date = dtStart.AddDays(-1);
                sp.quantity = cs.quantity;
                sp.period_price = cs.quantity * cs.unit_price;
                sp.period_cost = cs.quantity * cs.unit_cost;
                if (sp.period_end_date > contract.end_date)
                {
                    sp.period_price = sp.period_price * GetPeriodDays(sp.period_begin_date, contract.end_date) / GetPeriodDays(sp.period_begin_date, sp.period_end_date);
                    sp.period_cost = sp.period_cost * GetPeriodDays(sp.period_begin_date, contract.end_date) / GetPeriodDays(sp.period_begin_date, sp.period_end_date);
                    sp.period_price = decimal.Round((decimal)sp.period_price, 4);
                    sp.period_cost = decimal.Round((decimal)sp.period_cost, 4);
                    sp.period_end_date = contract.end_date;
                }
                sp.period_adjusted_price = sp.period_price;
                sp.vendor_account_id = ivtService.vendor_account_id;
                sp.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sp.update_time = sp.create_time;
                sp.create_user_id = userId;
                sp.update_user_id = userId;

                spDal.Insert(sp);
                OperLogBLL.OperLogAdd<ctt_contract_service_period>(sp, sp.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "新增合同服务周期");
            }
            
            return true;
        }

        /// <summary>
        /// 新增合同服务包
        /// </summary>
        /// <param name="service"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddServiceBundle(ctt_contract_service service, long userId)
        {
            ctt_contract_service_dal dal = new ctt_contract_service_dal();
            var contract = new ContractBLL().GetContract(service.contract_id);
            ServiceBLL sBll = new ServiceBLL();

            if (service.adjusted_price == null)
                return false;

            // 插入合同服务表ctt_contract_service
            ctt_contract_service cs = new ctt_contract_service();
            cs.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cs.create_user_id = userId;
            cs.update_user_id = userId;
            cs.update_time = cs.create_time;
            cs.id = dal.GetNextIdCom();
            cs.contract_id = service.contract_id;
            cs.object_id = service.object_id;
            cs.object_type = 2;
            cs.quantity = service.quantity;
            cs.unit_price = service.unit_price;
            cs.unit_cost = service.unit_cost;
            cs.effective_date = service.effective_date;
            cs.adjusted_price = service.quantity * service.unit_price;

            dal.Insert(cs);
            OperLogBLL.OperLogAdd<ctt_contract_service>(cs, cs.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "新增合同服务包");

            var ivtServiceBundle = sBll.GetServiceBundleById(service.object_id);

            // 插入合同服务包对应的服务 ctt_contract_service_bundle_service
            var sbsList = sBll.GetServiceListByServiceBundleId(ivtServiceBundle.id);
            var sbsDal = new ctt_contract_service_bundle_service_dal();
            foreach(var sbs in sbsList)
            {
                ctt_contract_service_bundle_service csbs = new ctt_contract_service_bundle_service();
                csbs.id = sbsDal.GetNextIdCom();
                csbs.service_id = sbs.service_id;
                csbs.contract_service_id = cs.id;
                sbsDal.Insert(csbs);
            }

            // 插入合同服务周期表ctt_contract_service_period
            DateTime dtStart = service.effective_date;
            ctt_contract_service_period_dal spDal = new ctt_contract_service_period_dal();
            DateTime tmp1;  // 周期开始时间
            DateTime tmp2;  // 周期结束时间
            tmp1 = contract.start_date;
            if (dtStart != contract.start_date)     // 生效时间不是合同开始时间
            {
                tmp2 = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);   // 下一周期开始时间
                int periodDaysCnt = (tmp2 - tmp1).Days;
                while (true)    // 寻找服务生效的首周期开始结束时间
                {
                    if (dtStart <= tmp2.AddDays(-1))
                        break;
                    if (tmp2 >= contract.end_date)
                        break;
                    tmp1 = tmp2;
                    tmp2 = GetNextPeriodStart(tmp2, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                }
                //dtStart = tmp1;
                //dtStart = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                tmp2 = tmp2.AddDays(-1);

                // 计算调整后的首周期天数
                if (tmp2 >= contract.end_date)
                    tmp2 = contract.end_date;
                int adjustDaysCnt = (tmp2 - dtStart).Days + 1;

                if (adjustDaysCnt != periodDaysCnt)     // 生效时间不是周期开始时间
                {
                    ctt_contract_service_adjust_dal saDal = new ctt_contract_service_adjust_dal();
                    ctt_contract_service_adjust sa = new ctt_contract_service_adjust();
                    sa.id = saDal.GetNextIdCom();
                    sa.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    sa.update_time = sa.create_time;
                    sa.create_user_id = userId;
                    sa.update_user_id = userId;
                    sa.contract_id = service.contract_id;
                    sa.object_id = cs.object_id;
                    sa.object_type = cs.object_type;
                    sa.quantity_change = cs.quantity;
                    sa.contract_service_id = cs.id;
                    sa.effective_date = dtStart;
                    sa.end_date = tmp2;
                    if (sa.end_date > contract.end_date)
                        sa.end_date = contract.end_date;
                    sa.prorated_cost_change = (decimal)service.adjusted_price;
                    sa.adjust_prorated_price_change = service.quantity * (decimal)service.unit_price * adjustDaysCnt / periodDaysCnt;
                    sa.prorated_price_change = sa.adjust_prorated_price_change;

                    saDal.Insert(sa);
                    OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "新增合同服务包调整");

                    dtStart = tmp2.AddDays(1);

                    // 插入服务调整表包含的服务ctt_contract_service_adjust_bundle_service
                    ctt_contract_service_adjust_bundle_service_dal sabsDal = new ctt_contract_service_adjust_bundle_service_dal();
                    foreach (var sbs in sbsList)
                    {
                        ctt_contract_service_adjust_bundle_service sabs = new ctt_contract_service_adjust_bundle_service();
                        sabs.id = sabsDal.GetNextIdCom();
                        sabs.service_id = sbs.service_id;
                        sabs.contract_service_adjust_id = sa.id;
                        sabs.prorated_cost_change = (decimal)sBll.GetServiceById(sbs.service_id).unit_cost;
                        sabs.vendor_account_id = ivtServiceBundle.vendor_account_id;
                        sabsDal.Insert(sabs);
                    }
                }
            }

            ctt_contract_service_period_bundle_service_dal spbsDal = new ctt_contract_service_period_bundle_service_dal();
            while (true)
            {
                if (dtStart > contract.end_date)
                    break;
                ctt_contract_service_period sp = new ctt_contract_service_period();
                sp.id = spDal.GetNextIdCom();
                sp.contract_id = contract.id;
                sp.contract_service_id = cs.id;
                sp.object_id = cs.object_id;
                sp.object_type = cs.object_type;
                sp.period_begin_date = dtStart;
                dtStart = GetNextPeriodStart(dtStart, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                sp.period_end_date = dtStart.AddDays(-1);
                sp.quantity = cs.quantity;
                sp.period_price = cs.quantity * cs.unit_price;
                sp.period_cost = cs.quantity * cs.unit_cost;
                if (sp.period_end_date > contract.end_date)
                {
                    sp.period_price = sp.period_price * GetPeriodDays(sp.period_begin_date, contract.end_date) / GetPeriodDays(sp.period_begin_date, sp.period_end_date);
                    sp.period_cost = sp.period_cost * GetPeriodDays(sp.period_begin_date, contract.end_date) / GetPeriodDays(sp.period_begin_date, sp.period_end_date);
                    sp.period_price = decimal.Round((decimal)sp.period_price, 4);
                    sp.period_cost = decimal.Round((decimal)sp.period_cost, 4);
                    sp.period_end_date = contract.end_date;
                }
                sp.period_adjusted_price = sp.period_price;
                sp.vendor_account_id = ivtServiceBundle.vendor_account_id;
                sp.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sp.update_time = sp.create_time;
                sp.create_user_id = userId;
                sp.update_user_id = userId;

                spDal.Insert(sp);
                OperLogBLL.OperLogAdd<ctt_contract_service_period>(sp, sp.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "新增合同服务包周期");

                // 插入合同服务包周期对应的服务表ctt_contract_service_period_bundle_service
                foreach (var sbs in sbsList)
                {
                    ctt_contract_service_period_bundle_service spbs = new ctt_contract_service_period_bundle_service();
                    spbs.id = spbsDal.GetNextIdCom();
                    spbs.service_id = sbs.service_id;
                    spbs.contract_service_period_id = sp.id;
                    spbs.vendor_account_id = ivtServiceBundle.vendor_account_id;
                    spbs.period_cost = (decimal)sBll.GetServiceById(sbs.service_id).unit_cost;
                    spbsDal.Insert(spbs);
                }
            }

            return true;
        }

        /// <summary>
        /// 调整合同服务
        /// </summary>
        /// <param name="ser"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AdjustService(ctt_contract_service ser, long userId)
        {
            ctt_contract_service_dal dal = new ctt_contract_service_dal();
            ctt_contract_service_adjust_dal adjDal = new ctt_contract_service_adjust_dal();
            ctt_contract_service_period_dal prdDal = new ctt_contract_service_period_dal();
            
            var service = dal.FindById(ser.id);
            var contract = new ContractBLL().GetContract(service.contract_id);
            if (service.quantity == ser.quantity && service.unit_price == ser.unit_price && service.unit_cost == ser.unit_cost)
                return true;
            var serviceOld = dal.FindById(ser.id);

            var periodList = GetServicePeriodList(ser.id);      // 服务周期列表
            if (periodList == null || periodList.Count == 0)
                return false;
            // 寻找调整日期所在的周期
            int index = 0;
            if (periodList[0].period_begin_date > ser.effective_date)
            {
                var adj = dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and end_date='{periodList[0].period_begin_date.AddDays(-1).ToString("yyyy-MM-dd")}' and delete_time=0");
                if (adj == null)
                    return false;
                if (adj.effective_date > ser.effective_date)
                    return false;
                index = 0;

                if (adj.approve_and_post_user_id == null)   // 未审批提交才能调整
                {
                    if (ser.effective_date.Date.Equals(adj.effective_date.Date))    // 调整的生效时间等于开始时间
                    {
                        var adjOld = adjDal.FindById(adj.id);
                        var nextDate = GetNextPeriodStart(adj.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                        adj.quantity_change = adj.quantity_change + (ser.quantity - service.quantity);
                        if (ser.unit_cost == null || ser.unit_cost == 0)
                            adj.prorated_cost_change = 0;
                        else
                            adj.prorated_cost_change = (decimal)ser.unit_cost * ((adj.end_date - adj.effective_date).Days + 1) / (nextDate - ser.effective_date).Days;
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adj.prorated_price_change = 0;
                        else
                            adj.prorated_price_change = (decimal)ser.unit_price * ((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days;
                        adj.prorated_cost_change = decimal.Round(adj.prorated_cost_change, 4) * adj.quantity_change;
                        adj.prorated_price_change = decimal.Round(adj.prorated_price_change, 4) * adj.quantity_change;
                        adj.adjust_prorated_price_change = adj.prorated_price_change;
                        adj.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adj.update_user_id = userId;
                        adjDal.Update(adj);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjOld, adj), adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                    }
                    else if (ser.effective_date > adj.effective_date)   // 调整的生效时间不等于开始时间
                    {
                        if (service.quantity != ser.quantity)   // 调整数量才进行修改，否则从下一周期修改
                        {
                            var nextDate = GetNextPeriodStart(adj.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                            var adjNew = new ctt_contract_service_adjust();
                            adjNew.id = adjDal.GetNextIdCom();
                            adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            adjNew.create_user_id = userId;
                            adjNew.update_time = adjNew.create_time;
                            adjNew.update_user_id = userId;
                            adjNew.contract_id = adj.contract_id;
                            adjNew.object_id = adj.object_id;
                            adjNew.object_type = adj.object_type;
                            adjNew.quantity_change = ser.quantity - service.quantity;
                            if (ser.unit_cost == null || ser.unit_cost == 0)
                                adjNew.prorated_cost_change = 0;
                            else
                                adjNew.prorated_cost_change = (decimal)ser.unit_cost * (((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days);
                            if (ser.unit_price == null || ser.unit_price == 0)
                                adjNew.prorated_price_change = 0;
                            else
                                adjNew.prorated_price_change = (decimal)ser.unit_price * (((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days);
                            adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4) * adjNew.quantity_change;
                            adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4) * adjNew.quantity_change;
                            adjNew.effective_date = ser.effective_date;
                            adjNew.end_date = adj.end_date;
                            adjNew.vendor_account_id = adj.vendor_account_id;
                            adjNew.contract_service_id = adj.contract_service_id;
                            adjNew.adjust_prorated_price_change = adjNew.prorated_price_change;

                            adjDal.Insert(adjNew);
                            OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(adjNew, adjNew.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整新增");
                        }
                    }
                }
            }
            else
            {
                for (index = 0; index < periodList.Count; ++index)
                {
                    if (periodList[index].period_end_date >= ser.effective_date)
                        break;
                }
                if (index >= periodList.Count)
                    return false;
            }

            service.unit_price = ser.unit_price;
            service.quantity = ser.quantity;
            service.adjusted_price = service.unit_price * service.quantity;
            service.unit_cost = ser.unit_cost;
            //service.effective_date = contract.start_date;
            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.update_user_id = userId;

            dal.Update(service);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service>(serviceOld, service), service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "调整合同服务");

            for (int i = index; i < periodList.Count; ++i)
            {
                if (periodList[i].approve_and_post_user_id != null)
                    continue;

                if (ser.effective_date > periodList[i].period_begin_date)   // 调整开始生效所在的周期
                {
                    if (ser.quantity != serviceOld.quantity)    // 调整数量需要记录调整表
                    {
                        var adjNew = new ctt_contract_service_adjust();
                        adjNew.id = adjDal.GetNextIdCom();
                        adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adjNew.create_user_id = userId;
                        adjNew.update_time = adjNew.create_time;
                        adjNew.update_user_id = userId;
                        adjNew.contract_id = contract.id;
                        adjNew.object_id = service.id;
                        adjNew.object_type = 1;
                        adjNew.quantity_change = ser.quantity - serviceOld.quantity;

                        if (periodList[i].period_cost == null || periodList[i].period_cost == 0)
                            adjNew.prorated_cost_change = 0;
                        else
                            adjNew.prorated_cost_change = (decimal)ser.unit_cost * (((periodList[i].period_end_date - ser.effective_date).Days + 1) / (decimal)((periodList[i].period_end_date - periodList[i].period_begin_date).Days + 1));
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adjNew.prorated_price_change = 0;
                        else
                            adjNew.prorated_price_change = (decimal)ser.unit_price * (((periodList[i].period_end_date - ser.effective_date).Days + 1) / (decimal)((periodList[i].period_end_date - periodList[i].period_begin_date).Days + 1));
                        adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4) * adjNew.quantity_change;
                        adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4) * adjNew.quantity_change;
                        adjNew.effective_date = ser.effective_date;
                        adjNew.end_date = periodList[i].period_end_date;
                        adjNew.vendor_account_id = periodList[i].vendor_account_id;
                        adjNew.contract_service_id = periodList[i].contract_service_id;
                        adjNew.adjust_prorated_price_change = adjNew.prorated_price_change;

                        adjDal.Insert(adjNew);
                        OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(adjNew, adjNew.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整新增");
                    }
                }
                else    // 生效日期后的周期
                {
                    var perdOld = prdDal.FindById(periodList[i].id);
                    var perd = periodList[i];

                    perd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    perd.update_user_id = userId;
                    perd.period_price = ser.unit_price * ser.quantity;
                    perd.period_cost = ser.unit_cost * ser.quantity;
                    perd.quantity = ser.quantity;
                    var desc = OperLogBLL.CompareValue<ctt_contract_service_period>(perdOld, perd);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        prdDal.Update(perd);
                        OperLogBLL.OperLogUpdate(desc, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整修改服务周期");
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 调整合同服务包
        /// </summary>
        /// <param name="ser"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AdjustServiceBundle(ctt_contract_service ser, long userId)
        {
            ctt_contract_service_dal dal = new ctt_contract_service_dal();
            ctt_contract_service_adjust_dal adjDal = new ctt_contract_service_adjust_dal();
            ctt_contract_service_period_dal prdDal = new ctt_contract_service_period_dal();

            var service = dal.FindById(ser.id);
            var contract = new ContractBLL().GetContract(service.contract_id);
            if (service.quantity == ser.quantity && service.unit_price == ser.unit_price && service.unit_cost == ser.unit_cost)
                return true;
            var serviceOld = dal.FindById(ser.id);

            var periodList = GetServicePeriodList(ser.id);      // 服务周期列表
            if (periodList == null || periodList.Count == 0)
                return false;
            // 寻找调整日期所在的周期
            int index = 0;
            if (periodList[0].period_begin_date > ser.effective_date)
            {
                var adj = dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and end_date='{periodList[0].period_begin_date.AddDays(-1).ToString("yyyy-MM-dd")}' and delete_time=0");
                if (adj == null)
                    return false;
                if (adj.effective_date > ser.effective_date)
                    return false;
                index = 0;

                if (adj.approve_and_post_user_id == null)   // 未审批提交才能调整
                {
                    if (ser.effective_date.Date.Equals(adj.effective_date.Date))    // 调整的生效时间等于开始时间
                    {
                        var adjOld = adjDal.FindById(adj.id);
                        var nextDate = GetNextPeriodStart(adj.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                        adj.quantity_change = adj.quantity_change + (ser.quantity - service.quantity);
                        if (ser.unit_cost == null || ser.unit_cost == 0)
                            adj.prorated_cost_change = 0;
                        else
                            adj.prorated_cost_change = (decimal)ser.unit_cost * ((adj.end_date - adj.effective_date).Days + 1) / (nextDate - ser.effective_date).Days;
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adj.prorated_price_change = 0;
                        else
                            adj.prorated_price_change = (decimal)ser.unit_price * ((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days;
                        adj.prorated_cost_change = decimal.Round(adj.prorated_cost_change, 4) * adj.quantity_change;
                        adj.prorated_price_change = decimal.Round(adj.prorated_price_change, 4) * adj.quantity_change;
                        adj.adjust_prorated_price_change = adj.prorated_price_change;
                        adj.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adj.update_user_id = userId;
                        adjDal.Update(adj);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjOld, adj), adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                    }
                    else if (ser.effective_date > adj.effective_date)   // 调整的生效时间不等于开始时间
                    {
                        if (service.quantity != ser.quantity)   // 调整数量才进行修改，否则从下一周期修改
                        {
                            var nextDate = GetNextPeriodStart(adj.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                            var adjNew = new ctt_contract_service_adjust();
                            adjNew.id = adjDal.GetNextIdCom();
                            adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            adjNew.create_user_id = userId;
                            adjNew.update_time = adjNew.create_time;
                            adjNew.update_user_id = userId;
                            adjNew.contract_id = adj.contract_id;
                            adjNew.object_id = adj.object_id;
                            adjNew.object_type = adj.object_type;
                            adjNew.quantity_change = ser.quantity - service.quantity;
                            if (ser.unit_cost == null || ser.unit_cost == 0)
                                adjNew.prorated_cost_change = 0;
                            else
                                adjNew.prorated_cost_change = (decimal)ser.unit_cost * (((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days);
                            if (ser.unit_price == null || ser.unit_price == 0)
                                adjNew.prorated_price_change = 0;
                            else
                                adjNew.prorated_price_change = (decimal)ser.unit_price * (((adj.end_date - adj.effective_date).Days + 1) / (decimal)(nextDate - ser.effective_date).Days);
                            adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4) * adjNew.quantity_change;
                            adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4) * adjNew.quantity_change;
                            adjNew.effective_date = ser.effective_date;
                            adjNew.end_date = adj.end_date;
                            adjNew.vendor_account_id = adj.vendor_account_id;
                            adjNew.contract_service_id = adj.contract_service_id;
                            adjNew.adjust_prorated_price_change = adjNew.prorated_price_change;

                            adjDal.Insert(adjNew);
                            OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(adjNew, adjNew.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整新增");
                        }
                    }
                }
            }
            else
            {
                for (index = 0; index < periodList.Count; ++index)
                {
                    if (periodList[index].period_end_date >= ser.effective_date)
                        break;
                }
                if (index >= periodList.Count)
                    return false;
            }

            service.unit_price = ser.unit_price;
            service.quantity = ser.quantity;
            service.adjusted_price = service.unit_price * service.quantity;
            service.unit_cost = ser.unit_cost;
            //service.effective_date = contract.start_date;
            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.update_user_id = userId;

            dal.Update(service);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service>(serviceOld, service), service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "调整合同服务");

            for (int i = index; i < periodList.Count; ++i)
            {
                if (periodList[i].approve_and_post_user_id != null)
                    continue;

                if (ser.effective_date > periodList[i].period_begin_date)   // 调整开始生效所在的周期
                {
                    if (ser.quantity != serviceOld.quantity)    // 调整数量需要记录调整表
                    {
                        var adjNew = new ctt_contract_service_adjust();
                        adjNew.id = adjDal.GetNextIdCom();
                        adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adjNew.create_user_id = userId;
                        adjNew.update_time = adjNew.create_time;
                        adjNew.update_user_id = userId;
                        adjNew.contract_id = contract.id;
                        adjNew.object_id = service.id;
                        adjNew.object_type = 2;
                        adjNew.quantity_change = ser.quantity - serviceOld.quantity;

                        if (periodList[i].period_cost == null || periodList[i].period_cost == 0)
                            adjNew.prorated_cost_change = 0;
                        else
                            adjNew.prorated_cost_change = (decimal)ser.unit_cost * (((periodList[i].period_end_date - ser.effective_date).Days + 1) / (decimal)((periodList[i].period_end_date - periodList[i].period_begin_date).Days + 1));
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adjNew.prorated_price_change = 0;
                        else
                            adjNew.prorated_price_change = (decimal)ser.unit_price * (((periodList[i].period_end_date - ser.effective_date).Days + 1) / (decimal)((periodList[i].period_end_date - periodList[i].period_begin_date).Days + 1));
                        adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4) * adjNew.quantity_change;
                        adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4) * adjNew.quantity_change;
                        adjNew.effective_date = ser.effective_date;
                        adjNew.end_date = periodList[i].period_end_date;
                        adjNew.vendor_account_id = periodList[i].vendor_account_id;
                        adjNew.contract_service_id = periodList[i].contract_service_id;
                        adjNew.adjust_prorated_price_change = adjNew.prorated_price_change;

                        adjDal.Insert(adjNew);
                        OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(adjNew, adjNew.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整新增");
                    }
                }
                else    // 生效日期后的周期
                {
                    var perdOld = prdDal.FindById(periodList[i].id);
                    var perd = periodList[i];

                    perd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    perd.update_user_id = userId;
                    perd.period_price = ser.unit_price * ser.quantity;
                    perd.period_cost = ser.unit_cost * ser.quantity;
                    perd.quantity = ser.quantity;
                    var desc = OperLogBLL.CompareValue<ctt_contract_service_period>(perdOld, perd);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        prdDal.Update(perd);
                        OperLogBLL.OperLogUpdate(desc, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整修改服务周期");
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 修改服务的结束日期，修改服务周期
        /// </summary>
        /// <param name="contract">合同</param>
        /// <param name="serviceId">服务id</param>
        /// <param name="endDate">修改的合同结束日期</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditServiceEndDate(ctt_contract contract, long serviceId, DateTime endDate, long userId)
        {
            ctt_contract_service_adjust_dal adjDal = new ctt_contract_service_adjust_dal();
            ctt_contract_service_period_dal prdDal = new ctt_contract_service_period_dal();

            var periodList = GetServicePeriodList(serviceId);   // 服务周期列表
            var service = GetService(serviceId);

            var adjust = adjDal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={serviceId} and approve_and_post_user_id is null and delete_time=0 order by effective_date asc");
            if (adjust != null)
            {
                if (endDate < adjust.effective_date)
                {
                    adjust.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    adjust.delete_user_id = userId;
                    adjDal.Update(adjust);
                    OperLogBLL.OperLogDelete<ctt_contract_service_adjust>(adjust, adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "修改合同服务结束日期删除服务调整");
                }
                else if (endDate < adjust.end_date)
                {
                    var adjustOld = adjDal.FindById(adjust.id);
                    adjust.end_date = endDate;
                    adjust.prorated_cost_change = adjustOld.prorated_cost_change * ((adjust.end_date - adjust.effective_date).Days + 1) / ((adjustOld.end_date - adjustOld.effective_date).Days + 1);
                    adjust.prorated_cost_change = decimal.Round(adjust.prorated_cost_change, 4);
                    adjust.prorated_price_change = adjustOld.prorated_price_change * ((adjust.end_date - adjust.effective_date).Days + 1) / ((adjustOld.end_date - adjustOld.effective_date).Days + 1);
                    adjust.prorated_price_change = decimal.Round(adjust.prorated_price_change, 4);
                    adjust.adjust_prorated_price_change = adjust.prorated_price_change;
                    adjust.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    adjust.update_user_id = userId;
                    adjDal.Update(adjust);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjustOld, adjust), adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "修改合同服务结束日期修改服务调整");
                }
            }

            if (periodList.Count == 0)
                return true;

            if (periodList[periodList.Count - 1].period_end_date < endDate)     // 结束日期向后调整
            {
                // 判断最后一个周期是否满周期
                var nextStart = GetNextPeriodStart(periodList[periodList.Count - 1].period_begin_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                if (nextStart.AddDays(-1) != periodList[periodList.Count - 1].period_end_date)  // 最后一个周期不是满周期，先填满最后一个周期
                {
                    if (periodList[periodList.Count - 1].approve_and_post_user_id != null)  // 最后一个周期不是满周期且已审批并提交，不能向后调整
                        return false;

                    ctt_contract_service_period prdOld = prdDal.FindById(periodList[periodList.Count - 1].id);
                    if (nextStart > endDate)    // 没有下一周期
                    {
                        var prd = periodList[periodList.Count - 1];
                        prd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        prd.update_user_id = userId;
                        prd.period_end_date = endDate;
                        if (service.unit_price != null)
                        {
                            prd.period_price = service.unit_price * GetPeriodDays(prd.period_begin_date, prd.period_end_date) / GetPeriodDays(prd.period_begin_date, nextStart.AddDays(-1));
                            prd.period_price = decimal.Round((decimal)prd.period_price, 4) * prd.quantity;
                        }
                        if (service.unit_cost != null)
                        {
                            prd.period_cost = service.unit_cost * GetPeriodDays(prd.period_begin_date, prd.period_end_date) / GetPeriodDays(prd.period_begin_date, nextStart.AddDays(-1));
                            prd.period_cost = decimal.Round((decimal)prd.period_cost, 4) * prd.quantity;
                        }
                        prd.period_adjusted_price = prd.period_price;
                        prdDal.Update(prd);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_period>(prdOld, prd), prd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "修改合同服务结束日期修改服务周期");

                        return true;
                    }
                    else    // 最后周期变成满周期
                    {
                        var prd = periodList[periodList.Count - 1];
                        prd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        prd.update_user_id = userId;
                        prd.period_end_date = nextStart.AddDays(-1);
                        prd.period_price = service.unit_price * prd.quantity;
                        prd.period_cost = service.unit_cost * prd.quantity;
                        prd.period_adjusted_price = prd.period_price;
                        prdDal.Update(prd);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_period>(prdOld, prd), prd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "修改合同服务结束日期修改服务周期");
                    }
                }

                while (nextStart <= endDate)
                {
                    ctt_contract_service_period prd = new ctt_contract_service_period();
                    ctt_contract_service_period prdPre = periodList[periodList.Count - 1];
                    prd.id = prdDal.GetNextIdCom();
                    prd.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    prd.create_user_id = userId;
                    prd.update_time = prd.create_time;
                    prd.update_user_id = userId;
                    prd.contract_id = prdPre.contract_id;
                    prd.object_id = prdPre.object_id;
                    prd.object_type = prdPre.object_type;
                    prd.period_begin_date = nextStart;
                    prd.period_end_date = GetNextPeriodStart(nextStart, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type).AddDays(-1);
                    prd.period_price = prdPre.period_price;
                    prd.period_cost = prdPre.period_cost;
                    if (prd.period_end_date > endDate)  // 不是整周期
                    {
                        if (service.unit_price != null)
                            prd.period_price = decimal.Round((decimal)service.unit_price * GetPeriodDays(prd.period_begin_date, endDate) / GetPeriodDays(prd.period_begin_date, prd.period_end_date), 4) * prdPre.quantity;
                        if (service.unit_cost != null)
                            prd.period_cost = decimal.Round((decimal)service.unit_cost * GetPeriodDays(prd.period_begin_date, endDate) / GetPeriodDays(prd.period_begin_date, prd.period_end_date), 4) * prdPre.quantity;
                        prd.period_end_date = endDate;
                    }
                    prd.quantity = prdPre.quantity;
                    prd.period_adjusted_price = prd.period_price;
                    prd.vendor_account_id = prdPre.vendor_account_id;
                    prd.contract_service_id = prdPre.contract_service_id;

                    prdDal.Insert(prd);
                    OperLogBLL.OperLogAdd<ctt_contract_service_period>(prd, prd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "修改合同结束时间新增服务周期");

                    nextStart = prd.period_end_date.AddDays(1);
                }
            }
            else    // 结束日期向前调整
            {
                for (int i = 0; i < periodList.Count; ++i)
                {
                    if (periodList[i].approve_and_post_user_id != null) // 已审批并提交，不能修改
                        continue;
                    if (periodList[i].period_end_date <= endDate)       // 本周期不需要调整
                        continue;
                    if (periodList[i].period_begin_date > endDate)      // 本周期需要被删除
                    {
                        periodList[i].delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        periodList[i].delete_user_id = userId;
                        prdDal.Update(periodList[i]);
                        OperLogBLL.OperLogDelete<ctt_contract_service_period>(periodList[i], periodList[i].id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "修改合同结束时间删除服务周期");
                    }
                    else    // 需要修改本周期结束日期
                    {
                        var prd = periodList[i];
                        var prdOld = prdDal.FindById(prd.id);
                        var fullPeriodEndDate = GetNextPeriodStart(prd.period_begin_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type).AddDays(-1);
                        prd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        prd.update_user_id = userId;
                        prd.period_end_date = endDate;
                        if (service.unit_price != null)
                        {
                            prd.period_price = service.unit_price * GetPeriodDays(prd.period_begin_date, prd.period_end_date) / GetPeriodDays(prd.period_begin_date, fullPeriodEndDate);
                            prd.period_price = decimal.Round((decimal)prd.period_price, 4) * prd.quantity;
                        }
                        if (service.unit_cost != null)
                        {
                            prd.period_cost = service.unit_cost * GetPeriodDays(prd.period_begin_date, prd.period_end_date) / GetPeriodDays(prd.period_begin_date, fullPeriodEndDate);
                            prd.period_cost = decimal.Round((decimal)prd.period_cost, 4) * prd.quantity;
                        }
                        prd.period_adjusted_price = prd.period_price;
                        prdDal.Update(prd);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_period>(prdOld, prd), prd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "修改合同服务结束日期修改服务周期");
                    }
                }
            }

            return true;
        }


        /// <summary>
        /// 编辑合同服务发票描述
        /// </summary>
        /// <param name="ser"></param>
        /// <param name="userId"></param>
        public void EditServiceInvoiceDescription(ctt_contract_service ser, long userId)
        {
            var dal = new ctt_contract_service_dal();
            var service = dal.FindById(ser.id);
            var serviceOld = dal.FindById(ser.id);

            service.internal_description = ser.internal_description;
            service.is_invoice_description_customized = ser.is_invoice_description_customized;
            if (ser.is_invoice_description_customized == 0)
                service.invoice_description = ser.invoice_description;
            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.update_user_id = userId;

            dal.Update(service);
            OperLogBLL.OperLogUpdate<ctt_contract_service>(service, serviceOld, service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "修改合同服务发票描述");
        }

        /// <summary>
        /// 根据生效时间计算生效时间开始的首周期所占整周期的天数百分比(保留8位小数)
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="effDate"></param>
        /// <returns></returns>
        public decimal CalcServiceAdjustDatePercent(long contractId,DateTime effDate)
        {
            var contract = new ContractBLL().GetContract(contractId);
            if (effDate < contract.start_date || effDate > contract.end_date)
                return 0;

            DateTime endDate = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
            int periodDaysCnt = (endDate - contract.start_date).Days;
            DateTime startDate = contract.start_date;
            while(true)
            {
                if (endDate.AddDays(-1) >= effDate)
                    break;
                startDate = endDate;
                endDate = GetNextPeriodStart(endDate, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
            }
            if (effDate == startDate)
                return 0;
            if (endDate > contract.end_date)
                endDate = contract.end_date;
            return decimal.Round(((decimal)((endDate - effDate).Days) / periodDaysCnt), 8);
        }

        /// <summary>
        /// 获取下一周期开始时间
        /// </summary>
        /// <param name="start"></param>
        /// <param name="periodType"></param>
        /// <returns></returns>
        private DateTime GetNextPeriodStart(DateTime start, DicEnum.QUOTE_ITEM_PERIOD_TYPE periodType)
        {
            switch (periodType)
            {
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                    return start.AddMonths(1);
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                    return start.AddMonths(3);
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                    return start.AddMonths(6);
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                    return start.AddYears(1);
                default:
                    return start;
            }
        }

        /// <summary>
        /// 根据周期的开始日期获取周期
        /// </summary>
        /// <param name="start"></param>
        /// <param name="end"></param>
        /// <returns></returns>
        private int GetPeriodDays(DateTime start, DateTime end)
        {
            return ((end - start).Days + 1);
        }

        /// <summary>
        /// 获取按时间升序的合同服务周期
        /// </summary>
        /// <param name="serviceId"></param>
        /// <returns></returns>
        public List<ctt_contract_service_period> GetServicePeriodList(long serviceId)
        {
            return new ctt_contract_service_period_dal().FindListBySql($"SELECT * FROM ctt_contract_service_period WHERE contract_service_id={serviceId} AND delete_time=0 ORDER BY period_begin_date ASC");
        }

        /// <summary>
        /// 判断服务/服务包是否已计费
        /// </summary>
        /// <param name="serviceId"></param>
        /// <returns></returns>
        public bool IsServiceApproveAndPost(long serviceId)
        {
            ctt_contract_service_period_dal dal = new ctt_contract_service_period_dal();
            int count = dal.FindSignleBySql<int>($"SELECT COUNT(0) FROM ctt_contract_service_period WHERE contract_service_id={serviceId} AND approve_and_post_user_id<>NULL AND delete_time=0");
            if (count > 0)
                return true;
            return false;
        }

        /// <summary>
        /// 删除合同服务/服务包
        /// </summary>
        /// <param name="serviceId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteService(long serviceId, long userId)
        {
            if (IsServiceApproveAndPost(serviceId))
                return false;

            var serviceDal = new ctt_contract_service_dal();
            var saDal = new ctt_contract_service_adjust_dal();
            var spDal = new ctt_contract_service_period_dal();

            var service = serviceDal.FindById(serviceId);
            if (service == null)
                return false;
            
            var saList = saDal.FindListBySql($"SELECT * FROM ctt_contract_service_adjust WHERE contract_service_id={serviceId} AND delete_time=0");
            var spList = spDal.FindListBySql($"SELECT * FROM ctt_contract_service_period WHERE contract_service_id={serviceId} AND delete_time=0");

            service.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.delete_user_id = userId;

            serviceDal.Update(service);
            OperLogBLL.OperLogDelete<ctt_contract_service>(service, service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "删除合同服务/服务包");

            foreach(var sa in saList)
            {
                sa.delete_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sa.delete_user_id = userId;
                saDal.Update(sa);
                OperLogBLL.OperLogDelete<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "删除合同服务/包调整信息");
            }

            foreach (var sp in spList)
            {
                sp.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sp.delete_user_id = userId;
                spDal.Update(sp);
                OperLogBLL.OperLogDelete<ctt_contract_service_period>(sp, sp.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "删除合同服务/包各周期信息");
            }

            return true;
        }
    }
}
