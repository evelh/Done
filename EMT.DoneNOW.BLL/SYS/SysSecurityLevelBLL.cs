using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    public class SysSecurityLevelBLL
    {
        private readonly sys_limit_dal _dal = new sys_limit_dal();
        public List<sys_limit> GetAll() {
            return _dal.FindAll().ToList<sys_limit>();
        }
        public Dictionary<int, string> GetDownList(int parent_id)
        {
            Dictionary<int, string> dic = new Dictionary<int, string>();
            return new d_general_dal().FindListBySql($"select * from d_general where parent_id ={parent_id}").ToDictionary(d => d.id, d => d.name);   

        }
        public sys_security_level GetSecurityLevel(long id) {
            return new sys_security_level_dal().FindById(id);
        }
    }
}
