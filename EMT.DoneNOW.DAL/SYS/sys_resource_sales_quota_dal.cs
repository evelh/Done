
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_resource_sales_quota_dal : BaseDAL<sys_resource_sales_quota>
    {
        /// <summary>
        /// 获取员工的销售目标
        /// </summary>
        public List<sys_resource_sales_quota> GetQuotaByResIds(string ids,int year,int month)
        {
            return FindListBySql($"SELECT * from sys_resource_sales_quota where delete_time = 0 and year={year} and month = {month} and resource_id in ({ids})");
               
        }
    }
}
