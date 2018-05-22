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
    #SearchCondition{
        border-bottom: 1px solid #d3d3d3;
    }
</style>

    <%if (conditionHeight > 0) { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="<%=conditionHeight %>,*" cols="100%" framespacing="0" border="0">
    <frame src="SearchConditionFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&isCheck=<%=isCheck %>&param1=<%=param1 %>&param2=<%=param2 %>&param3=<%=param3 %>&param4=<%=param4 %>&param5=<%=param5 %>&param6=<%=param6 %>&param7=<%=param7 %>" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&show=<%=isShow %>&isCheck=<%=isCheck %>&param1=<%=param1 %>&param2=<%=param2 %>&param3=<%=param3 %>&param4=<%=param4 %>&param5=<%=param5 %>&param6=<%=param6 %>" id="SearchBody" name="SearchBody"></frame>
</frameset>
    <%} else { %>
<frameset id="SearchFrameSet" name="SearchFrameSet" rows="0,*" cols="100%" framespacing="0" border="0">
    <frame src="" id="SearchCondition"></frame>
    <frame src="SearchBodyFrame.aspx?cat=<%=this.catId %>&type=<%=this.queryTypeId %>&group=<%=paraGroupId %>&isCheck=<%=isCheck %>&param1=<%=param1 %>&param2=<%=param2 %>" id="SearchBody" style="overflow-x: hidden; overflow-y: auto; "></frame>
</frameset>
    <%} %>
  
</html>
