using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ConfigItemTypeAjax 的摘要说明
    /// </summary>
    public class ConfigItemTypeAjax : BaseAjax
    {
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var type_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "delete":
                    Delete(context, Convert.ToInt64(type_id)); break;
                case "delete_valid":
                    Delete(context, Convert.ToInt64(type_id)); break;
                case "Active":
                    Active(context, Convert.ToInt64(type_id)); break;
                case "No_Active":
                    No_Active(context, Convert.ToInt64(type_id)); break;
                case "GetUdfByCate":
                    GetUdfByCate(context);
                    break;
                default: break;
            }
        }
        public void Delete_Valid(HttpContext context, long type_id)
        {
            string returnvalue = string.Empty;
            var result = new ConfigTypeBLL().Delete_Valid(type_id, LoginUserId, out returnvalue);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                Delete(context, type_id);
            }
            else if (result == DTO.ERROR_CODE.EXIST)
            {
                context.Response.Write(returnvalue);
            }
            else if (result == DTO.ERROR_CODE.SYSTEM)
            {
                context.Response.Write("system");
            }
            else
            {
                context.Response.Write("other");
            }
        }
        public void Delete(HttpContext context, long type_id)
        {
            var result = new ConfigTypeBLL().Delete(type_id, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("删除成功！");
            }
            else
            {
                context.Response.Write("删除失败！");
            }
        }
        public void Active(HttpContext context, long type_id)
        {
            var result = new GeneralBLL().Active(type_id, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("激活成功！");
            }
            else if (result == DTO.ERROR_CODE.ACTIVATION)
            {
                context.Response.Write("已是激活状态，无需此操作！");
            }
            else
            {
                context.Response.Write("激活失败！");
            }
        }
        public void No_Active(HttpContext context, long type_id)
        {

            var result = new GeneralBLL().NoActive(type_id, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("停用成功！");
            }
            else if (result == DTO.ERROR_CODE.NO_ACTIVATION)
            {
                context.Response.Write("已是停用状态，无需此操作！");
            }
            else
            {
                context.Response.Write("停用失败！");
            }
        }

        public void GetUdfByCate(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];
            crm_installed_product insPro = null;
            List<DTO.UserDefinedFieldValue> iProduct_udfValueList = null;
            if (!string.IsNullOrEmpty(insProId))
            {
                insPro = new DAL.crm_installed_product_dal().FindNoDeleteById(long.Parse(insProId));
                var iProduct_udfList = new UserDefinedFieldsBLL().GetUdf(DTO.DicEnum.UDF_CATE.CONFIGURATION_ITEMS);
                iProduct_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DTO.DicEnum.UDF_CATE.CONFIGURATION_ITEMS, insPro.id, iProduct_udfList);
            }
            var cateId = context.Request.QueryString["cateId"];
            string udfHtml = "";
            if (!string.IsNullOrEmpty(cateId))
            {
              
                var usdList = new DAL.sys_udf_field_dal().GetUdfByGroupId(long.Parse(cateId));
                if(usdList!=null&& usdList.Count > 0)
                {
                    var udfFileDto = new UserDefinedFieldsBLL().GetUdf((DTO.DicEnum.UDF_CATE.CONFIGURATION_ITEMS));
                    usdList.ForEach(_ => {
                        DTO.UserDefinedFieldValue thisValue = null;
                        if(iProduct_udfValueList!=null&& iProduct_udfValueList.Count > 0)
                        {
                            thisValue = iProduct_udfValueList.FirstOrDefault(ip => ip.id == _.id);
                        }
                        switch (_.data_type_id)
                        {
                            case (int)DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT:
                                udfHtml += $"<tr><td class='ip_general_label_udf'><div class='clear'><label>{_.col_comment}</label><input type = 'text' name='{_.id}' class='sl_cdt' value='{(thisValue==null?"":thisValue.value)}' /></div></td></tr>";
                                break;
                            case (int)DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT:
                                udfHtml += $"<tr><td class='ip_general_label_udf'><div class='clear'><label>{_.col_comment}</label><textarea name='{_.id}' rows='2' cols='20'>{(thisValue == null ? "" : thisValue.value)}</textarea></div></td></tr>";
                                break;
                            case (int)DTO.DicEnum.UDF_DATA_TYPE.DATETIME:
                                udfHtml += $"<tr><td class='ip_general_label_udf'><div class='clear'><label>{_.col_comment}</label><input type = 'text' name='{_.id}' onclick='WdatePicker()' class='sl_cdt' value='{(thisValue == null ? "" : thisValue.value)}' /></div></td></tr>";
                                break;
                            case (int)DTO.DicEnum.UDF_DATA_TYPE.NUMBER:
                                udfHtml += $"<tr><td class='ip_general_label_udf'><div class='clear'><label>{_.col_comment}</label><input type = 'text' name='{_.id}'  maxlength='11' onkeyup=\"value = value.replace(/[^\\d] / g, '') \" onbeforepaste=\"clipboardData.setData('text', clipboardData.getData('text').replace(/[^\\d] / g, ''))\" class='sl_cdt' value='{(thisValue == null ? "" : thisValue.value)}' /></div></td></tr>";
                                break;
                            case (int)DTO.DicEnum.UDF_DATA_TYPE.LIST:
                                var thisListHtml = "";
                                if(udfFileDto!=null&& udfFileDto.Count > 0)
                                {
                                    var thisList = udfFileDto.FirstOrDefault(u => u.id == _.id);
                                    if (thisList != null&& thisList.value_list!=null&& thisList.value_list.Count>0)
                                    {
                                        if (_.is_required == 0)
                                            thisListHtml += "<option value=''> </option>";
                                        thisList.value_list.ForEach(t => {
                                            if (thisValue != null && thisValue.value.ToString() == t.val)
                                                thisListHtml += $"<option value='{t.val}' selected='selected'>{t.show}</option>";
                                            else
                                                thisListHtml += $"<option value='{t.val}'>{t.show}</option>";
                                        });
                                    }
                                }
                                udfHtml += $"<tr><td class='ip_general_label_udf'><div class='clear'><label>{_.col_comment}</label><select class='sl_cdt' name='{_.id}'>{thisListHtml}</select></div></td></tr>";
                                break;
                            default:
                                break;
                        }
                    });
                }
            }
            context.Response.Write(udfHtml);
        }

    }
}