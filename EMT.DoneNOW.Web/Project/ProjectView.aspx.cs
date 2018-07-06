using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;


namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectView : BasePage
    {
        protected pro_project thisProject = null;
        protected sys_bookmark thisBookMark;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    //  校验 是否有权限进行查看
                    if (AuthBLL.GetUserProjectAuth(LoginUserId, LoginUser.security_Level_id, thisProject.id).CanView == false)
                    {
                        Response.Write("<script>alert('无权查看');window.close();</script>");
                        Response.End();
                        return;
                    }
                    thisBookMark = new IndexBLL().GetSingBook(Request.Url.LocalPath + "?id=" + id, LoginUserId);


                    var thisAccount = new CompanyBLL().GetCompany(thisProject.account_id);
                    ShowTitle.Text = "项目-"+thisProject.no+thisProject.name+"("+ thisAccount.name + ")";
                    var type = Request.QueryString["type"];
                    switch (type)
                    {
                        case "Schedule":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id;
                            break;
                        case "ScheduleTemp":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id+ "&isTranTemp=1";
                            break;
                        case "Team":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_TEAM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_TEAM;
                            break;
                        case "Cost":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_COST_EXPENSE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_COST_EXPENSE+ "&isCheck=1";
                            break;// project_cost_expense
                        case "Note":
                            viewProjectIframe.Src = "ProjectNoteShow?project_id="+thisProject.id;
                            break;
                        case "Rate":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_RATE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_RATE;
                            break;
                        case "Calendar":
                            //viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_CALENDAR + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_CALENDAR; project_udf
                            viewProjectIframe.Src = "ProjectCalendarShow?project_id=" + thisProject.id;
                            break;
                        case "Attach":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_ATTACH + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_ATTACH;
                            break;
                        case "UDF":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_UDF + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_UDF;
                            break;
                        case "ticket":
                            viewProjectIframe.Src = "../Common/SearchFrameSet.aspx?cat=" + (int)DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE + "&type=" + (int)QueryType.MY_QUEUE_ACTIVE + "&group=215&param1=4890&param2=" + thisProject.id + "&param4=AddHidden";
                            break;
                        default:
                            viewProjectIframe.Src = "ProjectSummary?id=" + thisProject.id;
                            break;
                    }

                    #region 记录浏览历史
                    var history = new sys_windows_history()
                    {
                        title = $"项目：" + thisProject.name + " " +(thisAccount!=null? thisAccount.name:""),
                        url = Request.RawUrl,
                    };
                    new IndexBLL().BrowseHistory(history, LoginUserId);
                    #endregion
                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
    }
}