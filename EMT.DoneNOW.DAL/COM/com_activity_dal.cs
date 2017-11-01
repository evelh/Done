using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class com_activity_dal : BaseDAL<com_activity>
    {
        public List<com_activity> GetActiList(string where="")
        {
            return FindListBySql<com_activity>($"SELECT * from com_activity where delete_time = 0 "+where);
        }
    }
}
