<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GeneralView.aspx.cs" Inherits="EMT.DoneNOW.Web.GeneralView" %>
<%@ Import Namespace="EMT.DoneNOW.DTO" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <div class="TitleBarNavigationButton">
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/SysSetting/SysAdmin.aspx" CssClass="buttons"><img src="../Images/move-left.png"/></asp:HyperLink>                       
                    </div> 
                    <span class="text1"><%=name %></span>
                    <a href="###" class="collection"></a>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <%if (id != (int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)
                { %>
            <div class="ButtonContainer">
                <ul id="btn">
                    <li class="Button ButtonIcon NormalState" id="AddButton" tabindex="0" onclick="skip(0)">
                        <span class="Icon Add"></span>
                        <span class="Text Creat">新增<%=name %></span>
                    </li>
                </ul>
            </div>
            <%} %>            
    <div class="ScrollingContainer ContainsGrid Active" style="top: 82px; bottom: 0;margin: 0 10px;overflow: auto">
        <div class="Grid Small">
            <div class="HeaderContainer">
                <table cellpadding="0">
                    <tbody>
                        <tr class="HeadingRow">
                             <%if (id == (int)GeneralTableEnum.TERRITORY)
                                 { %><%--地域--%>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                             <td class="Context" style="width:250px;">
                                <div class="Standard">区域</div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                            <%} %>
                           
                           <%if (id == (int)GeneralTableEnum.ACTION_TYPE)
                               {%><%--活动类型--%>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">视图</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:100px;">
                                <div class="Standard">
                                    <div class="Heading">状态</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:100px;">
                                <div class="Standard">
                                    <div class="Heading">系统</div>
                                </div>
                            </td>
                            <%}
                                if (id == (int)GeneralTableEnum.MARKET_SEGMENT || id == (int)GeneralTableEnum.REGION || id == (int)GeneralTableEnum.COMPETITOR)
                                { %>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                            <%} %>

                            <%if (id == (int)GeneralTableEnum.OPPORTUNITY_STAGE)
                                { %><%--商机阶段--%>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:250px;">
                                <div class="Standard">
                                    <div class="Heading">Default for Lost Opportunities</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:250px;">
                                <div class="Standard">
                                    <div class="Heading">Default for Won Opportunities</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:150px;">
                                <div class="Standard">
                                    <div class="Heading">Sort Order</div>
                                </div>
                            </td>
                            <%} %>
                            <%if (id == (int)GeneralTableEnum.OPPORTUNITY_SOURCE)
                                { %>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:100px;">
                                <div class="Standard">
                                    <div class="Heading">Number</div>
                                </div>
                            </td>
                            <%} %>
                              <%if (id == (int)GeneralTableEnum.CONTRACT_CATE)
                                 { %><%--合同类别--%>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">描述</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:250px;">
                                <div class="Standard">
                                    <div class="Heading">激活</div>
                                </div>
                            </td>
                            <%} %>
                             <%if (id == (int)GeneralTableEnum.NAME_SUFFIX)
                                 { %><%--姓名后缀--%>
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">名称</div>
                                </div>
                            </td>
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">激活</div>
                                </div>
                            </td>
                            <%} %>
                             <%if (id == (int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)
                                 { %><%--销售指标度量--%>
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
                            <%} %>
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
                             <%if (id == (int)GeneralTableEnum.MARKET_SEGMENT || id == (int)GeneralTableEnum.REGION || id == (int)GeneralTableEnum.COMPETITOR)
                                 { %><%--市场、区域、竞争对手--%>

                        <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">


                             <td class="Text XL U3" style="width:201px;">
                               <%=td.name %>
                            </td> 
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.remark %></div>
                                </div>
                            </td>
                        </tr>
                            <%} %>
                            <%if (id == (int)GeneralTableEnum.TERRITORY)
                                { %><%--地域--%>
                       <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                             <td class="Text XL U3" style="width:201px;">
                                <%=td.name %>
                            </td>
                            <td class="Context" style="width:252px;">
                                <div class="Standard"> <%=gbll.GetGeneralTableName(id)%></div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.remark %></div>
                                </div>
                            </td>
                        </tr>
                            <%} %>
                               <%if (id == (int)GeneralTableEnum.ACTION_TYPE)
                                   {%><%--活动类型--%>
                      <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                             <td class="Text XL U3" style="width:201px;">
                                <%=td.name %>
                            </td>
                            <td class="Context" style="width:auto;">
                                <%if (Convert.ToInt32(td.parent_id) > 0)
                                    { %>
                                <div class="Standard"><%=gbll.GetGeneralName((int)td.parent_id)%></div>
                                <%} %>
                            </td>
                             <td class="Context" style="width:102px;text-align:center">
                                 <%if (td.is_active > 0)
                                     {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" style="text-align:center" /></div>
                                 <%} %>
                            </td>
                             <td class="Context" style="width:102px;text-align:center">
                                  <%if (td.is_system > 0)
                                      {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" style="text-align:center"/></div>
                                 <%} %>
                            </td>                            
                        </tr>
                            <%} %>
                            <%if (id == (int)GeneralTableEnum.OPPORTUNITY_STAGE)
                                { %><%--商机阶段--%>
                       <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                            <td class="Text XL U3" style="width:201px;">
                                 <%=td.name %>
                            </td>                           
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.remark %></div>
                                </div>
                            </td>
                             <td class="Context" style="width:252px;text-align:center"">
                                 <%if (Convert.ToInt32(td.ext1) > 0)
                                     {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" /></div>
                                 <%} %>
                            </td>
                            <td class="Context" style="width:252px;text-align:center"">
                                <%if (Convert.ToInt32(td.ext2) > 0)
                                    {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" /></div>
                                 <%} %>
                            </td>
                            <td class="Context" style="width:152px;">
                                <div class="Standard"><%=td.code %></div>
                            </td>
                            </tr>
                            <%} %>
                            
                             <%if (id == (int)GeneralTableEnum.OPPORTUNITY_SOURCE)
                                 { %><%--商家来源--%>
                         <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                             <td class="Text XL U3" style="width:201px;">
                                <%=td.name %>
                            </td>                           
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.remark %></div>
                                </div>
                            </td>
                                <td class="Context" style="width:102px;">
                                <div class="Standard"><%=td.code %></div>
                            </td>
                            </tr>
                            <%} %>
                        <%if (id == (int)GeneralTableEnum.NAME_SUFFIX)
                            { %><%--姓名后缀--%>
                        <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                            <td class="Text XL U3" style="width:201px;">
                                 <%=td.name %>
                            </td>                           
                             <td class="Context" style="width:252px;text-align:center"">
                                 <%if (Convert.ToInt32(td.is_active) > 0)
                                     {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" /></div>
                                 <%} %>
                            </td>
                             </tr>
                        <%} %>
                         <%if (id == (int)GeneralTableEnum.CONTRACT_CATE)
                            { %><%--合同类别--%>
                        <tr onclick="skip(<%=td.id %>)" title="右键显示操作菜单" data-val="<%=td.id %>" class="dn_tr">
                            <td class="Text XL U3" style="width:201px;">
                                 <%=td.name %>
                            </td>  
                             <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"><%=td.remark %></div>
                                </div>
                            </td>
                             <td class="Context" style="width:252px;text-align:center"">
                                 <%if (Convert.ToInt32(td.is_active) > 0)
                                     {%>
                                <div class="Standard">
                                    <img src="../Images/check.png" /></div>
                                 <%} %>
                            </td>
                             </tr>
                        <%} %>
                        <%if (id == (int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)
                            { %><%--销售指标度量--%>
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
                        <% }%>
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

               <%if (id == (int)GeneralTableEnum.ACTION_TYPE)
           {%>
           function Delete() {
               //活动类型
               if (confirm('确认删除?')) {
                   $.ajax({
                       type: "GET",
                       url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=id%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else {
                               alert(data);
                           }
                       }
                   });
               }
               window.location.reload();
           }                
                 <%}else if (id == (int)GeneralTableEnum.OPPORTUNITY_STAGE){%>
           function Delete() {
               //商机阶段
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
                               alert(data);
                           }
                       }
                   });
               }
               window.location.reload();
           }
                <%}%>
                <%else
           {%>
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
                                       }
                                   });
                               }
                           }
                       }
                   });
               }
               window.location.reload();
           }
                <%}%>
            function Edit() {
                skip(entityid);
                <%if (id == (int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)
            {%>
                window.open('Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SysOPPORTUNITY_ADVANCED_FIELD %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%}%>
            }
            function skip(entityid) {
                     <%switch (id)
            {%>
                <%case (int)GeneralTableEnum.TERRITORY:%>
                window.open('SysTerritory.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.MARKET_SEGMENT:%>
                window.open('SysMarket.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.REGION:%>
                window.open('SysRegion.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.COMPETITOR:%>
                window.open('SysCompetitor.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.ACTION_TYPE:%>
                window.open('ActionType.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACTION_TYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.OPPORTUNITY_STAGE:%>
                window.open('../Opportunity/OpportunityStage.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.OPPORTUNITY_SOURCE:%>
                window.open('../Opportunity/OpportunityLeadSource.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>
                 <%case (int)GeneralTableEnum.NAME_SUFFIX:%>
                window.open('Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.NAME_SUFFIX %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                <%; break;%>                
               <%} %>
                }   
      
        </script>
</body>
</html>
