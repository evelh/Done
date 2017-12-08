<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskHistory.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskHistory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css" />
    <title>任务操作历史</title>
    <style>
        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="PageContentContainer">
            <div class="PageHeadingContainer">
                <div class="Active ThemePrimaryColor TitleBar EntityPage">
                    <div class="TitleBarItem Title"><span class="Text">任务历史</span><span class="SecondaryText">(<%=thisTask.no %> - <%=thisTask.title %>)</span></div>
                </div>
                <div class="contentboby">
                    <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;">
                    </div>
                    <div class="contenttitle clear" style="position: fixed; border-bottom: 1px solid #e8e8fa; left: 0; top: 0; background: #fff; width: 100%;">
                        <ul class="clear fl">

                            <li id="Print"><i style="background-image: url(../Images/print.png);"></i></li>


                        </ul>
                        <%if (queryResult != null && queryResult.count > 0)
                            { %>
                        <div class="page fl">
                            <%
                                int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                                int indexTo = queryResult.page_size * queryResult.page;
                                if (indexFrom > queryResult.count)
                                    indexFrom = queryResult.count;
                                if (indexTo > queryResult.count)
                                    indexTo = queryResult.count;
                            %>
                            <span>第<%=indexFrom %>-<%=indexTo %>&nbsp;&nbsp;总数&nbsp;<%=queryResult.count %></span>
                            <span>每页<%if (queryResult.page_size == 20)
                                        {
                            %>&nbsp;20&nbsp;<%}
                                                else
                                                {
                            %><a href="#" onclick="ChangePageSize(20)">20</a><%}
                            %>|<%if (queryResult.page_size == 50)
                                   {
                            %>&nbsp;50&nbsp;<%}
                                                else
                                                {
                            %><a href="#" onclick="ChangePageSize(50)">50</a><%}
                            %>|<%if (queryResult.page_size == 100)
                                   { %>&nbsp;100&nbsp;<%}
                                                  else
                                                  { %><a href="#" onclick="ChangePageSize(100)">100</a><%} %></span>
                            <i onclick="ChangePage(1)"><<</i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
                            <input type="text" style="width: 30px; text-align: center;" value="<%=queryResult.page %>" />
                            <span>&nbsp;/&nbsp;<%=queryResult.page_count %></span>
                            <i onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
                        </div>
                        <%} %>
                    </div>
                </div>
              
            </div>
            <div class="searchcontent" id="searchcontent" style="margin-top: 56px; min-width: <%=tableWidth%>px; overflow: hidden;">

                <table cellpadding="0">
                   <tr>
                        <%
                  
                    foreach (var para in resultPara)
                    {
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                        string orderby = null;
                        string order = null;
                        if (!string.IsNullOrEmpty(queryResult.order_by))
                        {
                            var strs = queryResult.order_by.Split(' ');
                            orderby = strs[0];
                            order = strs[1].ToLower();
                        }
                %>
                <th  width="<%=para.length * 32 %>px" ><%=para.name %></th>
                <%} %>
                   </tr>
                    <tbody>

                        <%               
                            if (queryResult != null && queryResult.count > 0)
                            {
                                var stDal = new EMT.DoneNOW.DAL.sdk_task_dal();
                                var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                                foreach (var rslt in queryResult.result)
                                {
                                    string id = "0";
                                    if (idPara != null)
                                    {
                                        id = rslt[idPara.name].ToString();
                                    }
                        %>
                        <tr data-val="<%=id %>" class="dn_tr">
                            
                            <%foreach (var para in resultPara)
                                {
                                    if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                        continue;
                                    string tooltip = null;
                                    if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                                        tooltip = para.name + "tooltip";
                            %>
                            <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC)
                                { %>
                            <td <%if (tooltip != null)
                                { %>title="<%=rslt[tooltip] %>"
                                <%} %> style="background: url(..<%=rslt[para.name] %>) no-repeat center;"></td>
                            <%}
                                else if (para.name == "详情")
                                {%>
                                  <td><%=stDal.GetContractSql(rslt[para.name].ToString()) %></td>
                                <%}
                                else
                                { %>
                            <td><%=rslt[para.name] %></td>
                            <%} %>
                            <%}
                            %>
                        </tr>
                        <%}
                            }
                        %>
                    </tbody>
                </table>

            </div>
        </div>
        <%--<input type="hidden" id="test"/>--%>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/Common/SearchBody.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    //$(function () {
    //    debugger;
    //    TTTT();

    //    function TTTT() {
    //        if ($("#test").val() != "1") {
    //            LayerConfirm("1", "1", "1", function () { $("#test").val("1"); TTTT(); }, function () { ""});
    //            return false;

    //        }
    //        alert("1");
    //    }

        
       
    //})
</script>
