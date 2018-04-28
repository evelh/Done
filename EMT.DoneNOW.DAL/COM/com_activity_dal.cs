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
        /// <summary>
        /// 获取未完成的待办
        /// </summary>
        public List<com_activity> GetNoCompleteTodo(long userId)
        {
            return FindListBySql<com_activity>($"SELECT * from com_activity where cate_id = {(int)DTO.DicEnum.ACTIVITY_CATE.TODO} and resource_id = {userId} and status_id = {(int)DTO.DicEnum.ACTIVITY_STATUS.NOT_COMPLETED} and delete_time = 0");
        }
        /// <summary>
        /// 根据客户获取相关备注
        /// </summary>
        public List<com_activity> GetNoteByAccount(long accountId, int cateId = (int)DTO.DicEnum.ACTIVITY_CATE.NOTE)
        {
            return FindListBySql($"SELECT * from com_activity where cate_id = {cateId} and account_id = {accountId} and delete_time = 0");
        }
        /// <summary>
        /// 获取今天创建的待办的数量
        /// </summary>
        public int GetTodoCountByRes(long userId,string where ="")
        {
            if (userId != 0)
                where += $" and resource_id ={userId}";
            return Convert.ToInt32(GetSingle($"SELECT count(1) from com_activity where cate_id = {(int)DTO.DicEnum.ACTIVITY_CATE.TODO} and delete_time = 0"+ where));
        }

    }
}
