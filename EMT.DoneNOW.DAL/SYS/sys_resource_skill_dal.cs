using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_resource_skill_dal : BaseDAL<sys_resource_skill>
    {
        /// <summary>
        /// 根据类别删除员工技能
        /// </summary>
        public List<sys_resource_skill> GetSkillByClass(long classId)
        {
            return FindListBySql("SELECT * from sys_resource_skill where skill_class_id ="+classId.ToString());
        }
        /// <summary>
        /// 根据类型删除员工技能
        /// </summary>
        public List<sys_resource_skill> GetSkillBType(long typeId)
        {
            return FindListBySql("SELECT * from sys_resource_skill where skill_type_id = "+ typeId.ToString());
        }
    }

}
