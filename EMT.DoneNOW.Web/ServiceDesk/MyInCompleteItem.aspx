<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyInCompleteItem.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.MyInCompleteItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/Ticket.css" rel="stylesheet" />
    <title>我的未完成条目</title>
    <style>
        table{
            max-width:300px;
        }
        tr{
            height:25px;
        }
        .Section{
            width:350px;
        }
        .menu { position: absolute;z-index: 999;display: none;}
.menu ul{margin: 0 ;padding: 0;position: relative;width: 150px;border: 1px solid gray;background-color: #F5F5F5;padding: 10px 0;}
.menu ul li{padding-left: 20px;height: 25px;line-height: 25px;cursor:pointer;}
.menu ul li ul {display: none; position: absolute;right:-150px;top: -1px;background-color: #F5F5F5;min-height: 90%;}
.menu ul li ul li:hover{background: #e5e5e5;}
.menu ul li:hover{background: #e5e5e5;}
.menu ul li:hover ul {display: block;}
.menu ul li .menu-i1{width: 20px;height: 100%;display: block;float: left;}
.menu ul li .menu-i2{width: 20px;height: 100%;display: block;float: right;}
.menu ul .disabled{color: #AAAAAA;}

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">我的未完成条目</div>
        <div class="Normal Section" style="margin-left:20px;margin-top:20px;">
            <div class="Heading">
                <div class="Toggle Collapse Toggle1">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <div class="Left"><span class="Text">我的未完成服务预定</span></div>
                <div class="Middle"></div>
                <div class="Spacer"></div>
                <div class="Right"></div>
            </div>
            <div class="Content">
                <div class="EntityBodyEnhancedText">
                    <span class="Content">
                        <table class="Table table-hover" >
                            <%if (noComCall!=null&&noComCall.Count>0)
                                {
                                    foreach (var noComCall in noComCall)
                                    {%>
                            <tr data-val="<%=noComCall.id %>" class="CallTr" onclick="ChangeParentDate('<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(noComCall.start_time).ToString("yyyy-MM-dd") %>')">
                                <td><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(noComCall.start_time).ToString("yyyy-MM-dd") %></td>
                                <td>
                                    <%  var account= comBll.GetCompany(noComCall.account_id);%>
                                    <%=account==null?"":account.name %>
                                </td>
                            </tr> <%}
                                      }%>
                        </table>
                    </span>
                </div>
            </div>
        </div>
          <div class="Normal Section" style="margin-left:20px;">
            <div class="Heading">
                <div class="Toggle Collapse Toggle2">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <div class="Left"><span class="Text">我的未完成待办</span></div>
                <div class="Middle"></div>
                <div class="Spacer"></div>
                <div class="Right"></div>
            </div>
            <div class="Content">
                <div class="EntityBodyEnhancedText"><span class="Content">
                       <table class="Table table-hover" >
                            <%if (noComTodo!=null&&noComTodo.Count>0)
                                {
                                    foreach (var noComtodo in noComTodo)
                                    {%>
                            <tr data-val="<%=noComtodo.id %>" class="TodoTr" onclick="ChangeParentDate('<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(noComtodo.start_date).ToString("yyyy-MM-dd") %>')">
                                <td><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(noComtodo.start_date).ToString("yyyy-MM-dd") %></td>
                                <td>
                                    <%if (noComtodo.account_id != null)
                                        {var account = comBll.GetCompany((long)noComtodo.account_id); %>
                                    <%=account == null ? "" : account.name %>
                                    <%} %>
                                </td>
                            </tr> <%}
                                      }%>
                        </table>
                                                    </span></div>
            </div>
        </div>
    <div id="CallMenu" class="menu">
        <ul style="width: 220px;" id="menuUl">
            <li id="" class="" onclick="CallEdit()"><i class="menu-i1"></i>编辑服务预定</li>
            <li id="" class="" onclick="CallViewAccount()"><i class="menu-i1"></i>查看客户</li>
            <li id="" class="" onclick="CallAddItemNote()"><i class="menu-i1"></i>添加备注到服务预定上</li>
            <li id="" class="" onclick="CallModifyTicket()"><i class="menu-i1"></i>转发修改服务预定工单</li>
            <!--生成说明书todo -->
            <li id="" class="" onclick="CallDoneServiceCall()"><i class="menu-i1"></i>完成服务预定</li>
            <li id="" class="" onclick="CallCopyCall()"><i class="menu-i1"></i>复制服务预定</li>
            <li id="" class="" onclick="CallDeleteCall()"><i class="menu-i1"></i>删除服务预定</li>
        </ul>
    </div>
    <div id="TodoMenu" class="menu">
        <ul style="width: 220px;" id="menuUl">
            <li id="" class="" onclick="TodoEdit()"><i class="menu-i1"></i>编辑待办</li>
            <li id="" class="" onclick=""><i class="menu-i1"></i>查看待办</li>
            <li id="" class="" onclick="TodoViewCompany()"><i class="menu-i1"></i>查看客户</li>
            <li id="" class="" onclick="TodoFinish()"><i class="menu-i1"></i>完成待办</li>
            <li id="" class="" onclick="TodoDelete()"><i class="menu-i1"></i>删除待办</li>
        </ul>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("table").bind("contextmenu", function (e) { return false; })
    var entityid = "";
    var Times = 0;
    var oEvent;
    $(".CallTr").bind("contextmenu", function (event) {
        entityid = $(this).data("val");
        oEvent = event;
        clearInterval(Times);
        var menu = document.getElementById("CallMenu");
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 1000);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 1000);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
        } else {
            menu.style.top = Top + "px";
        }
    });
    // TodoTr
    $(".TodoTr").bind("contextmenu", function (event) {
        entityid = $(this).data("val");
        oEvent = event;
        clearInterval(Times);
        var menu = document.getElementById("TodoMenu");
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 1000);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 1000);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
        } else {
            menu.style.top = Top + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
    });
</script>
<script>
    var colors = ["#white", "white"];
    var color1 = 0; var color2 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color1 % 2]);
        color1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[color2 % 2]);
        color2++;
    });

    // 改变父页面的日期
    function ChangeParentDate(chooseDate) {
        var resource_id = window.opener.document.getElementById("resource_id").value;
        resource_id = '<%=LoginUserId.ToString() %>';
        var modeId = window.opener.document.getElementsByClassName("ShowdatsElm")[0].innerText;
        if (modeId == "1") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.ONE_DAY_VIEW %>';
        }
        else if (modeId == "5") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW %>';
        }
        else if (modeId == "7") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.FIVE_DAY_WORK_VIEW %>';
        }
        else if (modeId == "7+") {
            modeId = '<%=(int)EMT.DoneNOW.DTO.DicEnum.DISPATCHER_MODE.SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY %>';
        }
        if (modeId == "") {
            return;
        }
        var ckShowCancel = "";
        var aa  = window.opener.document.getElementById("ckShowCancel");
        if (aa.checked) {
            ckShowCancel = "1";
        } else {
            ckShowCancel = "0";
        }
        window.opener.location.href = "../ServiceDesk/DispatcherWorkshopView?resIds=" + resource_id + "&showCanCall=" + ckShowCancel + "&modeId=" + modeId + "&chooseDate=" + chooseDate + "&isSingResPage=1";
    }
</script>

<script>
    // 待办
    function TodoEdit() {
        window.open("../Activity/Todos.aspx?id=" + entityid, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    }
    function TodoViewCompany() {
        window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + entityid, '_blank', 'left=200,top=200,width=1200,height=1000', false);
    }
    function TodoFinish() {
        requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + entityid, null, function (data) {
            window.location.reload();
        })
    }
    function TodoDelete() {
        LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
            requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + entityid, null, function (data) {
                if (data == true) {
                    LayerAlert("删除成功", "确定", function () {
                        window.location.reload();
                    })
                }
                else {
                    LayerMsg("删除失败");
                }
            })
        }, function () { })
    }

    // 服务预定
    function CallEdit() {
        window.open("../ServiceDesk/ServiceCall?id=" + entityid, windowType.serviceCall + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
    }
    function CallViewAccount() {
        var accountId = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetCall&callId=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    accountId = data.account_id;
                }
            },
        });
        if (accountId != "" && accountId != null && accountId != undefined) {
            window.open("../Company/ViewCompany.aspx?id=" + accountId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
        }
    }
    function CallAddItemNote() {
        window.open("../Project/TaskNote?call_id=" + entityid, windowType.notes + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
    function CallModifyTicket() {
        var ids = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetCallTicketIds&callId=" + entityid,
            //dataType: "json",
            success: function (data) {
                if (data != "" && data != null && data != undefined) {
                    ids = data;
                }
            },
        });
        if (ids != "") {
            window.open("../ServiceDesk/TicketModify?ticketIds=" + ids, windowObj.masterTicket + windowType.manage, 'left=200,top=200,width=1280,height=800', false);
        }
        else {
            LayerMsg("为获取到相关工单信息");
        }
    }
    function CallDoneServiceCall() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=DoneCall&callId=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("完成成功！");
                }
                else {
                    LayerMsg("完成失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            },
        });
    }
    function CallCopyCall() {
        window.open("../ServiceDesk/ServiceCall?copy=1&id=" + entityid, windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
    function CallDeleteCall() {
        LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/TicketAjax.ashx?act=DeleteCall&callId=" + entityid,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("删除成功！");
                    }
                    else {
                        LayerMsg("删除失败！");
                    }
                    setTimeout(function () { history.go(0); }, 800);
                },
            });
        }, function () { })
       
    }

</script>
