
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_service_call_dal : BaseDAL<sdk_service_call>
    {
        // 
        public List<sdk_service_call> GetCallByAccount(long accountId)
        {
            return FindListBySql<sdk_service_call>($"SELECT * from sdk_service_call where account_id = {accountId} and delete_time = 0");
        }
    }
}
