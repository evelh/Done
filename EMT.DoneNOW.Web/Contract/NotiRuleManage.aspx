<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NotiRuleManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.NotiRuleManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"修改" %>通知规则</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        .content label {
            width: 120px;
        }

        .CloseButton {
            background-image: url(../Images/delete.png);
            width: 16px;
            height: 16px;
            float: left;
        }

        .Section {
            border: 1px solid #d3d3d3;
            margin: 0 0 12px 0;
            padding: 4px 0 4px 0;
            width: 836px;
        }

            .Section > .Heading {
                align-items: center;
                display: flex;
                overflow: hidden;
                padding: 2px 4px 8px 6px;
                position: relative;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            .Section > .Content {
                padding-top: 12px;
            }

            .Section > .DescriptionText, .Section > .Content {
                padding-left: 28px;
                padding-right: 28px;
            }

            .Section .Column.Large, .Section .Column.Large > .Editor, .Section .Column.Large > .CheckBoxGroupContainer > .Editor, .Section .Column.Large > .RadioButtonGroupContainer > .Editor {
                width: 780px;
            }

        .Column, .ReplaceableColumnContainer {
            display: inline-block;
            vertical-align: top;
        }

        .Section .Column.Normal, .Section .Column.Normal > .Editor, .Section .Column.Normal > .CheckBoxGroupContainer > .Editor, .Section .Column.Normal > .RadioButtonGroupContainer > .Editor, .Section .Column.Normal > .Attachment_TypeContainer > .Editor {
            width: 390px;
        }

        .Column.Normal > .EditorLabelContainer, .Column.Normal > .ReadOnlyData > .LabelContainer {
            width: 380px;
        }

        .EditorLabelContainer {
            display: block;
        }

            .EditorLabelContainer > .Label {
                color: #4f4f4f;
                font-weight: 700;
                height: 14px;
                line-height: 13px;
                overflow: hidden;
                padding-bottom: 1px;
                padding-right: 5px;
                vertical-align: bottom;
                white-space: nowrap;
            }

            .EditorLabelContainer .Label label, .EditorLabelContainer .Label .Required {
                font-size: 12px;
            }

        .Required {
            color: #e51937;
            padding-left: 2px;
            font-size: 12px;
        }

        .Editor {
            display: inline-block;
            padding-bottom: 12px;
            vertical-align: top;
        }

            .Editor.TextBox input, .Editor.TextBox .Value, .Editor.DataSelector input {
                width: 306px;
            }

        input[type="text"] {
            height: 22px;
            padding: 0 6px;
            resize: none;
        }

        .Section > .Heading {
            align-items: center;
            display: flex;
            overflow: hidden;
            padding: 2px 4px 8px 6px;
            position: relative;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

            .Section > .Heading > .Left {
                flex: 0 1 auto;
            }

            .Section > .Heading > div, .Section > .Heading > span {
                display: inline-block;
                position: relative;
            }

            .Section > .Heading > .Left > .Text, .Section > .Heading > .Middle > .Text {
                color: #666;
                font-size: 12px;
                font-weight: bold;
                line-height: normal;
                text-transform: uppercase;
            }

        .Section > .Content {
            padding-top: 12px;
        }

        .Section > .DescriptionText, .Section > .Content {
            padding-left: 28px;
            padding-right: 28px;
        }

        .Section .Column.Large, .Section .Column.Large > .Editor, .Section .Column.Large > .CheckBoxGroupContainer > .Editor, .Section .Column.Large > .RadioButtonGroupContainer > .Editor {
            width: 780px;
        }

        .Column.Large > .EditorLabelContainer.DualMultipleSelect {
            width: 780px;
        }

        .Editor.DualMultipleSelect .Left {
            margin-right: 70px;
        }

        .Editor.DualMultipleSelect .Left, .Editor.DualMultipleSelect .Right {
            display: inline-block;
            width: 320px;
        }

        .Section .Column.Large > .Editor.DualMultipleSelect select {
            width: 320px;
        }

        .Editor.DualMultipleSelect select {
            resize: none;
        }

        .Editor.MultipleSelect select, .Editor.DataSelector select, .Editor.DualMultipleSelect select {
            height: 126px;
        }

        select {
            color: #333;
            height: 24px;
            margin: 0;
            padding: 0;
            white-space: nowrap;
        }

        .Editor.DualMultipleSelect .Middle {
            height: 60px;
            left: 380px;
            margin-top: -30px;
            position: absolute;
            top: 60%;
            width: 70px;
        }

        .Editor.DualMultipleSelect .Left, .Editor.DualMultipleSelect .Right {
            display: inline-block;
            width: 320px;
        }

        .Editor.DualMultipleSelect .Middle a.Button.MoveRight {
            top: 0;
        }

        .Editor.DualMultipleSelect .Middle a.Button.MoveLeft, .Editor.DualMultipleSelect .Middle a.Button.MoveRight {
            position: absolute;
            left: 27px;
        }

        .Editor > .InputField > a.Button.IconOnly, .Editor > .InputField > a.Button.IconOnly span, .Editor.DataSelector > .InputField a.Button.IconOnly span, .Editor.DualMultipleSelect > .InputField a.Button.IconOnly, .Editor.DualMultipleSelect > .InputField a.Button.IconOnly span, .Editor .CustomHtml a.Button.IconOnly, .Editor .CustomHtml a.Button.IconOnly span {
            height: 20px;
        }

        .Editor > .InputField > a.Button.IconOnly, .Editor.DualMultipleSelect > .InputField a.Button.IconOnly, .Editor .CustomHtml a.Button.IconOnly {
            background: transparent;
            border: none;
            padding: 0;
            vertical-align: top;
        }

        a.Button > .Text {
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: 600;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        a.Button.IconOnly .Text {
            display: none;
        }

        .EditorLabelContainer.DualMultipleSelect > .Label {
            display: inline-block;
            padding-right: 70px;
        }

        .Column.Large > .EditorLabelContainer.DualMultipleSelect > .Label {
            width: 320px;
        }
        body>.PageContentContainer>.ScrollingContentContainer {
    flex: 1 1 auto;
    position: relative;
}
        body>.PageContentContainer>.ScrollingContentContainer>.ScrollingContainer {
    bottom: 0;
    left: 0;
    position: absolute;
    right: 0;
    top: 0;
}
        .ScrollingContainer {
    -webkit-overflow-scrolling: touch;
    left: 0;
    overflow-x: auto;
    overflow-y: auto;
    padding: 0 10px 0 10px;
    position: absolute;
    right: 0;
}
 .PageContentContainer {
    display: flex;
    flex-direction: column;
    bottom: 0;
    left: 20px;
    position: absolute;
    right: 0;
    top: 98px;
}
 body>.PageContentContainer>.ScrollingContentContainer {
    flex: 1 1 auto;
    position: relative;
}
 .Section .Column.Large>.Editor.TextArea textarea {
    min-width: 715px;
    width: 715px;
}
 .Editor.TextArea textarea.Small {
    height: 31px;
    min-height: 31px;
}
 textarea {
    font-size: 12px;
    height: 118px;
    margin: 0;
    min-height: 118px;
    padding: 6px;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"修改" %>通知规则</div>
        <div class="header-title" style="margin-left: 30px;">
            <ul>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
                </li>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="关闭" />
                </li>
            </ul>
        </div>
        <div class="PageContentContainer">
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer"  style="height:100%;">
                 
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">常规</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Large Column">
                                    <div class="Normal Column" style="float: left;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z1f07f47507494b0496ee81aeaddfd613">规则名称</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox" data-editor-id="z1f07f47507494b0496ee81aeaddfd613" data-rdp="z1f07f47507494b0496ee81aeaddfd613">
                                            <div class="InputField">
                                                <input id="name" name="name" type="text" value="<%=thisRule==null?"":thisRule.name %>" />
                                            </div>

                                        </div>
                                    </div>
                                    <div class="Normal Column" style="float: left;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z2f71bdc08b56475d8df3630607cbe78b"><%=conTypeName %>临界值</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox" data-editor-id="z2f71bdc08b56475d8df3630607cbe78b" data-rdp="z2f71bdc08b56475d8df3630607cbe78b">
                                            <div class="InputField">
                                                <input id="threshold" name="threshold" type="text" value="<%=thisRule==null?"":thisRule.threshold.ToString("#0.00") %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  class="ToDec2"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">重新购买</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Large Column">
                                    <div class="Normal Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="z35af765c731b4b67889b99dd6c1a4015">购买<%=thisContract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER?"金额":(thisContract.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS?"时间":"事件") %></label>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox">
                                            <div class="InputField">
                                                  <% if (thisContract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                                                      { %>
                                                <input type="text" id="quantity" name="quantity" maxlength="9" value="<%=thisRule != null && thisRule.quantity != null ? ((decimal)thisRule.quantity).ToString("#0.00") : "" %>" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  class="ToDec2"/>
                                                <%}
                                                else
                                                { %>
                                                <input type="text" id="rate" name="rate" maxlength="9" value="<%=thisRule!=null&&thisRule.rate!=null?((decimal)thisRule.rate).ToString("#0.00"):"" %>" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="ToDec2"/>
                                                <%} %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Normal Column">
                                        <% if (thisContract.type_id != (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                                            { %>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label><%=conTypeName=="预付时间"?"小时计费费率":"事件单位金额" %></label>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox">
                                            <div class="InputField">
                                                <input type="text" id="rate" name="rate" maxlength="9" value="<%=thisRule!=null&&thisRule.rate!=null?((decimal)thisRule.rate).ToString("#0.00"):"" %>" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="ToDec2"/>
                                            </div>
                                        </div>
                                        <%} %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">通知</span></div>
                                <div class="Middle"></div>
                                <div class="Spacer"></div>
                                <div class="Right"></div>
                            </div>
                            <div class="Content">
                                <div class="Large Column">
                                    <div class="DualMultipleSelect EditorLabelContainer">
                                        <div class="Label">
                                            <label for="zc7d80ef9b1dc4d36b73dae6602ef198c">可用员工</label>
                                        </div>
                                        <div class="Label" style="padding-left: 73px;">
                                            <label for="zc7d80ef9b1dc4d36b73dae6602ef198c">通知员工</label>
                                        </div>
                                    </div>
                                    <div class="Editor DualMultipleSelect" data-editor-id="zc7d80ef9b1dc4d36b73dae6602ef198c" data-rdp="zc7d80ef9b1dc4d36b73dae6602ef198c">
                                        <div class="InputField">
                                            <div class="Left">
                                                <select id="OtherRes" multiple="multiple">
                                                    <%if (otherRuleResList != null && otherRuleResList.Count > 0)
                                                        {
                                                            foreach (var thisRuleRes in otherRuleResList)
                                                            {%>
                                                    <option value="<%=thisRuleRes.id %>"><%=thisRuleRes.name %></option>
                                                    <%
                                                            }
                                                        } %>
                                                </select>

                                            </div>

                                            <div class="Middle" style="top:380px;left:361px;">
                                                <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="ResToRight" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -15px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                                <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="ResToLeft" tabindex="0" style="margin-top:40px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                            </div>

                                            <div class="Right">
                                                <select id="RuleRes" multiple="multiple">
                                                    <%if (thisRuleResList != null && thisRuleResList.Count > 0)
                                                        {
                                                            foreach (var thisRuleRes in thisRuleResList)
                                                            {%>
                                                    <option value="<%=thisRuleRes.id %>"><%=thisRuleRes.name %></option>
                                                    <%
                                                            }
                                                        } %>
                                                </select>
                                            </div>
                                            <input type="hidden" id="hiRuleRes" name="RuleRes" value=""/>
                                            <input type="hidden" id="hiRuleCon" name="RuleCon" value=""/>
                                        </div>
                                    </div>
                                    <div class="DualMultipleSelect EditorLabelContainer">
                                        <div class="Label">
                                            <label for="za6ffcae65f5e49b19cb691dddab2e325">可用联系人</label>
                                        </div>
                                        <div class="Label" style="padding-left: 73px;">
                                            <label for="za6ffcae65f5e49b19cb691dddab2e325">通知联系人</label>
                                        </div>
                                    </div>
                                    <div class="Editor DualMultipleSelect" data-editor-id="za6ffcae65f5e49b19cb691dddab2e325" data-rdp="za6ffcae65f5e49b19cb691dddab2e325">
                                        <div class="InputField">
                                            <div class="Left">
                                                <select id="OtherCon" multiple="multiple">
                                                    <%if (otherRuleConList != null && otherRuleConList.Count > 0)
                                                        {
                                                            foreach (var thisRuleRes in otherRuleConList)
                                                            {%>
                                                    <option value="<%=thisRuleRes.id %>"><%=thisRuleRes.name %></option>
                                                    <%
                                                            }
                                                        } %>
                                                </select>
                                            </div>
                                            <div class="Middle" style="top:533px;left:361px;">
                                                <a class="Button ButtonIcon IconOnly MoveRight NormalState" id="ConToRight" tabindex="0"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -15px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>
                                                <a class="Button ButtonIcon IconOnly MoveLeft NormalState" id="ConToLeft" tabindex="0" style="margin-top:40px;"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -16px;width: 18px;height: 16px;"></span><span class="Text"></span></a>

                                            </div>
                                            <div class="Right">
                                                <select id="RuleCon" multiple="multiple">
                                                    <%if (thisRuleConList != null && thisRuleConList.Count > 0)
                                                        {
                                                            foreach (var thisRuleRes in thisRuleConList)
                                                            {%>
                                                    <option value="<%=thisRuleRes.id %>"><%=thisRuleRes.name %></option>
                                                    <%
                                                            }
                                                        } %>
                                                </select>

                                            </div>
                                        </div>
                                        <div class="Label">
                                            <label for="zb59848c73de146889c8682fd3c482fad">其他邮件地址<span class="SecondaryText">(使用 ; 分隔)</span></label>
                                        </div>
                                    </div>
                                    <div class="Editor TextArea" data-editor-id="zb59848c73de146889c8682fd3c482fad" data-rdp="zb59848c73de146889c8682fd3c482fad">
                                        <div class="InputField">
                                            <textarea class="Small" id="additional_email_addresses" name="additional_email_addresses" placeholder=""><%=thisRule==null?"":thisRule.additional_email_addresses %></textarea>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="zcbad7de9303b489bbcdd5a8ecf0ff2f6">通知模板</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="zcbad7de9303b489bbcdd5a8ecf0ff2f6" data-rdp="zcbad7de9303b489bbcdd5a8ecf0ff2f6">
                                        <div class="InputField">
                                            <asp:DropDownList runat="server" ID="notify_tmpl_id" Width="715px"></asp:DropDownList>
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
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    $("#CloseButton").click(function () {
        window.close();
    })
    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })
    // ConToRight ConToLeft
    // OtherRes  RuleRes     
    // OtherCon    RuleCon
    $("#ResToRight").click(function () {
        $("#OtherRes option").each(function () {
            if ($(this).is(":checked")) {
                
                var thisValue = $(this).attr("value");
                var thisText = $(this).html();
                $("#RuleRes").append("<option value='" + thisValue + "'>" + thisText+"</option>");
                $(this).remove();
            }
        })
    })
    $("#ResToLeft").click(function () {
        $("#RuleRes option").each(function () {
            if ($(this).is(":checked")) {
                var thisValue = $(this).attr("value");
                var thisText = $(this).html();
                $("#OtherRes").append("<option value='" + thisValue + "'>" + thisText + "</option>");
                $(this).remove();
            }
        })
    })
    $("#ConToRight").click(function () {
        $("#OtherCon option").each(function () {
            if ($(this).is(":checked")) {

                var thisValue = $(this).attr("value");
                var thisText = $(this).html();
                $("#RuleCon").append("<option value='" + thisValue + "'>" + thisText + "</option>");
                $(this).remove();
            }
        })
    })
    $("#ConToLeft").click(function () {
        $("#RuleCon option").each(function () {
            if ($(this).is(":checked")) {
                var thisValue = $(this).attr("value");
                var thisText = $(this).html();
                $("#OtherCon").append("<option value='" + thisValue + "'>" + thisText + "</option>");
                $(this).remove();
            }
        })
    })

    $("#save_close").click(function () {
        return SubmitCheck();
    })
    function SubmitCheck() {
        var name = $("#name").val();
     
        if ($.trim(name) == "") {
            LayerMsg("请填写规则名称");
            return false;
        }
        var threshold = $("#threshold").val();
        if ($.trim(threshold) == "") {
            LayerMsg("请填写临界值");
            return false;
        }
        var notify_tmpl_id = $("#notify_tmpl_id").val();
        if (notify_tmpl_id == "" || notify_tmpl_id == "0") {
            LayerMsg("请选择通知模板");
            return false;
        }
        var hiRuleRes = "";
        $("#RuleRes option").each(function () {
            var thisValue = $(this).attr("value");
            hiRuleRes += thisValue+",";
        })
        if (hiRuleRes != "") {
            hiRuleRes = hiRuleRes.substring(0, hiRuleRes.length-1);
        }
        $("#hiRuleRes").val(hiRuleRes);
        var hiRuleCon = "";
        $("#RuleCon option").each(function () {
            var thisValue = $(this).attr("value");
            hiRuleCon += thisValue + ",";
        })
        if (hiRuleCon != "") {
            hiRuleCon = hiRuleCon.substring(0, hiRuleCon.length - 1);
        }
        $("#hiRuleCon").val(hiRuleCon);
        return true;
    }
</script>

