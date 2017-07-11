
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class com_note_dal : BaseDAL<com_note>
    {
        /// <summary>
        /// 通过客户ID去获取备注信息，按照开始时间倒序显示
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<com_note> FindNoteByAccountId(long account_id)
        {
            return FindListBySql($"select * from com_note where account_id = {account_id} and delete_time = 0 ORDER BY start_date DESC");
        }
    }
}
