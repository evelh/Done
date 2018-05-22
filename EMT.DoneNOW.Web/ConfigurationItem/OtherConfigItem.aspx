<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtherConfigItem.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.OtherConfigItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>其他配置项</title>
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
    <div class="header">其他配置项-<%=product!=null?product.name:"" %></div>
        <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OTHER_INSTALLED_PRODUCT_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.OTHER_INSTALLED_PRODUCT_SEARCH %>&con3966=<%=insPro.id %>&con3963=<%=insPro.account_id %>">
        </iframe>
</body>
</html>
