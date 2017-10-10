<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemManage.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteItem.QuoteItemManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>报价项管理</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min2.2.2.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/Quotebaojiaxiang.css" rel="stylesheet" />
    <style>
        .num {
            color: #666666;
            font-size: 12px;
            vertical-align: super;
        }
    </style>
</head>
<body>
    <%if (string.IsNullOrEmpty(isShow))
        { %>
    <div class="TitleBar">

        <div class="Title">
            <span class="text1">报价项管理</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>

    </div>
    <%} %>
    <form id="form1" runat="server">
        <input type="hidden" id="isRelationSaleOrder" value="0" />
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    新增报价项
                  <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS %>')">工时</a></li>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %>')">产品</a></li>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.SERVICE %>')">服务</a></li>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION %>')">成本</a></li>

                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST %>')">费用</a></li>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT %>')">一次性折扣</a></li>
                        <li><a href="#" onclick="AddQuoteItem('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES %>')">配送</a></li>


                    </ul>

                </li>
                <li>工具<i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#"></a>置为主报价</li>
                        <li><a href="#"></a>导入报价项</li>
                        <li><a href="#"></a>新建配置项</li>
                        <li><a href="#"></a>新建定期服务合同</li>
                        <li><a onclick="window.open('../Opportunity/ViewOpportunity?id=<%=quote.opportunity_id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityView %>','left=200,top=200,width=960,height=750', false);">查看商机</a></li>
                        <li><a onclick="window.open('../Quote/QuoteClose?id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityView %>','left=200,top=200,width=960,height=750', false);">关闭报价</a></li>
                        <li><a href="#" onclick="window.open('../Quote/QuoteLost?id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityLose %>','left=200,top=200,width=960,height=750', false);">丢失报价</a></li>
                    </ul>
                </li>
                <li><a href="#" onclick="window.open('../Quote/QuoteAddAndUpdate.aspx?id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteEdit %>','left=200,top=200,width=960,height=750', false);">编辑报价单</a></li>
                <li><a href="#" onclick="window.open('../Quote/QuoteView.aspx?id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteView %>','left=200,top=200,width=960,height=750', false);">预览电子报价单</a></li>
                <li><a href="#">打印</a></li>

                <li style="float: right;">报价<asp:DropDownList ID="quoteDropList" runat="server"></asp:DropDownList><i style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -63px; float: right;" class="icon-1" onclick="SetPrimaryQuote()"></i><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0; float: right;" class="icon-1" onclick="window.open('../Quote/QuoteAddAndUpdate.aspx?quote_opportunity_id=<%=quote.opportunity_id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>','left=200,top=200,width=960,height=750', false);"></i></li>
            </ul>
        </div>
        <div class="quoteItemListDiv">

            <input type="hidden" name="show_each_tax_in_tax_group" id="show_each_tax_in_tax_group" value="" runat="server" />
            <input type="hidden" name="show_each_tax_in_tax_period" id="show_each_tax_in_tax_period" value="" runat="server" />
            <input type="hidden" name="show_tax_cate" id="show_tax_cate" value="" runat="server" />
            <input type="hidden" name="show_tax_cate_superscript" id="show_tax_cate_superscript" value="" runat="server" />
            <input type="hidden" name="show_labels_when_grouped" id="show_labels_when_grouped" value="" runat="server" />
            <div class="grid">
                <div id="quoteSettingDiv">
                    <span class="FieldLabels">分组方式:</span>
                    <div class="FieldSelect">
                        <asp:DropDownList ID="groupBy" runat="server"></asp:DropDownList>
                        <%--     <select name="groupBy" id="groupBy">
                            <option value="no">不分组</option>
                            <option value="cycle">周期</option>
                            <option value="product">产品</option>
                        </select>--%>
                    </div>
                </div>
                <div id="quoteBody">
                    <table class="ReadOnlyGrid_Table">
                        <thead>
                            <tr>
                                <td>序列号</td>
                                <td>报价项名称</td>
                                <td>报价项类型</td>
                                <td>出厂序号</td>
                                <td>数量</td>
                                <td>单价</td>
                                <td>折扣率</td>
                                <td>单元折扣</td>
                                <td>折后价</td>
                                <td>单元成本</td>
                                <td>毛利</td>
                                <td>毛利率</td>
                                <td>总价</td>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                var type = dic.First(_ => _.Key == "quote_item_type").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>; // 报价项分类
                                var quote_item_tax_cate_name = dic.First(_ => _.Key == "quote_item_tax_cate").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>; // 报价项相关税

                                // 为了给税加入上标获取到集合排序
                                var taxAllCateList = quoteItemList.Select(_ => _.tax_cate_id).Distinct().ToList();  // 所有的税ID信息相关的集合

                                // EMT.DoneNOW.DAL.d_tax_region_cate_dal.GetTaxRegionCate
                                List<EMT.DoneNOW.Core.d_tax_region_cate> quote_item_tax_cate = null;
                                if (quote.tax_region_id != null)
                                {
                                    quote_item_tax_cate = new EMT.DoneNOW.DAL.d_tax_region_cate_dal().GetTaxRegionCate(quote.tax_region_id);
                                }

                                if (groupList != null && groupList.Count > 0)
                                {
                                    decimal groupAllTaxPrcie = 0; // 分组下的所有税的总和
                                    foreach (var item in groupList)
                                    {%>
                            <tr>

                                <% var groupName = "";
                                    if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.CYCLE).ToString())
                                    {
                                        var cycleFiled = new EMT.DoneNOW.DAL.d_general_dal().GetDictionary(new EMT.DoneNOW.DAL.d_general_table_dal().GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE));
                                        // var tset = new EMT.DoneNOW.DTO.DictionaryEntryDto(null, "", 0);
                                        // cycleFiled.Add(tset);
                                        if (!string.IsNullOrEmpty(item.Key.ToString()))
                                        {
                                            groupName = cycleFiled.First(_ => _.val.ToString() == item.Key.ToString()).show;
                                        }
                                        else
                                        {
                                            groupName = "无周期";
                                        }
                                        //   groupName = cycleFiled.First(_ => (_.val == null ? "" : _.val).ToString() == item.Key.ToString()) != null ? cycleFiled.First(_ => (_.val == null ? "" : _.val).ToString() == item.Key.ToString()).show : "无周期";
                                    }
                                    else if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.PRODUCT).ToString())
                                    {
                                        if (!string.IsNullOrEmpty(item.Key.ToString()))
                                        {
                                            var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(long.Parse(item.Key.ToString()));
                                            if (product != null)
                                            {
                                                groupName = product.name;
                                            }
                                        }
                                        else
                                        {
                                            groupName = "无产品";
                                        }
                                    }
                                    else
                                    {

                                    }
                                %>
                                <td><%=groupName %></td>
                                <td colspan="12"></td>
                            </tr>
                            <% 
                                foreach (var quoteItem in item.Value as List<EMT.DoneNOW.Core.crm_quote_item>)
                                {
                            %>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <% }%>
                            <% var totalPrice = item.Value.ToList().Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                decimal totalAllTaxPrice = 0;
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;"><%=groupName %>汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <%
                                if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {

                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = item.Value.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_=>_.val==taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice*taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate;
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate*100).ToString("#0.00")+"%" %>):</td>
                                <td><%=(taxTotalPrice*tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                            }

                                        }
                                    }
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;"><%=groupName %>税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += totalAllTaxPrice;  // 所有报价项的税之和
                            %>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(item.Value.ToList().Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=  ((decimal)((item.Value.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>

                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%      
                                }%>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>分组汇总：</b> <span></span>
                                    <span><%=(decimal.Round(groupAllTaxPrcie,2)) %></span>
                                </td>
                                <% var groupMaoli = groupList.Values.Sum(value => value.Sum(_ => (_.unit_cost != null && _.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount - _.unit_cost) * _.quantity : 0)); %>
                                <td><%=(decimal.Round(decimal.Parse(groupMaoli.ToString()),2).ToString()) %>
                           
                                </td>
                                <td>
                                    <%  var totalSum = groupList.Values.Sum(value => value.Sum((_ => _.unit_price != null ? _.unit_price * _.quantity : 0)));
                                        var totalCost = groupList.Values.Sum(value => value.Sum((_ => _.unit_cost != null ? _.unit_cost * _.quantity : 0))); %>
                                    <%=((decimal)(((totalSum-totalCost)*100/(totalCost==0?1:totalCost)))).ToString("#0.00")+"%" %></td>

                                <% var groupTotal = (groupList.Values.Sum(value => value.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) + (decimal.Round(groupAllTaxPrcie, 2)));  %>
                                <td><%=(decimal.Round(decimal.Parse(groupTotal.ToString()),2).ToString()) %></td>
                            </tr>
                            <% if (distributionList != null && distributionList.Count > 0)
                                {%>
                            <tr>
                                <td>配送类型的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <% foreach (var quoteItem in distributionList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>

                            <%}%>
                            <% var totalPrice = distributionList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                         ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal totalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">配送汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = distributionList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);// 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">配送税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += totalAllTaxPrice;  // 所有报价项的税之和
                            %>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((distributionList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>

                            </tr>
                            <%   }
                                if (discountQIList != null && discountQIList.Count > 0)
                                {%>
                            <tr>
                                <td>一次性折扣</td>
                                <td colspan="12"></td>
                            </tr>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent == null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%  // 计算出一次性的报价项的总价 ，转换成百分比
                                    var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                %>
                                <td><%=((decimal)(quoteItem.unit_discount*100/(oneTotalPrice==0?1:oneTotalPrice))).ToString("#0.00")+"%" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.quantity!=null)?((decimal)(quoteItem.unit_discount*quoteItem.quantity)).ToString("#0.00"):"" %></td>
                            </tr>

                            <%}%>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent != null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>

                                <td><%=quoteItem.discount_percent!=null?(quoteItem.discount_percent*100).ToString()+"%":"" %></td>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent).ToString()),2).ToString()):"" %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <%if (oneTimeList != null && oneTimeList.Count > 0)
                                    { %>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent*100/100).ToString()),2).ToString()):"" %></td>
                                <%}
                                    else
                                    { %>
                                <%} %>
                            </tr>

                            <%}%>

                            <% var totalPrice = (discountQIList.Where(_ => _.discount_percent == null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) + (oneTimeList != null && oneTimeList.Count > 0 ? discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent * 100 / 100) : 0)); // 该项下的总价 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 //distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 // 一次性折扣税汇总，税单独计算，其余汇总不变
                                decimal itemTaxPrice = 0;
                                decimal totalAllTaxPrice = 0;  // 该类型下的所有税汇总
                                discountQIList.ForEach(discount =>
                                {
                                    if (discount.discount_percent != null)
                                    { }
                                    else
                                    {
                                        var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                        discount.discount_percent = (discount.unit_discount / (oneTotalPrice == 0 ? 1 : oneTotalPrice));
                                    }
                                    quote_item_tax_cate.ForEach(_ =>
                                    {
                                        var list = oneTimeList.Where(dis => (dis.tax_cate_id == null ? 0 : dis.tax_cate_id) == _.tax_cate_id).ToList();
                                        if (list != null && list.Count > 0)
                                        {
                                            totalAllTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent * _.total_effective_tax_rate); // 折扣中需要交税的项
                                            itemTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent);// 折扣中需要交税的和
                                        }

                                    });

                                });  // 在这里首先计算出要一次性折扣的所有的税
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">一次性报价项汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <%  if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = oneTimeList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {      %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(itemTaxPrice * taxcate.total_effective_tax_rate).ToString("#0.000") %></td>
                            </tr>
                            <%
// totalAllTaxPrice += taxTotalPrice *(decimal) taxcate.total_effective_tax_rate; %>
                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(itemTaxPrice * tc.tax_rate).ToString("#0.000") %></td>
                            </tr>
                            <%}
                                            }

                                        }
                                    }
                                }
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie -= totalAllTaxPrice;  // 所有报价项的税之和
                            %>

                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">一次性税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.000") %></td>
                            </tr>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td></td>
                                <td></td>
                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%}%>
                        
                            <% if (optionalItemList != null && optionalItemList.Count > 0)
                                { %>
                                <tr>
                                <td colspan="9"></td>
                                <td><b>除去可选的汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %></td>
                                <% var thisSum = quoteItemList.Where(_ => _.optional != 1).Sum(_ => _.unit_cost != null ? _.unit_cost * _.quantity : 0);  %>
                                <td><%=((decimal)((quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(thisSum==0?1:thisSum))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">带上税的汇总</td>
                                <td><%=(decimal.Round(decimal.Parse((groupAllTaxPrcie+quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>
                            <tr>
                                <td>可选的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <%  
                                foreach (var quoteItem in optionalItemList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <%}%>

                            <% var totalPrice = optionalItemList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                         ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal totalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">可选报价项汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = optionalItemList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">可选税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += totalAllTaxPrice;  // 所有报价项的税之和
                            %>


                            <tr>
                                <td colspan="9"></td>
                                <td><b>可选汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((optionalItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%  }%>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>全部汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(quoteItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((quoteItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>
                                <td><%=decimal.Round(((decimal)(quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>

                                <td colspan="12" style="text-align: right;">加税汇总</td>
                                <td><%=decimal.Round(((decimal)(groupAllTaxPrcie+quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <%     }
                                else if (doubleGroupList != null && doubleGroupList.Count > 0)
                                {

                                    /* 双分组处理 */


                                    decimal groupAllTaxPrcie = 0;
                                    foreach (var outGroupBy in doubleGroupList)
                                    {

                                        var outGroupName = "";
                                        if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.CYCLE_PRODUCT).ToString())
                                        {
                                            var cycleFiled = new EMT.DoneNOW.DAL.d_general_dal().GetDictionary(new EMT.DoneNOW.DAL.d_general_table_dal().GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE));
                                            // var tset = new EMT.DoneNOW.DTO.DictionaryEntryDto(null,"",0);
                                            //   cycleFiled.Add(tset);
                                            // outGroupName = cycleFiled.First(_ =>  (_.val==null?"":_.val).ToString() == outGroupBy.Key.ToString()) != null ? cycleFiled.First(_ =>  (_.val==null?"":_.val).ToString() == outGroupBy.Key.ToString()).show : "无周期";

                                            if (!string.IsNullOrEmpty(outGroupBy.Key.ToString()))
                                            {
                                                outGroupName = cycleFiled.First(_ => _.val.ToString() == outGroupBy.Key.ToString()).show;
                                            }
                                            else
                                            {
                                                outGroupName = "无周期";
                                            }
                                        }
                                        else if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.PRODUCT_CYCLE).ToString())
                                        {
                                            if (!string.IsNullOrEmpty(outGroupBy.Key.ToString()))
                                            {
                                                var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(long.Parse(outGroupBy.Key.ToString()));
                                                if (product != null)
                                                {
                                                    outGroupName = product.name;
                                                }
                                            }
                                            else
                                            {
                                                outGroupName = "无产品";
                                            }
                                        }
                            %>

                            <tr>
                                <td><%=outGroupName %></td>
                                <td colspan="12"></td>
                            </tr>
                            <%      foreach (var inGroupBy in outGroupBy.Value as Dictionary<object, List<EMT.DoneNOW.Core.crm_quote_item>>)
                                {

                                    var inGroupName = "";
                                    if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.CYCLE_PRODUCT).ToString())
                                    {
                                        if (!string.IsNullOrEmpty(inGroupBy.Key.ToString()))
                                        {
                                            var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(long.Parse(inGroupBy.Key.ToString()));
                                            if (product != null)
                                            {
                                                inGroupName = product.name;
                                            }
                                        }
                                        else
                                        {
                                            inGroupName = "无产品";
                                        }
                                    }
                                    else if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.PRODUCT_CYCLE).ToString())
                                    {
                                        var cycleFiled = new EMT.DoneNOW.DAL.d_general_dal().GetDictionary(new EMT.DoneNOW.DAL.d_general_table_dal().GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE));
                                        if (!string.IsNullOrEmpty(inGroupBy.Key.ToString()))
                                        {
                                            inGroupName = cycleFiled.First(_ => _.val.ToString() == inGroupBy.Key.ToString()).show;
                                        }
                                        else
                                        {
                                            inGroupName = "无周期";
                                        }
                                        //  inGroupName = cycleFiled.First(_ => _.val.ToString() == inGroupBy.Key.ToString()) != null ? cycleFiled.First(_ => _.val.ToString() == inGroupBy.Key.ToString()).show : "无周期";

                                    }
                            %>

                            <tr>
                                <td></td>
                                <td><%=inGroupName %></td>
                                <td colspan="11"></td>
                            </tr>
                            <% 
                                foreach (var quoteItem in inGroupBy.Value as List<EMT.DoneNOW.Core.crm_quote_item>)
                                {
                            %>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <%      }
                                var totalPrice = inGroupBy.Value.ToList().Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                decimal totalAllTaxPrice = 0;  // 该分项的所有的税的汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;"><%=inGroupName %>汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = inGroupBy.Value.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                            }

                                        }
                                    }
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;"><%=inGroupName %>税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += totalAllTaxPrice;  // 所有报价项的税之和
                            %>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(inGroupBy.Value.ToList().Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=  ((decimal)((inGroupBy.Value.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-inGroupBy.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(inGroupBy.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:inGroupBy.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>

                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%
                                    }
                                }



                                if (distributionList != null && distributionList.Count > 0)
                                {%>
                            <tr>
                                <td>配送类型的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <% foreach (var quoteItem in distributionList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>

                            <%}%>
                            <% var distotalPrice = distributionList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                            ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal distotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">配送汇总:</td>
                                <td><%=((decimal)(distotalPrice==null?0:distotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = distributionList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);// 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                distotalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">配送税汇总:</td>
                                <td><%=(distotalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                distotalPrice += distotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += distotalAllTaxPrice;  // 所有报价项的税之和
                            %>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((distributionList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(distotalPrice.ToString()),2).ToString()) %></td>

                            </tr>
                            <%   }
                                if (discountQIList != null && discountQIList.Count > 0)
                                {%>
                            <tr>
                                <td>一次性折扣</td>
                                <td colspan="12"></td>
                            </tr>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent == null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%  // 计算出一次性的报价项的总价 ，转换成百分比
                                    var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                %>
                                <td><%=((decimal)(quoteItem.unit_discount*100/(oneTotalPrice==0?1:oneTotalPrice))).ToString("#0.00")+"%" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.quantity!=null)?(quoteItem.unit_discount*quoteItem.quantity).ToString():"" %></td>
                            </tr>

                            <%}%>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent != null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>

                                <td><%=quoteItem.discount_percent!=null?(quoteItem.discount_percent*100).ToString()+"%":"" %></td>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent).ToString()),2).ToString()):"" %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <%if (oneTimeList != null && oneTimeList.Count > 0)
                                    { %>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent*100/100).ToString()),2).ToString()):"" %></td>
                                <%}
                                    else
                                    { %>
                                <%} %>
                            </tr>

                            <%}%>

                            <% var onetotalPrice = (discountQIList.Where(_ => _.discount_percent == null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) + (oneTimeList != null && oneTimeList.Count > 0 ? discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent * 100 / 100) : 0)); // 该项下的总价 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    // 一次性折扣税汇总，税单独计算，其余汇总不变
                                decimal itemTaxPrice = 0;
                                decimal onetotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                                discountQIList.ForEach(discount =>
                                {
                                    if (discount.discount_percent != null)
                                    { }
                                    else
                                    {
                                        var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                        discount.discount_percent = (discount.unit_discount / (oneTotalPrice == 0 ? 1 : oneTotalPrice));
                                    }
                                    quote_item_tax_cate.ForEach(_ =>
                                    {
                                        var list = oneTimeList.Where(dis => (dis.tax_cate_id == null ? 0 : dis.tax_cate_id) == _.tax_cate_id).ToList();
                                        if (list != null && list.Count > 0)
                                        {
                                            onetotalAllTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent * _.total_effective_tax_rate); // 折扣中需要交税的项
                                            itemTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent);
                                        }

                                    });

                                });  // 在这里首先计算出要一次性折扣的所有的税
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">一次性报价项汇总:</td>
                                <td><%=((decimal)(onetotalPrice==null?0:onetotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <%  if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = oneTimeList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {      %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(itemTaxPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
// totalAllTaxPrice += taxTotalPrice *(decimal) taxcate.total_effective_tax_rate; %>
                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(itemTaxPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                            }

                                        }
                                    }
                                }
                                onetotalPrice += onetotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie -= onetotalAllTaxPrice;  // 所有报价项的税之和
                            %>

                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">一次性税汇总:</td>
                                <td><%=(onetotalAllTaxPrice).ToString("#0.000") %></td>
                            </tr>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td></td>
                                <td></td>
                                <td><%=(decimal.Round(decimal.Parse(onetotalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%}%>
           
                            <% if (optionalItemList != null && optionalItemList.Count > 0)
                                { %>
                                             <tr>
                                <td colspan="9"></td>
                                <td><b>除去可选的汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %></td>
                                <% var thisSum = quoteItemList.Where(_ => _.optional != 1).Sum(_ => _.unit_cost != null ? _.unit_cost * _.quantity : 0);  %>
                                <td><%=((decimal)((quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(thisSum==0?1:thisSum))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">带上税的汇总</td>
                                <td><%=(decimal.Round(decimal.Parse((groupAllTaxPrcie+quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>
                            <tr>
                                <td>可选的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <%  
                                foreach (var quoteItem in optionalItemList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <%}%>

                            <% var optotalPrice = optionalItemList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                           ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal optotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">可选报价项汇总:</td>
                                <td><%=((decimal)(optotalPrice==null?0:optotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = optionalItemList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                optotalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">可选税汇总:</td>
                                <td><%=(optotalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                optotalPrice += optotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += optotalAllTaxPrice;  // 所有报价项的税之和
                            %>


                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((optionalItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(optotalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%  }%>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>全部汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(quoteItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((quoteItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>
                                <td><%=decimal.Round(((decimal)(quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>

                                <td colspan="12" style="text-align: right;">加税汇总</td>
                                <td><%=decimal.Round(((decimal)(groupAllTaxPrcie+quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <%












                                }
                                else
                                {
                                    if (quoteItemList != null && quoteItemList.Count > 0)
                                    {
                                        decimal groupAllTaxPrcie = 0;
                                        var generalList = quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.optional != 1).ToList();
                                        foreach (var quoteItem in generalList)
                                        {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <% }
                            %>
                            <% var totalPrice = generalList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                    ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal totalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">配送汇总:</td>
                                <td><%=((decimal)(totalPrice==null?0:totalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = generalList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);// 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                totalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">税汇总:</td>
                                <td><%=(totalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                totalPrice += totalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += totalAllTaxPrice;  // 所有报价项的税之和
                            %>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>

                                <td><%=(decimal.Round(decimal.Parse(generalList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((generalList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-generalList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(generalList.Sum(_=>_.unit_cost!=null?_.unit_cost:0)==0?1:generalList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(totalPrice.ToString()),2).ToString()) %></td>

                            </tr>
                            <% 
                                // var distributionList = quoteItemList.Where(_ => _.type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();   // 配送类型的报价项
                                if (distributionList != null && distributionList.Count > 0)
                                {%>
                            <tr>
                                <td>配送类型的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <% foreach (var quoteItem in distributionList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>

                            <%}%>
                            <% var distotalPrice = distributionList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                            ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal distotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">配送汇总:</td>
                                <td><%=((decimal)(distotalPrice==null?0:distotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = distributionList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);// 应该交税的报价项的和

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                distotalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">配送税汇总:</td>
                                <td><%=(distotalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                distotalPrice += distotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += distotalAllTaxPrice;  // 所有报价项的税之和
                            %>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((distributionList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(distotalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%   }

                                // var oneTimeList = quoteItemList.Where(_ => _.period_type_id == (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToList();
                                if (discountQIList != null && discountQIList.Count > 0)
                                {%>
                            <tr>
                                <td>一次性折扣</td>
                                <td colspan="12"></td>
                            </tr>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent == null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%  // 计算出一次性的报价项的总价 ，转换成百分比
                                    var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                %>
                                <td><%=((decimal)(quoteItem.unit_discount*100/(oneTotalPrice==0?1:oneTotalPrice))).ToString("#0.00")+"%" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.quantity!=null)?(quoteItem.unit_discount*quoteItem.quantity).ToString():"" %></td>
                            </tr>

                            <%}%>
                            <%foreach (var quoteItem in discountQIList.Where(_ => _.discount_percent != null).ToList())
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>

                                <td><%=quoteItem.discount_percent!=null?(quoteItem.discount_percent*100).ToString()+"%":"" %></td>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent/100*100).ToString()),2).ToString()):"" %></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <%if (oneTimeList != null && oneTimeList.Count > 0)
                                    { %>
                                <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent).ToString()),2).ToString()):"" %></td>
                                <%}
                                    else
                                    { %>
                                <%} %>
                            </tr>

                            <%}%>
                            <% var onetotalPrice = (discountQIList.Where(_ => _.discount_percent == null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) + (oneTimeList != null && oneTimeList.Count > 0 ? discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent * 100 / 100) : 0)); // 该项下的总价 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    //distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    // 一次性折扣税汇总，税单独计算，其余汇总不变
                                decimal itemTaxPrice = 0;
                                decimal onetotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                                discountQIList.ForEach(discount =>
                                {
                                    if (discount.discount_percent != null)
                                    { }
                                    else
                                    {
                                        var oneTotalPrice = oneTimeList != null && oneTimeList.Count > 0 ? (oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)) : 0;
                                        discount.discount_percent = (discount.unit_discount / (oneTotalPrice == 0 ? 1 : oneTotalPrice));
                                    }
                                    quote_item_tax_cate.ForEach(_ =>
                                    {
                                        var list = oneTimeList.Where(dis => (dis.tax_cate_id == null ? 0 : dis.tax_cate_id) == _.tax_cate_id).ToList();
                                        if (list != null && list.Count > 0)
                                        {
                                            onetotalAllTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent * _.total_effective_tax_rate); // 折扣中需要交税的项
                                            itemTaxPrice += (decimal)(list.Sum(dis => (dis.unit_discount != null && dis.unit_price != null && dis.quantity != null) ? (dis.unit_price - dis.unit_discount) * dis.quantity : 0) * discount.discount_percent);
                                        }

                                    });


                                });  // 在这里首先计算出要一次性折扣的所有的税
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">一次性报价项汇总:</td>
                                <td><%=((decimal)(onetotalPrice==null?0:onetotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <%  if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = oneTimeList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {      %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(itemTaxPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
// totalAllTaxPrice += taxTotalPrice *(decimal) taxcate.total_effective_tax_rate; %>
                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(itemTaxPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                            }

                                        }
                                    }
                                }
                                onetotalPrice += onetotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie -= onetotalAllTaxPrice;  // 所有报价项的税之和
                            %>

                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">一次性税汇总:</td>
                                <td><%=(onetotalAllTaxPrice).ToString("#0.000") %></td>
                            </tr>

                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td></td>
                                <td></td>
                                <td><%=(decimal.Round(decimal.Parse(onetotalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%}%>

                   
                            <%// var optionalItemList = quoteItemList.Where(_ => _.optional == 1).ToList();   // 获取到可选的报价项
                                if (optionalItemList != null && optionalItemList.Count > 0)
                                { %>
                                     <tr>
                                <td colspan="9"></td>
                                <td><b>除去可选的汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %></td>

                                <% var thisSum = quoteItemList.Where(_ => _.optional != 1).Sum(_ => _.unit_cost != null ? _.unit_cost * _.quantity : 0);  %>
                                <td><%=((decimal)((quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(thisSum==0?1:thisSum))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">带上税的汇总</td>
                                <td><%=(decimal.Round(decimal.Parse((groupAllTaxPrcie+quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                            </tr>

                            <tr>
                                <td>可选的报价项</td>
                                <td colspan="12"></td>
                            </tr>
                            <%  
                                foreach (var quoteItem in optionalItemList)
                                {%>
                            <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                                <td><%=quoteItem.oid %></td>
                                <td><span class="ITG num"><%=quoteItem.tax_cate_id!=null?(taxAllCateList.IndexOf(quoteItem.tax_cate_id)).ToString():"" %></span><%=quoteItem.name %></td>
                                <td><%=type.First(_=>_.val==quoteItem.type_id.ToString())==null?"":type.First(_=>_.val==quoteItem.type_id.ToString()).show %>
                                </td>
                                <td><%--出厂序号待确定--todo--%></td>
                                <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                                <td><%=quoteItem.unit_price %></td>
                                <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/(quoteItem.unit_price==0?1:quoteItem.unit_price)).ToString()),2)).ToString()+"%":"" %></td>
                                <td><%=quoteItem.unit_discount %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                                <td><%=quoteItem.unit_cost %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                                <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/(quoteItem.unit_cost==0?1:quoteItem.unit_cost)).ToString()),2).ToString())+"%":"" %></td>
                                <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                            </tr>
                            <%}%>
                            <% var optotalPrice = optionalItemList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0); // 该项下的总价 
                                                                                                                                                                                                           ///distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)
                                decimal optotalAllTaxPrice = 0;  // 该类型下的所有税汇总
                            %>
                            <tr>
                                <td colspan="12" style="text-align: right;">可选报价项汇总:</td>
                                <td><%=((decimal)(optotalPrice==null?0:optotalPrice)).ToString("#0.00") %></td>
                            </tr>
                            <% if (quote_item_tax_cate != null && quote_item_tax_cate.Count > 0)
                                {
                                    foreach (var taxcate in quote_item_tax_cate)
                                    {
                                        decimal taxTotalPrice = 0; // 该分组下的所有的税的汇总
                                        var taxQI = optionalItemList.Where(_ => (_.tax_cate_id == null ? 0 : _.tax_cate_id) == taxcate.tax_cate_id).ToList();  // 获取到报价项中选择这个税的报价项
                                        taxTotalPrice = (decimal)taxQI.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);

                                        if (taxQI != null && taxQI.Count > 0)
                                        {
                            %>
                            <tr class="STC">
                                <td colspan="12" style="text-align: right;"><span class="ITG num"><%=(taxAllCateList.IndexOf(taxcate.tax_cate_id)).ToString() %></span><%=quote_item_tax_cate_name.FirstOrDefault(_ => _.val == taxcate.tax_cate_id.ToString()).show %></td>
                                <td><%=(taxTotalPrice * taxcate.total_effective_tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%
                                optotalAllTaxPrice += taxTotalPrice * (decimal)taxcate.total_effective_tax_rate; %>

                            <%
                                var taxCateList = new EMT.DoneNOW.DAL.d_tax_region_cate_tax_dal().GetTaxRegionCate(Convert.ToInt64(taxcate.id)); // 获取该税下的分税
                                if (taxCateList != null && taxCateList.Count > 0)
                                {
                                    foreach (var tc in taxCateList)
                                    {
                            %>
                            <tr class="STCS">
                                <td colspan="12" style="text-align: right;"><%=tc.tax_name %>(税率：<%=(tc.tax_rate * 100).ToString("#0.00") + "%" %>):</td>
                                <td><%=(taxTotalPrice * tc.tax_rate).ToString("#0.00") %></td>
                            </tr>
                            <%}
                                }
                            %>
                            <tr class="ITP">
                                <td colspan="12" style="text-align: right;">可选税汇总:</td>
                                <td><%=(optotalAllTaxPrice).ToString("#0.00") %></td>
                            </tr>
                            <%
                                        }
                                    }
                                }
                                optotalPrice += optotalAllTaxPrice; // 该分组下的总价和加上税
                                groupAllTaxPrcie += optotalAllTaxPrice;  // 所有报价项的税之和
                            %>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((optionalItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                                <td><%=(decimal.Round(decimal.Parse(optotalPrice.ToString()),2).ToString()) %></td>
                            </tr>
                            <%  }%>
                            <tr>
                                <td colspan="9"></td>
                                <td><b>全部汇总：</b></td>
                                <td><%=(decimal.Round(decimal.Parse(quoteItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                                <td><%=((decimal)((quoteItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>
                                <td><%=decimal.Round(((decimal)(quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <tr>
                                <td colspan="12" style="text-align: right;">税汇总</td>
                                <td><%=groupAllTaxPrcie.ToString("#0.00") %></td>
                            </tr>
                            <tr>

                                <td colspan="12" style="text-align: right;">加税汇总</td>
                                <td><%=decimal.Round(((decimal)(groupAllTaxPrcie+quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                            </tr>
                            <% 
                                    }
                                } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
    <div id="menu">
        <ul style="width: 220px;">
            <li onclick="EditQuoteItem()"><i class="menu-i1"></i>修改报价项</li>
            <li onclick="DeleteQuoteItem()"><i class="menu-i1"></i>删除报价项</li>
        </ul>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/Common/SearchBody.js"></script>
<script>
    //groupBy

    $(function () {
        <%--$("#groupBy").val('<%=groupBy %>');--%>
        $("#groupBy").change(function () {
            var groupType = $(this).val();
            var quote_id = $("#quoteDropList").val();
            location.href = "QuoteItemManage?quote_id=" + quote_id + "&group_by=" + groupType;
        })

        $("#quoteDropList").change(function () {
            var groupType = $("#groupBy").val();
            var quote_id = $(this).val();
            location.href = "QuoteItemManage?quote_id=" + quote_id + "&group_by=" + groupType;
        })

        var show_each_tax_in_tax_group = $("#show_each_tax_in_tax_group").val();
        var show_each_tax_in_tax_period = $("#show_each_tax_in_tax_period").val();
        var show_tax_cate = $("#show_tax_cate").val();
        var show_tax_cate_superscript = $("#show_tax_cate_superscript").val();
        if (show_each_tax_in_tax_group == 0) {
            // $(".ITG").css('display', 'none');  // 隐藏掉这个tr
            $(".ITG").css("display", "none");
        } else {
            $(".ITG").css('display', '');
        }
        if (show_each_tax_in_tax_period == 0) {
            if ($("#groupBy").val() == <%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.CYCLE %>) {
                $(".ITP").css('display', 'none');  // 隐藏掉这个tr
            }
        }
        else {
            $(".ITP").css('display', '');
        }
        if (show_tax_cate == 0) {
            $(".STC").css('display', 'none');  // 隐藏掉这个tr
        } else {
            $(".STC").css('display', '');
        }
        if (show_tax_cate_superscript == 0) {
            $(".STCS").css('display', 'none');
            // $(".STCS").hide();
        } else {
            $(".STCS").css('display', '');
            // $(".STCS").show();
        }

        // 校验该报价的商机是否已经关联报价单，已经关联则不添加，不删除，不更改主报价
        CheckRelationSaleOrder();


    })
    function EditQuoteItem() {

        window.open("QuoteItemAddAndUpdate?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteEdit %>', 'left=200,top=200,width=900,height=750', false);
    }
    // 
    function AddQuoteItem(openType) {
        CheckRelationSaleOrder();

        var isRelation = $("#isRelationSaleOrder").val();
        if (isRelation == 1) {
            alert('报价已关联销售单，不允许新增报价项');
            return false;
        }
        <%--window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %> ', openType, 'left=200,top=200,width=960,height=750', false);--%>
        window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=' + openType, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>', 'left=200,top=200,width=960,height=750', false);
    }

    function DeleteQuoteItem() {
        CheckRelationSaleOrder();

        var isRelation = $("#isRelationSaleOrder").val();
        if (isRelation == 1) {
            alert('报价已关联销售单，不允许删除报价项');
            return false;
        }
        $.ajax({
            type: "GET",
            url: "../Tools/QuoteAjax.ashx?act=deleteQuoteItem&id=" + entityid,
            success: function (data) {
                alert(data);
                history.go(0);
            }

        })
    }

    // 设置当前报价为主报价
    function SetPrimaryQuote() {
        CheckRelationSaleOrder();

        var isRelation = $("#isRelationSaleOrder").val();
        if (isRelation == 1) {
            alert('报价已关联销售单，不允许更换主报价项');
            return false;
        }
        var selectQuoteId = $("#quoteDropList").val();
        if (selectQuoteId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteAjax.ashx?act=setPrimaryQuote&id=" + selectQuoteId,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }

            })
        }
    }
    // 判断改报价是否关联销售订单
    function CheckRelationSaleOrder() {
        // isRelationSaleOrder
        $.ajax({
            type: "GET",
            url: "../Tools/QuoteAjax.ashx?act=isSaleOrder&id=" + <%=quote.id %>,
            success: function (data) {
                if (data == "True") {
                    $("#isRelationSaleOrder").val("1");
                }
            }

        })
    }
</script>
