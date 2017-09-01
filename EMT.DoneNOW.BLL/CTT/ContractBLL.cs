using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class ContractBLL
    {
        /// <summary>
        /// 获取SLA列表
        /// </summary>
        /// <returns></returns>
        public List<d_sla> GetSLAList()
        {
            return new d_sla_dal().GetList();
        }
    }
}
