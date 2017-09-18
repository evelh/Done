using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;

namespace EMT.DoneNOW.DAL
{
    public class crm_quote_dal : BaseDAL<crm_quote>
    {

        /// <summary>
        /// 取到报价信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_quote GetQuote(long id)
        {
            return FindSignleBySql<crm_quote>($"select * from crm_quote where id = {id} and delete_time=0");
        }

        /// <summary>
        /// 根据商机获取到相关报价
        /// </summary>
        /// <param name="opportunity_id"></param>
        /// <returns></returns>
        public List<crm_quote> GetQuoteByOpportunityId(long opportunity_id)
        {
            return FindListBySql<crm_quote>($"select * from crm_quote where opportunity_id = {opportunity_id} and delete_time=0");
        }
        /// <summary>
        /// 通过传过来的条件进行报价的查询，不传递参数代表查询所有报价
        /// </summary>
        /// <param name="where">查询参数</param>
        /// <returns></returns>
        public List<crm_quote> GetQuoteByWhere(string where = "")
        {
            if (where != "")
                return FindListBySql<crm_quote>($"select * from crm_quote where delete_time=0 " + where);
            return FindListBySql<crm_quote>($"select * from crm_quote where  delete_time=0 ");
        }     
        public DataTable GetVar(int cid, int aid, int qid,int oid)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("select * from ");
            //联系人901
            sql.Append(@"(select  (select name from crm_account where id=c.account_Id) as '[Contact: Company]', (case when is_active=1 then '已激活' else '未激活'end ) as '[联系人：激活的]', NULL as '[联系人：外部编号]', c.title as '[联系人：称呼]', c.first_name as '[联系人：名]', c.last_name as '[联系人：姓]', (select name from d_general where id=c.suffix_id) as '[联系人：后缀]', null as '[联系人：中间名]', c.name as '[联系人：姓名]', c.name as '[联系人：姓名（链接）]', c.name as '[联系人：链接]', c.ID as '[Contact: ID]', null as '[联系人：头衔]', l.address as '[联系人：地址]', l.additional_address as '[联系人：补充地址]', (select name from d_district where id=l.city_id) as '[联系人：城市]', (select name from d_district where id=l.province_id) as '[联系人：省]', l.postal_code as '[Contact: Post Code]', (select name from d_country where id=l.country_id) as '[联系人：国家]', c.email as '[联系人：邮件地址]', c.phone as '[联系人：电话]', null as '[联系人：电话分机]', c.alternate_phone as '[联系人：备用电话]', c.mobile_phone as '[联系人：移动电话]', c.fax as '[联系人：传真]', null as '[联系人：Client Access Portal用户姓名]', c.email2 as '[Contact: Alternate Email1]', null as '[Contact: Customer Contact]', null as '[Contact: Address]' from crm_contact c LEFT JOIN crm_location l on c.location_id = l.id where 1 = 1    and c.id in(" + cid + ") and 1 = 1  order by  c.name) as aa,");
            //客户900
            sql.Append(@"(select s.col001 as '[Site Configuration: Building Security Code]',a.name as '[客户：名称]',s.col009 as '[Site Configuration: DNS - Password]',a.name as '[客户：名称（链接）]',s.col007 as '[Site Configuration: DNS - Provider]',a.name as '[客户：链接]',s.col008 as '[Site Configuration: DNS - Username]',a.oid as '[Company: ID]',s.col011 as '[Site Configuration: Email Certificates - Host Name]',a.no as '[客户：编号]',s.col010 as '[Site Configuration: Email Certificates - Provider]',(CASE WHEN a.is_active=1 THEN '激活' else '未激活'  END) as '[客户：激活的]',s.col002 as '[Site Configuration: ISP Provider Phone Number]',l.additional_address as '[客户：补充地址]',s.col003 as '[Site Configuration: Web Hosting - Contact]',null as '[客户：其他地址]',s.col004 as '[Site Configuration: Web Hosting - Primary Phone #]',l.city_name as '[客户：城市]',s.col006 as '[Site Configuration: Web Hosting - PW]',l.province_name as '[客户：省]',s.col005 as '[Site Configuration: Web Hosting - UN]',l.postal_code as '[Company: Post Code]',s.col012 as '[Site Configuration: WAN - Vendor]',(select country_name_display from d_country where id=l.country_id) as '[客户：国家]',s.col013 as '[Site Configuration: WAN - Static IP]',a.phone as '[客户：电话]',s.col014 as '[Site Configuration: WAN - Gateway]',a.alternate_phone1 as '[客户：备用电话1]',s.col015 as '[Site Configuration: WAN - Subnet Mask]',a.alternate_phone2 as '[客户：备用电话2]',s.col016 as '[Site Configuration: WAN - DNS - Primary]',a.fax as '[客户：传真]',s.col017 as '[Site Configuration: WAN - DNS - Secondary]',a.web_site as '[客户：网址]',s.col018 as '[Site Configuration: LAN - Domain]',(select name from d_general where  id=a.type_id) as '[客户：类型]',s.col019 as '[Site Configuration: LAN - IP Address]',(select icon_path from d_account_classification where id=a.classification_id) as '[Company: Classification Icon]',s.col020 as '[Site Configuration: LAN - Admin Password]',(select name from d_account_classification where id=a.classification_id) as '[Company: Classification Name]',s.col021 as '[Site Configuration: Domain Controller - OS]',u.name as '[Company: Account Manager]',s.col022 as '[Site Configuration: Domain Controller - Name]',u.title as '[Company: Account Manager Prefix]',s.col023 as '[Site Configuration: Domain Controller - IP]',u.first_name as '[Company: Account Manager First Name]',s.col024 as '[Site Configuration: Domain Controller - Roles]',u.last_name as '[Company: Account Manager Last Name]',(select name from d_general where id=u.suffix_id) as '[Company: Account Manager Suffix]',u.office_phone as '[Company: Account Manager Office Phone]',null as '[Company: Account Manager Office Phone Extension]',u.home_phone as '[Company: Account Manager Home Phone]',u.mobile_phone as '[Company: Account Manager Mobile Phone]',u.email as '[Company: Account Manager Email Address]',u.email1 as '[Company: Account Manager Email Address 1]',u.email2 as '[Company: Account Manager Email Address 2]',(select name from d_general where id =a.territory_id) as '[客户：地域]',(select name from d_general where id =a.market_segment_id) as '[客户：市场领域]',(select name from d_general where id =a.competitor_id) as '[客户：竞争对手]',(select name from crm_account where id=a.parent_id) as '[Company: Parent Company]',FROM_UNIXTIME( a.last_activity_time/1000,'%Y-%m-%d %H:%i:%s') as '[客户：最近活动日期]',null as '[Company: Account Team Members]',null as '[Company: Account Team Members (with Email Address)]',null as '[Company: Account Team Members (with Office Phone)]',null as '[Company: Account Team Members (with Office Phone and Email Address)]',null as '[Company: label time]',null as '[Company: Lead Source]',null as '[Company: Number of Employees]',null as '[Company: test001]',a.tax_identification as '[客户：税收编号]',l.address as '[客户：地址]',null as '[客户：其它地址信息]',null as '[Company: Currency]',null as '[Company: Currency Display Symbol]',null as '[Company: Currency Exchange Rate]' from crm_account a join crm_account_site_ext s on a.id=s.parent_id left join sys_resource u on a.resource_id=u.id LEFT JOIN (select cl.*,(select name from d_district where id=cl.province_id)province_name,(select name from d_district where id=cl.city_id)city_name from crm_location cl where is_default=1) l on a.id=l.account_id where a.delete_time=0    and a.id=" + aid + " and 1=1  order by a.name) as bb,");
            //报价909
            sql.Append(@"(select q.name as '[报价：名称]',q.name as '[Quote: Name (with link to edit page)]',q.name as '[Quote: Link to Edit Page]',FROM_UNIXTIME(q.create_time,'%Y-%m-%d') as '[报价：创建日期]',q.description as '[报价：描述]',DATE_FORMAT( q.effective_date, '%Y-%m-%d') as '[报价：生效日期]',DATE_FORMAT( q.expiration_date, '%Y-%m-%d') as '[报价：过期日期]',a.name as '[Quote: Company]',o.name as '[Quote: Opportunity Name]',DATE_FORMAT( q.projected_close_date, '%Y-%m-%d') as '[报价：预计完成日期]',o.Probability as '[报价：成交概率]', c.name as '[报价：联系人]', c.title as '[报价：联系人称呼]', c.last_name as '[报价：联系人名]', c.first_name as '[报价：联系人姓]', (select name from d_general where id = c.suffix_id) as '[报价：联系人后缀]', (select name from d_general where id=q.tax_region_id) as '[报价：税区域]', (CASE WHEN q.is_active=1 THEN '激活' else '未激活'  END) as '[Quote: Quote Active]', q.external_quote_no as '[报价：外部报价编号]', q.quote_comment as '[报价：注释]', (select name from d_general where id = q.payment_term_id) as '[报价：付款期限]', (select name from d_general where id = q.payment_type_id) as '[报价：付款类型]', q.purchase_order_no as '[报价：购买订单编号]', (select name from d_general where id = q.shipping_type_id) as '[报价：配送类型]', l.address as '[报价：买家 - 地址]', l.additional_address as '[报价：买家 - 补充地址]', l.city as '[报价：买家 - 城市]', l.province as '[报价：买家 - 省]', l.postal_code as '[Quote: Sold To - Post Code]', m.address as '[Quote: Billing Address 1]', m.additional_address as '[Quote: Billing Address 2]', m.city as '[Quote: Billing Address City]', m.province as '[Quote: Billing Address State]', m.postal_code as '[Quote: Billing Address Post Code]', n.address as '[Quote: Shipping Address 1]', n.additional_address as '[Quote: Shipping Address 2]', n.city as '[Quote: Shipping City]', n.province as '[Quote: Shipping State]', n.postal_code as '[Quote: Shipping Post Code]', q.oid as '[Quote: Quote Number]',null as '[Quote: Tax]',null as '[Quote: Tax Detail]' from crm_quote q JOIN crm_opportunity o on q.opportunity_id=o.id join crm_account a on o.account_id = a.id left join crm_contact c on q.contact_id = c.id 
left join (select cl.*,(select name from d_district where id=cl.city_id) city,(select name from d_district where id=cl.province_id) province from crm_location cl)l on q.sold_to_location_id = l.id
left join (select cl.*,(select name from d_district where id=cl.city_id) city,(select name from d_district where id=cl.province_id) province from crm_location cl)m on q.bill_to_location_id = m.id
left join (select cl.*,(select name from d_district where id=cl.city_id) city,(select name from d_district where id=cl.province_id) province from crm_location cl)n on q.ship_to_location_id = n.id where q.delete_time=0
    and q.id=" + qid + " and 1=1  order by q.name) as qq,");



            //商机903
            sql.Append(@"(select o.name as '[Opportunity: Name]',o.name as '[Opportunity: Name (with link)]',o.name as '[商机：链接]',a.name as '[Opportunity: Company]',c.name as '[商机：联系人]',c.title as '[商机：联系人称呼]',c.last_name as '[商机：联系人名]',c.first_name as '[商机：联系人姓]',(select name from d_general where id = c.suffix_id) as '[商机：联系人后缀]',u.name as '[商机：所有人]',u.title as '[商机：所有人称呼]',u.last_name as '[商机：所有人名]',u.first_name as '[商机：所有人姓]',(select name from d_general where id = u.suffix_id) as '[商机：所有人后缀]',(select name from d_general where id=o.stage_id) as '[商机：阶段]',(select name from d_general where id=o.source_id) as '[Opportunity: Lead Source]',(select name from d_general where id=o.status_id) as '[商机：状态]',o.probability  as '[商机：成交概率]',o.create_time as '[商机：创建日期]',DATE_FORMAT(o.projected_close_date, '%Y-%m-%d') as '[商机：预计完成日期]',DATEDIFF(NOW(),o.projected_close_date) as '[Opportunity: Past Projected Close Date by (days)]',DATEDIFF(o.projected_close_date,NOW()) as '[Opportunity: Projected Close Date in (days)]',FROM_UNIXTIME(o.actual_closed_time,'%Y-%m-%d') as '[商机：关闭日期]',(select name from ivt_product where id = primary_product_id) as '[商机：主要产品]',o.promotion_name as '[商机：促销]',o.total_revenue as '[商机：收入]',o.total_cost as '[商机：成本]',o.gross_profit as '[商机：毛利润]',round(o.gross_profit*100/o.total_revenue,2) as '[商机：毛利润%]',o.spread_value as '[商机：商机收入周期范围]',DATE_FORMAT( o.start_date, '%Y-%m-%d') as '[Opportunity: Promised Fulfillment Date]',DATE_FORMAT( o.end_date, '%Y-%m-%d') as '[Opportunity: End Date]',round(o.ext1,2) as '[Opportunity: 1. Professional Services]',round(o.ext2,2) as '[Opportunity: 2. Training Fees]',round(o.ext3,2) as '[Opportunity: 3. Hardware Fees]',round(o.ext4,2) as '[Opportunity: 4. Monthly User Fees]',round(o.ext5,2) as '[Opportunity: 5. Other Fees]',o.market as '[商机：市场]',o.barriers as '[商机：障碍]',o.help_needed as '[商机：需要帮助]',o.next_step as '[商机：下一步]','Re - assign Instructions 活动表获取' as '[商机：重新分配说明]','Re - assigned FROM 活动表获取' as '[商机：再分配人]',(select name from d_general where id=o.interest_degree_id) as '[商机：等级]',null as '[商机：变动]',(select address from sys_organization_location where id = u.location_id) as '[Opportunity: Owner Address]',null as '[Opportunity: Owner Address 1]',null as '[Opportunity: Owner Address 2]',l.city as '[Opportunity: Owner City]',l.province as '[Opportunity: Owner State]',l.postal_code as '[Opportunity: Owner Post Code]',l.country as '[Opportunity: Owner Country]',u.office_phone as '[Opportunity: Owner Office Phone]',null as '[Opportunity: Owner Office Phone Extension]',u.home_phone as '[Opportunity: Owner Home Phone]',u.mobile_phone as '[Opportunity: Owner Mobile Phone]',u.email as '[Opportunity: Owner Email Address]',u.email1 as '[Opportunity: Owner Additional Email Address 1]' from (select o.*,round((o.one_time_revenue+o.monthly_revenue*o.number_months+o.quarterly_revenue*o.number_months/3+o.semi_annual_revenue*o.number_months/6+o.yearly_revenue*o.number_months/12),2)total_revenue,round((o.one_time_cost+o.monthly_cost*o.number_months+o.quarterly_cost*o.number_months/3+o.semi_annual_cost*o.number_months/6+o.yearly_cost*o.number_months/12),2) total_cost,round((o.one_time_revenue+o.monthly_revenue*o.number_months+o.quarterly_revenue*o.number_months/3+o.semi_annual_revenue*o.number_months/6+o.yearly_revenue*o.number_months/12-o.one_time_cost+o.monthly_cost*o.number_months+o.quarterly_cost*o.number_months/3+o.semi_annual_cost*o.number_months/6+o.yearly_cost*o.number_months/12),2)gross_profit,(case when (select count(1)from crm_quote where opportunity_id=o.id and delete_time=0)>0 then 1 else 0  end)has_quote from crm_opportunity o) o
join crm_account a on o.account_id = a.id left join (select * from crm_quote where delete_time=0 and is_primary_quote=1) q on o.id = q.opportunity_id
left join crm_contact c on o.contact_id=c.id left join sys_resource u on o.resource_id=u.id
left join (select cl.*,(select name from d_district where id=cl.city_id) city,(select name from d_district where id=cl.province_id) province,(select country_name_display from d_country where id=cl.country_id) country from sys_organization_location cl)l on u.location_id = l.id where o.delete_time=0    and o.id=" + oid + " and 1=1  order by o.name) as oo");
            var list = ExecuteDataTable(sql.ToString());
            return list;
        }

        public DataTable GetQuoteItemVar(int qiid)
        {
            //以后需要更改9-6
            //string sql = "select f_rpt_getsql(932,932,null,'{\"q:id\":\""+qiid+"\"}',null)";
            //sql=ExecuteDataTable(sql).Rows[0][0].ToString();
            //return ExecuteDataTable(sql);
            StringBuilder sql = new StringBuilder();
            sql.Append("select * from ");
            //报价子项932 body 变量parent_id=106
            sql.Append(@" (select  q.name as '[报价项: 名称]', q.description as '[报价项: 说明]', (select name from d_general where id = period_type_id) as '[Quote Item: Period Type]', q.unit_price as '[Quote Item: Unit Price]', q.quantity as '[Quote Item: Quantity]', round(q.unit_price*q.quantity,2) as '[Quote Item: Extended Price]', q.unit_discount as '[Quote Item: Unit Discount]', round(q.unit_discount*q.quantity,2) as '[Quote Item: Line Discount]' FROM crm_quote_item q where q.delete_time=0    and q.id =" + qiid + " and 1=1  order by q.name) as qi");
            var list = ExecuteDataTable(sql.ToString());
            return list;
        }       
        /// <summary>
        /// 根据报价id获取商机信息
        /// </summary>
        /// <param name="quote_id"></param>
        /// <returns></returns>
        public crm_opportunity GetOppoByQuoteId(long quote_id)
        {
            return FindSignleBySql<crm_opportunity>($"select op.* FROM crm_quote q LEFT JOIN crm_opportunity op on op.id = q.opportunity_id where q.id={quote_id}");
        }
    }
}
