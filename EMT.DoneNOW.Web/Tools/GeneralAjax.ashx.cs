using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// GeneralAjax 的摘要说明
    /// </summary>
    public class GeneralAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "general":
                        var general_id = context.Request.QueryString["id"];
                        GetGeneralInfo(context, long.Parse(general_id));
                        break;
                    case "GetTaxSum":
                        var accDedIds = context.Request.QueryString["ids"];
                        var tax_id = context.Request.QueryString["taxId"];
                        GetTaxSum(context, long.Parse(tax_id), accDedIds);
                        break;
                    case "GetNotiTempEmail":
                        var notiTempId = context.Request.QueryString["temp_id"];
                        GetNotiTempEmail(context,long.Parse(notiTempId));
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



        private void GetGeneralInfo(HttpContext context, long id)
        {
            var general = new d_general_dal().GetGeneralById(id);
            if (general != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(general));
            }
        }
        /// <summary>
        ///  根据税区和条目税种计算税额
        /// </summary>
        private void GetTaxSum(HttpContext context, long tax_id, string accDedIds)
        {
            if (tax_id == 0 || string.IsNullOrEmpty(accDedIds))
            {
                context.Response.Write("0.00");
                return;
            }

            decimal totalMoney = 0;
            // 所有需要计算的条目的Id的集合
            var accDedIdList = accDedIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (accDedIdList != null && accDedIdList.Count() > 0)
            {
                var adDal = new crm_account_deduction_dal();
                foreach (var accDedId in accDedIdList)
                {
                    var accDedList = adDal.GetInvDedDtoList($" and id={accDedId}");
                    var thisAccDed = adDal.FindNoDeleteById(long.Parse(accDedId));
                    if (accDedList != null && accDedList.Count > 0)
                    {
                        var accDed = accDedList.FirstOrDefault(_ => _.id.ToString() == accDedId);
                        if (accDed.tax_category_id != null)
                        {
                            var thisTax = new d_tax_region_cate_dal().GetSingleTax(tax_id, (long)accDed.tax_category_id);
                            if (thisTax != null && thisAccDed.extended_price != null)
                            {
                                totalMoney += (decimal)(thisAccDed.extended_price * thisTax.total_effective_tax_rate);
                            }
                        }
                    }
                }
            }
            context.Response.Write(totalMoney.ToString("#0.00"));

        }
        /// <summary>
        /// 根据通知模板获取相关模板邮件信息
        /// </summary>
        private void GetNotiTempEmail(HttpContext context, long temp_id)
        {

            var tempEmailList = new sys_notify_tmpl_email_dal().GetEmailByTempId(temp_id);
            if (tempEmailList != null&& tempEmailList.Count>0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(tempEmailList[0]));
            }


        }
        
    }
}