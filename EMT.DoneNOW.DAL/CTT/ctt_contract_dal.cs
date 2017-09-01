using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_dal : BaseDAL<ctt_contract>
    {
        public ctt_contract GetSingleContract(long id)
        {
            return FindSignleBySql<ctt_contract>($"select * from ctt_contract where id = {id} and delete_time = 0");
        }
    }

}
