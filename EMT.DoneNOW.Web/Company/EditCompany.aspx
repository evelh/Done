﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.EditCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>修改客户-<%=account?.name %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
        <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <style>
        #addressManage th {
            text-align: center;
        }
       .grid{margin:0 5px 0 5px;}
       .grid tr th{background-color:#cbd9e4;}
        .grid tbody td, .grid tr th{
            border-width: 1px;
            border-style: solid;
            border-left-color: #F8F8F8;
            border-right-color: #F8F8F8;
            border-top-color: #e8e8e8;
            border-bottom-color: #e8e8e8;
            padding: 4px 4px 4px 4px;
            vertical-align: top;
            word-wrap: break-word;
            font-size: 12px;
            color: #333;
        }
          .BookmarkButton {
    cursor: pointer;
    display: inline-block;
    height: 16px;
    position: relative;
    width: 16px;
    float:right;
    margin-top: 8px;
}
             .BookmarkButton.Selected div {
    border-color: #f9d959;
}
        .BookmarkButton>.LowerLeftPart {
    border-right-width: 8px;
    border-bottom-width: 6px;
    border-left-width: 8px;
    top: 5px;
    -moz-transform: rotate(35deg);
    -webkit-transform: rotate(35deg);
    -ms-transform: rotate(35deg);
    transform: rotate(35deg);
}
        .BookmarkButton>.LowerRightPart {
    border-right-width: 8px;
    border-bottom-width: 6px;
    border-left-width: 8px;
    top: 5px;
    -moz-transform: rotate(-35deg);
    -webkit-transform: rotate(-35deg);
    -ms-transform: rotate(-35deg);
    transform: rotate(-35deg);
}
        .BookmarkButton>div.LowerLeftPart, .BookmarkButton>div.LowerRightPart, .BookmarkButton>div.UpperPart {
    border-left-color: transparent;
    border-right-color: transparent;
    border-style: solid;
    border-top: none;
    height: 0;
    position: absolute;
    width: 0;
}
        .BookmarkButton>.UpperPart {
    border-bottom-width: 6px;
    border-left-width: 3px;
    border-right-width: 3px;
    left: 5px;
    top: 1px;
}
   
    </style>
</head>
<body>
    <form id="EditCompany" runat="server">
        <div class="header">修改客户 <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> " onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div></div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" BorderStyle="None" />
                </li>
              <%if (CheckAuth("CRM_COMPANY_EDIT_COMPANY_DELETE_COMPANY")) { %>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -64px 0;" class="icon-1"></i>
                    <asp:Button ID="delete" runat="server" Text="删除" OnClick="delete_Click" BorderStyle="None" />
                </li>
              <%} %>
                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    关闭
                </li>
            </ul>
        </div>


        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规</li>
                <li id="Location">地址信息</li>
                <li id="Additional">附加信息</li>
                <li id="UserDefined">用户自定义</li>
                <li id="Subsidiaries">子客户</li>
                <li id="SiteConfiguration">站点配置</li>
                <li id="Alerts">提醒</li>
            </ul>
        </div>
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:132px;">
        <div class="content clear" id="EditGeneral">

            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">

                <tr>
                    <td>
                        <div class="clear">
                            <label>客户名称<span class="red">*</span></label>
                            <input type="hidden" name="id" id="id" value="<%=account.id %>"/>
                            <asp:TextBox ID="company_name" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>
                        <div class="clear">
                            <label>是否激活<span class="red">*</span></label>


                            <% if (account.is_active == 1)
                                { %>
                            <input type="checkbox" name="is_active" data-val="1" value="1" checked="checked" />
                            <%}
                                else
                                { %>
                            <input type="checkbox" name="is_active" data-val="1" value="1" />
                            <%} %>
                            <%--<asp:CheckBox ID="isactive" runat="server" />--%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户编号</label>
                            <asp:TextBox ID="CompanyNumber" runat="server" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" ></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>国家<span class=" red">*</span></label>
                            <input id="country_idInit" value='1' type="hidden" runat="server" />
                            <select name="country_id" id="country_id">
                                  <% if (counList != null && counList.Count > 0) {
                                                foreach (var coun in counList)
                                                {%>
                                         <option value="<%=coun.id %>" <%if (location != null && location.country_id == coun.id) {%> selected="selected" <%} %>  ><%=coun.country_name_display %></option>
                                                <%}
                                            } %>
                                       
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>省份<span class=" red">*</span></label>
                            <input id="province_idInit" value='' type="hidden" runat="server" />
                            <select name="province_id" id="province_id">
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>城市<span class=" red">*</span></label>
                            <input id="city_idInit" value='' type="hidden" runat="server" />
                            <select name="city_id" id="city_id">
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>区县<span class=" red">*</span></label>
                            <input id="district_idInit" value='' type="hidden" runat="server" />
                            <select name="district_id" id="district_id">
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>
                                地址<span class="red">*</span>
                            </label>
                            <asp:TextBox ID="address" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>地址附加信息<span class="num"></span></label>
                            <asp:TextBox ID="AdditionalAddress" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <%--      <tr>
                    <td>
                        <div class="clear">
                            <label>是否是默认地址<span class="num"></span></label>
                            <asp:DropDownList ID="is_default" runat="server">
                                <asp:ListItem Value="1">默认地址</asp:ListItem>
                                <asp:ListItem Value="0">     </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>--%>
                <tr>
                    <td>
                        <div class="clear">
                            <label>邮编<span class="num"></span></label>
                            <asp:TextBox ID="postal_code" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>电话<span class=" red">*</span></label>
                            <asp:TextBox ID="Phone" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>备用电话1</label>
                            <asp:TextBox ID="AlternatePhone1" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>备用电话2</label>
                            <asp:TextBox ID="AlternatePhone2" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>传真<span class="red"></span></label>
                            <asp:TextBox ID="Fax" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>官网</label>
                            <asp:TextBox ID="WebSite" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>是否接受问卷调查<span class="red">*</span></label>
                            <asp:CheckBox ID="is_optoutSurvey" runat="server" />

                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>全程距离</label>
                            <asp:TextBox ID="mileage" runat="server" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户类型<span class="red">*</span></label>
                            <asp:DropDownList ID="CompanyType" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户类别<span class="red"></span></label>
                            <asp:DropDownList ID="classification" runat="server" AutoPostBack="False">
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户经理<span class="red">*</span></label>
                          
                          <%if (!CheckAuth("SEARCH_COMPANY_RESET_ACCOUNT_MANAGER")) { %> 
                            <input type="hidden" name="AccountManger" value="<%=account.resource_id %>" />
                          <select disabled="disabled">
                            <option><%=new EMT.DoneNOW.BLL.UserResourceBLL().GetResourceById((long)account.resource_id).name %></option>
                          </select>
                          <%} else { %>
                            <asp:DropDownList ID="AccountManger" runat="server"></asp:DropDownList>
                          <%} %> 
                        </div>
                    </td>
                </tr>
             <%--   <tr>
                    <td>
                        <div class="clear">
                            <label>客户小组</label>
                        </div>
                    </td>
                </tr>--%>
                <tr>
                    <td>
                        <div class="clear">
                            <label>地域<span class="red"></span></label>
                            <asp:DropDownList ID="TerritoryName" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>市场领域</label>
                            <asp:DropDownList ID="MarketSegment" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>竞争对手<span class="red"></span></label>
                            <asp:DropDownList ID="Competitor" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>是否免税<%--<span class="red">*</span>--%></label>
                            <asp:CheckBox ID="Tax_Exempt" runat="server" />


                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>税区<span class="num"></span></label>
                            <asp:DropDownList ID="TaxRegion" runat="server">
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>税号<span class="num"></span></label>
                            <asp:TextBox ID="TaxId" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>父客户名称</label>
                            <asp:TextBox ID="ParentComoanyName" runat="server"></asp:TextBox>
                            <i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>

                            <input type="hidden" id="ParentComoanyNameHidden" name="parent_company_name" value="<%=account.parent_id %>" />
                        </div>
                    </td>
                </tr>
            </table>

        </div>
        <%--// location_list--%>
        <div class="content clear" style="display: none;margin-right:10px;" id="locationManage">
            <a href="#" style="margin-left: 10px;" onclick="window.open('LocationManage.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.LocationAdd %>','left=200,top=200,width=900,height=750', false);">新增地址</a>
            <table style="text-align: center;" class="table table-hover grid" id="addressManage">
                <tr style="text-align: center;">
                    <th>地址类型</th>
                    <th>国家</th>
                    <th>省份</th>
                    <th>城市</th>
                    <th>区县</th>
                    <th>地址</th>
                    <th>地址附加信息</th>
                    <th>邮编</th>
                    <th>标签</th>
                    <th>默认地址</th>
                    <th>操作</th>
                </tr>
                <% var location_cate = dic.FirstOrDefault(_ => _.Key == "").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                    var district = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                    var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
                %>
                <%if (location_list != null && location_list.Count > 0)
                    {
                        foreach (var location in location_list)
                        {%>
                <tr>
                    <% if (location_cate != null)
                        {%>
                    <td><%=location_cate.FirstOrDefault(_ => _.val == location.cate_id.ToString()).show %></td>
                    <%}
                        else
                        { %>
                    <td></td>
                    <%} %>
                    <td><%=country.FirstOrDefault(_=>_.val == location.country_id.ToString()).show %></td>
                    <td><%=district.FirstOrDefault(_=>_.val == location.province_id.ToString()).show %></td>
                    <td><%=district.FirstOrDefault(_=>_.val == location.city_id.ToString()).show %></td>
                    <td><%=district.FirstOrDefault(_=>_.val == location.district_id.ToString()).show %></td>
                    <td><%=location.address %></td>
                    <td><%=location.additional_address %></td>
                    <td><%=location.postal_code %></td>
                    <td><%=location.location_label %></td>
                    <td><%=location.is_default==1?"是":"否" %></td>
                    <%if (location.is_default != 1)
                        { %>
                    <td><a href="#" onclick="window.open('LocationManage.aspx?id=<%=location.id %>&account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.LoactionEdit %>','left=200,top=200,width=900,height=750', false);">修改</a> <a href="#" onclick="deleteLocation(<%=location.id %>)">删除</a></td>
                    <%}
                        else
                        { %>
                    <td><a href="#" onclick="window.open('LocationManage.aspx?id=<%=location.id %>&account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.LoactionEdit %>','left=200,top=200,width=900,height=750', false);">修改</a></td>
                    <%} %>
                </tr>
                <% }%>
                <%} %>
            </table>
        </div>

        <div class="content clear" style="display: none;">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                <tr>
                    <td>
                        <div class="clear">
                            <label>股票代码<span class="red"></span></label>
                            <asp:TextBox ID="stock_symbol" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>股票市场<span class="red"></span></label>
                            <asp:TextBox ID="stock_market" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>Sic代码<span class="red"></span></label>
                            <asp:TextBox ID="sic_code" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户资产价值<span class="red"></span></label>
                            <asp:TextBox ID="asset_value" runat="server" CssClass="Number"  onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>新浪微博地址<span class="red"></span></label>
                            <asp:TextBox ID="weibo_url" runat="server"></asp:TextBox>
                            <%--<img src="../Images/open.png" class="Jump" style="width:20px;height:20px;"/>--%>
                            <input type="button" class="Jump" value="跳转" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>微信订阅号<span class="red"></span></label>
                            <asp:TextBox ID="wechat_mp_subscription" runat="server"></asp:TextBox>
                            <input type="button" class="Jump" value="跳转" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>微信服务号<span class="red"></span></label>
                            <asp:TextBox ID="wechat_mp_service" runat="server"></asp:TextBox>
                            <input type="button" class="Jump" value="跳转" />
                        </div>
                    </td>
                </tr>
            </table>

        </div>


        <div class="content clear" style="display: none;">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">

                          <%
                              bool canEdit = false;
                              bool canView = false;
                              bool editP = CheckAuth("EDIT_COMPANY_PROTECT_UDF");
                              bool editUP = CheckAuth("EDIT_COMPANY_UNPROTECT_UDF");
                              bool viewP = CheckAuth("VIEW_COMPANY_PROTECT_UDF");
                              bool viewUP = CheckAuth("VIEW_COMPANY_UNPROTECT_UDF");
                              %>

                <% if (company_udfList != null && company_udfList.Count > 0)
                    {

                        foreach (var udf in company_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>

                          <%
                              canEdit = false;
                              canView = false;
                              if (udf.is_protected==1 && editP)
                                canEdit = true;
                              if (udf.is_protected==1 && viewP)
                                canView = true;
                              if (udf.is_protected==0 && editUP)
                                canEdit = true;
                              if (udf.is_protected==0 && viewUP)
                                canView = true;
                              %>

                          <%if (!canView) { %>
                          <input type="text" readonly="readonly" value="****" /><input type="hidden" name="<%=udf.id %>" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} else { %>
                          <input type="text" name="<%=udf.id %>" <%if (!canEdit) { %> readonly="readonly" <%} %> class="sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} %>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                          <%
                              canEdit = false;
                              canView = false;
                              if (udf.is_protected==1 && editP)
                                canEdit = true;
                              if (udf.is_protected==1 && viewP)
                                canView = true;
                              if (udf.is_protected==0 && editUP)
                                canEdit = true;
                              if (udf.is_protected==0 && viewUP)
                                canView = true;
                              %>

                          <%if (!canView) { %>
                          <textarea readonly="readonly" rows="2" cols="20">****</textarea><input type="hidden" name="<%=udf.id %>" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} else { %>
                            <textarea name="<%=udf.id %>" <%if (!canEdit) { %> readonly="readonly" <%} %> rows="2" cols="20"><%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %></textarea>
                            <%} %>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                          <%
                              canEdit = false;
                              canView = false;
                              if (udf.is_protected==1 && editP)
                                canEdit = true;
                              if (udf.is_protected==1 && viewP)
                                canView = true;
                              if (udf.is_protected==0 && editUP)
                                canEdit = true;
                              if (udf.is_protected==0 && viewUP)
                                canView = true;
                              %>

                          <%if (!canView) { %>
                          <input type="text" readonly="readonly" value="****" /><input type="hidden" name="<%=udf.id %>" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} else { %>
                          <input type="text" name="<%=udf.id %>" <%if (!canEdit) { %> readonly="readonly" <%}else { %> onclick="WdatePicker()"  <%} %> class="sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} %>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                          <%
                              canEdit = false;
                              canView = false;
                              if (udf.is_protected==1 && editP)
                                canEdit = true;
                              if (udf.is_protected==1 && viewP)
                                canView = true;
                              if (udf.is_protected==0 && editUP)
                                canEdit = true;
                              if (udf.is_protected==0 && viewUP)
                                canView = true;
                              %>
                          <%if (!canView) { %>
                          <input type="text" readonly="readonly" value="****" /><input type="hidden" name="<%=udf.id %>" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} else { %>
                          <input type="text" name="<%=udf.id %>" <%if (!canEdit) { %> readonly="readonly" <%} %> class="sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />
                            <%} %>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>
                   <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <label><%=udf.name %></label>
                                        <select name="<%=udf.id %>">
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (company_udfValueList!=null&&company_udfValueList.Count>0&&company_udfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = company_udfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                   
                                                foreach (var thisValeList in udf.value_list)
                                                {%>
                                            <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                            <%
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                <%}
                        }
                    } %>
            </table>

        </div>



        <div class="content clear" style="display: none;">
       
            <p style="padding-left:60px;overflow:hidden;">
                <span class="fl">子客户列表</span>
                <span class="on fl" style="margin-left:8px;"><i class="icon-dh" onclick="OpenSubCompany()"></i></span>
            </p>
            <div class="Selected fl" style="padding-left:45px;">
                <select id="" multiple="" class="dblselect" style="height: 300px;">
                    <%var subIds = "";
                        if (subCompanyList != null && subCompanyList.Count > 0)
                        {
                            foreach (var subCompany in subCompanyList)
                            {
                                subIds += subCompany.id.ToString() + ",";
                                %>
                    <option value="<%=subCompany.id %>" ondblclick="Adddbclick(this);"><%=subCompany.name %></option>
                    <%}
                            subIds = subIds == "" ? "" : subIds.Substring(0,subIds.Length-1);
                        }%>
                </select>
            </div>
        
                 <input type="hidden" id="SubCompany" />
            <input type="hidden" id="SubCompanyHidden" name="SubCompanyHidden" value="<%=subIds %>" />
         
        </div>
        <% //子公司 预留  %>


        <div class="content clear" style="display: none;">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">


                <% if (site_udfList != null && site_udfList.Count > 0)
                    {

                        foreach (var udf in site_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <textarea name="<%=udf.id %>" rows="2" cols="20"><%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=site_udfValueList.FirstOrDefault(_=>_.id==udf.id)!=null?site_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>
                     <tr>
                                <td>
                                    <div class="FieldLabels">
                                        <label><%=udf.name %></label>
                                        <select name="<%=udf.id %>">
                                            <%if (udf.required != 1)
                                            { %>
                                            <option></option>
                                            <%} %>
                                            <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                {
                                                    var thisValue = "";
                                                    if (site_udfValueList!=null&&site_udfValueList.Count>0&&site_udfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                    {
                                                        thisValue = site_udfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                    }
                                                   
                                                foreach (var thisValeList in udf.value_list)
                                                {%>
                                            <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                            <%
                                                    }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                <%}
                        }
                    } %>
            </table>

        </div>
        <% //站点信息 预留   %>


        <div class="content clear" style="display: none;">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 25px;">
                <tr>
                    <td>
                        <div class="clear">
                            <label style="width:670px;text-align:center;">客户信息提示<span class="red"></span></label>
                            <asp:TextBox ID="Company_Detail_Alert" runat="server" Rows="5" Width="670" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible;margin-left:0;"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label style="width:670px;text-align:center;">新建工单提示<span class="red"></span></label>
                            <asp:TextBox ID="New_Ticket_Alert" runat="server" Rows="5" Width="670" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible;margin-left:0;"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label style="width:670px;text-align:center;">工单信息提示<span class="red"></span></label>
                            <asp:TextBox ID="Ticket_Detail_Alert" runat="server" Rows="5" Width="670" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible;margin-left:0;"></asp:TextBox>

                        </div>
                    </td>
                </tr>
            </table>

        </div>
            </div>



    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<%--<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>--%>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        InitArea();
    });
</script>
<script type="text/javascript">
    $(function () {

        <%if (!string.IsNullOrEmpty(Request.QueryString["loaction"]))
         { %>
        window.document.getElementById('locationManage').style.display = ''; window.document.getElementById('EditGeneral').style.display = 'none';
        $("#Location").addClass("boders");
        $("#general").removeClass("boders")
        <% }%>

        //var targetTimes = 0;
        //// $("a").attr('target', '_blank' + targetTimes);
        //$("a").click(function () {
        //    $(this).attr('target', '_blank' + targetTimes);
        //    targetTimes = Number(targetTimes) + 1;
        //})

        var old_company_type = $("#CompanyType").find("option:selected").text();

        $("#Tax_Exempt").click(function () {

            if ($('#Tax_Exempt').is(':checked')) {
                // 禁用
                $("#TaxRegion").attr("disabled", "disabled");

            }
            else {
                // 解除禁用
                $("#TaxRegion").removeAttr("disabled");
            }
        });  // 选中免税，税区不可在进行编辑的事件处理

        $("#save_close").click(function () {
            var companyName = $("#company_name").val();          //  公司名称--必填项校验
            if (companyName == null || companyName == '') {
                alert("请输入客户名称");
                // alert(companyName);
                return false;
            }
            var phone = $("#Phone").val();                        //  电话-- 必填项校验
            if (phone == null || phone == '') {
                alert("请输入电话名称");
                return false;
            }
            //if (!checkPhone(phone)) {
            //    alert("请输入正确格式的电话！");
            //    return false;
            //}
            var firstName = $("#first_name").val();                                  // 姓
            var lastName = $("#last_name").val();                                    // 名
            var country = $("#country_id").val();                                      // 国家
            var province = $("#province_id").val();                                    // 省份
            var city = $("#City").val();                                            // 城市
            if (country == 0 || province == 0 || city == 0) {
                alert("请填写选择地址");                                           // 地址下拉框的必填校验
                return false;
            }
            var address = $("#address").val();                                      // 地址信息
            if (address == null || address == '') {
                alert("请完善地址信息");                                              // 地址的必填校验
                return false;
            }
            var CompanyType = $("#CompanyType").val();
            if (CompanyType == 0) {
                alert("请选择客户类型");
                return false;
            }

            var AccountManger = $("#AccountManger").val();
            if (AccountManger == 0) {
                alert("请选择客户经理");
                return false;
            }


            // 邮编验证
            var postal_code = $("#postal_code").val();
            //alert(Trim(email, 'g'));
            if (postal_code != '') {
                if (!checkPostalCode(postal_code)) {
                    alert("请输入正确的邮编！");
                    return false;
                }
            }

            var company = $("#CompanyType").find("option:selected").text();

            if (old_company_type == '客户' && company != '客户') {
                var msg = "如果修改为新的客户类型，相关联系人将不能登录自助服务台，是否继续？";
                if (!confirm(msg)) {
                    return false;
                }

            }

        });   // 保存并关闭的事件

        $("#close").click(function () {
            if (navigator.userAgent.indexOf("MSIE") > 0) {
                if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                    window.opener = null;
                    window.close();
                } else {
                    window.open('', '_top');
                    window.top.close();
                }
            }
            else if (navigator.userAgent.indexOf("Firefox") > 0) {
                window.location.href = 'about:blank ';
            } else {
                window.opener = null;
                window.open('', '_self', '');
                window.close();
            }
        });  // 直接关闭窗口


        $(".Jump").click(function () {
            $("a").attr("target", "_blank");
            var url = $(this).prev().val();
            window.open("http://" + url,"_blank");
        })
        var conteneClickTimes = 0;       // 定义tab页跳转点击次数，免得一直提醒
        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {

                if ($(this).attr("id") != "general") {
                    var companyName = $("#company_name").val();
                    if (companyName == "") {
                        alert("请输入客户名称");
                        return false;
                    }
                    var country = $("#country_id").val();
                    if (country == 0) {
                        alert("请选择国家");
                        return false;
                    }
                    var province = $("#province_id").val();
                    if (province == 0) {
                        alert("请选择省份");
                        return false;
                    }
                    var city = $("#city_id").val();
                    if (city == 0) {
                        alert("请选择城市");
                        return false;
                    }
                    var district = $("#district_id").val();
                    if (district == 0) {
                        alert("请选择区县");
                        return false;
                    }
                    var address = $("#address").val();
                    if (address == "") {
                        alert("请输入地址");
                        return false;
                    }
                    var phone = $("#Phone").val();
                    if (phone == "") {
                        alert("请输入电话");
                        return false;
                    }
                    var companytype = $("#CompanyType").val();
                    if (companytype == 0) {
                        alert("请选择公司类型");
                        return false;
                    }
                    var accountManger = $("#AccountManger").val();
                    if (accountManger == 0) {
                        alert("请选择客户经理");
                        return false;
                    }

                    $(this).addClass("boders").siblings("li").removeClass("boders");
                    $(".content").eq(i).show().siblings(".content").hide();

                }
                else {
                    $(this).addClass("boders").siblings("li").removeClass("boders");
                    $(".content").eq(i).show().siblings(".content").hide();
                }




            })
        });

        $(".btn-block").click(function () {

            var ids = "";
            $("#multiselect_to").each(function () {
                var id = $(this).val();
                ids += id + ",";
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length);
                $("#subCompanyIds").val(ids);
            }
        })
    })
    function deleteLocation(location_id) {
        if (confirm("确认删除地址吗？")) {
            var url = "Tools/AddressAjax.ashx?LocationId =" + location_id;

            $.ajax({
                type: "GET",
                url: "../Tools/AddressAjax.ashx?act=delete&LocationId=" + location_id,
                //data: { LocationId: location_id },
                success: function (data) {
                    debugger;
                    if (data == "Occupy") {
                        alert('该地址已被引用，请更改后删除');
                    }
                    else if (data == "Fail") {
                        alert('地址删除失败');
                    }
                    else if (data == "Success") {
                        alert('地址删除成功');
                        history.go(0);
                    }// LoseUser
                    else if (data == "LoseUser") {
                        alert('用户丢失');
                    }
                    else {
                        alert(data);
                    }

                }

            })
        }

    }

    function chooseCompany() {
        var subIds = $("#SubCompanyHidden").val();
        if (subIds != "") {
            alert("已选择子客户");
            return;
        }
        var account_id = $("#id").val();
        if (account_id != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUB_COMPANY_CALLBACK %>&field=ParentComoanyName&con625=" + account_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
        }

            

   
        //window.open(url, "newwindow", "height=200,width=400", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no");
        //这些要写在一行
    }

    function OpenSubCompany() {
        if ($("#ParentComoanyNameHidden").val() != "") {
            alert("已添加父客户，不能添加子客户！");
            return;
        }
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUB_COMPANY_CALLBACK %>&field=SubCompany&muilt=1&callBack=ChooseSubCompany", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function ChooseSubCompany() {
        if ($("#SubCompanyHidden").val() != "") {
           
            requestData("../Tools/CompanyAjax.ashx?act=names&ids=" + $("#SubCompanyHidden").val() , null, function (data) {
                debugger;
                $(".dblselect").empty();
                for (i = 0; i < data.length; i++) {
                    var option = $("<option>").val(data[i].val).text(data[i].show);
                    $(".dblselect").append(option);
                }
                $(".dblselect option").dblclick(function () {
                    Adddbclick(this);
                });
            })
        }

    }

    function Adddbclick(val) {
        debugger;
        var delval = $(val).val();
        if ($("#SubCompanyHidden").val() == delval) {
            $("#SubCompany").val("");
            $("#SubCompanyHidden").val("");
            $(".dblselect").empty();
        } else {
            requestData("../Tools/CompanyAjax.ashx?act=names&ids=" + $("#SubCompanyHidden").val(), null, function (data) {
                debugger;
                var ids = "";
                $(".dblselect").empty();
                for (i = 0; i < data.length; i++) {
                    if (data[i].val == delval)
                        continue;
                    var option = $("<option>").val(data[i].val).text(data[i].show);
                    $(".dblselect").append(option);
                    ids += data[i].val + ",";
                }
                $(".dblselect option").dblclick(function () {
                    Adddbclick(this);
                });
                if (ids != "") {
                    ids = ids.substr(0, ids.length - 1);
                }
                $("#SubCompanyHidden").val(ids);
            })
        }
    }
    function ChangeBookMark() {
        var url = '<%=Request.RawUrl %>';
        var title = '编辑客户:<%=account?.name %>';
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
</script>
