using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class OopportunityAdd : BasePage
    {
        protected crm_opportunity opportunity = null;        // 用于修改时获取商机内容
        protected bool isAdd = true;                           // 用于判断新增或修改   
        protected List<UserDefinedFieldDto> opportunity_udfList = null;     
        protected List<UserDefinedFieldValue> opportunity_udfValueList = null;    
        protected List<UserDefinedFieldDto> company_udfList = null;
        protected List<UserDefinedFieldValue> company_udfValueList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var opportunity_id = Request.QueryString["opportunity_id"];
                opportunity = new crm_opportunity_dal().GetOpportunityById(Convert.ToInt64(opportunity_id));
                if (opportunity != null)
                {
                    isAdd = false;
                    opportunity_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                    company_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.COMPANY);
                }
                if (!isAdd)
                {
                    opportunity_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.OPPORTUNITY,opportunity.id, opportunity_udfList);
                    //company_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.COMPANY,opportunity.id, opportunity_udfList);
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        protected void save_Click(object sender, EventArgs e)
        {
            var param = new OpportunityAddOrUpdateDto() {
                general = AssembleModel<crm_opportunity>(),
                notify = AssembleModel<com_notify_email>(),
            };
            if (opportunity_udfList != null && opportunity_udfList.Count > 0)                      // 首先判断是否有自定义信息
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var udf in opportunity_udfList)                            // 循环添加
                {
                    var new_udf = new UserDefinedFieldValue()
                    {
                        id = udf.id,
                        value = Request.Form[udf.id.ToString()] == "" ? null : Request.Form[udf.id.ToString()],
                    };
                    list.Add(new_udf);

                }
                param.udf = list;
            }
            if (isAdd)
            {
                var result = new OpportunityBLL().Insert(param,GetLoginUserId());   // 根据参数插入商机
                if (result == ERROR_CODE.PARAMS_ERROR)   // 必填参数丢失，重写
                {
                    Response.Write("<script>alert('必填参数丢失，请重新填写'); </script>");
                }              
                else if (result == ERROR_CODE.USER_NOT_FIND)               // 用户丢失
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("Login.aspx");
                }            
                else if (result == ERROR_CODE.SUCCESS)                    // 插入用户成功，刷新前一个页面
                {
                    Response.Write("<script>alert('添加商机成功！');</script>");  //  关闭添加页面的同时，刷新父页面
                }
            }
            else
            {
                // todo 修改操作
            }
        }
    }
}