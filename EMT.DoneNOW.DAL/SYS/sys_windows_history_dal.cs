
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_windows_history_dal : BaseDAL<sys_windows_history>
    {
        /// <summary>
        /// 查询所有的浏览记录
        /// </summary>
        public List<sys_windows_history> GetHisList(long? userId=null)
        {
            string where = "";
            if (userId != null)
                where = $" where create_user_id = {userId} ";
            return FindListBySql<sys_windows_history>($"SELECT * from sys_windows_history {where} order by create_time desc");
        }
        /// <summary>
        /// 根据URL 获取相应记录
        /// </summary>
        public sys_windows_history GetByUrl(string url,long userId)
        {
            return FindSignleBySql<sys_windows_history>($"SELECT * from sys_windows_history where url='{url}' and create_user_id={userId}");
        }
    }
}
