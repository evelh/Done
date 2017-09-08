using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_service_bundle_dal : BaseDAL<ivt_service_bundle>
    {
        /// <summary>
        /// 获取到单个的服务包信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_service_bundle GetSinSerBun(long id)
        {
            return FindSignleBySql<ivt_service_bundle>($"select * from ivt_service_bundle where id = {id} and delete_time = 0") ;

        }
    }
}
