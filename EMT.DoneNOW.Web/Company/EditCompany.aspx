﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.EditCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Company</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />

</head>
<body>
    <form id="EditCompany" runat="server">
        <div class="header">添加客户</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="delete" runat="server" Text="删除" OnClick="delete_Click" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" />
                </li>
            </ul>
        </div>
        <%-- <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />--%>


        <div class="nav-title">
            <ul class="clear">
                <li class="boders">通用</li>
                <li>地址信息</li>
                <li>附加信息</li>
                <li>用户自定义</li>
                <li>子公司</li>
                <li>站点配置</li>
                <li>提醒</li>
            </ul>
        </div>

        <div class="content clear">

            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">

                <tr>
                    <td>
                        <div class="clear">
                            <label>客户名称<span class="red">*</span></label>

                            <asp:TextBox ID="company_name" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>
                        <div class="clear">
                            <label>是否激活<span class="red">*</span></label>
                            <asp:CheckBox ID="isactive" runat="server" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户编号</label>
                            <asp:TextBox ID="CompanyNumber" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>
                                国家<span class=" red">*</span>
                            </label>
                            <asp:DropDownList ID="country_id" runat="server">
                                <asp:ListItem Value="1">111111</asp:ListItem>
                                <asp:ListItem Value="2">222222</asp:ListItem>
                                <asp:ListItem Value="3">333333</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>省份<span class=" red">*</span></label>
                            <asp:DropDownList ID="province_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>城市<span class=" red">*</span></label>
                            <asp:DropDownList ID="city_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>区县<span class=" red">*</span></label>

                            <asp:DropDownList ID="district_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>
                                地址
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
                <tr>
                    <td>
                        <div class="clear">
                            <label>是否是默认地址<span class="num"></span></label>
                            <asp:DropDownList ID="is_default" runat="server">
                                <asp:ListItem Value="1">默认地址</asp:ListItem>
                                <asp:ListItem Value="0">     </asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
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
                            <asp:TextBox ID="mileage" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>公司类型</label>
                            <asp:DropDownList ID="CompanyType" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>分类类别<span class="red"></span></label>

                            <asp:DropDownList ID="classification" runat="server" AutoPostBack="False">
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户经理</label>
                            <asp:DropDownList ID="AccountManger" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户小组</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>销售区域<span class="red"></span></label>
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
                            <label>是否免税<span class="red">*</span></label>
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
                            <span onclick="chooseCompany('CompanyFindBack.aspx?id=<%=account.id %>');" style="width: 30px; float: left; margin-left: -5px;">查找</span>
                            <input type="hidden" id="parent_company_name" name="parent_company_name" value="<%=account.parent_id %>" />
                        </div>
                    </td>
                </tr>
            </table>

        </div>
        <%--// location_list--%>
        <div class="content clear">
            <table style="text-align: left;" class="table table-hover">
                <tr>
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
                    var district = dic.FirstOrDefault(_ => _.Key == "district").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
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
                    { %><td></td>
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
                    <td><a href="LocationManage.aspx?id=<%=location.id %>&account_id=<%=account.id %>">修改</a> <a href="">删除</a></td>
                </tr>
                <% }%>
                <%} %>
            </table>
        </div>

        <div class="content clear">
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
                            <label>Sic代码<span class="red"></span></label>
                            <asp:TextBox ID="sic_code" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户资产价值<span class="red"></span></label>
                            <asp:TextBox ID="asset_value" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>新浪微博地址<span class="red"></span></label>
                            <asp:TextBox ID="weibo_url" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>微信订阅号<span class="red"></span></label>
                            <asp:TextBox ID="wechat_mp_subscription" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>微信服务号<span class="red"></span></label>
                            <asp:TextBox ID="wechat_mp_service" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
            </table>

        </div>


        <div class="content clear">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">


                <% if (company_udfList != null && company_udfList.Count > 0)
                    {

                        foreach (var udf in company_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.col_name %></label>
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.col_name %></label>
                            <textarea id="<%=udf.id %>" rows="2" cols="20">
                                <%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>

                            </textarea>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.col_name %></label>

                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.col_name %></label>

                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" value="<%=company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>

                <%}
                        }
                    } %>
            </table>

        </div>



        <div class="content clear">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
            </table>

        </div>
        <% //子公司 预留  %>



        <div class="content clear">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
            </table>

        </div>
        <% //站点信息 预留   %>


        <div class="content clear">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">
                <tr>
                    <td>
                        <div class="clear">
                            <label>客户信息提示<span class="red"></span></label>
                            <asp:TextBox ID="Company_Detail_Alert" runat="server" Rows="5" Width="100%" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>新建工单提示<span class="red"></span></label>
                            <asp:TextBox ID="New_Ticket_Alert" runat="server" Rows="5" Width="100%" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>工单信息提示<span class="red"></span></label>
                            <asp:TextBox ID="Ticket_Detail_Alert" runat="server" Rows="5" Width="100%" Height="25%" TextMode="MultiLine" Wrap="true"
                                Style="overflow-y: visible"></asp:TextBox>

                        </div>
                    </td>
                </tr>
            </table>

        </div>




    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script type="text/javascript">
    $(function () {

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
                alert("请输入公司名称");
                // alert(companyName);
                return false;
            }
            var phone = $("#Phone").val();                        //  电话-- 必填项校验
            if (phone == null || phone == '') {
                alert("请输入电话名称");
                return false;
            }
            if (!checkPhone(phone)) {
                alert("请输入正确格式的电话！");
                return false;
            }
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
    })

</script>
