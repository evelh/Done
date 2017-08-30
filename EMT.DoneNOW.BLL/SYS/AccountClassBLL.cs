using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    public class AccountClassBLL
    {
        private readonly d_account_classification_dal _dal = new d_account_classification_dal();
        /// <summary>
        /// 通过客户类别id获取一个类别对象
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_account_classification GetSingel(long id) {
            return _dal.FindSignleBySql<d_account_classification>($"select * from d_account_classification where id={id} and delete_time=0");
        }
        /// <summary>
        /// 插入
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(d_account_classification data, long user_id)
        {
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id = user_id;

            _dal.Insert(data);
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新修改
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(d_account_classification data, long user_id)
        {
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (_dal.Update(data)) {
                return ERROR_CODE.SUCCESS;
            }
            return ERROR_CODE.ERROR;
        }
        /// <summary>
        /// 删除
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(d_account_classification data, long user_id)
        { 
             data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = user_id;
            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 激活
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Active(long id, long user_id)
        {
            var data = GetSingel(id);
            if (data == null) {
                return ERROR_CODE.ERROR;
            }
            if (Convert.ToInt32(data.status_id) == 1) {
                return ERROR_CODE.ACTIVATION;
            }
            data.status_id = 1;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }
        public ERROR_CODE NoActive(long id, long user_id)
        {
            var data = GetSingel(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (Convert.ToInt32(data.status_id) == 0)
            {
                return ERROR_CODE.NO_ACTIVATION;
            }
            data.status_id = 0;
            data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            _dal.Update(data);
            return ERROR_CODE.SUCCESS;
        }
    }
}
