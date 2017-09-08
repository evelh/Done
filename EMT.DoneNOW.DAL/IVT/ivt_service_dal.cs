using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_service_dal : BaseDAL<ivt_service>
    {
        /// <summary>
        /// 根据条件获取到服务
        /// </summary>
        /// <param name="where"></param>
        /// <returns></returns>
        public List<ivt_service> GetServiceList(string where = "")
        {
            if (where != "")
            {
                return FindListBySql<ivt_service>($"select * from ivt_service where delete_time = 0 " + where);
            }

            return FindListBySql<ivt_service>($"select * from ivt_service where delete_time = 0");

        }
        /// <summary>
        /// 根据Id获取到单个的服务信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service GetSinService(long id)
        {
            return FindSignleBySql<ivt_service>($"select * from ivt_service where id = {id} and delete_time = 0");
        }
    }
}
