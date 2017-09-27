using System;
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
    public class ContractBlockBLL
    {
        private readonly ctt_contract_block_dal dal = new ctt_contract_block_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            //dic.Add("payment_term", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));        // 
            dic.Add("paymentType", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TYPE)));        // 
            //dic.Add("payment_ship_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_SHIP_TYPE)));        // 

            return dic;
        }

        public ctt_contract_block GetBlockById(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 修改预付
        /// </summary>
        /// <param name="blockEdit"></param>
        /// <param name="userId"></param>
        public void EditPurchase(ctt_contract_block blockEdit, long userId)
        {
            ctt_contract_block block = dal.FindById(blockEdit.id);
            ctt_contract_block blockOld = dal.FindById(blockEdit.id);

            block.start_date = blockEdit.start_date;
            block.end_date = blockEdit.end_date;
            block.rate = blockEdit.rate;
            block.quantity = blockEdit.quantity;
            block.status_id = blockEdit.status_id;
            block.date_purchased = blockEdit.date_purchased;
            block.payment_number = blockEdit.payment_number;
            block.payment_type_id = blockEdit.payment_type_id;
            block.description = blockEdit.description;

            block.update_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            block.update_user_id = userId;

            dal.Update(block);
            OperLogBLL.OperLogUpdate<ctt_contract_block>(block, blockOld, block.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_BLOCK, "修改预付");

            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            var list = costDal.FindByBlockId(block.id);
            foreach (var cost in list)
            {
                var costEdit = costDal.FindById(cost.id);
                costEdit.quantity = block.quantity;
                costEdit.unit_price = block.rate;
                costEdit.date_purchased = block.date_purchased;
                costEdit.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                costEdit.update_user_id = userId;
                costDal.Update(costEdit);
                OperLogBLL.OperLogUpdate<ctt_contract_cost>(costEdit, cost, costEdit.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本");
            }
        }

        /// <summary>
        /// 新增预付
        /// </summary>
        /// <param name="dto"></param>
        /// <param name="userId"></param>
        public bool NewPurchase(ContractBlockAddDto dto, long userId)
        {
            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();

            if(dto.isMonthly)   // 每月计费
            {
                // 检查必填项
                if (dto.endDate == null && dto.purchaseNum == null)
                    return false;
                if (dto.hours == null || dto.hourlyRate == null)
                    return false;
                // 检查起止日期和计费周期
                if (dto.endDate != null && (DateTime)dto.endDate < dto.startDate)
                    return false;
                if (dto.endDate == null && dto.purchaseNum <= 0)
                    return false;

                DateTime dtBlockStart = dto.startDate;          // 一个预付周期开始时间
                DateTime dtBlockEnd = (DateTime)dto.endDate;    // 所有预付周期结束时间
                int blockNums = 0;  // 已处理新增预付时间
                while(true)
                {
                    if (dto.endDate != null)    // 按最后一个周期的结束时间判断
                    {
                        if (dtBlockStart > dtBlockEnd)
                            break;
                    }
                    else    // 按周期个数判断
                    {
                        if (blockNums >= (int)dto.purchaseNum)
                            break;
                    }

                    // 新增预付
                    ctt_contract_block block = new ctt_contract_block();
                    block.id = dal.GetNextIdCom();
                    block.is_billed = 0;
                    block.is_paid = 0;
                    block.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    block.create_user_id = userId;
                    block.update_user_id = userId;
                    block.update_time = block.create_time;

                    block.start_date = dtBlockStart;
                    block.end_date = dtBlockStart.AddMonths(1).AddDays(-1);
                    if (dto.type==1)
                    {
                        block.quantity = ((decimal)dto.hours) * 10000 / 10000;
                        block.rate = ((decimal)dto.hourlyRate) * 100 / 100;
                    }
                    else if(dto.type == 2)
                    {
                        block.quantity = 1;
                        block.rate = (decimal)dto.amount;
                    }
                    if ((bool)dto.firstPart && blockNums == 0)  // 首月部分的处理
                    {
                        block.end_date = new DateTime(dtBlockStart.Year, dtBlockStart.Month + 1, 1).AddDays(-1);    // 结束日期为开始日期同月份的最后一天
                        block.quantity = ((decimal)(block.end_date.Day - block.start_date.Day + 1) / block.end_date.Day) * ((decimal)dto.hours) * 10000 / 10000;    // 预付数量按照天数比例计算
                    }
                    if (dto.endDate != null && ((DateTime)dto.endDate) < block.end_date)    // 设置了结束时间的处理
                    {
                        block.end_date = (DateTime)dto.endDate;
                        block.quantity = ((decimal)((block.end_date - block.start_date).Days + 1)
                            / DateTime.DaysInMonth(block.start_date.Year, block.start_date.Month))
                            * ((decimal)dto.hours) * 10000 / 10000;    // 预付数量按照天数比例计算
                    }
                    dtBlockStart = block.end_date.AddDays(1);   // 下一周期的开始日期
                    ++blockNums;    // 已处理周期数加1

                    // 可以延期
                    if (dto.delayDays != null && dto.delayDays > 0)
                    {
                        block.end_date.AddDays((int)dto.delayDays);
                    }

                    block.status_id = (sbyte)(dto.status ? 1 : 0);
                    block.date_purchased = block.start_date;
                    block.payment_number = dto.paymentNum;
                    block.payment_type_id = dto.paymentType;
                    block.description = dto.note;

                    dal.Insert(block);
                    OperLogBLL.OperLogAdd<ctt_contract_block>(block, block.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_BLOCK, "新增合同预付");


                    // 新增合同成本
                    ctt_contract_cost cost = new ctt_contract_cost();
                    cost.id = costDal.GetNextIdCom();
                    cost.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    cost.create_user_id = userId;
                    cost.update_time = cost.create_time;
                    cost.update_user_id = userId;
                    cost.contract_block_id = block.id;
                    cost.contract_id = dto.contractId;
                    var costCode = new d_cost_code_dal().GetListCostCode((int)COST_CODE_CATE.BLOCK_PURCHASE);
                    if (costCode == null || costCode.Count == 0)
                        throw new Exception("字典项缺失");
                    cost.cost_code_id = costCode[0].id;
                    cost.name = $"预付[{dto.startDate.ToShortDateString()}-{((DateTime)dto.endDate).ToShortDateString()}]";
                    cost.date_purchased = block.date_purchased;
                    cost.cost_type_id = (int)COST_TYPE.OPERATIONA;
                    cost.status_id = (int)COST_STATUS.UNDETERMINED;
                    cost.bill_status = 1;
                    cost.quantity = block.quantity;
                    cost.unit_cost = 0;
                    cost.unit_price = block.rate;
                    cost.contract_block_id = block.id;
                    cost.extended_price = (cost.quantity * cost.unit_price) * 100 / 100;

                    costDal.Insert(cost);
                    OperLogBLL.OperLogAdd<ctt_contract_cost>(cost, cost.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增合同成本");
                }
                return true;
            }
            else    // 一次计费
            {
                if (dto.endDate == null || dto.hours == null || dto.hourlyRate == null) // 检查必填项
                    return false;
                if ((DateTime)dto.endDate < dto.startDate)  // 检查起止日期和计费周期
                    return false;

                // 新增预付
                ctt_contract_block block = new ctt_contract_block();
                block.id = dal.GetNextIdCom();
                block.is_billed = 0;
                block.is_paid = 0;
                block.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                block.create_user_id = userId;
                block.update_user_id = userId;
                block.update_time = block.create_time;
                block.start_date = dto.startDate;
                block.end_date = (DateTime)dto.endDate;
                if (dto.type == 1)
                {
                    block.quantity = ((decimal)dto.hours) * 10000 / 10000;
                    block.rate = ((decimal)dto.hourlyRate) * 100 / 100;
                }
                else if (dto.type == 2)
                {
                    block.quantity = 1;
                    block.rate = (decimal)dto.amount;
                }
                block.status_id = (sbyte)(dto.status ? 1 : 0);
                block.date_purchased = dto.datePurchased;
                block.payment_number = dto.paymentNum;
                block.payment_type_id = dto.paymentType;
                block.description = dto.note;

                dal.Insert(block);
                OperLogBLL.OperLogAdd<ctt_contract_block>(block, block.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_BLOCK, "新增合同预付");


                // 新增合同成本
                ctt_contract_cost cost = new ctt_contract_cost();
                cost.id = costDal.GetNextIdCom();
                cost.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cost.create_user_id = userId;
                cost.update_time = cost.create_time;
                cost.update_user_id = userId;
                cost.contract_block_id = block.id;
                cost.contract_id = dto.contractId;
                var costCode = new d_cost_code_dal().GetListCostCode((int)COST_CODE_CATE.BLOCK_PURCHASE);
                if (costCode == null || costCode.Count == 0)
                    throw new Exception("字典项缺失");
                cost.cost_code_id = costCode[0].id;
                cost.name = $"预付[{dto.startDate.ToShortDateString()}-{((DateTime)dto.endDate).ToShortDateString()}]";
                cost.date_purchased = block.date_purchased;
                cost.cost_type_id = (int)COST_TYPE.OPERATIONA;
                cost.status_id = (int)COST_STATUS.UNDETERMINED;
                cost.bill_status = 1;
                cost.quantity = block.quantity;
                cost.unit_cost = 0;
                cost.unit_price = block.rate;
                cost.contract_block_id = block.id;
                cost.extended_price = (cost.quantity * cost.unit_price) * 100 / 100;

                costDal.Insert(cost);
                OperLogBLL.OperLogAdd<ctt_contract_cost>(cost, cost.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增合同成本");

                return true;
            }
        }

        /// <summary>
        /// 删除预付
        /// </summary>
        /// <param name="blockId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeletePurchase(long blockId, long userId)
        {
            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            var list = costDal.FindByBlockId(blockId);
            foreach (var cost in list)
            {
                cost.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                cost.delete_user_id = userId;
                costDal.Update(cost);
                OperLogBLL.OperLogDelete<ctt_contract_cost>(cost, cost.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST);
            }

            var block = dal.FindById(blockId);
            if (block == null)
                return false;
            block.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            block.delete_user_id = userId;
            dal.Update(block);
            OperLogBLL.OperLogDelete<ctt_contract_block>(block, block.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_BLOCK);
            return true;
        }

        /// <summary>
        /// 删除合同下未收费的预付和成本信息
        /// </summary>
        /// <param name="contractId"></param>
        /// <param name="userId"></param>
        public void DeleteContractBlockByContractId(long contractId, long userId)
        {
            var list = dal.FindListByContractId(contractId);
            foreach (var entity in list)
            {
                if (entity.is_billed == 1)  // 已付费的不删除
                    continue;

                DeletePurchase(entity.id, userId);
            }
        }
    }
}
