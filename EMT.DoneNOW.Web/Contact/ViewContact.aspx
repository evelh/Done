<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewContact.aspx.cs" Inherits="EMT.DoneNOW.Web.ViewContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查看联系人</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <form id="form1" runat="server">
        <%  
            var defaultLocation = locationBLL.GetLocationByAccountId(account.id);

            var taxRegion = dic.FirstOrDefault(_ => _.Key == "taxRegion").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var classification = dic.FirstOrDefault(_ => _.Key == "classification").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sys_resource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var competition = dic.FirstOrDefault(_ => _.Key == "competition").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var market_segment = dic.FirstOrDefault(_ => _.Key == "market_segment").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var district = dic.FirstOrDefault(_ => _.Key == "district").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var territory = dic.FirstOrDefault(_ => _.Key == "territory").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var company_type = dic.FirstOrDefault(_ => _.Key == "company_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sufix = dic.FirstOrDefault(_ => _.Key == "sufix").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var action_type = dic.FirstOrDefault(_ => _.Key == "action_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
        %>
        <div class="header">
            <i>
                <ul>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=activity">活动</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=todo">待办</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=note">备注</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=opportunity">商机</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=contactGroup">联系人组</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=ticket">工单</a></li>
                    <li><a href="ViewContact.aspx?id=<%=contact.id %>&type=configura">配置项</a></li>
                </ul>
            </i>
            联系人-<%=contact.name %>
        </div>

        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <input type="button" id="Edit" value="修改" onclick="window.open('AddContact.aspx?id=<%=contact.id %>','<%=EMT.DoneNOW.DTO.OpenWindow.ContactEdit %>','left= 200, top = 200, width = 900, height = 750', false);" />
                    <%--  <asp:Button ID="Edit" runat="server" Text="修改" BorderStyle="None" />--%>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    添加
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#" onclick="window.open('../Activity/AddActivity.aspx?contact_id=<%=account.id %>&type=todo','<%=EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>','left=200,top=200,width=900,height=750', false);">待办</a></li>
                        <li><a href="#" onclick="window.open('../Activity/AddActivity.aspx?contact_id=<%=account.id %>&type=note','<%=EMT.DoneNOW.DTO.OpenWindow.NoteAdd %>','left=200,top=200,width=900,height=750', false);">客户备注</a></li>
                        <li><a href="#" onclick="window.open('../Opportunity/OpportunityAddAndEdit.aspx?oppo_contact_id=<%=contact.id %>','<%=EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>','left=200,top=200,width=900,height=750', false);">商机</a></li>
                    </ul>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>友情链接</li>
            </ul>
        </div>


        <div class="activityTitleleft fl" id="showGeneralInformation" style="margin-left: 20px;">
            <input type="hidden" id="isHide" runat="server" value="hide" />
            <%switch (type)
                {
                    case "activity":%>
            <h1>活动-<%=contact.name %></h1>
            <%break;
                case "todo":%>
            <h1>待办-<%=contact.name %></h1>
            <%break;
                case "note":%>
            <h1>备注-<%=contact.name %></h1>
            <%break;
                    default:
                        break;
                } %>

            <div class="contact address">
                <label><%=contact.name %><%=contact.suffix_id==null?"":sufix.First(_=>_.val.ToString()==contact.suffix_id.ToString()).show  %></label>
                <%if (!string.IsNullOrEmpty(contact.title))
                    { %>
                <p class="clear">
                    <span class="fl">头衔</span>
                    <span class="fr"><%=contact.title %> </span>
                </p>
                <%} %>

                <%if (contact.location_id != null)
                    {
                        var contactLocation = locationBLL.GetLocation((long)contact.location_id);%>
                <p>
                    <span><%=country.First(_ => _.val.ToString() == contactLocation.country_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.province_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.city_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.district_id.ToString()).show  %></span>

                </p>

                <p><span><%=contactLocation.address %></span>&nbsp;<span><%=contactLocation.additional_address %></span>&nbsp;<span><%=contactLocation.address %></span></p>

                <% if (!string.IsNullOrEmpty(contactLocation.address))
                    { %>

                <p class="clear">
                    <span class="fl"><a href="#" onclick="window.open('http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=contactLocation.address %>','map','left=200,top=200,width=960,height=750', false);">地图</a></span>
                </p>
                <%} %>



                <% if (!string.IsNullOrEmpty(contactLocation.additional_address))
                    { %>
                <p><%=contactLocation.additional_address %></p>
                <%} %>

                <%} %>
                <% if (!string.IsNullOrEmpty(contact.phone))
                    { %>
                <p class="clear">
                    <span class="fl">电话</span>
                    <span class="fr"><%=contact.phone %> </span>
                </p>
                <%} %>
                <% if (!string.IsNullOrEmpty(contact.mobile_phone))
                    { %>
                <p class="clear">
                    <span class="fl">移动电话</span>
                    <span class="fr"><%=contact.mobile_phone %> </span>
                </p>
                <%} %>
                <% if (!string.IsNullOrEmpty(contact.email))
                    { %>
                <p class="clear">
                    <span class="fl">邮箱</span>
                    <span class="fr"><%=contact.email %> </span>
                </p>
                <%} %>
            </div>



            <div class="address ">
                <label><%=account.name %> <%--<span>类别图标</span> <span>自助服务台图标</span>--%></label>
                <p>
                    <span><%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %></span>
                    <span><%=defaultLocation.address %></span><span><%=defaultLocation.additional_address %></span>
                </p>


                <% if (!string.IsNullOrEmpty(defaultLocation.address))
                    { %>

                <p class="clear">
                    <span class="fl"><a href="#" onclick="window.open('http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=defaultLocation.address %>','map','left=200,top=200,width=960,height=750', false);">地图</a></span>
                </p>
                <%} %>
                <% if (!string.IsNullOrEmpty(defaultLocation.address))
                    { %>

                <%--                <p><a href="http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=defaultLocation.address %>" target="view_window"><%=defaultLocation.address %></a></p>--%>
                <%} %>

                <% if (!string.IsNullOrEmpty(defaultLocation.additional_address))
                    { %>
                <%--  <p><%=defaultLocation.additional_address %></p>--%>
                <%} %>

                <%--<p>可以根据链接，跳转到百度或其他地图，显示该客户位置</p>--%>

                <% if (account.parent_id != null)
                    { %>
                <p><a href="ViewCompany.aspx?id=<%=account.parent_id %>"><%=companyBll.GetCompany((long)account.parent_id).name %> </a></p>
                <%} %>

                <p><%=account.phone %></p>
                <p>(P) <%=defaultLocation.postal_code %></p>
                <p>(F) <%=account.fax %></p>
                <p><%=account.web_site %></p>
            </div>


            <div class="other">
                <%if (contactUDFList != null && contactUDFList.Count > 0)
                    {
                        foreach (var item in contactUDFList)
                        { %>
                <p class="clear">
                    <span class="fl"><%=item.name %> </span>
                    <span class="fr"><%=contactEDFValueList.FirstOrDefault(_=>_.id==item.id).value %></span>
                </p>

                <%}
                    }%>
                <p class="clear">
                    <span class="fl">最后活动时间 </span>
                    <span class="fr"><%=contact.last_activity_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)contact.last_activity_time).ToString("yyyy-MM-dd"):"" %></span>
                </p>
            </div>
        </div>


        <div id="ShowContact_Right" style="float: left; margin-left: 35px;" class="activityTitleright f1">
            <iframe runat="server" id="viewContact_iframe" width="800" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {

        //var targetTimes = 0;
        //// $("a").attr('target', '_blank' + targetTimes);
        //$("a").click(function () {
        //    $(this).attr('target', '_blank' + targetTimes);
        //    targetTimes = Number(targetTimes) + 1;
        //})

        var hide = $("#isHide").val();
        if (hide == "hide") {
            $("#showGeneralInformation").hide();
        }
        $("#viewContact_iframe").attr("onLoad", iFrameHeight);
    })

    // 这个方法可以使iframe适应源页面的大小
    function iFrameHeight() {
        var ifm = document.getElementById("viewContact_iframe");
        var subWeb = document.frames ? document.frames["viewContact_iframe"].document : ifm.contentDocument;
        if (ifm != null && subWeb != null) {
            ifm.height = subWeb.body.scrollHeight;
            ifm.width = subWeb.body.scrollWidth;
        }
    }


</script>
