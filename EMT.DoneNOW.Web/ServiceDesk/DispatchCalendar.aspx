<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DispatchCalendar.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.DispatchCalendar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>

        <frameset id="frame2" rows="75%, 25%" frameborder="1" border="8" bordercolor="#ffffff">
    <frame name="TOP" id="TOP" src="DispatcherWorkshopView.aspx" scrolling="AUTO" DragDropFromWindow_Window="BOTTOM;" DragDropFromWindow_DragPage="BOTTOM.oDragPage;"></FRAME>
    <frame name="BOTTOM" id="BOTTOM" src="../Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.DISPATCH_TICKET_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.DISPATCH_TICKET_SEARCH %>&group=214" scrolling="AUTO" DragDropToWindow_Window="TOP;" DragDropToWindow_DragPage="TOP.oDragPage;"></FRAME>
</frameset>

</html>
