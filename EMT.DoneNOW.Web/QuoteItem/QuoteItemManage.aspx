<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemManage.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteItem.QuoteItemManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>报价项管理</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min2.2.2.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
     <link href="../Content/Quotebaojiaxiang.css" rel="stylesheet" />
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
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;" class="icon-1"></i>
                    新增报价项
                  <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);">工时</a></li>
                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);"></a>产品</li>
                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.SERVICE %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);"></a>服务</li>
                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);"></a>成本</li>

                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);"></a>费用</li>
                        <li><a href="#" onclick="window.open('QuoteItemAddAndUpdate.aspx?quote_id=<%=quote.id %>&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES %> ','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteItemAdd %>','left=200,top=200,width=960,height=750', false);"></a>配送费用</li>


                    </ul>

                </li>
                <li>工具<i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><a href="#">置为主报价</a></li>
                        <li><a href="#">导入报价项</a></li>
                        <li><a href="#">新建配置项</a></li>
                        <li><a href="#">新建定期服务合同</a></li>
                        <li><a href="#" onclick="window.open('../Opportunity/ViewOpportunity?id=<%=quote.opportunity_id %>','<%=EMT.DoneNOW.DTO.OpenWindow.OpportunityView %>','left=200,top=200,width=960,height=750', false);">查看商机</a></li>
                        <li><a href="#">关闭报价</a></li>
                        <li><a href="#" onclick="window.open('../Quote/QuoteLost?id=<%=quote.id %>','<%=EMT.DoneNOW.DTO.OpenWindow.OpportunityLose %>','left=200,top=200,width=960,height=750', false);">丢失报价</a></li>
                    </ul>
                </li>
                <li><a href="#" onclick="window.open('../Quote/QuoteAddAndUpdate.aspx?id=<%=quote.id %>','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteEdit %>','left=200,top=200,width=960,height=750', false);">编辑报价单</a></li>
                <li><a href="#">预览电子报价单</a></li>
                <li><a href="#">打印</a></li>

                <li style="float: right;">报价<asp:DropDownList ID="quoteDropList" runat="server"></asp:DropDownList><i style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -63px; float: right;" class="icon-1" onclick="SetPrimaryQuote()" ></i><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0; float: right;" class="icon-1" onclick="window.open('../Quote/QuoteAddAndUpdate.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>','left=200,top=200,width=960,height=750', false);"></i></li>
            </ul>
        </div>
        <div class="quoteItemListDiv">
            <div class="grid">
                <div id="quoteSettingDiv">
                     <span class="FieldLabels">分组方式:</span>
                    <div class="FieldSelect">
                        <select name="groupBy" id="groupBy">
                            <option value="no">不分组</option>
                            <option value="cycle">周期</option>
                            <option value="product">产品</option>
                        </select>
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
                    <%if (groupList != null && groupList.Count > 0)
                        {
                            foreach (var item in groupList)
                            {%>
                    <tr>

                        <% var groupName = "";
                            switch (groupBy)
                            {
                                case "cycle":
                                    var cycleFiled =   new EMT.DoneNOW.DAL.d_general_dal().GetDictionary(new EMT.DoneNOW.DAL.d_general_table_dal().GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE));
                                    groupName = cycleFiled.First(_ => _.val.ToString() == item.Key.ToString()) != null ? cycleFiled.First(_ => _.val.ToString() == item.Key.ToString()).show : "无周期";
                                    break;
                                case "product":
                                    if (!string.IsNullOrEmpty(item.Key.ToString()))
                                    {
                                        var product = new EMT.DoneNOW.BLL.IVT.ProductBLL().GetProduct(long.Parse(item.Key.ToString()));
                                        if (product != null)
                                        {
                                            groupName = product.product_name;
                                        }
                                    }
                                    else
                                    {
                                        groupName = "无产品";
                                    }
                                    break;
                                default:
                                    break;
                            } %>
                        <td><%=groupName %></td>
                        <td colspan="12"></td>
                    </tr>
                    <% foreach (var quoteItem in item.Value as List<EMT.DoneNOW.Core.crm_quote_item>)
                        {
                    %>
                    <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                        <td><%=quoteItem.oid %></td>
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                         <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>
                    <% }%>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                        <td><%=(decimal.Round(decimal.Parse(item.Value.ToList().Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=  ((decimal)((item.Value.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)==0?1:item.Value.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>

                        <td><%=(decimal.Round(decimal.Parse(item.Value.ToList().Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
                    </tr>
                    <%      
                        }%>
                    <tr>
                          <td colspan="9"></td>
                        <td><b>分组汇总：</b> <span></span>
                            <span></span>
                        </td>
                        <td><%=(decimal.Round(decimal.Parse(groupList.Values.Sum(value=>value.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %>
                           
                        </td>
                        <td>
                            <%  var totalSum = groupList.Values.Sum(value => value.Sum((_ => _.unit_price != null ? _.unit_price * _.quantity : 0)));
                                var totalCost = groupList.Values.Sum(value => value.Sum((_ => _.unit_cost != null ? _.unit_cost * _.quantity : 0))); %>
                            <%=((decimal)(((totalSum-totalCost)*100/(totalCost==0?1:totalCost)))).ToString("#0.00")+"%" %></td>


                        <td><%=(decimal.Round(decimal.Parse(groupList.Values.Sum(value=>value.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)).ToString()),2).ToString()) %></td>
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
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                        <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                          <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                         <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>

                    <%}%>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                           <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((distributionList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                         <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
                      
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
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td></td>
                        <td></td>
                        <td><%=quoteItem.unit_price %></td>

                        <td><%=quoteItem.discount_percent!=null?quoteItem.discount_percent.ToString()+"%":"" %></td>
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
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
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

                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                        <td></td>
                        <td></td>
                        <td><%=(decimal.Round(decimal.Parse((discountQIList.Where(_=>_.discount_percent!=null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)+(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent*100/100):0)).ToString()),2).ToString()) %></td>
                    </tr>
                    <%}%>
                                 <tr>
                        <td colspan="9"></td>
                        <td><b>除去可选的汇总：</b></td>
                        <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                        <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent==null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                    </tr>
                       <% if (optionalItemList != null && optionalItemList.Count > 0)
                        { %>
                    <tr>
                        <td>可选的报价项</td>
                         <td colspan="12"></td>
                    </tr>
                    <%  
                        foreach (var quoteItem in optionalItemList)
                        {%>
                    <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                        <td><%=quoteItem.oid %></td>
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                      <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount*100/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                       <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                       <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>
                    <%}%>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                          <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((optionalItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                          <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
                    </tr>
                    <%  }%>

                                <tr>
                        <td colspan="9"></td>
                        <td><b>全部汇总：</b></td>
                        <td><%=(decimal.Round(decimal.Parse(quoteItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((quoteItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                        <td><%=decimal.Round(((decimal)(quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent!=null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
                    </tr>
                    <%     }
                        else
                        {
                            if (quoteItemList != null && quoteItemList.Count > 0)
                            {
                                var generalList = quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.optional != 1).ToList();
                                foreach (var quoteItem in generalList)
                                {%>
                    <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                        <td><%=quoteItem.oid %></td>
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                        <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                       <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>
                    <% }
                    %>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                
                         <td><%=(decimal.Round(decimal.Parse(generalList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((generalList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-generalList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/(generalList.Sum(_=>_.unit_cost!=null?_.unit_cost:0)==0?1:generalList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0)))).ToString("#0.00")+"%" %></td>
                        <td><%=(decimal.Round(decimal.Parse(generalList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
                     
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
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                           <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                    <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>

                    <%}%>
                    <tr>
                        <td colspan="9"></td>
                          <td><b>汇总：</b></td>
                           <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((distributionList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/distributionList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                         <td><%=(decimal.Round(decimal.Parse(distributionList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
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
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td></td>
                        <td></td>
                        <td><%=quoteItem.unit_price %></td>

                        <td><%=quoteItem.discount_percent!=null?quoteItem.discount_percent.ToString()+"%":"" %></td>
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
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td></td>
                        <td></td>
                        <td></td>

                         <td><%=quoteItem.discount_percent!=null?(quoteItem.discount_percent*100).ToString()+"%":"" %></td>
                         <td><%=oneTimeList!=null&&oneTimeList.Count>0?(decimal.Round(decimal.Parse((oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0)*quoteItem.discount_percent/100).ToString()),2).ToString()):"" %></td>
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
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                        <td></td>
                        <td></td>
                        <td><%=(decimal.Round(decimal.Parse((discountQIList.Where(_=>_.discount_percent!=null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)+(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                    </tr>
                    <%}%>

                    <tr>
                        <td colspan="9"></td>
                        <td><b>除去可选的汇总：</b></td>
                         <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0)).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/quoteItemList.Where(_=>_.optional!=1).Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                        <td><%=(decimal.Round(decimal.Parse((quoteItemList.Where(_=>_.optional!=1).Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent!=null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0)).ToString()),2).ToString()) %></td>
                    </tr>

                    <%// var optionalItemList = quoteItemList.Where(_ => _.optional == 1).ToList();   // 获取到可选的报价项
                        if (optionalItemList != null && optionalItemList.Count > 0)
                        { %>
                    <tr>
                        <td>可选的报价项</td>
                         <td colspan="12"></td>
                    </tr>
                    <%  
                        foreach (var quoteItem in optionalItemList)
                        {%>
                    <tr data-val="<%=quoteItem.id %>" class="dn_tr">
                        <td><%=quoteItem.oid %></td>
                        <td><%=quoteItem.name %></td>
                        <td><% var type = "";
                                switch (quoteItem.type_id)
                                {
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS:
                                        type = "工时";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST:
                                        type = "费用";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION:
                                        type = "成本";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT:
                                        type = "折扣";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT:
                                        type = "产品";
                                        break;
                                    case (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES:
                                        type = "配送费用";
                                        break;
                                    default:
                                        break;
                                } %>
                            <%=type %>
                        </td>
                        <td>出厂序号待确定--todo</td>
                        <td><%=quoteItem.quantity!=null?((int)quoteItem.quantity).ToString():"" %></td>
                        <td><%=quoteItem.unit_price %></td>
                        <%--decimal.Round(decimal.Parse("0.3333333"),2)   Math.Round(Convert.ToDouble((quoteItem.unit_discount/quoteItem.unit_price,2,MidpointRounding.AwayFromZero)))  --%>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse((quoteItem.unit_discount/quoteItem.unit_price).ToString()),2)).ToString()+"%":"" %></td>
                        <td><%=quoteItem.unit_discount %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null)?(quoteItem.unit_price-quoteItem.unit_discount).ToString():"" %></td>
                        <td><%=quoteItem.unit_cost %></td>
                      <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount-quoteItem.unit_cost)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                        <td><%=(quoteItem.unit_cost!=null&&quoteItem.unit_price!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_cost)*100/quoteItem.unit_cost).ToString()),2).ToString())+"%":"" %></td>
                        <td><%=(quoteItem.unit_discount!=null&&quoteItem.unit_price!=null&&quoteItem.quantity!=null)?(decimal.Round(decimal.Parse(((quoteItem.unit_price-quoteItem.unit_discount)*quoteItem.quantity).ToString()),2).ToString()):"" %></td>
                    </tr>
                    <%}%>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>汇总：</b></td>
                          <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((optionalItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/optionalItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                         <td><%=(decimal.Round(decimal.Parse(optionalItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0).ToString()),2).ToString()) %></td>
                    </tr>
                    <%  }%>
                    <tr>
                        <td colspan="9"></td>
                        <td><b>全部汇总：</b></td>
                        <td><%=(decimal.Round(decimal.Parse(quoteItemList.Sum(_=>(_.unit_cost!=null&&_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount-_.unit_cost)*_.quantity:0).ToString()),2).ToString()) %></td>
                        <td><%=((decimal)((quoteItemList.Sum(_=>_.unit_price!=null?_.unit_price*_.quantity:0)-quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))*100/quoteItemList.Sum(_=>_.unit_cost!=null?_.unit_cost*_.quantity:0))).ToString("#0.00")+"%" %></td>
                        <td><%=decimal.Round(((decimal)(quoteItemList.Sum(_=>(_.unit_discount!=null&&_.unit_price!=null&&_.quantity!=null)?(_.unit_price-_.unit_discount)*_.quantity:0)-discountQIList.Where(_=>_.discount_percent!=null).ToList().Sum(_=>(_.unit_discount!=null&&_.quantity!=null)?_.unit_discount*_.quantity:0)-(oneTimeList != null && oneTimeList.Count > 0?discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_=>oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0)*_.discount_percent):0))),2).ToString() %></td>
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
        $("#groupBy").val('<%=groupBy %>');
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

    })
    function EditQuoteItem() {

        window.open("QuoteItemAddAndUpdate?id=" + entityid, '<%=EMT.DoneNOW.DTO.OpenWindow.QuoteEdit %>', 'left=200,top=200,width=900,height=750', false);
    }
    function DeleteQuoteItem() {
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
</script>
