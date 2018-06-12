<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSearchResult.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSearchResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchLi时间轴st.css" />
    <link href="../Content/Roles.css" rel="stylesheet" />
    <title></title>
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

        .RightClickMenu, .LeftClickMenu {
            padding: 16px;
            background-color: #FFF;
            border: solid 1px #CCC;
            cursor: pointer;
            z-index: 999;
            position: absolute;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
        }

        .RightClickMenuItem {
            min-height: 24px;
            min-width: 100px;
        }

        .RightClickMenuItemIcon {
            padding: 1px 5px 1px 5px;
            width: 16px;
        }

        .RightClickMenuItemTable tr:first-child td:last-child {
            white-space: nowrap;
        }

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }
        /*合同审批时，提交日期窗口*/
        .addText {
            width: 486px;
            height: 275px;
            margin-left: -247px;
            margin-top: -142px;
            z-index: 980;
            display: block;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: #b9b9b9;
            border: solid 4px #b9b9b9;
        }

            .addText > div {
                background-color: #fff;
                bottom: 0;
                left: 0;
                position: absolute;
                right: 0;
                top: 0;
            }

        .CancelDialogButton {
            background-image: url(../img/cancel1.png);
            background-position: 0 -32px;
            border: none;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
            z-index: 100;
            border-radius: 50%;
        }

        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 25;
            position: absolute;
            top: 0;
            left: 0;
            /*合同审批时，提交日期窗口（样式尾）*/
        }
        #Legend {
    vertical-align: middle;
    padding-right: 0px;
    padding-top: 0px;
    padding-bottom: 0px;
}
        .grid thead tr td {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
}
    </style>
</head>
<body style="overflow-x: auto; overflow-y: auto;">
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null)
                {%>value="<%=queryResult.page %>"
                <%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null)
                {%>value="<%=queryResult.page_size %>"
                <%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null)
                {%>value="<%=queryResult.query_id %>"
                <%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null)
                {%>value="<%=queryResult.order_by %>"
                <%} %> />
            <input type="hidden" id="cat" name="cat" value="<%=catId %>" />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <input type="hidden" name="id" value="<%=objId %>" />
            <input type="hidden" id="isCheck" name="isCheck" value="<%=isCheck %>" />
            <input type="hidden" id="account_ids" name="account_ids" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contentboby">
            <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;">
            </div>
            <div class="contenttitle clear" style="position: fixed; border-bottom: 1px solid #e8e8fa; left: 0; top: 0; background: #fff; width: 100%;">
                <ul class="clear fl">
                    <li id="AddProject"  class="f1"><i style="background-image: url(../Images/new.png);"></i><span style="margin-right: 5px; margin-left: 5px; ">新增</span><img src="../Images/dropdown.png" /></li>
                    <li id="coluSelect" onclick="javascript:window.open('../Common/ColumnSelector.aspx?type=<%=queryTypeId %>&group=<%=paraGroupId %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);"><i style="background-image: url(../Images/column-chooser.png);"></i></li>
                    <li id="Print"><i style="background-image: url(../Images/print.png);"></i></li>


                    <% if (queryResult != null && queryResult.count > 0)
                        { %>
                    <li id="ListView" onclick="Show()" style="display:none;"><i style=" background-image: url(../Images/list-view.png);"></i></li>

                    <li id="TimeLine" style="border: 0px solid #bcbcbc;background: linear-gradient(to bottom,#fff 0,#fbfbfb 100%);">时间轴:</li>
                    <li id="btnDay"><span style="margin-right: 5px; margin-left: 5px;">天</span></li>
                    <li id="btnWeek"><span style="margin-right: 5px; margin-left: 5px;">周</span></li>
                    <li id="btnMonth"><span style="margin-right: 5px; margin-left: 5px;">月</span></li>
                    <%} %>
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
        <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;" id="D1">
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemText" onclick="Add('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>','')">
                                <span class="lblNormalClass">项目新增</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemText" onclick="Add('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>','1')">
                                <span class="lblNormalClass">从模板导入</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemText" onclick="Add('<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.PROJECT_DAY %>','')">
                                <span class="lblNormalClass">项目提案新增</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </form>
    <%if (queryResult != null)
        { %>
     <div class="cover"></div>
    <div class="searchcontent" id="searchcontent" style="margin-top: 56px; min-width: <%=tableWidth%>px; overflow: hidden;">
        <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;">
            <tr>
                
                <%
                    string project_ids = "";
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
                <th title="点击按此列排序" width="<%=para.length * 32 %>px" onclick="ChangeOrder('<%=para.name %>')">
                    <%=para.name %>
                    <%if (orderby != null && para.name.Equals(orderby))
                        { %><img src="../Images/sort-<%=order %>.png" />
                    <%} %></th>
                <%} %>
            </tr>
            <%               
                if (queryResult.count > 0)
                {
                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                    foreach (var rslt in queryResult.result)
                    {
                        string id = "0";
                        if (idPara != null)
                        {
                            id = rslt[idPara.name].ToString();

                        }
            %>
     
            <%
                project_ids += id + ",";
            %>
            <tr onclick="View('<%=id %>')" title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">

                <%if (!string.IsNullOrEmpty(isCheck))
                    { %>
                <td style="width: 22px; max-width: 22px;">
                    <input type="checkbox" class="IsChecked" value="<%=id %>" /></td>

                <%} %>
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
        </table>
         <input type="hidden" name="project_ids" id="project_ids" value="<%=string.IsNullOrEmpty(project_ids)?"":project_ids.Substring(0,project_ids.Length-1) %>" />
    </div>
    <%
        if (queryResult.count == 0)
        {
    %>
    <div style="color: red; text-align: center; padding: 10px 0; font-size: 14px; font-weight: bold;">选定的条件未查找到结果</div>
    <%}%>
    <%} %>

    <div id="menu">
        <%if (contextMenu.Count > 0)
            { %>
        <ul style="width: 220px;">
            <%foreach (var menu in contextMenu)
                { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null)
                    { %>
                <i class="menu-i2">>></i>
                <ul id="menu-i2-right">
                    <%foreach (var submenu in menu.submenu)
                        { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
                </ul>
                <%} %>
            </li>
            <%} %>
        </ul>
        <%} %>
    </div>

    <iframe id="tableLeft" style="float:left;width:50%;height:300px;margin-top:50px; display:none"  onload="this.height=this.contentWindow.document.documentElement.scrollHeight">
        <script type="text/javascript">     
            //动态获取被引用的页面的高度     
            function reinitIframe1() {
                var iframe = document.getElementById("tableLeft");
                 var bHeight = iframe.contentWindow.document.body.scrollHeight;
                 var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
                 var height = Math.max(bHeight, dHeight);
                 iframe.height = height;
            }
            window.setInterval("reinitIframe1()", 200);
            </script>  
    </iframe>
     <iframe id="imgRight" style="float:left;width:50%;height:300px;margin-top:50px;display:none" onload="this.height=this.contentWindow.document.documentElement.scrollHeight" >
         <script type="text/javascript">     
             //动态获取被引用的页面的高度     
             function reinitIframe2() {
                 var iframe = document.getElementById("imgRight");
                 
                     var bHeight = iframe.contentWindow.document.body.scrollHeight;
                     var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
                     var height = Math.max(bHeight, dHeight);
                     iframe.height = height;
                 
             }
             window.setInterval("reinitIframe2()", 200);
                    </script>      
    </iframe>
  <div class="grid" style="display:none;font-size:12px;background-color:rgb(255,255,255);">
		<table style="width: 100%;height:40px;border-bottom-color:#98b4ca;border-collapse: collapse;border-bottom-width: 1px;border-bottom-style: solid;border-spacing: 0px;" cellspacing="0" cellpadding="0" class="TimelineLegend" >
			<thead>
				<tr align="center">
					<td></td>
					<td width="15%"  class="ClientLegend" id="Legend" style="text-align:right;"><span style="text-align:right;background-color: rgb(52, 106, 149);border-width: 1px;border-style: solid;border-color: rgb(0, 69, 124);border-image: initial;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>
					<td width="15%"  class="TimelineFooter" id="LegendText"><div style="text-align:left;">客户项目</div></td>
					<td width="15%" class="InternalLegend"  id="Legend" style="text-align:right;"><span style="  text-align:right; background-color: rgb(150, 184, 222);border-width: 1px;border-style: solid;border-color: rgb(81, 138, 201);border-image: initial;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>
					<td width="15%"  class="TimelineFooter" id="LegendText"><div style="text-align:left;">内部项目</div></td>
					<td width="15%" class="ProposalLegend"  id="Legend" style="text-align:right;"><span style=" text-align:right;   background-color: rgb(230, 217, 196);border-width: 1px;border-style: solid;border-color: rgb(213, 197, 173);border-image: initial;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>
					<td width="15%" class="TimelineFooter" id="LegendText"><div style="text-align:left;">项目提案</div></td>
				</tr>
			</thead>
		</table>
	</div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/Common/SearchBody.js"></script>
<script src="../Scripts/common.js"></script>
<script>
             $(".f1").on("mouseover", function () {
                 $(this).css("background", "white");
                 $(this).css("border-bottom", "none");
                 $("#D1").show();
             });
             $(".f1").on("mouseout", function () {
                 $("#D1").hide();
                 $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(this).css("border-bottom", "1px solid #BCBCBC");
             });
             $("#D1").on("mouseover", function () {
                 $(this).show();
                 $(".f1").css("background", "white");
                 $(".f1").css("border-bottom", "none");
             });
             $("#D1").on("mouseout", function () {
                 $(this).hide();
                 $(".f1").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(".f1").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(".f1").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(".f1").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
                 $(".f1").css("border-bottom", "1px solid #BCBCBC");
             });
             $(".lblNormalClass").on("mouseover", function () {
                 $(this).parent().css("background", "#E9F0F8");
             });
             $(".lblNormalClass").on("mouseout", function () {
                 $(this).parent().css("background", "#FFF");
             });
</script>
<script>
    $(function () {

    })

    $("#btnDay").click(function () {
        var project_ids = $("#project_ids").val();
        if (project_ids != "") {
            Hiden('day');
        }
        
    })
    $("#btnWeek").click(function () {
        Hiden('week');
    })
    $("#btnMonth").click(function () {
        Hiden('month');
    })

    //$("#AddProject").mouseover(function () {
    //    $(".RightClickMenu").show();
    //})
    //$("#AddProject").mouseout(function () {
    //    setTimeout(function () { $(".RightClickMenu").hide(); }, 1000);
    //})
    //$(".RightClickMenu").mouseover(function () {
    //    $(".RightClickMenu").show();
    //})
    //$(".RightClickMenu").mouseout(function () {
    //    setTimeout(function () { $(".RightClickMenu").hide(); }, 1000);
    //})

    // 添加的类型，是否从模板新增
    function Add(type_id, isFromTemp) {
        if (isFromTemp == undefined || isFromTemp == null)
            isFromTemp = "";
        window.open('ProjectAddOrEdit?type_id=' + type_id + "&isFromTemp=" + isFromTemp, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_ADD %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
    /// 隐藏查询结果，展示iframe内容
    function Hiden(dateType) {
        var project_ids = $("#project_ids").val();
        $("#searchcontent").hide();
        $("#tableLeft").css("display", "");
        $("#imgRight").css("display", "");
        $(".grid").css("display","");
        $("#tableLeft").attr("src", "ProjectSearchTable?ids=" + project_ids);
        $("#imgRight").attr("src", "ProjectSearchImg?ids=" + project_ids + "&dateType=" + dateType);

        $("#AddProject").css("display", "none");
        $("#coluSelect").css("display", "none");
        $("#Print").css("display", "none");
        $("#ListView").css("display", "");// TimeLine
        $("#TimeLine").css("display", "none");
    }

    function Show() {
        $("#AddProject").css("display", "");
        $("#coluSelect").css("display", "");
        $("#Print").css("display", "");
        $("#ListView").css("display", "none");
        $("#searchcontent").show();
        $("#tableLeft").css("display", "none");
        $("#imgRight").css("display", "none");
        $(".grid").css("display", "none");
        $("#tableLeft").attr("src", "");
        $("#imgRight").attr("src", "");
        $("#TimeLine").css("display", "");
    }

    function Edit() {
        // entityid
        window.open("ProjectAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_EDIT %>', 'left=200,top=200,width=900,height=800', false);
    }
    function View(id) {
        window.open("ProjectView.aspx?id=" + id, '_blank', 'left=200,top=200,width=900,height=800', false);
    }
    function ShowProject() {
        window.open("ProjectView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=900,height=800', false);
    }

    function NewProNote() {
        window.open("../Project/TaskNote.aspx?project_id=" + entityid, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    }

    function NewProCalendar() {
        window.open("../Project/ProjectCalendar.aspx?project_id=" + entityid, windowObj.projectCalendar + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    }
    function Delete() {
        if (confirm("确认删除该项目，删除不可恢复")) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=DeletePro&project_id=" + entityid,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("删除项目成功！");
                            history.go(0);
                        } else if (!data.result) {
                            LayerMsg("该项目模板不能被删除，因为有一个或多个时间条目，费用，费用，服务预定，备注，附件，里程碑！");
                        }
                    }
                },
            });
        }
      
    }
    function Preference() {
        window.open("../Project/ProjectFinancials.aspx?id=" + entityid,'_blank', 'left=200,top=200,width=1080,height=800', false);
    }
</script>
