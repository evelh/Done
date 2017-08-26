using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 安全等级
    /// </summary>
    public class SecurityLevelDto
    {
        public long id;            // 安全等级的id
        public sbyte isSystem;     // 是否系统的安全等级
        public string name;        // 安全等级名称
        public string description; // 描述
        public Dictionary<AuthLimitEnum, DicEnum.LIMIT_TYPE_VALUE> limit;  // 权限点
        public List<ModuleEnum> modules;                                       // 模块
    }
}
