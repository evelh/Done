<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountTicketList.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.AccountTicketList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>工单历史</title>
    <style>
          
         #SearchFrameSet{
        height:100%;
    }
    #SearchCondition{
        border-bottom: 1px solid #d3d3d3;
    }
    </style>
</head>

            <frameset id="SearchFrameSet" name="SearchFrameSet" rows="206,*" cols="100%" framespacing="0" border="0">
    <frame src="../Common/SearchConditionFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_ACCOUNT_LIST %>&group=<%=groupId %>&con1731=<%=thisAccount.id.ToString() %>"  scrolling="no"  style="width:100%;border-width: 0px;" id="SearchCondition"></frame>
  <frame src="../Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_ACCOUNT_LIST %>&con1731=<%=thisAccount.id.ToString() %>&show=1"  scrolling="yes"  style="width:100%;height:600px;border-width: 0px;" id="SearchBody"></frame>
</frameset>
        
</html>
