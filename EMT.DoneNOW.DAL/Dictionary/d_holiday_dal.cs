
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_holiday_dal : BaseDAL<d_holiday>
    {
        /// <summary>
        /// 根据设置ID去获取相应的节假日设置日期
        /// </summary>
        public List<d_holiday> GetHoliDays(long holSetId)
        {
            return FindListBySql<d_holiday>($"SELECT * from d_holiday where holiday_set_id = {holSetId}");
        }
    }
}
