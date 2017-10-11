<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OppportunityAdvancedField.aspx.cs" Inherits="EMT.DoneNOW.Web.OppportunityAdvancedField" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
   <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />

    <style>.header-title{width: 100%;margin:10px;width: auto;height: 30px;}
.header-title ul li{position: relative;height:30px;line-height:30px; padding: 0 10px;float: left;margin-right: 10px;border: 1px solid #CCCCCC;cursor:pointer;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);}
.header-title ul li input{height:28px;line-height:28px;}
.header-title ul li:hover ul{display: block;}
.header-title ul li .icon-1{width: 16px;height:16px;display: block;float: left;margin-top: 7px;margin-right: 5px;}
.header-title ul li ul{display: none; position:absolute; left: -1px;top: 28px;border: 1px solid #CCCCCC;background: #F5F5F5;width:160px;padding: 10px 0;z-index: 99;}
.header-title ul li ul li{float: none;border: none;background: #F5F5F5;height:28px;line-height:28px;}
.header-title ul li input{outline:none; border: none;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);}
.icon-1{width: 16px;height:16px;display: block;float: left;margin-top: 7px;margin-right: 5px;}</style>
    <title>销售指标度量</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">销售指标度量</span>
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
            <div class="DivSection" style="border: none; padding-left: 0;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="30%" class="FieldLabels">名称
                        <span class="errorSmall">*</span>
                                <div>
                                    <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">
                                <div>
                                    <asp:CheckBox ID="Active" runat="server" />
                                    Displays on CRM Dashboard
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
            function save_deal() {
                var n = $("#Name").val();
                if (n == null || n == '') {
                    alert("请输入销售指标度量的名称！");
                    return false;
                }
            }
        </script>
    </form>
</body>
</html>