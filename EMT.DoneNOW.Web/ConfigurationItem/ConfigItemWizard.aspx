<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigItemWizard.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.ConfigItemWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>配置项向导</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/LostOpp.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
          <div class="TitleBar">
        <div class="Title">
            <span class="text1">配置项目向导</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--第一页-->
    <div class="Workspace Workspace1">
        <div class="PageInstructions">
           请为正在安装的产品输入默认的安装日期和质保日期.
        </div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td width="100%" valign="top">
                            <!--第一页主体-->
                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td width="100%" class="FieldLabels">
                                            <div style="padding-bottom: 19px;">
                                                安装日期设置
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="padding-bottom: 10px;">
                                               <%-- <input type="radio" name="installChoice" checked style="margin-left: 10px;">--%><asp:RadioButton ID="rbBuyDate" runat="server" GroupName="installChoice" Checked="true" />
                                                <span>购买日期</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="padding-bottom: 19px;">
                                                <input type="radio" name="installChoice" style="margin-left: 10px;">
                                                <asp:RadioButton ID="rbInstallDate" runat="server" GroupName="installChoice" />
                                                <span>安装日期</span>
                                                <input type="text" onclick="WdatePicker()" class="Wdate">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="100%" class="FieldLabels">
                                            <div style="padding-bottom: 19px;">
                                                质保日期
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="padding-bottom: 10px;">
                                                <%--<input type="radio" name="warChoice" checked style="margin-left:10px;">--%>
                                                <asp:RadioButton ID="rbNo" GroupName="warChoice" runat="server" Checked ="true" />
                                                <span>无质保</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="padding-bottom: 10px;">
                                         <%--       <input type="radio" id="expiration" name="warChoice" style="margin-left: 10px;">--%>
                                                <asp:RadioButton ID="rbThrDate" GroupName="warChoice" runat="server" Checked ="true" />
                                                <span>质保到期时间</span>
                                                <input type="text" onclick="WdatePicker()" class="Wdate" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="padding-bottom: 19px;">
                                                <%--<input type="radio" name="warChoice" style="margin-left: 10px;">--%>
                                                <asp:RadioButton ID="rbEffDate" GroupName="warChoice" runat="server" Checked ="true" />
                                                <span>质保有效期</span>
                                                <input type="text" style="width:66px;" maxlength="3">
                                                <select style="width:68px;">
                                                    <option value="">Days</option>
                                                    <option value="">Months</option>
                                                    <option value="">Years</option>
                                                </select>
                                                <span>距离今天</span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li style="display: none;" id="a1">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" id="b1">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" style="display: none;" id="c1">
                    <a class="ImgLink">
                        <span class="Text">Finish</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d1">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">Close</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第二页-->
    <div class="Workspace Workspace2" style="display: none;">
        <div class="PageInstructions">选择以下产品作为配置项。相关信息可以修改，但不会修改成本。</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr>
                        <td colspan="9" valign="top">
                            <table cellspacing="0" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td colspan="1" id="txtBlack8">
                                            <div class="DivScrollingContainer" style="top:1px;margin-right:10px;">
                                                <div class="grid" style="overflow: auto;">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                        <thead>
                                                            <tr>
                                                                <td align="center" style="width:20px;">
                                                                    <input type="checkbox" style="margin: 0;">
                                                                </td>
                                                                <td>物料代码</td>
                                                                <td style="width:150px;">
                                                                  产品名称<span class="errorSmall">*</span>
                                                                </td>
                                                                <td align="center">安装日期</td>
                                                                <td align="center">
                                                                    质保截止日期  
                                                                </td>
                                                                <td>序列号</td>
                                                                <td>参考号</td>
                                                                <td>参考名</td>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td align="center">
                                                                    <input type="checkbox" style="margin: 0;">
                                                                </td>
                                                                  <%
                                                            EMT.DoneNOW.Core.d_cost_code costCode =  new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);
                                                        
                                                            %>
                                                                <td><%=costCode!=null?costCode.name:"" %></td>
                                                                <td style="width:150px;">
                                                                    <span style="display:inline-block; width: 79%; vertical-align:top; font-size: 12px;">
                                                                       <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="product_id" value="<%=product.product_name %>"/>
                                                                        <input type="hidden" name="product_id" id="product_idHidden" value="<%=product.id %>"/>

                                                                       
                                                                    </span>
                                                                    <input type="hidden" id=""/>
                                                                    <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                                                </td>
                                                                <td align="center">
                                                                    <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate">
                                                                </td>
                                                                <td align="center">
                                                                    <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate">
                                                                </td>
                                                                <td>
                                                                    <input type="text" name="serial_number" style="width:60px;">
                                                                </td>
                                                                <td>
                                                                    <input type="text" name="reference_number" style="width:60px;">
                                                                </td>
                                                                <td>
                                                                    <input type="text" style="width:60px;" name="reference_name" value="<%=conCost.name %>">
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li id="a2">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" id="b2">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" style="display: none;" id="c2">
                    <a class="ImgLink">
                        <span class="Text">Finish</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d2">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">Close</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第三页-->
    <div class="Workspace Workspace3" style="display: none;">
        <div class="PageInstructions">以下操作将被执行。</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <table cellspacing="1" cellpadding="0" width="100%">
                                <tbody>
                                    <tr>
                                        <td class="FieldLabels">
                                            <div>
                                                <span style="display: inline-block;">
                                                    <img src="../Images/check.png" style="vertical-align: middle;">
                                                </span>
                                                (<span id="sum">1</span>)
                                                <span style="color: #333333; font-weight:normal;">
                                                   配置项将从合同成本中创建
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li id="a3">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">上一页</span>
                    </a>
                </li>
                <!--下一层-->
                <li class="right" style="display: none;" id="b3">
                    <a class="ImgLink">
                        <span class="Text">下一页</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li class="right" id="c3">
                    <a class="ImgLink">
                        <span class="Text"><asp:Button ID="btnFinish" runat="server" Text="完成" OnClick="btnFinish_Click" /></span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" style="display: none;" id="d3">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">Close</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!--第四页-->
    <div class="Workspace Workspace4" style="display: none;">
        <div class="PageInstructions">The Wizard has been finished.</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                <tr>
                    <td width="100%">
                        <a href="##">Run the Install Products Wizard again from the beginning.</a>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                <!--上一层-->
                <li style="display: none;" id="a4">
                    <a class="ImgLink">
                        <img class="ButtonImg" src="../Images/move-left.png">
                        <span class="Text">Back</span>
                    </a>
                </li>
                <!--下一层-->
                <li style="display: none;" class="right" id="b4">
                    <a class="ImgLink">
                        <span class="Text">Next</span>
                        <img class="ButtonRightImg" src="../Images/move-right.png">
                    </a>
                </li>
                <!--完成-->
                <li style="display: none;" class="right" id="c4">
                    <a class="ImgLink">
                        <span class="Text">Finish</span>
                    </a>
                </li>
                <!--关闭-->
                <li class="right" id="d4">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text">Close</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#b1").on("click", function () {
        $(".Workspace1").hide();
        $(".Workspace2").show();
    });
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });
    $("#b2").on("click", function () {
        $(".Workspace2").hide();
        $(".Workspace3").show();
    });
    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    });
    $("#c3").on("click", function () {
        $(".Workspace3").hide();
        $(".Workspace4").show();
    });
    $("#d4").on("click", function () {
        window.close();
    });
    $("#load111").on("click", function () {
        $(".grid").show();
    });
    $("#all").on("click", function () {
        if ($(this).is(":checked")) {
            $(".grid input[type=checkbox]").prop('checked', true);
        } else {
            $(".grid input[type=checkbox]").prop('checked', false);
        }
    });

</script>
