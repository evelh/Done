using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class ViewContactList : BasePage
    {
        protected List<crm_contact> conList;
        protected string conIds;
        protected string sortOrder;
        protected void Page_Load(object sender, EventArgs e)
        {
            conIds = Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(conIds))
                conList = new ContactBLL().GetListByIds(conIds);
            sortOrder = Request.QueryString["sortOrder"];
            if (!string.IsNullOrEmpty(sortOrder)&& conList!=null&& conList.Count>0)
            {
                var srotArr = sortOrder.Split('_');
                if (srotArr.Length == 2)
                {
                    if (srotArr[0] == "name")
                    {
                        if (srotArr[1] == "asc")
                            conList = conList.OrderBy(_ => _.name).ToList();
                        else
                            conList = conList.OrderByDescending(_ => _.name).ToList();
                    }
                    else if (srotArr[0] == "email")
                    {
                        if (srotArr[1] == "asc")
                            conList = conList.OrderBy(_ => _.email).ToList();
                        else
                            conList = conList.OrderByDescending(_ => _.email).ToList();
                    }
                    else if (srotArr[0] == "title")
                    {
                        if (srotArr[1] == "asc")
                            conList = conList.OrderBy(_ => _.title).ToList();
                        else
                            conList = conList.OrderByDescending(_ => _.title).ToList();
                    }
                }
            }
        }
    }
}