<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyNameSimilar.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.CompanyNameSimilar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>客户名称相似</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">客户名称相似</div>
        <div class="header-title" style="margin:0 10px 10px 0;height:40px;">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;margin-top:6px;"></i>
                    
                    <span id="save_close">保存并关闭</span>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;margin-top:6px;"></i>
                  <span id="close">关闭</span>
                    </li>
            </ul>
        </div>
        <div class="text" style="padding:0;">
            您新建的客户可能已经存在，您要创建新客户，还是更新以下客户的记录、联系人、待办信息？注意已存在客户的信息不会被更新
        </div>
        <div class="content clear savecontent" style="padding: 10px;">
            <table border="0" cellspacing="0" cellpadding="0" class="savetable" width="100%">
                <tr style="background: #CBD9E4;">
                    <th style="width:20%;text-align:center;">客户名称</th>
                    <th style="width:100px;text-align:center;">客户类型</th>
                    <th style="width:30%;text-align:center;">地址</th>
                    <th style="width:80px;text-align:center;">城市</th>
                    <th style="width:60px;text-align:center;">状态</th>
                    <th style="width:20%;text-align:center;">重复原因</th>
                </tr>
                <% if (nameSimilarList != null && nameSimilarList.Count > 0)
                    {
                        var accountType = dic.FirstOrDefault(_ => _.Key == "company_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                        foreach (var item in nameSimilarList)
                        {%>
                <tr>
                    <td><%=item.name %></td>
                    <td><%=item.type_id==null?"":accountType.FirstOrDefault(_=>_.val==item.type_id.ToString()).show %></td>
                    <td></td>
                    <td></td>
                    <td><%=item.is_active==1?"激活":"未激活" %></td>
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
