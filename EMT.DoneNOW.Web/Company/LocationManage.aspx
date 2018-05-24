<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocationManage.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.LocationManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>地址管理</title>
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
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/bootstrap.min2.2.2.css" rel="stylesheet" />
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
            <ul style="list-style:none;margin-left:10px; ">
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save" runat="server" Text="保存"  BorderStyle="None" OnClick="save_Click" />
                </li>
                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>关闭</li>

            </ul>
        </div>
        <div>
            <%if (location != null)
                { %>
            <input type="hidden" name="id" id="id" value="<%=location.id %>"/>
            <%} %>
            <input type="hidden" name="account_id" id="account_id" value="<%=account_id %>"/>
            <table class="table table-bordered table-hover" style="width:40%;margin-left:20px;">
                <tr>
                    <td>
                        <label>是否默认</label></td>
                    <td>

                        <asp:CheckBox ID="isDefault" runat="server" />
                 <%--       <%if (location != null && location.is_default == 1)
                                                  { %>
                        <input type="checkbox"  name="is_default" data-val="1" value="1" checked="checked" disabled="disabled"/>
                        <%}else{%>
                        <input  type="checkbox" name="is_default" data-val="1" value="1"/>
                        <%} %>--%>
                       <%-- <asp:CheckBox ID="is_default" data-val="1" value="1" runat="server" />--%></td>
                </tr>
                <tr>
                    <td>国家<span style="color:red;">*</span></td>
                    <td>
                        <input id="country_idInit" value='1' type="hidden" runat="server" />
                        <select id="country_id" name="country_id">
                            <option value="1">中国</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>省份<span style="color:red;">*</span></td>
                    <td>
                        <input id="province_idInit" value='' type="hidden" runat="server" />
                        <select id="province_id" name="province_id">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>城市<span style="color:red;">*</span></td>
                    <td>
                        <input id="city_idInit" value='' type="hidden" runat="server" />
                        <select id="city_id" name="city_id">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>区县<span style="color:red;">*</span></td>
                    <td>
                        <input id="district_idInit" value='' type="hidden" runat="server" />
                        <select id="district_id" name="district_id">
                        </select>
                    </td>

                </tr>
                <tr>
                    <td>地址<span style="color:red;">*</span></td>
                    <td>
                        <asp:TextBox ID="address" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>地址附加信息</td>
                    <td>
                        <asp:TextBox ID="additional_address" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>邮编</td>
                    <td>
                        <asp:TextBox ID="postal_code" runat="server"></asp:TextBox></td>
                </tr>
                    <tr>
                    <td>标签</td>
                    <td>
                        <asp:TextBox ID="location_label" runat="server"></asp:TextBox></td>
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
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#close").click(function () {
        if (navigator.userAgent.indexOf("MSIE") > 0) {
            if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                window.opener = null;
                window.close();
            } else {
                window.open('', '_top');
                window.top.close();
            }
        }
        else if (navigator.userAgent.indexOf("Firefox") > 0) {
            window.location.href = 'about:blank ';
        } else {
            window.opener = null;
            window.open('', '_self', '');
            window.close();
        }
    });
    $("#save").click(function () {
        var province_id = $("#province_id").val();
        if (province_id == "") {
            LayerMsg("请选择相关省份！");
            return false;
        }
        var city_id = $("#city_id").val();
        if (city_id == "") {
            LayerMsg("请选择相关城市！");
            return false;
        }
        var district_id = $("#district_id").val();
        if (district_id == "") {
            LayerMsg("请选择相关区县！");
            return false;
        }
        var address = $("#address").val();
        if (address == "") {
            LayerMsg("请填写相关地址！");
            return false;
        }
        return true;
    })
</script>
