<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSearchTable.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSearchTable" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/Roles.css" rel="stylesheet" />
    <title></title>
    <style>
       td{
           height:30px;
       }
       th{
           height:62px;
       }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="left: 0;overflow-x: scroll;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:0px;">
        <% if (proList != null&&proList.Count>0)
            {
                %>
            <table>
                <tr>

                </tr>
            </table>
              <div class="Gantt_divTable" id="Gantt_dateContainer">
        
      </div>
      <div class="Gantt_divTable" id="Gantt_gridBodyContainer" onscroll="Gantt_dateContainer.scrollLeft = this.scrollLeft;">
         
      </div>

        <table >
            <tbody>
            <tr class="dataGridHeader">
                <th style="width:100px;"></th>
                <th style="width:100px;">标题</th>
                <th style="width:120px;">客户</th>
                <th style="width:100px;">持续时间</th>
                <th style="width:150px;">开始时间</th>
                <th style="width:150px;">结束时间</th>
                <th style="width:100px;">Est.Time</th>
                <th style="width:100px;">Actual Time</th>
            </tr>
               
            <%foreach (var pro in proList)
            {%>
            <tr class="dataGridBody">
                <td><%=proList.IndexOf(pro)+1 %></td>
                <td><a><%=pro.name %></a></td>
                <% var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(pro.account_id); %>
                <td><%=account==null?"":account.name %></td>
                <td><%=pro.duration %> 天</td>
                <td><%=((DateTime)pro.start_date).ToString("yyyy-MM-dd") %></td>
                <td><%=((DateTime)pro.end_date).ToString("yyyy-MM-dd") %></td>
                <td><%=pro.est_project_time==null?"":(((decimal)pro.est_project_time).ToString("#0.00")+"小时") %></td>
                <% 
                    decimal acTime = 0;
                    var taskList = new EMT.DoneNOW.DAL.sdk_task_dal().GetProTask(pro.id);
                    if (taskList != null && taskList.Count > 0)
                    {
                        var sweDal = new EMT.DoneNOW.DAL.sdk_work_entry_dal();
                        taskList.ForEach(_=> {
                            var taskEntry = sweDal.GetByTaskId(_.id);
                            if (taskEntry != null&&taskEntry.Count!=null)
                            {
                                acTime += taskEntry.Sum(te=>te.hours_worked==null?0:(decimal)te.hours_worked);
                            }
                        });
                    }
                    %>

                <td><%=acTime==0?"":acTime.ToString("#0.00") %></td>
            </tr>
            <%} %>
                 </tbody>
        </table>
        <%} %>
      
        </div>
    </form>
</body>
</html>
