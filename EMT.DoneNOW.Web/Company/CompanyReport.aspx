<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyReport.aspx.cs" Inherits="EMT.DoneNOW.Web.Company.CompanyReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/AccountReport.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding-top: 15px; padding-bottom: 15px; padding-left: 0px;margin-left: calc(50% - 325px);">
            <table width="650" cellspacing="0" cellpadding="2" style="border: 1px solid #BBBBBB;" id="Table1">
                <tbody>
                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table2">

                                <tbody>
                                    <tr>
                                        <td id="txtBlack8" align="left"><b>客户简介</b></td>
                                        <td id="txtBlack8" align="right"></td>

                                    </tr>
                                    <tr>
                                        <td id="txtBlack8" align="Left">
                                            <b><%=account.name %></b>
                                            <br />
                                            <%=countryName %>&nbsp;<%=provinceName %>&nbsp;<%=cityName %>&nbsp;<%=districtName %>&nbsp; <br />
                                            <%=accLocation!=null?accLocation.address:"" %><br />
                                            <%=accLocation!=null?accLocation.additional_address:"" %><br />
                                            <%=accLocation!=null?accLocation.postal_code:"" %><br />
                                        </td>
                                        <td id="txtBlack8" align="right" valign="bottom"><b>创建时间:</b>&nbsp;<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(account.create_time).ToString("yyyy-MM-dd HH:mm") %></td>

                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p>

                <!-- 
		Child accounts
		-->
            </p>
            <table width="650" style="border: 1px solid #BBBBBB;" id="Table3">
                <tbody>
                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table4">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>子客户</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td>

                            <% if (subAccountList != null && subAccountList.Count > 0)
                                { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table5">
                                <tbody>
                                    <tr>

                                        <td width="110" id="txtBlack8" style="padding-left: 15px; vertical-align: top"><b>客户名称</b></td>
                                        <td width="150" id="txtBlack8" style="vertical-align: top"><b>类型</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>最近活动时间</b></td>
                                    </tr>
                                    <% foreach (var subAccount in subAccountList)
                                        {
                                            var typeName = "";
                                            if (subAccount.type_id != null)
                                            {
                                                var thisGen =  genDal.FindById((long)subAccount.type_id);
                                                if (thisGen != null)
                                                    typeName = thisGen.name;
                                            }
                                            %>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><%=subAccount.name %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=typeName %></td>
                                    </tr>
                                        <%} %>
                                    
                                </tbody>
                            </table>
                            <%}
                            else
                            { %>
                             无子客户
                            <%} %>
                        </td>
                    </tr>

                    <!-- 
		Contacts
		-->

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table6">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>联系人</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td>
                              <% if (contactList != null && contactList.Count > 0)
                                  { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table7">
                                <tbody>
                                    <tr>

                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><b>姓名</b></td>
                                        <td id="txtBlack8" style="vertical-align: top"><b>头衔</b></td>
                                        <td id="txtBlack8" style="vertical-align: top"><b>电话 </b></td>
                                        <td id="txtBlack8" style="vertical-align: top"><b>最近活动时间</b></td>
                                        <td id="txtBlack8" style="vertical-align: top"><b>E-Mail</b></td>

                                    </tr>
                                    <% foreach (var contact in contactList)
                                        {
                                            %>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><%=contact.name %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=contact.title %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=contact.phone %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%if (contact.last_activity_time != null)
                                                                                           { %><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)contact.last_activity_time).ToString("yyyy-MM-dd HH:mm") %><%} %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=contact.email %></td>
                                    </tr>
                                       <% } %>
                                    
                                </tbody>
                            </table>
                            <%}else{ %>
                            无联系人
                            <%} %>
                        </td>
                    </tr>

                    <!-- 
		Opportunity History
		-->

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table8">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>商机历史</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td>
                              <% if (oppoList != null && oppoList.Count > 0)
                                  { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table9">

                                <tbody>
                                    <tr>
                                        <td width="110" id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><b>商机名称</b></td>
                                        <td width="110" id="txtBlack8" style="vertical-align: top"><b>收入</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>成功概率</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>预计完成时间</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>配置项名称</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>状态</b></td>
                                    </tr>
                                    <% foreach (var oppo in oppoList)
                                        {%>
                                      <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><%=oppo.name %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=oppoBll.ReturnOppoRevenue(oppo.id).ToString("#0.00") %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=oppo.probability!=null?((int)oppo.probability).ToString()+"%":"" %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=oppo.projected_close_date!=null?((DateTime)oppo.projected_close_date).ToString("yyyy-MM-dd"):"" %></td>
                                        <td id="txtBlack8" style="vertical-align: top"></td>
                                        <td id="txtBlack8" style="vertical-align: top"><% var thisSta = oppoStaList.FirstOrDefault(_ => _.id == oppo.status_id); %>  <%=thisSta!=null?thisSta.name:"" %></td>
                                    </tr>
                                        <%} %>
                                  


                                </tbody>
                            </table>
                            <%} else{ %>
                            无商机
                            <%} %>
                        </td>
                    </tr>

                    <!-- 
		User Defined fields
		-->

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table10">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>用户自定义字段</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td>
                            <% if (companyUdfList != null && companyUdfList.Count > 0)
                                { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table11">

                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><b>字段名</b></td>
                                        <td width="420" id="txtBlack8" style="vertical-align: top"><b>字段值</b></td>
                                    </tr>
                                    <% foreach (var udf in companyUdfList)
                                        {%>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><%=udf.name %></td>
                                       
                                        <td id="txtBlack8" style="vertical-align: top">
                                             <% 
                                                 EMT.DoneNOW.DTO.UserDefinedFieldValue thisValue = null;
                                                 if (companyUdfValueList != null && companyUdfValueList.Count > 0)
                                                 {
                                                     thisValue = companyUdfValueList.FirstOrDefault(_ => _.id == udf.id);
                                                 }
                                                 if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT || udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT || udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                                 { %>
                                            <%=thisValue != null ? thisValue.value.ToString() : "" %>
                                            <%}else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                { %>
                            <%=thisValue == null ? "" : ((DateTime)thisValue.value).ToString("yyyy-MM-dd") %>
                            <%} else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {
                                    if (udf.value_list != null && udf.value_list.Count > 0 && thisValue != null && !string.IsNullOrEmpty(thisValue.ToString()))
                                    {
                                        var selectValue = udf.value_list.FirstOrDefault(_ => _.val == thisValue.ToString());
                            %>
                            <%=selectValue == null ? "" : selectValue.show %>
                            <%
                                    }
                                } %>

                                        </td>

                                    </tr>
                                        <%} %>
                                </tbody>
                            </table>

                            <%} else
                            { %>
                            无自定义字段
                            <%} %>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table12">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>配置项</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td>
                            <% if (insProList != null && insProList.Count > 0)
                                { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table13">
                                <tbody>
                                    <tr>
                                        <td width="155" id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><b>配置项名称</b></td>
                                        <td width="125" id="txtBlack8" style="vertical-align: top"><b>安装日期</b></td>
                                    </tr>
                                <%foreach (var insPro in insProList)
                                    {
                                        var product = ipDal.FindNoDeleteById(insPro.product_id);
                                        if (product == null)
                                        {
                                            continue;
                                        }
                                        %>
                                     <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><%=product.name %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=insPro.start_date!=null?((DateTime)insPro.start_date).ToString("yyyy-MM-dd"):"" %></td>

                                    </tr>
                                   <% } %>
                                </tbody>
                            </table>
                            <%}
                            else
                            { %>
                            无配置项
                            <%} %>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table14">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>待办</b></td>
                                    </tr>
                                </tbody>
                            </table>

                        </td>
                    </tr>

                    <tr>
                        <td><% if (todoList != null && todoList.Count > 0)
                                {
                                    todoList = noteList.OrderByDescending(_ => _.start_date).ToList();
                                    %>
                            
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table15">

                                <tbody>
                                    <tr>

                                        <td width="50" id="txtBlack8" style="padding-left: 15px; vertical-align: top;"><b>活动类型</b></td>
                                        <td width="110" id="txtBlack8" style="vertical-align: top"><b>开始时间</b></td>
                                        <td width="110" id="txtBlack8" style="vertical-align: top"><b>完成时间</b></td>
                                        <td width="155" id="txtBlack8" style="vertical-align: top"><b>负责人</b></td>
                                    </tr>
                                       <%foreach (var todo in todoList)
                                           { %>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><% var thisAct = actTypeList.FirstOrDefault(_ => _.id == todo.action_type_id); %>  <%=thisAct!=null?thisAct.name:"" %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(todo.start_date).ToString("yyyy-MM-dd HH:mm") %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%=todo.complete_time!=null?EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)todo.complete_time).ToString("yyyy-MM-dd HH:mm"):"" %></td>
                                        <td id="txtBlack8" style="vertical-align: top"><%var thisRes = resList.FirstOrDefault(_ => _.id == todo.resource_id); %> <%=thisRes!=null?thisRes.name:"" %> </td>
                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                             <%}
                            else
                            { %>
                            无待办信息
                            <%} %>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table16">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>备注</b></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td><% if (noteList != null && noteList.Count > 0)
                                {
                                    noteList = noteList.OrderByDescending(_ => _.start_date).ToList();

                                    %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table17">

                                <tbody>
                                     <%foreach (var note in noteList)
                                         {
                                             var thisAct = actTypeList.FirstOrDefault(_ => _.id == note.action_type_id);
                                             var thisCreate = resList.FirstOrDefault(_ => _.id == note.create_user_id);
                                             var thisRes = resList.FirstOrDefault(_ => _.id == note.resource_id);
                                             %>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px;">  <%=thisAct!=null?thisAct.name:"" %>&nbsp;<%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(note.start_date).ToString("yyyy-MM-dd HH:mm") %>
                                            &nbsp;创建人：<%=thisCreate!=null?thisCreate.name:"" %>&nbsp; 指派对象： <%=thisRes!=null?thisRes.name:"" %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px;">
                                            <%=note.description %>
                                        </td>
                                    </tr>
                                         <%} %>
                                
                                </tbody>
                            </table>
                             <%}
                            else
                            { %>
                            无备注信息
                            <%} %>
                        </td>
                    </tr>

                    <!-- 
		Opportunity Detail
		-->

                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" bgcolor="#eeeeee" id="Table18">
                                <tbody>
                                    <tr>
                                        <td width="200" id="txtBlack8" align="left"><b>商机详情</b></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <% if (oppoList != null && oppoList.Count > 0)
                                { %>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table19">
                                <tbody>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px;">
                                               <% foreach (var oppo in oppoList)
                                                   {
                                                       var priProduct = produList.FirstOrDefault(_ => _.id == oppo.primary_product_id);
                                                       var oppoSource = oppoSourceList.FirstOrDefault(_ => _.id == oppo.source_id);
                                                       var stratDiffDay = 0;
                                                       var thisStage = oppoStageList.FirstOrDefault(_=>_.id==oppo.stage_id);
                                                       %>
                                            <table style="margin-top: 10px;" width="605" cellspacing="0" cellpadding="2" id="Table20">
                                                <tbody>
                                                    <tr>
                                                        <td>

                                                            <table width="605" cellspacing="0" cellpadding="3" border="0" id="Table21">
                                                                <tbody>
                                                                    <tr>
                                                                        <td width="25%" id="txtBlack8" valign="top"><b>商机:</b></td>
                                                                        <td width="25%" id="txtBlack8" valign="top"><%=priProduct!=null?priProduct.name+',':"" %> <%=oppo.name %></td>
                                                                        <td width="25%" id="txtBlack8" valign="top">&nbsp;</td>
                                                                        <td width="25%" id="txtBlack8" valign="top">&nbsp;</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>来源:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=oppoSource!=null?oppoSource.name:"" %></td>
                                                                        <td id="txtBlack8" valign="top">&nbsp;</td>
                                                                        <td id="txtBlack8" valign="top">&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>

                                                            <table style="margin-top: 10px;" width="605" cellspacing="0" cellpadding="3" border="0" id="Table22">
                                                                <tbody>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top" width="25%"><b>商机第一次确认日期:</b></td>
                                                                        <td id="txtBlack8" valign="top" width="25%"><%=oppo.projected_begin_date!=null?((DateTime)oppo.projected_begin_date).ToString("yyyy-MM-dd"):"" %></td>
                                                                        <td id="txtBlack8" valign="top" width="50%"><%if (oppo.projected_begin_date != null){ stratDiffDay = DateTime.Now.Subtract(((DateTime)oppo.projected_begin_date)).Days;%> 商机已经开始<%=stratDiffDay<0?0:stratDiffDay %>天 <%} %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>双方第一次碰面日期:</b></td>
                                                                        <td id="txtBlack8" valign="top"></td>
                                                                        <td id="txtBlack8" valign="top"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>当前阶段:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=thisStage!=null?thisStage.name:"" %></td>
                                                                        <td id="txtBlack8" valign="top"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>预计完成日期:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=oppo.projected_close_date!=null?((DateTime)oppo.projected_close_date).ToString("yyyy-MM-dd"):"" %></td>
                                                                        <td id="txtBlack8" valign="top"><%if (oppo.probability != null)
                                                                                                            {%> <%=oppo.probability %>%成功概率 <%} %> </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>

                                                            <table style="margin-top: 10px;" width="605" cellspacing="0" cellpadding="3" border="0" id="Table23">
                                                                <tbody>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top" width="30%"><b>专业费用:</b></td>
                                                                        <td id="txtBlack8" valign="top" width="70%"><%=(oppo.ext1??0).ToString("#0.00") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>培训费用:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=(oppo.ext2??0).ToString("#0.00") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>硬件费用:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=(oppo.ext3??0).ToString("#0.00") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>月度使用情况:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=(oppo.ext4??0).ToString("#0.00") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>其他费用:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=(oppo.ext5??0).ToString("#0.00") %></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>

                                                            <table width="605" cellspacing="0" cellpadding="3" border="0" style="margin-top: 10px;" id="Table24">
                                                                <tbody>
                                                                    <tr>
                                                                        <td id="txtBlack8" colspan="2" bgcolor="#eeeeee"><b>阻挡销售工作推进的主要困难</b></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>市场情况:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=oppo.market %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top" width="30%"><b>当前困难:</b></td>
                                                                        <td id="txtBlack8" valign="top" width="70%"><%=oppo.barriers %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>所需帮助:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=oppo.help_needed %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8" valign="top"><b>后续跟进:</b></td>
                                                                        <td id="txtBlack8" valign="top"><%=oppo.next_step %></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>

                                                            <table style="padding-top: 10px;" width="605" cellspacing="0" cellpadding="3" border="0" id="Table25">
                                                                <tbody>
                                                                    <tr>
                                                                        <td id="txtBlack8" colspan="2" bgcolor="#eeeeee"><b>商机自定义信息</b></td>
                                                                    </tr>

                                                                       <% foreach (var udf in oppoUdfList)
                                        {%>
                                    <tr>
                                        <td id="txtBlack8" style="padding-left: 15px; vertical-align: top"><%=udf.name %></td>
                                       
                                        <td id="txtBlack8" style="vertical-align: top">
                                             <% 
                                                 EMT.DoneNOW.DTO.UserDefinedFieldValue thisValue = null;
                                                 var thisOppoUdfValueList = udfBLL.GetUdfValue(EMT.DoneNOW.DTO.DicEnum.UDF_CATE.OPPORTUNITY, oppo.id, oppoUdfList);
                                                 if (thisOppoUdfValueList != null && thisOppoUdfValueList.Count > 0)
                                                 {
                                                     thisValue = thisOppoUdfValueList.FirstOrDefault(_ => _.id == udf.id);
                                                 }
                                                 if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT || udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT || udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                                 { %>
                                            <%=thisValue != null ? thisValue.value.ToString() : "" %>
                                            <%}else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                { %>
                            <%=thisValue == null ? "" : ((DateTime)thisValue.value).ToString("yyyy-MM-dd") %>
                            <%} else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {
                                    if (udf.value_list != null && udf.value_list.Count > 0 && thisValue != null && !string.IsNullOrEmpty(thisValue.ToString()))
                                    {
                                        var selectValue = udf.value_list.FirstOrDefault(_ => _.val == thisValue.ToString());
                            %>
                            <%=selectValue == null ? "" : selectValue.show %>
                            <%
                                    }
                                } %>

                                        </td>

                                    </tr>
                                        <%} %>
                                                                </tbody>
                                                            </table>

                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <br />
                                            <br />
                                            <%} %>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                               <%}
                            else
                            { %>
                            无商机
                            <%} %>
                        </td>
                    </tr>

                </tbody>
            </table>
            <p>
            </p>
            <table width="650" cellspacing="0" cellpadding="2" id="Table26">
                <tbody>
                    <tr>
                        <td>
                            <table width="642" cellspacing="0" cellpadding="3" border="0" id="Table27">
                                <tbody>
                                    <tr>
                                        <td id="txtBlack8" align="center"><b>报告生成时间 :</b>&nbsp;<%=DateTime.Now.ToString("yyyy-MM-dd") %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>



        </div>
    </form>
</body>
</html>
