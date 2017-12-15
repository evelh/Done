<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSearchTable.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSearchTable" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/Roles.css" rel="stylesheet" />
    <title></title>
    <style>
        td {
            height: 30px;
            padding:0px;
      
        }

        th {
            height: 62px;
        }
        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
    border-color: #98b4ca;
    background-color: #cbd9e4;
    color: #64727a;
    border-width: 1px;
    border-style: solid;
        border-width: 0px;
}
        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
    font-size: 13px;
    font-weight: bold;
    height: 19px;
    padding: 0px;
    vertical-align: top;
    word-wrap: break-word;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="height:62px;">
            <table style="width:100%;height:62px;">
                <tr class="dataGridHeader">
                    <th style="min-width: 20px;"></th>
                    <th style="min-width: 150px;">标题</th>
                    <th style="min-width: 120px;">客户</th>
                    <th style="min-width: 100px;">持续时间</th>
                    <th style="min-width: 150px;">开始时间</th>
                    <th style="min-width: 150px;">结束时间</th>
                    <th style="min-width: 100px;">Est.Time</th>
                    <th style="min-width: 100px;">Actual Time</th>
                </tr>
            </table>
        </div>
        <div style="left: 0; overflow-x: scroll; overflow-y: auto;right: 0; bottom: 0; top: 0px;min-height: 225px;height: 225px;">
            <% if (proList != null && proList.Count > 0)
                {
            %>
            <table>
                <tbody>
                    <%foreach (var pro in proList)
                        {%>
                    <tr class="dataGridBody">
                        <td style="min-width: 20px;padding:0px;border-width: 0px;"><%=proList.IndexOf(pro)+1 %></td>
                        <td style="min-width: 150px;padding:0px;border-width: 0px;height: 30px;"><a><%=pro.name %></a></td>
                        <% var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(pro.account_id); %>
                        <td style="min-width: 120px;padding:0px;border-width: 0px;"><%=account==null?"":account.name %></td>
                        <td style="min-width: 100px;padding:0px;border-width: 0px;"><%=pro.duration %> 天</td>
                        <td style="min-width: 150px;padding:0px;border-width: 0px;"><%=((DateTime)pro.start_date).ToString("yyyy-MM-dd") %></td>
                        <td style="min-width: 150px;padding:0px;border-width: 0px;"><%=((DateTime)pro.end_date).ToString("yyyy-MM-dd") %></td>
                        <td style="min-width: 100px;padding:0px;border-width: 0px;"><%=pro.est_project_time==null?"":(((decimal)pro.est_project_time).ToString("#0.00")+"小时") %></td>
                        <% 
                            decimal acTime = 0;
                            var taskList = new EMT.DoneNOW.DAL.sdk_task_dal().GetProTask(pro.id);
                            if (taskList != null && taskList.Count > 0)
                            {
                                var sweDal = new EMT.DoneNOW.DAL.sdk_work_entry_dal();
                                taskList.ForEach(_ =>
                                {
                                    var taskEntry = sweDal.GetByTaskId(_.id);
                                    if (taskEntry != null && taskEntry.Count > 0)
                                    {
                                        acTime += taskEntry.Sum(te => te.hours_worked == null ? 0 : (decimal)te.hours_worked);
                                    }
                                });
                            }
                        %>

                        <td style="min-width: 100px;"> <%=acTime==0?"":acTime.ToString("#0.00") %></td>
                    </tr>
                    <%} %>
                </tbody>
            </table>
            <%} %>
        </div>
    </form>
</body>
</html>
