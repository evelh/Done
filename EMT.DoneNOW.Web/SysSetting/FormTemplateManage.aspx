<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormTemplateManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.FormTemplateManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/FromTemp.css" rel="stylesheet" />
    <title></title>
    <style>
        li {
            list-style: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">表单模板(<%=typeName %>)</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -128px -32px;" class="icon-1"></i>
                    <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" /></li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <table style="width: 668px;" cellpadding="0" cellspacing="0">
            <tbody>
                <tr>
                    <td colspan="3">
                        <div class="PageLevelInstruction">
                            <span id="AllowSaveTemplatesLabel" class="lblNormalClass" style="font-weight: normal;">模板允许您预先填充可以加载到新实例中的常用数据的表单.
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="DivSectionOnly">
                            <table width="100%" cellpadding="0" cellspacing="0">
                                <tbody>
                                    <tr>
                                        <td style="width: 238px;">
                                            <div class="FieldLabel">
                                                <span id="FavoriteNameLabel" class="lblNormalClass" style="font-weight: bold;">模板名称</span><div class="required">*</div>
                                            </div>
                                            <span id="txt_favorite_name" style="display: inline-block;">
                                                <input name="tmpl_name" type="text" value="<%=isAdd&&temp!=null?"复制：":"" %><%=temp!=null?temp.tmpl_name:"" %>" maxlength="50" id="" class="txtBlack8Class" style="width: 162px;" /></span>
                                        </td>
                                        <td style="width: 220px;">
                                            <div class="FieldLabel">
                                                <span id="SpeedCodeLabel" class="lblNormalClass" style="font-weight: bold;">快速代码</span><div class="required">*</div>
                                            </div>
                                            <span id="txt_speed_code" style="display: inline-block;">
                                                <input name="speed_code" type="text" maxlength="10" id="speed_code" class="txtBlack8Class" style="width: 120px;" value="<%=!isAdd&&temp!=null?temp.speed_code:"" %>" /></span>
                                        </td>
                                        <td class="checkbox" style="padding-top: 4px;">
                                            <span id="chk_active"><span class="txtBlack8Class">
                                                <input id="isActive" type="checkbox" name="isActive" <%if (isAdd || (temp != null && temp.is_active == 1))
                                                    { %>
                                                    checked="checked" <%} %> style="vertical-align: middle;" /></span></span>
                                            <div class="FieldLabel" style="display: inline;">
                                                <span id="ActiveLabel" class="lblNormalClass" style="font-weight: normal;">激活</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align: top;">
                                            <div class="FieldLabel">
                                                <span id="FavoriteDescriptionLabel" class="lblNormalClass" style="font-weight: bold;">表单描述</span>
                                            </div>
                                            <span id="txt_favorite_description" class="DescriptionTextbox" style="display: inline-block;">
                                                <textarea name="remark" id="remark" class="txtBlack8Class" maxlength="500" style="width: 162px;"><%=temp!=null?temp.remark:"" %></textarea></span>
                                        </td>
                                        <td rowspan="2" style="vertical-align: top;">
                                            <table width="100%" class="AvailableToTable" cellpadding="0" cellspacing="0">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="2">
                                                            <div class="FieldLabel">
                                                                <span id="AvailableToLabel" class="lblNormalClass" style="font-weight: bold;">可用于:</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 10px;">
                                                            <input id="rdo_me" type="radio" name="availablity" value="rdo_me" checked="checked" />
                                                        </td>
                                                        <td>
                                                            <div class="FieldLabel" style="display: inline;">
                                                                <span id="MyselfOnlyLabel" class="lblNormalClass" style="font-weight: normal;">我自己</span>
                                                                <span id="MyselfOnlyInstructionLabel" class="FieldLevelInstruction" style="font-weight: normal;"></span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input id="rdo_department" type="radio" name="availablity" value="rdo_department" />
                                                        </td>
                                                        <td>
                                                            <div class="FieldLabel" style="display: inline;">
                                                                <span id="departmentLabel" class="lblNormalClass" style="font-weight: normal;">指定部门</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>
                                                            <div class="FieldLabel" style="display: inline;">
                                                                <span style="display: inline-block;">
                                                                    <select name="range_department_id" id="range_department_id" disabled="disabled" class="txtBlack8Class" style="width: 150px;">
                                                                        <option value="">(请选择)</option>
                                                                        <% if (depList != null && depList.Count > 0)
                                                                            {
                                                                                foreach (var dep in depList)
                                                                                { %>
                                                                        <option value="<%=dep.id %>" <%if (temp != null && temp.range_department_id != null && temp.range_department_id == dep.id)
                                                                            {  %>
                                                                            selected="selected" <%} %>><%=dep.name %></option>
                                                                        <%  }
                                                                            } %>
                                                                    </select></span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input id="rdo_company" type="radio" name="availablity" value="rdo_company" checked="checked" />
                                                        </td>
                                                        <td>
                                                            <div class="FieldLabel" style="display: inline;">
                                                                <span id="AnyoneInCompanyLabel" class="lblNormalClass" style="font-weight: normal;">所有人 </span>
                                                                <span id="AnyoneInCompanyInstructionLabel" class="FieldLevelInstruction" style="font-weight: normal;"></span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>

        <div id="editForm" class="searchpanel">
            <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">商机</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        商机名称
                                    </div>
                                    <div>
                                        <span id="" class="oppText">
                                            <input name="name" type="text" id="" class="txtBlack8Class" value="<%=tempOppo != null ? tempOppo.name : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户
                                    </div>
                                    <div id="">
                                        <span id="" style="display: inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                            <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="txtBlack8Class" />
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        联系人
                                    </div>
                                    <div id="">

                                        <table id="" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td id=""><span style="display: inline-block;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;">
                                                        </select>
                                                    </span></td>
                                                    <td id="" style="display: none;"></td>
                                                    <td id=""></td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </div>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        商机负责人
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="resource_id" id="resource_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (resList != null && resList.Count > 0)
                                                    {
                                                        foreach (var res in resList)
                                                        { %>
                                                <option value="<%=res.id %>" <%if (tempOppo != null && tempOppo.resource_id != null && tempOppo.resource_id == res.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=res.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        阶段
                                    </div>
                                    <div>
                                        <span class="editDD">
                                            <select name="stage_id" id="stage_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (oppoStageList != null && oppoStageList.Count > 0)
                                                    {
                                                        foreach (var stage in oppoStageList)
                                                        { %>
                                                <option value="<%=stage.id %>" <%if (tempOppo != null && tempOppo.stage_id != null && tempOppo.stage_id == stage.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=stage.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        商机来源
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="source_id" id="source_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (oppoSourceList != null && oppoSourceList.Count > 0)
                                                    {
                                                        foreach (var source in oppoSourceList)
                                                        { %>
                                                <option value="<%=source.id %>" <%if (tempOppo != null && tempOppo.source_id != null && tempOppo.source_id == source.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=source.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        状态
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="status_id" id="status_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (oppoStatusList != null && oppoStatusList.Count > 0)
                                                    {
                                                        foreach (var status in oppoStatusList)
                                                        { %>
                                                <option value="<%=status.id %>" <%if (tempOppo != null && tempOppo.status_id != null && tempOppo.status_id == status.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=status.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        计划关闭时间
                                    </div>
                                    <div>
                                        <table class="radioTable">
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <span>
                                                            <input id="ckKeep" type="radio" name="OppoCloseType" value="pcdKeepCurrent" checked="checked" /></span>
                                                        <span class="txtBlack8Class">保持不变</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckFromToday" type="radio" name="OppoCloseType" value="radioFromToday" />
                                                        <span class="txtBlack8Class">距离今天:</span>
                                                    </td>
                                                    <td>
                                                        <span id="" class="oppNumber">
                                                            <input name="txtOppoFromToday" type="text" value="<%=tempOppo != null && tempOppo.projected_close_date_type_value != null ? tempOppo.projected_close_date_type_value.ToString() : "0" %>" id="txtOppoFromToday" class="txtBlack8Class" style="text-align: right; width: 105px;" disabled="disabled" /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckFromCreate" type="radio" name="OppoCloseType" value="radioFromCreateDate" />
                                                        <span class="txtBlack8Class">距离创建时间:</span>
                                                    </td>
                                                    <td>
                                                        <span id="" class="oppNumber">
                                                            <input name="txtOppoFromCreate" type="text" id="txtOppoFromCreate" class="txtBlack8Class" style="text-align: right; width: 105px;" disabled="disabled" value="<%=tempOppo != null && tempOppo.projected_close_date_type_value != null ? tempOppo.projected_close_date_type_value.ToString() : "0" %>" /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckDayMonth" type="radio" name="OppoCloseType" value="radioLastDayOfMonth" />
                                                        <span class="txtBlack8Class">该月份的最后一天:&nbsp;&nbsp;&nbsp;</span>
                                                    </td>
                                                    <td class="oppNumber">
                                                        <span id="" class="pcdLastDayOfMonth">
                                                            <select name="selOppoDayMonth" id="selOppoDayMonth" class="txtBlack8Class" style="width: 105px;" disabled="disabled">
                                                                <option selected="selected" value="1">一月</option>
                                                                <option value="2">二月</option>
                                                                <option value="3">三月</option>
                                                                <option value="4">四月</option>
                                                                <option value="5">五月</option>
                                                                <option value="6">六月</option>
                                                                <option value="7">七月</option>
                                                                <option value="8">八月</option>
                                                                <option value="9">九月</option>
                                                                <option value="10">十月</option>
                                                                <option value="11">十一月</option>
                                                                <option value="12">十二月</option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        成功几率
                                    </div>
                                    <div>
                                        <span>
                                            <input name="probability" type="text" id="probability" class="txtBlack8Class ToDec2" style="width: 120px; text-align: right;" value="<%=tempOppo != null && tempOppo.probability != null ? tempOppo.probability.ToString() : "" %>" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户感兴趣程度
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="interest_degree_id" id="interest_degree_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (oppoIntDegList != null && oppoIntDegList.Count > 0)
                                                    {
                                                        foreach (var intDeg in oppoIntDegList)
                                                        { %>
                                                <option value="<%=intDeg.id %>" <%if (tempOppo != null && tempOppo.interest_degree_id != null && tempOppo.interest_degree_id == intDeg.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=intDeg.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        主要产品 
                                    </div>
                                    <div id="" style="width: 404px;">
                                        <input name="primary_product_id" type="hidden" id="productIdHidden" value="<%=thisProduct != null ? thisProduct.id.ToString() : "" %>" /><nobr><span id="" style="display:inline-block;" >
                                            <input name="" type="text" id="productId" class="txtBlack8Class"  style="width:374px;" value="<%=thisProduct != null ? thisProduct.name : "" %>" /></span>&nbsp;
                                            <i style="width: 16px;height: 16px;float: right;margin-left: 5px;margin-top: 5px;background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;" onclick="chooseProduct()"></i></nobr>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        促销名称
                                    </div>
                                    <div>
                                        <span id="" class="oppText">
                                            <input name="promotion_name" type="text" id="" class="txtBlack8Class" value="<%=tempOppo != null ? tempOppo.promotion_name : "" %>"></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        主要竞争对手
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="competitor_id" id="competitor_id" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                <% if (oppoComperList != null && oppoComperList.Count > 0)
                                                    {
                                                        foreach (var comper in oppoComperList)
                                                        { %>
                                                <option value="<%=comper.id %>" <%if (tempOppo != null && tempOppo.competitor_id != null && tempOppo.competitor_id == comper.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=comper.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel" style="padding-bottom: 10px;">
                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="ckOppoUseQuote" type="checkbox" name="ckOppoUseQuote" style="vertical-align: middle;" />
                                        <label style="vertical-align: middle;">是否引用报价项成本收入数据</label>

                                    </span></span>
                                </td>
                                <td class="input"></td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <table cellpadding="0" cellspacing="0" class="subTable">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td>
                                                    <div class="FieldLabel">
                                                        一次性收入
                                                    </div>
                                                    <div>
                                                        <span id="" class="oppNumber2">
                                                            <input name="one_time_revenue" type="text" id="one_time_revenue" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.one_time_revenue != null ? ((decimal)tempOppo.one_time_revenue).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        一次性成本
									
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_oneTimeCost" class="oppNumber2">
                                                            <input name="one_time_cost" type="text" id="one_time_cost" class="txtBlack8Class  Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.one_time_cost != null ? ((decimal)tempOppo.one_time_cost).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <table cellpadding="0" cellspacing="0" class="subTable">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td>
                                                    <div class="FieldLabel">
                                                        月度收入
                                                    </div>
                                                    <div>
                                                        <span id="" class="oppNumber2">
                                                            <input name="monthly_revenue" type="text" id="monthly_revenue" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.monthly_revenue != null ? ((decimal)tempOppo.monthly_revenue).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        月度成本
									
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_monthlyCost" class="oppNumber2">
                                                            <input name="monthly_cost" type="text" id="monthly_cost" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.monthly_cost != null ? ((decimal)tempOppo.monthly_cost).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <table cellpadding="0" cellspacing="0" class="subTable">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td>
                                                    <div class="FieldLabel">
                                                        季度收入
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_quarterlyRevenue" class="oppNumber2">
                                                            <input name="quarterly_revenue" type="text" id="quarterly_revenue" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.quarterly_revenue != null ? ((decimal)tempOppo.quarterly_revenue).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        季度成本
                                                    </div>
                                                    <div>
                                                        <span id="" class="oppNumber2">
                                                            <input name="quarterly_cost" type="text" id="quarterly_cost" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.quarterly_cost != null ? ((decimal)tempOppo.quarterly_cost).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <table cellpadding="0" cellspacing="0" class="subTable">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td>
                                                    <div class="FieldLabel">
                                                        半年收入
                                                    </div>
                                                    <div>
                                                        <span id="" class="oppNumber2">
                                                            <input name="semi_annual_revenue" type="text" id="semi_annual_revenue" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.semi_annual_revenue != null ? ((decimal)tempOppo.semi_annual_revenue).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        半年成本
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_semiAnnualCost" class="oppNumber2">
                                                            <input name="semi_annual_cost" type="text" id="semi_annual_cost" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.semi_annual_cost != null ? ((decimal)tempOppo.semi_annual_cost).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <table cellpadding="0" cellspacing="0" class="subTable">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td>
                                                    <div class="FieldLabel">
                                                        年收入
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_yearlyRevenue" class="oppNumber2">
                                                            <input name="yearly_revenue" type="text" id="yearly_revenue" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.yearly_revenue != null ? ((decimal)tempOppo.yearly_revenue).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        年成本
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_yearlyCost" class="oppNumber2">
                                                            <input name="yearly_cost" type="text" id="yearly_cost" class="txtBlack8Class Calculation ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.yearly_cost != null ? ((decimal)tempOppo.yearly_cost).ToString("#0.00") : "" %>" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel" style="padding-bottom: 10px;">
                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="ckOppoSpreadValue" type="checkbox" name="ckOppoSpreadValue" style="vertical-align: middle;" />
                                        <label style="vertical-align: middle;">总计费时长</label></span></span>
                                    &nbsp;
			<span id="" style="display: inline-block;">
                <input name="number_months_for_estimating_total_profit" type="text" value="1" maxlength="4" id="number_months_for_estimating_total_profit" class="txtBlack8Class" style="height: 22px; width: 40px; text-align: right;" /></span>&nbsp;
			<span id="" style="display: inline-block;">
                <select name="spread_revenue_recognition_unit" id="spread_revenue_recognition_unit" class="txtBlack8Class" style="width: 110px;" disabled="">
                    <option value="Days">天</option>
                    <option selected="selected" value="Months">月</option>
                    <option value="Years">年</option>

                </select></span>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        1.&nbsp;专业服务
                                    </div>
                                    <div>
                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_advancedField1" class="CurrencyStyle">
                                            <input name="ext1" type="text" id="ext1" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.ext1 != null ? ((decimal)tempOppo.ext1).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        2.&nbsp;培训费用 
                                    </div>
                                    <div>
                                        <span class="CurrencyStyle">
                                            <input name="ext2" type="text" id="ext2" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.ext2 != null ? ((decimal)tempOppo.ext2).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        3.&nbsp;硬件费用 
                                    </div>
                                    <div>
                                        <span class="CurrencyStyle">
                                            <input name="ext3" type="text" id="ext3" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.ext3 != null ? ((decimal)tempOppo.ext3).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        4.&nbsp;月度使用费用
                                    </div>
                                    <div>
                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_advancedField4" class="CurrencyStyle">
                                            <input name="ext4" type="text" id="ext4" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.ext4 != null ? ((decimal)tempOppo.ext4).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        5.&nbsp;其他费用
                                    </div>
                                    <div>
                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_advancedField5" class="CurrencyStyle">
                                            <input name="ext5" type="text" id="ext5" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempOppo != null && tempOppo.ext5 != null ? ((decimal)tempOppo.ext5).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="Table1" cellpadding="0" cellspacing="0">
                        <tbody>
                            <% if (notifyList != null && notifyList.Count > 0)
                                {
                                    foreach (var notify in notifyList)
                                    {%>
                            <tr>
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                            { %>
                                            checked="checked" <%} %> />
                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                </td>
                            </tr>
                            <% }
                                } %>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp != null ? temp.other_emails : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp != null ? temp.additional_email_text : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.PROJECT_NOTE)
                {%>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">项目备注</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">发布对象</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="publish_type_id" id="publish_type_id" class="txtBlack8Class">
                                                <% if (pushList != null && pushList.Count > 0)
                                                    {
                                                        foreach (var puish in pushList)
                                                        { %>
                                                <option value="<%=puish.id %>" <%if (tempNote != null && tempNote.publish_type_id != null && tempNote.publish_type_id == puish.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=puish.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="isAnnounce" style="vertical-align: middle;" <%if (tempNote != null && tempNote.announce == 1)
                                                { %>
                                                checked="checked" <%} %> /><label style="vertical-align: middle;">公告</label></span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">备注类型</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="action_type_id" id="action_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (actList != null && actList.Count > 0)
                                                    {
                                                        foreach (var act in actList)
                                                        { %>
                                                <option value="<%=act.id %>" <%if (tempNote != null && tempNote.action_type_id == act.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=act.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">标题</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="name" type="text" id="name" class="txtBlack8Class" value="<%=tempNote != null ? tempNote.name : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="" rows="3" cols="55" style="height: 100px"><%=tempNote != null ? tempNote.description : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td></td>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>

                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp != null ? temp.other_emails : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">通知模板 </span>
                                    </div>
                                    <div style="width: 360px;">
                                        <span id="">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                        <br>
                                        <span id="" class="FieldLevelInstruction" style="font-weight: normal;"></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">附加邮件文本</span>
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp != null ? temp.additional_email_text : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">快速服务预定</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户名称 
                                    </div>
                                    <div id="">
                                        <span id="" style="display: inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                            <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="txtBlack8Class" />
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">联系人</span>
                                    </div>
                                    <div id="">

                                        <table id="" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td id=""><span id="" style="display: inline-block;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;" disabled="disabled"></select></span></td>

                                                    <td id=""></td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </div>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单标题</span>
                                    </div>
                                    <div>
                                        <span id="" class="ticketTitleInput" style="display: inline-block;">
                                            <input name="title" type="text" id="title" class="txtBlack8Class" style="width: 100%;" value="<%=tempQuickCall != null ? tempQuickCall.title : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="description" rows="3" cols="55" style="width: 360px; height: 50px"><%=tempQuickCall != null ? tempQuickCall.description : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">优先级</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="priority_type_id" id="priority_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (priorityList != null && priorityList.Count > 0)
                                                    {
                                                        foreach (var priority in priorityList)
                                                        { %>
                                                <option value="<%=priority.id %>" <%if (tempQuickCall != null && tempQuickCall.priority_type_id != null && tempQuickCall.priority_type_id == priority.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=priority.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">问题类型</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="issue_type_id" id="issue_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (issueTypeList != null && issueTypeList.Count > 0)
                                                    {
                                                        foreach (var issueType in issueTypeList)
                                                        { %>
                                                <option value="<%=issueType.id %>" <%if (tempQuickCall != null && tempQuickCall.issue_type_id != null && tempQuickCall.issue_type_id == issueType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=issueType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">子问题类型</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="sub_issue_type_id" id="sub_issue_type_id" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单种类</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="cate_id" id="cate_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticketCateList != null && ticketCateList.Count > 0)
                                                    {
                                                        foreach (var ticketCate in ticketCateList)
                                                        { %>
                                                <option value="<%=ticketCate.id %>" <%if (tempQuickCall != null && tempQuickCall.cate_id != null && tempQuickCall.cate_id == ticketCate.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticketCate.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Billing</span>
                </div>
                <div class="Content">
                    <table cellpadding="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">合同</span>
                                    </div>
                                    <div id="">
                                        <input name="contract_id" type="hidden" id="contractIdHidden" value="<%=thisContract != null ? thisContract.id.ToString() : "" %>" /><span id="" style="display: inline-block;"><input name="" type="text" id="contractId" disabled="disabled" class="txtBlack8Class" style="width: 360px;" value="<%=thisContract != null ? thisContract.name : "" %>" /></span>&nbsp;
                                        <i onclick="ContractCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工作类型</span>
                                    </div>
                                    <div id="">
                                        <input name="cost_code_id" type="hidden" id="costCodeIdHidden" value="<%=thisCostCode != null ? thisCostCode.id.ToString() : "" %>" /><span id="" style="display: inline-block;"><input name="" type="text" id="costCodeId" disabled="disabled" class="txtBlack8Class" style="width: 360px;" value="<%=thisCostCode != null ? thisCostCode.name : "" %>" /></span>&nbsp;
                                        <i onclick="WorkTypeCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Scheduling</span>
                </div>
                <div class="Content">
                    <table cellpadding="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel" style="padding-right: 5px!important;" width="85px">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">队列</span>
                                    </div>
                                    <div>
                                        <span id="" class="ResourceQueueDD">
                                            <select name="department_id" id="department_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (queueList != null && queueList.Count > 0)
                                                    {
                                                        foreach (var queue in queueList)
                                                        { %>
                                                <option value="<%=queue.id %>" <%if (tempQuickCall != null && tempQuickCall.department_id != null && tempQuickCall.department_id == queue.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=queue.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel" style="padding-right: 5px!important;" width="85px">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">主负责人</span>
                                    </div>
                                    <div>
                                        <span id="" class="ResourceQueueDD">
                                            <select name="resRoleId" id="resRoleId" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (resRoleList != null && resRoleList.Count > 0)
                                                    {
                                                        foreach (var resRole in resRoleList)
                                                        {
                                                            if (resList == null || resList.Count == 0 || roleList == null || roleList.Count == 0)
                                                            {
                                                                continue;
                                                            }
                                                            var thisRes = resList.FirstOrDefault(_ => _.id == resRole.resource_id);
                                                            var thisRole = roleList.FirstOrDefault(_ => _.id == resRole.role_id);
                                                            if (thisRes == null || thisRole == null)
                                                            {
                                                                continue;
                                                            }
                                                %>
                                                <option value="<%=resRole.resource_id.ToString() + "," + resRole.role_id.ToString() %>" <%if (tempQuickCall != null && tempQuickCall.owner_resource_id == resRole.resource_id && tempQuickCall.role_id == resRole.role_id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=thisRes.name + $"[{thisRole.name}]" %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td></td>
                                <td class="inputLabel">
                                    <span id="" class="FieldLabel" style="font-weight: bold; width: 85px;">其他负责人</span>
                                    <div>

                                        <input type="hidden" id="OtherResIdHidden" name="second_resource_ids" value="<%=tempQuickCall != null ? tempQuickCall.second_resource_ids : "" %>" />
                                        <input type="hidden" id="OtherResId" />
                                        <span id="" style="display: inline-block;">
                                            <select size="4" name="" id="otherRes" class="txtBlack8Class" style="height: 50px; width: 374px;">
                                            </select></span>
                                        <i onclick="OtherResCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">开始时间</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="estimated_begin_time" type="text" id="" onclick="WdatePicker({ dateFmt: 'HH:mm' })" class="txtBlack8Class" style="width: 76px" value="<%=tempQuickCall != null ? tempQuickCall.estimated_begin_time : "" %>" />&nbsp;</span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">结束时间</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="estimated_end_time" type="text" onclick="WdatePicker({ dateFmt: 'HH:mm' })" id="" class="txtBlack8Class" style="width: 76px" value="<%=tempQuickCall != null ? tempQuickCall.estimated_end_time : "" %>" />&nbsp;</span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table cellpadding="0">
                        <tbody>
                            <% if (notifyList != null && notifyList.Count > 0)
                                {
                                    foreach (var notify in notifyList)
                                    {%>
                            <tr>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                            { %>
                                            checked="checked" <%} %> />
                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                </td>
                            </tr>
                            <% }
                                } %>
                            <tr>
                                <td class="inputLabel" colspan="2">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">通知模板</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.QUOTE)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="EditControlFormQuoteEntryFavEditor.ascx_QuoteLabel" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">报价</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户名称 
                                    </div>
                                    <div id="">
                                        <span id="" style="display: inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                            <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="txtBlack8Class" />
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">商机名称</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="opportunity_id" id="opportunity_id" class="txtBlack8Class" disabled="disabled">
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">报价名称</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="name" type="text" maxlength="200" id="" value="<%=tempQuote != null ? tempQuote.name : "" %>" class="txtBlack8Class" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">报价描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="" maxlength="1000" rows="3" cols="55"><%=tempQuote != null ? tempQuote.description : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">有效时间</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="effective_date" type="text" id="" class="txtBlack8Class" style="width: 76px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=tempQuote != null ? tempQuote.effective_date.ToString() : "" %>" /></span> 距离现在
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">到期日期</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="expiration_date" type="text" id="" class="txtBlack8Class" style="width: 76px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=tempQuote != null ? tempQuote.expiration_date.ToString() : "" %>" /></span> 距离现在
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        联系人
                                    </div>
                                    <div id="">

                                        <table id="" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td id=""><span style="display: inline-block;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;" disabled="disabled">
                                                        </select>
                                                    </span></td>
                                                    <td id=""></td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </div>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">税区域</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="tax_region_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (taxRegionList != null && taxRegionList.Count > 0)
                                                    {
                                                        foreach (var taxRegion in taxRegionList)
                                                        { %>
                                                <option value="<%=taxRegion.id %>" <%if (tempQuote != null && tempQuote.tax_region_id != null && tempQuote.tax_region_id == taxRegion.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=taxRegion.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="isActive" <% if (tempQuote != null && tempQuote.is_active == 1)
                                                { %>
                                                checked="checked" <%} %> style="vertical-align: middle;" /><label style="vertical-align: middle;">报价激活</label></span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">报价模板</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                                <% if (quoteTempList != null && quoteTempList.Count > 0)
                                                    {
                                                        foreach (var quoteTemp in quoteTempList)
                                                        { %>
                                                <option value="<%=quoteTemp.id %>" <%if (tempQuote != null && tempQuote.quote_tmpl_id != null && tempQuote.quote_tmpl_id == quoteTemp.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=quoteTemp.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">外部报价编号</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="external_quote_no" type="text" id="" class="txtBlack8Class" value="<%=tempQuote != null ? tempQuote.external_quote_no : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">报价内容</span>
                                    </div>
                                    <div>
                                        <textarea name="quote_comment" id="" rows="3" cols="55"><%=tempQuote != null ? tempQuote.quote_comment : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">条款</span>
                </div>
                <div class="Content">
                    <table id="Table1" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">付款期限</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="payment_term_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (payTermList != null && payTermList.Count > 0)
                                                    {
                                                        foreach (var payTerm in payTermList)
                                                        { %>
                                                <option value="<%=payTerm.id %>" <%if (tempQuote != null && tempQuote.payment_term_id != null && tempQuote.payment_term_id == payTerm.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=payTerm.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">付款类型</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="payment_type_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (payTypeList != null && payTypeList.Count > 0)
                                                    {
                                                        foreach (var payType in payTypeList)
                                                        { %>
                                                <option value="<%=payType.id %>" <%if (tempQuote != null && tempQuote.payment_type_id != null && tempQuote.payment_type_id == payType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=payType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">采购订单编号</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="purchase_order_no" type="text" id="" class="txtBlack8Class" value="<%=tempQuote != null ? tempQuote.purchase_order_no : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">配送类型</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="shipping_type_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (shipTypeList != null && shipTypeList.Count > 0)
                                                    {
                                                        foreach (var shipType in shipTypeList)
                                                        { %>
                                                <option value="<%=shipType.id %>" <%if (tempQuote != null && tempQuote.shipping_type_id != null && tempQuote.shipping_type_id == shipType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=shipType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="isBillTo" style="vertical-align: middle;" <%if (tempQuote != null && tempQuote.bill_to_as_sold_to == 1)
                                                { %>
                                                checked="checked" <%} %> /><label style="vertical-align: middle;">发票寄送地址同销售地址</label></span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="isShipTo" style="vertical-align: middle;" <%if (tempQuote != null && tempQuote.ship_to_as_sold_to == 1)
                                                { %>
                                                checked="checked" <%} %> /><label style="vertical-align: middle;">收货地址同销售地址</label></span></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td></td>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp != null ? temp.other_emails : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">主题</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="subject" type="text" maxlength="100" id="" class="txtBlack8Class" value="<%=temp != null ? temp.subject : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp != null ? temp.additional_email_text : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">定期工单</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0" class="entireThing">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户
                                    </div>
                                    <div id="">
                                        <span id="" style="display: inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                            <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="txtBlack8Class" />
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">合同</span>
                                    </div>
                                    <div id="" style="width: 400px;">
                                        <input name="contract_id" type="hidden" id="contractIdHidden" value="<%=thisContract != null ? thisContract.id.ToString() : "" %>" /><span id="" style="display: inline-block;"><input name="" type="text" id="contractId" disabled="disabled" class="txtBlack8Class" style="width: 374px;" value="<%=thisContract != null ? thisContract.name : "" %>" /></span>&nbsp;
                                        <i onclick="ContractCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工作类型</span>
                                    </div>
                                    <div id="" style="width: 400px;">
                                        <input name="cost_code_id" type="hidden" id="costCodeIdHidden" value="<%=thisCostCode != null ? thisCostCode.id.ToString() : "" %>" /><span id="" style="display: inline-block;"><input name="" type="text" id="costCodeId" disabled="disabled" class="txtBlack8Class" style="width: 374px;" value="<%=thisCostCode != null ? thisCostCode.name : "" %>" /></span>&nbsp;
                                        <i onclick="WorkTypeCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        配置项
                                    </div>
                                    <div id="" style="width: 400px;">
                                        <input name="installed_product_id" type="hidden" id="insProIdHidden" value="<%=tempRecTicket != null ? tempRecTicket.installed_product_id.ToString() : "" %>" /><span id=""><input name="" type="text" id="insProId" disabled="disabled" class="txtBlack8Class" style="width: 374px;" value="<%=thisProduct != null ? thisProduct.name : "" %>" /></span>&nbsp;<i onclick="InsProCallBack()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        联系人
                                    </div>
                                    <div id="">

                                        <table id="" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td id=""><span style="display: inline-block;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;">
                                                        </select>
                                                    </span></td>
                                                    <td id="" style="display: none;"></td>
                                                    <td id=""></td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </div>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">来源</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="source_type_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (sourceTypeList != null && sourceTypeList.Count > 0)
                                                    {
                                                        foreach (var sourceType in sourceTypeList)
                                                        { %>
                                                <option value="<%=sourceType.id %>" <%if (tempRecTicket != null && tempRecTicket.source_type_id != null && tempRecTicket.source_type_id == sourceType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=sourceType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单标题</span>
                                    </div>
                                    <div>
                                        <span id="" class="ticketTitleInput" style="display: inline-block;">
                                            <input name="title" type="text" id="title" class="txtBlack8Class" style="width: 374px;" value="<%=tempRecTicket != null ? tempRecTicket.title : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单描述</span>
                                    </div>
                                    <div>
                                        <div>
                                            <textarea name="description" id="description" rows="3" cols="55" style="width: 374px; height: 50px; resize: vertical;"><%=tempRecTicket != null ? tempRecTicket.description : "" %></textarea>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel" style="padding-top: 5px">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">队列</span>
                                        <div>
                                            <span id="" class="ResourceQueueDD">
                                                <select name="department_id" id="department_id" class="txtBlack8Class">
                                                    <option value=""></option>
                                                    <% if (queueList != null && queueList.Count > 0)
                                                        {
                                                            foreach (var queue in queueList)
                                                            { %>
                                                    <option value="<%=queue.id %>" <%if (tempRecTicket != null && tempRecTicket.department_id != null && tempRecTicket.department_id == queue.id)
                                                        {  %>
                                                        selected="selected" <%} %>><%=queue.name %></option>
                                                    <%  }
                                                        } %>
                                                </select></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel" style="padding-top: 5px">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">主负责人 </span>
                                        <div>
                                            <span id="" class="ResourceQueueDD">
                                                <select name="resRoleId" id="resRoleId" class="txtBlack8Class">
                                                    <option value=""></option>
                                                    <% if (resRoleList != null && resRoleList.Count > 0)
                                                        {
                                                            foreach (var resRole in resRoleList)
                                                            {
                                                                if (resList == null || resList.Count == 0 || roleList == null || roleList.Count == 0)
                                                                {
                                                                    continue;
                                                                }
                                                                var thisRes = resList.FirstOrDefault(_ => _.id == resRole.resource_id);
                                                                var thisRole = roleList.FirstOrDefault(_ => _.id == resRole.role_id);
                                                                if (thisRes == null || thisRole == null)
                                                                {
                                                                    continue;
                                                                }
                                                    %>
                                                    <option value="<%=resRole.resource_id.ToString() + "," + resRole.role_id.ToString() %>" <%if (tempRecTicket != null && tempRecTicket.owner_resource_id == resRole.resource_id && tempRecTicket.role_id == resRole.role_id)
                                                        {  %>
                                                        selected="selected" <%} %>><%=thisRes.name + $"[{thisRole.name}]" %></option>
                                                    <%  }
                                                        } %>
                                                </select></span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">截止日期</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="estimated_end_time" type="text" id="" class="txtBlack8Class" style="width: 76px" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=tempRecTicket != null ? tempRecTicket.estimated_end_time : "" %>" />&nbsp;</span>
                                        <br />
                                        <br />
                                        <span id="">
                                            <input name="estimated_end_time_from_now" type="text" id="" class="txtBlack8Class" style="width: 76px; text-align: right;" value="<%=tempRecTicket != null ? tempRecTicket.estimated_end_time_from_now : "" %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                        &nbsp;<span style="height: 100%"><span id="" class="FieldLevelInstruction" style="font-weight: normal;">分钟距离现在</span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">优先级</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="priority_type_id" id="priority_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (priorityList != null && priorityList.Count > 0)
                                                    {
                                                        foreach (var priority in priorityList)
                                                        { %>
                                                <option value="<%=priority.id %>" <%if (tempRecTicket != null && tempRecTicket.priority_type_id != null && tempRecTicket.priority_type_id == priority.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=priority.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="status_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticStaList != null && ticStaList.Count > 0)
                                                    {
                                                        foreach (var ticSta in ticStaList)
                                                        { %>
                                                <option value="<%=ticSta.id %>" <%if (tempRecTicket != null && tempRecTicket.status_id != null && tempRecTicket.status_id == ticSta.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticSta.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">估算时间 </span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="estimated_hours" type="text" maxlength="12" id="" class="txtBlack8Class ToDec2" style="text-align: right;" value="<%=tempRecTicket != null && tempRecTicket.estimated_hours != null ? ((decimal)tempRecTicket.estimated_hours).ToString("#0.00") : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工单种类</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="cate_id" id="cate_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticketCateList != null && ticketCateList.Count > 0)
                                                    {
                                                        foreach (var ticketCate in ticketCateList)
                                                        { %>
                                                <option value="<%=ticketCate.id %>" <%if (tempRecTicket != null && tempRecTicket.cate_id != null && tempRecTicket.cate_id == ticketCate.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticketCate.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">问题类型</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="issue_type_id" id="issue_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (issueTypeList != null && issueTypeList.Count > 0)
                                                    {
                                                        foreach (var issueType in issueTypeList)
                                                        { %>
                                                <option value="<%=issueType.id %>" <%if (tempRecTicket != null && tempRecTicket.issue_type_id != null && tempRecTicket.issue_type_id == issueType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=issueType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">子问题类型 </span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="sub_issue_type_id" id="sub_issue_type_id" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">持续时间</span>
                </div>
                <div class="Content">
                    <div id="" class="searchpanel" style="width: 100%;">
                        <div>
                            <table class="radioTable">
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                开始时间 
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                <span id="" class="oppNumber">
                                                    <input name="recurring_start_date" type="text" id="" class="txtBlack8Class" style="text-align: right; width: 55px;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=tempRecTicket != null && tempRecTicket.recurring_start_date != null ? tempRecTicket.recurring_start_date.ToString() : "" %>" /></span>
                                                <span class="txtBlack8Class">距离现在天数
                                                </span>
                                            </div>
                                        </td>
                                        <td class="CheckboxPadding">
                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                <input id="" type="checkbox" name="isActive" <% if ((tempRecTicket == null) || (tempRecTicket.is_active == 1))
                                                    {%>
                                                    checked="checked" <%} %> style="vertical-align: middle;" /><label style="vertical-align: middle;">激活 (只影响主工单)</label></span></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                结束日期 / 实例数
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                <input id="rdEnd" type="radio" name="EndType" value="radioEndDaysFromNow" checked="checked" />
                                                <span class="oppNumber">
                                                    <input name="recurring_end_date" type="text" id="recurring_end_date" class="txtBlack8Class" style="text-align: right; width: 55px;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=tempRecTicket != null && tempRecTicket.recurring_end_date != null ? tempRecTicket.recurring_end_date.ToString() : "" %>" /></span>
                                                <span class="txtBlack8Class">距离现在时间
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                <input id="rdIns" type="radio" name="EndType" value="radioEndInstances" />
                                                <span id="" class="oppNumber">
                                                    <input name="recurring_instances" type="text" id="recurring_instances" class="txtBlack8Class" style="text-align: right; width: 55px;" disabled="" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" value="<%=tempRecTicket != null && tempRecTicket.recurring_instances != null ? tempRecTicket.recurring_instances.ToString() : "" %>" /></span>
                                                <span class="txtBlack8Class">实例数
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                    </div>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">频率</span>
                </div>
                <div class="Content">
                    <div id="EditControlFormRecurringTicketEntryFavEditor.ascx_FrequencyForm" class="searchpanel" style="width: 100%;">
                        <table class="radioTable" style="height: 143px">
                            <tbody>
                                <tr>
                                    <td style="height: 100%; min-width: 50px;">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <div style="height: 25px;">
                                                            <input id="rdDay" type="radio" name="FreType" value="radioDaily" />
                                                            <span class="txtBlack8Class">天</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div style="height: 25px;">
                                                            <input id="rdWeek" type="radio" name="FreType" value="radioWeekly" />
                                                            <span class="txtBlack8Class">周</span>
                                                        </div>
                                                    </td>

                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div style="height: 25px;">
                                                            <input id="rdMonth" type="radio" name="FreType" value="radioMonthly" checked="checked" />
                                                            <span class="txtBlack8Class">月</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div style="height: 25px;">
                                                            <input id="rdYear" type="radio" name="FreType" value="radioYearly" />
                                                            <span class="txtBlack8Class">年
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td class="FieldLabel" style="padding-top: 0px; padding-left: 50px;">
                                        <div id="pnlDaily" class="FrequencyClass" style="display: none;">
                                            <div>
                                                每隔
									<span id="" class="oppNumber">
                                        <input name="every" type="text" value="1" id="day_every" class="txtBlack8Class" style="text-align: right; width: 55px;" /></span>
                                                天
                                            </div>
                                            <div>
                                                <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                    <input id="day_no_sat" type="checkbox" name="day_no_sat" style="vertical-align: middle;" /><label style="vertical-align: middle;">周六不创建</label></span></span>
                                            </div>
                                            <div>
                                                <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                    <input id="day_no_sun" type="checkbox" name="day_no_sun" style="vertical-align: middle;" /><label style="vertical-align: middle;">周日不创建</label></span></span>
                                            </div>
                                        </div>
                                        <div id="pnlWeekly" class="FrequencyClass" style="display: none;">

                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3">
                                                            <div>
                                                                每隔
												<span id="" class="oppNumber">
                                                    <input name="week_eve_week" type="text" value="1" id="week_eve_week" class="txtBlack8Class" style="text-align: right; width: 55px;" /></span>
                                                                周:
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>

                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekSun" type="checkbox" name="ckWeekSun" style="vertical-align: middle;" /><label style="vertical-align: middle;">周日</label></span></span>
                                                        </td>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekWed" type="checkbox" name="ckWeekWed" style="vertical-align: middle;" /><label style="vertical-align: middle;">周三</label></span></span>
                                                        </td>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekSat" type="checkbox" name="ckWeekSat" style="vertical-align: middle;" /><label style="vertical-align: middle;">周六</label></span></span>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekMon" type="checkbox" name="ckWeekMon" style="vertical-align: middle;" /><label style="vertical-align: middle;">周一</label></span></span>
                                                        </td>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekThu" type="checkbox" name="ckWeekThu" style="vertical-align: middle;" /><label style="vertical-align: middle;">周四</label></span></span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekTus" type="checkbox" name="ckWeekTus" style="vertical-align: middle;" /><label style="vertical-align: middle;">周二</label></span></span>
                                                        </td>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="ckWeekFri" type="checkbox" name="ckWeekFri" style="vertical-align: middle;" /><label style="vertical-align: middle;">周五</label></span></span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>

                                        </div>
                                        <div id="pnlMonthly" class="FrequencyClass" style="display: inline;">
                                            到期
								<div>
                                    <input id="rdMonth0" type="radio" name="monthType" value="radioSpecificDay" checked="checked" />
                                    <span class="lblNormalClass" style="font-weight: normal;">天  </span><span id="" class="oppNumber">
                                        <input name="month_day_num" type="text" id="month_day_num" class="txtBlack8Class" style="text-align: right; width: 55px;" /></span><span class="lblNormalClass" style="font-weight: normal;">  每  </span><span id="" class="oppNumber">
                                            <input name="month_month_day" type="text" value="1" id="month_month_day" class="txtBlack8Class" style="text-align: right; width: 55px;" /></span><span class="lblNormalClass" style="font-weight: normal;"> 月</span>
                                </div>
                                            <div>
                                                <input id="rdMonth1" type="radio" name="monthType" value="radioRelativeDay" />
                                                <span class="lblNormalClass" style="font-weight: normal;">每  </span>
                                                <span id="" class="oppNumber">
                                                    <input name="month_month_eve_num" type="text" value="1" id="month_month_eve_num" class="txtBlack8Class" style="text-align: right; width: 55px;" disabled="" /></span><span class="lblNormalClass" style="font-weight: normal;">  月 </span>
                                                <span id="">
                                                    <select name="month_1_month" id="month_1_month" class="txtBlack8Class" style="width: 100px" disabled="">
                                                        <option selected="selected" value="1st">第一个</option>
                                                        <option value="2nd">第二个</option>
                                                        <option value="3rd">第三个</option>
                                                        <option value="4th">第四个</option>
                                                        <option value="last">最后一个</option>

                                                    </select></span>

                                                <span class="lblNormalClass" style="font-weight: normal;"></span><span id="">
                                                    <select name="month_1_week" id="month_1_week" class="txtBlack8Class" style="width: 100px" disabled="">
                                                        <option selected="selected" value="1">星期一</option>
                                                        <option value="2">星期二</option>
                                                        <option value="3">星期三</option>
                                                        <option value="4">星期四</option>
                                                        <option value="5">星期五</option>
                                                        <option value="6">星期六</option>
                                                        <option value="0">星期日</option>
                                                        <option value="7">天</option>
                                                        <option value="8">工作日</option>

                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">  </span>

                                            </div>

                                        </div>
                                        <div id="pnlYearly" class="FrequencyClass" style="display: none;">
                                            <div>
                                                <input id="rdYear0" type="radio" name="YearType" value="radioYearlySpecific" checked="checked" />
                                                <span class="lblNormalClass" style="font-weight: normal;">每  </span><span id="">
                                                    <select name="year_every_month" id="year_every_month" class="txtBlack8Class" style="width: 100px">
                                                        <option value=""></option>
                                                        <option selected="selected" value="1">一月</option>
                                                        <option value="2">二月</option>
                                                        <option value="3">三月</option>
                                                        <option value="4">四月</option>
                                                        <option value="5">五月</option>
                                                        <option value="6">六月</option>
                                                        <option value="7">七月</option>
                                                        <option value="8">八月</option>
                                                        <option value="9">九月</option>
                                                        <option value="10">十月</option>
                                                        <option value="11">十一月</option>
                                                        <option value="12">十二月</option>

                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">   </span><span id="" class="oppNumber">
                                                        <input name="year_month_day" type="text" id="year_month_day" class="txtBlack8Class" style="text-align: right; width: 55px;" /></span><span class="lblNormalClass" style="font-weight: normal;"> 日 </span>
                                            </div>
                                            <div>
                                                <input id="rdYear1" type="radio" name="YearType" value="radioYearlyRelative" />
                                                <span class="lblNormalClass" style="font-weight: normal;">每  </span><span id="">
                                                    <select name="year_the_month" id="year_the_month" class="txtBlack8Class" style="width: 100px" disabled="">
                                                        <option selected="selected" value="1">一月</option>
                                                        <option value="2">二月</option>
                                                        <option value="3">三月</option>
                                                        <option value="4">四月</option>
                                                        <option value="5">五月</option>
                                                        <option value="6">六月</option>
                                                        <option value="7">七月</option>
                                                        <option value="8">八月</option>
                                                        <option value="9">九月</option>
                                                        <option value="10">十月</option>
                                                        <option value="11">十一月</option>
                                                        <option value="12">十二月</option>
                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">   </span><span id="">
                                                        <select name="year_month_week_num" id="year_month_week_num" class="txtBlack8Class" style="width: 100px" disabled="">
                                                            <option value=""></option>
                                                            <option selected="selected" value="1st">第一个</option>
                                                            <option value="2nd">第二个</option>
                                                            <option value="3rd">第三个</option>
                                                            <option value="4th">第四个</option>
                                                            <option value="last">最后一个</option>

                                                        </select></span><span class="lblNormalClass" style="font-weight: normal;">  的  </span><span id="">
                                                            <select name="year_the_week" id="year_the_week" class="txtBlack8Class" style="width: 100px" disabled="">
                                                                <option value=""></option>
                                                                <option selected="selected" value="1">星期一</option>
                                                                <option value="2">星期二</option>
                                                                <option value="3">星期三</option>
                                                                <option value="4">星期四</option>
                                                                <option value="5">星期五</option>
                                                                <option value="6">星期六</option>
                                                                <option value="0">星期日</option>
                                                                <option value="7">天</option>
                                                                <option value="8">工作日</option>

                                                            </select></span><span class="lblNormalClass" style="font-weight: normal;">  </span>
                                            </div>

                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">自定义字段</span>
                </div>
                <div class="Content">
                    <div id="" class="searchpanel" style="width: 100%;">
                        <table style="overflow-y: auto; border-collapse: collapse; border: 0px;" id="udfWrapperTable" class="Neweditsubsection" width="100%">
                            <tbody>
                                <tr>
                                    <td style="border: 0px;">
                                        <div id="" style="border-style: None; padding-bottom: 0px; min-height: 30px;">
                                            <table border="0" style="border-collapse: collapse;" width="100%">
                                                <tbody>
                                                    <% if (tickUdfList != null && tickUdfList.Count > 0)
                                                        {
                                                            foreach (var udf in tickUdfList)
                                                            {
                                                                if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                                                                {%>
                                                    <tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span style="display: inline-block;">
                                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" value="<%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():"" %>" /></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                                                        {%>
                                                    <tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span style="display: inline-block;">
                                                                <textarea name="<%=udf.id %>" rows="2" cols="20"><%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():""  %></textarea></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                                        {%>
                                                    <%string val = "";
                                                        if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                        {
                                                            object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                            if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                            {
                                                                val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                            }
                                                        }
                                                    %><tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span style="display: inline-block;">
                                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" value="<%=val %>" /></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                                        {%>
                                                    <%string val = "";
                                                        if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                        {
                                                            object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                            if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                            {
                                                                val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                            }
                                                        }
                                                    %>
                                                    <tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span style="display: inline-block;">
                                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value %>" /></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                                        {%>
                                                    <tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span style="display: inline-block;">
                                                                <select name="<%=udf.id %>">
                                                                    <%if (udf.required != 1)
                                                                        { %>
                                                                    <option></option>
                                                                    <%} %>
                                                                    <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                                        {
                                                                            var thisValue = "";
                                                                            if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                                            {
                                                                                thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                                            }

                                                                            foreach (var thisValeList in udf.value_list)
                                                                            {%>
                                                                    <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                                                    <%
                                                                            }
                                                                        } %>
                                                                </select></span>
                                                        </div>
                                                        </td>
                                                    </tr>
                                                    <%
                                                                }
                                                            }
                                                        }  %>
                                                </tbody>
                                            </table>

                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td></td>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="other_emails" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">服务预定</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户名称 
                                    </div>
                                    <div id="">
                                        <span id="" style="display: inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                            <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="txtBlack8Class" />
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i>

                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">开始时间</span>
                                    </div>
                                    <div>
                                        <span>
                                            <input name="start_time" type="text" id="start_time" onclick="WdatePicker({ dateFmt: 'HH:mm' })" class="txtBlack8Class" value="<%=tempSerCall!=null?tempSerCall.start_time:"" %>" style="width: 76px" />&nbsp;</span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">结束时间</span>
                                    </div>
                                    <div>
                                        <span>
                                            <input name="end_time" type="text" id="end_time" class="txtBlack8Class" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=tempSerCall!=null?tempSerCall.end_time:"" %>" style="width: 76px" />&nbsp;</span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="description" rows="3" cols="55" style="resize: vertical;"><%=tempSerCall!=null?tempSerCall.description:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="status_id" id="status_id" class="txtBlack8Class" style="width: 76px">
                                                <% if (callStatusList != null && callStatusList.Count > 0)
                                                    {
                                                        foreach (var callStatu in callStatusList)
                                                        { %>
                                                <option value="<%=callStatu.id %>" <%if (tempSerCall != null && tempSerCall.status_id != null && tempSerCall.status_id == callStatu.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=callStatu.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">任务备注</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">发布对象</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="publish_type_id" id="publish_type_id" class="txtBlack8Class">
                                                <% if (pushList != null && pushList.Count > 0)
                                                    {
                                                        foreach (var puish in pushList)
                                                        { %>
                                                <option value="<%=puish.id %>" <%if (tempNote != null && tempNote.publish_type_id != null && tempNote.publish_type_id == puish.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=puish.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">备注类型</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="action_type_id" id="action_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (actList != null && actList.Count > 0)
                                                    {
                                                        foreach (var act in actList)
                                                        { %>
                                                <option value="<%=act.id %>" <%if (tempNote != null && tempNote.action_type_id == act.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=act.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="status_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticStaList != null && ticStaList.Count > 0)
                                                    {
                                                        foreach (var ticSta in ticStaList)
                                                        { %>
                                                <option value="<%=ticSta.id %>" <%if (tempNote != null && tempNote.status_id != null && tempNote.status_id == ticSta.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticSta.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">标题</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="name" type="text" id="name" class="txtBlack8Class" value="<%=tempNote != null ? tempNote.name : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="" rows="3" cols="55" style="height: 100px"><%=tempNote != null ? tempNote.description : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">任务工时</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="status_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticStaList != null && ticStaList.Count > 0)
                                                    {
                                                        foreach (var ticSta in ticStaList)
                                                        { %>
                                                <option value="<%=ticSta.id %>" <%if (tempEntry != null && tempEntry.status_id != null && tempEntry.status_id == ticSta.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticSta.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">角色</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="role_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (roleList != null && roleList.Count > 0)
                                                    {
                                                        foreach (var role in roleList)
                                                        { %>
                                                <option value="<%=role.id %>" <%if (tempEntry != null && tempEntry.role_id != null && tempEntry.role_id == role.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=role.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">默认时长</span>
                                    </div>
                                    <div class="FieldLabel">
                                        <%
                                            int hours = 0;
                                            int mins = 0;
                                            if (tempEntry != null && tempEntry.hours_worked != null)
                                            {
                                                hours = (int)Math.Floor((decimal)tempEntry.hours_worked);
                                                var thisMin = tempEntry.hours_worked - hours;
                                                if (thisMin != 0)
                                                {
                                                    mins = Convert.ToInt32(thisMin * 60);
                                                }
                                            }
                                        %>


                                        <span style="display: inline-block;">
                                            <input name="hours" type="text" value="<%=hours %>" id="hours" class="txtBlack8Class" style="width: 49px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                        &nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">小时</span>&nbsp;&nbsp;
			<span style="display: inline-block;">
                <input name="mins" type="text" value="<%=mins %>" id="mins" class="txtBlack8Class" style="width: 49px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                        &nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">分钟</span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="FieldLevelInstruction">对于起止时间，开始时间将默认为：结束时间 - 默认时长
					<br>
                                    <br>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <span class="FieldLabel" style="font-weight: bold;">工作类型</span>
                                    <div>
                                        <span class="editDD">
                                            <select name="cost_code_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (workTypeList != null && workTypeList.Count > 0)
                                                    {
                                                        foreach (var workType in workTypeList)
                                                        { %>
                                                <option value="<%=workType.id %>" <%if (tempEntry != null && tempEntry.cost_code_id != null && tempEntry.cost_code_id == workType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=workType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="input">
                                <td></td>
                                <td style="padding-bottom: 10px;">
                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="isNoBill" type="checkbox" name="isNoBill" style="vertical-align: middle;" <% if (tempEntry != null && tempEntry.is_billable == 0)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">不计费</label></span></span>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="FieldLabel"><span class="txtBlack8Class">
                <input id="isShowOnInvoice" type="checkbox" name="isShowOnInvoice" style="vertical-align: middle;" checked="checked" disabled="" /><label style="vertical-align: middle;">展示在发票上</label></span></span>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工时说明</span>
                                    </div>
                                    <div>
                                        <textarea name="summary_notes" id="" rows="3" cols="55"><%=tempEntry!=null?tempEntry.summary_notes:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">内部说明</span>
                                    </div>
                                    <div>
                                        <textarea name="internal_notes" id="" rows="3" cols="55"><%=tempEntry!=null?tempEntry.internal_notes:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET)
                { %>
            <div class="Normal Section" id="">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left">
                        <span class="Text">工单
                        </span>
                    </div>
                    <div class="Middle"></div>
                    <div class="Spacer"></div>
                    <div class="Right"></div>
                </div>
                <div class="Content">
                    <div class="Large Column">
                        <div class="Normal Column">
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>
                                        工单种类
                                    </label>
                                </div>
                            </div>
                            <div class="Editor SingleSelect">
                                <div class="InputField">
                                    <select name="cate_id" id="cate_id">
                                        <option value=""></option>
                                        <% if (ticketCateList != null && ticketCateList.Count > 0)
                                            {
                                                foreach (var ticketCate in ticketCateList)
                                                { %>
                                        <option value="<%=ticketCate.id %>" <%if (tempTicket != null && tempTicket.cate_id != null && tempTicket.cate_id == ticketCate.id)
                                            {  %>
                                            selected="selected" <%} %>><%=ticketCate.name %></option>
                                        <%  }
                                            } %>
                                    </select>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>客户</label>
                                </div>
                            </div>
                            <div class="Editor DataSelector">
                                <div class="InputField">
                                    <input name="" type="text" value="<%=thisAccount != null ? thisAccount.name : "" %>" id="accountId" class="" />
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" onclick="chooseCompany()"> <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                    <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount != null ? thisAccount.id.ToString() : "" %>" />
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>联系人</label>
                                </div>
                            </div>
                            <div class="Editor SingleDataSelector" id="">
                                <div class="ContentContainer">
                                    <div class="ValueContainer">

                                        <div class="InputContainer">
                                            
                                            <input id="contactId" type="text" value="<%=thisContact!=null?thisContact.name:"" %>" name="" />
                                            <input id="contactIdHidden" type="hidden" value="<%=thisContact!=null?thisContact.id.ToString():"" %>" name="contact_id" />
                                            <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" onclick="CallBackContact()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                        </div>

                                    </div>
                                </div>
                                

                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>其他联系人</label>
                                </div>
                            </div>
                            <div class="Editor MultipleDataSelector">
                                <div class="ContentContainer">
                                    <div class="ValueContainer">
                                        <div class="InputContainer">

                                            <input type="text" disabled="disabled"/>
                                            <input id="contactIds" type="hidden" value="" name="" />
                                            <input id="contactIdsHidden" type="hidden" value="<%=tempTicket!=null?tempTicket.additional_contact_ids:"" %>" name="additional_contact_ids" />
<a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" onclick="ContactsCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                        </div>
                                    </div>
                                </div>
                                
                                <select size="4" name="" id="otherContactIds" class="txtBlack8Class" style="height: 50px; width: 374px;">
                                </select>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>状态</label>
                                </div>
                            </div>
                            <div class="Editor ItemSelector DisplayMode">
                                <select name="status_id" id="" class="txtBlack8Class">
                                    <option value=""></option>
                                    <% if (ticStaList != null && ticStaList.Count > 0)
                                        {
                                            foreach (var ticSta in ticStaList)
                                            { %>
                                    <option value="<%=ticSta.id %>" <%if (tempTicket != null && tempTicket.status_id != null && tempTicket.status_id == ticSta.id)
                                        {  %>
                                        selected="selected" <%} %>><%=ticSta.name %></option>
                                    <%  }
                                        } %>
                                </select>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>优先级</label>
                                </div>
                            </div>
                            <div class="Editor ItemSelector DisplayMode">
                                <select name="priority_type_id" id="priority_type_id" class="txtBlack8Class">
                                    <option value=""></option>
                                    <% if (priorityList != null && priorityList.Count > 0)
                                        {
                                            foreach (var priority in priorityList)
                                            { %>
                                    <option value="<%=priority.id %>" <%if (tempTicket != null && tempTicket.priority_type_id != null && tempTicket.priority_type_id == priority.id)
                                        {  %>
                                        selected="selected" <%} %>><%=priority.name %></option>
                                    <%  }
                                        } %>
                                </select>

                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>工单类型</label>
                                </div>
                            </div>
                            <div class="Editor SingleSelect">
                                <div class="InputField">
                                    <select id="ticket_type_id" name="ticket_type_id">
                                        <option value=""></option>
                                        <% if (ticketTypeList != null && ticketTypeList.Count > 0)
                                            {
                                                foreach (var ticketType in ticketTypeList)
                                                { %>
                                        <option value="<%=ticketType.id %>" <%if (tempTicket != null && tempTicket.ticket_type_id != null && tempTicket.ticket_type_id == ticketType.id)
                                            {  %>
                                            selected="selected" <%} %>><%=ticketType.name %></option>
                                        <%  }
                                            } %>
                                    </select>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>工单标题</label>
                                </div>
                            </div>
                            <div class="Editor TextBox">
                                <div class="InputField">
                                    <input name="title" type="text" id="title" class="txtBlack8Class" style="width: 374px;" value="<%=tempTicket != null ? tempTicket.title : "" %>" />
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>工单描述</label>
                                </div>
                            </div>
                            <div class="Editor TextArea">
                                <div class="InputField">
                                    <textarea name="description" id="description" rows="3" cols="55" style="width: 374px; height: 50px; resize: vertical;"><%=tempTicket != null ? tempTicket.description : "" %></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Column">
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>合同</label>
                                </div>
                            </div>
                            <div class="Editor DataSelector">
                                <div class="InputField">
                                    <input name="contract_id" type="hidden" id="contractIdHidden" value="<%=thisContract != null ? thisContract.id.ToString() : "" %>" />
                                    <input name="" type="text" id="contractId" disabled="disabled" class="txtBlack8Class" style="width: 350px;" value="<%=thisContract != null ? thisContract.name : "" %>" />
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" onclick="ContractCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>工作类型</label>
                                </div>
                            </div>
                            <div class="Editor DataSelector">
                                <div class="InputField">
                                    <input name="cost_code_id" type="hidden" id="costCodeIdHidden" value="<%=thisCostCode != null ? thisCostCode.id.ToString() : "" %>" />
                                    <input name="" type="text" id="costCodeId" disabled="disabled" class="txtBlack8Class" style="width: 350px;" value="<%=thisCostCode != null ? thisCostCode.name : "" %>" />
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" onclick="WorkTypeCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>配置项</label>
                                </div>
                            </div>
                            <div class="Editor DataSelector">
                                <div class="InputField">
                                    <input name="installed_product_id" type="hidden" id="insProIdHidden" value="<%=tempRecTicket != null ? tempRecTicket.installed_product_id.ToString() : "" %>" />
                                    <input name="" type="text" id="insProId" disabled="disabled" class="txtBlack8Class" style="width: 350px;" value="<%=thisProduct != null ? thisProduct.name : "" %>" />
                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" onclick="InsProCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>来源</label>
                                </div>
                            </div>
                            <div class="Editor SingleSelect">
                                <div class="InputField">
                                    <select name="source_type_id" id="" class="txtBlack8Class">
                                        <option value=""></option>
                                        <% if (sourceTypeList != null && sourceTypeList.Count > 0)
                                            {
                                                foreach (var sourceType in sourceTypeList)
                                                { %>
                                        <option value="<%=sourceType.id %>" <%if (tempTicket != null && tempTicket.source_type_id != null && tempTicket.source_type_id == sourceType.id)
                                            {  %>
                                            selected="selected" <%} %>><%=sourceType.name %></option>
                                        <%  }
                                            } %>
                                    </select>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>队列</label>
                                </div>
                            </div>
                            <div class="Editor ItemSelector DisplayMode">
                                <select name="department_id" id="department_id" class="txtBlack8Class">
                                    <option value=""></option>
                                    <% if (queueList != null && queueList.Count > 0)
                                        {
                                            foreach (var queue in queueList)
                                            { %>
                                    <option value="<%=queue.id %>" <%if (tempTicket != null && tempTicket.department_id != null && tempTicket.department_id == queue.id)
                                        {  %>
                                        selected="selected" <%} %>><%=queue.name %></option>
                                    <%  }
                                        } %>
                                </select>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>主负责人</label>
                                </div>
                            </div>
                            <div class="Editor SingleDataSelector">
                                <div class="ContentContainer">
                                    <div class="ValueContainer">
                                        <div class="InputContainer">
                                            <% string res = "";
                                                string role = "";
                                                if (proResDep != null&&resList!=null&&roleList!=null)
                                                {
                                                    var thisRes = resList.FirstOrDefault(_ => _.id == proResDep.resource_id);
                                                    var thisRole = roleList.FirstOrDefault(_ => _.id == proResDep.role_id);
                                                    if (thisRes != null && thisRole != null)
                                                    {
                                                        res = thisRes.name;role = thisRole.name;
                                                    }
                                                }
                                                %>
                                            <input id="owner_resource_id" type="text" value="<%=!string.IsNullOrEmpty(res)&&!string.IsNullOrEmpty(role)?res+$"({role})":"" %>" name="" style="width: 350px;" />
                                            <input type="hidden" id="owner_resource_idHidden" name="redDepId" value="<%=proResDep!=null?proResDep.id.ToString():"" %>" />  <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" onclick="ChoosePriRes()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                        </div>

                                    </div>
                                </div>
                              

                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>其他负责人</label>
                                </div>
                            </div>
                            <div class="Editor MultipleDataSelector">
                                <div class="ContentContainer">
                                    <div class="ValueContainer">
                                        <div class="InputContainer">
                                            <input id="" type="text" value="" name="SecondaryResources" style="width: 350px;" />
                                             <input id="OtherResId" type="hidden" />
                                <input id="OtherResIdHidden" name="second_resource_ids" type="hidden" value="<%=tempTicket!=null?tempTicket.second_resource_ids:"" %>" />
                                <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" onclick="OtherResCallBack()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -191px -44px;"></span><span class="Text"></span></a>
                                        </div>
                                    </div>
                                </div>
                               
                                 <select multiple="multiple" id="otherRes" style="height: 110px; width: 85%; float: left;">
                            </select>
                            </div>
                            <div class="EditorLabelContainer" style="clear:both;">
                                <div class="Label">
                                    <label>预估时间</label>
                                </div>
                            </div>
                            <div class="Editor DecimalBox">
                                <div class="InputField">
                                    <input id="" type="text" value="<%=tempTicket!=null&&tempTicket.estimated_hours!=null?((decimal)tempTicket.estimated_hours).ToString("#0.00"):"" %>" name="estimated_hours" maxlength="14" class="ToDec2" />
                                </div>
                            </div>
                            <div class="Medium Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label>问题类型</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect">
                                    <div class="InputField">
                                        <select name="issue_type_id" id="issue_type_id" class="txtBlack8Class" style="width:128px;">
                                            <option value=""></option>
                                            <% if (issueTypeList != null && issueTypeList.Count > 0)
                                                {
                                                    foreach (var issueType in issueTypeList)
                                                    { %>
                                            <option value="<%=issueType.id %>" <%if (tempTicket != null && tempTicket.issue_type_id != null && tempTicket.issue_type_id == issueType.id)
                                                {  %>
                                                selected="selected" <%} %>><%=issueType.name %></option>
                                            <%  }
                                                } %>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="Medium Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label>子问题类型</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect">
                                    <div class="InputField">
                                        <select name="sub_issue_type_id" id="sub_issue_type_id" class="txtBlack8Class" style="width:128px;" >
                                            <option selected="selected" value=""></option>

                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>服务等级协议(SLA)</label>
                                </div>
                            </div>
                            <div class="Editor SingleSelect">
                                <div class="InputField">
                                    <select name="sla_id" id="sla_id" class="txtBlack8Class">
                                        <option value=""></option>
                                        <% if (slaList != null && slaList.Count > 0)
                                            {
                                                foreach (var sla in slaList)
                                                { %>
                                        <option value="<%=sla.id %>" <%if (tempTicket != null && tempTicket.sla_id != null && tempTicket.sla_id == sla.id)
                                            {  %>
                                            selected="selected" <%} %>><%=sla.name %></option>
                                        <%  }
                                            } %>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReplaceableColumnContainer">
                        <div class="Large Column">
                            <div class="ReadOnlyData">
                                <div class="LabelContainer"><span class="Label">截止日期</span></div>
                                <div class="Value">
                                    <div class="FormatPreservation">
                                        Due Date: No default (user entry required)
Due Time: No default (user entry required)
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="Large Column">
                        <div class="ButtonContainer"><a class="Button ButtonIcon Link NormalState" id="zdedaf020e1c84417bfab71f7c4998049" tabindex="0">Edit</a></div>
                    </div>
                </div>
            </div>

            <div class="Normal Section">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left"><span class="Text">自定义字段</span></div>
                    <div class="Middle"></div>
                    <div class="Spacer"></div>
                    <div class="Right"></div>
                </div>
                <div class="Content">
                    <div class="Large Column">
                        <div id="" style="border-style: None; padding-bottom: 0px; min-height: 30px;">
                            <table border="0" style="border-collapse: collapse;" width="100%">
                                <tbody>
                                    <% if (tickUdfList != null && tickUdfList.Count > 0)
                                        {
                                            foreach (var udf in tickUdfList)
                                            {
                                                if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)
                                                {%>
                                    <tr>
                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                            <span style="display: inline-block;">
                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" value="<%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():"" %>" /></span>
                                        </div>
                                        </td>
                                    </tr>
                                    <%}
                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)
                                        {%>
                                    <tr>
                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                            <span style="display: inline-block;">
                                                <textarea name="<%=udf.id %>" rows="2" cols="20"><%=ticketUdfValueList!=null&&ticketUdfValueList.Count>0&& ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id)!=null?ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString():""  %></textarea></span>
                                        </div>
                                        </td>
                                    </tr>
                                    <%}
                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                        {%>
                                    <%string val = "";
                                        if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                        {
                                            object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                            if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                            {
                                                val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                            }
                                        }
                                    %><tr>
                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                            <span style="display: inline-block;">
                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" value="<%=val %>" /></span>
                                        </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                        {%>
                                    <%string val = "";
                                        if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                        {
                                            object value = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                            if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                            {
                                                val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                            }
                                        }
                                    %>
                                    <tr>
                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                            <span style="display: inline-block;">
                                                <input name="<%=udf.id %>" type="text" id="" class="txtBlack8Class" style="width: 170px;" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value %>" /></span>
                                        </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                        {%>
                                    <tr>
                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;"><%=udf.name %></span><span id="" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                            <span style="display: inline-block;">
                                                <select name="<%=udf.id %>">
                                                    <%if (udf.required != 1)
                                                        { %>
                                                    <option></option>
                                                    <%} %>
                                                    <% if (udf.value_list != null && udf.value_list.Count > 0)
                                                        {
                                                            var thisValue = "";
                                                            if (ticketUdfValueList != null && ticketUdfValueList.Count > 0 && ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id) != null)
                                                            {
                                                                thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == udf.id).value.ToString();
                                                            }

                                                            foreach (var thisValeList in udf.value_list)
                                                            {%>
                                                    <option value="<%=thisValeList.val %>" <%=thisValue==thisValeList.val?"selected='selected'":"" %>><%=thisValeList.show %></option>
                                                    <%
                                                            }
                                                        } %>
                                                </select></span>
                                        </div>
                                        </td>
                                    </tr>
                                    <%
                                                }
                                            }
                                        }  %>
                                </tbody>
                            </table>

                        </div>

                    </div>
                </div>
            </div>

            <div class="Normal Section">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left"><span class="Text">变更信息</span></div>
                    <div class="Middle"></div>
                    <div class="Spacer"></div>
                    <div class="Right"></div>
                </div>
                <div class="Content">
                    <div class="Large Column">
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>影响分析</label>
                            </div>
                        </div>
                        <div class="Editor TextArea">
                            <div class="InputField">
                                <textarea class="Medium" id="" name="impact_analysis" placeholder=""><%=tempTicket!=null?tempTicket.impact_analysis:"" %></textarea>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>实施计划</label>
                            </div>
                        </div>
                        <div class="Editor TextArea">
                            <div class="InputField">
                               <textarea class="Medium" id="" name="implementation_plan" placeholder=""><%=tempTicket!=null?tempTicket.implementation_plan:"" %></textarea>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>版本计划</label>
                            </div>
                        </div>
                        <div class="Editor TextArea">
                            <div class="InputField">
                                <textarea class="Medium" id="" name="roll_out_plan" placeholder=""><%=tempTicket!=null?tempTicket.roll_out_plan:"" %></textarea>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>回滚计划</label>
                            </div>
                        </div>
                        <div class="Editor TextArea">
                            <div class="InputField">
                               <textarea class="Medium" id="" name="back_out_plan" placeholder=""><%=tempTicket!=null?tempTicket.back_out_plan:"" %></textarea>
                            </div>
                        </div>
                        <div class="EditorLabelContainer">
                            <div class="Label">
                                <label>审阅记录</label>
                            </div>
                        </div>
                        <div class="Editor TextArea">
                            <div class="InputField">
                                <textarea class="Medium" id="" name="review_notes" placeholder=""><%=tempTicket!=null?tempTicket.review_notes:"" %></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="Normal Section">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left"><span class="Text">检查单</span></div>
                    <div class="Middle"></div>
                    <div class="Spacer"></div>
                    <div class="Right"></div>
                </div>
                <div class="DescriptionText">你最多可以输入20个条目.</div>
                <div class="Content">
                 
                       <div class="ToolBar">
                                    <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon New NormalState" id="AddCheckListButton" tabindex="0" style="color:black;"><span class="Icon"></span><span class="Text">新增检查单</span></a></div>
                                    <div class="ToolBarItem Left"><a class="Button ButtonIcon NormalState" id="AddCheckListFromLibraryButton" tabindex="0"  style="color:black;"><span class="Icon"></span><span class="Text">从知识库添加</span></a></div>
                                    <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon NormalState" id="SaveToLibraryButton" tabindex="0" style="color:black;"><span class="Icon"></span><span class="Text">保存到知识库</span></a></div>
                                    <div class="Spacer"></div>
                                </div>
                         <div class="Grid Small" id="TicketChecklistItemsGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0" style="min-width:650px;">
                                            <thead class="HeaderContainer">
                                                <tr class="HeadingRow">
                                                    <td class=" Interaction DragEnabled" style="width: 60px;">
                                                        <div class="Standard"></div>
                                                    </td>
                                                    <td class=" Context" style="width: 20px;">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class=" Image" style="width: 20px;">
                                                        <div class="Standard">
                                                            <div class="BookOpen ButtonIcon">
                                                                <div class="Icon"></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">完成</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">条目</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Boolean" style="text-align: center;">
                                                        <div class="Standard">
                                                            <div class="Heading">重要</div>
                                                        </div>
                                                    </td>
                                                    <%--<td class="ScrollBarSpacer" style="width: 19px;"></td>--%>
                                                </tr>
                                            </thead>
                                            <div class="cover"></div>
                                            <tbody id="Drap" class="Drap RowContainer BodyContainer">
                                                <div class="border_left">
                                                </div>
                                                <div class="border_right">
                                                </div>
                                                <div class="border-line"></div>
                                                <% if (tempCheckList != null && tempCheckList.Count > 0)
                                                    {
                                                        int num = 0;
                                                        foreach (var item in tempCheckList)
                                                        {
                                                            num++;
                                                %>
                                                <tr data-val="<%=item.id %>" id="<%=item.id %>" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num"><%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %></div>
                                                            <input type="hidden" id="<%=item.id %>_sort_order" name="<%=item.id %>_sort_order" value="<%=item.sort_order==null?"":((decimal)item.sort_order).ToString("#0") %>" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                    <td>
                                                        <%if (item.is_competed == 1)
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_complete" name="<%=item.id %>_is_complete" checked="checked" />
                                                        <%}
                                                            else
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_complete" name="<%=item.id %>_is_complete" />
                                                        <%} %>
                                                     

                                                    </td>
                                                    <td>
                                                        <input type="text" id="<%=item.id %>_item_name" name="<%=item.id %>_item_name" value="<%=item.item_name %>" /></td>
                                                    <td>
                                                        <%if (item.is_important == 1)
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" checked="checked" />
                                                        <%}
                                                            else
                                                            { %>
                                                        <input type="checkbox" id="<%=item.id %>_is_import" name="<%=item.id %>_is_import" />
                                                        <%} %>
                                                    </td>
                                                </tr>
                                                <%
                                                        }
                                                    }
                                                    else
                                                    { %>
                                                <tr data-val="-1" id="-1" class="HighImportance D" draggable="true">
                                                    <td class="Interaction">
                                                        <div>
                                                            <div class="Decoration Icon DragHandle">
                                                            </div>
                                                            <div class="Num">1</div>
                                                            <input type="hidden" id="-1_sort_order" name="-1_sort_order" value="1" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <a class="ButtonIcon Button ContextMenu NormalState ">
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px; height: 15px;">
                                                            </div>
                                                        </a>
                                                    </td>
                                                    <td></td>
                                                    <td>
                                                        <input type="checkbox" id="-1_is_complete" name="-1_is_complete" /></td>
                                                    <td>
                                                        <input type="text" id="-1_item_name" name="-1_item_name" /></td>
                                                    <td>
                                                        <input type="checkbox" id="-1_is_import" name="-1_is_import" /></td>

                                                </tr>
                                                <%} %>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                        <div class="NoDataMessage">未查询到相关数据</div>
                                        <input type="hidden" id="CheckListIds" name="CheckListIds" />
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>
                </div>
            </div>

             <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="menu" id="menu" style="background-color: #f8f8f8;">
            <%--菜单--%>
            <ul style="width: 220px;" id="menuUl">
                <li id="AddToAbove" onclick="AddAbove()">添加到条目上面</li>
                <li id="AddToBelow" onclick="AddBelow()">添加到条目下面</li>
                <li id="CopyItem" onclick="CopyThisItem()">复制</li>
                <li id="AssKonw">关联知识库</li>
                <li id="DeleteItem" onclick="Delete()">删除</li>
            </ul>
        </div>

            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">工单备注</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">发布对象</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="publish_type_id" id="publish_type_id" class="txtBlack8Class">
                                                <% if (pushList != null && pushList.Count > 0)
                                                    {
                                                        foreach (var puish in pushList)
                                                        { %>
                                                <option value="<%=puish.id %>" <%if (tempNote != null && tempNote.publish_type_id != null && tempNote.publish_type_id == puish.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=puish.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">备注类型</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="action_type_id" id="action_type_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (actList != null && actList.Count > 0)
                                                    {
                                                        foreach (var act in actList)
                                                        { %>
                                                <option value="<%=act.id %>" <%if (tempNote != null && tempNote.action_type_id == act.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=act.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="status_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticStaList != null && ticStaList.Count > 0)
                                                    {
                                                        foreach (var ticSta in ticStaList)
                                                        { %>
                                                <option value="<%=ticSta.id %>" <%if (tempNote != null && tempNote.status_id != null && tempNote.status_id == ticSta.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticSta.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">标题</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="name" type="text" id="name" class="txtBlack8Class" value="<%=tempNote != null ? tempNote.name : "" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">描述</span>
                                    </div>
                                    <div>
                                        <textarea name="description" id="" rows="3" cols="55" style="height: 100px"><%=tempNote != null ? tempNote.description : "" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="ckCreateNote" style="vertical-align: middle;" <%if (tempNote != null && tempNote.apply_note_incidents == 1)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">本次新增的备注、附件信息同时在相关的事故上（共n个关联的事故）增加</label></span></span>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="ckAppSlo" style="vertical-align: middle;" <%if (tempNote != null && tempNote.append_to_resolution == 1)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">描述信息附加到解决方案</label></span></span>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span id="" class="FieldLabel"><span class="txtBlack8Class">
                        <input id="" type="checkbox" name="ckAppSloInc" style="vertical-align: middle;" <%if (tempNote != null && tempNote.append_to_resolution_incidents == 1)
                            { %>
                            checked="checked" <%} %> /><label style="vertical-align: middle;">描述信息附加到相关事故（共n个关联的事故）的解决方案</label></span></span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                { %>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">工单工时</span>
                </div>
                <div class="Content">
                    <table id="entireThing" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">状态</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="status_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (ticStaList != null && ticStaList.Count > 0)
                                                    {
                                                        foreach (var ticSta in ticStaList)
                                                        { %>
                                                <option value="<%=ticSta.id %>" <%if (tempEntry != null && tempEntry.status_id != null && tempEntry.status_id == ticSta.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=ticSta.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">角色</span>
                                    </div>
                                    <div>
                                        <span>
                                            <select name="role_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (roleList != null && roleList.Count > 0)
                                                    {
                                                        foreach (var role in roleList)
                                                        { %>
                                                <option value="<%=role.id %>" <%if (tempEntry != null && tempEntry.role_id != null && tempEntry.role_id == role.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=role.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">默认时长</span>
                                    </div>
                                    <div class="FieldLabel">
                                        <%
                                            int hours = 0;
                                            int mins = 0;
                                            if (tempEntry != null && tempEntry.hours_worked != null)
                                            {
                                                hours = (int)Math.Floor((decimal)tempEntry.hours_worked);
                                                var thisMin = tempEntry.hours_worked - hours;
                                                if (thisMin != 0)
                                                {
                                                    mins = Convert.ToInt32(thisMin * 60);
                                                }
                                            }
                                        %>


                                        <span style="display: inline-block;">
                                            <input name="hours" type="text" value="<%=hours %>" id="hours" class="txtBlack8Class" style="width: 49px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                        &nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">小时</span>&nbsp;&nbsp;
			<span style="display: inline-block;">
                <input name="mins" type="text" value="<%=mins %>" id="mins" class="txtBlack8Class" style="width: 49px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                        &nbsp;<span class="FieldLevelInstruction" style="font-weight: normal;">分钟</span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="FieldLevelInstruction">对于起止时间，开始时间将默认为：结束时间 - 默认时长
					<br>
                                    <br>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <span class="FieldLabel" style="font-weight: bold;">工作类型</span>
                                    <div>
                                        <span class="editDD">
                                            <select name="cost_code_id" id="" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (workTypeList != null && workTypeList.Count > 0)
                                                    {
                                                        foreach (var workType in workTypeList)
                                                        { %>
                                                <option value="<%=workType.id %>" <%if (tempEntry != null && tempEntry.cost_code_id != null && tempEntry.cost_code_id == workType.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=workType.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="input">
                                <td></td>
                                <td style="padding-bottom: 10px;">
                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="isNoBill" type="checkbox" name="isNoBill" style="vertical-align: middle;" <% if (tempEntry != null && tempEntry.is_billable == 0)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">不计费</label></span></span>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="FieldLabel"><span class="txtBlack8Class">
                <input id="isShowOnInvoice" type="checkbox" name="isShowOnInvoice" style="vertical-align: middle;" checked="checked" disabled="" /><label style="vertical-align: middle;">展示在发票上</label></span></span>

                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工时说明</span>
                                    </div>
                                    <div>
                                        <textarea name="summary_notes" id="" rows="3" cols="55"><%=tempEntry!=null?tempEntry.summary_notes:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="input" style="padding-bottom: 10px;">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="ckAppSlo" style="vertical-align: middle;" <%if (tempEntry != null && tempEntry.append_to_resolution == 1)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">附加到解决方案</label></span></span>

                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="FieldLabel"><span class="txtBlack8Class">
                        <input id="" type="checkbox" name="ckAppSloInc" style="vertical-align: middle;" <%if (tempEntry != null && tempEntry.append_to_resolution_incidents == 1)
                            { %>
                            checked="checked" <%} %> /><label style="vertical-align: middle;">附件到相关事故（n个事故）的解决方案</label></span></span>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">内部说明</span>
                                    </div>
                                    <div>
                                        <textarea name="internal_notes" id="" rows="3" cols="55"><%=tempEntry!=null?tempEntry.internal_notes:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="input">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="ckCreateNote" style="vertical-align: middle;" <%if (tempEntry != null && tempEntry.apply_note_incidents == 1)
                                            { %>
                                            checked="checked" <%} %> /><label style="vertical-align: middle;">为相关事故（n个事故）创建备注，并更新状态</label></span></span>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span class="lblNormalClass" style="font-weight: bold; font-weight: bold;">通知</span>
                </div>
                <div class="Content">
                    <table id="notficationTable" class="entireThing" cellpadding="0" cellspacing="0" width="100%">
                        <tbody>
                            <tr>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0" style="padding-bottom: 10px;">
                                        <tbody>
                                            <% if (notifyList != null && notifyList.Count > 0)
                                                {
                                                    foreach (var notify in notifyList)
                                                    {%>
                                            <tr>
                                                <td class="input CheckboxPadding">
                                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                                            { %>
                                                            checked="checked" <%} %> />
                                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                                </td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">

                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        通知模板
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="notify_tmpl_id" id="notify_tmpl_id" class="txtBlack8Class">
                                                <option value=""></option>
                                                <% if (tempNotiList != null && tempNotiList.Count > 0)
                                                    {
                                                        foreach (var tempNoti in tempNotiList)
                                                        { %>
                                                <option value="<%=tempNoti.id %>" <%if (temp != null && temp.notify_tmpl_id != null && temp.notify_tmpl_id == tempNoti.id)
                                                    {  %>
                                                    selected="selected" <%} %>><%=tempNoti.name %></option>
                                                <%  }
                                                    } %>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">

                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        附加文本
                                    </div>
                                    <div>
                                        <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {
        <%if (temp != null)
    { %>
         <%if (temp.range_type_id == (int)EMT.DoneNOW.DTO.DicEnum.RANG_TYPE.OWN)
    {%>
        $("#rdo_me").trigger("click");
    <%}
    else if (temp.range_type_id == (int)EMT.DoneNOW.DTO.DicEnum.RANG_TYPE.DEPARTMENT)
    {%>
        $("#rdo_department").trigger("click");
    <%}
    else if (temp.range_type_id == (int)EMT.DoneNOW.DTO.DicEnum.RANG_TYPE.ALL)
    {%>
        $("#rdo_company").trigger("click");
<%    } %>
        <%} %>
    })
    $("#rdo_me").click(function () {
        $("#range_department_id").prop("disabled", true);
    })
    $("#rdo_company").click(function () {
        $("#range_department_id").prop("disabled", true);
    })
    $("#rdo_department").click(function () {
        $("#range_department_id").prop("disabled", false);
    })
    $(".ToDec2").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })
    $("#SaveClose").click(function () {
        var tmpl_name = $("#tmpl_name").val();
        if (tmpl_name == "") {
            LayerMsg("请填写模板名称！");
            return false;
        }
        var speed_code = $("#speed_code").val();
        if (speed_code == "") {
            LayerMsg("请填写快速代码！");
            return false;
        }
        var isRep = ""; // 快速代码是否重复
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/FormTempAjax.ashx?act=CheckTempCode&code=" + speed_code +"&id=<%=temp!=null?temp.id.ToString():"" %>",
            dataType: "json",
            success: function (data) {
                if (data) {

                }
                else {
                    isRep = "1";
                }
            },
        });
        if (isRep == "1") {
            LayerMsg("快速代码重复，请重新填写！");
            return false;
        }
        <%  if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET)
    {%>
        GetCheckIds();
        <%} %>
        return true;
    })
    // 客户查找带回
    function chooseCompany() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=GetContactList", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 产品查找带回
    function chooseProduct() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=productId", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    $("#issue_type_id").change(function () {
        GetSubIssueType();
    })

    // 根据 问题类型，返回相应的子问题类型
    function GetSubIssueType() {
        var subIssTypeHtml = "<option value=''> </option>";
        var issue_type_id = $("#issue_type_id").val();
        if (issue_type_id != "" && issue_type_id != null && issue_type_id != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=GetGeneralByParentId&parent_id=" + issue_type_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            subIssTypeHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#sub_issue_type_id").html(subIssTypeHtml);
    }
</script>
<!--商机JS -->
<script>
    $(function () {
        <% if (tempOppo != null)
    { %>
         <%if (tempOppo.account_id != null)
    { %>
        GetContactList();
        <%}%>

        <%if (tempOppo.contact_id != null)
    { %>
        $("#contact_id").val('<%=tempOppo.contact_id.ToString() %>');
        <%} %>
        <%if (tempOppo.projected_close_date_type_id == (int)EMT.DoneNOW.DTO.DicEnum.PROJECTED_CLOSE_DATE.FROM_TODAY)
    {%>
        $("#ckFromToday").trigger("click");
    <%}
    else if (tempOppo.projected_close_date_type_id == (int)EMT.DoneNOW.DTO.DicEnum.PROJECTED_CLOSE_DATE.FROM_CREATE)
    {%>
        $("#ckFromCreate").trigger("click");
    <%}
    else if (tempOppo.projected_close_date_type_id == (int)EMT.DoneNOW.DTO.DicEnum.PROJECTED_CLOSE_DATE.LAST_DAY_OF_MONTH)
    {%>
        $("#ckDayMonth").trigger("click");
        $("#selOppoDayMonth").val("<%=tempOppo.projected_close_date_type_value.ToString() %>");
<%    } %>
        <%if (tempOppo.use_quote_revenue_and_cost == 1)
    { %>
        $("#ckOppoUseQuote").trigger("click");
        <%} %>
          <%if (tempOppo.spread_revenue_recognition_value == 1)
    { %>
        $("#ckOppoSpreadValue").trigger("click");
        $("#spread_revenue_recognition_unit").val('<%=tempOppo.spread_revenue_recognition_unit %>');
        <%} %>
         <%} %>

    })
    $("#ckKeep").click(function () {
        $("#txtOppoFromToday").prop("disabled", true);
        $("#txtOppoFromCreate").prop("disabled", true);
        $("#selOppoDayMonth").prop("disabled", true);
    })
    $("#ckFromToday").click(function () {
        $("#txtOppoFromToday").prop("disabled", false);
        $("#txtOppoFromCreate").prop("disabled", true);
        $("#selOppoDayMonth").prop("disabled", true);
    })
    $("#ckFromCreate").click(function () {
        $("#txtOppoFromToday").prop("disabled", true);
        $("#txtOppoFromCreate").prop("disabled", false);
        $("#selOppoDayMonth").prop("disabled", true);
    })
    $("#ckDayMonth").click(function () {
        $("#txtOppoFromToday").prop("disabled", true);
        $("#txtOppoFromCreate").prop("disabled", true);
        $("#selOppoDayMonth").prop("disabled", false);
    })
    $("#ckOppoUseQuote").click(function () {
        if ($(this).is(":checked")) {
            $(".Calculation").prop("disabled", true);
        }
        else {
            $(".Calculation").prop("disabled", false);
        }

    })

    $("#ckOppoSpreadValue").click(function () {
        if ($(this).is(":checked")) {
            $("#number_months_for_estimating_total_profit").prop("disabled", false);
            $("#spread_revenue_recognition_unit").prop("disabled", false);
        }
        else {
            $("#number_months_for_estimating_total_profit").prop("disabled", true);
            $("#spread_revenue_recognition_unit").prop("disabled", true);
        }

    })
      <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.OPPORTUNITY)
    { %>
    function GetContactList() {
        var account_id = $("#accountIdHidden").val();
        if (account_id != "") {
            $("#contact_id").prop("disabled", false);
            $("#contact_id").html("");
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

        } else {
            $("#contact_id").prop("disabled", true);
        }

    }
    <%}%>


</script>
<!--快速服务预定JS -->
<script>
    $(function () {
        <% if (tempQuickCall != null)
    { %>
        <%if (tempQuickCall.account_id != null)
    { %>
        GetContactList();
        <%}%>
        <% if (tempQuickCall.contact_id != null)
    {%>
        $("#contact_id").val('<%=tempQuickCall.contact_id %>');
        <% }%>
        $("#issue_type_id").trigger("change");
        <%if (tempQuickCall.sub_issue_type_id != null)
    { %>
        $("#sub_issue_type_id").val('<%=tempQuickCall.sub_issue_type_id %>');
        <%} %>
        GetResDepByIds();
        <%} %>
    })
       <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
    { %>
    $("#resRoleId").change(function () {
        var resRoleId = $("#resRoleId").val();
        var OtherResId = $("#OtherResIdHidden").val();
        if (resRoleId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=ChechByResRole&ResRole=" + resRoleId + "&OtherIds=" + OtherResId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.isRepeat) {
                            $("#OtherResIdHidden").val(data.newDepResIds);
                        }

                    }
                },
            });
            GetResDepByIds();
        }
    })
    <%}%>
    // 其他负责人的查找带回- 带回的其他负责人包含主负责人时，提示 主负责人已经包含该员工 是 删除主负责人信息，否 从其他负责人中删除该联系人
    function OtherResCallBack() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&muilt=1&field=OtherResId&callBack=GetOtherResData";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 获取到其他负责人的相应信息
    function GetOtherResData() {
        // 检查是否有重复员工
        // 检查带回员工是否与主负责人有冲突
        // 
        var OtherResId = $("#OtherResIdHidden").val();
        if (OtherResId != "") {
            var resRoleId = $("#resRoleId").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=ChechByResRole&ResRole=" + resRoleId + "&OtherIds=" + OtherResId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.isRepeat) {
                            $("#resRoleId").val("");
                            //$("#OtherResIdHidden").val(data.newDepResIds);
                        }

                    }
                },
            });
            GetResDepByIds();
        }
    }

    // 其他负责人的数据返回（此方法不做员工重复校验）
    function GetResDepByIds() {
        var resDepIds = $("#OtherResIdHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
                    if (data != "") {
                        $("#otherRes").html(data);
                        $("#otherRes option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        } else {
            $("#otherRes").html("");
        }

    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#otherRes option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#OtherResIdHidden").val(ids);
    }
     <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.QUICK_CALL)
    { %>
    function GetContactList() {
        var account_id = $("#accountIdHidden").val();
        if (account_id != "") {
            $("#contact_id").prop("disabled", false);
            $("#contact_id").html("");
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
            $("#contractId").prop("disabled", false);
            $("#contractId").val("");
            $("#contractIdHidden").val("");
        } else {
            $("#contact_id").prop("disabled", true);
            $("#contractId").prop("disabled", true);
            $("#contractId").val("");
            $("#contractIdHidden").val("");
        }

    }
    <%}%>
    function ContractCallBack() {
        var account_idHidden = $("#accountIdHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=" + account_idHidden + "&field=contractId", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }
    }
    function WorkTypeCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE %>&field=costCodeId", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }


</script>

<!--报价JS -->
<script>
    $(function () {
         <%if (tempQuote != null)
    { %>
        GetContactList();
          <% if (tempQuote.contact_id != null)
    {%>
        $("#contact_id").val('<%=tempQuote.contact_id %>');
        <% }%>
         <% if (tempQuote.opportunity_id != null)
    {%>
        $("#opportunity_id").val('<%=tempQuote.opportunity_id %>');
        <% }%>

         <%} %>
    })

      <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.QUOTE)
    { %>
    function GetContactList() {
        var account_id = $("#accountIdHidden").val();
        if (account_id != "") {
            $("#contact_id").prop("disabled", false);
            $("#contact_id").html("");
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
            $("#opportunity_id").html("");
            // $("#opportunity_idHidden").val("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=opportunity&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#opportunity_id").html(data);
                        $("#opportunity_id option[value='0']").remove();
                    }
                },
            });
            document.getElementById("opportunity_id").options.add(new Option(" ", ""), 0);
            //$("#opportunity_id").append("<option value=''> </option>"); 
            $("#opportunity_id").val('');
            $("#opportunity_id").prop("disabled", false);

        } else {
            $("#contact_id").prop("disabled", true);
            $("#opportunity_id").prop("disabled", true);
            $("#opportunity_id").html("");
        }

    }
    <%}%>
</script>

<!--定期工单JS -->
<script>
    $(function () {
         <%if (tempRecTicket != null)
    { %>
        GetContactList();
        $("#contractId").val("<%=thisContract!=null?thisContract.name:"" %>");
         $("#contractIdHidden").val("<%=thisContract!=null?thisContract.id.ToString():"" %>");
         $("#insProId").val("<%=thisProduct!=null?thisProduct.name.ToString():"" %>");
         $("#insProIdHidden").val("<%=thisInsPro!=null?thisInsPro.id.ToString():"" %>");
          <% if (tempRecTicket.contact_id != null)
    {%>
         $("#contact_id").val('<%=tempRecTicket.contact_id %>');
        <% }%>
         $("#issue_type_id").trigger("change");
        <%if (tempRecTicket.sub_issue_type_id != null)
    { %>
         $("#sub_issue_type_id").val('<%=tempRecTicket.sub_issue_type_id %>');
        <%} %>

           <%if (tempRecTicket.recurring_end_date != null)
    { %>
         $("#rdEnd").trigger("click");
         <%}
    else if (tempRecTicket.recurring_instances != null)
    { %>
         $("#rdIns").trigger("click");
         <%} %>

         <%if (tempRecTicket.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.DAY)
    {
        var dayDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrDayDto>(tempRecTicket.recurring_define);
        if (dayDto != null)
        {%>
         $("#day_every").val('<%=dayDto.every %>');
         $("#day_no_sat").prop("checked",<%=dayDto.no_sat == 1 ? "true" : "false" %>);
         $("#day_no_sun").prop("checked",<%=dayDto.no_sun == 1 ? "true" : "false" %>);
        <%}
        %>

         $("#rdDay").trigger("click");

         <%}
    else if (tempRecTicket.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.WEEK)
    {  %>
          <% var weekDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrWeekDto>(tempRecTicket.recurring_define);
    if (weekDto != null)
    {%>
         $("#week_eve_week").val('<%=weekDto.every %>');
        <%
    if (weekDto.dayofweek != null && weekDto.dayofweek.Count() > 0)
    {
        if (weekDto.dayofweek.Any(_ => _ == 1))
        {%>
           $("#ckWeekMon").prop("checked", true);
            <%}
    if (weekDto.dayofweek.Any(_ => _ == 2))
    {%>
           $("#ckWeekTus").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 3))
    { %>
           $("#ckWeekWed").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 4))
    {%>
           $("#ckWeekThu").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 5))
    { %>
           $("#ckWeekFri").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 6))
    {%>
           $("#ckWeekSat").prop("checked", true);
            <%
    }
    if (weekDto.dayofweek.Any(_ => _ == 7))
    {%>
           $("#ckWeekSun").prop("checked", true);
            <%
            }
        }
    }%>
            $("#rdWeek").trigger("click");
         <%}
    else if (tempRecTicket.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.MONTH)
    {
        var monthDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(tempRecTicket.recurring_define);
        if (monthDto != null)
        {
            %>
         <%if (monthDto.day != -1)
    { %>
        $("#rdMonth0").trigger("click");
        $("#month_month_day").val('<%=monthDto.month %>');
        $("#month_day_num").val('<%=monthDto.day %>');
         <%}
    else
    {%>
        $("#rdMonth1").trigger("click");
        $("#month_month_eve_num").val('<%=monthDto.month %>');
        $("#month_1_month").val("<%=monthDto.no %>");
        $("#month_1_week").val("<%=monthDto.dayofweek %>");
   <% } %>


        <%}
        %>
        $("#rdMonth").trigger("click");
         <% }
    else if (tempRecTicket.recurring_frequency == (int)EMT.DoneNOW.DTO.DicEnum.RECURRING_TICKET_FREQUENCY_TYPE.YEAR)
    {
        var yearDto = new EMT.Tools.Serialize().DeserializeJson<EMT.DoneNOW.DTO.TicketRecurrMonthDto>(tempRecTicket.recurring_define);
        if (yearDto != null)
        {
            %>
         <%if (yearDto.day != -1)
    { %>
        $("#rdYear0").trigger("click");
        $("#year_every_month").val('<%=yearDto.month %>');
           $("#year_month_day").val('<%=yearDto.day %>');
         <%}
    else
    {%>
           $("#rdYear1").trigger("click");
           $("#year_the_month").val('<%=yearDto.month %>');
           $("#year_month_week_num").val("<%=yearDto.no %>");
           $("#year_the_week").val("<%=yearDto.dayofweek %>");
   <% } %>
        <%}
        %>
           $("#rdYear").trigger("click");
         <%}
    }%>
    })


    $("#rdEnd").click(function () {
        $("#recurring_end_date").prop("disabled", false);
        $("#recurring_instances").prop("disabled", true);
    })
    $("#rdIns").click(function () {
        $("#recurring_end_date").prop("disabled", true);
        $("#recurring_instances").prop("disabled", false);
    })

    $("#rdDay").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlDaily").show();
    })
    $("#rdWeek").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlWeekly").show();
    })
    $("#rdMonth").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlMonthly").show();
    })
    $("#rdYear").click(function () {
        $(".FrequencyClass").hide();
        $("#pnlYearly").show();
    })
    $("#rdMonth0").click(function () {
        $("#month_day_num").prop("disabled", false);
        $("#month_month_day").prop("disabled", false);
        $("#month_month_eve_num").prop("disabled", true);
        $("#month_1_month").prop("disabled", true);
        $("#month_1_week").prop("disabled", true);
    })
    $("#rdMonth1").click(function () {
        $("#month_day_num").prop("disabled", true);
        $("#month_month_day").prop("disabled", true);
        $("#month_month_eve_num").prop("disabled", false);
        $("#month_1_month").prop("disabled", false);
        $("#month_1_week").prop("disabled", false);
    })
    $("#rdYear0").click(function () {

        $("#year_the_month").prop("disabled", true);
        $("#year_month_week_num").prop("disabled", true);
        $("#year_the_week").prop("disabled", true);
        $("#year_every_month").prop("disabled", false);
        $("#year_month_day").prop("disabled", false);
    })
    $("#rdYear1").click(function () {
        $("#year_the_month").prop("disabled", false);
        $("#year_month_week_num").prop("disabled", false);
        $("#year_the_week").prop("disabled", false);
        $("#year_every_month").prop("disabled", true);
        $("#year_month_day").prop("disabled", true);
    })

    function ContractCallBack() {
        var account_idHidden = $("#accountIdHidden").val();
        if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACTMANAGE_CALLBACK %>&con626=1&con627=" + account_idHidden + "&field=contractId", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }
    }
    // 配置项的查找带回
    function InsProCallBack() {
        var accountId = $("#accountIdHidden").val();
        if (accountId != "" && accountId != null && accountId != undefined) {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSPRODUCT_CALLBACK %>&con1247=" + accountId + "&field=insProId", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>", 'left=200,top=200,width=600,height=800', false);
         }
         else {
             LayerMsg("请先选择客户");
         }

    }
    <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.RECURRING_TICKET)
    {%>
     function GetContactList() {
         var account_id = $("#accountIdHidden").val();
         if (account_id != "") {
             $("#contact_id").prop("disabled", false);
             $("#contact_id").html("");
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
             $("#contractId").prop("disabled", false);
             $("#insProId").prop("disabled", false);

         } else {
             $("#contact_id").prop("disabled", true);
             $("#contractId").prop("disabled", true);
             $("#insProId").prop("disabled", true);
         }
         $("#contractId").val("");
         $("#contractIdHidden").val("");
         $("#insProId").val("");
         $("#insProIdHidden").val("");

     }
    <%} %>
</script>
<!--服务预定JS -->
<script>
     <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.SERVICE_CALL)
    {%>
     function GetContactList() {
     }
    <%} %>
</script>
<!--任务工时JS -->
<script>
     $(function () {
         <% if (tempEntry != null)
    { %>
         <% if (tempEntry.is_billable == 0)
    { %>
         $("#isShowOnInvoice").prop("disabled", false);
         <%}
    else
    { %>
         $("#isShowOnInvoice").prop("disabled", true);
          <%} %>
            <% if (tempEntry.show_on_invoice == 1)
    { %>
         $("#isShowOnInvoice").prop("checked", true);
         <%}
    else
    { %>
         $("#isShowOnInvoice").prop("checked", false);
          <%} %>

         <%} %>
     })

     $("#hours").blur(function () {
         var hours = $(this).val();
         if (!isNaN(hours) && hours != "") {
             if (Number(hours) > 23) {
                 LayerMsg("默认小时不能超过23小时");
                 $(this).val("23");
             }
             else if (Number(hours) < 0) {
                 LayerMsg("默认小时不能小于0小时");
                 $(this).val("0");
             }
         }
         else {
             $(this).val("");
         }
     })
     $("#mins").blur(function () {
         var mins = $(this).val();
         if (!isNaN(mins) && mins != "") {
             if (Number(mins) > 59) {
                 LayerMsg("默认分钟不能超过59分钟");
                 $(this).val("59");
             }
             else if (Number(mins) < 0) {
                 LayerMsg("默认分钟不能小于0分钟");
                 $(this).val("0");
             }
         }
         else {
             $(this).val("");
         }
     })
     $("#isNoBill").click(function () {
         if ($(this).is(":checked")) {
             $("#isShowOnInvoice").prop("disabled", false);
             $("#isShowOnInvoice").prop("checked", false);
         }
         else {
             $("#isShowOnInvoice").prop("disabled", true);
             $("#isShowOnInvoice").prop("checked", true);
         }
     })
</script>

<!--工单JS -->
<script>
     $(function () {

         <%if (tempTicket != null)
    { %>
         $("#issue_type_id").trigger("change");
        <%if (tempTicket.sub_issue_type_id != null)
    { %>
          $("#sub_issue_type_id").val('<%=tempTicket.sub_issue_type_id %>');
        <%} %>
          GetContactByIds();
          GetResDepByIds();

         <%} %>

     })




     // 联系人的查找带回
     function CallBackContact() {
         var account_idHidden = $("#accountIdHidden").val();
         if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
             window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&con628=" + account_idHidden + "&field=contactId&callBack=SingContactDeal", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }

     }

     function ContactsCallBack() {
         var account_idHidden = $("#accountIdHidden").val();
         if (account_idHidden != "" && account_idHidden != null && account_idHidden != undefined) {
             window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&con628=" + account_idHidden + "&field=contactIds&muilt=1&callBack=ManyContactDeal", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
         }
         else {
             LayerMsg("请先选择客户");
         }
     }
     function ManyContactDeal() {
         var contactId = $("#contactIdHidden").val();
         var contactIds = $("#contactIdsHidden").val();
         if (contactId != "" && contactIds != "") {
             var conArr = contactIds.split(',');
             if (conArr.indexOf(contactId) != -1) {
                 LayerConfirm("是否将主要联系人更改为附加联系人", "是", "否", function () {
                     $("#contactId").val("");
                     $("#contactIdHidden").val("");
                     GetContactByIds();
                 }, function () { SingContactDeal(); });
             }
         }
         else {
             GetContactByIds();
         }
     }
     function SingContactDeal() {
         var contactId = $("#contactIdHidden").val();
         var contactIds = $("#contactIdsHidden").val();
         if (contactId != "" && contactIds != "") {
             var conArr = contactIds.split(',');
             if (conArr.indexOf(contactId) != -1) {
                 var newIds = "";
                 for (var i = 0; i < conArr.length; i++) {
                     if (conArr[i] != contactId) {
                         newIds += conArr[i] + ',';
                     }
                 }
                 if (newIds != "")
                     newIds = newIds.substring(0, newIds.length - 1);
                 $("#contactIdsHidden").val(newIds);
                 GetContactByIds();
             }
         }
     }
     function GetContactByIds() {
         var contactIds = $("#contactIdsHidden").val();
         debugger;
         if (contactIds != "") {
             $.ajax({
                 type: "GET",
                 url: "../Tools/ContactAjax.ashx?act=GetConList&ids=" + contactIds,
                 async: false,
                 //dataType:"json",
                 success: function (data) {
                     if (data != "") {
                         $("#otherContactIds").html(data);
                         $("#otherContactIds option").dblclick(function () {
                             RemoveContact(this);
                         })
                     }
                 }

             })
         }
         else {
             $("#otherContactIds").html("");
             
         }
         
     }
     function RemoveContact(val) {
         $(val).remove();
         var ids = "";
         $("#otherContactIds option").each(function () {
             ids += $(this).val() + ',';
         })
         if (ids != "") {
             ids = ids.substr(0, ids.length - 1);
         }
         $("#contactIdsHidden").val(ids);
     }

    <%if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET)
    { %>
     function GetContactList() {
         var accountId = $("#accountIdHidden").val();
         if (accountId != "") {
             $("#contactId").prop("disabled", false);
             $("#contractId").prop("disabled", false);
             $("#insProId").prop("disabled", false);
         }
         else {
             $("#contactId").prop("disabled", true);
             $("#contractId").prop("disabled", true);
             $("#insProId").prop("disabled", true);
         }
         
     }  // 主负责人查找带回
     function ChoosePriRes() {
         var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=owner_resource_id&callBack=GetResByCallBack";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
     }
     // 主负责人查找带回事件 - 当带回的主负责人在其他负责人中出现的时候-从其他负责人中删除，然后带回主负责人
     function GetResByCallBack() {
         var owner_resource_id = $("#owner_resource_idHidden").val();
         if (owner_resource_id != "") {
             var OtherResId = $("#OtherResIdHidden").val();
             if (OtherResId != "") {  //
                 $.ajax({
                     type: "GET",
                     async: false,
                     url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&isDelete=1&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
                     dataType: "json",
                     success: function (data) {
                         if (data != "") {
                             if (data.isRepeat) {
                                 $("#OtherResIdHidden").val(data.newDepResIds);
                                 GetResDepByIds();
                             }
                         }
                     },
                 });
             }  // 检查主负责人是否与其他负责人冲突

         } else {
             $("#owner_resource_id").val("");
         }
     }
     // 其他负责人的查找带回- 带回的其他负责人包含主负责人时，提示 主负责人已经包含该员工 是 删除主负责人信息，否 从其他负责人中删除该联系人
     function OtherResCallBack() {
         var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&muilt=1&field=OtherResId&callBack=GetOtherResData";
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 获取到其他负责人的相应信息
    function GetOtherResData() {
        // 检查是否有重复员工
        // 检查带回员工是否与主负责人有冲突
        // 
        var OtherResId = $("#OtherResIdHidden").val();
        if (OtherResId != "") {
            var owner_resource_id = $("#owner_resource_idHidden").val();
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ResourceAjax.ashx?act=CheckResInResDepIds&resDepIds=" + OtherResId + "&resDepId=" + owner_resource_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#OtherResIdHidden").val(data.newDepResIds);
                        if (data.isRepeat) {
                            LayerConfirm("选择员工已经是主负责人，是否将其置为其他负责人", "是", "否", function () { $("#owner_resource_idHidden").val(""); $("#owner_resource_id").val(""); }, function () { GetResByCallBack(); });
                        }

                    }
                },
            });
            GetResDepByIds();
        }
    }

    // 其他负责人的数据返回（此方法不做员工重复校验）
    function GetResDepByIds() {
        var resDepIds = $("#OtherResIdHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
                    if (data != "") {
                        $("#otherRes").html(data);
                        $("#otherRes option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        } else {
            $("#otherRes").html("");
        }

    }
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#otherRes option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#OtherResIdHidden").val(ids);
    }
    <%} %>
   

</script>

<!--检查单信息js操作 -->
<script>
    var pageCheckId = -1;
    // 新增检查单
    function AddCheckList(copyNum, upOrDown, upOrDownId) {
        // copyNum 复制的Id 没有代表新增不复制--（复制不考虑其他，名称复制后名称加入‘复制’）
        pageCheckId--;
        var newCheckHtml = "<tr data-val='" + pageCheckId + "' id='" + pageCheckId + "'  class='HighImportance D' draggable='true'><td class='Interaction' ><div><div class='Decoration Icon DragHandle'></div><div class='Num'></div> <input type='hidden' id='" + pageCheckId + "_sort_order' name='" + pageCheckId + "_sort_order' value=''/></div></td ><td><a class='ButtonIcon Button ContextMenu NormalState'><div class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px;height:15px;'></div></a></td><td></td><td><input type='checkbox' id='" + pageCheckId + "_is_complete' name='" + pageCheckId + "_is_complete' /></td><td><input type='text' id='" + pageCheckId + "_item_name' name='" + pageCheckId + "_item_name' /></td><td><input type='checkbox' id='" + pageCheckId + "_is_import' name='" + pageCheckId + "_is_import' /></td></tr>";



        if (upOrDownId != "" && upOrDown != "") {
            if (upOrDown == "Up") {
                $("#" + upOrDownId).before(newCheckHtml);
            }
            else {
                $("#" + upOrDownId).after(newCheckHtml);
            }
        } else {
            $("#Drap").append(newCheckHtml);
        }

        SortNum();
        if (copyNum != "")  // 复制的  相关赋值  todo 关联的知识库的赋值
        {
            if ($("#" + copyNum + "_is_complete").is(":checked")) {
                $("#" + pageCheckId + "_is_complete").prop("checked", true);
            }
            if ($("#" + copyNum + "_is_import").is(":checked")) {
                $("#" + pageCheckId + "_is_import").prop("checked", true);
            }
            $("#" + pageCheckId + "_item_name").val($("#" + copyNum + "_item_name").val() + "(复制)");
        }
        BindMenu();

    }
    // 为页面的检查单数字排序
    function SortNum() {
        var sortNum = 1;
        $(".HighImportance").each(function () {
            $(this).find('.Num').text(sortNum);
            $(this).find('.Num').next().val(sortNum);
            sortNum++;
        })
    }

    $("#AddCheckListButton").click(function () {
        AddCheckList("", "", "");
    })
    var entityid = "";
    var Times = 0;
    function BindMenu() {
        $(".ContextMenu").bind("click", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).parent().parent().data("val");// data("val");
            var menu = document.getElementById("menu");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 800);
            };
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var Top = $(document).scrollTop() + oEvent.clientY;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            var rightWidth = winWidth - oEvent.clientX;
            var bottomHeight = winHeight - oEvent.clientY;
            if (winWidth < clientWidth && rightWidth < menuWidth) {
                menu.style.left = winWidth - menuWidth - 18 + 103 + scrLeft + "px";
            } else {
                menu.style.left = Left + 13 + "px";
            }


            if (winHeight < clientHeight && bottomHeight < menuHeight) {
                menu.style.top = winHeight - menuHeight - 55 + scrTop + "px";
            } else {
                menu.style.top = Top - 85 + "px";
            }
            document.onclick = function () {
                menu.style.display = "none";
            }
            return false;
        });
    }

    BindMenu();

    // 添加到上面
    function AddAbove() {

        if (entityid != "") {
            AddCheckList("", "Up", entityid);
        }
    }
    // 添加到下面
    function AddBelow() {
        if (entityid != "") {
            AddCheckList("", "Down", entityid);
        }
    }
    // 复制操作
    function CopyThisItem() {
        if (entityid != "") {
            AddCheckList(entityid, "", "");
        }
    }
    // 删除任务单
    function Delete() {
        if (entityid != "") {
            LayerConfirm("删除不可恢复，是否继续删除？", "是", "否", function () { $("#" + entityid).remove(); }, function () { });
            SortNum();
        }
    }
    // 获取到页面的检查单的Id
    function GetCheckIds() {
        var ckIds = "";
        $(".HighImportance").each(function () {
            var thisVal = $(this).data("val");
            if (thisVal != "" && thisVal != null && thisVal != undefined) {
                ckIds += thisVal + ',';
            }
        })
        if (ckIds != "") {
            ckIds = ckIds.substring(0, ckIds.length - 1);
        }
        $("#CheckListIds").val(ckIds);
    }
</script>



