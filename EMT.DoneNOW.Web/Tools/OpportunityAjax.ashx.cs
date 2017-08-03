using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// OpportunityAjax 的摘要说明
    /// </summary>
    public class OpportunityAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var opportunity_id = context.Request.QueryString["id"];
                        break;
                    case "formTemplate":
                        var formTemp_id = context.Request.QueryString["id"];
                        GetFormTemplate(context,Convert.ToInt64(formTemp_id));
                        break;
                    case "property":
                        var id = context.Request.QueryString["id"];
                        var propertyName = context.Request.QueryString["property"];
                        GetOpportunityProperty(context,id,propertyName);
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();

            }
        }
        /// <summary>
        /// 删除商机处理
        /// </summary>
        /// <param name="context"></param>
        /// <param name="opportunity_id"></param>
        public void DeleteOpportunity(HttpContext context,long opportunity_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new OpportunityBLL().DeleteOpportunity(opportunity_id,user.id);
                if (result)
                {
                    context.Response.Write("删除商机成功！");
                }                               
                else                            
                {                               
                    context.Response.Write("删除商机失败！");
                }
            }
            
        }
        /// <summary>
        /// 根据商机模板填充商机内容
        /// </summary>
        /// <param name="context"></param>
        /// <param name="formTemp_id"></param>
        public void GetFormTemplate(HttpContext context, long formTemp_id)
        {
            var formTemplate = new FormTemplateBLL().GetOpportunityTmpl((int)formTemp_id);
            if (formTemplate != null)
            {
                var json = new Tools.Serialize().SerializeJson(formTemplate);
                if (formTemplate.account_id != null)
                {
                    var companyName = new CompanyBLL().GetCompany((long)formTemplate.account_id);   // todo  当客户删除后，表单模板查询的客户为null                  
                    if (companyName != null)
                    {
                        json = json.Substring(0, json.Length - 1);
                        json += ",\"ParentComoanyName\":\"" + companyName.name + "\"}";
                    }                    
                }                            
                context.Response.Write(json);
            }
        }


        private void GetOpportunityProperty(HttpContext context, string opportunity_id, string propertyName)
        {
            var opportunity = new OpportunityBLL().GetOpportunity(long.Parse(opportunity_id));
            if (opportunity != null)
            {
                context.Response.Write(DAL.BaseDAL<crm_opportunity>.GetObjectPropertyValue(opportunity, propertyName));
            }
        }
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}