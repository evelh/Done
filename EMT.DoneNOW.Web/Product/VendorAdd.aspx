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
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存"  BorderStyle="None" OnClick="Save_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" OnClientClick="return cancel()" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
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
                            <input type="text"disabled="disabled" id="CallBack" name="CallBack" value="<%=vendorname %>" />
                            <input type="hidden" name="CallBackHidden" id="CallBackHidden" value=""/>
                            <i onclick="OpenWindow()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                            </div>                        
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        单位成本
                        <div>
                            <asp:TextBox ID="cost" runat="server" onchange=""></asp:TextBox>
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
                         <asp:CheckBox ID="active" runat="server"  Checked="true"/>激活
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
        <input type="hidden" id="vvname" name="vvname"/>
     <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
            $(document).ready(function () {
                returnValue = $("#vendor_data", window.opener.document).val();
                if (returnValue !== '' && returnValue !== undefined) {
                    result = returnValue.replace(/'/g, '"');
                    result = result.replace(/\ +/g, "") //去掉空格方法
                    result = result.replace(/[\r\n]/g, "")//去掉回车换行
                    var obj = JSON.parse('[' + result + ']');                  
                    console.log(obj);            
                    for (var i = 0; i < obj.length; i++) {
                        // var kk = { 'vendorname': vendorname, 'id': id, 'vendor_cost': vendor_cost, 'vendor_product_no': vendor_product_no, 'is_active': is_active };
                        $("#CallBack").val(obj[i].vendorname);
                        $("#CallBackHidden").val(obj[i].id);
                        $("#cost").val(obj[i].vendor_cost);
                        $("#number").val(obj[i].vendor_product_no);
                        if (obj[i].is_active != "1") {
                            $("#active").removeAttr("selected", true);
                        }
                        $("#vvname").val(obj[i].vendorname);
                    }
                }


            });

            function save_deal() {
                var ve = $("#VendorName").val();
                var cost = $("#cost").val();
                if (ve == '' || ve == 0) {
                    alert("请选择供应商！");
                    return false;
                }
                window.opener.EditReturn($("#CallBackHidden").val());
            }
            function cancel() {


            }
            function OpenWindow(){
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VENDOR_CALLBACK %>&field=CallBack&callBack=GetVendorName",'<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorSelect %>', 'left=200,top=200,width=600,height=800',false);
            }
            function GetVendorName() {
                $("#vvname").val($("#CallBack").val());
            }
        </script>
    </form>
</body>
</html>
