<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchFrameSet.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchFrameSet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<style>
    #SearchFrameSet{
        height:100%;
    }
</style>

    <%if (conditionHeight > 0) { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="350,*" cols="100%" framespacing="0" border="0">
    <frame src="SearchConditionFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&show=1" id="SearchBody"></frame>
</frameset>
    <%} else { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="0,*" cols="100%" framespacing="0" border="0">
    <frame src="" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>" id="SearchBody" style="overflow-x: hidden; overflow-y: auto; "></frame>
</frameset>
    <%} %>
</html>
