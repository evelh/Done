using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;

namespace EMT.DoneNOW.BLL
{
    public class ContactBLL
    {
        private readonly crm_contact_dal _dal = new crm_contact_dal();

        /// <summary>
        /// 获取联系人相关的列表字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("country", new d_country_dal().GetDictionary());                        // 国家表

            return dic;
        }

        /// <summary>
        /// 获取一个客户下所有联系人
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByCompany(long companyId)
        {
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag($"SELECT * FROM crm_contact WHERE account_id='{companyId}'"));
        }

        /// <summary>
        /// 根据联系人id查找
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_contact GetContact(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 新增联系人
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_contact contact, string token)
        {
            contact.id = _dal.GetNextIdCom();
            contact.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contact.create_user_id = CachedInfoBLL.GetUserInfo(token).id;
            contact.update_time = contact.create_time;
            contact.update_user_id = contact.create_user_id;
            // TODO: 主联系人设置
            _dal.Insert(contact);  // TODO:

            return ERROR_CODE.ERROR;
        }

        /// <summary>
        /// 更新联系人信息
        /// </summary>
        /// <returns></returns>
        public bool Update(crm_contact contact, string token)
        {
            contact.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contact.update_user_id = CachedInfoBLL.GetUserInfo(token).id;

            // TODO: 日志
            return _dal.Update(contact);
        }

        /// <summary>
        /// 按条件查询
        /// </summary>
        /// <returns></returns>
        public List<crm_contact> FindList(JObject jsondata)
        {
            ContactConditionDto condition = jsondata.ToObject<ContactConditionDto>();
            string orderby = ((JValue)(jsondata.SelectToken("orderby"))).Value.ToString();
            string page = ((JValue)(jsondata.SelectToken("page"))).Value.ToString();
            int pagenum;
            if (!int.TryParse(page, out pagenum))
                pagenum = 1;
            return _dal.Find(condition, pagenum, orderby);
        }

        /// <summary>
        /// 删除联系人
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteContact(long id, string token)
        {
            crm_contact contact = GetContact(id);
            contact.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contact.delete_user_id = CachedInfoBLL.GetUserInfo(token).id;
            // TODO: 日志
            return _dal.SoftDelete(contact,id);
        }
    }
}
