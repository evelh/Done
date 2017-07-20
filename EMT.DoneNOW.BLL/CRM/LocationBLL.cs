using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.BLL.CRM
{
    public class LocationBLL
    {
        private readonly crm_location_dal _dal = new crm_location_dal();

        /// <summary>
        /// 获取到用户的默认地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_location GetLocationByAccountId(long account_id)
        {
            return new crm_location_dal().GetLocationByAccountId(account_id);
        }

    }
}
