using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class UserDefinedField : BasePage
    {
        protected UserDefinedFieldDto udfField;
        protected List<DictionaryEntryDto> udfCates;
        protected List<DictionaryEntryDto> udfTypes;
        protected string udfTypeOpts;
        private UserDefinedFieldsBLL bll = new UserDefinedFieldsBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            long id;
            udfCates = new GeneralBLL().GetDicValues(GeneralTableEnum.UDF_FIELD_CATE);
            udfTypes = new GeneralBLL().GetDicValues(GeneralTableEnum.UDF_FIELD_TYPE);

            if (!IsPostBack)
            {
                if (long.TryParse(Request.QueryString["id"], out id))
                {
                    udfField = bll.GetUdfInfo(id);
                    if (udfField == null)
                    {
                        Response.Write("<script>alert('参数错误！'); </script>");
                        Response.End();
                        return;
                    }

                    if (udfField.data_type == (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                    {
                        udfTypeOpts = "<option value='" + (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT + "' selected='selected' >单行文本</option>";
                        udfTypeOpts += "<option value='" + (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT + "' >多行文本</option>";
                    }
                    else if (udfField.data_type == (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                    {
                        udfTypeOpts = "<option value='" + (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT + "' >单行文本</option>";
                        udfTypeOpts += "<option value='" + (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT + "' selected='selected' >多行文本</option>";
                    }
                    else
                    {
                        var find = udfTypes.Find(_ => _.val.Equals(udfField.data_type.ToString()));
                        udfTypeOpts = "<option value='" + (int)DicEnum.UDF_DATA_TYPE.SINGLE_TEXT + "' >单行文本</option>";
                        udfTypeOpts += "<option value='" + (int)DicEnum.UDF_DATA_TYPE.MUILTI_TEXT + "' >多行文本</option>";
                        udfTypeOpts += "<option value='" + udfField.data_type + "' selected='selected' >" + find.show + "</option>";
                    }
                }
            }
            else
            {
                UserDefinedFieldDto dto = new UserDefinedFieldDto();
                dto.list = new List<sys_udf_list>();
                if (long.TryParse(Request.QueryString["id"], out id))
                {
                    udfField = bll.GetUdfInfo(id);
                    dto.id = (int)id;
                    dto.cate = udfField.cate;
                    foreach (var udfval in udfField.list)
                    {
                        if (!string.IsNullOrEmpty(Request.QueryString["listValShowe" + udfval.id]))
                        {
                            if (Request.Form["dftid"] != udfval.id.ToString())
                                udfval.is_default = 0;
                            dto.list.Add(udfval);
                        }
                    }
                }
                else
                {
                    dto.cate = int.Parse(Request.Form["cate_id"]);
                }
                dto.is_active = (sbyte)(GetCheckBoxValue("active") ? 1 : 0);
                dto.required = (sbyte)(GetCheckBoxValue("require") ? 1 : 0);
                dto.is_protected = (sbyte)(GetCheckBoxValue("protect") ? 1 : 0);
                dto.is_encrypted = (sbyte)(GetCheckBoxValue("encrypted") ? 1 : 0);
                dto.is_visible_in_portal = (sbyte)(GetCheckBoxValue("showinportal") ? 1 : 0);
                dto.name = Request.Form["col_comment"];
                dto.description = Request.Form["description"];
                dto.default_value = Request.Form["default_value"];
                dto.data_type = int.Parse(Request.Form["data_type_id"]);
                dto.sort_order = Request.Form["sort_value"];
                if (!string.IsNullOrEmpty(Request.Form["crm_to_project_udf_id"]))
                    dto.crm_to_project = int.Parse(Request.Form["crm_to_project_udf_id"]);

                var ids = Request.Form["crm_to_project_udf_id"];
                if (!string.IsNullOrEmpty(ids))
                {
                    ids = ids.Remove(ids.Length - 1, 1);
                    var idstr = ids.Split(',');
                    foreach (var valid in idstr)
                    {
                        var ufv = new sys_udf_list();
                        ufv.name = Request.Form["listValShow" + valid];
                        if (Request.Form["dftid"] == valid)
                            ufv.is_default = 1;
                        if (!string.IsNullOrEmpty(Request.Form["listValOrder" + valid]))
                            ufv.sort_order = decimal.Parse(Request.Form["listValOrder" + valid]);
                        dto.list.Add(ufv);
                    }
                }

                bll.EditUdf((DicEnum.UDF_CATE)dto.cate, dto, LoginUserId);
                if (Request.Form["act"] == "new")
                {
                    Response.Write("<script>alert('保存自定义字段成功');window.location.href='UserDefinedField.aspx';self.opener.location.reload();</script>");
                }
                else
                {
                    Response.Write("<script>alert('保存自定义字段成功');window.close();self.opener.location.reload();</script>");
                }
            }

        }

        private bool GetCheckBoxValue(string key)
        {
            if (string.IsNullOrEmpty(Request.Form[key]))
                return false;
            if (Request.Form[key] == "on")
                return true;
            return false;
        }
    }
}