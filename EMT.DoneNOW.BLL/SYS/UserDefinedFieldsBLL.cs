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
            string sql=dal.QueryStringDeleteFlag($"SELECT id,col_comment as name,description,data_type_id as cate,default_value,decimal_length,is_required as required FROM sys_udf_field WHERE is_active=1");
            var list = dal.FindListBySql<UserDefinedFieldDto>(sql);
            foreach (var udf in list)
            {
                if (udf.cate == (int)DicEnum.UDF_DATA_TYPE.LIST)
                {
                    var valList = udfListDal.FindListBySql<DictionaryEntryDto>(udfListDal.QueryStringDeleteFlag($"SELECT id as 'val',name as 'show',is_default as 'select' FROM sys_udf_list WHERE udf_field_id={udf.id} status_id=0"));
                    if (valList != null && valList.Count != 0)
                        udf.value_list = valList;
                }
            }

            return list;
        }

        /// <summary>
        /// 保存记录中的自定义字段值
        /// </summary>
        /// <param name="cate">客户、联系人等类别</param>
        /// <param name="objId">记录的id</param>
        /// <param name="fields">自定义字段信息</param>
        /// <param name="value">自定义字段值</param>
        /// <returns></returns>
        public bool SaveUdfValue(DicEnum.UDF_CATE cate, long objId, List<UserDefinedFieldDto> fields, List<UserDefinedFieldValue> value)
        {
            if (value == null || value.Count == 0)
                return true;

            StringBuilder select = new StringBuilder();
            StringBuilder values = new StringBuilder();
            foreach (var val in value)
            {
                var field = fields.FindAll(s => s.id == val.id);
                if (field == null || field.Count == 0)
                    continue;
                select.Append(",").Append(field.First().col_name);
                values.Append(",").Append(val.value);
            }
            if (values.Length == 0)
                return false;

            string table = "";
            switch (cate)
            {
                case DicEnum.UDF_CATE.COMPANY:
                    table = "crm_account_ext";
                    break;
                case DicEnum.UDF_CATE.CONTACT:
                    table = "crm_contact_ext";
                    break;
                    // TODO: 其他类别
                default:
                    break;
            }
            var dal = new sys_udf_field_dal();
            string insert = $"INSERT INTO {table} (id,parent_id{select.ToString()}) VALUES ({dal.GetNextIdSys()},{objId}{values.ToString()})";
            dal.ExecuteSQL(insert);

            return true;
        }
    }
}