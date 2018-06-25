using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using System.IO;

namespace EMT.DoneNOW.BLL
{
    public class DataImportBLL
    {
        /// <summary>
        /// 获取客户联系人导入的字段名称列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetCompanyImportFieldsStr()
        {
            List<string> fields = new List<string>();
            var list = GetCompanyImportFields();

            foreach (var field in list)
            {
                fields.Add(field.name);
            }

            return fields;
        }

        /// <summary>
        /// 获取客户联系人导入的字段列表
        /// </summary>
        /// <returns></returns>
        private List<ImportFieldStruct> GetCompanyImportFields()
        {
            List<ImportFieldStruct> list = new List<ImportFieldStruct>();

            GetAccountFields(ref list);
            GetUdfFields(ref list, DicEnum.UDF_CATE.COMPANY);
            GetUdfFields(ref list, DicEnum.UDF_CATE.SITE);
            GetContactFields(ref list);
            GetUdfFields(ref list, DicEnum.UDF_CATE.CONTACT);

            return list;
        }

        /// <summary>
        /// 从xls文件中导入客户联系人
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="isUpdate">存在匹配项是否更新已有数据</param>
        /// <param name="userId"></param>
        public string ImportCompany(string filename, bool isUpdate, long userId)
        {
            string strline;
            string[] aryline;
            StreamReader mysr = new StreamReader(filename, Encoding.Default);

            List<ImportFieldStruct> lstCpy = new List<ImportFieldStruct>();
            List<ImportFieldStruct> udfCpy = new List<ImportFieldStruct>();
            List<ImportFieldStruct> udfCfg = new List<ImportFieldStruct>();
            List<ImportFieldStruct> lstCtt = new List<ImportFieldStruct>();
            List<ImportFieldStruct> udfCtt = new List<ImportFieldStruct>();
            GetAccountFields(ref lstCpy);
            GetUdfFields(ref udfCpy, DicEnum.UDF_CATE.COMPANY);
            GetUdfFields(ref udfCfg, DicEnum.UDF_CATE.SITE);
            GetContactFields(ref lstCtt);
            GetUdfFields(ref udfCtt, DicEnum.UDF_CATE.CONTACT);

            // 检查模板字段
            if ((strline = mysr.ReadLine()) == null)
                return "模板格式错误！";
            //var list = GetCompanyImportFields();
            aryline = strline.Split(',');
            if (aryline.Length != lstCpy.Count + udfCfg.Count + udfCpy.Count + lstCtt.Count + udfCtt.Count)
                return "模板格式错误！";
            int idx = 0;
            for (int i = 0; i < lstCpy.Count; i++)
            {
                if (aryline[idx] != lstCpy[i].name)
                    return "模板格式错误！";

                idx++;
            }
            for (int i = 0; i < udfCpy.Count; i++)
            {
                if (aryline[idx] != udfCpy[i].name)
                    return "模板格式错误！";

                idx++;
            }
            for (int i = 0; i < udfCfg.Count; i++)
            {
                if (aryline[idx] != udfCfg[i].name)
                    return "模板格式错误！";

                idx++;
            }
            for (int i = 0; i < lstCtt.Count; i++)
            {
                if (aryline[idx] != lstCtt[i].name)
                    return "模板格式错误！";

                idx++;
            }
            for (int i = 0; i < udfCtt.Count; i++)
            {
                if (aryline[idx] != udfCtt[i].name)
                    return "模板格式错误！";

                idx++;
            }

            // 记录导入日志
            com_import_log log = new com_import_log();
            com_import_log_dal logdal = new com_import_log_dal();
            log.cate_id = (int)DicEnum.DATA_IMPORT_CATE.COMPANY_CONTACT;
            log.id = logdal.GetNextIdCom();
            log.import_user_id = userId;
            log.import_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            log.file_name = filename;
            logdal.Insert(log);

            while ((strline = mysr.ReadLine()) != null)
            {

                //for (int i = 0; i < list.Count; i++)
                //{
                //    var field = list[i];
                //    // 检查必填
                //    if (field.require == 1 && string.IsNullOrEmpty(aryline[i]))
                //    {

                //    }
                //}
            }

            return null;
        }

        private bool ImportCompanyOneLine(string strline, bool isUpdate, long logId, long userId, List<ImportFieldStruct> lstCpy, List<ImportFieldStruct> udfCpy, List<ImportFieldStruct> udfCfg, List<ImportFieldStruct> lstCtt, List<ImportFieldStruct> udfCtt)
        {
            var aryline = strline.Split(',');
            int idx = 0;
            for (int i = 0; i < lstCpy.Count; i++)
            {

                idx++;
            }
            for (int i = 0; i < udfCpy.Count; i++)
            {
                

                idx++;
            }
            for (int i = 0; i < udfCfg.Count; i++)
            {
                

                idx++;
            }
            for (int i = 0; i < lstCtt.Count; i++)
            {
                

                idx++;
            }
            for (int i = 0; i < udfCtt.Count; i++)
            {
                
                idx++;
            }

            return true;
        }


        #region 导入字段
        /// <summary>
        /// 获取自定义字段列表
        /// </summary>
        /// <param name="list"></param>
        /// <param name="cate"></param>
        private void GetUdfFields(ref List<ImportFieldStruct> list, DicEnum.UDF_CATE cate)
        {
            string pre;
            switch(cate)
            {
                case DicEnum.UDF_CATE.COMPANY:
                    pre = "客户自定义:";
                    break;
                case DicEnum.UDF_CATE.CONTACT:
                    pre = "联系人自定义:";
                    break;
                case DicEnum.UDF_CATE.SITE:
                    pre = "站点自定义:";
                    break;
                default:
                    pre = null;
                    break;
            }
            var fields = new UserDefinedFieldsBLL().GetUdf(cate);
            foreach (var fld in fields)
            {
                list.Add(new ImportFieldStruct
                {
                    name = (fld.required == 1 ? "[必填]" : "") + pre + fld.name,
                    field = fld.col_name,
                    require = fld.required,
                    type = fld.data_type == (int)DicEnum.UDF_DATA_TYPE.NUMBER ? ImportFieldType.Decimal : ImportFieldType.String
                });
            }
        }

        /// <summary>
        /// 获取客户的导入字段信息
        /// </summary>
        /// <param name="list"></param>
        private void GetAccountFields(ref List<ImportFieldStruct> list)
        {
            list.Add(new ImportFieldStruct { name = "[必填]客户:名称", field = "name", require = 1 });
            list.Add(new ImportFieldStruct { name = "客户:编号", field = "company_number", type = ImportFieldType.Int });
            list.Add(new ImportFieldStruct { name = "[必填]客户:电话", field = "phone", require = 1 });
            list.Add(new ImportFieldStruct { name = "客户:地址国家", field = "crm_location:country_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:地址省份", field = "crm_location:province_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:地址城市", field = "crm_location:city_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:地址区县", field = "crm_location:district_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:地址详细地址", field = "crm_location:address" });
            list.Add(new ImportFieldStruct { name = "客户:地址地址附加信息", field = "crm_location:additional_address" });
            list.Add(new ImportFieldStruct { name = "客户:地址邮编", field = "crm_location:postal_code" });
            list.Add(new ImportFieldStruct { name = "客户:地址标签", field = "crm_location:location_label" });
            list.Add(new ImportFieldStruct { name = "客户:备用电话1", field = "alternate_phone1" });
            list.Add(new ImportFieldStruct { name = "客户:备用电话2", field = "alternate_phone2" });
            list.Add(new ImportFieldStruct { name = "客户:传真", field = "fax" });
            list.Add(new ImportFieldStruct { name = "客户:网站", field = "web_site" });
            list.Add(new ImportFieldStruct { name = "客户:全程距离(公里)", field = "mileage", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "客户:类型", field = "type_id", type = ImportFieldType.Dictionary, dic = 6 });
            list.Add(new ImportFieldStruct { name = "客户:分类", field = "classification_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:客户经理", field = "resource_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:销售区域", field = "territory_id", type = ImportFieldType.Dictionary, dic = 2 });
            list.Add(new ImportFieldStruct { name = "客户:所属行业", field = "market_segment_id", type = ImportFieldType.Dictionary, dic = 3 });
            list.Add(new ImportFieldStruct { name = "客户:竞争对手", field = "competitor_id", type = ImportFieldType.Dictionary, dic = 4 });
            list.Add(new ImportFieldStruct { name = "客户:上级客户", field = "parent_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:股票简称", field = "stock_symbol" });
            list.Add(new ImportFieldStruct { name = "客户:股票市场", field = "stock_market" });
            list.Add(new ImportFieldStruct { name = "客户:股票代码", field = "sic_code" });
            list.Add(new ImportFieldStruct { name = "客户:市值", field = "asset_value", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "客户:客户详细提醒", field = "", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:新建工单提醒", field = "", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:工单进度提醒", field = "", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:税区", field = "tax_region_id", type = ImportFieldType.Dictionary, dic = 5 });
            list.Add(new ImportFieldStruct { name = "客户:是否免税", field = "is_tax_exempt", type = ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "客户:税号", field = "tax_identification" });
            list.Add(new ImportFieldStruct { name = "客户:新浪微博地址", field = "weibo_url" });
            list.Add(new ImportFieldStruct { name = "客户:微信订阅号", field = "wechat_mp_subscription" });
            list.Add(new ImportFieldStruct { name = "客户:微信服务号", field = "wechat_mp_service" });
            list.Add(new ImportFieldStruct { name = "客户:问卷调查分数", field = "surrvey_rating" });
            list.Add(new ImportFieldStruct { name = "客户:是否激活", field = "is_active", type = ImportFieldType.Check });
            // TODO: 邮件模板、报价模板

        }

        /// <summary>
        /// 获取联系人的导入字段信息
        /// </summary>
        /// <param name="list"></param>
        private void GetContactFields(ref List<ImportFieldStruct> list)
        {
            list.Add(new ImportFieldStruct { name = "联系人:外部对象ID", field = "external_id" });
            list.Add(new ImportFieldStruct { name = "联系人:姓", field = "first_name" });
            list.Add(new ImportFieldStruct { name = "联系人:名", field = "last_name" });
            list.Add(new ImportFieldStruct { name = "联系人:称谓", field = "suffix_id", type = ImportFieldType.Dictionary, dic = 48 });
            list.Add(new ImportFieldStruct { name = "联系人:头衔", field = "title" });
            list.Add(new ImportFieldStruct { name = "联系人:email", field = "Email" });
            list.Add(new ImportFieldStruct { name = "联系人:email2", field = "备用Email" });
            list.Add(new ImportFieldStruct { name = "联系人:地址国家", field = "crm_location:country_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:地址省份", field = "crm_location:province_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:地址城市", field = "crm_location:city_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:地址区县", field = "crm_location:district_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:地址详细地址", field = "crm_location:address" });
            list.Add(new ImportFieldStruct { name = "联系人:地址地址附加信息", field = "crm_location:additional_address" });
            list.Add(new ImportFieldStruct { name = "联系人:地址邮编", field = "crm_location:postal_code" });
            list.Add(new ImportFieldStruct { name = "联系人:地址标签", field = "crm_location:location_label" });
            list.Add(new ImportFieldStruct { name = "联系人:电话", field = "phone" });
            list.Add(new ImportFieldStruct { name = "联系人:备用电话", field = "alternate_phone" });
            list.Add(new ImportFieldStruct { name = "联系人:手机号", field = "mobile_phone" });
            list.Add(new ImportFieldStruct { name = "联系人:传真", field = "fax" });
            list.Add(new ImportFieldStruct { name = "联系人:联系人组", field = "", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:是否激活", field = "is_active", type = ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "联系人:是否主联系人", field = "is_primary_contact", type = ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "联系人:qq号", field = "qq" });
            list.Add(new ImportFieldStruct { name = "联系人:微信号", field = "wechat" });
            list.Add(new ImportFieldStruct { name = "联系人:新浪微博地址", field = "weibo_url" });
        }

        // 导入数据的字段类型
        private enum ImportFieldType
        {
            String,         // 字符
            Int,            // 整形
            Long,           // 
            Decimal,        // 
            Dictionary,     // 字典项
            Check,          // 是否(1是0否)
        }

        // 导入数据的字段描述
        private class ImportFieldStruct
        {
            public string name;         // 字段名称
            public string field;        // 对应数据库字段名
            public int require = 0;     // 是否必填
            public ImportFieldType type = ImportFieldType.String;   // 字段类型
            public int dic = 0;         // 字段指向通用字典时字典id
        }
        #endregion
    }
}
