using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_service_dal : BaseDAL<ctt_contract_service>
    {

        public List<ctt_contract_service> GetConSerList(long contract_id)
        {
            return FindListBySql<ctt_contract_service>($"SELECT * from ctt_contract_service where contract_id = {contract_id} and delete_time = 0");
        }

        public ctt_contract_service GetSinConSer(long service_id)
        {
            return FindSignleBySql<ctt_contract_service>($"SELECT * from ctt_contract_service where id = {service_id} and delete_time = 0");
        }

        
    }

}
