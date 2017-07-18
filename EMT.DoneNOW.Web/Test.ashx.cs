using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System.Reflection;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// Test 的摘要说明
    /// </summary>
    public class Test : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            // context.Response.Write("Hello World");

            var ttt =  AssembleModel<CompanyAddDto>();




            var param = new CompanyAddDto();
            param.general.company_name = context.Request.QueryString["CompanyName"];
            param.general.phone = context.Request.Form["Phone"];
            param.contact.first_name = context.Request.Form["FirstName"];
            param.contact.last_name = context.Request.Form["LastName"];
            param.location.country_id = Convert.ToInt32(context.Request.Form["Country"]);
            param.location.province_id = Convert.ToInt32(context.Request.Form["Province"]);
            param.location.city_id = Convert.ToInt32(context.Request.Form["City"]);
            param.location.address = context.Request.Form["Address"];
            param.location.additional_address = context.Request.Form["AdditionalAddress"];
            param.location.postal_code = context.Request.Form["PostCode"];
            param.general.tax_region = Convert.ToInt32(context.Request.Form["TaxRegion"]);
            param.general.tax_id = context.Request.Form["TaxId"];
            param.general.tax_exempt = context.Request.Form["TaxExempt"] == "1";
            param.general.alternate_phone1 = context.Request.Form["AlternatePhone1"];
            param.general.alternate_phone2 = context.Request.Form["AlternatePhone2"];
            param.contact.mobile_phone = context.Request.Form["MobilePhone"];
            param.general.fax = context.Request.Form["Fax"];
            param.general.company_type = Convert.ToInt32(context.Request.Form["CompanyType"]);
            param.general.classification = Convert.ToInt32(context.Request.Form["Classification"]);
            param.general.account_manage = Convert.ToInt32(context.Request.Form["AccountManger"]);
            param.general.territory_name = Convert.ToInt32(context.Request.Form["TerritoryName"]);
            param.general.market_segment = Convert.ToInt32(context.Request.Form["MarketSegment"]);
            param.general.competitor = Convert.ToInt32(context.Request.Form["Competitor"]);
            param.general.parent_company_name = Convert.ToInt32(context.Request.Form["ParentComoanyName"]);
            param.general.web_site = context.Request.Form["WebSite"];
            param.general.company_number = context.Request.Form["CompanyNumber"];
            var companyBll = new CompanyBLL();

            var result = companyBll.Insert(param, "");
            if (result == ERROR_CODE.PARAMS_ERROR)                    // 必要参数丢失
            {

            }
            else if (result == ERROR_CODE.CRM_ACCOUNT_NAME_EXIST)      // 用户名称已经存在
            {

            }


























            //var companyBLL = new CompanyBLL();

            //var compareAccountName = companyBLL.CheckCompanyName(companyName);    
            //if (compareAccountName != null && compareAccountName.Count > 0)
            //{
            //    compareAccountName.ForEach(_ => {
            //        context.Response.Write(_+",");
            //    });
            //}
            //else
            //{
            //    context.Response.Write("ok");
            //}


        }
        protected T AssembleModel<T>()
        {
            System.Collections.Specialized.NameValueCollection valueCollection = HttpContext.Current.Request.Params;    // 请求上下文提交的参数
            PropertyInfo[] propertyInfoList = GetPropertyInfoArray(typeof(T));
            if (propertyInfoList == null)
                return default(T);

            object obj = Activator.CreateInstance(typeof(T), null); // 创建指定类型实例
            foreach (string key in valueCollection.Keys)    // 所有上下文的值
            {
                foreach (var PropertyInfo in propertyInfoList)  // 所有实体属性
                {
                    if (key.ToLower() == PropertyInfo.Name.ToLower())
                    {
                        PropertyInfo.SetValue(obj, valueCollection[key], null); // 给对象赋值
                    }
                }
            }
            return (T)obj;
        }

        /// <summary>
        /// 反射获取类的属性
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        private PropertyInfo[] GetPropertyInfoArray(Type type)
        {
            PropertyInfo[] props = null;
            try
            {
                object obj = Activator.CreateInstance(type);
                props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            }
            catch (Exception ex)
            {
            }
            return props;
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