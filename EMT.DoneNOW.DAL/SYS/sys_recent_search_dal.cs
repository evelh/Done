using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_recent_search_dal : BaseDAL<sys_recent_search>
    {
        /// <summary>
        /// 获取默认查询条件
        /// </summary>
        public sys_recent_search GetByUrl(string url)
        {
            return FindSignleBySql<sys_recent_search>($"SELECT * from sys_recent_search where url like '%{url}%'");
        }
        /// <summary>
        /// 获取查询历史
        /// </summary>
        public List<sys_recent_search> GetListByUpdate(string url)
        {
            return FindListBySql<sys_recent_search>($"SELECT * from sys_recent_search where url like '%{url}%' ORDER BY update_time desc  LIMIT 20");
        }

        public sys_recent_search GetByCon(string condit,string url = "")
        {
            return FindSignleBySql<sys_recent_search>($"SELECT * from sys_recent_search where conditions='{condit}' {(!string.IsNullOrEmpty(url)? " and url like '%"+url+"%'" : "")}");
        }
    }
}
