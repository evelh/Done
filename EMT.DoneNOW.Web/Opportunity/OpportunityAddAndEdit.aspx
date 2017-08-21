<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpportunityAddAndEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.OopportunityAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


    <title><%=isAdd?"新增商机":"修改商机" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <%--<link rel="stylesheet" type="text/css" href="../Content/multiple-select.css"/>--%>
</head>
<body>
    <form id="form1" runat="server" style="min-width:880px;">

        <div class="header"><%=isAdd?"添加商机":"修改商机" %></div>

        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建报价" BorderStyle="None" OnClick="save_newAdd_Click" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_create_note" runat="server" Text="保存并新增备注" BorderStyle="None" OnClick="save_create_note_Click" /></li>
                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    关闭</li>
            </ul>
        </div>

        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="">常规</li>
                <li id="">信息</li>
                <li id="">自定义信息</li>
                <li id="">通知</li>
                <li style="float: right;">
                    <div style="float: right;">
                        <asp:DropDownList ID="formTemplate" runat="server"></asp:DropDownList>
                    </div>
                </li>
            </ul>

        </div>

        <div class="content clear">
            <div class="information clear">
                <p class="informationTitle"><i></i>常规信息</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width:871px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>商机名称<span class="red">*</span></label>
                                    <input type="text" name="name" id="name" value="<%=isAdd?"":opportunity.name %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">

                                    <%if (isAdd && contact != null)
                                        {
                                            var company = conpamyBll.GetCompany(contact.account_id);
                                    %>
                                    <label>客户<span class="red">*</span></label>
                                    <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=company.name %>" /><i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                    <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left= 200, top = 200, width = 900, height = 750', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                    <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=company.id %>" />
                                    <%}
                                    else if (isAdd&&account!=null)
                                    { %>
                                    <label>客户<span class="red">*</span></label>
                                    <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=account.name %>" /><i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                    <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left= 200, top = 200, width = 900, height = 750', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                    <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=account.id %>" />
                                    <%}
                                    else
                                    { %>
                                        <label>客户<span class="red">*</span></label>
                                    <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=isAdd ? "" : conpamyBll.GetCompany(opportunity.account_id).name %>" /><i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                    <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left= 200, top = 200, width = 900, height = 750', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                    <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd ? "" : opportunity.account_id.ToString() %>" />
                                    <%} %>
                                </div>
                            </td>

                            <td>
                                <div class="clear">
                                    <label>创建日期<span class="red">*</span></label>
                                    <input onclick="WdatePicker()" type="text"  class="sl_cdt" name="projected_begin_date" id="projected_begin_date" value="<%=isAdd?DateTime.Now.ToString("yyyy-MM-dd"):opportunity.projected_begin_date==null?DateTime.Now.ToString("yyyy-MM-dd"):((DateTime)opportunity.projected_begin_date).ToString("yyyy-MM-dd") %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>联系人</label>
                                    <%if (contact != null)
                                        { %>
                                    <select name="contact_id" id="contact_id" disabled="disabled">
                                        <option value="<%=contact.id %>" selected="selected"><%=contact.name %></option>
                                    </select>
                                    <%}
                                        else
                                        { %>
                                    <select name="contact_id" id="contact_id">
                                    </select>
                                    <%} %>
                                    <input type="hidden" id="contactHideID" value="<%=isAdd&&contact!=null?contact.id.ToString():(!isAdd&&opportunity.contact_id!=null?opportunity.contact_id.ToString():"") %>"/>
                                    <i onclick="AddContact()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>计划关闭时间<span class="red">*</span></label>
                                    <input onclick="WdatePicker()" type="text"  class="sl_cdt" name="projected_close_date" id="projected_close_date" value="<%=(!isAdd&&opportunity.projected_close_date!=null?((DateTime)opportunity.projected_close_date).ToString("yyyy-MM-dd"):"") %>" />
                                      <div style=" display: -webkit-inline-box;">
                                <a  onclick="AddTime(0)">今天</a>|<a   onclick="AddTime(7)">7</a>|<a  onclick="AddTime(30)">30</a>|<a   onclick="AddTime(60)">60</a>
                            </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>商机负责人<span class="red">*</span></label>
                                    <asp:DropDownList ID="resource_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>成交概率</label>
                                    <input type="text" name="probability" id="probability" value="<%=(!isAdd)&&(opportunity.probability!=null)?opportunity.probability.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>当前阶段<span class="red">*</span></label>
                                    <asp:DropDownList ID="stage_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>客户感兴趣等级</label>

                                    <asp:DropDownList ID="interest_degree_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>商机来源</label>
                                    <asp:DropDownList ID="source_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>主要产品</label>
                                    <input type="text" name="primary_product_id" id="primary_product_id" /><%-- todo 主要产品的查找带回--%>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <div class="clear">
                                    <label>状态<span class="red">*</span></label>
                                    <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>促销名称</label>
                                    <input type="text" name="promotion_name" id="promotion_name" value="<%=(!isAdd)&&!string.IsNullOrEmpty(opportunity.promotion_name)?opportunity.promotion_name:"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>主要竞争对手</label>
                                    <asp:DropDownList ID="competitor_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>商机值</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width:828px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>使用报价条目收入/成本<span class="red">*</span></label>
                                    <input type="checkbox" name="use_quote" id="use_quote" value="" />
                                </div>
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>一次性收益</label>
                                    <input type="text" class="Calculation" name="one_time_revenue" id="one_time_revenue" value="<%=(!isAdd)&&(opportunity.one_time_revenue!=null)?opportunity.one_time_revenue.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>一次性成本</label>
                                    <input type="text" class="Calculation" name="one_time_cost" id="one_time_cost" value="<%=(!isAdd)&&(opportunity.one_time_cost!=null)?opportunity.one_time_cost.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>月度收益</label>
                                    <input type="text" class="Calculation" name="monthly_revenue" id="monthly_revenue" value="<%=(!isAdd)&&(opportunity.monthly_revenue!=null)?opportunity.monthly_revenue.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>月度成本</label>
                                    <input type="text" class="Calculation" name="monthly_cost" id="monthly_cost" value="<%=(!isAdd)&&(opportunity.monthly_cost!=null)?opportunity.monthly_cost.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>季度收益</label>
                                    <input type="text" class="Calculation" name="quarterly_revenue" id="quarterly_revenue" value="<%=(!isAdd)&&(opportunity.quarterly_revenue!=null)?opportunity.quarterly_revenue.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>季度成本</label>
                                    <input type="text" class="Calculation" name="quarterly_cost" id="quarterly_cost" value="<%=(!isAdd)&&(opportunity.quarterly_cost!=null)?opportunity.quarterly_cost.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>半年收益</label>
                                    <input type="text" class="Calculation" name="semi_annual_revenue" id="semi_annual_revenue" value="<%=(!isAdd)&&(opportunity.semi_annual_revenue!=null)?opportunity.semi_annual_revenue.ToString():"" %>"   maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>半年成本</label>
                                    <input type="text" class="Calculation" name="semi_annual_cost" id="semi_annual_cost" value="<%=(!isAdd)&&(opportunity.semi_annual_cost!=null)?opportunity.semi_annual_cost.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>年收益</label>
                                    <input type="text" class="Calculation" name="yearly_revenue" id="yearly_revenue" value="<%=(!isAdd)&&(opportunity.yearly_revenue!=null)?opportunity.yearly_revenue.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>年成本</label>
                                    <input type="text" class="Calculation" name="yearly_cost" id="yearly_cost" value="<%=(!isAdd)&&(opportunity.yearly_cost!=null)?opportunity.yearly_cost.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>计算总额</label>
                                    <input type="text" class="Calculation" name="number_months" id="number_months" value="<%=(!isAdd)&&(opportunity.number_months!=null)?opportunity.number_months:10 %>"  onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /><span style="line-height:30px;margin-left:-15px;">月</span>

                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>总收益</label>
                                    <span name="Total_Revenue" id="Total_Revenue"></span>

                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>总成本</label>
                                    <span name="Total_Cost" id="Total_Cost"></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>毛利</label>
                                    <label name="Gross_Profit" id="Gross_Profit"></label>
                                </div>

                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>周期收益</p>
                <div class="clear">
                    <input type="checkbox" name="" id="opportunityRange" />
                    <label style="width:141px;">商机收入周期范围</label>
                    <input type="text" name="spread_value" id="spread_value" value="<%=(!isAdd)&&(opportunity.spread_value!=null)?opportunity.spread_value.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                    <asp:DropDownList ID="spread_unit" runat="server" style="margin-left:3px;">
                        <asp:ListItem Value="Days">日</asp:ListItem>
                        <asp:ListItem Value="Months">月</asp:ListItem>
                        <asp:ListItem Value="Years">年</asp:ListItem>
                    </asp:DropDownList>
                    <%--    <select name="spread_unit" id="spread_unit">
                        <option value="Day">日</option>
                        <option value="Months" selected>月</option>
                        <option value="Years">年</option>
                    </select>--%>
                </div>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>高级字段</p>
                <%
                    var advanced_field = dic.FirstOrDefault(_ => _.Key == "oppportunity_advanced_field").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                    if (advanced_field != null && advanced_field.Count > 0)
                    {
                %>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width:815px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=advanced_field.FirstOrDefault(_=>_.val=="ext1").show %></label>
                                    <input type="text" class="extFiled" name="ext1" id="ext1" value="<%=(!isAdd)&&opportunity.ext1!=null?opportunity.ext1.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=advanced_field.FirstOrDefault(_=>_.val=="ext2").show %></label>
                                    <input type="text" name="ext2" class="extFiled" id="ext2" value="<%=(!isAdd)&&opportunity.ext2!=null?opportunity.ext2.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=advanced_field.FirstOrDefault(_=>_.val=="ext3").show %></label>
                                    <input type="text" name="ext3" class="extFiled" id="ext3ext3" value="<%=(!isAdd)&&opportunity.ext3!=null?opportunity.ext3.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=advanced_field.FirstOrDefault(_=>_.val=="ext4").show %></label>
                                    <input type="text" name="ext4" class="extFiled" id="ext4" value="<%=(!isAdd)&&opportunity.ext4!=null?opportunity.ext4.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=advanced_field.FirstOrDefault(_=>_.val=="ext5").show %></label>
                                    <input type="text" name="ext5" class="extFiled" id="ext5ext5" value="<%=(!isAdd)&&opportunity.ext5!=null?opportunity.ext5.ToString():"" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"/>
                                </div>
                            </td>
                        </tr>



                    </table>
                </div>
                <%} %>
            </div>
        </div>
        <div class="content clear" style="display: none;">
            <div class="clear">
                <label>承诺履行时间</label>
                <input onclick="WdatePicker()" type="text" class="sl_cdt" name="start_date" id="start_date" value="<%=(!isAdd)&&opportunity.start_date!=null?((DateTime)opportunity.start_date).ToString("dd/MM/yyyy"):"" %>" />
            </div>
            <div class="clear">
                <label>承诺完成时间</label>
                <input onclick="WdatePicker()" type="text" class="sl_cdt" name="end_date" id="end_date" value="<%=(!isAdd)&&opportunity.end_date!=null?((DateTime)opportunity.end_date).ToString("dd/MM/yyyy"):"" %>" />

            </div>0 
            <div class="clear">
                <label>市场情况</label>
                <textarea name="market" id="market" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.market))?opportunity.market:"" %></textarea>
            </div>
            <div class="clear">
                <label>当前困难</label>
                <textarea name="barriers" id="barriers" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.barriers))?opportunity.barriers:"" %></textarea>
            </div>
            <div class="clear">
                <label>所需帮助</label>
                <textarea name="help_needed" id="help_needed" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.help_needed))?opportunity.help_needed:"" %></textarea>
            </div>
            <div class="clear">
                <label>后续跟进</label>
                <textarea name="next_step" id="next_step" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.next_step))?opportunity.next_step:"" %></textarea>
            </div>
            <div class="clear">
                <label>赢单原因</label>
                <asp:DropDownList ID="win_reason_type_id" runat="server"></asp:DropDownList>
            </div>
            <div class="clear">
                <label>赢单原因描述</label>
                <textarea name="win_reason" id="win_reason" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.win_reason))?opportunity.win_reason:"" %></textarea>
            </div>
            <div class="clear">
                <label>丢单原因</label>
                <asp:DropDownList ID="loss_reason_type_id" runat="server"></asp:DropDownList>
            </div>
            <div class="clear">
                <label>丢单原因描述</label>
                <textarea name="loss_reason" id="loss_reason" cols="20" rows="2"><%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.loss_reason))?opportunity.loss_reason:"" %></textarea>
            </div>
        </div>
        <div class="content clear" style="display: none;">

            <div>
                <table border="none" cellspacing="" cellpadding="" style="width:815px;">

                    <% if (opportunity_udfList != null && opportunity_udfList.Count > 0)
                        {
                            foreach (var udf in opportunity_udfList)
                            {

                                if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                {%>
                    <tr>
                        <td>
                            <div class="clear">
                                <label><%=udf.name %></label>
                                <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd)&&opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
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
                                <textarea name="<%=udf.id %>" rows="2" cols="20"><%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>
                            </div>

                        </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                        {%><tr>
                            <td>
                                <div class="clear">
                                    <label><%=udf.name %></label>

                                    <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value.ToString():"" %>" />
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
                                <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
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


        </div>
        <div class="content clear" style="display: none;">
            <%var user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(GetLoginUserId()); %>
            <div class="clear">
                <input type="checkbox" name="" id="checkUser" />
                <label><%=user.name %></label>
                <input type="hidden" name="from_email" value="<%=user.email %>" />
                <input type="checkbox" name="" id="CheckAccountManage" />
                <label>客户经理</label>
            </div>
            <div class="clear">
                <label>员工<a href="#">（加载员工）</a></label>
                <select></select>
            </div>
            <div class="clear">
                <label>其他邮件</label>
                <input type="text" name="to_email" id="to_email" />
            </div>
            <div class="clear">
                <label>通知模板</label>
                <asp:DropDownList ID="notify_tmpl_id" runat="server"></asp:DropDownList>
            </div>
            <div class="clear">
                <label>主题</label>
                <input type="text" name="subject" id="subject" value="" />
            </div>
            <div class="clear">
                <label>附加信息</label>
                <input type="text" name="body_text" id="body_text" value="" />
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>

<script>
    
    $(function () {
        $.fn.populateForm = function (data) {
            return this.each(function () {
                var formElem, name;
                if (data == null) { this.reset(); return; }
                for (var i = 0; i < this.length; i++) {
                    formElem = this.elements[i];
                    //checkbox的name可能是name[]数组形式
                    name = (formElem.type == "checkbox") ? formElem.name.replace(/(.+)\[\]$/, "$1") : formElem.name;
                    if (data[name] == undefined) continue;
                    switch (formElem.type) {
                        case "checkbox":
                            if (data[name] == "") {
                                formElem.checked = false;
                            } else {
                                //数组查找元素
                                if (data[name].indexOf(formElem.value) > -1) {
                                    formElem.checked = true;
                                } else {
                                    formElem.checked = false;
                                }
                            }
                            break;
                        case "radio":
                            if (data[name] == "") {
                                formElem.checked = false;
                            } else if (formElem.value == data[name]) {
                                formElem.checked = true;
                            }
                            break;
                        case "button": break;
                        case "select": formElem.value = data[name].value; break;
                        default: formElem.value = data[name];
                    }
                }
            });
        };

        $("#save").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        });

        $("#save_close").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        });

        $("#save_newAdd").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        });

        $("#save_create_note").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        });

        $("#formTemplate").change(function () {
            var formTemplate_id = $("#formTemplate").val();
            if (formTemplate_id != 0)       // 
            {
                //<a href="../Tools/OpportunityAjax.ashx">../Tools/OpportunityAjax.ashx</a>
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/OpportunityAjax.ashx?act=formTemplate&id=" + formTemplate_id,
                    dataType: "json",
                    success: function (data) {
                        debugger;
                        if (data != "" && data != undefined) {
                            $("#form1").populateForm(data);
                        }
                    },


                });
            }
        })

        $(".Calculation").blur(function () {
            Calculation_Gross_Profit();
            var value = $(this).val();
            if (!isNaN(value) && value != "") {
                $(this).val(toDecimal2(value));
            } else {
                $(this).val("");
            }
        })

        $(".extFiled").blur(function () {
            var value = $(this).val();
            if (!isNaN(value) && value != "") {
                $(this).val(toDecimal2(value));
            } else {
                $(this).val("");
            }
        })
        Calculation_Gross_Profit();
        GetContactList();
      
        var contactHideID = $("#contactHideID").val();
        if (contactHideID != "") {
            $("#contact_id").val(contactHideID);
            <%if (contact != null) { %>
           $("#contact_id").attr("disabled", "disabled")
                <%}%>
        }
        function Calculation_Gross_Profit()   // 计算毛利和毛利率,年收益和年成本
        {
            var CalculationMonths = $("#number_months").val();
            if (!isNaN(CalculationMonths))   // 计算的月份时数字开始计算
            {
                debugger;
                var total_income = 0.00;                    // 总收益
                var total_expenditure = 0.00;               // 总支出
                var one_time_revenue = $("#one_time_revenue").val();   // 一次性收益
                var one_time_cost = $("#one_time_cost").val();         // 一次性支出
                if (one_time_revenue != "" && !isNaN(one_time_revenue))       // 收益和支出是数字时开始计算
                {
                    total_income = Number(total_income.toFixed(2)) + Number(toDecimal2(one_time_revenue));
                    $("#one_time_revenue").val(toDecimal2(one_time_revenue));
                }
                if (one_time_cost != "" && !isNaN(one_time_cost)) {
                    total_expenditure = Number(total_expenditure.toFixed(2)) + Number(toDecimal2(one_time_cost));
                    // total_expenditure += toDecimal2(one_time_cost);
                    $("#one_time_cost").val(toDecimal2(one_time_cost));
                }

                var monthly_revenue = $("#monthly_revenue").val();   // 月收益
                var monthly_cost = $("#monthly_cost").val();         // 月支出
                if (monthly_revenue != "" && !isNaN(monthly_revenue))       // 收益和支出是数字时开始计算
                {
                    total_income = Number(total_income.toFixed(2)) + Number(toDecimal2(monthly_revenue) * CalculationMonths);
                    $("#monthly_revenue").val(toDecimal2(monthly_revenue));
                }
                if (monthly_cost != "" && !isNaN(monthly_cost)) {
                    total_expenditure = Number(total_expenditure.toFixed(2)) + Number(toDecimal2(monthly_cost) * CalculationMonths);
                    // total_expenditure += toDecimal2(monthly_cost) * CalculationMonths;
                    $("#monthly_cost").val(toDecimal2(monthly_cost));
                }

                var quarterly_revenue = $("#quarterly_revenue").val();   // 季收益
                var quarterly_cost = $("#quarterly_cost").val();         // 季支出
                if (quarterly_revenue != "" && !isNaN(quarterly_revenue))       // 收益和支出是数字时开始计算
                {
                    total_income = Number(total_income.toFixed(2)) + Number(toDecimal2((quarterly_revenue / 4)) * CalculationMonths);
                    //  total_income += toDecimal2((quarterly_revenue / 4)) * CalculationMonths;
                    $("#quarterly_revenue").val(toDecimal2(quarterly_revenue));
                }
                if (quarterly_cost != "" && !isNaN(quarterly_cost)) {
                    total_expenditure = Number(total_expenditure.toFixed(2)) + Number(toDecimal2((quarterly_cost / 4)) * CalculationMonths);
                    //total_expenditure += toDecimal2((quarterly_cost / 4)) * CalculationMonths;
                    $("#quarterly_cost").val(toDecimal2(quarterly_cost));
                }

                var semi_annual_revenue = $("#semi_annual_revenue").val();   // 半年收益
                var semi_annual_cost = $("#semi_annual_cost").val();         // 半年支出
                if (semi_annual_revenue != "" && !isNaN(semi_annual_revenue))       // 收益和支出是数字时开始计算
                {
                    total_income = Number(total_income.toFixed(2)) + Number(toDecimal2((semi_annual_revenue / 6)) * CalculationMonths);
                    //total_income += toDecimal2((semi_annual_revenue / 6)) * CalculationMonths;
                    $("#semi_annual_revenue").val(toDecimal2(semi_annual_revenue));
                }
                if (semi_annual_cost != "" && !isNaN(semi_annual_cost)) {
                    total_expenditure = Number(total_expenditure.toFixed(2)) + Number(toDecimal2((semi_annual_cost / 6)) * CalculationMonths);
                    // total_expenditure += toDecimal2((semi_annual_cost / 6)) * CalculationMonths;
                    $("#semi_annual_cost").val(toDecimal2(semi_annual_cost));
                }

                var yearly_revenue = $("#yearly_revenue").val();   // 年收益
                var yearly_cost = $("#yearly_cost").val();         // 年支出
                if (yearly_revenue != "" && !isNaN(yearly_revenue))       // 收益和支出是数字时开始计算
                {
                    total_income = Number(total_income.toFixed(2)) + Number(toDecimal2((yearly_revenue / 12)) * CalculationMonths);
                    //total_income += toDecimal2((yearly_revenue / 12)) * CalculationMonths;
                    $("#yearly_revenue").val(toDecimal2(yearly_revenue));
                }
                if (yearly_cost != "" && !isNaN(yearly_cost)) {
                    total_expenditure = Number(total_expenditure.toFixed(2)) + Number(toDecimal2((yearly_cost / 12)) * CalculationMonths);
                    //total_expenditure += toDecimal2((yearly_cost / 12)) * CalculationMonths;
                    $("#yearly_cost").val(toDecimal2(yearly_cost));
                }

                $("#Total_Revenue").text(toDecimal2(total_income));
                $("#Total_Cost").text(toDecimal2(total_expenditure));

                var Gross_Profit = Number(total_income) - Number(total_expenditure);
                // Math.round(num / total * 10000) / 100.00 + "%"
                if (Number(total_income) != 0) {
                    $("#Gross_Profit").text(toDecimal2(Gross_Profit) + "(" + Math.round(Gross_Profit / total_income * 10000) / 100.00 + "%)");
                }

            }
        }

 

        // use_quote
        $("#use_quote").click(function () {
            if ($(this).is(':checked')) {             
                $(".Calculation").attr("disabled", "disabled");
            }
            else {
                $(".Calculation").removeAttr("disabled");
            }
        })
        $("#spread_value").attr("disabled", "disabled");
        $("#spread_unit").attr("disabled", "disabled");
        $("#opportunityRange").click(function () {
            if ($(this).is(':checked')) {
                $("#spread_value").removeAttr("disabled");
                $("#spread_unit").removeAttr("disabled");
            }
            else {
                $("#spread_value").attr("disabled", "disabled");
                $("#spread_unit").attr("disabled", "disabled");
            }
        })
                    
    })
    function SubmitCheck() {

        var opportunityName = $("#name").val();
        if (opportunityName == "") {
            alert("请输入商机名称");
            return false;
        }

        var ParentComoanyName = $("#ParentComoanyNameHidden").val();
        if (ParentComoanyName == "") {
            alert("请通过查找功能查找客户");
            return false;
        }

        var resource_id = $("#resource_id").val();
        if (resource_id == 0) {
            alert("请选择商机负责人");
            return false;
        }

        var status_id = $("#status_id").val();
        if (status_id == 0) {
            alert("请选择状态");
            return false;
        }
        var projected_begin_date = $("#projected_begin_date").val();
        if (projected_begin_date == "" || (!check(projected_begin_date))) {
            alert("请填写创建日期");
            return false;
        }
        var projected_close_date = $("#projected_close_date").val();
        if (projected_close_date == "" || (!check(projected_close_date))) {
            alert("请填写计划关闭日期");
            return false;
        }



        return true;
    }
    function GetContactList() {
        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            $("#contact_id").removeAttr("disabled");

            $("#contact_id").html("");
            //$("#contactHideID").val("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#contact_id").html(data);

                    }
                },
            });
        }

    }

    // 强制保留两位小数
    function toDecimal2(x) {
        var f = parseFloat(x);
        if (isNaN(f)) {
            return false;
        }
        var f = Math.round(x * 100) / 100;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
            rs = s.length;
            s += '.';
        }
        while (s.length <= rs + 2) {
            s += '0';
        }
        return s;
    }

    function AddTime(time) {
        var date = new Date();
        date.setDate(Number(date.getDate()) + Number(time));

        var newDate = date.getFullYear() + '-' + returnNumber((date.getMonth() + 1)) + '-' + returnNumber(date.getDate());
        $("#projected_close_date").val(newDate);
        // $("#projected_close_date").datebox('setValue', newDate);       
    }
    function returnNumber(param) {
        if (param < 10) {
            return "0" + param
        }
        return param;
    }

    function chooseCompany()
    {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=ParentComoanyName&callBack=GetContactList", '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function AddContact() {
        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            window.open('../Contact/AddContact.aspx?callback=AddContactBack&account_id=' + account_id, '<%=EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>', '<%=EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>', 'left= 200, top = 200, width = 900, height = 750', false);
        } else {
            return false;
        }    
    }
    function AddContactBack(id) {
        GetContactList();
        $("#contact_id").val(id);
    }
</script>
