
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_change_board_dal : BaseDAL<d_change_board>
    {
        public List<d_change_board> GetChangeList()
        {
            return FindListBySql($"SELECT * from d_change_board where delete_time = 0 and is_active = 1");
        }
        // 
    }
}
