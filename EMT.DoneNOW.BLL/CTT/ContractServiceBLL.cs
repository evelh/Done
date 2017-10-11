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
            cs.effective_date = contract.start_date;
            cs.adjusted_price = service.quantity * service.unit_price;

            dal.Insert(cs);
            OperLogBLL.OperLogAdd<ctt_contract_service>(cs, cs.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE, "新增合同服务");

            var ivtService = new ServiceBLL().GetServiceById(service.object_id);
            // 插入合同服务周期表ctt_contract_service_period
            DateTime dtStart = service.effective_date;
            ctt_contract_service_period_dal spDal = new ctt_contract_service_period_dal();
            if (dtStart != contract.start_date)     // 生效时间不是合同开始时间
            {
                DateTime tmp1;  // 周期开始时间
                DateTime tmp2;  // 周期结束时间
                tmp1 = contract.start_date;
                tmp2 = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                int periodDaysCnt = (tmp2 - tmp1).Days;
                while (true)
                {
                    if (dtStart > tmp2)
                        break;
                    if (tmp2 >= contract.end_date)
                        break;
                    tmp1 = tmp2;
                    tmp2 = GetNextPeriodStart(tmp2, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                }
                dtStart = tmp1;
                dtStart = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);

                // 计算调整后的首周期天数
                if (tmp2 >= contract.end_date)
                    tmp2=contract.end_date;
                int adjustDaysCnt = (tmp2 - dtStart).Days;

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
                    sa.contract_service_id = cs.id;
                    sa.effective_date = contract.start_date;
                    sa.end_date = dtStart.AddDays(-1);
                    if (sa.end_date > contract.end_date)
                        sa.end_date = contract.end_date;
                    sa.prorated_cost_change = (decimal)service.adjusted_price;
                    sa.adjust_prorated_price_change = service.quantity * (decimal)service.adjusted_price * adjustDaysCnt / periodDaysCnt;
                    sa.prorated_price_change = sa.adjust_prorated_price_change;

                    saDal.Insert(sa);
                    OperLogBLL.OperLogAdd<ctt_contract_service_adjust>(sa, sa.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_ADJUST, "新增合同服务调整");
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
                sp.period_begin_date = dtStart;
                dtStart = GetNextPeriodStart(dtStart, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                sp.period_end_date = dtStart.AddDays(-1);
                if (sp.period_end_date > contract.end_date)
                    sp.period_end_date = contract.end_date;
                sp.quantity = cs.quantity;
                sp.period_price = cs.quantity * cs.unit_price;
                sp.period_adjusted_price = sp.period_price;
                sp.period_cost = cs.quantity * cs.unit_cost;
                sp.vendor_account_id = ivtService.vendor_id;
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
            cs.effective_date = contract.start_date;
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
            if (dtStart != contract.start_date)     // 生效时间不是合同开始时间
            {
                DateTime tmp1;  // 周期开始时间
                DateTime tmp2;  // 周期结束时间
                tmp1 = contract.start_date;
                tmp2 = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                int periodDaysCnt = (tmp2 - tmp1).Days;
                while (true)
                {
                    if (dtStart > tmp2)
                        break;
                    if (tmp2 >= contract.end_date)
                        break;
                    tmp1 = tmp2;
                    tmp2 = GetNextPeriodStart(tmp2, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                }
                dtStart = tmp1;
                dtStart = GetNextPeriodStart(contract.start_date, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);

                // 计算调整后的首周期天数
                if (tmp2 >= contract.end_date)
                    tmp2 = contract.end_date;
                int adjustDaysCnt = (tmp2 - dtStart).Days;

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
                    sa.contract_service_id = cs.id;
                    sa.effective_date = contract.start_date;
                    sa.end_date = dtStart.AddDays(-1);
                    if (sa.end_date > contract.end_date)
                        sa.end_date = contract.end_date;
                    sa.prorated_cost_change = (decimal)service.adjusted_price;
                    sa.adjust_prorated_price_change = service.quantity * (decimal)service.adjusted_price * adjustDaysCnt / periodDaysCnt;
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
                        sabs.vendor_account_id = ivtServiceBundle.vendor_id;
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
                sp.period_begin_date = dtStart;
                dtStart = GetNextPeriodStart(dtStart, (DicEnum.QUOTE_ITEM_PERIOD_TYPE)contract.period_type);
                sp.period_end_date = dtStart.AddDays(-1);
                if (sp.period_end_date > contract.end_date)
                    sp.period_end_date = contract.end_date;
                sp.quantity = cs.quantity;
                sp.period_price = cs.quantity * cs.unit_price;
                sp.period_adjusted_price = sp.period_price;
                sp.period_cost = cs.quantity * cs.unit_cost;
                sp.vendor_account_id = ivtServiceBundle.vendor_id;
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
                    spbs.vendor_account_id = ivtServiceBundle.vendor_id;
                    spbs.period_cost = (decimal)sBll.GetServiceById(sbs.service_id).unit_cost;
                    spbsDal.Insert(spbs);
                }
            }

            return true;
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
