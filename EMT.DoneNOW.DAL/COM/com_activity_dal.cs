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
        /// <summary>
        /// 根据对象Id 获取对象相关备注
        /// </summary>
        public List<com_activity> GetActiListByOID(long oid,string where ="")
        {
            return FindListBySql<com_activity>($"SELECT * from com_activity where delete_time = 0 and object_id = {oid} "+where);
        }
    }
}
