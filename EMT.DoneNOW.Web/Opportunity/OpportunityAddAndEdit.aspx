<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpportunityAddAndEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.OopportunityAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


    <title><%=isAdd?"新增商机":"修改商机" %></title>

    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <%if (isAdd)
            {%>
        <div class="header">添加商机</div>
        <%}
            else
            { %>
        <div class="header">修改商机</div>
        <%} %>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建报价" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_create_opportunity" runat="server" Text="保存并新增备注" BorderStyle="None" /></li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" BorderStyle="None" /></li>
            </ul>
        </div>

        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="">通用</li>
                <li id="">信息</li>
                <li id="">自定义信息</li>
                <li id="">通知</li>
            </ul>
        </div>
        <div class="content clear">
            <div class="information clear">
                <p class="informationTitle"><i></i>基本信息</p>
                <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 40px;">
                    <tr>
                        <td colspan="2">
                            <div class="clear">
                                <label>商机名称<span class="red">*</span></label>
                                <input type="text" style="width: 100%;" name="name" id="name" value="<%=isAdd?"":opportunity.name %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>客户名称</label>
                                <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="" /><i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: -1px; margin-top: 5px; background: url(../Images/data-selector.png);"></i>
                                <i onclick="" style="width: 15px; height: 15px; float: left; margin-left: -1px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -78px 0;"></i>


                                <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd?"":opportunity.account_id.ToString() %>" />
                            </div>
                        </td>

                        <td>
                            <div class="clear">
                                <label>计划开始日期</label>
                                <input type="datetime-local" name="projected_begin_date" id="projected_begin_date" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>联系人</label>
                                <select name="contact_id" id="contact_id">
                                </select>
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>项目关闭时间</label>
                                <input type="datetime-local" name="projected_close_date" id="projected_close_date" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>商机负责人</label>
                                <asp:DropDownList ID="resource_id" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>成交概率</label>
                                <input type="text" name="probability" id="probability" value="<%=(!isAdd)&&(opportunity.probability!=null)?opportunity.probability.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>当前阶段</label>
                                <asp:DropDownList ID="stage_id" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>等级</label>

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
                                <label>状态</label>
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
            <div class="information clear">
                <p class="informationTitle"><i></i>商机值</p>
                <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 40px;">
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
                                <input type="checkbox" name="one_time_revenue" id="one_time_revenue" value="<%=(!isAdd)&&(opportunity.one_time_revenue!=null)?opportunity.one_time_revenue.ToString():"" %>" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>一次性成本</label>
                                <input type="checkbox" name="one_time_cost" id="one_time_cost" value="<%=(!isAdd)&&(opportunity.one_time_cost!=null)?opportunity.one_time_cost.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>月度收益</label>
                                <input type="checkbox" name="monthly_revenue" id="monthly_revenue" value="<%=(!isAdd)&&(opportunity.monthly_revenue!=null)?opportunity.monthly_revenue.ToString():"" %>" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>月度成本</label>
                                <input type="checkbox" name="monthly_cost" id="monthly_cost" value="<%=(!isAdd)&&(opportunity.monthly_cost!=null)?opportunity.monthly_cost.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>季度收益</label>
                                <input type="checkbox" name="quarterly_revenue" id="quarterly_revenue" value="<%=(!isAdd)&&(opportunity.quarterly_revenue!=null)?opportunity.quarterly_revenue.ToString():"" %>" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>季度成本</label>
                                <input type="checkbox" name="quarterly_cost" id="quarterly_cost" value="<%=(!isAdd)&&(opportunity.quarterly_cost!=null)?opportunity.quarterly_cost.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>半年收益</label>
                                <input type="checkbox" name="semi_annual_revenue" id="semi_annual_revenue" value="<%=(!isAdd)&&(opportunity.semi_annual_revenue!=null)?opportunity.semi_annual_revenue.ToString():"" %>" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>半年成本</label>
                                <input type="checkbox" name="semi_annual_cost" id="semi_annual_cost" value="<%=(!isAdd)&&(opportunity.semi_annual_cost!=null)?opportunity.semi_annual_cost.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>年收益</label>
                                <input type="checkbox" name="yearly_revenue" id="yearly_revenue" value="<%=(!isAdd)&&(opportunity.yearly_revenue!=null)?opportunity.yearly_revenue.ToString():"" %>" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>年成本</label>
                                <input type="checkbox" name="yearly_cost" id="yearly_cost" value="<%=(!isAdd)&&(opportunity.yearly_cost!=null)?opportunity.yearly_cost.ToString():"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>总收益</label>
                                <input type="checkbox" name="Total_Revenue" id="Total_Revenue" value="" />
                            </div>
                        </td>
                        <td>
                            <div class="clear">
                                <label>总成本</label>
                                <input type="checkbox" name="Total_Cost" id="Total_Cost" value="" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>毛利</label>
                                <input type="checkbox" name="Gross_Profit" id="Gross_Profit" value="" />
                            </div>

                        </td>
                    </tr>
                </table>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>周期收益</p>
                <div class="clear">
                    <input type="checkbox" name="" id="opportunity" />
                    <label>商机收入周期范围</label>
                    <input type="text" name="spread_value" id="spread_value" value="" />
                    <select name="spread_unit" id="spread_unit">
                        <option></option>
                    </select>
                </div>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>高级字段</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 400px; margin-left: 40px;">

                        <% if (opportunity_udfList != null && opportunity_udfList.Count > 0)
                            {
                                foreach (var udf in opportunity_udfList)
                                {

                                    if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                    {%>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=udf.col_name %></label>
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
                                    <label><%=udf.col_name %></label>
                                    <textarea name="<%=udf.id %>" rows="2" cols="20">
                                        <%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>
                                    </textarea>
                                </div>

                            </td>
                        </tr>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                            {%><tr>
                                    <td>
                                        <div class="clear">
                                            <label><%=udf.col_name %></label>

                                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" value="<%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value.ToString():"" %>" />
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

                                    <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=opportunity_udfValueList!=null&&opportunity_udfValueList.Count>0?opportunity_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
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
        </div>
        <div class="content clear">
            <div class="clear">
                <label>承诺履行时间</label>
                <input type="datetime-local" name="start_date" id="start_date" value="<%=(!isAdd)&&opportunity.start_date!=null?((DateTime)opportunity.start_date).ToString("dd/MM/yyyy"):"" %>" />
            </div>
            <div class="clear">
                <label>承诺完成时间</label>
                <input type="datetime-local" name="end_date" id="end_date" value="<%=(!isAdd)&&opportunity.end_date!=null?((DateTime)opportunity.end_date).ToString("dd/MM/yyyy"):"" %>" />

            </div>
              <div class="clear">
                <label>市场情况</label>
                  <textarea name="market" id="market" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.market))?opportunity.market:"" %>
                  </textarea>
              </div>
            <div class="clear">
                <label>当前困难</label>
                  <textarea name="barriers" id="barriers" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.barriers))?opportunity.barriers:"" %>
                  </textarea>
              </div> 
              <div class="clear">
                <label>所需帮助</label>
                  <textarea name="help_needed" id="help_needed" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.help_needed))?opportunity.help_needed:"" %>
                  </textarea>
              </div>
              <div class="clear">
                <label>后续跟进</label>
                  <textarea name="next_step" id="next_step" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.next_step))?opportunity.next_step:"" %>
                  </textarea>
              </div>
               <div class="clear">
                   <label>赢单原因</label>
                   <asp:DropDownList ID="win_reason_type_id" runat="server"></asp:DropDownList>
              </div>
               <div class="clear">
                <label>赢单原因描述</label>
                  <textarea name="win_reason" id="win_reason" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.win_reason))?opportunity.win_reason:"" %>
                  </textarea>
              </div>
              <div class="clear">
                   <label>赢单原因</label>
                   <asp:DropDownList ID="loss_reason_type_id" runat="server"></asp:DropDownList>
              </div>
               <div class="clear">
                <label>赢单原因描述</label>
                  <textarea name="win_reason" id="loss_reason" cols="20" rows="2">
                      <%=(!isAdd)&&(!string.IsNullOrEmpty(opportunity.loss_reason))?opportunity.loss_reason:"" %>
                  </textarea>
              </div>
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
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd)&&company_udfValueList!=null&&company_udfValueList.Count>0?company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />

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
                                <%=(!isAdd)&&company_udfValueList!=null&&company_udfValueList.Count>0?company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>

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

                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" value="<%=(!isAdd)&&company_udfValueList!=null&&company_udfValueList.Count>0?company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />

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

                            <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" value="<%=(!isAdd)&&company_udfValueList!=null&&company_udfValueList.Count>0?company_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" />
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
        </div>
    </form>
</body>
</html>
