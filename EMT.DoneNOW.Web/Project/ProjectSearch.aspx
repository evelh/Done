<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSearch.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSearch" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <style>
    #SearchFrameSet{
        height:100%;
    }
    #SearchCondition{
        border-bottom: 1px solid #d3d3d3;
    }
</style>
</head>

           <%if (conditionHeight > 0) { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="<%=conditionHeight %>,*" cols="100%" framespacing="0" border="0">
    <frame src="../Common/SearchConditionFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&isCheck=<%=isCheck %>" id="SearchCondition"></frame>
    <frame src="ProjectSearchResult.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&show=1&isCheck=<%=isCheck %>" id="SearchBody"></frame>
</frameset>
    <%} else { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="0,*" cols="100%" framespacing="0" border="0">
    <frame src="" id="SearchCondition"></frame>
    <frame src="ProjectSearchResult.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>" id="SearchBody" style="overflow-x: hidden; overflow-y: auto; "></frame>
</frameset>
    <%} %>

</html>
