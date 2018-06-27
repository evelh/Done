﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SaleOrder
{
    public partial class SaleQuotaMonth : BasePage
    {
        protected List<sys_resource> resourceList;
        protected sys_resource_sales_quota resQuota;
        protected bool isAdd = true;
        protected int year = DateTime.Now.Year;
        protected int month = DateTime.Now.Month;
        protected SaleOrderBLL salBll = new SaleOrderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["year"]))
                int.TryParse(Request.QueryString["year"] ,out year);
            if (!string.IsNullOrEmpty(Request.QueryString["month"]))
                int.TryParse(Request.QueryString["month"], out month);
            resourceList = new UserResourceBLL().GetResourceByTime(year,month);
            long resId = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["resId"]) && long.TryParse(Request.QueryString["resId"], out resId))
                resQuota = salBll.GetResMonthQuota(resId,year,month);
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                resQuota = salBll.GetQuotaById(id);

            if (resQuota != null)
            {
                isAdd = false;
                var thisRes = new UserResourceBLL().GetResourceById(resQuota.resource_id);
                year = resQuota.year;
                month = resQuota.month;
                if (resourceList == null || (!resourceList.Any(_ => _.id == resQuota.resource_id)))
                    resourceList.Add(thisRes);
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var pageQuota = AssembleModel<sys_resource_sales_quota>();
        }
    }
}