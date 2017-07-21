<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.ViewCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>查看客户</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <%--    <link rel="stylesheet" type="text/css" href="../Content/NewCompany.css" />--%>
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
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
            <label>COMPANY-<%=account.name+"(ID:"+account.account_id+")" %></label>
        </div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="Edit" runat="server" Text="修改" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="tianjia" runat="server" Text="添加" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="Tools" runat="server" Text="工具" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="Report" runat="server" Text="客户报告" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="LiveLink" runat="server" Text="友情链接" BorderStyle="None" /></li>
            </ul>
        </div>

        <div runat="server" id="activity"></div>
        <div id="ShowCompany_Left" style="float: left;">
            <div id="GeneralInformation" style="float: left; width: 300px; margin-left: 40px; background-color: #f1eaea;">
                <%-- 客户的基本信息 --%>

                <label><%=account.name %> <span>类别图标</span> <span>自助服务台图标</span></label>

                <p><%=country.First(_=>_.val.ToString()==location.country_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.provice_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.city_id.ToString()).show  %></p>
                <p><%=addressdistrict.First(_=>_.val.ToString()==location.district_id.ToString()).show  %></p>



                <% if (!string.IsNullOrEmpty(location.address))
                    { %>
                <p><%=location.address %></p>
                <%} %>

                <% if (!string.IsNullOrEmpty(location.additional_address))
                    { %>
                <p><%=location.additional_address %></p>
                <%} %>

                <p>可以根据链接，跳转到百度或其他地图，显示该客户位置</p>

                <% if (account.parent_id != null)
                    { %>
                <p> <a href="ViewCompany.aspx?id=<%=account.parent_id %>"><%=companyBll.GetCompany((long)account.parent_id).name %> </a></p>
                <%} %>

                <p><%=account.phone %></p>
                <p>(P) <%=location.postal_code %></p>
                <p>(F) <%=account.fax %></p>
                <p><%=account.web_site %></p>
                <hr />
            </div>

            <div id="TaxInformation" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;">
                <table>
                    <%if (account.is_tax_exempt != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>是否免税 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.is_tax_exempt == 1 ? "是" : "否" %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (account.tax_region_id != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>税区</label>
                            </p>
                        </td>
                        <td>

                            <p><%=taxRegion.FirstOrDefault(_=>_.val==account.tax_region_id.ToString()).show %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (!string.IsNullOrEmpty(account.tax_identification))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>税号</label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.tax_identification %></p>
                        </td>
                    </tr>
                    <%} %>
                </table>
                <hr />

            </div>

            <div id="AreaInformation" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;">
                <table>
                    <%if (!string.IsNullOrEmpty(account.no))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>客户编号 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.no %></p>
                        </td>
                    </tr>
                    <%} %>

                    <tr>
                        <td>
                            <p>
                                <label>客户经理 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=sys_resource.First(_=>_.val == account.resource_id.ToString()).show %></p>
                        </td>
                    </tr>


                    <tr>
                        <td>
                            <p>
                                <label>客户ID </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.account_id %></p>
                        </td>
                    </tr>

                    <% var primary_contact = GetDefaultContact();
                        if (primary_contact != null)
                        {%>
                    <tr>
                        <td>
                            <p>
                                <label>主要联系人 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=primary_contact.name %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (account.territory_id != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>地域 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=territory.First(_=>_.val==account.territory_id.ToString()).show %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (account.market_segment_id != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>市场领域 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=market_segment.First(_=>_.val==account.market_segment_id.ToString()).show %></p>
                        </td>
                    </tr>
                    <%} %>
                </table>
                <hr />

            </div>
            <div id="Group" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;">
                <%--显示群组的人的头像 --%>
                <hr />

            </div>
            <div id="OtherInformation" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;">
                <table>
                    <tr>
                        <td>
                            <p>有效商机总值</p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>关闭商机总值</p>
                        </td>
                    </tr>

                    <%if (account.asset_value != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>市值 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.asset_value %></p>
                        </td>
                    </tr>
                    <%} %>

                    <%if (account.competitor_id != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>竞争对手 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=competition.First(_=>_.val==account.competitor_id.ToString()).show %></p>
                        </td>
                    </tr>
                    <%} %>

                    <%if (!string.IsNullOrEmpty(account.alternate_phone1))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>备用电话1 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.alternate_phone1%></p>
                        </td>
                    </tr>
                    <%} %>

                    <%if (!string.IsNullOrEmpty(account.alternate_phone2))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>备用电话2 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.alternate_phone2 %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (account.last_activity_time != null)
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>最后活动时间 </label>
                            </p>
                        </td>
                        <td>
                            <p>时间戳转时间 <%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)account.last_activity_time).ToString("yyyy-MM-dd") %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (!string.IsNullOrEmpty(account.sic_code))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>客户股票代码 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.sic_code %></p>
                        </td>
                    </tr>
                    <%} %>
                    <%if (!string.IsNullOrEmpty(account.stock_market))
                        { %>
                    <tr>
                        <td>
                            <p>
                                <label>客户股票市场 </label>
                            </p>
                        </td>
                        <td>
                            <p><%=account.stock_market %></p>
                        </td>
                    </tr>
                    <%} %>

                    <p>客户标准产业分类代码</p>
                </table>
                <hr />

            </div>
            <div id="ViewCompanyPower" style="clear: both; float: left; margin-top: 40px; margin-left: 40px; width: 300px;">
                <p>可以查看本客户的员工</p>


            </div>
        </div>
        <div id="ShowCompany_Right" style="float: left; margin-left: 35px;">
            <table>
                <tr>
                    <td colspan="2">
                        <%--<input type="text" onkeydown="Prompt()"/>--%>
                        <asp:TextBox ID="insert" runat="server" TextMode="MultiLine" MaxLength="1000" Rows="5" Width="500px" Height="25%" Wrap="true" Style="overflow-y: visible"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="padding-right: 5px; padding-top: 10px; width: 350px;">
                        <span id="WordNumber"></span>
                    </td>
                    <td align="right" style="padding-top: 10px;">
                        <%
                            Type.DataValueField = "val";
                            Type.DataTextField = "show";
                            Type.DataSource = action_type;
                            Type.DataBind();
                            Type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                        %>
                        <asp:DropDownList ID="Type" runat="server" Width="100px">
                        </asp:DropDownList>
                        <asp:Button ID="add" runat="server" Text="添加" /></td>
                </tr>
            </table>
            <div>
                <asp:CheckBox ID="Todos" runat="server" />
                <span>待办</span>
                <asp:CheckBox ID="Notes" runat="server" />
                <span>备注</span>
                <asp:CheckBox ID="Opportunities" runat="server" />
                <span>商机</span>
                <asp:CheckBox ID="SalesOrders" runat="server" />
                <span>销售单</span>
                <asp:CheckBox ID="Tickets" runat="server" />
                <span>工单</span>
                <asp:CheckBox ID="Contacts" runat="server" />
                <span>合同</span>
                <asp:CheckBox ID="Projects" runat="server" />
                <span>项目</span>

            </div>
            <div>
                <span>排序方式：</span>
                <asp:DropDownList ID="OrderBy" runat="server">
                    <asp:ListItem Value="1">时间从早到晚</asp:ListItem>
                    <asp:ListItem Value="2">时间从晚到早</asp:ListItem>
                </asp:DropDownList>
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
        // WordNumber
        var maxNumber = 2000;
        $("#WordNumber").text(maxNumber);
        $("#insert").keyup(function () {
            var insert = $("#insert").val();
            if (insert != '') {
                var length = insert.length;
                $("#WordNumber").text(maxNumber - length);
                if (length > 2000) {
                    $(this).val($(this).val().substring(0, 2000));
                }
            }

        });
    })


</script>
