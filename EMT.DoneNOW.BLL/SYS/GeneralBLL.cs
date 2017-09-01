using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 字典项相关
    /// </summary>
    public class GeneralBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();
        /// <summary>
        /// 根据tableId获取字典值列表
        /// </summary>
        /// <param name="tableId"></param>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetDicValues(GeneralTableEnum tableId)
        {
            var table = new d_general_table_dal().GetById((int)tableId);
            return new d_general_dal().GetDictionary(table);
        }

        /// <summary>
        /// 根据字典项的table name和字典项name获取字典项id
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="generalName"></param>
        /// <returns></returns>
        public long GetGeneralId(string tableName, string generalName)
        {
            var tableDal = new d_general_table_dal();
            var generalDal = new d_general_dal();
            var table = tableDal.GetSingle(tableDal.QueryStringDeleteFlag($"SELECT * FROM d_general_table WHERE name='{tableName}'")) as d_general_table;
            if (table == null)
                return 0;
            var general = generalDal.GetSingle(generalDal.QueryStringDeleteFlag($"SELECT * FROM d_general WHERE general_table_id={table.id} AND name='{generalName}'")) as d_general;
            if (general == null)
                return 0;
            return general.id;
        }
        /// <summary>
        /// 通过id获取一个d_general对象，并返回
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_general GetSingleGeneral(long id) {
            return _dal.FindById(id);
        }
        /// <summary>
        /// 通过name和general_table_id获取一个d_general对象，并返回
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public d_general GetSingleGeneral(string name,int general_table_id) {
            return _dal.FindSignleBySql<d_general>($"select * from d_general where name='{name}' and general_table_id={general_table_id} and delete_time=0");
        }
        public List<d_general> GetGeneralList(int general_table_id) {
            return _dal.FindListBySql<d_general>($"select * from d_general where general_table_id={general_table_id} and delete_time=0 ORDER BY id,sort_order,`code`").ToList();
        }
        public string GetGeneralTableName(int general_table_id) {
            return new d_general_table_dal().FindById(general_table_id).name;
        }
        public string GetGeneralParentName(int parent_id)
        {
            return _dal.FindSignleBySql<d_general>($"select * from d_general where id={parent_id} and delete_time=0 ").name;
        }
        /// <summary>
        /// 删除一个
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_system > 0) {
                return ERROR_CODE.SYSTEM;
            }
            data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 激活
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Active(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_active > 0)
            {
                return ERROR_CODE.ACTIVATION;
            }
            data.is_active = 1;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 失活
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE NoActive(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_active==0)
            {
                return ERROR_CODE.NO_ACTIVATION;
            }
            data.is_active = 0;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            return ERROR_CODE.SUCCESS;
        }
    }
}
