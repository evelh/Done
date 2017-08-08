<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyNameSimilar.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.CompanyNameSimilar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>客户名称相似</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">客户名称相似</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    
                    <span id="save_close">保存并关闭</span>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                  <span id="close">关闭</span>
                    </li>
            </ul>
        </div>
        <div class="text">
            您新建的客户可能已经存在，您要创建新客户，还是更新以下客户的记录、联系人、待办信息？注意已存在客户的信息不会被更新
        </div>
        <div class="content clear savecontent" style="padding: 10px;">
            <table border="" cellspacing="" cellpadding="" class="savetable">
                <tr style="background: #CBD9E4;">
                    <th>客户名称</th>
                    <th>客户类型</th>
                    <th>地址</th>
                    <th>城市</th>
                    <th>状态</th>
                    <th>重复原因</th>
                </tr>
                <% if (nameSimilarList != null && nameSimilarList.Count > 0)
                    {
                        foreach (var item in nameSimilarList)
                        {%>
                <tr>
                    <td><%=item.name %></td>
                    <td><%=item.type_id %></td>
                    <td>地址</td>
                    <td>城市</td>
                    <td><%=item.is_active %></td>
                    <td><%=duplicateReason %></td>
                </tr>

                <%}%>
                <%}%>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {
        $("#save_close").click(function () {
            window.opener.document.getElementById("isCheckCompanyName").value = "no";
          
            window.opener.document.getElementById("save_close").click();
            window.close();
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
