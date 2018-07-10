<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CopyUdfToProject.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.CopyUdfToProject" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/LostOpp.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">从商机复制向导</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="Workspace Workspace1">
            <div class="PageInstructions">选择客户</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" colspan="2">客户名称
                                                    <div>
                                                        <input type="text" name="account_id" id="account_id" value="<%=thisAccount!=null?thisAccount.name:"" %>" /><a class="DataSelectorLinkIcon" name="AccountPicker" id="AccountPicker"><img src="../Images/data-selector.png" border="0" width="16" height="16" /></a>
                                                        <input type="hidden" id="account_idHidden" value="<%=thisAccount!=null?thisAccount.id.ToString():"" %>" />
                                                    </div>
                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a1">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一步</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                        <a class="ImgLink">
                            <span class="Text">下一步</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png" />
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="Workspace Workspace2" style="display:none;">
            <div class="PageInstructions">选择商机</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" colspan="2">商机名称
                                                    <div>
                                                        <select id="oppo_id">
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>

                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a2">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一步</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b2">
                        <a class="ImgLink">
                            <span class="Text">下一步</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png" />
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="Workspace Workspace3" style="display:none;">
            <div class="PageInstructions">下面是将从选定的商机复制到该项目的值 </div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <thead>
                                            <tr>
                                                <td width="80px" align="left">项目字段</td>
                                                <td style="padding-left: 8px;" align="left">商机字段</td>
                                                <td style="padding-left: 8px;" align="left">值</td>
                                            </tr>
                                        </thead>
                                        <tbody id="proUdfList">
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a3">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一步</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b3">
                        <a class="ImgLink">
                            <span class="Text"><asp:Button ID="finish" runat="server" Text="完成" OnClick="finish_Click" /></span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
         <div class="Workspace Workspace4" style="display:none;">
            <div class="PageInstructions">向导完成</div>
            <div class="WizardSection">
               
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                  
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">关闭</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {
        <%if (thisAccount != null)
        { %>
        $("#account_id").prop("disabled", true);

        <%}%>

        
        <%if (thisOppo != null)
        { %>
        $("#oppo_id").prop("disabled", true);
         <%}%>

    })

    $("#b1").click(function () {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden == "") {
            LayerMsg("请选择客户");
            return false;
        }
        GetOppoByAccount();
        $(".Workspace1").hide();
        $(".Workspace2").show();
    })
    $("#a2").click(function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    })
    $("#b2").click(function () {
        var oppo_id = $("#oppo_id").val();
        if (oppo_id == "") {
            LayerMsg("请选择商机");
            return false;
        }
        GetUdfByOpp();
        $(".Workspace3").show();
        $(".Workspace2").hide();
    })
    $("#a3").click(function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    })
    $("#b4").click(function () {
        window.close();
    })



    function GetOppoByAccount() {
        var account_idHidden = $("#account_idHidden").val();
        if (account_idHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/OpportunityAjax.ashx?act=GetOppByStatus&account_id=" + account_idHidden,
                success: function (data) {
                    $("#oppo_id").html(data);

                    <%if (thisOppo != null)
                    { %>
                    $("#oppo_id").val('<%=thisOppo.id.ToString() %>');
                    <%}%>
                },
            });
        }
    }
    // 根据商机获取相应的值
    function GetUdfByOpp() {
        var oppo_id = $("#oppo_id").val();
        if (oppo_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/OpportunityAjax.ashx?act=GetPorUdfByOpp&oppo_id=" + oppo_id,
                success: function (data) {
                    $("#proUdfList").html(data);
                },
            });
        }
        

    }


</script>
