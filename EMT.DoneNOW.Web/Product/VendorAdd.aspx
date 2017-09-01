<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.VendorAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>供应商</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增供应商</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        供应商名称
                       <span class="errorSmall">*</span>
                            <div>
                              <asp:TextBox ID="CallBack" runat="server" disabled="disabled" name="account_name"></asp:TextBox>
                            <input type="hidden" name="CallBackHidden" id="CallBackHidden" value=""/>
                            <i onclick="OpenWindow()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                            </div>                        
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        单位成本
                        <div>
                            <asp:TextBox ID="cost" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        供应商产品编号
                        <div>
                            <asp:TextBox ID="number" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                           <asp:CheckBox ID="active" runat="server" />激活
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:CheckBox ID="default" runat="server" />默认
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
                var ve = $("#VendorName").val();
                if (ve == '' || ve == 0) {

                }
            }
            function OpenWindow() {
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VENDOR_CALLBACK %>&field=CallBack&callBack=GetProductCate", window, 'left=200,top=200,width=600,height=800', false);
            }
            function GetProductCate() {
                // alert($("#accCallBack").val());
            }
        </script>
    </form>
</body>
</html>
