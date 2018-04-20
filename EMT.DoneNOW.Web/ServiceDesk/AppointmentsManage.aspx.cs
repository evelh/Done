using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class AppointmentsManage : BasePage
    {
        protected bool isAdd = true;
        protected sdk_appointment appo = null;
        protected List<sys_resource> resList = new DAL.sys_resource_dal().GetSourceList();
        protected DateTime chooseDate = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var appId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(appId))
                    appo = new DAL.sdk_appointment_dal().FindNoDeleteById(long.Parse(appId));
                if (appo != null)
                {
                    isAdd = false;
                    var thisRes = new sys_resource_dal().FindNoDeleteById(appo.resource_id);
                    var history = new sys_windows_history()
                    {
                        title = "编辑约会:" + appo.name + (thisRes==null?"":$"({thisRes.name})"),
                        url = Request.RawUrl,
                    };
                    new IndexBLL().BrowseHistory(history, LoginUserId);
                }
                var chooseDateString = Request.QueryString["chooseDate"];
                if (!string.IsNullOrEmpty(chooseDateString))
                    chooseDate = DateTime.Parse(chooseDateString);
            }
            catch (Exception msg)
            {
                Response.Write("<script>alert('" + msg.Message + "');window.close();</script>");
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = Getparam();
            if (param == null)
                return;
            var result = false;
            if (isAdd)
                result = new DispatchBLL().AddAppointment(param,LoginUserId);
            else
                result = new DispatchBLL().EditAppointment(param, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');window.close();</script>");
        }

        protected void save_add_Click(object sender, EventArgs e)
        {
            var param = Getparam();
            if (param == null)
                return;
            var result = false;
            if (isAdd)
                result = new DispatchBLL().AddAppointment(param, LoginUserId);
            else
                result = new DispatchBLL().EditAppointment(param, LoginUserId);
            ClientScript.RegisterStartupScript(this.GetType(), "刷新父页面", $"<script>self.opener.location.reload();</script>");
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}！');location.href='AppointmentsManage';</script>");
        }

        protected sdk_appointment Getparam()
        {
            var pageSpp = AssembleModel<sdk_appointment>();
            var start_time = Request.Form["startTime"];
            var end_time = Request.Form["endTime"];
            if (string.IsNullOrEmpty(end_time) || string.IsNullOrEmpty(start_time))
                return null;
            pageSpp.start_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(start_time));
            pageSpp.end_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(end_time));
            if (isAdd)
                return pageSpp;
            else
            {
                appo.resource_id = pageSpp.resource_id;
                appo.name = pageSpp.name;
                appo.start_time = pageSpp.start_time;
                appo.end_time = pageSpp.end_time;
                appo.description = pageSpp.description;
                return appo;
            }

            
        }

    }
}