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

        }
    }
}