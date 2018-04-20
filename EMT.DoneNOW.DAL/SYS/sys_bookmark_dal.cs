
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_bookmark_dal : BaseDAL<sys_bookmark>
    {
        /// <summary>
        /// 获取用户这个URL 的书签
        /// </summary>
        public sys_bookmark GetSingBook(string url,long userId)
        {
            return FindSignleBySql<sys_bookmark>($"SELECT * from sys_bookmark where create_user_id = {userId} and url='{url}'");
        }
        /// <summary>
        /// 获取用户的所有书签
        /// </summary>
        public List<sys_bookmark> GetBookList(long userId)
        {
            return FindListBySql<sys_bookmark>($"SELECT * from sys_bookmark where create_user_id = {userId} ");
        }
        /// <summary>
        /// 删除该用户下的所有书签
        /// </summary>
        public bool DeleteBook(long userId)
        {
            return ExecuteSQL("delete from sys_bookmark where create_user_id = "+ userId) >0;
        }
        /// <summary>
        /// 删除用户选择的书签
        /// </summary>
        public bool DeleteBook(string ids, long userId)
        {
            if (string.IsNullOrEmpty(ids))
                return false;
            return ExecuteSQL($"delete from sys_bookmark where id in ({ids}) and create_user_id = " + userId) > 0;
        }
    }
}
