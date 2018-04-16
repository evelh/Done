using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class Holiday : BasePage
    {
        protected bool isAdd = true;
        protected long id;
        protected string name;
        protected int type = 1;
        protected DateTime? date = null;
        private long holidaySetId;
        protected void Page_Load(object sender, EventArgs e)
        {
            var bll = new GeneralBLL();
            if (long.TryParse(Request.QueryString["id"], out id))
            {
                isAdd = false;
                var holiday = bll.GetHoliday(id);
                name = holiday.description;
                date = holiday.hd;
                type = holiday.hd_type;
            }
            if (!long.TryParse(Request.QueryString["hid"], out holidaySetId) && isAdd)    // 新增需要带入节假日id
            {
                Response.End();
                return;
            }
            if (IsPostBack)
            {
                name = Request.Form["holidayName"];
                string hdate = Request.Form["hd"];
                date = DateTime.Parse(hdate);
                type = int.Parse(Request.Form["type"]);
                if (isAdd)
                {
                    d_holiday hld = new d_holiday
                    {
                        description = name,
                        hd = date.Value,
                        hd_type = type,
                        holiday_set_id = (int)holidaySetId,
                    };
                    if (bll.AddHoliday(hld, LoginUserId))
                    {
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                        Response.End();
                    }
                    else
                    {
                        Response.Write("<script>alert('新增失败，日期重复!');</script>");
                    }
                }
                else
                {
                    if (bll.EditHoliday(id, name, date.Value, type, LoginUserId))
                    {
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                        Response.End();
                    }
                    else
                    {
                        Response.Write("<script>alert('新增失败，日期重复!');</script>");
                    }
                }
            }
        }
    }
}