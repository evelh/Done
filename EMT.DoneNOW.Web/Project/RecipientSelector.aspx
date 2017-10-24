<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecipientSelector.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.RecipientSelector" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>

    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/Roles.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">接收选择器</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">OK</span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div style="color: #666; font-size: 12px; line-height: 14px; margin: 0 10px; padding: 0 0 5px 0;">Select the recipients that you would like to receive this notification.</div>
        <div class="DivSection" style="border: none; padding-left: 0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="width: 720px; overflow: auto;">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">员工
                        <div style="padding-bottom: 6px;">
                            <input type="text" style="width: 300px;" />
                            <a>
                                <img src="../Images/data-selector.png" />
                            </a>
                        </div>
                            <div>
                                <select multiple="multiple" style="width: 314px; min-height: 110px;" id="resSelect">
                                    <%if (resouList != null && resouList.Count > 0)
                                        {
                                            foreach (var resou in resouList)
                                            {%>
                                    <option value="<%=resou.id %>"><%=resou.name %></option>
                                    <%}
                                    } %>
                                </select>
                            </div>
                        </td>
                        <td width="30%" class="FieldLabels">工作组
                        <div style="padding-bottom: 6px;">
                            <input type="text" style="width: 300px;">
                            <a>
                                <img src="../Images/data-selector.png" />
                            </a>
                        </div>
                            <div>
                                <select multiple="multiple" style="width: 314px; min-height: 110px;" id="worSelect">
                                 <%if (worList != null && worList.Count > 0)
                                        {
                                            foreach (var wor in worList)
                                            {%>
                                    <option value="<%=wor.id %>"><%=wor.name %></option>
                                    <%}
                                    } %>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">联系人
                        <div style="padding-bottom: 6px;">
                            <input type="text" style="width: 300px;" />
                            <a>
                                <img src="../Images/data-selector.png" onclick="ChooseContact()">
                            </a>
                        </div>
                            <div>
                                <select multiple="multiple" style="width: 314px; min-height: 110px;" id="conSelect">
                                    <%if (conList != null && conList.Count > 0)
                                        {
                                            foreach (var con in conList)
                                            {%>
                                    <option value="<%=con.id %>"><%=con.name %></option>
                                    <%}
                                    } %>
                                </select>
                            </div>
                        </td>
                        <td width="30%" class="FieldLabels">Other Emails
                        <span style="font-weight: normal">(separate with semi-colon)</span>
                            <div>
                                <textarea style="width: 300px; min-height: 126px; resize: vertical;" id="OtherEmail"><%=otherEmail %></textarea>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">部门
                        <div style="padding-bottom: 6px;">
                            <input type="text" style="width: 300px;" />
                            <a>
                                <img src="../Images/data-selector.png" />
                            </a>
                        </div>
                            <div>
                                <select multiple="multiple" style="width: 314px; min-height: 110px;" id="depSelect">
                                     <%if (depList != null && depList.Count > 0)
                                        {
                                            foreach (var dep in depList)
                                            {%>
                                    <option value="<%=dep.id %>"><%=dep.name %></option>
                                    <%}
                                    } %>
                                </select>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <input type="hidden" id="account_hidden" value="<%=account==null?"":account.id.ToString() %>"/>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/Roles.js"></script>
<script>
    $("#CancelButton").click(function () {
        window.close();
    })

    $("#SaveAndCloneButton").click(function () {
        var resouIds = "";
        $("#resSelect option").each(function () {
            resouIds += $(this).val() + ',';
        });
        if (resouIds != "") {
            resouIds = resouIds.substring(0, resouIds.length-1);
        }


        var worIds = "";
        $("#worSelect option").each(function () {
            worIds += $(this).val() + ',';
        });
        if (worIds != "") {
            worIds = worIds.substring(0, worIds.length - 1);
        }

        var conIds = "";
        $("#conSelect option").each(function () {
            conIds += $(this).val() + ',';
        });
        if (conIds != "") {
            conIds = conIds.substring(0, conIds.length - 1);
        }


        var depIds = "";
        $("#depSelect option").each(function () {
            depIds += $(this).val() + ',';
        });
        if (depIds != "") {
            depIds = depIds.substring(0, depIds.length - 1);
        }
        var otherMail = $("#OtherEmail").html().trim();
        <%if (thisType == "To")
        { %>
        window.opener.document.getElementById("NoToResIds").value = resouIds;
        window.opener.document.getElementById("NoToContractIds").value = conIds;
        window.opener.document.getElementById("NoToDepIds").value = depIds;
        window.opener.document.getElementById("NoToWorkIds").value = worIds;
        window.opener.document.getElementById("NoToOtherMail").value = otherMail;
        <%}
         else if (thisType == "Cc")
         { %>
        window.opener.document.getElementById("NoCcResIds").value = resouIds;
        window.opener.document.getElementById("NoCcContractIds").value = conIds;
        window.opener.document.getElementById("NoCcDepIds").value = depIds;
        window.opener.document.getElementById("NoCcWorkIds").value = worIds;
        window.opener.document.getElementById("NoCcOtherMail").value = otherMail;
        <% }
        else if (thisType == "Bcc")
        {%>
        window.opener.document.getElementById("NoBccResIds").value = resouIds;
        window.opener.document.getElementById("NoBccContractIds").value = conIds;
        window.opener.document.getElementById("NoBccDepIds").value = depIds;
        window.opener.document.getElementById("NoBccWorkIds").value = worIds;
        window.opener.document.getElementById("NoBccOtherMail").value = otherMail;
        <%}%>
        window.opener.GetDataBySelectPage('<%=thisType %>');
        window.close();

    })

    function ChooseContact() {
        var account_hidden = $("#account_hidden").val();
        if (account_hidden != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=contactID&muilt=1&callBack=GetContact&con628=" + account_hidden, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);
        } else {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=contactID&muilt=1&callBack=GetContact", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);
        }
    }
</script>
