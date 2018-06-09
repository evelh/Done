
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_change_board_person_dal : BaseDAL<d_change_board_person>
    {
        public d_change_board_person GetSingleByBoardRes(long boardId,long resId)
        {
            return FindSignleBySql<d_change_board_person>($"SELECT * from d_change_board_person where delete_time =0 and change_board_id = {boardId} and resource_id ={resId}");
        }
    }
}
