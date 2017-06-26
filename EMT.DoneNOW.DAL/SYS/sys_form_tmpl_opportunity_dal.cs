using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_form_tmpl_opportunity_dal : BaseDAL<sys_form_tmpl_opportunity>
    {
        /// <summary>
        /// 比较两个对象的属性，记录不同的属性及属性值
        /// </summary>
        /// <param name="oldObj"></param>
        /// <param name="newObj"></param>
        /// <returns></returns>
        public string UpdateDetail(sys_form_tmpl_opportunity oldObj, sys_form_tmpl_opportunity newObj)
        {
            if (oldObj == null || newObj == null)
                return null;
            List<ObjUpdateDto> list = new List<ObjUpdateDto>();
            if (!Object.Equals(oldObj.id, newObj.id))
                list.Add(new ObjUpdateDto { field = "id", old_val = oldObj.id, new_val = newObj.id });
            if (!Object.Equals(oldObj.form_tmpl_id, newObj.form_tmpl_id))
                list.Add(new ObjUpdateDto { field = "form_tmpl_id", old_val = oldObj.form_tmpl_id, new_val = newObj.form_tmpl_id });
            if (!Object.Equals(oldObj.opportunity_no, newObj.opportunity_no))
                list.Add(new ObjUpdateDto { field = "opportunity_no", old_val = oldObj.opportunity_no, new_val = newObj.opportunity_no });
            if (!Object.Equals(oldObj.resource_id, newObj.resource_id))
                list.Add(new ObjUpdateDto { field = "resource_id", old_val = oldObj.resource_id, new_val = newObj.resource_id });
            if (!Object.Equals(oldObj.contact_id, newObj.contact_id))
                list.Add(new ObjUpdateDto { field = "contact_id", old_val = oldObj.contact_id, new_val = newObj.contact_id });
            if (!Object.Equals(oldObj.account_id, newObj.account_id))
                list.Add(new ObjUpdateDto { field = "account_id", old_val = oldObj.account_id, new_val = newObj.account_id });
            if (!Object.Equals(oldObj.name, newObj.name))
                list.Add(new ObjUpdateDto { field = "name", old_val = oldObj.name, new_val = newObj.name });
            if (!Object.Equals(oldObj.stage_id, newObj.stage_id))
                list.Add(new ObjUpdateDto { field = "stage_id", old_val = oldObj.stage_id, new_val = newObj.stage_id });
            if (!Object.Equals(oldObj.source_id, newObj.source_id))
                list.Add(new ObjUpdateDto { field = "source_id", old_val = oldObj.source_id, new_val = newObj.source_id });
            if (!Object.Equals(oldObj.status_id, newObj.status_id))
                list.Add(new ObjUpdateDto { field = "status_id", old_val = oldObj.status_id, new_val = newObj.status_id });
            if (!Object.Equals(oldObj.competitor_id, newObj.competitor_id))
                list.Add(new ObjUpdateDto { field = "competitor_id", old_val = oldObj.competitor_id, new_val = newObj.competitor_id });
            if (!Object.Equals(oldObj.probability, newObj.probability))
                list.Add(new ObjUpdateDto { field = "probability", old_val = oldObj.probability, new_val = newObj.probability });
            if (!Object.Equals(oldObj.interest_degree_id, newObj.interest_degree_id))
                list.Add(new ObjUpdateDto { field = "interest_degree_id", old_val = oldObj.interest_degree_id, new_val = newObj.interest_degree_id });
            if (!Object.Equals(oldObj.projected_begin_date, newObj.projected_begin_date))
                list.Add(new ObjUpdateDto { field = "projected_begin_date", old_val = oldObj.projected_begin_date, new_val = newObj.projected_begin_date });
            if (!Object.Equals(oldObj.projected_close_date_type_id, newObj.projected_close_date_type_id))
                list.Add(new ObjUpdateDto { field = "projected_close_date_type_id", old_val = oldObj.projected_close_date_type_id, new_val = newObj.projected_close_date_type_id });
            if (!Object.Equals(oldObj.projected_close_date_type_value, newObj.projected_close_date_type_value))
                list.Add(new ObjUpdateDto { field = "projected_close_date_type_value", old_val = oldObj.projected_close_date_type_value, new_val = newObj.projected_close_date_type_value });
            if (!Object.Equals(oldObj.primary_product_id, newObj.primary_product_id))
                list.Add(new ObjUpdateDto { field = "primary_product_id", old_val = oldObj.primary_product_id, new_val = newObj.primary_product_id });
            if (!Object.Equals(oldObj.promotion_name, newObj.promotion_name))
                list.Add(new ObjUpdateDto { field = "promotion_name", old_val = oldObj.promotion_name, new_val = newObj.promotion_name });
            if (!Object.Equals(oldObj.description, newObj.description))
                list.Add(new ObjUpdateDto { field = "description", old_val = oldObj.description, new_val = newObj.description });
            if (!Object.Equals(oldObj.last_activity_time, newObj.last_activity_time))
                list.Add(new ObjUpdateDto { field = "last_activity_time", old_val = oldObj.last_activity_time, new_val = newObj.last_activity_time });
            if (!Object.Equals(oldObj.market, newObj.market))
                list.Add(new ObjUpdateDto { field = "market", old_val = oldObj.market, new_val = newObj.market });
            if (!Object.Equals(oldObj.barriers, newObj.barriers))
                list.Add(new ObjUpdateDto { field = "barriers", old_val = oldObj.barriers, new_val = newObj.barriers });
            if (!Object.Equals(oldObj.help_needed, newObj.help_needed))
                list.Add(new ObjUpdateDto { field = "help_needed", old_val = oldObj.help_needed, new_val = newObj.help_needed });
            if (!Object.Equals(oldObj.next_step, newObj.next_step))
                list.Add(new ObjUpdateDto { field = "next_step", old_val = oldObj.next_step, new_val = newObj.next_step });
            if (!Object.Equals(oldObj.win_reason_type_id, newObj.win_reason_type_id))
                list.Add(new ObjUpdateDto { field = "win_reason_type_id", old_val = oldObj.win_reason_type_id, new_val = newObj.win_reason_type_id });
            if (!Object.Equals(oldObj.loss_reason_type_id, newObj.loss_reason_type_id))
                list.Add(new ObjUpdateDto { field = "loss_reason_type_id", old_val = oldObj.loss_reason_type_id, new_val = newObj.loss_reason_type_id });
            if (!Object.Equals(oldObj.win_reason, newObj.win_reason))
                list.Add(new ObjUpdateDto { field = "win_reason", old_val = oldObj.win_reason, new_val = newObj.win_reason });
            if (!Object.Equals(oldObj.loss_reason, newObj.loss_reason))
                list.Add(new ObjUpdateDto { field = "loss_reason", old_val = oldObj.loss_reason, new_val = newObj.loss_reason });
            if (!Object.Equals(oldObj.spread_revenue_recognition_value, newObj.spread_revenue_recognition_value))
                list.Add(new ObjUpdateDto { field = "spread_revenue_recognition_value", old_val = oldObj.spread_revenue_recognition_value, new_val = newObj.spread_revenue_recognition_value });
            if (!Object.Equals(oldObj.spread_revenue_recognition_unit, newObj.spread_revenue_recognition_unit))
                list.Add(new ObjUpdateDto { field = "spread_revenue_recognition_unit", old_val = oldObj.spread_revenue_recognition_unit, new_val = newObj.spread_revenue_recognition_unit });
            if (!Object.Equals(oldObj.number_months_for_estimating_total_profit, newObj.number_months_for_estimating_total_profit))
                list.Add(new ObjUpdateDto { field = "number_months_for_estimating_total_profit", old_val = oldObj.number_months_for_estimating_total_profit, new_val = newObj.number_months_for_estimating_total_profit });
            if (!Object.Equals(oldObj.one_time_revenue, newObj.one_time_revenue))
                list.Add(new ObjUpdateDto { field = "one_time_revenue", old_val = oldObj.one_time_revenue, new_val = newObj.one_time_revenue });
            if (!Object.Equals(oldObj.one_time_cost, newObj.one_time_cost))
                list.Add(new ObjUpdateDto { field = "one_time_cost", old_val = oldObj.one_time_cost, new_val = newObj.one_time_cost });
            if (!Object.Equals(oldObj.monthly_revenue, newObj.monthly_revenue))
                list.Add(new ObjUpdateDto { field = "monthly_revenue", old_val = oldObj.monthly_revenue, new_val = newObj.monthly_revenue });
            if (!Object.Equals(oldObj.monthly_cost, newObj.monthly_cost))
                list.Add(new ObjUpdateDto { field = "monthly_cost", old_val = oldObj.monthly_cost, new_val = newObj.monthly_cost });
            if (!Object.Equals(oldObj.quarterly_revenue, newObj.quarterly_revenue))
                list.Add(new ObjUpdateDto { field = "quarterly_revenue", old_val = oldObj.quarterly_revenue, new_val = newObj.quarterly_revenue });
            if (!Object.Equals(oldObj.quarterly_cost, newObj.quarterly_cost))
                list.Add(new ObjUpdateDto { field = "quarterly_cost", old_val = oldObj.quarterly_cost, new_val = newObj.quarterly_cost });
            if (!Object.Equals(oldObj.semi_annual_revenue, newObj.semi_annual_revenue))
                list.Add(new ObjUpdateDto { field = "semi_annual_revenue", old_val = oldObj.semi_annual_revenue, new_val = newObj.semi_annual_revenue });
            if (!Object.Equals(oldObj.semi_annual_cost, newObj.semi_annual_cost))
                list.Add(new ObjUpdateDto { field = "semi_annual_cost", old_val = oldObj.semi_annual_cost, new_val = newObj.semi_annual_cost });
            if (!Object.Equals(oldObj.yearly_revenue, newObj.yearly_revenue))
                list.Add(new ObjUpdateDto { field = "yearly_revenue", old_val = oldObj.yearly_revenue, new_val = newObj.yearly_revenue });
            if (!Object.Equals(oldObj.yearly_cost, newObj.yearly_cost))
                list.Add(new ObjUpdateDto { field = "yearly_cost", old_val = oldObj.yearly_cost, new_val = newObj.yearly_cost });
            if (!Object.Equals(oldObj.use_quote_revenue_and_cost, newObj.use_quote_revenue_and_cost))
                list.Add(new ObjUpdateDto { field = "use_quote_revenue_and_cost", old_val = oldObj.use_quote_revenue_and_cost, new_val = newObj.use_quote_revenue_and_cost });
            if (!Object.Equals(oldObj.ext1, newObj.ext1))
                list.Add(new ObjUpdateDto { field = "ext1", old_val = oldObj.ext1, new_val = newObj.ext1 });
            if (!Object.Equals(oldObj.ext2, newObj.ext2))
                list.Add(new ObjUpdateDto { field = "ext2", old_val = oldObj.ext2, new_val = newObj.ext2 });
            if (!Object.Equals(oldObj.ext3, newObj.ext3))
                list.Add(new ObjUpdateDto { field = "ext3", old_val = oldObj.ext3, new_val = newObj.ext3 });
            if (!Object.Equals(oldObj.ext4, newObj.ext4))
                list.Add(new ObjUpdateDto { field = "ext4", old_val = oldObj.ext4, new_val = newObj.ext4 });
            if (!Object.Equals(oldObj.ext5, newObj.ext5))
                list.Add(new ObjUpdateDto { field = "ext5", old_val = oldObj.ext5, new_val = newObj.ext5 });
            if (!Object.Equals(oldObj.start_date, newObj.start_date))
                list.Add(new ObjUpdateDto { field = "start_date", old_val = oldObj.start_date, new_val = newObj.start_date });
            if (!Object.Equals(oldObj.end_date, newObj.end_date))
                list.Add(new ObjUpdateDto { field = "end_date", old_val = oldObj.end_date, new_val = newObj.end_date });
            if (!Object.Equals(oldObj.actual_closed_time, newObj.actual_closed_time))
                list.Add(new ObjUpdateDto { field = "actual_closed_time", old_val = oldObj.actual_closed_time, new_val = newObj.actual_closed_time });
            if (list.Count == 0)
                return "";
            return new Tools.Serialize().SerializeJson(list);
        }
    }

}
