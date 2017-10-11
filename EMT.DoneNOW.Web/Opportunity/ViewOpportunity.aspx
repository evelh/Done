<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewOpportunity.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.ViewOpportunity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查看商机</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min2.2.2.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <form id="form1" runat="server">

        <%
            var defaultLocation = locationBLL.GetLocationByAccountId(account.id);
            var oppportunity_status = dic.FirstOrDefault(_ => _.Key == "oppportunity_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;  // 商机状态
            var opportunity_interest_degree = dic.FirstOrDefault(_ => _.Key == "opportunity_interest_degree").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;  // 商机受欢迎程度
            var opportunity_stage = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;  // 商机阶段
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            var sufix = dic.FirstOrDefault(_ => _.Key == "sufix").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
            //  var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
        %>
        <div class="header">
            <i>
                <ul>
                    <li class="alt"><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=activity" style="color:grey;">活动</a></li>
                    <li class="alt"><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=todo"  style="color:grey;">待办</a></li>
                    <li><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=note" >备注</a></li>
                    <li class="alt"><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=ticket" style="color:grey;">工单</a></li>
                    <li class="alt"><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=att" style="color:grey;"></a>附件</li>
                    <li><a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=quoteItem">报价项</a></li>
                </ul>
            </i>
            查看商机
        </div>
        <div class="header-title">
            <ul>
                <li><a href="#" onclick="window.open('OpportunityAddAndEdit.aspx?opportunity_id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityEdit %>','left=200,top=200,width=900,height=750', false);">修改</a>

                </li>
                <li>
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    添加
					<i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#" onclick="window.open('../Activity/AddActivity.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>','left=200,top=200,width=900,height=750', false);"></a>待办</li>
                        <li><a href="#" onclick="window.open('../Activity/AddActivity.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.NoteAdd %>','left=200,top=200,width=900,height=750', false);"></a>备注</li>
                        <li>工单</li>
                        <li>附件</li>
                        <%if (quoteList == null || quoteList.Count == 0)
                            { %>
                        <li><a href="#" onclick="window.open('../Quote/QuoteAddAndUpdate?quote_opportunity_id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>','left=200,top=200,width=900,height=750', false);">报价</a></li>
                        <%} %>
                        <%-- todo 如果商机已经有报价，则不显示  CloseOpportunity--%>
                    </ul>
                </li>
                <li><a onclick="window.open('CloseOpportunity.aspx?id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityClose %>','left=200,top=200,width=900,height=750', false);">关闭商机</a></li>
                <li><a onclick="window.open('LoseOpportunity.aspx?id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityLose %>','left=200,top=200,width=900,height=750', false);">丢失商机</a></li>
                <li><a></a>LiveLink</li>
                <li><a></a>打印</li>

            </ul>
        </div>
        <%--<div class="text warn">eave these fields blank. All fields marked with a “1” apply to the Contact only.</div>--%>
        <div class="content clear savecontent" style="padding: 10px;">
            <input type="hidden" id="isHide" runat="server" value="hide" />
            <div class="activityTitleleft fl" id="showGeneralInformation">
                <%switch (type)
                    {
                        case "activity":%>
                <h1>活动-<%=opportunity.name %></h1>
                <%break;
                    case "todo":%>
                <h1>待办-<%=opportunity.name %></h1>
                <%break;
                    case "note":%>
                <h1>备注-<%=opportunity.name %></h1>
                <%break;
                        default:
                            break;
                    } %>
                <div class="opportunityWidgetMediumHigh clear">
                    <h2>距离预计完成日期天数 </h2>
                    <h3>
                        <%if (opportunity.projected_close_date != null)
                            { %>

                        <p>
                            <%=((DateTime)opportunity.projected_close_date).Subtract(DateTime.Now).Days %><br />
                            (<%=((DateTime)opportunity.projected_close_date).ToString("dd/MM/yyyy") %>)
                        </p>

                        <%} %>
					
                    </h3>
                </div>
                <div class="opportunityWidgetMediumHigh clear opportunityWidgetMediumHigh2">
                    <h2>成交概率</h2>
                    <h3>
                        <p><%=opportunity.probability %></p>
                    </h3>
                </div>
                <div class="address opportunityaddress viewleftTitle1">
                    <p class="switch pr"><i class="switchicon switchicon1"></i>商机-<%=opportunity.name %>(ID:<%=opportunity.oid %>)-<%=account.name %> </p>
                    <p class="clear">
                        <span class="fl">商机ID</span><span class="fr"><%=opportunity.oid %><br />
                        </span>
                    </p>
                    <%
                      //  var quoteList = new EMT.DoneNOW.DAL.crm_quote_dal().GetQuoteByOpportunityId(opportunity.id);
                        %>
                    <%if (quoteList!=null&&quoteList.Count>0)  // 判断报价是否存在
                        {
                            var primaryQuote = quoteList.FirstOrDefault(_ => _.is_primary_quote == 1);
                            %>
                    <p class="clear">
                         主报价:<a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=quoteItem"><%=primaryQuote.name %></a> 
                    </p>
                    <%
                            foreach (var quote in quoteList.Where(_=>_.is_primary_quote!=1))
                            {%>
                      <p class="clear">
                       <a href="ViewOpportunity.aspx?id=<%=opportunity.id %>&type=quoteItem"><%=quote.name %></a>                       
                    </p>
                            <%}
                        }
                        else
                        { %>
                    <%--<p><a href="#">这里是新增报价的链接</a></p>--%>
                    <%} %>

                    <%  if (1 == 2)    // 没有报价不显示 	有报价，无项目提案，显示“编辑报价，关联项目”，链接到主报价编辑界面，有项目提案，显示主报价的项目提案。项目提案名称  链接到项目
                        {
                    %>
                    <%}
                        else
                        {
                    %>

                    <%}
                          var totalRebenue = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoRevenue(opportunity.id);
                                var totalCost = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoCost(opportunity.id);
                        %>
                    <p class="clear"><span class="fl">毛利</span><span class="fr"><%=(totalRebenue-totalCost).ToString("#0.00") %></span></p>
                    <p class="clear"><span class="fl">创建日期</span><span class="fr"><%=opportunity.projected_close_date!=null?((DateTime)opportunity.projected_close_date).ToString("dd/MM/yyyy"):"" %>（距今<%=opportunity.projected_begin_date!=null?((DateTime)opportunity.projected_begin_date).Subtract(DateTime.Now).Days.ToString():"" %>天）  </span></p>
                    <%if (opportunity.status_id != null)
                        {%>
                    <p class="clear"><span class="fl">状态</span><span class="fr"> <%=oppportunity_status.FirstOrDefault(_=>_.val==opportunity.status_id.ToString()).show %> </span></p>

                    <%} %>
                    <%if (opportunity.interest_degree_id != null)
                        {%>
                    <p class="clear"><span class="fl">等级</span><span class="fr"> <%=opportunity_interest_degree.FirstOrDefault(_=>_.val==opportunity.interest_degree_id.ToString()).show %>  </span></p>
                    <%} %>
                    <%if (opportunity.stage_id != null)
                        {%>
                    <p class="clear"><span class="fl">阶段</span><span class="fr"> <%=opportunity_stage.FirstOrDefault(_=>_.val==opportunity.stage_id.ToString()).show %>   </span></p>
                    <%} %>
                </div>

                <div class="account address opportunityaddress viewleftTitle1 ">
                    <p class="switch pr">
                        <i class="switchicon switchicon1"></i>客户
                        <img src="../Images/at16.png" />
                      
                    </p>
                      <p><%=account.name %> (<%="ID:"+account.oid %>)&nbsp;<%=account.is_active==1?"激活":"未激活" %>&nbsp;<%--<span>类别图标</span> <span>自助服务台图标</span>--%></p>
                    <p><%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %>
                   <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %>
                  <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %>
                    <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %></p>

                           
                    <p style="display:none;"> 
                     <span><%=defaultLocation.address %></span>&nbsp;<span><%=defaultLocation.additional_address %></span>&nbsp;<span><%=defaultLocation.postal_code %> </span>
                    </p>
                <% if (!string.IsNullOrEmpty(defaultLocation.address))
                    { %>

                <p class="clear">
                    <span class="fl"><a href="#" onclick="window.open('http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=defaultLocation.address %>','map','left=200,top=200,width=960,height=750', false);">地图</a></span>
                </p>
                <%} %>

                   <%-- <% if (!string.IsNullOrEmpty(defaultLocation.address))
                        { %>

                    <p><a href="http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=defaultLocation.address %>" target="view_window"><%=defaultLocation.address %></a></p>
                    <%} %>

                    <% if (!string.IsNullOrEmpty(defaultLocation.additional_address))
                        { %>
                    <p><%=defaultLocation.additional_address %></p>
                    <%} %>--%>

                    <%--<p>可以根据链接，跳转到百度或其他地图，显示该客户位置</p>--%>

                    <% if (account.parent_id != null)
                        { %>
                    <%--<p><a href="ViewCompany.aspx?id=<%=account.parent_id %>"><%=companyBll.GetCompany((long)account.parent_id).name %> </a></p>--%>
                    <%} %>

                    <p><%=account.phone %></p>
                    <p>(P) <%=defaultLocation.postal_code %></p>
                    <p>(F) <%=account.fax %></p>
                    <p><%=account.web_site %></p>
                </div>

                <%if (contact != null)
                    {
                %>

                <div class="contact address opportunityaddress viewleftTitle1">
                    <p class="switch pr">
                        <i class="switchicon switchicon1"></i>联系人
                        <img src="../Images/at16.png" />
                          
                    </p>
                    <p><%=contact.name %><%=contact.suffix_id==null?"":sufix.First(_=>_.val.ToString()==contact.suffix_id.ToString()).show  %>|<%=contact.title %>-<%=account.name %></p>
                   <%-- <label><%=contact.name %><%=contact.suffix_id==null?"":sufix.First(_=>_.val.ToString()==contact.suffix_id.ToString()).show  %></label>--%>
                    <%if (!string.IsNullOrEmpty(contact.title))
                        { %>
                    <p class="clear">
                        <span class="fl">头衔</span>
                        <span class="fr"><%=contact.title %> </span>
                    </p>
                    <%}
                        if (contact.location_id != null)
                        {
                            var contactLocation = locationBLL.GetLocation((long)contact.location_id);
                    %>
                    <p>
                    <span><%=country.First(_ => _.val.ToString() == contactLocation.country_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.province_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.city_id.ToString()).show  %></span>
                    <span><%=addressdistrict.First(_ => _.val.ToString() == contactLocation.district_id.ToString()).show  %></span>
                        </p>
                    <% if (!string.IsNullOrEmpty(contactLocation.address))
                        { %>

                    <p><a href="http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=contactLocation.address %>" target="view_window"><%=contactLocation.address %></a></p>
                    <%} %>
                    <% if (!string.IsNullOrEmpty(contactLocation.postal_code))
                        { %>
                    <p >
                        <span class="fl">邮编</span>
                        <span class="fr"><%=contactLocation.address %> </span>
                    </p>
                    <%} %>
                    <% if (!string.IsNullOrEmpty(contactLocation.additional_address))
                        { %>
                    <p><%=contactLocation.additional_address %></p>
                    <%}
                    }%>
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

                <%} %>




                <hr class="viewleftTitle1hr" />
                <div class="viewleftTitle1">
                    <%
                        var advanced_field = dic.FirstOrDefault(_ => _.Key == "oppportunity_advanced_field").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                        if (advanced_field != null && advanced_field.Count > 0)
                        {
                            foreach (var item in advanced_field)
                            { %>
                    <%switch (item.val)
                        {
                            case "78":
                    %>
                    <p class="clear"><span class="fl"><%=item.show %></span><span class="fr"><%=opportunity.ext1!=null?opportunity.ext1.ToString():"" %></span></p>
                    <%
                            break;
                        case "79":
                    %>
                    <p class="clear"><span class="fl"><%=item.show %></span><span class="fr"><%=opportunity.ext2!=null?opportunity.ext2.ToString():"" %></span></p>
                    <%
                            break;
                        case "80":
                    %>
                    <p class="clear"><span class="fl"><%=item.show %></span><span class="fr"><%=opportunity.ext3!=null?opportunity.ext3.ToString():"" %></span></p>
                    <%
                            break;
                        case "81":
                    %>
                    <p class="clear"><span class="fl"><%=item.show %></span><span class="fr"><%=opportunity.ext4!=null?opportunity.ext4.ToString():"" %></span></p>
                    <%
                            break;
                        case "82":
                    %>
                    <p class="clear"><span class="fl"><%=item.show %></span><span class="fr"><%=opportunity.ext5!=null?opportunity.ext5.ToString():"" %></span></p>
                    <%
                            break;
                        default:
                    %>

                    <%
                            break;
                        }%>


                    <%}
                        } %>
                    <p class="clear"><span class="fl">市场情况</span><span class="fr"><%=opportunity.market %></span></p>
                    <p class="clear"><span class="fl">当期困难</span><span class="fr"><%=opportunity.barriers %></span></p>
                    <p class="clear"><span class="fl">所需帮助</span><span class="fr"><%=opportunity.help_needed %></span></p>
                    <p class="clear"><span class="fl">后续跟进</span><span class="fr"><%=opportunity.next_step %></span></p>
                    <p class="clear"><span class="fl">主要产品</span><span class="fr"><%=opportunity.primary_product_id==null?"":opportunity.primary_product_id.ToString() %></span></p>


                </div>
                <hr class="viewleftTitle1hr" />

                <div class="viewleftTitle1">
                    <p class="clear"><a href="javaScript:">谁可以看到</a></p>
                </div>
            </div>

            <div id="ShowOpportunity_Right" style="float: left; margin-left: 35px;width:100%" class="activityTitleright f1">
                <iframe runat="server" id="viewOpportunity_iframe" width="100%;" height="100%" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>

<script>
    $(function () {
        //var targetTimes = 0;  
        //$("a").click(function () {
        //    $(this).attr('target', '_blank' + targetTimes);
        //    targetTimes = Number(targetTimes) + 1;
        //})

        var hide = $("#isHide").val();
        if (hide == "hide") {
            $("#showGeneralInformation").hide();
        }
        $("#viewOpportunity_iframe").attr("onLoad", iFrameHeight());


    })

    // 这个方法可以使iframe适应源页面的大小
    function iFrameHeight() {
        //alert(1);
        var ifm = document.getElementById("viewOpportunity_iframe");
        var subWeb = document.frames ? document.frames["viewOpportunity_iframe"].document : ifm.contentDocument;
        if (ifm != null && subWeb != null) {
            ifm.height = subWeb.body.height;
            // ifm.width = subWeb.body.;
        }
    }

    $(".alt").on("click", function () {
         alert("暂未实现");
    })
</script>
