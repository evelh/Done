using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectUdf : BasePage
    {
        protected DTO.UserDefinedFieldDto udf;      // 自定义字段信息
        protected long objectId;
        protected DicEnum.UDF_CATE cate;
        protected object udfValue;
        protected sys_udf_field thisUdfInfo = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            string colName = Request.QueryString["colName"];
            objectId = Convert.ToInt64(Request.QueryString["object_id"]);

            var objType= Request.QueryString["object_type"];
            switch (objType)
            {
                case "project":
                    cate = DicEnum.UDF_CATE.PROJECTS;
                    break;
                default:
                    break;
            }
            thisUdfInfo = new DAL.sys_udf_field_dal().GetInfoByCateAndName((int)cate, colName);

            //if (!IsPostBack)
            //{
                var bll = new UserDefinedFieldsBLL();
                var udfList = bll.GetUdf(cate);
                udf = udfList.First(f => f.name.Equals(colName));
                var udfValues = bll.GetUdfValue(cate, objectId, udfList);
                udfValue = udfValues.First(v => v.id == udf.id).value;
            //}


            if (thisUdfInfo == null)  // 没有找到该自定义相关信息，停止响应
            {
                Response.End();
            }
            
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            string udfValue = Request.Form[udf.id.ToString()];
            if (!string.IsNullOrWhiteSpace(udfValue) && !string.IsNullOrEmpty(udfValue))
            {

            }
            else
            {
                udfValue = null;
            }
            DicEnum.OPER_LOG_OBJ_CATE operCate = DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION;
            switch (cate)
            {
                case DicEnum.UDF_CATE.PROJECTS:
                    operCate= DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION;
                    break;
                default:
                    break;
            }


            var result =  new UserDefinedFieldsBLL().EditUdf(cate, objectId, udf.id,udfValue,Request.Form["description"],LoginUserId, operCate);
            if (result)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功');window.close();self.opener.location.reload();</script>");
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败');window.close();self.opener.location.reload();</script>");
            }
          
        }
    }
}