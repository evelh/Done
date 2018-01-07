<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractExclusions.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractExclusions" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        .buttonBar {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

        a.Button.Save .Icon, a.Button.Save.DisabledState .Icon {
            background-position: -32px -0px;
            display: inline-block;
        }

        a.Button span.Icon {
            background: transparent url(../../Images/Updated/ButtonBarIcons.png?v=1) no-repeat scroll;
            display: none;
            float: left;
            height: 16px;
            margin: 4px 3px 0 4px;
            width: 16px;
        }

        a.Button span {
            display: inline-block;
        }

            a.Button span.Text {
                float: left;
                font-size: 12px;
                font-weight: bold;
                line-height: 25px;
                padding: 0 3px;
                color: #4F4F4F;
            }

        .DivScrollingContainer.General {
            top: 82px;
        }

        .DivScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: fixed;
            right: 0;
            bottom: 0;
        }

        .sectionContainer {
            background-color: #fff;
            border: solid 1px #d3d3d3;
            margin: 0 10px 10px 10px;
            overflow: auto;
            padding: 5px 5px 0 5px;
            height: 250px;
        }

            .sectionContainer .section {
                color: #4F4F4F;
                font-weight: bold;
                font-size: 12px;
                height: 20px;
                line-height: 20px;
                margin-bottom: 10px;
                padding-left: 5px;
                width: auto;
                vertical-align: middle;
                text-transform: uppercase;
            }

        .label {
            color: #4F4F4F;
            font-size: 12px;
        }

        .sectionContainer .content {
            padding: 0 10px 0 28px;
        }

        .sectionContainer .labelText {
            color: #4F4F4F;
            font-weight: bold;
            font-size: 12px;
            padding-top: 5px;
        }

        .labelText {
            color: #4f4f4f;
            font-weight: 700;
            font-size: 12px;
            margin: 0;
            padding: 0;
        }

        .sectionContainer .data {
            margin-bottom: 5px;
            width: 99%;
        }

        .listMover {
            display: inline-block;
        }

        .listMover {
            width: 99%;
        }

            .listMover .leftContainer, .listMover .middleContainer, .listMover .rightContainer {
                display: inline-block;
                float: left;
                height: 167px;
            }

            .listMover .leftContainer, .listMover .rightContainer {
                width: 40%;
            }

            .listMover .leftContainer, .listMover .middleContainer, .listMover .rightContainer {
                display: inline-block;
                float: left;
                height: 167px;
            }

            .listMover .middleContainer {
                vertical-align: middle;
                width: 18%;
            }

            .listMover .centerContainer {
                padding-top: 60px;
            }

            .listMover .centerContainer {
                text-align: center;
            }

        .buttonBar a.Button, .ButtonPanel a.Button, .pageTitleBar > .TitleBarNavigation a.Button {
            background: #d7d7d7;
            background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            border: 1px solid #bcbcbc;
            display: inline-block;
            color: #4F4F4F;
            cursor: pointer;
            padding: 0 3px 0 2px;
            position: relative;
            text-decoration: none;
            vertical-align: middle;
            margin-right: 6px;
            float: left;
        }

        .listMover .leftContainer .topContainer, .listMover .rightContainer .topContainer {
            padding: 5px 0 2px 0;
            color: #4F4F4F;
        }

        .topContainer {
            padding-bottom: 3px !important;
            font-size: 12px;
            color: #333;
            font-weight: bold;
            font-family: Arial;
        }
        .listMover .middleContainer .topContainer, .listMover .middleContainer .bottomContainer {
    margin: auto;
    padding-left: 20px!important;
    padding-right: 20px!important;
}
        .listMover .middleContainer .topContainer, .listMover .middleContainer .bottomContainer {
    height: 30px;
    padding-bottom: 15px;
    padding-left: 25px;
    width: 60px;
}
        .listMover .leftContainer select, .listMover .rightContainer select {
    width: 220px;
    height: 100%;
}

body, input[type="text"], input[type="password"], select, textarea, .dxgvControl_Default pre {
    font-family: Arial,Helvetica,Tahoma,sans-serif;
}

input[type=text], input[type=password], select, textarea {
    border: solid 1px #D7D7D7;
    font-size: 12px;
    color: #333;
    margin: 0;
}

select {
    height: 24px;
    padding: 0;
}

select {
    width: 100%!important;
}
/*a.Button.NormalState {
    background-position: right -69px;
}*/
a.Button.IconOnly {
    background: none;
}
a.Button {
    cursor: pointer;
    height: 24px;
    padding: 0 3px;
    position: relative;
    text-decoration: none;
    vertical-align: middle;
}
a {
    color: #376597;
    text-decoration: none;
}
a.Button.NormalState>span {
    background-position: 0 0;
}
a.Button.IconOnly>span {
    background: none;
    padding: 0 1px 0 3px;
}
a.Button>span {
    height: 23px;
    padding: 0;
}
a.Button span {
    display: inline-block;
}
a.Button.IconOnly span.Icon {
    margin: 4px 0 0 -1px;
}
a.Button.MoveLeft .Icon, a.Button.MoveLeft.DisabledState .Icon, a.Button.SolidArrowLeft .Icon {
    background-position: -0px -16px;
    display: inline-block;
}
a.Button.MoveRight .Icon, a.Button.MoveRight.DisabledState .Icon, a.Button.SolidArrowRight .Icon {
    background-position: -16px -16px;
    display: inline-block;
}
a.Button span.Icon {
    float: left;
    height: 16px;
    margin: 4px 3px 0 4px;
    width: 16px;
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
            display: none;
        }
   #LoadingIndicator {
    width: 100px;
    height:100px;
    background-image: url(../Images/Loading.gif);
    background-repeat: no-repeat;
    background-position: center center;
    z-index: 30;
    margin:auto;
    position: absolute;
    top:0;
    left:0;
    bottom:0;
    right: 0;
    display: none;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="buttonBar">
            <a id="ctl00_mainContent_buttonSave" class="Button Save NormalState" onclick="SaveExc()">
                <span>
                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px -0px; width: 16px; height: 16px;"></span>
                    <span class="Text">保存</span>
                </span>
            </a>
            <a id="ctl00_mainContent_buttonCancel" class="Button Cancel NormalState">
                <span>
                    <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -15px -16px; width: 18px; height: 16px;"></span>
                    <span class="Text">取消</span>
                </span>
            </a>
        </div>

        <div class="DivScrollingContainer General">
            <div class="sectionContainer" style="height: 100px;">
                <div class="section">
                    <span id="ctl00_mainContent_generalContainerHeaderText" class="label">常规</span>
                </div>
                <div class="content">
                    <div class="labelText">
                        <span id="ctl00_mainContent_contractSelectorHeaderText" class="label">例外默认合同</span>&nbsp;
				<span id="ctl00_mainContent_ContractSelectorHeaderEmptyText" class="FieldLevelInstructions">（无相关例外合同时保持空白）</span>
                    </div>
                    <div class="data">
                        <span id="ctl00_mainContent_contractSelector" class="dataSelector">
                            <div id="ctl00_mainContent_contractSelector_UpperPanel" class="dataSelectorUpperPanel">
                                <div id="ctl00_mainContent_contractSelector_TextBoxContainer" class="visible">
                                    <input name="" type="text" id="excId" class="dataSelectorTextBox dataSelectorAutoCompleteTextBox" value="<%=excContract==null?"":excContract.name %>" /><a  class="Button DataSelector IconOnly NormalState" onclick="ExcConCallBack()"><span style="width: 13px;background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;height: 16px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -10px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></span></a>
                                </div>
                                <input type="hidden" name="" id="excIdHidden" value="<%=excContract==null?"":excContract.id.ToString() %>" />

                            </div>
                        </span>
                    </div>
                </div>
            </div>
            <div class="sectionContainer" style="height: 240px;">
                <div class="section">
                    <span id="ctl00_mainContent_roleHeaderText" class="label">角色</span>
                </div>
                <div class="content">
                    <div class="data">
                        <span id="ctl00_mainContent_roleListMover" class="listMover">
                            <div id="ctl00_mainContent_roleListMover_LeftContainer" class="leftContainer">
                                <div id="ctl00_mainContent_roleListMover_LeftContainerTopContainer" class="topContainer">
                                    角色
                                </div>
                                <div id="ctl00_mainContent_roleListMover_LeftContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="" multiple="multiple" id="allRoleList" class="listBox" style="width: 200px;">
                                        <% if (allRoleList != null && allRoleList.Count > 0)
                                            {
                                                foreach (var role in allRoleList)
                                                {
                                        %>
                                        <option value="<%=role.id %>"><%=role.name %></option>
                                        <%
                                                }
                                            } %>
                                    </select>
                                </div>
                            </div>
                            <div id="" class="middleContainer">
                                <div id="" class="centerContainer">
                                    <div class="topContainer" style="top: 380px; left: 361px;">
                                        <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="ResToRight" tabindex="0" onclick="ToRightRole()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -10px -16px; width: 18px; height: 16px;"></span><span class="Text"></span></a>
                                       </div>
                                    <div class="bottomContainer">
                                        <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="ResToLeft" tabindex="0" style="margin-top: 40px;" onclick="ToLeftRole()"> <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px; width: 18px; height: 16px;"></span><span class="Text"></span></a>
                                    </div>
                                </div>
                            </div>
                            <div id="" class="rightContainer">
                                <div id="" class="topContainer">
                                    例外角色
                                </div>
                                <div id="ctl00_mainContent_roleListMover_RightContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="" multiple="multiple" id="excRoleList" class="listBox" style="width: 200px;">

                                        <% if (thisRoleList != null && thisRoleList.Count > 0)
                                            {
                                                foreach (var role in thisRoleList)
                                                {
                                        %>
                                        <option value="<%=role.id %>"><%=role.name %></option>
                                        <%
                                                }
                                            } %>
                                    </select>
                                </div>
                            </div>
                        </span>
                    </div>
                </div>
            </div>
            <div class="sectionContainer" style="height: 240px;">
                <div class="section">
                    <span id="ctl00_mainContent_allocationCodeHeaderText" class="label">工作类型</span>
                </div>
                <div class="content">
                    <div class="data">
                        <span id="ctl00_mainContent_allocationCodeListMover" class="listMover">
                            <div id="ctl00_mainContent_allocationCodeListMover_LeftContainer" class="leftContainer">
                                <div id="ctl00_mainContent_allocationCodeListMover_LeftContainerTopContainer" class="topContainer">
                                    工作类型
                                </div>
                                <div id="ctl00_mainContent_allocationCodeListMover_LeftContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="allWorkType" multiple="multiple" id="allWorkType" class="listBox" style="width: 200px;">

                                        <% if (allCodeList != null && allCodeList.Count > 0)
                                            {
                                                foreach (var code in allCodeList)
                                                {
                                        %>
                                        <option value="<%=code.id %>"><%=code.name %></option>
                                        <%
                                                }
                                            } %>
                                    </select>
                                </div>
                            </div>
                            <div id="ctl00_mainContent_allocationCodeListMover_MiddleContainer" class="middleContainer">
                                <div id="ctl00_mainContent_allocationCodeListMover_CenterContainer" class="centerContainer">
                                    <div  class="topContainer" style="top: 380px; left: 361px;">
                                        <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="TypeToRight" tabindex="0" onclick="ToRightWorkType()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -10px -16px; width: 18px; height: 16px;"></span><span class="Text"></span></a>
                                        
                                        </div>
                                    <div class="bottomContainer">

                                        
                                        <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="TypeToLeft" tabindex="0" style="margin-top: 40px;" onclick="ToLeftWorkType()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px; width: 18px; height: 16px;"></span><span class="Text"></span></a>
                                    </div>
                                </div>
                            </div>
                            <div id="" class="rightContainer">
                                <div id="" class="topContainer">
                                    例外工作类型
                                </div>
                                <div id="ctl00_mainContent_allocationCodeListMover_RightContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="excWorkType" multiple="multiple" id="excWorkType" class="listBox" style="width: 200px;">
                                        <% if (thisCodeList != null && thisCodeList.Count > 0)
                                            {
                                                foreach (var code in thisCodeList)
                                                {
                                        %>
                                        <option value="<%=code.id %>"><%=code.name %></option>
                                        <%
                                                }
                                            } %>
                                    </select>
                                </div>
                            </div>
                        </span>
                    </div>
                </div>
            </div>
        </div>
         <div id="BackgroundOverLay"></div>
          <div id="LoadingIndicator"></div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
  <script src="../Scripts/common.js"></script>
<script>
  
    // 角色 左右切换
    function ToRightRole() {
        
        $("#allRoleList option").each(function () {
            if ($(this).is(":checked")) {
                var newHtml = "";
                var thisValue = $(this).attr("value");
                var thisHtml = $(this).html();
                newHtml = "<option value='" + thisValue + "'>" + thisHtml + "</option>";
                $("#excRoleList").append(newHtml);
                $(this).remove();
            }
        })

    }

    function ToLeftRole() {
        $("#excRoleList option").each(function () {
            if ($(this).is(":checked")) {
                var newHtml = "";
                var thisValue = $(this).attr("value");
                var thisHtml = $(this).html();
                newHtml = "<option value='" + thisValue + "'>" + thisHtml + "</option>";
                $("#allRoleList").append(newHtml);
                $(this).remove();
            }
        })
    }

    // 工作类型 左右切换
    function ToRightWorkType() {
        $("#allWorkType option").each(function () {
            if ($(this).is(":checked")) {
                var newHtml = "";
                var thisValue = $(this).attr("value");
                var thisHtml = $(this).html();
                newHtml = "<option value='" + thisValue + "'>" + thisHtml + "</option>";
                $("#excWorkType").append(newHtml);
                $(this).remove();
            }
        })
    }
    function ToLeftWorkType() {
        $("#excWorkType option").each(function () {
            if ($(this).is(":checked")) {
                var newHtml = "";
                var thisValue = $(this).attr("value");
                var thisHtml = $(this).html();
                newHtml = "<option value='" + thisValue + "'>" + thisHtml + "</option>";
                $("#allWorkType").append(newHtml);
                $(this).remove();
            }
        })
    }
    // 保存例外因素
    function SaveExc() {
        $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        var contractId = '<%=thisContract==null?"":thisContract.id.ToString() %>';
        var excIdHidden = $("#excIdHidden").val();

        var roleIds = "";
        $("#excRoleList option").each(function () {
            var thisValue = $(this).attr("value");
            roleIds += thisValue + ',';
        });
        if (roleIds != "") {
            roleIds = roleIds.substring(0, roleIds.length-1);
        }

        var typeIds = "";
        $("#excWorkType option").each(function () {
            var thisValue = $(this).attr("value");
            typeIds += thisValue + ',';
        });
        if (typeIds != "") {
            typeIds = typeIds.substring(0, typeIds.length - 1);
        }
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=SaveExclu&contract_id=" + contractId + "&exc_contract_id=" + excIdHidden + "&roleIds=" + roleIds + "&typeIds=" + typeIds ,
            success: function (data) {
                if (data == "True") {
                    LayerMsg("保存成功！");
                } else {
                    LayerMsg("保存失败！");
                }
               
                setTimeout(function () {
                    history.go(0);}, 1500)
                
            },
        });
    }
    // 关闭当前页面
    function ClosePage() {

    }

    function ExcConCallBack() {

        var account_id = '<%=thisContract==null?"":thisContract.account_id.ToString() %>';
        window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.EXC_CONTRACT_CALLBACK %>&field=excId&con1231=' + account_id, '<%=EMT.DoneNOW.DTO.OpenWindow.EXC_CONTRACT_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
    }


</script>
