<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMilestoneDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.ContractMilestoneDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>里程碑详细</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text2">里程碑详细<%=ccm.name %></span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon Print"></span>
                <span class="Text"></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">关闭</span>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="width:622px;">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
            <tbody>
            <tr>
                <td>
                    <span class="FieldLabels" style="font-weight:bold">到期日期</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;"><%=ccm.due_date %></span>
                    </div>
                </td>
                <td>
                    <span class="FieldLabels" style="font-weight:bold;">金额</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;"><%=ccm.dollars %></span>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="FieldLabels" style="font-weight:bold;">预估时间</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;">0</span>
                    </div>
                </td>
                <td>
                    <span class="FieldLabels" style="font-weight:bold;">实际时间</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;">0</span>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <span class="FieldLabels" style="font-weight:bold;">未完成任务数</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;">0</span>
                    </div>
                </td>
                <td>
                    <span class="FieldLabels" style="font-weight:bold;">采购订单号</span>
                    <div>
                        <span class="lblNormalClass" style="font-weight:normal;"></span>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <!--表格-->
    <div style="width: 100%; margin-bottom: 10px;">
        <div class="GridContainer" style="height: auto;">
            <div style="overflow: auto; z-index: 0;width: 683px;">
                <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;">
                    <tbody>
                        <tr class="dataGridHeader">
                            <td>
                                <span>名称</span>
                            </td>
                            <td align="right">预计时间</td>
                            <td align="right">
                                实际时间
                            </td>
                            <td align="right">
                               成本
                            </td>
                        </tr>
                        <tr class="dataGridBody">
                            <td>
                                <span>汇总</span>
                            </td>
                            <td align="right">
                                <span>0.00</span>
                            </td>
                            <td align="right">
                                <span>0</span>
                            </td>
                            <td align="right">
                                <span></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script>
            $("#CancelButton").click(function () {
                window.close();
                self.opener.location.reload();
            });
        </script>
    </form>
</body>
</html>
