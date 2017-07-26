<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchFrameSet.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchFrameSet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="400,*" cols="100%">
    <frame src="SearchConditionFrame.aspx?type=<%=this.searchName %>" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?type=<%=this.searchName %>&show=1" id="SearchBody"></frame>
</frameset>
</html>
