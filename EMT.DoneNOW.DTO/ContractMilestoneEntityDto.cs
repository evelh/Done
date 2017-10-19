using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 合同里程碑（加入物料代码名称）
    /// </summary>
    public class ContractMilestoneEntityDto
    {
        public Int64 id { get; set; }
        public Int64 oid { get; set; }
        public Int64 contract_id { get; set; }
        public Int32 status_id { get; set; }
        public DateTime due_date { get; set; }
        public Decimal? hours { get; set; }
        public Decimal? dollars { get; set; }
        public String name { get; set; }
        public String description { get; set; }
        public Int64? cost_code_id { get; set; }
        public String cost_code_name { get; set; }
        public String extacctitemid { get; set; }
        public SByte? is_initial_payment { get; set; }
        public Int32? type { get; set; }
    }
}
