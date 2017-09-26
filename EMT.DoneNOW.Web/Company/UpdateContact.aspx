<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdateContact.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.UpdateContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>修改联系人信息</title>
    <style>
        td{
            text-align:left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">修改联系人-<%=account.name %></div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" /></li>
            </ul>
        </div>
        <div class="text">
            公司的地址已更新，如下所示。
        </div>
        <div style="margin-left:50px;">
            <table style="width:400px;">

                <tr style="width:400px;">
                    <td ><span class="fl">国家</span></td>
                    <td style="width:200px;"><span><%=country_dic.FirstOrDefault(_=>_.val==defaultLocation.country_id.ToString()).show %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">省份</span></td>
                    <td><span><%=dic.FirstOrDefault(_=>_.val==defaultLocation.province_id.ToString()).show %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">城市</span></td>
                    <td><span><%=dic.FirstOrDefault(_=>_.val==defaultLocation.city_id.ToString()).show %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">区县</span></td>
                    <td><span><%=dic.FirstOrDefault(_=>_.val==defaultLocation.district_id.ToString()).show %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">地址</span></td>
                    <td><span><%=defaultLocation.address %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">邮编</span></td>
                    <td><span><%=defaultLocation.postal_code %></span></td>
                </tr>
                <tr>
                    <td><span class="fl">附加地址</span></td>
                    <td><span><%=defaultLocation.additional_address %></span></td>
                </tr>
            </table>
      
            <p>
                <span>联系人姓名清单</span>
                  <% if (locationContactList != null && locationContactList.Count > 0)
                      {
                          foreach (var contact in locationContactList)
                          {%>
                  <span style="margin-left: 10px;"><%=contact.name %></span>
                  <% }%>
                  <%} %>
                    <% if (faxPhoneContactList != null && faxPhoneContactList.Count > 0)
                      {
                          foreach (var contact in faxPhoneContactList)
                          {%>
                  <span style="margin-left: 10px;"><%=contact.name %></span>
                  <% }%>
                  <%} %>
              </p>
        </div>
        <div class="text" style="width:600px;">
            客户电话/传真发生变更，请确认以下员工是否同步修改
        </div>

        <input type="hidden" id="updateContact" value="" />
        <div class="content clear savecontent" style="padding: 10px;width:100%;" >
            <div>
                <p>
                    电话-
                    <asp:Label ID="Phone" runat="server" Text=""> </asp:Label>
                    传真-
                    <asp:Label ID="Fax" runat="server" Text=""></asp:Label>
                </p>
                <input type="hidden" name="Phone" value="<%=account.phone %>" />
                <input type="hidden" name="Fax" value="<%=account.fax %>" />
            </div>
            <table border="" cellspacing="" cellpadding="" class="savetable" style="width:100%;" >
                <tr style="background: #CBD9E4;">
                    <th style="text-align:center;">
                        <input type="hidden" id="updateId" name="updateId" value="" />
                        <input type="checkbox" name="" id="" value="" /></th>
                    <th style="text-align:center;">联系人名称</th>
                    <th style="text-align:center;">电话</th>
                    <th style="text-align:center;">传真</th>
                </tr>
                <% if (faxPhoneContactList != null && faxPhoneContactList.Count > 0)
                    {
                        foreach (var contact in faxPhoneContactList)
                        {%>
                <tr>
                    <td style="padding: 0;text-align:center;"><input type="checkbox" class="idCheck" value="<%=contact.id %>" /></td>
                    <td style="padding: 0;text-align:center;"><%=contact.name %></td>
                    <td style="padding: 0;text-align:center;"><%=contact.phone %></td>
                    <td style="padding: 0;text-align:center;"><%=contact.fax %></td>

                </tr>
                <% }%>
                <%} %>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        $("#save_close").click(function () {
            debugger;
            var updateId = "";
            $(".idCheck").each(function () {
                if ($(this).is(':checked')) {
                    updateId += $(this).val() + ',';
                }
            })
            if (updateId != "") {
                updateId = updateId.substring(0, updateId.length - 1);
                $("#updateId").val(updateId);
            }
        })
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
        });  // 直接关闭窗口
    })
</script>
