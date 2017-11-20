<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.ViewCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>查看客户</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
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
        //  var district = dic.FirstOrDefault(_ => _.Key == "district").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
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
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACTIVITY")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=activity'"><a>活动</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_TODOS")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=todo'"><a>待办</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_NOTES")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=note'"><a>备注</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_OPPORTUNITY")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=opportunity'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=opportunity">商机</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_SALES_ORDER")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=saleOrder'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=saleOrder">销售订单</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_CONTACT")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=contact'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=contact">联系人</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_CONTACT_GROUP")) { %>
          <li>联系人组</li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_TICKETS")) { %>
          <li>工单</li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_PROJECT")) { %>
          <li>项目</li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_CONFIGURATION_ITEM")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=confirgItem'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=confirgItem">配置项</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_FINANCIAL")) { %>
          <li>财务</li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_CONTRACT")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=contract'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=contract">合同</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_INVOICE")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=invoice'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=invoice">发票</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_PREFERNCE_INVOICE")) { %>
          <li onclick="window.open('../Invoice/PreferencesInvoice.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREFERENCE %>','left=200,top=200,width=900,height=750', false);"><a>发票参数设定</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_PREFERNCE_QUOTE")) { %>
          <li onclick="window.open('../Quote/PreferencesQuote.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuotePreference %>','left=200,top=200,width=900,height=750', false);"><a>报价参数设定</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ATTACHMENT")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=attachment'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=attachment">附件</a></li>
          <%}%>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_SUBSIDIARY")) { %>
          <li onclick="window.location.href='ViewCompany.aspx?id=<%=account.id %>&type=Subsidiaries'"><a href="ViewCompany.aspx?id=<%=account.id %>&type=Subsidiaries">子客户</a></li>
          <%}%>
        </ul>
      </i>
      客户-<%=account.name %>(<%="ID:" + account.oid.ToString() %>)&nbsp;<%=account.is_active == 1 ? "激活" : "未激活" %>&nbsp;<%=account.type_id == null ? "" : company_type.FirstOrDefault(_ => _.val == account.type_id.ToString()).show %>
    </div>
    <div class="header-title" style="width:480px;">
      <ul>
        <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_EDIT_COMPANY")) { %>
        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
          <input type="button" id="Edit" value="修改" onclick="window.open('EditCompany.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyEdit %>','left= 200, top = 200, width = 960, height = 750', false);" />
        </li>
        <%}%>
        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
          <%--  <asp:Button ID="tianjia" runat="server" Text="添加" BorderStyle="None" />--%>添加
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
          <ul>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_COMPANY")) { %>
            <li onclick="window.open('AddCompany.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left=200,top=200,width=960,height=750', false);"><a href="#">客户</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_TICKETS")) { %>
            <li>工单</li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_TODOS")) { %>
            <li onclick="window.open('../Activity/Todos.aspx?accountId=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>','left=200,top=200,width=730,height=750', false);"><a href="#">待办</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_NOTES")) { %>
            <li onclick="window.open('../Activity/Notes.aspx?accountId=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.NoteAdd %>','left=200,top=200,width=730,height=750', false);"><a href="#">客户备注</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_OPPORTUNITY")) { %>
            <li onclick="window.open('../Opportunity/OpportunityAddAndEdit.aspx?oppo_account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>','left=200,top=200,width=900,height=750', false);"><a href="#">商机</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_CONTACT")) { %>
            <li onclick="window.open('../Contact/AddContact.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>','left=200,top=200,width=900,height=750', false);"><a href="#">联系人</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_SUB_COMPANY")) { %>
            <li><%if (account.parent_id == null)
                    { %>
              <a href="#" onclick="window.open('AddCompany.aspx?parent_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.Subsidiaries %>','left=200,top=200,width=900,height=750', false);">子客户</a>
              <%}
                  else
                  { %>子客户
                            <%} %>
            </li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_CONFIGURATION")) { %>
            <li onclick="window.open('../ConfigurationItem/AddOrEditConfigItem.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.AddInstalledProduct %>','left=200,top=200,width=900,height=750', false);"><a href="#">配置项</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_ATTACHMENT")) { %>
            <li onclick="window.open('../Activity/AddAttachment?objId=<%=account.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.COMPANY %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.AttachmentAdd %>','left=200,top=200,width=730,height=750', false);"><a href="#">附件</a></li>
            <%}%>
          </ul>
        </li>

        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>工具
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
          <ul>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_CLOSE_OPPORTUNITY")) { %>
            <li onclick="window.open('../Opportunity/CloseOpportunity.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityClose %>','left=200,top=200,width=900,height=750', false);"><a>关闭商机向导</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_LOSE_OPPORTUNITY")) { %>
            <li onclick="window.open('../Opportunity/LoseOpportunity.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityLose %>','left=200,top=200,width=900,height=750', false);"><a>丢失商机向导</a></li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_RESET_ACCOUNT_MANAGER")) { %>
            <li>重新分配商机所有人</li>
            <%}%>
            <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_CANCLE_COMPANY")) { %>
            <li>注销客户向导</li>
            <%}%>
            <%--<li>Microsoft word merge wizard</li>--%>
            <%--<li>Reset quick books company mapping</li>--%>
          </ul>
        </li>
        <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_REPORT")) { %>
        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
          <asp:Button ID="Report" runat="server" Text="客户报告" BorderStyle="None" /></li>
        <%}%>
        <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_FRIEND_LINK")) { %>
        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
          <asp:Button ID="LiveLink" runat="server" Text="友情链接" BorderStyle="None" /></li>
        <%}%>
      </ul>
    </div>
    <% 
        var alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(account.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);
        if (alert != null)
        { %>
    <div class="text warn"><%=alert.alert_text %></div>
    <%} %>
    <h1 style="margin-left: 10px; font-size: 15px; font-weight: bolder; color: #4F4F4F; margin-top: 10px;"><%=actType %>-<%=account.name %></h1>
    <div <%if (type == "activity" || type == "note" || type == "todo") { %> style="margin-left:280px;margin-right:10px;" <%}else{ %> style="margin-left:10px;margin-right:10px;" <% } %>>
    <div class="activityTitleleft fl" id="showCompanyGeneral" style="margin-left: -270px;">
      <input type="hidden" id="isHide" runat="server" value="hide" />
      <input type="hidden" id="objectId" value="<%=account.id %>" />
      <%-- 客户的基本信息 --%>
      <div class="address">
        <label>
          <%=account.name %>
          <%if (account.classification_id != null)
              {
                var thisClasss = new EMT.DoneNOW.DAL.d_account_classification_dal().FindNoDeleteById((long)account.classification_id);
                if (thisClasss != null)
                {
          %>
          <img src="<%=thisClasss.icon_path %>" />
          <%}
            } %>
          <%-- <span>自助服务台图标</span>--%></label>
        <p>
          <span><%=country.First(_=>_.val.ToString()==location.country_id.ToString()).show  %></span>
          <span><%=addressdistrict.First(_=>_.val.ToString()==location.province_id.ToString()).show  %></span>
          <span><%=addressdistrict.First(_=>_.val.ToString()==location.city_id.ToString()).show  %></span>
          <span><%=addressdistrict.First(_=>_.val.ToString()==location.district_id.ToString()).show  %></span>

        </p>
        <p>
          <span><%=location.address %></span>&nbsp;<span><%=location.additional_address %></span>&nbsp;<span><%=location.postal_code %> </span>
        </p>
        <% if (!string.IsNullOrEmpty(location.address))
            { %>

        <p class="clear">
          <span class="fl"><a href="#" onclick="window.open('http://map.baidu.com/?newmap=1&ie=utf-8&s=s%26wd%3D<%=location.address %>','map','left=200,top=200,width=960,height=750', false);">地图</a></span>
        </p>
        <%} %>






        <%--<p>可以根据链接，跳转到百度或其他地图，显示该客户位置</p>--%>

        <% if (account.parent_id != null)
            { %>
        <p class="clear"><a href="#" onclick="window.open('ViewCompany.aspx?id=<%=account.parent_id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.ParentCompanyView %>','left=200,top=200,width=960,height=750', false);"><%=companyBll.GetCompany((long)account.parent_id)!=null?companyBll.GetCompany((long)account.parent_id).name:"" %> </a></p>
        <%} %>

        <p><%=account.phone %></p>
        <%--<p>(P) <%=location.postal_code %></p>--%>
        <p>(F) <%=account.fax %></p>
        <p><%=account.web_site %></p>
        <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_SITE_MANAGE")) { %>
        <p><a href="#" onclick="window.open('CompanySiteManage.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>','left=200,top=200,width=960,height=750', false);">站点配置</a></p>
        <%}%>
      </div>

      <div class="viewleftTitle1">


        <p class="clear">
          <span class="fl">是否免税 </span>
          <span class="fr"><%=account.is_tax_exempt == 1 ? "是" : "否" %> </span>
        </p>




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

        <%if (account.resource_id != null)
            { %>
        <p class="clear">
          <span class="fl">客户经理 </span>
          <span class="fr"><%=sys_resource.First(_ => _.val == account.resource_id.ToString()).show %></span>
        </p>
        <%} %>
        <p class="clear">
          <span class="fl">客户ID </span>
          <span class="fr"><%=account.oid %></span>
        </p>
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
      <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_RESOURCE")) { %>
      <div class="viewleftTitle1">
        <p><a href="#" onclick="alert('暂未实现');return false;">可以查看本客户的员工</a></p>
      </div>
      <%} %>
    </div>

    <div id="ShowCompany_Right" class="activityTitleright f1">
      <%if (type.Equals("activity"))
          { %>
      <div class="FeedHeader">
        <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_ADD_NOTE")) { %>
        <div class="NewRootNote">
          <textarea placeholder="添加一个备注..." id="insert"></textarea>
        </div>
        <div class="add clear">
          <span id="WordNumber">2000</span>
          <input type="button" id="addNote" value="添加" style="height:24px;" />
          <asp:DropDownList ID="noteType" runat="server" Width="100px" Height="24px">
          </asp:DropDownList>
        </div>
        <%} %>
        <div class="checkboxs clear">
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TODOS")) { %>
          <div class="clear">
            <asp:CheckBox ID="Todos" runat="server" />
            <label>待办</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_NOTES")) { %>
          <div class="clear">
            <asp:CheckBox ID="Note" runat="server" />
            <label>备注</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_OPPORTUNITY")) { %>
          <div class="clear">
            <asp:CheckBox ID="Opportunities" runat="server" />
            <label>商机</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_SALES_ORDER")) { %>
          <div class="clear">
            <asp:CheckBox ID="SalesOrders" runat="server" />
            <label>销售单</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_TICKETS")) { %>
          <div class="clear">
            <asp:CheckBox ID="Tickets" runat="server" />
            <label>工单</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_CONTRACT")) { %>
          <div class="clear">
            <asp:CheckBox ID="Contracts" runat="server" />
            <label>合同</label>
          </div>
          <%} %>
          <%if (CheckAuth("CRM_COMPANY_VIEW_COMPANY_VIEW_ACT_PROJECT")) { %>
          <div class="clear">
            <asp:CheckBox ID="Projects" runat="server" />
            <label>项目</label>
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

      <div id='activityContent' style='margin-bottom:10px;'>

      </div>
      <%}
        else
        { %>
      <iframe src="<%=iframeSrc %>" id="viewCompany_iframe" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
      <%} %>
    </div>
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
        
  })

      var Height = $(window).height() - 130 + "px";
      $("#ShowCompany_Right").css("height", Height);

        $(window).resize(function () {
          var Height = $(window).height() - 130 + "px";
          $("#ShowCompany_Right").css("height", Height);
        })

    function iFrameHeight() {
        var ifm = document.getElementById("viewCompany_iframe");
        var subWeb = document.frames ? document.frames["viewCompany_iframe"].document : ifm.contentDocument;
        if (ifm != null && subWeb != null) {
            ifm.height = subWeb.body.scrollHeight;
            ifm.width = subWeb.body.scrollWidth;

        }
    }
    function AddCompany() {
        // var checkResult = <% %>;
    }
    var pageType = "account";
</script>

  <% if (type.Equals("activity")) { %>
    <script src="../Scripts/ViewActivity.js"></script>
  <%} %>
