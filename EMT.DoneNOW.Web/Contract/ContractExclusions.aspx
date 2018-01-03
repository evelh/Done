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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="buttonBar">
            <a id="ctl00_mainContent_buttonSave" class="Button Save NormalState">
                <span>
                    <span class="Icon"></span>
                    <span class="Text">保存</span>
                </span>
            </a>
            <a id="ctl00_mainContent_buttonCancel" class="Button Cancel NormalState">
                <span>
                    <span class="Icon"></span>
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
                                    <input name="" type="text" id="excId" class="dataSelectorTextBox dataSelectorAutoCompleteTextBox" /><a id="" class="Button DataSelector IconOnly NormalState"><span><span class="Icon"></span><span class="Text"></span></span></a>
                                </div>
                                <input type="hidden" name="" id="excIdHidden" value="" />
                                
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
                                    <select size="10" name="" multiple="multiple" id="allRoleList" class="listBox">
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
                                    <div class="Middle" style="top:380px;left:361px;">
                                           <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="ResToRight" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -15px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                                <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="ResToLeft" tabindex="0" style="margin-top:40px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                    </div>
                                </div>
                            </div>
                            <div id="" class="rightContainer">
                                <div id="" class="topContainer">
                                    例外角色
                                </div>
                                <div id="ctl00_mainContent_roleListMover_RightContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="" multiple="multiple" id="excRoleList" class="listBox">
                                   
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
                                    <select size="10" name="allWorkType" multiple="multiple" id="allWorkType" class="listBox">
                                       
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
                                  <div class="Middle" style="top:380px;left:361px;">
                                         <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="TypeToRight" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -15px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                                <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="TypeToLeft" tabindex="0" style="margin-top:40px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                    </div>
                                </div>
                            </div>
                            <div id="" class="rightContainer">
                                <div id="" class="topContainer">
                                    例外工作类型
                                </div>
                                <div id="ctl00_mainContent_allocationCodeListMover_RightContainerBottomContainer" class="bottomContainer">
                                    <select size="10" name="excWorkType" multiple="multiple" id="excWorkType" class="listBox">
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>

    // 角色 左右切换
    function ToLeftRole() {

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

    function ToRightRole() {
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
    function ToLeftWorkType() {
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
    function ToRightWorkType() {
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

    }
    // 关闭当前页面
    function ClosePage() {

    }


</script>
