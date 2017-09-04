using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 新增合同实体
    /// </summary>
    public class ContractAddDto
    {
        public ctt_contract contract;           // 合同信息
        public List<UserDefinedFieldValue> udf; // 合同自定义字段
    }
}
