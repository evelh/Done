<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.ViewCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查看客户</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <form id="form1" runat="server">

        <%  var account = GetAccount();
            var location = GetDefaultLocation();
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
                    <li>活动</li>
                    <li>待办</li>
                    <li>备注</li>
                    <li><a href="ViewCompany.aspx?id=<%=account.id %>&type=opportunity"  target="view_window1">商机</a></li>
                    <li>销售订单</li>
                    <li><a href="ViewCompany.aspx?id=<%=account.id %>&type=contact"  target="view_window2">联系人</a></li>
                    <li>联系人组</li>
                    <li>工单</li>
                    <li>项目</li>
                    <li>配置项</li>
                    <li>financials财务</li>
                    <li>合同</li>
                    <li>发票</li>
                    <li>Invoice发票参数设定</li>
                    <li>Quote reference报价参数设定</li>
                    <li>附件</li>
                    <li><a href="ViewCompany.aspx?id=<%=account.id %>&type=Subsidiaries"  target="view_window">子客户</a></li>
                </ul>
            </i>
            客户-<%=account.name %>
        </div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" id="Edit" value="修改" onclick="window.open('EditCompany.aspx?id=<%=account.id %>');"/>
                   <%-- <asp:Button ID="Edit" runat="server" Text="修改" BorderStyle="None" OnClientClick="" />--%>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    <asp:Button ID="tianjia" runat="server" Text="添加" BorderStyle="None" />
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="AddCompany.aspx"  target="view_window">客户</a></li>
                        <li>工单</li>
                        <li>待办</li>
                        <li>客户备注</li>
                        <li><a href="../Opportunity/OpportunityAddAndEdit.aspx?account_id=<%=account.id %>" target="view_window">商机</a></li>
                        <li><a href="../Contact/AddContact.aspx?parent_id=<%=account.id %>" target="view_window">联系人</a></li>
                        <li><a href="AddCompany.aspx?parent_id=<%=account.id %>" target="view_window">子客户</a></li>
                        <li>配置项</li>
                        <li>附件</li>
                    </ul>
                </li>

                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                    <asp:Button ID="Tools" runat="server" Text="工具" BorderStyle="None" />
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li>关闭商机向导</li>
                        <li><a href="../Opportunity/LoseOpportunity.aspx?account_id=<%=account.id %>">丢失商机向导</a></li>
                        <li>重新分配商机所有人</li>
                        <li>注销客户向导</li>
                        <li>Microsoft word merge wizard</li>
                        <%--<li>Reset quick books company mapping</li>--%>
                    </ul>
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="Report" runat="server" Text="客户报告" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="LiveLink" runat="server" Text="友情链接" BorderStyle="None" /></li>
            </ul>
        </div>
        <div class="text warn">离开这些领域的空白。所有标有“1”的字段只适用于联系人。</div>

        <div class="activityTitleleft fl" id="showCompanyGeneral" style="margin-left:20px;">
            <input type="hidden" id="isHide" runat="server" value="hide"/>
            <input type="hidden" id="activetytype" runat="server" value=""/>
            <%-- 客户的基本信息 --%>
            <h1 id="acType"><%=account.name %>活动</h1>
            <div class="address ">
                <label><%=account.name %> <span>类别图标</span> <span>自助服务台图标</span></label>
                <p><%=country.First(_=>_.val.ToString()==location.country_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.province_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.city_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.district_id.ToString()).show  %></p>

                <% if (!string.IsNullOrEmpty(location.address))
                    { %>
                
                 <p><a href="http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=location.address %>"  target="view_window"><%=location.address %></a></p>
                <%} %>

                 <% if (!string.IsNullOrEmpty(location.postal_code))
                    { %>
                 <span class="fl">邮编</span>
                 <span class="fr"><%=location.address %> </span>
               
                <%} %>
                <% if (!string.IsNullOrEmpty(location.additional_address))
                    { %>
                <p><%=location.additional_address %></p>
                <%} %>
               
                <%--<p>可以根据链接，跳转到百度或其他地图，显示该客户位置</p>--%>

                <% if (account.parent_id != null)
                    { %>
                <p><a href="ViewCompany.aspx?id=<%=account.parent_id %>"><%=companyBll.GetCompany((long)account.parent_id).name %> </a></p>
                <%} %>

                <p><%=account.phone %></p>
                <p>(P) <%=location.postal_code %></p>
                <p>(F) <%=account.fax %></p>
                <p><%=account.web_site %></p>
            </div>

            <div class="viewleftTitle1">
                <%if (account.is_tax_exempt != null)
                    { %>

                <p class="clear">
                    <span class="fl">是否免税 </span>
                    <span class="fr"><%=account.is_tax_exempt == 1 ? "是" : "否" %> </span>
                </p>

                <%} %>


                <%if (account.tax_region_id != null)
                    { %>

                <p class="clear">
                    <span class="fl">税区 </span>
                    <span class="fr"><%=taxRegion.FirstOrDefault(_=>_.val==account.tax_region_id.ToString()).show %></span>
                </p>

                <%} %>

                <%if (!string.IsNullOrEmpty(account.tax_identification))
                    { %>
                <p class="clear">
                    <span class="fl">税号 </span>
                    <span class="fr"><%=account.tax_identification %></span>
                </p>
                <%} %>
               
            </div>
            <hr class="viewleftTitle1hr" />
            <div class="viewleftTitle1">
                <%if (!string.IsNullOrEmpty(account.no))
                    { %>

                <p class="clear">
                    <span class="fl">客户编号 </span>
                    <span class="fr"><%=account.no %></span>
                </p>

                <%} %>


                <p class="clear">
                    <span class="fl">客户经理 </span>
                    <span class="fr"><%=sys_resource.First(_=>_.val == account.resource_id.ToString()).show %></span>
                </p>
             <%--   <p class="clear">
                    <span class="fl">客户ID </span>
                    <span class="fr"><%=account.account_id %></span>
                </p>--%>
                <% var primary_contact = GetDefaultContact();
                    if (primary_contact != null)
                    {%>

                <p class="clear">
                    <span class="fl">主要联系人 </span>
                    <span class="fr"><%=primary_contact.name %></span>

                </p>

                <%} %>


                <%if (account.territory_id != null)
                    { %>

                <p class="clear">
                    <span class="fl">地域 </span>
                    <span class="fr"><%=territory.First(_=>_.val==account.territory_id.ToString()).show %></span>

                </p>
                <%} %>



                <%if (account.market_segment_id != null)
                    { %>

                <p class="clear">
                    <span class="fl">市场领域 </span>
                    <span class="fr"><%=market_segment.First(_=>_.val==account.market_segment_id.ToString()).show %></span>
                </p>
                <%} %>
            </div>
            <hr class="viewleftTitle1hr" />

<%--            <div class="viewleftTitle1">
            </div>
            <div id="Group" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;"> /* -- todo 群组头像 */
           
                <hr />

            </div>--%>

            <div class="viewleftTitle1">
                <p class="clear">
                    有效商机总值
                </p>
                <p class="clear">
                    关闭商机总值
                </p>
                <%if (account.asset_value != null)
                    { %>
                <p class="clear">
                    <span class="fl">市值 </span>
                    <span class="fr"><%=account.asset_value %></span>
                </p>
                <%} %>

                <%if (account.competitor_id != null)
                    { %>
                <p class="clear">
                    <span class="fl">竞争对手 </span>
                    <span class="fr"><%=competition.First(_=>_.val==account.competitor_id.ToString()).show %></span>
                </p>
                <%} %>

                <%if (!string.IsNullOrEmpty(account.alternate_phone1))
                    { %>
                <p class="clear">
                    <span class="fl">备用电话1 </span>
                    <span class="fr"><%=account.alternate_phone1%></span>
                </p>
                <%} %>
                <%if (!string.IsNullOrEmpty(account.alternate_phone2))
                    { %>
                <p class="clear">
                    <span class="fl">备用电话2 </span>
                    <span class="fr"><%=account.alternate_phone2%></span>
                </p>
                <%} %>
                <%if (account.last_activity_time != null)
                    { %>
                <p class="clear">
                    <span class="fl">最后活动时间 </span>
                    <span class="fr"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)account.last_activity_time).ToString("yyyy-MM-dd") %></span>
                </p>
                <%} %>

                <%if (!string.IsNullOrEmpty(account.sic_code))
                    { %>
                <p class="clear">
                    <span class="fl">客户股票代码 </span>
                    <span class="fr"><%=account.sic_code %></span>
                </p>
                <%} %>

                
                <%if (!string.IsNullOrEmpty(account.stock_market))
                    { %>
                <p class="clear">
                    <span class="fl">客户股票市场 </span>
                    <span class="fr"><%=account.stock_market %></span>
                </p>
                <%} %>

                <p>客户标准产业分类代码</p>            
            </div>
             <hr class="viewleftTitle1hr" />
             <div class="viewleftTitle1">  
                <p>可以查看本客户的员工</p>
             </div>
        </div>

        <div id="ShowCompany_Right" class="activityTitleright f1" style="float: left; margin-left: 35px;">
            
        <iframe runat="server" id="viewCompany_iframe" width="800" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" >

        </iframe>
        
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

        var hide = $("#isHide").val();
        if (hide == "hide") {
            $("#showCompanyGeneral").hide();
        }
        $("#viewCompany_iframe").attr("onLoad", iFrameHeight);
        var type = $("#activetytype").val();
        if (type == "activity") {
            $("#acType").text("活动");
        } else if (type == "note") {
            $("#acType").text("备注");
        } else if (type == "todo") {
            $("#acType").text("待办");
        }
    })

    function iFrameHeight() {
        var ifm = document.getElementById("viewCompany_iframe");
        var subWeb = document.frames ? document.frames["viewCompany_iframe"].document : ifm.contentDocument;
        if (ifm != null && subWeb != null) {
            ifm.height = subWeb.body.scrollHeight;
            ifm.width = subWeb.body.scrollWidth;
            
        }
    } 


</script>
