using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_cost_dal : BaseDAL<ctt_contract_cost>
    {
        /// <summary>
        /// 获取指定预付时间、预付费、事件ID关联的成本信息
        /// </summary>
        /// <param name="blockId"></param>
        /// <returns></returns>
        public List<ctt_contract_cost> FindByBlockId(long blockId)
        {
            string sql = $"SELECT * FROM ctt_contract_cost WHERE contract_block_id={blockId} AND delete_time=0";
            var list = FindListBySql(sql);
            if (list == null || list.Count == 0)
                return new List<ctt_contract_cost>();
            return list;
        }

        /// 根据项目Id 获取cost   36 代表时变更单
        public List<ctt_contract_cost> GetCostByProId(long project_id,string where ="")
        {
            // cost_code_id = 36 and
            return FindListBySql<ctt_contract_cost>($"SELECT * FROM ctt_contract_cost where   project_id = {project_id} and delete_time = 0 "+where);
        }
        /// <summary>
        /// 获取报价项ID 已经生成的成本，不能重复生成，所有只会有一条
        /// </summary>
        public ctt_contract_cost GetSinBuQuoteItem(long quote_item_id)
        {
            return FindSignleBySql<ctt_contract_cost>($"SELECT * from ctt_contract_cost where delete_time = 0 and quote_item_id = {quote_item_id}");
        }
        /// <summary>
        /// 根据销售订单获取相应成本状态
        /// </summary>
        public List<ctt_contract_cost> GetListBySaleOrderId(long sale_order_id)
        {
            return FindListBySql<ctt_contract_cost>($"SELECT ccc.* from ctt_contract_cost ccc inner join crm_sales_order cso on ccc.opportunity_id = cso.opportunity_id where ccc.delete_time = 0 and cso.delete_time = 0 and cso.id = {sale_order_id}");
        }
        /// <summary>
        /// 根据工单类型获取相应成本
        /// </summary>
        public List<ctt_contract_cost> GetListByTicketId(long ticketId,string where="")
        {
            return FindListBySql<ctt_contract_cost>($"SELECT * FROM ctt_contract_cost where task_id = {ticketId} and delete_time = 0 "+where);
        }


    }

}
