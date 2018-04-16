using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class HolidaySet : BasePage
    {
        protected bool isAdd = true;
        protected long id;
        protected string name;
        protected string description;
        protected void Page_Load(object sender, EventArgs e)
        {
            var bll = new GeneralBLL();
            if (long.TryParse(Request.QueryString["id"], out id))
            {
                isAdd = false;
                var holiday = bll.GetSingleGeneral(id);
                name = holiday.name;
                description = holiday.remark;
            }
            if (IsPostBack)
            {
                string hname = Request.Form["holidayName"];
                string hdesc = Request.Form["description"];
                if (isAdd)
                {
                    bll.AddHolidaySet(hname, hdesc, LoginUserId);
                }
                else
                {
                    if (hdesc != description || hname != name)
                    {
                        bll.EditHolidaySet(id, hname, hdesc, LoginUserId);
                    }
                }
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}