<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocationManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.LocationManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        #Select1 {
            width: 128px;
        }

        #Select2 {
            width: 143px;
        }

        #Select3 {
            width: 131px;
        }
    </style>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <form id="form1" runat="server">
        <%if (string.IsNullOrEmpty(location_id))
            { %>
        <div class="header">新增地址</div>
        <%}
    else
    { %>
             <div class="header">修改地址</div>
        <%} %>
          <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save" runat="server" Text="保存"  BorderStyle="None" OnClick="save_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i></li>

            </ul>
        </div>
        <div>
            <table class="table">
                <tr>
                    <td>
                        <label>是否默认</label></td>
                    <td>
                        <%if (location != null && location.is_default == 1)
                                                  { %>
                        <input type="checkbox"  name="is_default" data-val="1" value="1" checked="checked" disabled="disabled"/>
                        <%}else{%>
                        <input  type="checkbox" name="is_default" data-val="1" value="1"/>
                        <%} %>
                       <%-- <asp:CheckBox ID="is_default" data-val="1" value="1" runat="server" />--%></td>
                </tr>
                <tr>
                    <td>国家</td>
                    <td>
                        <input id="country_idInit" value='1' type="hidden" runat="server" />
                        <select id="country_id" name="country_id">
                            <option value="1">中国</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>省份</td>
                    <td>
                        <input id="province_idInit" value='5' type="hidden" runat="server" />
                        <select id="province_id" name="province_id">
                        </select></td>
                </tr>
                <tr>
                    <td>城市</td>
                    <td>
                        <input id="city_idInit" value='6' type="hidden" runat="server" />
                        <select id="city_id" name="city_id">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>区县</td>
                    <td>
                        <input id="district_idInit" value='8' type="hidden" runat="server" />
                        <select id="district_id" name="district_id">
                        </select>
                    </td>

                </tr>
                <tr>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td>地址</td>
                    <td>
                        <asp:TextBox ID="address" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>地址附加信息</td>
                    <td>
                        <asp:TextBox ID="additional_address" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                </tr>
            </table>



            <script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
            <script type="text/javascript">
                $(document).ready(function () {
                    InitArea();
                });
            </script>
        </div>
    </form>
</body>
</html>
