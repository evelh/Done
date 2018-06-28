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
        sys_udf_field_dal udfDal = new sys_udf_field_dal();

        #region 客户联系人导入
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
        /// 从csv文件中导入客户联系人
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

            com_import_log_detail_dal logDetailDal = new com_import_log_detail_dal(log.id);

            while ((strline = mysr.ReadLine()) != null)
            {
                if (ImportCompanyOneLine(strline, isUpdate, userId, logDetailDal, lstCpy, udfCpy, udfCfg, lstCtt, udfCtt))
                    log.success_num++;
                else
                    log.fail_num++;
            }
            if (log.success_num != 0 || log.fail_num != 0)
                logdal.Update(log);

            return null;
        }

        /// <summary>
        /// 导入一个客户联系人
        /// </summary>
        /// <param name="strline">导入数据</param>
        /// <param name="isUpdate">有匹配是否更新</param>
        /// <param name="userId"></param>
        /// <param name="logDal">详细日志dal</param>
        /// <param name="lstCpy">客户</param>
        /// <param name="udfCpy">客户自定义</param>
        /// <param name="udfCfg">站点自定义</param>
        /// <param name="lstCtt">联系人</param>
        /// <param name="udfCtt">联系人自定义</param>
        /// <returns></returns>
        private bool ImportCompanyOneLine(string strline, bool isUpdate, long userId, com_import_log_detail_dal logDal, List<ImportFieldStruct> lstCpy, List<ImportFieldStruct> udfCpy, List<ImportFieldStruct> udfCfg, List<ImportFieldStruct> lstCtt, List<ImportFieldStruct> udfCtt)
        {
            var aryline = strline.Split(',');
            int idx = 0;

            List<ImportFieldStruct> list = new List<ImportFieldStruct>();   // 合并字段
            list.AddRange(lstCpy);
            list.AddRange(udfCpy);
            list.AddRange(udfCfg);

            // 联系人
            int idxfname = lstCtt.FindIndex(_ => _.field == "first_name");
            int idxlname = lstCtt.FindIndex(_ => _.field == "last_name");
            int idxemail = lstCtt.FindIndex(_ => _.field == "email");
            idx = lstCpy.Count + udfCpy.Count + udfCfg.Count;
            string fname = aryline[idx + idxfname];
            string lname = aryline[idx + idxlname];
            string email = aryline[idx + idxemail];
            if (!string.IsNullOrEmpty(fname) && !string.IsNullOrEmpty(lname) && !string.IsNullOrEmpty(email))   // 导入了联系人
            {
                list.AddRange(lstCtt);
                list.AddRange(udfCtt);
            }

            // 检查必填字段
            for (int i = 0; i < list.Count; i++)
            {
                if (list[i].require == 1 && string.IsNullOrEmpty(aryline[i]))
                {
                    logDal.AddFailLog($"{list[i].name}字段为空");
                    return false;
                }
            }

            idx = 0;
            bool exist = false;
            string sqlact;
            string sqladdrAct;
            string sqlactUdf = null;
            string sqlactalert1 = null;
            string sqlactalert2 = null;
            string sqlactalert3 = null;
            string sqlcfgUdf = null;
            string sqlctt = null;
            string sqladdrCtt;
            string sqlcttUdf = null;
            string sqlcttGroup = null;
            string sqltmp;
            
            long accountId;

            long longval;
            int intval;
            decimal decimalval;
            string crtval;
            GeneralBLL generalbll = new GeneralBLL();
            long crttime = Tools.Date.DateHelper.ToUniversalTimeStamp();

            // 判断客户是否存在
            var idxCpyName = lstCpy.FindIndex(_ => _.field == "name");
            var idxCpyPhone = lstCpy.FindIndex(_ => _.field == "phone");
            string actName = aryline[idxCpyName];
            string actPhone = aryline[idxCpyPhone];
            crm_account find = udfDal.FindSignleBySql<crm_account>($"select * from crm_account where name='{actName}' and phone='{actPhone}' and delete_time=0");
            if (find != null)
            {
                exist = true;
                if (!isUpdate)
                {
                    logDal.AddFailLog("客户已存在");
                    return false;
                }
                sqlact = $"update crm_account set delete_time=0";
                accountId = find.id;
                sqltmp = null;
            }
            else
            {
                accountId = udfDal.GetNextIdCom();
                sqlact = "insert into crm_account (id,create_user_id,update_user_id,create_time,update_time";
                sqltmp = accountId.ToString() + $",{userId},{userId},{crttime},{crttime}";
            }

            for (int i = 0; i < lstCpy.Count; i++)
            {
                crtval = aryline[idx];
                if (string.IsNullOrEmpty(crtval))
                {
                    idx++;
                    continue;
                }

                if (lstCpy[i].field.IndexOf("crm_location:") >= 0)  // 地址信息
                {

                }
                else if (lstCpy[i].type == ImportFieldType.String)
                {
                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{crtval}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{crtval}'";
                    }
                }
                else if (lstCpy[i].type == ImportFieldType.Long)
                {
                    if (!long.TryParse(crtval, out longval))
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段格式错误，应为整数数字");
                        return false;
                    }
                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{longval}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{longval}'";
                    }
                }
                else if (lstCpy[i].type == ImportFieldType.Int)
                {
                    if (!int.TryParse(crtval, out intval))
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段格式错误，应为整数数字");
                        return false;
                    }
                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{intval}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{intval}'";
                    }
                }
                else if (lstCpy[i].type == ImportFieldType.Decimal)
                {
                    if (!decimal.TryParse(crtval, out decimalval))
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段格式错误，应为小数数字");
                        return false;
                    }
                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{decimalval}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{decimalval}'";
                    }
                }
                else if (lstCpy[i].type == ImportFieldType.Check)
                {
                    if (crtval == "是")
                        intval = 1;
                    else if (crtval == "否")
                        intval = 0;
                    else
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段格式错误，应为'是'或'否'");
                        return false;
                    }

                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{intval}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{intval}'";
                    }
                }
                else if(lstCpy[i].type == ImportFieldType.Dictionary && lstCpy[i].dic != 0)     // 通用字典
                {
                    var dics = generalbll.GetDicValues(lstCpy[i].dic);
                    var finddic = dics.FindAll(_ => _.show.Equals(crtval));
                    if(finddic.Count==0)
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段找不到对应字典项");
                        return false;
                    }
                    else if (finddic.Count > 1)
                    {
                        logDal.AddFailLog($"{lstCpy[i].name}字段找到多个字典项");
                        return false;
                    }
                    if (exist)
                        sqlact += $",{lstCpy[i].field}='{finddic[0].val}'";
                    else
                    {
                        sqlact += $",{lstCpy[i].field}";
                        sqltmp += $",'{finddic[0].val}'";
                    }
                }
                else    // 其他字典
                {
                    if (lstCpy[i].field == "classification_id")
                    {
                        var cls = udfDal.FindListBySql<d_account_classification>($"select * from d_account_classification where name='{crtval}' and delete_time=0");
                        if (cls.Count == 0)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找不到对应字典项");
                            return false;
                        }
                        else if (cls.Count > 1)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找到多个字典项");
                            return false;
                        }
                        if (exist)
                            sqlact += $",{lstCpy[i].field}='{cls[0].id}'";
                        else
                        {
                            sqlact += $",{lstCpy[i].field}";
                            sqltmp += $",'{cls[0].id}'";
                        }
                    }
                    else if (lstCpy[i].field == "resource_id")
                    {
                        var dics = udfDal.FindListBySql<sys_user>($"select * from sys_user where name='{crtval}'");
                        if (dics.Count == 0)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找不到对应字典项");
                            return false;
                        }
                        else if (dics.Count > 1)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找到多个字典项");
                            return false;
                        }
                        if (exist)
                            sqlact += $",{lstCpy[i].field}='{dics[0].id}'";
                        else
                        {
                            sqlact += $",{lstCpy[i].field}";
                            sqltmp += $",'{dics[0].id}'";
                        }
                    }
                    else if (lstCpy[i].field == "parent_id")
                    {
                        var dics = udfDal.FindListBySql<crm_account>($"select id,name from crm_account where name='{crtval}' and delete_time=0");
                        if (dics.Count == 0)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找不到对应字典项");
                            return false;
                        }
                        else if (dics.Count > 1)
                        {
                            logDal.AddFailLog($"{lstCpy[i].name}字段找到多个字典项");
                            return false;
                        }
                        if (exist)
                            sqlact += $",{lstCpy[i].field}='{dics[0].id}'";
                        else
                        {
                            sqlact += $",{lstCpy[i].field}";
                            sqltmp += $",'{dics[0].id}'";
                        }
                    }
                    else if (lstCpy[i].field == "alert1" || lstCpy[i].field == "alert2" || lstCpy[i].field == "alert3")
                    {
                        int alerttype;
                        if (lstCpy[i].field == "alert1")
                            alerttype = (int)DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT;
                        else if (lstCpy[i].field == "alert2")
                            alerttype = (int)DicEnum.ACCOUNT_ALERT_TYPE.NEW_TICKET_ALERT;
                        else
                            alerttype = (int)DicEnum.ACCOUNT_ALERT_TYPE.TICKET_DETAIL_ALERT;

                        if (exist)
                        {
                            var alert = udfDal.FindSignleBySql<crm_account_alert>($"select * from crm_account_alert where account_id={accountId} and alert_type_id={alerttype} and delete_time=0");
                            if (alert == null)
                            {
                                string tmp = $"insert into crm_account_alert(id,account_id,alert_type_id,alert_text,create_user_id,update_user_id,create_time,update_time) values ({udfDal.GetNextIdCom()},{accountId},{alerttype},'{crtval}',{userId},{userId},{crttime},{crttime})";
                                if (lstCpy[i].field == "alert1")
                                    sqlactalert1 = tmp;
                                else if (lstCpy[i].field == "alert2")
                                    sqlactalert2 = tmp;
                                else
                                    sqlactalert3 = tmp;
                            }
                            else
                            {
                                string tmp = $"update crm_account_alert set alert_text='{crtval}' where id={alert.id}";
                                if (lstCpy[i].field == "alert1")
                                    sqlactalert1 = tmp;
                                else if (lstCpy[i].field == "alert2")
                                    sqlactalert2 = tmp;
                                else
                                    sqlactalert3 = tmp;
                            }
                        }
                        else
                        {
                            string tmp = $"insert into crm_account_alert(id,account_id,alert_type_id,alert_text,create_user_id,update_user_id,create_time,update_time) values ({udfDal.GetNextIdCom()},{accountId},{alerttype},'{crtval}',{userId},{userId},{crttime},{crttime})";
                            if (lstCpy[i].field == "alert1")
                                sqlactalert1 = tmp;
                            else if (lstCpy[i].field == "alert2")
                                sqlactalert2 = tmp;
                            else
                                sqlactalert3 = tmp;
                        }
                    }
                }
                
                idx++;
            }

            if (exist)
                sqlact = sqlact + $" where id={accountId}";
            else
                sqlact = $"{sqlact}) values ({sqltmp})";

            // 客户自定义字段
            sqltmp = "";
            sqlactUdf = "";
            for (int i = 0; i < udfCpy.Count; i++)
            {
                crtval = aryline[idx];
                if (string.IsNullOrEmpty(crtval))
                {
                    idx++;
                    continue;
                }

                if (exist)
                {
                    sqlactUdf += $"{udfCpy[i].field}='{crtval}',";
                }
                else
                {
                    sqlactUdf += $"{udfCpy[i].field},";
                    sqltmp += $"'{crtval}',";
                }

                idx++;
            }
            if (!string.IsNullOrEmpty(sqlactUdf))
            {
                sqlactUdf = sqlactUdf.Remove(sqlactUdf.Length - 1);
                if (exist)
                {
                    sqlactUdf = "update crm_account_ext set " + sqlactUdf + " where parent_id=" + accountId;
                }
                else
                {
                    sqltmp = sqltmp.Remove(sqltmp.Length - 1);
                    sqlactUdf = $"insert into crm_account_ext (id,parent_id,{sqlactUdf}) values ({udfDal.GetNextIdCom()},{accountId},{sqltmp})";
                }
            }
            else if (!exist)
            {
                sqlactUdf = $"insert into crm_account_ext (id,parent_id) values ({udfDal.GetNextIdCom()},{accountId})";
            }

            // 站点自定义
            sqltmp = "";
            sqlcfgUdf = "";
            for (int i = 0; i < udfCfg.Count; i++)
            {
                crtval = aryline[idx];
                if (string.IsNullOrEmpty(crtval))
                {
                    idx++;
                    continue;
                }

                if (exist)
                {
                    sqlcfgUdf += $"{udfCfg[i].field}='{crtval}',";
                }
                else
                {
                    sqlcfgUdf += $"{udfCfg[i].field},";
                    sqltmp += $"'{crtval}',";
                }

                idx++;
            }
            if (!string.IsNullOrEmpty(sqlcfgUdf))
            {
                sqlcfgUdf = sqlcfgUdf.Remove(sqlcfgUdf.Length - 1);
                if (exist)
                {
                    sqlcfgUdf = "update crm_account_site_ext set " + sqlcfgUdf + " where parent_id=" + accountId;
                }
                else
                {
                    sqltmp = sqltmp.Remove(sqltmp.Length - 1);
                    sqlcfgUdf = $"insert into crm_account_site_ext (id,parent_id,{sqlcfgUdf}) values ({udfDal.GetNextIdCom()},{accountId},{sqltmp})";
                }
            }
            else if (!exist)
            {
                sqlcfgUdf = $"insert into crm_account_site_ext (id,parent_id) values ({udfDal.GetNextIdCom()},{accountId})";
            }

            // 联系人
            sqlctt = "";
            sqltmp = "";
            if (!string.IsNullOrEmpty(fname) && !string.IsNullOrEmpty(lname) && !string.IsNullOrEmpty(email))   // 导入了联系人
            {
                long contactId;
                if (exist)
                {
                    // 判断联系人是否有匹配
                    crm_contact cttfind = udfDal.FindSignleBySql<crm_contact>($"select * from crm_contact where account_id={accountId} and first_name='{fname}' and last_name='{lname}' and email='{email}' and delete_time=0");
                    if (cttfind == null)
                    {
                        exist = false;
                        contactId = udfDal.GetNextIdCom();
                    }
                    else
                        contactId = cttfind.id;
                }
                else
                {
                    contactId = udfDal.GetNextIdCom();
                }

                if (exist)  // 更新联系人
                {
                    sqlctt = "update crm_contact set delete_time=0";
                }
                else    // 新增联系人
                {
                    sqlctt = $"insert into crm_contact (id,account_id,create_user_id,update_user_id,create_time,update_time";
                    sqltmp = $"{contactId},{accountId},{userId},{userId},{crttime},{crttime}";
                }

                for (int i = 0; i < lstCtt.Count; i++)
                {
                    crtval = aryline[idx];
                    if (string.IsNullOrEmpty(crtval))
                    {
                        idx++;
                        continue;
                    }

                    if (lstCtt[i].field.IndexOf("crm_location:") >= 0)  // 地址信息
                    {

                    }
                    else if (lstCtt[i].type == ImportFieldType.String)
                    {
                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{crtval}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{crtval}'";
                        }
                    }
                    else if (lstCtt[i].type == ImportFieldType.Long)
                    {
                        if (!long.TryParse(crtval, out longval))
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段格式错误，应为整数数字");
                            return false;
                        }
                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{longval}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{longval}'";
                        }
                    }
                    else if (lstCtt[i].type == ImportFieldType.Int)
                    {
                        if (!int.TryParse(crtval, out intval))
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段格式错误，应为整数数字");
                            return false;
                        }
                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{intval}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{intval}'";
                        }
                    }
                    else if (lstCtt[i].type == ImportFieldType.Decimal)
                    {
                        if (!decimal.TryParse(crtval, out decimalval))
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段格式错误，应为小数数字");
                            return false;
                        }
                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{decimalval}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{decimalval}'";
                        }
                    }
                    else if (lstCtt[i].type == ImportFieldType.Check)
                    {
                        if (crtval == "是")
                            intval = 1;
                        else if (crtval == "否")
                            intval = 0;
                        else
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段格式错误，应为'是'或'否'");
                            return false;
                        }

                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{intval}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{intval}'";
                        }
                    }
                    else if (lstCtt[i].type == ImportFieldType.Dictionary && lstCtt[i].dic != 0)     // 通用字典
                    {
                        var dics = generalbll.GetDicValues(lstCtt[i].dic);
                        var finddic = dics.FindAll(_ => _.show.Equals(crtval));
                        if (finddic.Count == 0)
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段找不到对应字典项");
                            return false;
                        }
                        else if (finddic.Count > 1)
                        {
                            logDal.AddFailLog($"{lstCtt[i].name}字段找到多个字典项");
                            return false;
                        }
                        if (exist)
                            sqlctt += $",{lstCtt[i].field}='{finddic[0].val}'";
                        else
                        {
                            sqlctt += $",{lstCtt[i].field}";
                            sqltmp += $",'{finddic[0].val}'";
                        }
                    }
                    else    // 其他字典
                    {
                        if (lstCtt[i].field == "contact_group")
                        {
                            var groups = udfDal.FindListBySql<crm_contact_group>($"select * from crm_contact_group where name='{crtval}' and delete_time=0");
                            if (groups.Count == 0)
                            {
                                logDal.AddFailLog($"{lstCtt[i].name}字段找不到对应联系人组");
                                return false;
                            }
                            if (groups.Count > 1)
                            {
                                logDal.AddFailLog($"{lstCtt[i].name}字段找到多个联系人组");
                                return false;
                            }
                            var contactgroup = udfDal.FindSignleBySql<crm_contact_group_contact>($"select * from crm_contact_group_contact where contact_group_id={groups[0].id} and contact_id={contactId} and delete_time=0");
                            if (contactgroup == null)
                                sqlcttGroup = $"insert into crm_contact_group_contact (id,contact_group_id,contact_id,create_user_id,update_user_id,create_time,update_time) values ({udfDal.GetNextIdCom()},{groups[0].id},{contactId},{userId},{userId},{crttime},{crttime})";

                        }
                    }

                    idx++;
                }
                if (exist)
                    sqlctt = sqlctt + $",name='{fname + lname}' where id={contactId}";
                else
                    sqlctt = $"{sqlctt},name) values ({sqltmp},'{fname + lname}')";

                sqltmp = "";
                sqlcttUdf = "";
                for (int i = 0; i < udfCtt.Count; i++)
                {
                    crtval = aryline[idx];
                    if (string.IsNullOrEmpty(crtval))
                    {
                        idx++;
                        continue;
                    }

                    if (exist)
                    {
                        sqlcttUdf += $"{udfCtt[i].field}='{crtval}',";
                    }
                    else
                    {
                        sqlcttUdf += $"{udfCtt[i].field},";
                        sqltmp += $"'{crtval}',";
                    }

                    idx++;
                }
                if (!string.IsNullOrEmpty(sqlcttUdf))
                {
                    sqlcttUdf = sqlcttUdf.Remove(sqlcttUdf.Length - 1);
                    if (exist)
                    {
                        sqlcttUdf = "update crm_contact_ext set " + sqlcttUdf + " where parent_id=" + contactId;
                    }
                    else
                    {
                        sqltmp = sqltmp.Remove(sqltmp.Length - 1);
                        sqlcttUdf = $"insert into crm_contact_ext (id,parent_id,{sqlcttUdf}) values ({udfDal.GetNextIdCom()},{contactId},{sqltmp})";
                    }
                }
                else if (!exist)
                {
                    sqlcttUdf = $"insert into crm_contact_ext (id,parent_id) values ({udfDal.GetNextIdCom()},{contactId})";
                }
            }

            List<string> sqls = new List<string>();
            sqls.Add(sqlact);
            if (!string.IsNullOrEmpty(sqlactalert1))
                sqls.Add(sqlactalert1);
            if (!string.IsNullOrEmpty(sqlactalert2))
                sqls.Add(sqlactalert2);
            if (!string.IsNullOrEmpty(sqlactalert3))
                sqls.Add(sqlactalert3);
            if (!string.IsNullOrEmpty(sqlactUdf))
                sqls.Add(sqlactUdf);
            if (!string.IsNullOrEmpty(sqlcfgUdf))
                sqls.Add(sqlcfgUdf);
            if (!string.IsNullOrEmpty(sqlctt))
                sqls.Add(sqlctt);
            if (!string.IsNullOrEmpty(sqlcttGroup))
                sqls.Add(sqlcttGroup);
            if (!string.IsNullOrEmpty(sqlcttUdf))
                sqls.Add(sqlcttUdf);

            if (udfDal.SQLTransaction(null, sqls.ToArray()))
            {
                logDal.AddSuccessLog();
                return true;
            }

            logDal.AddFailLog("出现错误！");
            return false;
        }

        #endregion

        #region 配置项导入

        /// <summary>
        /// 获取配置项导入的字段名称列表
        /// </summary>
        /// <returns></returns>
        public List<string> GetConfigItemFieldsStr()
        {
            List<string> fields = new List<string>();
            var list = GetConfigItemsFields();
            GetUdfFields(ref list, DicEnum.UDF_CATE.CONFIGURATION_ITEMS);

            foreach (var field in list)
            {
                fields.Add(field.name);
            }

            return fields;
        }

        /// <summary>
        /// 从csv文件中导入配置项
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="isUpdate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string ImportConfigItem(string filename, bool isUpdate, long userId)
        {
            string strline;
            string[] aryline;
            StreamReader mysr = new StreamReader(filename, Encoding.Default);

            // 检查模板字段
            if ((strline = mysr.ReadLine()) == null)
                return "模板格式错误！";

            List<ImportFieldStruct> lstCfg = GetConfigItemsFields();
            List<ImportFieldStruct> udfCfg = new List<ImportFieldStruct>();
            GetUdfFields(ref udfCfg, DicEnum.UDF_CATE.CONFIGURATION_ITEMS);

            aryline = strline.Split(',');
            if (aryline.Length != lstCfg.Count + udfCfg.Count)
                return "模板格式错误！";

            for (int i = 0; i < lstCfg.Count; i++)
            {
                if (aryline[i] != lstCfg[i].name)
                    return "模板格式错误！";
            }
            for (int i = 0; i < udfCfg.Count; i++)
            {
                if (aryline[i + lstCfg.Count] != udfCfg[i].name)
                    return "模板格式错误！";
            }

            // 记录导入日志
            com_import_log log = new com_import_log();
            com_import_log_dal logdal = new com_import_log_dal();
            log.cate_id = (int)DicEnum.DATA_IMPORT_CATE.CONFIGURATION;
            log.id = logdal.GetNextIdCom();
            log.import_user_id = userId;
            log.import_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            log.file_name = filename;
            logdal.Insert(log);

            com_import_log_detail_dal logDetailDal = new com_import_log_detail_dal(log.id);

            while ((strline = mysr.ReadLine()) != null)
            {
                if (ImportConfigItemOneLine(strline, isUpdate, userId, logDetailDal, lstCfg, udfCfg))
                    log.success_num++;
                else
                    log.fail_num++;
            }
            if (log.success_num != 0 || log.fail_num != 0)
                logdal.Update(log);

            return null;
        }

        /// <summary>
        /// 导入一个配置项
        /// </summary>
        /// <param name="strline"></param>
        /// <param name="isUpdate"></param>
        /// <param name="userId"></param>
        /// <param name="logDal"></param>
        /// <param name="lstCfg"></param>
        /// <param name="udfCfg"></param>
        /// <returns></returns>
        private bool ImportConfigItemOneLine(string strline, bool isUpdate, long userId, com_import_log_detail_dal logDal, List<ImportFieldStruct> lstCfg, List<ImportFieldStruct> udfCfg)
        {
            var aryline = strline.Split(',');

            if (!string.IsNullOrEmpty(aryline[0]) && !isUpdate)
            {
                logDal.AddFailLog($"不更新数据不能填写配置项ID");
                return false;
            }

            // 检查必填字段
            for (int i = 0; i < lstCfg.Count; i++)
            {
                if (lstCfg[i].require == 1 && string.IsNullOrEmpty(aryline[i]))
                {
                    logDal.AddFailLog($"{lstCfg[i].name}字段为空");
                    return false;
                }
            }
            for (int i = 0; i < udfCfg.Count; i++)
            {
                if (udfCfg[i].require == 1 && string.IsNullOrEmpty(aryline[i + lstCfg.Count]))
                {
                    logDal.AddFailLog($"{udfCfg[i].name}字段为空");
                    return false;
                }
            }

            string crtval;
            long cfgId;
            bool exist = false;
            int idxtmp;
            string valtmp;

            string sqlcfg = null;
            string sqlcfgUdf = null;
            string sqlpdt = null;

            // 判断是否有匹配
            crtval = aryline[0];
            if (!string.IsNullOrEmpty(crtval))
            {
                if (!long.TryParse(crtval, out cfgId))
                {
                    logDal.AddFailLog("配置项ID格式错误");
                    return false;
                }
                var cfg = udfDal.FindSignleBySql<crm_installed_product>($"select * from crm_installed_product where id={cfgId} and delete_time=0");
                if (cfg == null)
                {
                    logDal.AddFailLog($"配置项ID{cfgId}记录不存在");
                    return false;
                }
                exist = true;
            }
            int idxPdtName = lstCfg.FindIndex(_ => _.field == "product_id");
            int idxActName = lstCfg.FindIndex(_ => _.field == "account_id");
            crtval = aryline[idxPdtName];
            var pdtlist = udfDal.FindListBySql<ivt_product>($"select * from ivt_product where name='{crtval}' and delete_time=0");
            if (pdtlist.Count == 0)     // 产品不存在，判断是否新增产品
            {
                idxtmp = lstCfg.FindIndex(_ => _.field == "cost_code_id");
                valtmp = aryline[idxtmp];
                if (string.IsNullOrEmpty(valtmp))
                {
                    logDal.AddFailLog("新增产品需填入物料代码");
                    return false;
                }

            }
            if (!exist)
            {
                int idxSerNum = lstCfg.FindIndex(_ => _.field == "serial_number");
                if (!string.IsNullOrEmpty(aryline[idxSerNum]))
                {

                }
            }

            return true;
        }

        #endregion

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
                case DicEnum.UDF_CATE.CONFIGURATION_ITEMS:
                    pre = "自定义:";
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
            list.Add(new ImportFieldStruct { name = "客户:客户详细提醒", field = "alert1", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:新建工单提醒", field = "alert2", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "客户:工单进度提醒", field = "alert3", type = ImportFieldType.Dictionary });
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
            list.Add(new ImportFieldStruct { name = "联系人:邮箱", field = "email" });
            list.Add(new ImportFieldStruct { name = "联系人:邮箱2", field = "email2" });
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
            list.Add(new ImportFieldStruct { name = "联系人:联系人组", field = "contact_group", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "联系人:是否激活", field = "is_active", type = ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "联系人:是否主联系人", field = "is_primary_contact", type = ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "联系人:qq号", field = "qq" });
            list.Add(new ImportFieldStruct { name = "联系人:微信号", field = "wechat" });
            list.Add(new ImportFieldStruct { name = "联系人:新浪微博地址", field = "weibo_url" });
        }

        /// <summary>
        /// 获取配置项的导入字段信息
        /// </summary>
        /// <returns></returns>
        private List<ImportFieldStruct> GetConfigItemsFields()
        {
            List<ImportFieldStruct> list = new List<ImportFieldStruct>();

            list.Add(new ImportFieldStruct { name = "配置项ID[更新填写]", field = "id", type= ImportFieldType.Long });
            list.Add(new ImportFieldStruct { name = "[必填]产品名称", field = "product_id", require=1, type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "[必填]客户名称", field = "account_id", require = 1, type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "配置项种类", field = "cate_id", type = ImportFieldType.Dictionary, dic=108 });
            list.Add(new ImportFieldStruct { name = "[必填]安装日期", field = "start_date", require = 1, type = ImportFieldType.Date });
            list.Add(new ImportFieldStruct { name = "质保过期日期", field = "through_date", type = ImportFieldType.Date });
            list.Add(new ImportFieldStruct { name = "序列号", field = "serial_number" });
            list.Add(new ImportFieldStruct { name = "参考号", field = "reference_number" });
            list.Add(new ImportFieldStruct { name = "用户数", field = "number_of_users", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "联系人", field = "contact_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "安装位置", field = "location" });
            list.Add(new ImportFieldStruct { name = "合同", field = "contract_id",type=ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "服务", field = "service_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "服务集", field = "service_bundle_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "供应商", field = "vendor_account_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "上级配置项序列号", field = "parent_id" });
            list.Add(new ImportFieldStruct { name = "备注", field = "remark" });
            list.Add(new ImportFieldStruct { name = "每小时成本", field = "hourly_cost", type= ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "日成本", field = "daily_cost", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "月度成本", field = "monthly_cost", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "初始费用", field = "setup_fee", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "每次使用成本", field = "peruse_cost", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "客户链接", field = "accounting_link" });
            list.Add(new ImportFieldStruct { name = "物料代码[新增产品必填]", field = "cost_code_id", type= ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "是否激活", field = "is_active",type= ImportFieldType.Check });
            list.Add(new ImportFieldStruct { name = "订阅名称[新增订阅必填]", field = "crm_subscription:name" });
            list.Add(new ImportFieldStruct { name = "订阅描述", field = "crm_subscription:description" });
            list.Add(new ImportFieldStruct { name = "订阅周期类型[新增订阅必填]", field = "crm_subscription:period_type_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "订阅生效日期[新增订阅必填]", field = "crm_subscription:effective_date", type = ImportFieldType.Date });
            list.Add(new ImportFieldStruct { name = "订阅到期日期[新增订阅必填]", field = "crm_subscription:expiration_date", type = ImportFieldType.Date });
            list.Add(new ImportFieldStruct { name = "订阅周期价格[新增订阅必填]", field = "crm_subscription:period_price", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "订阅物料成本代码[新增订阅必填]", field = "crm_subscription:cost_code_id", type = ImportFieldType.Dictionary });
            list.Add(new ImportFieldStruct { name = "订阅订单号", field = "crm_subscription:purchase_order_no" });
            list.Add(new ImportFieldStruct { name = "订阅周期成本", field = "crm_subscription:period_cost", type = ImportFieldType.Decimal });
            list.Add(new ImportFieldStruct { name = "订阅状态", field = "crm_subscription:status_id", type = ImportFieldType.Dictionary });

            return list;
        }

        // 导入数据的字段类型
        private enum ImportFieldType
        {
            String,         // 字符
            Int,            // 整形
            Long,           // 
            Decimal,        // 
            Date,           // 日期
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
