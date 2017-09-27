using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data.SqlClient;
using System.Data;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class sys_quote_tmpl_dal : BaseDAL<sys_quote_tmpl>
    {

        //联合查询,获得报价模板可显示修改变量
        //SELECT a.name,b.id from d_general a,(SELECT id,ext1 from d_general where general_table_id=23 and parent_id=105 ORDER BY id) b
        // where a.id=b.ext1
        public List<DictionaryEntryDto> GetDictionary(int general_table_id,int parent_id)
        {
            d_general_dal a = new d_general_dal();
            string where = $"SELECT a.name,b.id from d_general a,(SELECT id,ext1 from d_general where general_table_id='{general_table_id}' and parent_id='{parent_id}' ORDER BY id) b where a.id=b.ext1";
            List<d_general> all = a.FindListBySql(QueryStringDeleteFlag(where));
            List<DictionaryEntryDto> list = new List<DictionaryEntryDto>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                if (entry.is_default == 1)
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name, 1));
                else
                    list.Add(new DictionaryEntryDto(entry.id.ToString(), entry.name));
            }

            return list;
        }
        /// <summary>
        ///获得全部显示变量
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllVariable()
        {
            d_query_result_dal a = new d_query_result_dal();
            StringBuilder sql = new StringBuilder();
            sql.Append(@"select b.col_comment FROM d_tmpl_cate_var a,d_query_result b,d_general c,");
            sql.Append(@"(SELECT id from d_general where general_table_id="+(int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP);
            sql.Append(" and parent_id = "+(int)DicEnum.NOTIFY_CATE.QUOTE_TEMPLATE_OTHERS + " ORDER BY id) d ");
            sql.Append(@" WHERE	a.query_result_id = b.id ");
            sql.Append(@"AND c.parent_id = a.template_cate_id ");
            sql.Append(@" AND c.ext1 = template_data_group_id");
            sql.Append(@" AND c.id=d.id");
            List<d_query_result> all = a.FindListBySql(sql.ToString());
            List<string> list = new List<string>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                list.Add(entry.col_comment);

            }
            return list;
        }
        /// <summary>
        ///获得全部发票显示变量
        /// </summary>
        /// <returns></returns>
        public List<string> GetAllInvoiceVariable()
        {
            d_query_result_dal a = new d_query_result_dal();
            StringBuilder sql = new StringBuilder();
            sql.Append(@"select b.col_comment FROM d_tmpl_cate_var a,d_query_result b,d_general c,");
            sql.Append(@"(SELECT id from d_general where general_table_id=" + (int)GeneralTableEnum.NOTIFICATION_TEMPLATE_CATE_DATE_GROUP);
            sql.Append(" and parent_id = " + (int)DicEnum.NOTIFY_CATE.INVOICE_TEMPLATE_OTHERS + " ORDER BY id) d ");
            sql.Append(@" WHERE	a.query_result_id = b.id ");
            sql.Append(@"AND c.parent_id = a.template_cate_id ");
            sql.Append(@" AND c.ext1 = template_data_group_id");
            sql.Append(@" AND c.id=d.id");
            List<d_query_result> all = a.FindListBySql(sql.ToString());
            List<string> list = new List<string>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                list.Add(entry.col_comment);

            }
            return list;
        }

        public List<string> GetVariable(int id)
        {
            d_query_result_dal a = new d_query_result_dal();
            StringBuilder sql = new StringBuilder();
            sql.Append(@"select b.col_comment FROM d_tmpl_cate_var a,d_query_result b,d_general c ");
            sql.Append(@" WHERE	a.query_result_id = b.id ");
            sql.Append(@"AND c.parent_id = a.template_cate_id ");
            sql.Append(@" AND c.ext1 = template_data_group_id");
            sql.Append(@" AND c.id="+id);
            List<d_query_result> all = a.FindListBySql(sql.ToString());
            List<string> list = new List<string>();
            if (all == null)
                return list;
            foreach (var entry in all)
            {
                list.Add(entry.col_comment);

            }
            return list;
        }

        public List<sys_quote_tmpl> GetQuoteTemp(string where = "")
        {
            if (where == "")
            {
                return FindListBySql("select * from sys_quote_tmpl where cate_id = 1 and delete_time=0 ");
            }
            else
            {
                return FindListBySql("select * from sys_quote_tmpl where cate_id = 1 and delete_time=0 " + where);
            }
        }

        /// <summary>
        /// 获取到发票模板
        /// </summary>
        public List<sys_quote_tmpl> GetInvoiceTemp(string where = "")
        {
            if (where == "")
            {
                return FindListBySql("select * from sys_quote_tmpl where cate_id = 2 and  delete_time=0 ");
            }
            else
            {
                return FindListBySql("select * from sys_quote_tmpl where cate_id = 2 and delete_time=0 " + where);
            }
        }


    }

}