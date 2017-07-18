<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1">
        <div id="search_list">
            <input type="hidden" name="search_page" />
            <input type="hidden" id="search_id" name="search_id" />
            <input type="hidden" name="order" />
            <div id="conditions"></div>
        </div>
    </form>
</body>
</html>
