using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_service_bundle_service_dal : BaseDAL<ivt_service_bundle_service>
    {
        /// <summary>
        /// 根据服务包获取到相对应服务
        /// </summary>
        /// <param name="serBagId"></param>
        /// <returns></returns>
        public List<ivt_service_bundle_service> GetSerList(long serBagId)
        {
            return FindListBySql<ivt_service_bundle_service>($"SELECT * from ivt_service_bundle_service where service_bundle_id = {serBagId}");
        }
    }
}
