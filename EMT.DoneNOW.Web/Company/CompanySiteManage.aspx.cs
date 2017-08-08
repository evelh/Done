using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Company
{
    public partial class CompanySiteManage : BasePage
    {
        protected List<UserDefinedFieldDto> site_udfList = null; // 站点自定义
        protected List<UserDefinedFieldValue> site_udfValueList = null; //
        protected crm_account account = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var company_id = Convert.ToInt64(Request.QueryString["id"]);
  
                account = new CompanyBLL().GetCompany(company_id);
                if (account != null)
                {
                    site_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.SITE);
                    site_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.SITE, company_id, site_udfList);
                }
                else
                {
                    Response.End();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        protected void edit_Click(object sender, EventArgs e)
        {
            var valueList = new List<UserDefinedFieldValue>();
            if (site_udfList != null && site_udfList.Count > 0)
            {
                //var list = new List<UserDefinedFieldValue>();
                foreach (var udf in site_udfList)
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    valueList.Add(new_udf);
                }          
            }

            if (valueList != null&& valueList.Count > 0)
            {
                var user = UserInfoBLL.GetUserInfo(GetLoginUserId());
                if (new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.SITE, site_udfList, account.id, valueList, user, DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER_SITE))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功');window.close();</script>");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败');window.close();</script>");
                }
                
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('尚未配置站点信息');window.close();</script>");
            }
        }
    }
}