using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

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

            dic.Add("country", new DistrictBLL().GetCountryList());                        // 国家表
            dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));

            return dic;
        }

        /// <summary>
        /// 获取一个客户下所有联系人
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByCompany(long companyId)
        {
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag($"SELECT * FROM crm_contact WHERE account_id='{companyId}' "));
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

        public ContactAddAndUpdateDto GetContactDto(long id)
        {
            ContactAddAndUpdateDto dto = new ContactAddAndUpdateDto();
            dto.contact = GetContact(id);
            if (dto.contact == null)
                return null;
            var bll = new UserDefinedFieldsBLL();
            dto.udf = bll.GetUdfValue(UDF_CATE.CONTACT, id, bll.GetUdf(UDF_CATE.CONTACT));
            if (dto.contact.location_id != null)
                dto.location = new LocationBLL().GetLocation((long)dto.contact.location_id);
            if (dto.contact.location_id2 != null)
                dto.location2 = new LocationBLL().GetLocation((long)dto.contact.location_id2);
            var company = new CompanyBLL().GetCompany(dto.contact.account_id);
            dto.company_name = company.name;

            return dto;
        }

        /// <summary>
        /// 新增联系人
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(ContactAddAndUpdateDto contactAddDto, long user_id)
        {          
            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;

            #region 对联系人必填项的校验

            // 必填项校验
            if (string.IsNullOrEmpty(contactAddDto.contact.name) || string.IsNullOrEmpty(contactAddDto.contact.phone) || string.IsNullOrEmpty(contactAddDto.contact.first_name))
            {
                return ERROR_CODE.PARAMS_ERROR;                // string类型的非空校验
            }
            if (contactAddDto.contact.allow_notify_email_task_ticket == 1)
            {
                if (string.IsNullOrEmpty(contactAddDto.contact.email))
                {
                    return ERROR_CODE.PARAMS_ERROR;           // 如果任务和工单中允许发邮件，那么联系人的邮箱为必填项
                }
            }
            #endregion

            #region 对联系人中的唯一性信息进行校验（联系人和移动电话）
            if (!string.IsNullOrEmpty(contactAddDto.contact.mobile_phone))    // 如果用户填写了移动电话，那么对电话进行唯一检验（全表内未删除的联系人进行检索，不局限于本客户联系人）
            {
                var same_phone_contact = _dal.GetContactByPhone(contactAddDto.contact.mobile_phone);
                if (same_phone_contact != null && same_phone_contact.Count > 0)    // 查询到此手机号已经有联系人在使用，不可重复使用，返回错误
                {
                    return ERROR_CODE.ERROR;
                }
            }

            // 联系人名称校验
            var compare_contact = _dal.GetContactByName(contactAddDto.contact.account_id, contactAddDto.contact.name);
            if (compare_contact != null && compare_contact.Count > 0)  // 该客户如果存在名称一样的未删除的用户，返回错误，提醒用户
            {
                return ERROR_CODE.ERROR;
            }
            #endregion

            if (contactAddDto.location != null)
            {
                var _location = contactAddDto.location;
                new LocationBLL().Insert(_location, user_id);
            }

            #region 如果是主要联系人，首先将原主要联系人设置为普通联系人

            if (contactAddDto.contact.is_primary_contact == 1)  // 客户将当前联系人设置为主要联系人，此时将原有的主要联系人更改为普通联系人
            {
                var old_primary_contact = _dal.GetPrimaryContactByAccountId(contactAddDto.contact.account_id); // 获取到客户的主要联系人
                if (old_primary_contact != null&&old_primary_contact.id!= contactAddDto.contact.id)
                {
                    old_primary_contact.is_primary_contact = 0;
                    if (_dal.Update(old_primary_contact))  // 更改主要联系人，插入操作日志
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                            oper_object_id = old_primary_contact.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = @"{""is_primary_contact"":""1→0""}", // 1 主要联系人 0 普通联系人
                            remark = "修改主要联系人为普通联系人",
                        });    // 插入更改日志
                    }
                }
            }
            #endregion

            #region  保存联系人信息
            //contactAddDto.contact.suffix_id = contactAddDto.contact.suffix_id == 0 ? null : contactAddDto.contact.suffix_id;
            contactAddDto.contact.id = contactAddDto.contact.id==0? _dal.GetNextIdCom(): contactAddDto.contact.id;
            contactAddDto.contact.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contactAddDto.contact.create_user_id = user.id;
            contactAddDto.contact.update_time = contactAddDto.contact.create_time;
            contactAddDto.contact.update_user_id = user.id;
            _dal.Insert(contactAddDto.contact);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = contactAddDto.contact.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(contactAddDto.contact),
                remark = "新增联系人"
            });       // 插入日志
            #endregion

            #region 保存联系人扩展信息          

            var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT); // 联系人的自定义字段
            var udf_con_list = contactAddDto.udf;                                               // 传过来的联系人的自定义参数
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTACT, user.id, contactAddDto.contact.id, udf_contact_list, udf_con_list, OPER_LOG_OBJ_CATE.CONTACTS_EXTENSION_INFORMATION); // 保存成功即插入日志
            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 更新联系人信息
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Update(ContactAddAndUpdateDto contact_update, long user_id)
        {
            //contact.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //contact.update_user_id = CachedInfoBLL.GetUserInfo(token).id;
            var user = UserInfoBLL.GetUserInfo(user_id);
        
            if (user == null)
                return ERROR_CODE.PARAMS_ERROR;

            #region 对联系人必填项的校验

            // 必填项校验
            if (string.IsNullOrEmpty(contact_update.contact.name) || string.IsNullOrEmpty(contact_update.contact.phone) || string.IsNullOrEmpty(contact_update.contact.first_name))
            {
                return ERROR_CODE.PARAMS_ERROR;                // string类型的非空校验
            }
            if (contact_update.contact.allow_notify_email_task_ticket == 1)
            {
                if (string.IsNullOrEmpty(contact_update.contact.email))
                {
                    return ERROR_CODE.PARAMS_ERROR;           // 如果任务和工单中允许发邮件，那么联系人的邮箱为必填项 
                }
            }
            #endregion

            #region 对联系人中的唯一性信息进行校验（联系人和移动电话）
            if (!string.IsNullOrEmpty(contact_update.contact.mobile_phone))    // 如果用户填写了移动电话，那么对电话进行唯一检验（全表内未删除的联系人进行检索，不局限于本客户联系人）
            {
                var same_phone_contact = _dal.GetContactByPhone(contact_update.contact.mobile_phone,contact_update.contact.id);
                if (same_phone_contact != null && same_phone_contact.Count > 0)    // 查询到此手机号已经有联系人在使用，不可重复使用，返回错误
                {
                    return ERROR_CODE.ERROR;
                }
            }

            // 联系人名称校验
            var compare_contact = _dal.GetContactByName(contact_update.contact.account_id, contact_update.contact.name, contact_update.contact.id);
            if (compare_contact != null && compare_contact.Count > 0)  // 该客户如果存在名称一样的未删除的用户，返回错误，提醒用户
            {
                return ERROR_CODE.ERROR;
            }
            #endregion

            #region 如果是主要联系人，首先将原主要联系人设置为普通联系人

            if (contact_update.contact.is_primary_contact == 1)  // 客户将当前联系人设置为主要联系人，此时将原有的主要联系人更改为普通联系人
            {
                var old_primary_contact = _dal.GetPrimaryContactByAccountId(contact_update.contact.account_id); // 获取到客户的主要联系人
                if (old_primary_contact != null)
                {
                    old_primary_contact.is_primary_contact = 0;
                    if (_dal.Update(old_primary_contact))  // 更改主要联系人，插入操作日志
                    {
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                            oper_object_id = old_primary_contact.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = @"{""is_primary_contact"":""1→0""}", // 1 主要联系人 0 普通联系人
                            remark = "修改主要联系人为普通联系人",
                        });    // 插入更改日志
                    }
                }
            }
            #endregion

            #region 修改联系人

            var old_contact_value = _dal.FindById(contact_update.contact.id);
     
            contact_update.contact.update_user_id = user.id;
            contact_update.contact.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Update(contact_update.contact);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = contact_update.contact.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_contact_value, contact_update.contact),
                remark = "修改联系人信息"
            });       // 插入日志
            #endregion

            #region 修改联系人的扩展信息          

            var udf_contact_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTACT); // 联系人的自定义字段
            if(udf_contact_list !=null && udf_contact_list.Count > 0)
            {
                var udf_con_list = contact_update.udf;                                               // 传过来的联系人的自定义参数
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.CONTACT, udf_contact_list, contact_update.contact.id, udf_con_list, user, DicEnum.OPER_LOG_OBJ_CATE.CONTACTS_EXTENSION_INFORMATION);                         // 修改方法内含有插入日志操作，若无修改将不插入日志
            }

            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 删除联系人
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteContact(long id, long user_id)
        {

            // var user = CachedInfoBLL.GetUserInfo(token);
            var user = new UserInfoDto()
            {
                id = 1,
                email = "zhufei@test.com",
                mobile = "10086",
                name = "zhufei_test",
                security_Level_id = 0
            };
            if (user == null)
                return false;

            crm_contact contact = GetContact(id);
            if (contact.delete_time!= 0||contact.delete_user_id!=0)        // 预防并发操作时，别的员工已经将此用户删除
            {
                return false;
            }
            //contact.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //contact.delete_user_id = user.id;
            if (_dal.SoftDelete(contact, user.id))
            {
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                    oper_object_id = contact.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = @"{""delete_time"":""0→" + Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now).ToString() + @""",""delete_user_id"":""0→" + user.id.ToString() + @"""}",
                    remark = "删除联系人"
                });       // 插入日志
            }
           
            return true;


            //   该联系人是公司的外包联系人（工单中的外包人员）
            //   该联系人有关联的工单或任务
            //   该联系人在自助服务台创建过工单备注或者附件
            //   该联系人是客户的账单联系人
            //   该联系人是客户的唯一的一个发票邮件接收人
            //    todo  删除校验本期暂时不做     07-13=====08-15
        }

        /// <summary>
        /// 根据客户id和联系人状态去查询相对应的联系人列表
        /// </summary>
        /// <param name="account_id"></param>
        /// <param name="is_active"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByStatus(long account_id, int is_active = 2)
        {
            return new crm_contact_dal().GetContactByStatus(account_id, is_active);
        }

        /// <summary>
        /// 获取到用户的默认地址
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_contact GetDefaultByAccountId(long account_id)
        {
            
            return _dal.FindSignleBySql<crm_contact>($"select * from crm_contact where account_id = {account_id} and is_primary_contact = 1 and delete_time = 0");
        }


        /// <summary>
        /// 通过id集合返回多个联系人
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<crm_contact> GetContactByIds(string ids)
        {
            return _dal.GetContactByIds(ids);
        }




        public bool UpdateContacts(string updateIds,string phone,string fax,long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return false;
            var con_list = updateIds.Split(',');
            var contactList = _dal.GetContactByIds(updateIds);
            if(contactList!=null&& contactList.Count > 0)
            {
                foreach (var item in con_list)
                {
                    var contact = new crm_contact_dal().FindById(Convert.ToInt64(item));   // 获取到对应的联系人信息
                    if (contact != null)
                    {
                        contact.phone = phone;
                        contact.fax = fax;
                        contact.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        contact.update_user_id = user.id;
                        new crm_contact_dal().Update(contact);                   // 修改联系人
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                            oper_object_id = contact.id,
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(contactList.FirstOrDefault(_ => _.id == contact.id), contact),
                            remark = "修改联系人电话或传真",
                        });    // 插入更改日志
                    }
                }
            }

            return true;
        }
    }
}
