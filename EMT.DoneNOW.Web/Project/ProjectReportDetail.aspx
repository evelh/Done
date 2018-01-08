<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectReportDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectReportDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title>上海声联</title>
    <style>
        TABLE#tblReport > tbody > tr > td, TABLE#tblReport > thead > tr > td, .tblReport > tbody > tr > td {
            border-width: 1px;
            border-style: solid;
            border-color: #BBB;
        }

        tr {
            display: table-row;
            vertical-align: inherit;
            border-color: inherit;
        }

        #txtBlack8, .txtBlack8 {
            color: #444;
            FONT-SIZE: 11px;
            font-weight: normal;
        }
          #tblOutlineBox {
            background-color: #fff;
            padding: 5px;
            color: menutext;
            border-width: 1px;
            border-style: solid;
            border-color: #BBB #BBBBBB #BBB #BBBBBB;
            font-size: 8pt;
            font-weight: bold;
            margin-top: 0;
            margin-bottom: 0;
        }

        #txtTableHeadNew, #headerRowText {
            color: #000;
            FONT-SIZE: 11px;
            font-weight: bold;
            background: #E6E6E6;
            background: -moz-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
            background: -webkit-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
            background: -ms-linear-gradient(top,#E6E6E6 0,#D6D6D6 100%);
            background: linear-gradient(to bottom,#E6E6E6 0,#D6D6D6 100%);
            vertical-align: top;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <span id="printSpan" style="visibility: visible;">
            <div class="ButtonBar" style="padding-top: 10px">
                <ul>
                    <li>
                        <a class="OnlyImageButton" id="HREF_btnPrint" name="HREF_btnPrint" onclick="ThisPrint()">
                            <img title="Print"  name="IMG_btnPrint" src="../Images/print.png" border="0"></a><span style="margin-left: 3px; margin-right: 3px;"></span></li>
                </ul>
            </div>
        </span>
        <table width="98%" cellspacing="0" cellpadding="0" border="0" id="tblOutlineBox">
            <tbody>
                <tr>
                    <td id="titleText" valign="top" style="text-align: left">项目截止日期报表
			<div id="subTitleText"><%=user==null?"":user.name %></div>
                    </td>
                    <td id="subTitleText" align="right" valign="top"><%=DateTime.Now.ToString("yyyy-MM-dd") %>
                        <br>
                        <%=DateTime.Now.ToShortTimeString().ToString() %> &nbsp;&nbsp;&nbsp;  <%=DateTime.Now.Hour<12?"上午":"下午" %><br>
                    </td>
                </tr>
                <tr>
                    <%  TimeSpan ts1 = new TimeSpan(((DateTime)thisProject.end_date).Ticks);
                        TimeSpan ts2 = new TimeSpan(DateTime.Now.Ticks);
                        TimeSpan ts = ts1.Subtract(ts2).Duration(); %>
                    <td><%=thisProject.name %>:距离项目结束还有<%=ts.Days %>天</td>
                    <td></td>
                </tr>
            </tbody>
        </table>

        <table width="98%" border="1" cellspacing="0" cellpadding="3" style="border-collapse: collapse; margin-top: 20px;" id="tblReport">
            <tbody>
                <% for (int i = 0; i < 7; i++)
                    {
                %>
                <tr>
                    <td colspan="6" id="txtTableHeadNew" style="text-align: left">结束日期 <%=chooseDate.AddDays(i).ToString("yyyy-MM-dd") %></td>
                </tr>
                <%
                    if ((taskList != null && taskList.Count > 0) || (proCalList != null && proCalList.Count > 0))
                    {
                        var dgDal = new EMT.DoneNOW.DAL.d_general_dal();
                        var dgtDal = new EMT.DoneNOW.DAL.d_general_table_dal();
                        var statusList = dgDal.GetDictionary(dgtDal.GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.TICKET_STATUS));
                        bool isHasData = false;
                        if (taskList != null && taskList.Count > 0)
                        {
                            var thisTaskList = taskList.Where(_ => EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)_.estimated_end_time).ToString("yyyy-MM-dd") == chooseDate.AddDays(i).ToString("yyyy-MM-dd")).ToList();
                            if (thisTaskList != null && thisTaskList.Count > 0)
                            {
                                isHasData = true;
                                foreach (var thisTask in thisTaskList)
                                {
                                    string imgSrc = "../Images/";
                                    string type = "";
                                    switch (thisTask.type_id)
                                    {
                                        case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE:
                                            imgSrc += "phase.png";
                                            type = "阶段";
                                            break;
                                        case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK:
                                            imgSrc += "task.png";
                                            type = "任务";
                                            break;
                                        case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE:
                                           // imgSrc = "";// ISSUE
                                            imgSrc += "task.png";
                                            // type = "问题";
                                            break;
                                        default:
                                            break;
                                    }
                %>
                <tr>
                    <td id="txtBlack8" style="text-algin: left; padding-left: 10px; border-top: none; border-bottom: none; border-right: none" width="1%" align="right"></td>
                    <td id="txtBlack8" width="1%" style="text-algin: left; border: none">
                        <img src="<%=imgSrc %>" border="0" alt="Phase" align="absmiddle"></td>
                    <td id="txtBlack8" style="text-algin: left; border: none"><%=type %></td>
                    <td id="txtBlack8" style="text-algin: left; border: none"><%=thisTask.title %></td>
                    <td id="txtBlack8" style="text-algin: left; border: none"></td>
                    <td id="txtBlack8" style="text-algin: left; border-top: none; border-bottom: none; border-left: none; padding-right: 5px;" align="right"><%=statusList.FirstOrDefault(_=>_.val==thisTask.status_id.ToString()).show %></td>
                </tr>
                <tr>
                    <td style="border-top: none; border-right: none; border-bottom: none;">&nbsp;</td>
                    <td id="txtBlack8" colspan="5" class="description" style="text-algin: left; padding-right: 30px; border-top: none; border-bottom: none; border-left: none"><%=thisTask.description %></td>
                </tr>
                <%if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
                    { %>
                <tr style="height: 5px">
                    <td id="txtBlack8" colspan="6" style="padding: 0px; border-top: none;"></td>
                </tr>
                <%}
                            }
                        }
                    }

                    if ((proCalList != null && proCalList.Count > 0))
                    {
                        var thisProCalList = proCalList.Where(_ => EMT.Tools.Date.DateHelper.ConvertStringToDateTime(_.end_time).ToString("yyyy-MM-dd") == chooseDate.AddDays(i).ToString("yyyy-MM-dd")).ToList();
                        if (thisProCalList != null && thisProCalList.Count > 0)
                        {
                            isHasData = true;
                            foreach (var thisProCal in thisProCalList)
                            {
                                string type = "日历条目";
                                var thisUser = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(thisProCal.create_user_id);
                %>
                <tr>
                    <td id="txtBlack8" style="text-algin: left; padding-left: 10px; border-top: none; border-bottom: none; border-right: none" width="1%" align="right"></td>
                    <td id="txtBlack8" width="1%" style="text-algin: left; border: none"></td>
                    <td id="txtBlack8" style="text-algin: left; border: none"><%=type %></td>
                    <td id="txtBlack8" style="text-algin: left; border: none">
                        <%=thisProCal.name %>
                    </td>
                    <td id="txtBlack8" style="text-algin: left; border: none"><%=thisUser==null?"":thisUser.name %></td>
                    <td id="txtBlack8" style="text-algin: left; border-top: none; border-bottom: none; border-left: none; padding-right: 5px;" align="right"></td>
                </tr>
                <tr>
                    <td style="border-top: none; border-right: none; border-bottom: none;">&nbsp;</td>
                    <td id="txtBlack8" colspan="5" class="description" style="text-algin: left; padding-right: 30px; border-top: none; border-bottom: none; border-left: none"><%=thisProCal.description %></td>
                </tr>
                <%}
                        }
                    }
                    if (!isHasData)
                    { %>

                <tr>
                    <td colspan="6" id="txtBlack8" height="30" valign="middle" style="border-top: none; border-bottom: none;">没有任何任务/日历条目在这一天结束</td>

                </tr>
                <%

                        }

                    }
                    else
                    {
                %>

                <tr>
                    <td colspan="6" id="txtBlack8" height="30" valign="middle" style="border-top: none; border-bottom: none;">没有任何任务/日历条目在这一天结束</td>

                </tr>
                <%
                        }

                        if (!isSeven)
                        {
                            break;
                        }
                    } %>
            </tbody>
        </table>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    <%if (isShowDetai)
    { %>
    $(".description").css("display","");
    <%}
    else
    { %>
    $(".description").css("display", "none");
    <% }%>

    function ThisPrint() {

        $("#printSpan").css("display", "none");
        $("#tblOutlineBox").css("margin-top","50px");
     
        window.print();
        $("#tblOutlineBox").css("margin-top", "");
        $("#printSpan").css("display", "");
    }
</script>