using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class pro_project_calendar_dal : BaseDAL<pro_project_calendar>
    {
        public List<pro_project_calendar> GetCalByPro(long project_id)
        {
            return FindListBySql<pro_project_calendar>($"SELECT * from pro_project_calendar where delete_time = 0 and project_id = {project_id}");
        }
    }
}
