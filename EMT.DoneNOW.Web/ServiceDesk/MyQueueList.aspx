<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyQueueList.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.MyQueueList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/MyQueue.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/repository.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <title></title>
    <style>
       
        /*黑色幕布*/
        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 99;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }
        /*弹框*/
        .Dialog.Large {
            width: 876px;
            height: 450px;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: white;
            border: solid 4px #b9b9b9;
            display: none;
        }

        .CancelDialogButton {
            background-image: url(../Images/cancel1.png);
            background-position: 0 -32px;
            border-radius: 50%;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
            z-index: 1;
        }

        .heard-title {
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            text-align: left;
            width: 97%;
            background-color: #346a95;
            color: #fff;
            position: relative;
            padding-left: 10px;
            padding-top: 5px;
        }

        #MoreBookDiv input[type=checkbox] {
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="LeftDiv">
            <div class="header">我的工作区和队列</div>
            <div class="header-title">
                <ul>
                    <li id="RefreshLi" onclick="RefreshPage()"><img  src="../Images/refresh.png"/></li>
                </ul>
            </div>
            <div class="DivScrollingContainer" style="top: 75px">
                <div id="serviceDeskSideBar">
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">我的工作区</div>
                    </div>
                    <div id="DIVMyWorkspace" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <li class="MenuLink Select" data-val="open"  onclick="SearchTicket('open')"><a>活动工单<%=dic["open"] %></a></li>
                            <li class="MenuLink" data-val="over"  onclick="SearchTicket('over')"><a>过期工单<%=dic["over"] %></a></li>
                            <li class="MenuLink" data-val="my"  onclick="SearchTicket('my')"><a>我创建的的工单<%=dic["my"] %></a></li>
                            <li class="MenuLink" data-val="complete"  onclick="SearchTicket('complete')"><a>完成工单<%=dic["complete"] %></a></li>
                            <li class="MenuLink" data-val="change"  onclick="SearchTicket('change')"><a>变更申请单<%=dic["change"] %></a></li>
                            <li class="MenuLink" data-val="call"  onclick="SearchTicket('call')"><a >服务预定</a></li>
                        </ul>
                    </div>
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">队列-所有工单</div>
                    </div>
                    <div id="DIVQueues" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <asp:Literal ID="liAllTicket" runat="server"></asp:Literal>
                        </ul>
                    </div>
                    <div class="relatedheard">
                        <div class="toogle">-</div>
                        <div class="title">队列-未分配工单</div>
                    </div>
                    <div id="DIVUnassignedTickets" style="position: relative; display: block; visibility: visible; top: 0px; left: 0px;margin-left:25px;">
                        <ul class="ButtonBarVert">
                            <asp:Literal ID="liNoResTicket" runat="server"></asp:Literal>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="RightDiv">
            <iframe style="left: 0; overflow-x: auto; overflow-y: hidden; right: 0; bottom: 0; height: auto;width:100%;height:100%;" id="ifSearchTicket" name="ifSearchTicket">

            </iframe>
        </div>
           <div id="BackgroundOverLay"></div>
          <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; display: none; width: 650px;" id="ShowAddOtherDiv">
            <div>

                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="CloseDigAddOtherDiv()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text" style="color: white;font-size: medium;font-weight: 500;margin-left: 10px;">添加到员工的工作列表-</span><span id="ToOtherTaskNo"></span>
                        </div>
                    </div>
                    <div class="DialogHeadingContainer">
                        <div class="ButtonContainer"><a class="Button ButtonIcon Save NormalState" onclick="SaveAddToOtherWorkList()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -38px 0px;"></span><span class="Text">保存并关闭</span></a><a class="Button ButtonIcon Cancel NormalState" id="CancelButton" onclick="CloseDigAddOtherDiv()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -102px 0px;"></span><span class="Text">取消</span></a></div>
                    </div>
                    <div class="ScrollingContentContainer" style="position:unset;">
                        <div class="ScrollingContainer" style="position:unset;">
                                <div class="Medium NoHeading Section">
                                    <div class="Content">
                                        <div class="Normal Column">
                                            <div class="Instructions">
                                                <div class="InstructionItem">你想将这个任务添加到谁的工作列表中?</div>
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>员工</label><span class="Required" style="color:red;">*</span></div>
                                            </div>
                                            <div class="Editor DataSelector">
                                                <div class="InputField">
                                                    <input id="" type="text" value="" style="width:200px;padding:0px;"/>
                                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" ><span class="Icon" onclick="ChooseOtherRes()"  style="background-image:url(../Images/data-selector.png);width: 16px;height: 16px;"></span><span class="Text"></span></a>
                                                    <input id="ToOtherResIds" name="" type="hidden" value="" />
                                                    <input id="ToOtherResIdsHidden" name="" type="hidden" value="" />
                                                    <div class="ContextOverlayContainer">
                                                        <div class="AutoComplete ContextOverlay">
                                                            <div class="Active LoadingIndicator"></div>
                                                            <div class="Content"></div>
                                                        </div>
                                                        <div class="AutoComplete ContextOverlay">
                                                            <div class="Active LoadingIndicator"></div>
                                                            <div class="Content"></div>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <select id="ResManySelect" multiple="multiple" style="width:200px;height:100px;"></select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        <%var type = Request.QueryString["type"];
    if (!string.IsNullOrEmpty(type))
    {%>
        $(".MenuLink").each(function () {
            var thisVal = $(this).data("val");
            if (thisVal == '<%=type %>') {
                $(this).trigger("click");
                return false;
            }
        })
    <%}
    else
    {%>
        $(".MenuLink").eq(0).trigger("click");
    <%}
    %>
    })
    function RefreshPage() {
        var firstChoose = $(".MenuLink.Select").eq(0).data("val");
        if (firstChoose != "" && firstChoose != null && firstChoose != undefined) {
            location.href = "MyQueueList?type=" + firstChoose;
        }
        else {
            location.href = "MyQueueList";
        }
    }

    $(".toogle").click(function () {
        $(this).parent().next().toggle();
        if ($(this).html() == '+') {
            $(this).html('-')
        }
        else {
            $(this).html('+')
        }
    })
    $(".MenuLink").click(function () {
        $(".MenuLink").removeClass("Select");
        if (!$(this).hasClass("Select")) {
            $(this).addClass("Select");
        }
    })

    function SearchTicket(searchType) {
        if (searchType == "open") {// MY_QUEUE_ACTIVE
            $("#ifSearchTicket").attr("src","../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=215&isCheck=1");
        }
        else if (searchType == "over"){
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=2&isCheck=1");
        }
        else if (searchType == "my") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_MY_TICKET %>&isCheck=1");
        }
        else if (searchType == "complete") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=3&isCheck=1&");
        }
        else if (searchType == "change") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_CHANGE_APPROVEL %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_CHANGE_APPROVEL %>");
        }
        else if (searchType == "call") {
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SERVICE_CALL_SEARCH %>");
        }
        else if (searchType.indexOf("dep_") != -1) {
            var depArr = searchType.split('_');
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_VIEW %>&param1=2669&param2=" + depArr[1] +"&isCheck=1&param3=2670&param4=2");
        }
        else if (searchType.indexOf("noRes_") != -1) {
            var depArr = searchType.split('_');
            $("#ifSearchTicket").attr("src", "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_VIEW %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_VIEW %>&param1=2669&param2=" + depArr[1] +"&isCheck=1&param3=2670&param4=0");
        }
    } 

    function SaveAddToOtherWorkList() {
        var resIds = $("#ToOtherResIdsHidden").val();
        var entityid = window.frames["ifSearchTicket"].frames["SearchBody"].entityid;
        if (resIds != "" && entityid != "") {
            window.frames["ifSearchTicket"].frames["SearchBody"].AddToWorkList(resIds, entityid);
        }
        CloseDigAddOtherDiv();
    }

    function CloseDigAddOtherDiv() {
        $('#BackgroundOverLay').hide();
        $('#ShowAddOtherDiv').hide();
    }

    function ChooseOtherRes() {
        window.open("../Common/SelectCallBack.aspx?cat=913&field=ToOtherResIds&muilt=1&callBack=GetRes", '_blank', 'left=200,top=200,width=600,height=800', false);
    }
    function GetRes() {
        var resIds = $("#ToOtherResIdsHidden").val();
        var resHtml = "";
        if (resIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=GetResList&ids=" + resIds,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            resHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#ResManySelect").html(resHtml);
        $("#ResManySelect option").dblclick(function () {
            RemoveResDep(this);
        })
    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#ResManySelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#ToOtherResIdsHidden").val(ids);
    }

</script>
