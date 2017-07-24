using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.DAL
{
    public class d_district_dal : BaseDAL<d_district>
    {
        /// <summary>
        /// 根据父id获取可见的行政区列表
        /// </summary>
        /// <param name="parentId"></param>
        /// <returns></returns>
        public List<d_district> GetDistrictByParent(int parentId)
        {
            string sql = $"SELECT * FROM d_district WHERE parent_id={parentId} AND status_id=0";
            return FindListBySql(sql);
        }
    }
}
