using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class SysUserAddDto
    {
        public sys_resource sys_res;//系统资源
        public sys_user sys_user;//系统用户
        public tst_timeoff_policy_resource timeoffPolicy;   // 休假策略
        public sys_resource_availability availability;      // 每天工作时间
        public List<sys_resource_internal_cost> internalCost;   // 内部成本列表
    }
}
