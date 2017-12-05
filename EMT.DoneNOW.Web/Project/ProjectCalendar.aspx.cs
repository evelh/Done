using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectCalendar : BasePage
    {
        protected pro_project thisProject = null;
        protected bool isAdd = true;
        protected pro_project_calendar thisCal = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    publish_type_id.DataTextField = "name";
                    publish_type_id.DataValueField = "id";
                    var pushList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.NOTE_PUBLISH_TYPE);
                    if (pushList != null && pushList.Count > 0)
                    {
                        pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.PROJECT_NOTE).ToString()).ToList();
                    }
                    publish_type_id.DataSource = pushList;
                    publish_type_id.DataBind();
                }

                var project_id = Request.QueryString["project_id"];
                if (!string.IsNullOrEmpty(project_id))
                {
                    thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                }
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisCal = new pro_project_calendar_dal().FindNoDeleteById(long.Parse(id));
                    if (thisCal != null)
                    {
                        isAdd = false;
                        if (!IsPostBack)
                        {
                            if (thisCal.publish_type_id != null)
                            {
                                publish_type_id.SelectedValue = thisCal.publish_type_id.ToString();
                            }
                            
                        }

                        thisProject = new pro_project_dal().FindNoDeleteById(thisCal.project_id);
                    }
                }


                if (thisProject == null)
                {
                    Response.End();
                }



            }
            catch (Exception msg)
            {
                Response.Write(msg);
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {

            var param = GetParam();
            if (param != null)
            {
                bool result = true;
                if (isAdd)
                {
                    result = new ProjectBLL().AddProCal(param, LoginUserId);
                }
                else
                {
                    result = new ProjectBLL().EditProCal(param, LoginUserId);
                }
                if (result)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close();self.opener.location.reload();</script>");
                }


            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失！');</script>");
            }
        }

        protected void save_new_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            if (param != null)
            {
                bool result = true;
                if (isAdd)
                {
                    result = new ProjectBLL().AddProCal(param, LoginUserId);
                }
                else
                {
                    result = new ProjectBLL().EditProCal(param, LoginUserId);
                }
                if (result)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');self.opener.location.reload();location.href='ProjectCalendar?project_id="+thisProject.id+"';</script>");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');self.opener.location.reload();location.href='ProjectCalendar?project_id=" + thisProject.id + "';</script>");
                }

            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('必填参数丢失！');</script>");
            }
        }
        /// <summary>
        /// 获取页面参数，必填项未填写时返回null
        /// </summary>
        protected pro_project_calendar GetParam()
        {
            var pageCal = AssembleModel<pro_project_calendar>();

            var date = Request.Form["EventDate"];
            var startTime = Request.Form["StartTime"];
            var endTime = Request.Form["EndTime"];// Title
            var title = Request.Form["name"];
            pageCal.project_id = thisProject.id;
            if (!string.IsNullOrEmpty(date) && !string.IsNullOrEmpty(startTime) && !string.IsNullOrEmpty(endTime) && !string.IsNullOrEmpty(title))
            {
                var starString = date + " " + startTime;
                var endString = date + " " + endTime;
                var startDate = DateTime.Parse(starString);
                var endDate = DateTime.Parse(endString);
                if (endDate < startDate)
                {
                    endDate = endDate.AddDays(1);
                }
                var startLong = Tools.Date.DateHelper.ToUniversalTimeStamp(startDate);
                var endLong = Tools.Date.DateHelper.ToUniversalTimeStamp(endDate);
                pageCal.start_time = startLong;
                pageCal.end_time = endLong;
            }
            else
            {
                return null;
            }

            if (isAdd)
            {
                return pageCal;
            }
            else
            {
                thisCal.name = pageCal.name;
                thisCal.description = pageCal.description;
                thisCal.start_time = pageCal.start_time;
                thisCal.end_time = pageCal.end_time;
                thisCal.publish_type_id = pageCal.publish_type_id;
                return thisCal;
            }
        }
    }
}