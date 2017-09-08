using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class pro_project_dal : BaseDAL<pro_project>
    {
        public pro_project GetProjectById(long id)
        {
            return FindSignleBySql<pro_project>($"select * from pro_project where id = {id} and delete_time = 0");
        }
    }
}
