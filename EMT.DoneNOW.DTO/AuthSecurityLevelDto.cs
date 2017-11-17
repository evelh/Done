using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 权限等级的limit和权限点(sys_permit)信息
    /// </summary>
    public class AuthSecurityLevelDto
    {
        public Dictionary<AuthLimitEnum, DicEnum.LIMIT_TYPE_VALUE> limitList { get; set; }
        /// <summary>
        /// 权限等级可用的权限点
        /// </summary>
        public List<AuthPermitDto> availablePermitList { get; set; }
        /// <summary>
        /// 权限等级不可用的权限点
        /// </summary>
        public List<AuthPermitDto> unAvailablePermitList { get; set; }
    }
}
