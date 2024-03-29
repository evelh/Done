﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 用户自定义字段处理
    /// </summary>
    public class UserDefinedFieldsBLL
    {
        /// <summary>
        /// 获取一个对象包含的用户自定义字段信息
        /// </summary>
        /// <param name="cate">对象分类</param>
        /// <returns></returns>
        public List<UserDefinedFieldDto> GetUdf(DicEnum.UDF_CATE cate)
        {
            var dal = new sys_udf_field_dal();
            var udfListDal = new sys_udf_list_dal();
            string sql=dal.QueryStringDeleteFlag($"SELECT id,col_name,col_comment as name,description,data_type_id as data_type,default_value,decimal_length,is_required as required,is_protected FROM sys_udf_field WHERE is_active=1 and delete_time=0 and cate_id = {(int)cate} ORDER BY sort_order");
            var list = dal.FindListBySql<UserDefinedFieldDto>(sql);
            foreach (var udf in list)
            {
                if (udf.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)
                {
                    var valList = udfListDal.FindListBySql<DictionaryEntryDto>(udfListDal.QueryStringDeleteFlag($"SELECT id as 'val',name as 'show',is_default as 'select' FROM sys_udf_list WHERE udf_field_id={udf.id} and delete_time=0 and status_id=0 ORDER BY sort_order"));
                    if (valList != null && valList.Count != 0)
                        udf.value_list = valList;
                }
            }

            return list;
        }

        /// <summary>
        /// 获取自定义字段信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public UserDefinedFieldDto GetUdfInfo(long id)
        {
            var dal = new sys_udf_field_dal();
            var dto = dal.FindSignleBySql<UserDefinedFieldDto>($"select *,col_comment as `name`,cate_id as cate,data_type_id as data_type,is_required as required from sys_udf_field where id={id} and delete_time=0");
            if (dto == null)
                return null;

            if (dto.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)
            {
                dto.list = dal.FindListBySql<sys_udf_list>($"select * from sys_udf_list where udf_field_id={dto.id} and status_id=0 and delete_time=0");
            }

            return dto;
        }

        /// <summary>
        /// 获取自定义字段是否激活
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetUdfIsActive(long id)
        {
            return new sys_udf_field_dal().FindSignleBySql<string>($"select is_active from sys_udf_field where id={id}");
        }

        /// <summary>
        /// 激活/取消激活自定义字段
        /// </summary>
        /// <param name="id"></param>
        /// <param name="active"></param>
        /// <returns></returns>
        public bool UpdateUdfStatus(long id, bool active, long userId)
        {
            var dal = new sys_udf_field_dal();
            var udf = dal.FindNoDeleteById(id);
            if (udf == null)
                return false;
            if (active)
                udf.is_active = 1;
            else
                udf.is_active = 0;

            udf.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            udf.update_user_id = userId;
            dal.Update(udf);
            return true;
        }

        /// <summary>
        /// 删除自定义字段
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteUdf(long id, long userId)
        {
            var dal = new sys_udf_field_dal();
            var udf = dal.FindNoDeleteById(id);
            if (udf == null)
                return false;

            udf.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            udf.delete_user_id = userId;

            dal.Update(udf);
            return true;
        }

        /// <summary>
        /// 新增编辑自定义字段
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="udf"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditUdf(DicEnum.UDF_CATE cate, UserDefinedFieldDto udf, long userId)
        {
            if (udf.id == 0)
                return AddUdf(cate, udf, userId);

            var dal = new sys_udf_field_dal();
            var field = dal.FindNoDeleteById(udf.id);
            if (field == null)
                return false;
            
            field.col_comment = udf.name;
            field.description = udf.description;
            field.data_type_id = udf.data_type;
            field.default_value = udf.default_value;
            field.is_protected = udf.is_protected;
            field.is_required = udf.required;
            field.is_encrypted = udf.is_encrypted;
            field.is_visible_in_portal = udf.is_visible_in_portal;
            field.crm_to_project_udf_id = udf.crm_to_project;
            field.sort_order = udf.sort_order;
            field.is_active = udf.is_active;
            field.display_format_id = udf.display_format;
            field.decimal_length = udf.decimal_length;
            field.update_user_id = userId;
            field.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();

            var fieldOld = dal.FindById(field.id);
            var desc = OperLogBLL.CompareValue<sys_udf_field>(fieldOld, field);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(field);
                OperLogBLL.OperLogUpdate(desc, field.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED, "编辑自定义字段");
            }

            var listDal = new sys_udf_list_dal();
            var list = dal.FindListBySql<sys_udf_list>($"select * from sys_udf_list where udf_field_id={field.id} and status_id=0 and delete_time=0");
            //var find=udf.list.Find(_=>_.is_default==1)
            foreach (var ufv in udf.list)
            {
                var find = list.Find(_ => _.id == ufv.id);
                if (find == null)
                {
                    sys_udf_list val = new sys_udf_list();
                    val.id = listDal.GetNextIdCom();
                    val.is_default = ufv.is_default;
                    val.name = ufv.name;
                    val.sort_order = ufv.sort_order;
                    val.udf_field_id = udf.id;
                    val.status_id = 0;
                    val.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    val.update_time = val.create_time;
                    val.create_user_id = field.create_user_id;
                    val.update_user_id = val.create_user_id;
                    listDal.Insert(val);

                    OperLogBLL.OperLogAdd<sys_udf_list>(val, val.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED_LIST, "新增自定义字段值");
                }
                else
                {
                    if (find.is_default != ufv.is_default)
                    {
                        find.is_default = ufv.is_default;
                        find.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        find.update_user_id = userId;

                        var old = listDal.FindById(find.id);
                        listDal.Update(find);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<sys_udf_list>(old, find), find.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED_LIST, "编辑自定义字段值");
                    }
                    list.Remove(find);
                }
            }

            foreach (var ufv in list)
            {
                ufv.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                ufv.delete_user_id = userId;
                listDal.Update(ufv);
                OperLogBLL.OperLogDelete<sys_udf_list>(ufv, ufv.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED_LIST, "删除自定义字段值");
            }

            return true;
        }

        /// <summary>
        /// 增加自定义字段
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="udf"></param>
        /// <returns></returns>
        public bool AddUdf(DicEnum.UDF_CATE cate, UserDefinedFieldDto udf, long userId)
        {
            string table = GetTableName(cate);
            var dal = new sys_udf_field_dal();

            var field = new sys_udf_field();
            field.id = dal.GetNextIdCom();
            field.col_name = GetNextColName();
            field.col_comment = udf.name;
            field.description = udf.description;
            field.cate_id = udf.cate;
            field.data_type_id = udf.data_type;
            field.default_value = udf.default_value;
            field.is_protected = udf.is_protected;
            field.is_required = udf.required;
            field.is_encrypted = udf.is_encrypted;
            field.is_visible_in_portal = udf.is_visible_in_portal;
            field.crm_to_project_udf_id = udf.crm_to_project;
            field.sort_order = udf.sort_order;
            field.is_active = udf.is_active;
            field.display_format_id = udf.display_format;
            field.decimal_length = udf.decimal_length;
            field.create_user_id = userId;
            field.update_user_id = userId;
            field.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            field.update_time = field.create_time;
            dal.Insert(field);
            OperLogBLL.OperLogAdd<sys_udf_field>(field, field.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED, "新增自定义字段");

            if (udf.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)       // 字段为列表类型，保存列表值
            {
                if (udf.list != null && udf.list.Count > 0)
                {
                    var listDal = new sys_udf_list_dal();
                    foreach(var listVal in udf.list)
                    {
                        sys_udf_list val = new sys_udf_list();
                        val.id = listDal.GetNextIdCom();
                        val.is_default = listVal.is_default;
                        val.name = listVal.name;
                        val.sort_order = listVal.sort_order;
                        val.udf_field_id = field.id;
                        val.status_id = 0;
                        val.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        val.update_time = val.create_time;
                        val.create_user_id = field.create_user_id;
                        val.update_user_id = val.create_user_id;
                        listDal.Insert(val);

                        OperLogBLL.OperLogAdd<sys_udf_list>(val, val.id, userId, DicEnum.OPER_LOG_OBJ_CATE.SYS_UDF_FILED_LIST, "新增自定义字段值");
                    }
                }
            }

            string sql = $"alter table {table} add {field.col_name} varchar(";
            if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                sql += "200)";
            else if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                sql += "2000)";
            else
                sql += "20)";
            dal.ExecuteSQL(sql);
            if (field.cate_id == (int)DicEnum.UDF_CATE.TICKETS)
            {
                table = GetTableName(DicEnum.UDF_CATE.FORM_RECTICKET);
                sql = $"alter table {table} add {field.col_name} varchar(";
                if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                    sql += "200)";
                else if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                    sql += "2000)";
                else
                    sql += "20)";
                dal.ExecuteSQL(sql);

                table = GetTableName(DicEnum.UDF_CATE.FORM_TICKET);
                sql = $"alter table {table} add {field.col_name} varchar(";
                if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                    sql += "200)";
                else if (field.data_type_id == (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                    sql += "2000)";
                else
                    sql += "20)";
                dal.ExecuteSQL(sql);
            }

            return true;
        }

        /// <summary>
        /// 保存记录中的自定义字段值，并记录日志
        /// </summary>
        /// <param name="cate">客户、联系人等类别</param>
        /// <param name="userId">操作用户id</param>
        /// <param name="objId">记录的id</param>
        /// <param name="fields">自定义字段信息</param>
        /// <param name="value">自定义字段值</param>
        /// <param name="oper_log_cate"></param>
        /// <returns></returns>
        public bool SaveUdfValue(DicEnum.UDF_CATE cate, long userId, long objId, List<UserDefinedFieldDto> fields, List<UserDefinedFieldValue> value, DicEnum.OPER_LOG_OBJ_CATE oper_log_cate)
        {
            // 无自定义字段信息
            if (value == null)
                value = new List<UserDefinedFieldValue>();

            StringBuilder select = new StringBuilder();
            StringBuilder values = new StringBuilder();
            Dictionary<string, object> dict = new Dictionary<string, object>();
            foreach (var val in value)
            {
                var field = fields.FindAll(s => s.id == val.id);
                if (field == null || field.Count == 0)
                    continue;
                string fieldName = field.First().col_name;
                if (val.value != null)
                {
                    select.Append(",").Append(fieldName);
                    string v = val.value.ToString().Replace("'", "''"); // 转义单引号
                    values.Append(",'").Append(v).Append("'");
                    dict.Add(fieldName, val.value);
                }
            }

            string table = GetTableName(cate);
            var dal = new sys_udf_field_dal();
            string insert = $"INSERT INTO {table} (id,parent_id{select.ToString()}) VALUES ({dal.GetNextIdCom()},{objId}{values.ToString()})";
            try
            {
                int rslt = dal.ExecuteSQL(insert);
                if (rslt <= 0)
                    return false;
                
                var user = new sys_resource_dal().FindById(userId);
                sys_oper_log log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile_phone == null ? "" : user.mobile_phone,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)oper_log_cate,
                    oper_object_id = objId,        // 操作对象id
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                    oper_description = new Tools.Serialize().SerializeJson(dict),
                    remark = "新增自定义字段值"

                };          // 创建日志
                new sys_oper_log_dal().Insert(log);       // 插入日志
            }
            catch
            {
                return false;   // TODO: 异常处理
            }

            return true;
        }

        /// <summary>
        /// 根据记录id获取字段值
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="objId"></param>
        /// <param name="fields"></param>
        /// <returns></returns>
        public List<UserDefinedFieldValue> GetUdfValue(DicEnum.UDF_CATE cate, long objId, List<UserDefinedFieldDto> fields)
        {
            var list = new List<UserDefinedFieldValue>();
            string table = GetTableName(cate);

            string sql = $"SELECT * FROM {table} WHERE parent_id={objId}";
            var tb = new sys_udf_field_dal().ExecuteDataTable(sql);
            if (tb == null)
                return list;

            if (tb.Rows.Count>0)
            {
                var dal = new sys_udf_field_dal();
                foreach (var field in fields)
                {
                    var udfField = dal.FindById(field.id);
                    list.Add(new UserDefinedFieldValue { id = field.id, value = tb.Rows[0][udfField.col_name] });
                }
            }
            return list;
        }

        /// <summary>
        /// 根据多个记录id获取字段值
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="ids">记录的id值，如 2,5,6</param>
        /// <param name="fields"></param>
        /// <returns></returns>
        public Dictionary<long, List<UserDefinedFieldValue>> GetUdfValue(DicEnum.UDF_CATE cate, string ids, List<UserDefinedFieldDto> fields)
        {
            var dic = new Dictionary<long, List<UserDefinedFieldValue>>();
            string table = GetTableName(cate);

            string sql = $"SELECT * FROM {table} WHERE parent_id IN ({ids})";
            var tb = new sys_udf_field_dal().ExecuteDataTable(sql);
            if (tb == null)
                return dic;

            var dal = new sys_udf_field_dal();
            foreach (System.Data.DataRow row in tb.Rows)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var field in fields)
                {
                    var udfField = dal.FindById(field.id);
                    list.Add(new UserDefinedFieldValue { id = field.id, value = row[udfField.col_name] });
                }
                dic.Add(long.Parse(row["parent_id"].ToString()), list);
            }

            return dic;
        }

        /// <summary>
        /// 更新自定义字段值，并记录日志
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="fields"></param>
        /// <param name="id"></param>
        /// <param name="vals"></param>
        /// <param name="user"></param>
        /// <param name="oper_log_cate"></param>
        /// <returns></returns>
        public bool UpdateUdfValue(DicEnum.UDF_CATE cate, List<UserDefinedFieldDto> fields, long id, List<UserDefinedFieldValue> vals, UserInfoDto user, DicEnum.OPER_LOG_OBJ_CATE oper_log_cate)
        {
            if (vals == null || vals.Count == 0)
                return true;
            var oldVal = GetUdfValue(cate, id, fields);
            Dictionary<string, string> dict = new Dictionary<string, string>();
            StringBuilder updateSb = new StringBuilder();
            foreach (var val in vals)
            {
                var oldv = oldVal.Find(f => f.id == val.id);
                if (oldv!=null&&object.Equals(oldv.value, val.value))
                    continue;
                var fld = fields.Find(f => f.id == val.id);
                if (val.value == null)
                {
                    updateSb.Append(fld.col_name).Append("=null,");    // 组合sql更新语句
                }
                else
                {
                    string v = val.value.ToString().Replace("'", "''"); // 转义单引号
                    updateSb.Append(fld.col_name).Append("='").Append(v).Append("',");    // 组合sql更新语句
                }
                
                dict.Add(fld.col_name, (oldv==null?"":oldv.value) + "→" + val.value);                         // 生成操作日志
            }
            if (dict.Count == 0)        // 无修改
                return true;
            
            string updateStr = updateSb.Remove(updateSb.Length - 1, 1).ToString();
            string sql = $"UPDATE {GetTableName(cate)} SET {updateStr} WHERE parent_id={id}";
            if (new sys_udf_field_dal().ExecuteSQL(sql) <= 0)
                return false;

            sys_oper_log log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)oper_log_cate,
                oper_object_id = id,        // 操作对象id
                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                oper_description = new Tools.Serialize().SerializeJson(dict),
                remark = "修改自定义字段值"

            };          // 创建日志
            new sys_oper_log_dal().Insert(log);       // 插入日志

            return true;
        }

        /// <summary>
        /// 获取用户自定义字段表名
        /// </summary>
        /// <param name="cate"></param>
        /// <returns></returns>
        private string GetTableName(DicEnum.UDF_CATE cate)
        {
            string table = "";
            switch (cate)
            {
                case DicEnum.UDF_CATE.COMPANY:
                    table = "crm_account_ext";
                    break;
                case DicEnum.UDF_CATE.CONTACT:
                    table = "crm_contact_ext";
                    break;
                case DicEnum.UDF_CATE.SITE:
                    table = "crm_account_site_ext";
                    break;
                case DicEnum.UDF_CATE.CONFIGURATION_ITEMS:
                    table = "crm_installed_product_ext";
                    break;
                case DicEnum.UDF_CATE.OPPORTUNITY:
                    table = "crm_opportunity_ext";
                    break;
                case DicEnum.UDF_CATE.SALES:
                    table = "crm_sales_order_ext";
                    break;
                case DicEnum.UDF_CATE.CONTRACTS:
                    table = "ctt_contract_ext";
                    break;
                case DicEnum.UDF_CATE.PRODUCTS:
                    table = "ivt_product_ext";
                    break;
                case DicEnum.UDF_CATE.PROJECTS:
                    table = "pro_project_ext";
                    break;
                case DicEnum.UDF_CATE.TASK:
                case DicEnum.UDF_CATE.TICKETS:
                    table = "sdk_task_ext";
                    break;
                case DicEnum.UDF_CATE.FORM_RECTICKET:
                    table = "sys_form_tmpl_recurring_ticket_ext";
                    break;
                case DicEnum.UDF_CATE.FORM_TICKET:
                    table = "sys_form_tmpl_ticket_ext";
                    break;
                // TODO: 其他类别
                default:
                    break;
            }
            return table;
        }
        /// <summary>
        /// 获取到这些ids当中和这个value不一样的数量
        /// </summary>
        public int GetSameValueCount(DicEnum.UDF_CATE cate,string ids,string fileName,string value)
        {
            var dal = new sys_udf_field_dal();
            string sql = $"SELECT COUNT(1) from {GetTableName(cate)} where parent_id in ({ids}) and {fileName} = '{value}' ";
            return int.Parse(dal.GetSingle(sql).ToString());
        }

        /// <summary>
        /// 获取一个未使用的字段名
        /// </summary>
        /// <returns></returns>
        private string GetNextColName()
        {
            var dal = new sys_udf_field_dal();
            var field = dal.FindSignleBySql<sys_udf_field>($"SELECT * FROM sys_udf_field ORDER BY id DESC LIMIT 1");
            if (field == null)
                return "col001";
            int index = int.Parse(field.col_name.Remove(0, 3));
            ++index;
            
            return "col" + index.ToString().PadLeft(3, '0');
        }

        /// <summary>
        /// 修改自定义字段某个值
        /// </summary>
        public bool EditUdf(DicEnum.UDF_CATE cate, long objectId, int udfId, string value, string desc, long user_id, DicEnum.OPER_LOG_OBJ_CATE operType)
        {
            // 更新自定义字段值
            var udfList = GetUdf(cate);
            var udfValues = GetUdfValue(cate, objectId, udfList);
            var user = new UserResourceBLL().GetSysUserSingle(user_id);
            int index = udfValues.FindIndex(f => f.id == udfId);
            object oldVal = udfValues[index].value;
            udfValues[index].value = value;
            UpdateUdfValue(cate, udfList, objectId, udfValues,
            new UserInfoDto { id = user_id, name = user.name }, operType);
            var colName = udfList.Find(f => f.id == udfId).name;
            bool result = true;
            switch (cate)
            {
                case DicEnum.UDF_CATE.PROJECTS:
                    result = new ProjectBLL().AddUdfActivity(objectId, colName, oldVal, value, desc, user_id);
                    break;
                default:
                    break;
            }

            return result;
        }

    }
}
