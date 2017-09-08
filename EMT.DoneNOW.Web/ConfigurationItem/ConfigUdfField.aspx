<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigUdfField.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigUdfField" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>新增自定义字段</title>
    <style type="text/css">
        .auto-style1 {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
            height: 65px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增自定义字段</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
   <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Name
                        <span class="errorSmall">*</span>
                        <div>
                            <input type="text" style="width:220px;">
                            <input type="checkbox" checked style="margin-left: 20px;">
                            <span class="txtBlack8Class">Active</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="auto-style1">
                        Description
                        <div>
                            <input type="text" style="width:220px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div style="padding-bottom: 10px;">
                            <input type="checkbox">
                            <span class="txtBlack8Class">Required (Applies only to user interface)</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div style="padding-bottom: 10px;">
                            <input type="checkbox">
                            <span class="txtBlack8Class">Protected</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <input type="checkbox">
                            <span class="txtBlack8Class">Encrypted</span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Sort Order
                        <div>
                            <input type="text" style="width:220px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Field Type
                        <div>
                            <select style="width:234px;">
                                <option value="">asda</option>
                                <option value="">111</option>
                                <option value="">222</option>
                                <option value="">3333</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Default Value
                        <div>
                            <input type="text" style="width:220px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Variable Name
                        <div style="padding: 0;">
                            <input type="text" style="width:220px;">
                        </div>
                        <div style="font-weight: normal;">This is for use in Microsoft Word Merge. The variable can only include alpha characters and must be unique. It must also begin with 'var' (for example: varMyTestVariable).</div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <input type="checkbox">
                            <span class="txtBlack8Class">Appears in Client Portal</span>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

        </div>
    </form>
</body>
</html>
