<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchFrameSet.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchFrameSet" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<style>
    #SearchFrameSet{
        height:100%;
    }
</style>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="420,*" cols="100%" framespacing="0" border="0">
    <frame src="SearchConditionFrame.aspx?type=<%=this.searchName %>" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?type=<%=this.searchName %>&show=1" id="SearchBody"></frame>
</frameset>
</html>
