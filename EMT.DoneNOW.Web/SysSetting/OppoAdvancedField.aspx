<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OppoAdvancedField.aspx.cs" Inherits="EMT.DoneNOW.Web.OppoAdvancedField" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
    <style type="text/css">
      #menu { position: absolute;z-index: 999;display: none;}
#menu ul{margin: 0 ;padding: 0;position: relative;width: 150px;border: 1px solid gray;background-color: #F5F5F5;padding: 10px 0;}
#menu ul li{padding-left: 20px;height: 25px;line-height: 25px;cursor:pointer;}
#menu ul li ul {display: none; position: absolute;right:-150px;top: -1px;background-color: #F5F5F5;min-height: 90%;}
#menu ul li ul li:hover{background: #e5e5e5;}
#menu ul li:hover{background: #e5e5e5;}
#menu ul li:hover ul {display: block;}
#menu ul li .menu-i1{width: 20px;height: 100%;display: block;float: left;}
#menu ul li .menu-i2{width: 20px;height: 100%;display: block;float: right;}
#menu ul .disabled{color: #AAAAAA;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
    <div class="ScrollingContainer ContainsGrid Active" style="top: 5px; bottom: 0;margin: 0 10px;overflow: auto">
        <div class="Grid Small">
            <div class="HeaderContainer">
                <table cellpadding="0">
                    <tbody>
                        <tr class="HeadingRow">                            
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">编号</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:250px;">
                                <div class="Standard">
                                    <div class="Heading">Displays on CRM Dashboard</div>
                                </div>
                            </td>
                            <td style="width:6px;"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RowContainer BodyContainer Active" style="top: 27px; bottom: 0px;">
                <table cellpadding="0">
                    <tbody>
                        <%int order = 1; %>
                              <%foreach (var td in GeneralList)
                                  { %>
                           <%--销售指标度量--%>
                        <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                            <td class="Text XL U3" style="width:201px;">
                                <%=order++ %>
                            </td> 
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.name %></div>
                                </div>
                            </td>
                             <td class="Context" style="width:252px;text-align:center"">
                                 <%if (Convert.ToInt32(td.ext1) > 0)
                                     {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" /></div>
                                 <%} %>
                            </td>
                             </tr>
                             <%}%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<%--右键菜单--%>
 <div id="menu">
        <%if (contextMenu.Count > 0) { %>
		<ul style="width:220px;">
            <%foreach (var menu in contextMenu) { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function%>"><i class="menu-i1"></i><%=menu.text %>
            </li>
            <%} %>
		</ul>
        <%} %>
	</div>
</div>
</form>
   <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/ClassificationIcons.js"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
       <script>
           function Delete() {
               if (confirm('删除操作将不能恢复，是否继续?')) {
                   $.ajax({
                       type: "GET",
                       url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=id%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else {
                               if (confirm(data)) {
                                   $.ajax({
                                       type: "GET",
                                       url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=id%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           parent.refrekkk();
                                       }
                                   });
                               }
                           }
                       }
                   });
               }
           }
            function Edit() {
                window.open('../Opportunity/OppportunityAdvancedField.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SysOPPORTUNITY_ADVANCED_FIELD %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        </script>
</body>
</html>
