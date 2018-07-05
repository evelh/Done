<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleOrderView.aspx.cs" Inherits="EMT.DoneNOW.Web.SaleOrder.SaleOrderView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>查看销售订单</title>
    <style>
        .allswitch {
            height: 34px;
        }
    </style>
    
</head>
<body>
    <form id="form1" runat="server">

        <div class="header">
            <i>
                <ul>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ACTIVITY")) { %>
                    <li><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=activity">活动</a></li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_TODOS")) { %>
                    <li><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=todo">待办</a></li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_NOTES")) { %>
                    <li><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=note">备注</a></li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_TICKETS")) { %>
                    <li>工单</li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ATTACHMENT")) { %>
                    <li><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=attachment">附件</a></li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ENTRY")) { %>
                    <li><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=entry">报价项</a></li>
                  <%}%>
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_PURCHASE_ORDER")) { %>
                    <li>采购订单</li>
                  <%}%>
                </ul>
            </i>
            销售订单-<%=opportunity.name %>(ID:<%=opportunity.oid %>)-<%=account.name %>
             <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> "
                onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div>
        </div>

        <div class="header-title">
            <ul>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_EDIT")) { %>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" id="Edit" value="修改" onclick="window.open('SaleOrderEdit.aspx?id=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderEdit %>','left= 200, top = 200, width = 900, height = 750', false);" />
                </li>
              <%}%>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_ADD")) { %>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    添加
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_ADD_TODOS")) { %>
                        <li><a href="#" onclick="window.open('../Activity/Todos.aspx?saleorderId=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>','left=200,top=200,width=730,height=750', false);">待办</a></li>
                      <%}%>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_ADD_NOTES")) { %>
                        <li><a href="#" onclick="window.open('../Activity/Notes.aspx?saleorderId=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.NoteAdd %>','left=200,top=200,width=730,height=750', false);">备注</a></li>
                      <%}%>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_ADD_TICKETS")) { %>
                        <li>工单</li>
                      <%}%>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_ADD_ATTACHMENT")) { %>
                        <li><a href="#" onclick="window.open('../Activity/AddAttachment.aspx?objId=<%=sale_order.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.AttachmentAdd %>','left=200,top=200,width=730,height=750', false);">附件</a></li>
                      <%}%>
                    </ul>
                </li>
              <%}%>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_FRIEND_LINK")) { %>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>友情链接</li>
              <%}%>
            </ul>
        </div>

        <input type="hidden" id="isShowLeft" value="" runat="server" />
        <!--头部-->
        <%
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sys_resource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var status = dic.FirstOrDefault(_ => _.Key == "sales_order_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

            var oppo_statu = dic.FirstOrDefault(_ => _.Key == "oppportunity_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var oppo_stage = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
        %>

        <h1 style="margin-left: 10px; font-size: 15px; font-weight: bolder; color: #4F4F4F; margin-top: 10px;"><%=actType %>-<%=opportunity.name %>(<a style="cursor: pointer;" onclick="window.open('../company/ViewCompany.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);" class="HyperLink"><%=account.name %></a>)</h1>
        <!--切换项-->
        <div <%if (type == "activity" || type == "note" || type == "todo")
            { %>
            style="margin-left: 280px; margin-right: 10px;" <%}
            else
            { %>
            style="margin-left: 10px; margin-right: 10px;" <% } %>>
            <div id="leftDiv" class="activityTitleleft fl" style="margin-left: -270px;">
                <div class="address opportunityaddress viewleftTitle1">
                    <p class="switch pr"><i class="switchicon switchicon1"></i>销售订单</p>
                    <p class="clear">
                        <span class="fl">负责人</span><span class="fr"><%=sys_resource.First(_=>_.val==sale_order.owner_resource_id.ToString()).show %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">开始日期</span><span class="fr"><%=sale_order.begin_date.ToString("yyyy-MM-dd") %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">截止日期</span><span class="fr"><%=sale_order.end_date==null?"":((DateTime)sale_order.end_date).ToString("yyyy-MM-dd") %><br />
                        </span>
                    </p>
                    <%
                        if (sale_order.ship_to_location_id != null)
                        {
                            var shipLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.ship_to_location_id);%>

                    <p class="clear">
                        <span class="fl">配送地址</span><span class="fr"><%=country.FirstOrDefault(_=>_.val==shipLocation.country_id.ToString()).show %>
                            <br />
                            <%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.district_id.ToString()).show %><br />
                            <%=shipLocation.address %><br />
                        </span>
                    </p>

                    <%}%>

                    <%if (sale_order.bill_to_location_id != null)
                        {
                            var billLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.bill_to_location_id);
                    %>
                    <p class="clear">
                        <span class="fl">账单地址</span><span class="fr"><%=country.FirstOrDefault(_=>_.val==billLocation.country_id.ToString()).show %>
                            <br />
                            <%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.district_id.ToString()).show %>
                            <br />
                            <%=billLocation.address %><br />
                        </span>
                    </p>

                    <%} %>

                    <p class="clear">
                        <span class="fl">状态</span><span class="fr"><%=status.FirstOrDefault(_=>_.val==sale_order.status_id.ToString()).show %><br />
                        </span>
                    </p>
                </div>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_OPPORTUNITY")) { %>
                <div class="address opportunityaddress viewleftTitle1">
                    <p class="switch pr"><i class="switchicon switchicon1"></i>商机</p>
                    <p class="clear">
                        <span class="fl">名称</span><span class="fr"><a style="cursor: pointer;" onclick="window.open('../Opportunity/ViewOpportunity.aspx?id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityView %>','left=200,top=200,width=900,height=750', false);" class="linkButton"><%=opportunity.name %></a><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">负责人</span><span class="fr"><%=sys_resource.First(_=>_.val==opportunity.resource_id.ToString()).show %><br />
                            <a style="cursor: pointer;" class="linkButton">重新指派</a><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">商机ID</span><span class="fr"><%=opportunity.oid %><br />
                        </span>
                    </p>
                    <%if (quote != null)
                        { %>
                    <p class="clear">
                        <span class="fl">报价</span><span class="fr"><a style="cursor: pointer;" class="linkButton" onclick="window.open('../QuoteItem/QuoteItemManage.aspx?quote_id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteItemManage %>','left=200,top=200,width=900,height=750', false);"><%=quote.name %></a><br />
                        </span>
                    </p>
                    <%} %>
                    <%
                        // todo 对项目提案的判断
                    %>
                    <%
                        var totalRebenue = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoRevenue(opportunity.id);
                        var totalCost = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoCost(opportunity.id);
                        var Gross_Profit = totalRebenue - totalCost;
                    %>
                    <p class="clear">
                        <span class="fl">毛利</span><span class="fr"><%=Gross_Profit.ToString("#0.00") %>
                            <br />
                            <%=totalRebenue==0?"0":(Gross_Profit/totalRebenue).ToString("#0.00") %> %
                                    <br />
                            <%=opportunity.number_months == null?"":opportunity.number_months.ToString()+"  个月" %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">创建日期</span><span class="fr"><%=opportunity.projected_begin_date==null?"":((DateTime)opportunity.projected_begin_date).ToString("yyyy-MM-dd") %>
                            <br />
                            <%=opportunity.projected_begin_date==null?"":" 距今"+Math.Ceiling(((DateTime)opportunity.projected_begin_date - DateTime.Now).TotalDays).ToString()+"天" %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">状态</span><span class="fr"><%=oppo_statu.First(_ => _.val == opportunity.status_id.ToString()).show %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">等级</span><span class="fr"><%=oppo_stage.First(_ => _.val == opportunity.stage_id.ToString()).show %><br />
                        </span>
                    </p>
                </div>
              <%} %>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_COMPANY")) { %>
                <div class="address opportunityaddress viewleftTitle1 allswitch">
                    <p class="switch pr"><i class="switchicon switchicon2"></i><a style="cursor: pointer;" onclick="window.open('../company/ViewCompany.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);"><%=account.name %></a></p>
                    <%  var location = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(account.id);
                        if (location != null)
                        { %>
                    <p class="clear">
                        <span class="fl">地址信息</span><span class="fr"><%=country.FirstOrDefault(_=>_.val==location.country_id.ToString()).show %>
                                     &nbsp;&nbsp;
                                        <%=addressdistrict.FirstOrDefault(_=>_.val==location.province_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==location.city_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==location.district_id.ToString()).show %>
                            <br />
                            <%=location.address %>&nbsp;&nbsp;<%=location.additional_address %>&nbsp;&nbsp;<%=location.postal_code %><br />
                        </span>
                    </p>
                    <%}
                    %>
                    <p class="clear">
                        <span class="fl">电话</span><span class="fr"><%=account.phone %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">传真</span><span class="fr"><%=account.fax %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">网站</span><span class="fr"><a style="cursor: pointer;" class="linkButton" href="http://<%=account.web_site %>" target="webSite"><%=account.web_site %></a><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl"><a style="cursor: pointer;" class="linkButton" onclick="window.open('../Company/CompanySiteManage.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>','left=200,top=200,width=960,height=750', false);">站点配置</a></span>
                    </p>
                    <p class="clear">
                        <span class="fl">电话</span><span class="fr"><%=account.phone %><br />
                        </span>
                    </p>
                </div>
              <%} %>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_CONTACT")) { %>
                <%if (contact != null)
                    { %>
                <div class="address opportunityaddress viewleftTitle1 allswitch">
                    <p class="switch pr"><i class="switchicon switchicon2"></i><%=contact.name %></p>
                    <p class="clear">
                        <span class="fl">头衔</span><span class="fr"><%=contact.title %><br />
                        </span>
                    </p>
                    <%
                        if (contact.location_id != null)
                        {
                            var contactLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)contact.location_id);%>

                    <p class="clear">
                        <span class="fl">地址信息</span>
                        <%if (contactLocation != null)
                            { %>
                        <span class="fr"><%=country.FirstOrDefault(_ => _.val == contactLocation.country_id.ToString()).show %>
                                     &nbsp;&nbsp;
                                        <%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.district_id.ToString()).show %>
                            <br />
                            <%=contactLocation.address %>&nbsp;&nbsp;<%=contactLocation.additional_address %>&nbsp;&nbsp;<%=contactLocation.postal_code %><br />
                        </span>
                        <%} %>
                    </p>

                    <% }
                    %>
                    <p class="clear">
                        <span class="fl">电话</span><span class="fr"><%=contact.phone %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">备用电话</span><span class="fr"><%=contact.alternate_phone %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">移动电话</span><span class="fr"><%=contact.mobile_phone %><br />
                        </span>
                    </p>
                    <p class="clear">
                        <span class="fl">邮箱</span><span class="fr"><a style="cursor: pointer;" class="linkButton" onclick="Email（'<%=contact.email %>')"><%=contact.email %></a><br />
                        </span>
                    </p>
                </div>
                <%} %>
              <%} %>
              <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_WHO_CAN_VIEW")) { %>
                <div><a class="linkButton" style="margin-left: 10px; cursor: pointer;">可以查看这个销售订单的员工</a></div>
              <%} %>
            </div>


            <div id="ShowCompany_Right" class="activityTitleright f1">
                <%if (type.Equals("activity"))
                    { %>
                <div class="FeedHeader">
                  <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_QUICK_ADD_NOTE")) { %>
                    <div class="NewRootNote">
                        <textarea placeholder="添加一个备注..." id="insert"></textarea>
                    </div>
                    <div class="add clear">
                        <span id="WordNumber">2000</span>
                        <input type="button" id="addNote" value="添加" style="height: 24px;" />
                        <asp:DropDownList ID="noteType" runat="server" Width="100px" Height="24px">
                        </asp:DropDownList>
                        <input type="hidden" id="objectId" value="<%=sale_order.id %>" />
                    </div>
                  <%} %>
                    <div class="checkboxs clear">
                        <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ACT_TODOS")) { %>
                        <div class="clear">
                            <asp:CheckBox ID="Todos" runat="server" />
                            <label>待办</label>
                        </div>
                      <%} %>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ACT_NOTES")) { %>
                        <div class="clear">
                            <asp:CheckBox ID="Note" runat="server" />
                            <label>备注</label>
                        </div>
                      <%} %>
                      <%if (CheckAuth("CRM_SALES_ORDER_VIEW_SALES_ORDER_VIEW_ACT_TICKETS")) { %>
                        <div class="clear">
                            <asp:CheckBox ID="Tickets" runat="server" />
                            <label>工单</label>
                        </div>
                      <%} %>
                    </div>
                    <div class="addselect">
                        <div class="clear">
                            <label>排序方式：</label>
                            <asp:DropDownList ID="OrderBy" runat="server">
                                <asp:ListItem Value="2">时间从晚到早</asp:ListItem>
                                <asp:ListItem Value="1">时间从早到晚</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <hr class="activityTitlerighthr" />
                <div id='activityContent' style='margin-bottom: 10px;'>
                </div>
                <%}
                    else
                    { %>
                <iframe id="viewSaleOrder_iframe" src="<%=iframeSrc %>" style="overflow: scroll; width: 100%; height: 100%; border: 0px;"></iframe>
                <%}%>
            </div>

        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>

<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>


<script>
    $(function () {
        var isShowLeft = $("#isShowLeft").val();
        if (isShowLeft == "1") {
            $("#leftDiv").css("display", "");
        }
        else {
            $("#leftDiv").css("display", "none");
        }
        
    })

    function ChangeBookMark() {
        //$("#bookmark").removeAttr("click");
        var url = '<%=Request.Url.LocalPath %>?id=<%=sale_order?.id %>';
           var title = '查看销售订单:<%=opportunity?.name %>';
        var isBook = $("#bookmark").hasClass("Selected");
        $.ajax({
            type: "GET",
            url: "../Tools/IndexAjax.ashx?act=BookMarkManage&url=" + url + "&title=" + title,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    if (isBook) {
                        $("#bookmark").removeClass("Selected");
                    } else {
                        $("#bookmark").addClass("Selected");
                    }
                }
            }
        })
       }

    //var Height = $(window).height() - 80 + "px";
    //var Width = $(window).width() + "px";
    //$("#viewSaleOrder_iframe").css("height", Height).css("width", Width);
    //$(window).resize(function () {
    //    var Height = $(window).height() - 80 + "px";
    //    var Width = $(window).width() + "px";
    //    $("#viewSaleOrder_iframe").css("height", Height).css("width", Width);
    //});

    var Height = $(window).height() - 130 + "px";
    $("#ShowCompany_Right").css("height", Height);

    $(window).resize(function () {
        var Height = $(window).height() - 130 + "px";
        $("#ShowCompany_Right").css("height", Height);
    })
    var pageType = "salesorder";
</script>
<% if (type.Equals("activity"))
    { %>
<script src="../Scripts/ViewActivity.js"></script>
<%} %>