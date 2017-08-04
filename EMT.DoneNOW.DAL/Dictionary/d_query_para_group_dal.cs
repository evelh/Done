using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_query_para_group_dal : BaseDAL<d_query_para_group>
    {
        /// <summary>
        /// 根据查询页面获取该查询页面内所有查询分组信息
        /// </summary>
        /// <param name="cateId"></param>
        /// <returns></returns>
        public List<d_query_para_group> GetListByCate(int cateId)
        {
            string sql = $"SELECT * FROM d_query_para_group WHERE cate_id={cateId} ORDER BY sort_order ASC";
            return FindListBySql(sql);
        }
    }

}
