<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewContactGroup.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ViewContactGroup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
    <style>
        iframe{
            height:100%;
            width:100%;
            border-width: 0px;
            min-height:700px;
        }
    </style>
</head>
<body>
  
        <div class="header">联系人组详情-<%=thisGroup!=null?thisGroup.name:"" %></div>
        <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VIEW_CONTACT_GROUP_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.VIEW_CONTACT_GROUP_SEARCH %>&con3949=<%=Request.QueryString["groupId"] %>&isCheck=1">
        </iframe>
  
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $(function () {
        var groupId = '<%=Request.QueryString["groupId"] %>';
        if (groupId == "") {
            alert("为获取到相应联系人组！");
            window.close();
        }
    })
</script>
