using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class ServiceBLL
    {
        /// <summary>
        /// 获取ivt_service实体
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service GetServiceById(long id)
        {
            return new ivt_service_dal().FindById(id);
        }

        /// <summary>
        /// 获取ivt_service_bundle实体
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service_bundle GetServiceBundleById(long id)
        {
            return new ivt_service_bundle_dal().FindById(id);
        }

        /// <summary>
        /// 获取服务包包含的服务列表
        /// </summary>
        /// <param name="serviceBundleId"></param>
        /// <returns></returns>
        public List<ivt_service_bundle_service> GetServiceListByServiceBundleId(long serviceBundleId)
        {
            return new ivt_service_bundle_service_dal().FindListBySql($"SELECT * FROM ivt_service_bundle_service WHERE service_bundle_id={serviceBundleId}");
        }
    }
}
