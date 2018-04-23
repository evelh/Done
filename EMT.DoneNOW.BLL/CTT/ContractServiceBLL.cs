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

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;   // 服务周期类型
            DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriod;   // 合同与服务周期类型中较大的周期类型
            decimal rate = GetPeriodRate((DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, 0, service.object_id, out svcPeriod, out maxPeriod);
            if (rate > 1)   // 合同周期更长，服务周期使用合同周期，单价和成本根据周期倍数翻倍
            {
                if (service.unit_cost != null)
                    service.unit_cost = service.unit_cost * rate;
                if (service.unit_price != null)
                    service.unit_price = service.unit_price * rate;
            }

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
            
            // 添加服务调整和服务周期
            DateTime start, end;    // 合同服务的周期起止日期
            DateTime periodEnd;     // 根据周期类型计算的周期结束日期
            decimal periodRate;     // 服务周期占整个周期的比例
            // 计算首周期起止日期，并判断是否需要新增服务调整记录
            if (!GetFirstPeriodDate(contract.start_date, contract.end_date, service.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, svcPeriod, out start, out end))
            {
                periodEnd = GetNextPeriodStart(start, maxPeriod).AddDays(-1);
                periodRate = ((decimal)GetPeriodDays(service.effective_date, end)) / GetPeriodDays(start, periodEnd);    // 首周期占整周期比例
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
                sa.effective_date = service.effective_date;
                sa.end_date = end;
                sa.prorated_cost_change = (decimal)service.adjusted_price;  // 调整后的总价
                sa.adjust_prorated_price_change = decimal.Round((decimal)cs.adjusted_price * periodRate, 4);
                sa.prorated_price_change = sa.adjust_prorated_price_change;

                saDal.Insert(sa);
                OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "新增合同服务调整");

                start = end.AddDays(1);     // 周期开始日期指向下一周期
            }
            ctt_contract_service_period_dal spDal = new ctt_contract_service_period_dal();
            var ivtService = new ServiceBLL().GetServiceById(service.object_id);
            periodRate = 1;
            while (start <= contract.end_date)
            {
                GetPeriodEndDate(start, contract.end_date, maxPeriod, out end);     // 获取周期结束日期
                periodEnd = GetNextPeriodStart(start, maxPeriod).AddDays(-1);
                if (periodEnd != end)
                {
                    periodRate = ((decimal)GetPeriodDays(start, end)) / GetPeriodDays(start, periodEnd);
                }

                ctt_contract_service_period sp = new ctt_contract_service_period();
                sp.id = spDal.GetNextIdCom();
                sp.contract_id = contract.id;
                sp.contract_service_id = cs.id;
                sp.object_id = cs.object_id;
                sp.object_type = cs.object_type;
                sp.period_begin_date = start;
                sp.period_end_date = end;
                sp.quantity = cs.quantity;
                sp.period_price = decimal.Round((decimal)(cs.quantity * cs.unit_price * periodRate), 4);
                sp.period_cost = decimal.Round((decimal)(cs.quantity * cs.unit_cost * periodRate), 4);
                sp.period_adjusted_price = sp.period_price;
                sp.vendor_account_id = ivtService.vendor_account_id;
                sp.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                sp.update_time = sp.create_time;
                sp.create_user_id = userId;
                sp.update_user_id = userId;

                spDal.Insert(sp);
                OperLogBLL.OperLogAdd<ctt_contract_service_period>(sp, sp.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "新增合同服务周期");

                start = end.AddDays(1);
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

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;   // 服务周期类型
            DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriod;   // 合同与服务周期类型中较大的周期类型
            decimal rate = GetPeriodRate((DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, 0, service.object_id, out svcPeriod, out maxPeriod);
            if (rate > 1)   // 合同周期更长，服务周期使用合同周期，单价和成本根据周期倍数翻倍
            {
                if (service.unit_cost != null)
                    service.unit_cost = service.unit_cost * rate;
                if (service.unit_price != null)
                    service.unit_price = service.unit_price * rate;
            }

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

            // 添加服务调整和服务周期
            DateTime start, end;    // 合同服务的周期起止日期
            DateTime periodEnd;     // 根据周期类型计算的周期结束日期
            decimal periodRate;     // 服务周期占整个周期的比例
            // 计算首周期起止日期，并判断是否需要新增服务调整记录
            if (!GetFirstPeriodDate(contract.start_date, contract.end_date, service.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, svcPeriod, out start, out end))
            {
                periodEnd = GetNextPeriodStart(start, maxPeriod).AddDays(-1);
                periodRate = ((decimal)GetPeriodDays(service.effective_date, end)) / GetPeriodDays(start, periodEnd);    // 首周期占整周期比例
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
                sa.effective_date = service.effective_date;
                sa.end_date = end;
                sa.prorated_cost_change = (decimal)service.adjusted_price;  // 调整后的总价
                sa.adjust_prorated_price_change = decimal.Round((decimal)cs.adjusted_price * periodRate, 4);
                sa.prorated_price_change = sa.adjust_prorated_price_change;

                saDal.Insert(sa);
                OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "新增合同服务包调整");

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

                start = end.AddDays(1);     // 周期开始日期指向下一周期
            }
            ctt_contract_service_period_dal spDal = new ctt_contract_service_period_dal();
            ctt_contract_service_period_bundle_service_dal spbsDal = new ctt_contract_service_period_bundle_service_dal();
            periodRate = 1;
            while (start <= contract.end_date)
            {
                GetPeriodEndDate(start, contract.end_date, maxPeriod, out end);     // 获取周期结束日期
                periodEnd = GetNextPeriodStart(start, maxPeriod).AddDays(-1);
                if (periodEnd != end)
                {
                    periodRate = ((decimal)GetPeriodDays(start, end)) / GetPeriodDays(start, periodEnd);
                }

                ctt_contract_service_period sp = new ctt_contract_service_period();
                sp.id = spDal.GetNextIdCom();
                sp.contract_id = contract.id;
                sp.contract_service_id = cs.id;
                sp.object_id = cs.object_id;
                sp.object_type = cs.object_type;
                sp.period_begin_date = start;
                sp.period_end_date = end;
                sp.quantity = cs.quantity;
                sp.period_price = decimal.Round((decimal)(cs.quantity * cs.unit_price * periodRate), 4);
                sp.period_cost = decimal.Round((decimal)(cs.quantity * cs.unit_cost * periodRate), 4);
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

                start = end.AddDays(1);
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
            if (ser.effective_date < service.effective_date)    // 调整的生效日期不能早于合同服务生效日期
                return false;
            var serviceOld = dal.FindById(ser.id);

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;   // 服务周期类型
            DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriod;   // 合同与服务周期类型中较大的周期类型
            decimal rate = GetPeriodRate((DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, service.id, 0, out svcPeriod, out maxPeriod);
            if (rate > 1)   // 合同周期更长，服务周期使用合同周期，单价和成本根据周期倍数翻倍
            {
                if (ser.unit_cost != null)
                    ser.unit_cost = ser.unit_cost * rate;
                if (ser.unit_price != null)
                    ser.unit_price = ser.unit_price * rate;
            }

            DateTime adjBeginDate = DateTime.MinValue;  // 需要调整的服务调整的起始日期(调整所在周期起始日期或下一周期起始日期)
            DateTime start, end;    // 合同服务的周期起止日期
            // 计算合同服务首周期起止日期，并判断是否有服务调整记录
            if (!GetFirstPeriodDate(contract.start_date, contract.end_date, service.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, svcPeriod, out start, out end))
            {
                if (ser.effective_date <= end)     // 调整的生效日期在服务调整周期内
                {
                    var adj = dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date='{service.effective_date.ToString("yyyy-MM-dd")}' and delete_time=0");
                    if (adj == null)
                        return false;
                    adjBeginDate = adj.end_date.AddDays(1);
                    if (adj.approve_and_post_user_id == null)   // 未审批提交才能调整
                    {
                        if (ser.effective_date.Date.Equals(adj.effective_date.Date))    // 调整的生效时间等于开始时间
                        {
                            if (adj.quantity_change + (ser.quantity - service.quantity) == 0)   // 调整后单位数为0，删除
                            {
                                adj.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adj.delete_user_id = userId;
                                adjDal.Update(adj);
                                OperLogBLL.OperLogDelete<ctt_contract_service_adjust>(adj, adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整删除");
                            }
                            else
                            {
                                var adjOld = adjDal.FindById(adj.id);
                                var periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                                adj.quantity_change = adj.quantity_change + (ser.quantity - service.quantity);
                                if (ser.unit_cost == null || ser.unit_cost == 0)
                                    adj.prorated_cost_change = 0;
                                else
                                    adj.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(service.effective_date, end) / GetPeriodDays(start, periodEndDate) * adj.quantity_change;
                                if (ser.unit_price == null || ser.unit_price == 0)
                                    adj.prorated_price_change = 0;
                                else
                                    adj.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(service.effective_date, end) / GetPeriodDays(start, periodEndDate) * adj.quantity_change;
                                adj.prorated_cost_change = decimal.Round(adj.prorated_cost_change, 4);
                                adj.prorated_price_change = decimal.Round(adj.prorated_price_change, 4);
                                adj.adjust_prorated_price_change = adj.prorated_price_change;
                                adj.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adj.update_user_id = userId;
                                adjDal.Update(adj);
                                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjOld, adj), adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                            }
                        }
                        else if (ser.effective_date > adj.effective_date)   // 调整的生效时间不等于开始时间
                        {
                            if (service.quantity != ser.quantity)   // 调整数量才进行修改，否则从下一周期修改
                            {
                                var periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
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
                                    adjNew.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(ser.effective_date, end) / GetPeriodDays(start, periodEndDate) * adjNew.quantity_change;
                                if (ser.unit_price == null || ser.unit_price == 0)
                                    adjNew.prorated_price_change = 0;
                                else
                                    adjNew.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(ser.effective_date, end) / GetPeriodDays(start, periodEndDate) * adjNew.quantity_change;
                                adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4);
                                adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4);
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

                    // 如果调整日期等于服务生效日期，且修改了价格或成本，则需要对调整周期内可能存在的其他服务调整进行调整
                    if (ser.effective_date == service.effective_date)
                    {
                        if (ser.unit_cost != serviceOld.unit_cost || ser.unit_price != serviceOld.unit_price)
                        {
                            DateTime periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);  // 调整所在周期的完整周期结束日期
                            var adjList = dal.FindListBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date>'{service.effective_date.ToString("yyyy-MM-dd")}' and end_date='{adj.end_date.ToString("yyyy-MM-dd")}' and approve_and_post_user_id is null and delete_time=0");
                            foreach (var adjust in adjList)
                            {
                                decimal adjRate = ((decimal)GetPeriodDays(adjust.effective_date, adjust.end_date)) / GetPeriodDays(start, periodEndDate);
                                var adjustOld = adjDal.FindById(adjust.id);
                                adjust.prorated_cost_change = (decimal)ser.unit_cost * adjust.quantity_change * adjRate;
                                adjust.prorated_price_change = (decimal)ser.unit_price * adjust.quantity_change * adjRate;
                                adjust.adjust_prorated_price_change = adjust.prorated_price_change;
                                adjust.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adjust.update_user_id = userId;
                                var desc = OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjustOld, adjust);
                                if (!string.IsNullOrEmpty(desc))
                                {
                                    adjDal.Update(adjust);
                                    OperLogBLL.OperLogUpdate(desc, adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                                }
                            }
                        }
                    }
                }
            }
            
            service.unit_price = ser.unit_price;
            service.quantity = ser.quantity;
            service.adjusted_price = service.unit_price * service.quantity;
            service.unit_cost = ser.unit_cost;
            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.update_user_id = userId;

            dal.Update(service);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service>(serviceOld, service), service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "调整合同服务");

            var periodList = GetServicePeriodList(ser.id);      // 服务周期列表
            if (periodList == null || periodList.Count == 0)
                return true;

            for (int i = 0; i < periodList.Count; ++i)
            {
                if (periodList[i].period_end_date < ser.effective_date)
                    continue;

                if (ser.effective_date > periodList[i].period_begin_date)   // 调整开始生效所在的周期，且生效日期大于周期开始日期
                {
                    adjBeginDate = periodList[i].period_end_date.AddDays(1);

                    if (periodList[i].approve_and_post_user_id != null)
                        continue;

                    if (ser.quantity != serviceOld.quantity)    // 调整数量需要记录调整表
                    {
                        var periodEndDate = GetNextPeriodStart(periodList[i].period_begin_date, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                        var adjNew = new ctt_contract_service_adjust();
                        adjNew.id = adjDal.GetNextIdCom();
                        adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adjNew.create_user_id = userId;
                        adjNew.update_time = adjNew.create_time;
                        adjNew.update_user_id = userId;
                        adjNew.contract_id = contract.id;
                        adjNew.object_id = service.object_id;
                        adjNew.object_type = 1;
                        adjNew.quantity_change = ser.quantity - serviceOld.quantity;

                        if (periodList[i].period_cost == null || periodList[i].period_cost == 0)
                            adjNew.prorated_cost_change = 0;
                        else
                            adjNew.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(ser.effective_date, periodList[i].period_end_date) / GetPeriodDays(periodList[i].period_begin_date, periodEndDate) * adjNew.quantity_change;
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adjNew.prorated_price_change = 0;
                        else
                            adjNew.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(ser.effective_date, periodList[i].period_end_date) / GetPeriodDays(periodList[i].period_begin_date, periodEndDate) * adjNew.quantity_change;
                        adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4);
                        adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4);
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
                    if (ser.effective_date == periodList[i].period_begin_date)  // 调整从本周期起始日期开始
                        adjBeginDate = periodList[i].period_end_date;

                    if (periodList[i].approve_and_post_user_id != null)
                        continue;

                    if (ser.quantity == 0)  // 调整后单位数为0，删除周期
                    {
                        var perd = periodList[i];
                        perd.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        perd.delete_user_id = userId;
                        prdDal.Update(perd);
                        OperLogBLL.OperLogDelete<ctt_contract_service_period>(perd, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整删除服务周期");
                    }
                    else
                    {
                        var perdOld = prdDal.FindById(periodList[i].id);
                        var perd = periodList[i];
                        var periodEndDate = GetNextPeriodStart(periodList[i].period_begin_date, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                        decimal prdRate = 1;
                        if (periodEndDate != perd.period_end_date)  // 该周期不是完整周期
                        {
                            prdRate = ((decimal)GetPeriodDays(perd.period_begin_date, perd.period_end_date)) / GetPeriodDays(perd.period_begin_date, periodEndDate);
                        }
                        perd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        perd.update_user_id = userId;
                        perd.period_price = ser.unit_price * ser.quantity * prdRate;
                        perd.period_cost = ser.unit_cost * ser.quantity * prdRate;
                        perd.period_adjusted_price = perd.period_price;
                        perd.quantity = ser.quantity;
                        var desc = OperLogBLL.CompareValue<ctt_contract_service_period>(perdOld, perd);
                        if (!string.IsNullOrEmpty(desc))
                        {
                            prdDal.Update(perd);
                            OperLogBLL.OperLogUpdate(desc, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整修改服务周期");
                        }
                    }
                }
            }

            if (adjBeginDate == DateTime.MinValue)
                return true;

            // 如有价格或成本修改，修改服务调整的价格或成本
            if (serviceOld.unit_price != ser.unit_price || serviceOld.unit_cost != ser.unit_cost)
            {
                var adjList = dal.FindListBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date>='{adjBeginDate.ToString("yyyy-MM-dd")}' and approve_and_post_user_id is null and delete_time=0");
                foreach (var adjust in adjList)
                {
                    // 查找调整所在周期的起止日期
                    DateTime pStart = adjBeginDate;
                    DateTime pend = DateTime.MinValue;
                    while (pStart <= contract.end_date)
                    {
                        pend = GetNextPeriodStart(pStart, maxPeriod).AddDays(-1);
                        if (adjust.effective_date > pStart && adjust.end_date <= pend)
                            break;
                        pStart = pend.AddDays(1);
                    }
                    decimal adjRate = ((decimal)GetPeriodDays(adjust.effective_date, adjust.end_date)) / GetPeriodDays(pStart, pend);
                    var adjustOld = adjDal.FindById(adjust.id);
                    adjust.prorated_cost_change = (decimal)ser.unit_cost * adjust.quantity_change * adjRate;
                    adjust.prorated_price_change = (decimal)ser.unit_price * adjust.quantity_change * adjRate;
                    adjust.adjust_prorated_price_change = adjust.prorated_price_change;
                    adjust.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    adjust.update_user_id = userId;
                    var desc = OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjustOld, adjust);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        adjDal.Update(adjust);
                        OperLogBLL.OperLogUpdate(desc, adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
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
            if (ser.effective_date < service.effective_date)    // 调整的生效日期不能早于合同服务生效日期
                return false;
            var serviceOld = dal.FindById(ser.id);

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;   // 服务周期类型
            DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriod;   // 合同与服务周期类型中较大的周期类型
            decimal rate = GetPeriodRate((DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, service.id, 0, out svcPeriod, out maxPeriod);
            if (rate > 1)   // 合同周期更长，服务周期使用合同周期，单价和成本根据周期倍数翻倍
            {
                if (ser.unit_cost != null)
                    ser.unit_cost = ser.unit_cost * rate;
                if (ser.unit_price != null)
                    ser.unit_price = ser.unit_price * rate;
            }

            DateTime adjBeginDate = DateTime.MinValue;  // 需要调整的服务调整的起始日期(调整所在周期起始日期或下一周期起始日期)
            DateTime start, end;    // 合同服务的周期起止日期
            // 计算合同服务首周期起止日期，并判断是否有服务调整记录
            if (!GetFirstPeriodDate(contract.start_date, contract.end_date, service.effective_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, svcPeriod, out start, out end))
            {
                if (ser.effective_date <= end)     // 调整的生效日期在服务调整周期内
                {
                    var adj = dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date='{service.effective_date.ToString("yyyy-MM-dd")}' and delete_time=0");
                    if (adj == null)
                        return false;
                    adjBeginDate = adj.end_date.AddDays(1);
                    if (adj.approve_and_post_user_id == null)   // 未审批提交才能调整
                    {
                        if (ser.effective_date.Date.Equals(adj.effective_date.Date))    // 调整的生效时间等于开始时间
                        {
                            if (adj.quantity_change + (ser.quantity - service.quantity) == 0)   // 调整后单位数为0，删除
                            {
                                adj.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adj.delete_user_id = userId;
                                adjDal.Update(adj);
                                OperLogBLL.OperLogDelete<ctt_contract_service_adjust>(adj, adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整删除");
                            }
                            else
                            {
                                var adjOld = adjDal.FindById(adj.id);
                                var periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                                adj.quantity_change = adj.quantity_change + (ser.quantity - service.quantity);
                                if (ser.unit_cost == null || ser.unit_cost == 0)
                                    adj.prorated_cost_change = 0;
                                else
                                    adj.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(service.effective_date, end) / GetPeriodDays(start, periodEndDate) * adj.quantity_change;
                                if (ser.unit_price == null || ser.unit_price == 0)
                                    adj.prorated_price_change = 0;
                                else
                                    adj.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(service.effective_date, end) / GetPeriodDays(start, periodEndDate) * adj.quantity_change;
                                adj.prorated_cost_change = decimal.Round(adj.prorated_cost_change, 4);
                                adj.prorated_price_change = decimal.Round(adj.prorated_price_change, 4);
                                adj.adjust_prorated_price_change = adj.prorated_price_change;
                                adj.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adj.update_user_id = userId;
                                adjDal.Update(adj);
                                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjOld, adj), adj.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                            }  
                        }
                        else if (ser.effective_date > adj.effective_date)   // 调整的生效时间不等于开始时间
                        {
                            if (service.quantity != ser.quantity)   // 调整数量才进行修改，否则从下一周期修改
                            {
                                var periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
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
                                    adjNew.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(ser.effective_date, end) / GetPeriodDays(start, periodEndDate) * adjNew.quantity_change;
                                if (ser.unit_price == null || ser.unit_price == 0)
                                    adjNew.prorated_price_change = 0;
                                else
                                    adjNew.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(ser.effective_date, end) / GetPeriodDays(start, periodEndDate) * adjNew.quantity_change;
                                adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4);
                                adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4);
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

                    // 如果调整日期等于服务生效日期，且修改了价格或成本，则需要对调整周期内可能存在的其他服务调整进行调整
                    if (ser.effective_date == service.effective_date)
                    {
                        if (ser.unit_cost != serviceOld.unit_cost || ser.unit_price != serviceOld.unit_price)
                        {
                            DateTime periodEndDate = GetNextPeriodStart(start, maxPeriod).AddDays(-1);  // 调整所在周期的完整周期结束日期
                            var adjList = dal.FindListBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date>'{service.effective_date.ToString("yyyy-MM-dd")}' and end_date='{adj.end_date.ToString("yyyy-MM-dd")}' and approve_and_post_user_id is null and delete_time=0");
                            foreach (var adjust in adjList)
                            {
                                decimal adjRate = ((decimal)GetPeriodDays(adjust.effective_date, adjust.end_date)) / GetPeriodDays(start, periodEndDate);
                                var adjustOld = adjDal.FindById(adjust.id);
                                adjust.prorated_cost_change = (decimal)ser.unit_cost * adjust.quantity_change * adjRate;
                                adjust.prorated_price_change = (decimal)ser.unit_price * adjust.quantity_change * adjRate;
                                adjust.adjust_prorated_price_change = adjust.prorated_price_change;
                                adjust.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                adjust.update_user_id = userId;
                                var desc = OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjustOld, adjust);
                                if (!string.IsNullOrEmpty(desc))
                                {
                                    adjDal.Update(adjust);
                                    OperLogBLL.OperLogUpdate(desc, adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
                                }
                            }
                        }
                    }
                }
            }

            service.unit_price = ser.unit_price;
            service.quantity = ser.quantity;
            service.adjusted_price = service.unit_price * service.quantity;
            service.unit_cost = ser.unit_cost;
            service.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            service.update_user_id = userId;

            dal.Update(service);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_service>(serviceOld, service), service.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "调整合同服务");

            var periodList = GetServicePeriodList(ser.id);      // 服务周期列表
            if (periodList == null || periodList.Count == 0)
                return true;

            for (int i = 0; i < periodList.Count; ++i)
            {
                if (periodList[i].period_end_date < ser.effective_date)
                    continue;

                if (ser.effective_date > periodList[i].period_begin_date)   // 调整开始生效所在的周期，且生效日期大于周期开始日期
                {
                    adjBeginDate = periodList[i].period_end_date.AddDays(1);

                    if (periodList[i].approve_and_post_user_id != null)
                        continue;

                    if (ser.quantity != serviceOld.quantity)    // 调整数量需要记录调整表
                    {
                        var periodEndDate = GetNextPeriodStart(periodList[i].period_begin_date, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                        var adjNew = new ctt_contract_service_adjust();
                        adjNew.id = adjDal.GetNextIdCom();
                        adjNew.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        adjNew.create_user_id = userId;
                        adjNew.update_time = adjNew.create_time;
                        adjNew.update_user_id = userId;
                        adjNew.contract_id = contract.id;
                        adjNew.object_id = service.object_id;
                        adjNew.object_type = 2;
                        adjNew.quantity_change = ser.quantity - serviceOld.quantity;

                        if (periodList[i].period_cost == null || periodList[i].period_cost == 0)
                            adjNew.prorated_cost_change = 0;
                        else
                            adjNew.prorated_cost_change = (decimal)ser.unit_cost * GetPeriodDays(ser.effective_date, periodList[i].period_end_date) / GetPeriodDays(periodList[i].period_begin_date, periodEndDate) * adjNew.quantity_change;
                        if (ser.unit_price == null || ser.unit_price == 0)
                            adjNew.prorated_price_change = 0;
                        else
                            adjNew.prorated_price_change = (decimal)ser.unit_price * GetPeriodDays(ser.effective_date, periodList[i].period_end_date) / GetPeriodDays(periodList[i].period_begin_date, periodEndDate) * adjNew.quantity_change;
                        adjNew.prorated_cost_change = decimal.Round(adjNew.prorated_cost_change, 4);
                        adjNew.prorated_price_change = decimal.Round(adjNew.prorated_price_change, 4);
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
                    if (ser.effective_date == periodList[i].period_begin_date)  // 调整从本周期起始日期开始
                        adjBeginDate = periodList[i].period_end_date;

                    if (periodList[i].approve_and_post_user_id != null)
                        continue;

                    if (ser.quantity == 0)  // 调整后单位数为0，删除周期
                    {
                        var perd = periodList[i];
                        perd.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        perd.delete_user_id = userId;
                        prdDal.Update(perd);
                        OperLogBLL.OperLogDelete<ctt_contract_service_period>(perd, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整删除服务周期");
                    }
                    else
                    {
                        var perdOld = prdDal.FindById(periodList[i].id);
                        var perd = periodList[i];
                        var periodEndDate = GetNextPeriodStart(periodList[i].period_begin_date, maxPeriod).AddDays(-1);       // 完整周期的周期结束日期
                        decimal prdRate = 1;
                        if (periodEndDate != perd.period_end_date)  // 该周期不是完整周期
                        {
                            prdRate = ((decimal)GetPeriodDays(perd.period_begin_date, perd.period_end_date)) / GetPeriodDays(perd.period_begin_date, periodEndDate);
                        }
                        perd.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        perd.update_user_id = userId;
                        perd.period_price = ser.unit_price * ser.quantity * prdRate;
                        perd.period_cost = ser.unit_cost * ser.quantity * prdRate;
                        perd.period_adjusted_price = perd.period_price;
                        perd.quantity = ser.quantity;
                        var desc = OperLogBLL.CompareValue<ctt_contract_service_period>(perdOld, perd);
                        if (!string.IsNullOrEmpty(desc))
                        {
                            prdDal.Update(perd);
                            OperLogBLL.OperLogUpdate(desc, perd.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD, "合同服务调整修改服务周期");
                        }
                    }
                }
            }

            if (adjBeginDate == DateTime.MinValue)
                return true;

            // 如有价格或成本修改，修改服务调整的价格或成本
            if (serviceOld.unit_price != ser.unit_price || serviceOld.unit_cost != ser.unit_cost)
            {
                var adjList = dal.FindListBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={service.id} and effective_date>='{adjBeginDate.ToString("yyyy-MM-dd")}' and approve_and_post_user_id is null and delete_time=0");
                foreach (var adjust in adjList)
                {
                    // 查找调整所在周期的起止日期
                    DateTime pStart = adjBeginDate;
                    DateTime pend = DateTime.MinValue;
                    while (pStart <= contract.end_date)
                    {
                        pend = GetNextPeriodStart(pStart, maxPeriod).AddDays(-1);
                        if (adjust.effective_date > pStart && adjust.end_date <= pend)
                            break;
                        pStart = pend.AddDays(1);
                    }
                    decimal adjRate = ((decimal)GetPeriodDays(adjust.effective_date, adjust.end_date)) / GetPeriodDays(pStart, pend);
                    var adjustOld = adjDal.FindById(adjust.id);
                    adjust.prorated_cost_change = (decimal)ser.unit_cost * adjust.quantity_change * adjRate;
                    adjust.prorated_price_change = (decimal)ser.unit_price * adjust.quantity_change * adjRate;
                    adjust.adjust_prorated_price_change = adjust.prorated_price_change;
                    adjust.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    adjust.update_user_id = userId;
                    var desc = OperLogBLL.CompareValue<ctt_contract_service_adjust>(adjustOld, adjust);
                    if (!string.IsNullOrEmpty(desc))
                    {
                        adjDal.Update(adjust);
                        OperLogBLL.OperLogUpdate(desc, adjust.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "合同服务调整修改");
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

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;   // 服务周期类型
            DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriod;   // 合同与服务周期类型中较大的周期类型
            decimal rate = GetPeriodRate((DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, service.id, 0, out svcPeriod, out maxPeriod);

            var adjustList = adjDal.FindListBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={serviceId} and approve_and_post_user_id is null and delete_time=0 order by effective_date asc");
            foreach (var adjust in adjustList)
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
        /// <param name="serviceId">服务/服务包id</param>
        /// <param name="effDate"></param>
        /// <returns></returns>
        public decimal CalcServiceAdjustDatePercent(long contractId, long serviceId, DateTime effDate)
        {
            var contract = new ContractBLL().GetContract(contractId);
            if (effDate < contract.start_date || effDate > contract.end_date)
                return 0;

            DicEnum.QUOTE_ITEM_PERIOD_TYPE svcPeriod;
            var service = new ServiceBLL().GetServiceById(serviceId);
            if (service == null)
            {
                var serBund = new ServiceBLL().GetServiceBundleById(serviceId);
                if (serBund == null)
                    return 0;
                svcPeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)serBund.period_type_id;
            }
            else
                svcPeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)service.period_type_id;

            // 计算生效日期所在的合同服务周期
            DateTime start, end;
            if (!GetFirstPeriodDate(contract.start_date, contract.end_date, effDate, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type, svcPeriod, out start, out end))
            {
                return decimal.Round(((decimal)GetPeriodDays(effDate, end) / GetPeriodDays(start, end)), 8);
            }
            else    // 生效日期是周期起始日期
                return 0;
            
        }

        #region 周期及周期天数计算
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
        /// 计算合同服务首周期的开始和结束日期
        /// </summary>
        /// <param name="contractStart">合同开始日期</param>
        /// <param name="contractEnd">合同结束日期</param>
        /// <param name="serviceEffect">服务生效日期</param>
        /// <param name="contractPeriod">合同周期</param>
        /// <param name="servicePeriod">服务周期</param>
        /// <param name="periodStart">首周期的开始日期</param>
        /// <param name="periodEnd">首周期的结束日期</param>
        /// <returns>合同服务生效日期是否合同内某个周期的起始日期（不是起始日期需要生成合同服务调整）</returns>
        private bool GetFirstPeriodDate(DateTime contractStart, DateTime contractEnd, DateTime serviceEffect, DicEnum.QUOTE_ITEM_PERIOD_TYPE contractPeriod, DicEnum.QUOTE_ITEM_PERIOD_TYPE servicePeriod, out DateTime periodStart, out DateTime periodEnd)
        {
            int cttPeriod = GetPeriodMonth(contractPeriod);     // 合同周期月数
            int svcPeriod = GetPeriodMonth(servicePeriod);      // 服务周期月数
            DateTime start = contractStart;     // 周期的开始日期
            DateTime end;                       // 周期的结束日期
            while (start <= contractEnd)
            {
                end = GetNextPeriodStart(start, contractPeriod).AddDays(-1);
                if (serviceEffect >= start && serviceEffect <= end)     // 服务生效日期在该周期内
                {
                    periodStart = start;
                    if (end > contractEnd)
                        end = contractEnd;
                    if (svcPeriod > cttPeriod)      // 服务周期更长，需要按照服务周期计算周期结束时间
                        periodEnd = GetNextPeriodStart(start, servicePeriod).AddDays(-1);
                    else
                        periodEnd = end;

                    if (start == serviceEffect)
                        return true;
                    else
                        return false;
                }
                else
                    start = end.AddDays(1);
            }

            periodStart = DateTime.MinValue;
            periodEnd = DateTime.MinValue;
            return false;
        }

        /// <summary>
        /// 根据周期起始日期和周期类型获取周期结束日期
        /// </summary>
        /// <param name="periodStart"></param>
        /// <param name="contractEnd"></param>
        /// <param name="periodType"></param>
        /// <param name="periodEnd"></param>
        /// <returns>周期起始时间超过合同结束时间，返回false</returns>
        private bool GetPeriodEndDate(DateTime periodStart, DateTime contractEnd, DicEnum.QUOTE_ITEM_PERIOD_TYPE periodType, out DateTime periodEnd)
        {
            periodEnd = DateTime.MinValue;
            if (periodStart > contractEnd)
                return false;

            DateTime end = GetNextPeriodStart(periodStart, periodType).AddDays(-1);
            if (end > contractEnd)
                periodEnd = contractEnd;
            else
                periodEnd = end;

            return true;
        }

        /// <summary>
        /// 获取周期类型对应的周期长度（月）
        /// </summary>
        /// <param name="period"></param>
        /// <returns></returns>
        private int GetPeriodMonth(DicEnum.QUOTE_ITEM_PERIOD_TYPE period)
        {
            switch (period)
            {
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                    return 1;
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                    return 3;
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                    return 6;
                case DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                    return 12;
                default:
                    return 0;
            }
        }

        /// <summary>
        /// 根据周期的开始日期和结束日期获取周期天数
        /// </summary>
        /// <param name="start"></param>
        /// <param name="end"></param>
        /// <returns></returns>
        private int GetPeriodDays(DateTime start, DateTime end)
        {
            return ((end - start).Days + 1);
        }

        /// <summary>
        /// 返回合同周期天数除以服务周期天数的比例，保留8位小数
        /// </summary>
        /// <param name="contractPeriod"></param>
        /// <param name="cttServiceId"></param>
        /// <param name="serviceId"></param>
        /// <param name="cttServicePeriod"></param>
        /// <param name="maxPeriodType"></param>
        /// <returns></returns>
        public decimal GetPeriodRate(DicEnum.QUOTE_ITEM_PERIOD_TYPE contractPeriod, long cttServiceId, long serviceId, out DicEnum.QUOTE_ITEM_PERIOD_TYPE cttServicePeriod, out DicEnum.QUOTE_ITEM_PERIOD_TYPE maxPeriodType)
        {
            DicEnum.QUOTE_ITEM_PERIOD_TYPE servicePeriod;
            if (cttServiceId != 0)
            {
                var service = GetService(cttServiceId);
                if (service.object_type == 1)
                    servicePeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)(new ServiceBLL().GetServiceById(service.object_id).period_type_id);
                else
                    servicePeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)(new ServiceBLL().GetServiceBundleById(service.object_id).period_type_id);
            }
            else
            {
                var service = new ServiceBLL().GetServiceById(serviceId);
                if (service == null)
                {
                    var serBund = new ServiceBLL().GetServiceBundleById(serviceId);
                    servicePeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)serBund.period_type_id;
                }
                else
                    servicePeriod = (DicEnum.QUOTE_ITEM_PERIOD_TYPE)service.period_type_id;
            }

            cttServicePeriod = servicePeriod;
            maxPeriodType = contractPeriod;

            if (contractPeriod == servicePeriod)
                return 1;
            if (contractPeriod == DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME
                || servicePeriod == DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                return 0;
            int ctt = GetPeriodMonth(contractPeriod);
            int svc = GetPeriodMonth(servicePeriod);
            if (ctt == 0 || svc == 0)
                return 0;

            if (svc > ctt)
                maxPeriodType = servicePeriod;

            return decimal.Round(((decimal)ctt) / svc, 8);
        }
        #endregion

        /// <summary>
        /// 获取一个合同服务的可调整最早日期（已审批并提交的周期或调整周期的结束日期后一天）
        /// </summary>
        /// <param name="serviceId">合同服务id</param>
        /// <returns>没有已审批并提交数据，返回NULL</returns>
        public DateTime? GetServiceMaxApproveTime(long serviceId)
        {
            var dal = new ctt_contract_service_period_dal();
            var period = dal.FindSignleBySql<ctt_contract_service_period>($"select * from ctt_contract_service_period where contract_service_id={serviceId} and approve_and_post_user_id is not null and delete_time=0 order by period_end_date desc limit 1");
            if (period == null)
            {
                var adjust = dal.FindSignleBySql<ctt_contract_service_adjust>($"select * from ctt_contract_service_adjust where contract_service_id={serviceId} and approve_and_post_user_id is not null and delete_time=0 order by end_date desc limit 1");
                if (adjust == null)
                    return null;
                else
                    return adjust.end_date.AddDays(1);
            }
            else
                return period.period_end_date.AddDays(1);
        }

        /// <summary>
        /// 获取一个定期服务合同的结束日期可调整最早日期（已审批并提交的周期或调整周期的结束日期后一天）
        /// </summary>
        /// <param name="contractId">合同id</param>
        /// <returns>没有已审批并提交数据，返回NULL</returns>
        public DateTime? GetContractMaxApproveTime(long contractId)
        {
            var serviceList = GetServiceList(contractId);
            if (serviceList == null || serviceList.Count == 0)
                return null;

            DateTime? maxApprove = null;
            foreach (var service in serviceList)
            {
                var dt = GetServiceMaxApproveTime(service.id);
                if (dt != null)
                {
                    if (maxApprove == null)
                        maxApprove = dt;
                    else if (dt > maxApprove)
                        maxApprove = dt;
                }
            }
            return maxApprove;
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
