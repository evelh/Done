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
                            <% if (notifyList != null && notifyList.Count > 0) {
                                    foreach (var notify in notifyList)
                                    {%>
                            <tr>
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                            { %> checked="checked"  <%} %>  />
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
                                            <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
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
                                            <select name="" id="" class="txtBlack8Class">

                                                <option selected="selected" value="1">All Autotask Users</option>
                                                <option value="2">Internal Project Team</option>
                                                <option value="3">Project Team</option>
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="EditControlFormProjectNoteEntryFavEditor.ascx_JournalUse" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">Announce</label></span></span>
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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                <option value="8">Email</option>
                                                <option value="5">Project Notes</option>
                                                <option value="12">Project Status</option>

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
                                            <input name="" type="text" id="" class="txtBlack8Class" /></span>
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
                                        <textarea name="" id="" rows="3" cols="55" style="height: 100px"></textarea>
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
                                             <% if (notifyList != null && notifyList.Count > 0) {
                                    foreach (var notify in notifyList)
                                    {%>
                            <tr>
                                
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                            { %> checked="checked"  <%} %>  />
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
                                             <input name="other_emails" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" value="<%=temp!=null?temp.other_emails:"" %>" /></span>
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
                                        <span id="" class="FieldLevelInstruction" style="font-weight: normal;">The selected Notification Template's "Send From" setting will override the Form Template's setting</span>
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
                                       <textarea name="additional_email_text" id="additional_email_text" rows="3" cols="67" class="oppText2" style="resize: vertical; width: 374px;"><%=temp!=null?temp.additional_email_text:"" %></textarea>
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
                                        <input name="" type="hidden" id="" /><nobr><span id="" style="display:inline-block;">
                                            <input name="" type="text" id="" class="txtBlack8Class"  style="width:360px;" /></span>&nbsp;
                                            <i onclick="chooseCompany()" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i></nobr>
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
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;"></select></span></td>

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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 100%;" /></span>
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
                                        <textarea name="" id="" rows="3" cols="55" style="width: 360px; height: 50px"></textarea>
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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>


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
                                            <select name="" id="" class="txtBlack8Class">
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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                <option value="3">Standard</option>
                                                <option value="1">Standard (non-editable)</option>
                                                <option value="2">AEM Alert</option>

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
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Contract</span>
                                    </div>
                                    <div id="">
                                        <input name="" type="hidden" id="" /><nobr><span id=""  style="display:inline-block;"><input name="" type="text" id="" disabled="disabled" class="txtBlack8Class" autocomplete="off" style="width:360px;" /></span>&nbsp;</nobr>
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
                                        <input name="" type="hidden" id="" /><nobr><span id=""  style="display:inline-block;"><input name="" type="text" id="" class="txtBlack8Class" style="width:360px;" /></span>&nbsp;</nobr>
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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                <option value="29683378">Administration</option>
                                                <option value="5">Client Portal</option>
                                                <option value="29682833">Level I Support</option>
                                                <option value="8">Monitoring Alert</option>
                                                <option value="6">Post Sale</option>
                                                <option value="29683354">Recurring Tickets</option>

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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td></td>
                                <td class="inputLabel">
                                    <span id="" class="FieldLabel" style="font-weight: bold; width: 85px;">其他负责人</span>
                                    <div>
                                        <span id="" style="display: inline-block;">
                                            <select size="4" name="" id="" class="txtBlack8Class" style="height: 50px; width: 374px;">
                                            </select></span>

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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 76px" />&nbsp;</span>
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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 76px" />&nbsp;</span>
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
                                <% if (notifyList != null && notifyList.Count > 0) {
                                    foreach (var notify in notifyList)
                                    {%>
                            <tr>
                                <td class="input CheckboxPadding">
                                    <span class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="noti<%=notify.id %>" style="vertical-align: middle;" <%if (notiIds != null && notiIds.Contains(notify.id.ToString()))
                                            { %> checked="checked"  <%} %>  />
                                        <label style="vertical-align: middle;"><%=notify.name %></label></span></span>
                                </td>
                            </tr>
                                   <% }
                                } %>
                            <tr>
                                <td></td>
                                <td class="inputLabel" colspan="2">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">通知模板</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="" id="" class="txtBlack8Class">
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
                    <span id="EditControlFormQuoteEntryFavEditor.ascx_QuoteLabel" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Quote</span>
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
                                        <input name="" type="hidden" id="" /><nobr><span id="" style="display:inline-block;">
                                            <input name="" type="text" id="" class="txtBlack8Class"  style="width:360px;" /></span>&nbsp;
                                            <i onclick="" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i></nobr>
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
                                            <select name="" id="" class="txtBlack8Class" disabled="disabled">
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
                                            <input name="" type="text" maxlength="200" id="" class="txtBlack8Class" /></span>
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
                                        <textarea name="" id="" maxlength="1000" rows="3" cols="55"></textarea>
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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 76px; text-align: right;" /></span> 距离现在
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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 76px; text-align: right;" /></span> 距离现在
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
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">税区域</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                <option value="1">shanghai</option>
                                                <option value="2">zimaoqu</option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">报价激活</label></span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;"></span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">External Quote Number</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="" type="text" id="" class="txtBlack8Class" /></span>
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
                                        <textarea name="" id="" rows="3" cols="55"></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Terms</span>
                </div>
                <div class="Content">
                    <table id="Table1" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">Payment Terms</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>


                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Payment Type</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Purchase Order Number</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="" type="text" id="" class="txtBlack8Class" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Shipping Type</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

                                            </select></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">Bill To Address same as Sold To Address</label></span></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="input">
                                    <div>
                                        <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                            <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">Ship To Address same as Sold To Address</label></span></span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Notification</span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td></td>
                                <td class="input">
                                    <table class="input" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr class="inputRow">
                                                <td class="input CheckboxPadding" style="width: 210px">
                                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" />
                                                        <label style="vertical-align: middle;">CC Me</label></span></span>
                                                </td>
                                                <td class="input CheckboxPadding">
                                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" /><labe style="vertical-align: middle;">Account Manager</labe></span></span>
                                                </td>
                                            </tr>

                                            <tr class="inputRow">
                                                <td class="input CheckboxPadding">
                                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">Quote Contact</label></span></span>
                                                </td>
                                                <td class="input CheckboxPadding"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Other Email(s)</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="" type="text" maxlength="2000" id="" class="txtBlack8Class" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr id="" class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Notification Template</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="" id="" class="txtBlack8Class">
                                            </select></span>
                                    </div>
                                </td>
                            </tr>

                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Subject</span>
                                    </div>
                                    <div>
                                        <span id="">
                                            <input name="" type="text" maxlength="100" id="" class="txtBlack8Class" /></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel3">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Additional Email Text</span>
                                    </div>
                                    <div>
                                        <textarea name="" id="" rows="3" cols="55"></textarea>
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
                    <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_RecurringTicketLabel" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Recurring Ticket</span>
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
                                        <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_ContractLabel" class="lblNormalClass" style="font-weight: bold;">合同</span>
                                    </div>
                                    <div id="" >
                                        <input name="" type="hidden" id="" /><nobr><span id="" disabled="disabled"  style="display:inline-block;"><input name="" type="text" id="" disabled="disabled" class="txtBlack8Class" style="width:360px;" /></span>&nbsp;<i onclick="" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i></nobr>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">工作类型</span>
                                    </div>
                                    <div id="" class="tickettitletext">
                                        <input name="" type="hidden" id="" /><nobr><span id="" style="display:inline-block;"><input name="" type="text" id="" class="txtBlack8Class" style="width:360px;" /></span>&nbsp;<i onclick="" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i></nobr>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        配置项
                                    </div>
                                    <div id="">
                                        <input name="" type="hidden" id="" /><nobr><span id=""><input name="" type="text" id="" disabled="disabled" class="txtBlack8Class"  style="width:360px;" /></span>&nbsp;<i onclick="" style="width: 16px; height: 16px; float: right; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -192px -48px;"></i></nobr>
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
                                        <span id="" class="lblNormalClass" style="font-weight: bold;">Source</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD">
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                             

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
                                        <span id="" class="tickettitletext">
                                            <input name="" type="text" id="" class="txtBlack8Class" /></span>
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
                                        <textarea name="" id="" rows="3" cols="55" style="width: 360px; height: 50px" ></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel" style="padding-top: 5px">
                                    <div class="FieldLabel">
                                        <span id="" class="lblNormalClass" style="font-weight:bold;">队列</span>
                                        <div>
                                            <span id="" class="ResourceQueueDD">
                                                <select name="ascx:" id="" class="txtBlack8Class">

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
                                                <select name="" id="" class="txtBlack8Class" >
                                                    <option selected="selected" value=""></option>
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
                                        <span  id="">
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 76px" />&nbsp;</span>
                                        <br>
                                        <br>
                                        <span id="">
                                            <input name="" type="text" id="" class="txtBlack8Class"  style="width: 76px; text-align: right;" /></span>
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
                                            <select name="" id="" class="txtBlack8Class">

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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>

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
                                            <input name="" type="text" maxlength="12" id="" class="txtBlack8Class" style="text-align: right;" /></span>
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
                                            <select name="" id="" class="txtBlack8Class">

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
                                            <select name="" id="" class="txtBlack8Class">

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
                                            <select name="" id="" class="txtBlack8Class" >
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
                    <span id="" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">Duration</span>
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
                                                    <input name="" type="text" id="" class="txtBlack8Class" style="text-align: right;" /></span>
                                                <span class="txtBlack8Class">距离现在天数
                                                </span>
                                            </div>
                                        </td>
                                        <td class="CheckboxPadding">
                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                <input id="" type="checkbox" name="" checked="checked" style="vertical-align: middle;" /><label style="vertical-align: middle;">Active (only impacts Recurrence Master Search)</label></span></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                End Date / End After (# instances)
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                <input id="" type="radio" name="" value="radioEndDaysFromNow" checked="checked" />
                                                <span class="oppNumber">
                                                    <input name="" type="text" id="" class="txtBlack8Class" style="text-align: right;" /></span>
                                                <span class="txtBlack8Class">距离现在时间
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="FieldLabel">
                                                <input id="" type="radio" name="" value="radioEndInstances"/>
                                                <span id="" class="oppNumber">
                                                    <input name="" type="text" id="" class="txtBlack8Class" style="text-align: right;"  disabled="" /></span>
                                                <span class="txtBlack8Class">instances
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
                                    <td style="height: 100%;">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input id="" type="radio" name="" value="radioDaily" />
                                                            <span class="txtBlack8Class">天</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input id="" type="radio" name="" value="radioWeekly" />
                                                            <span class="txtBlack8Class">周</span>
                                                        </div>
                                                    </td>

                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input id="" type="radio" name="" value="radioMonthly" checked="checked" />
                                                            <span class="txtBlack8Class">月</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input id="" type="radio" name="" value="radioYearly" />
                                                            <span class="txtBlack8Class">年
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td class="FieldLabel" style="padding-top: 0px; padding-left: 50px;">
                                        <div id="" style="display: none;">

                                            <div>
                                                每隔
									<span id="" class="oppNumber">
                                        <input name="" type="text" value="1" id="" class="txtBlack8Class"  style="text-align: right;" /></span>
                                                天
                                            </div>
                                            <div>
                                                <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                    <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">周六不创建</label></span></span>
                                            </div>
                                            <div>
                                                <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                    <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周日不创建</label></span></span>
                                            </div>

                                        </div>
                                        <div id="" style="display: none;">

                                            <table>
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3">
                                                            <div>
                                                                每隔
												<span id="" class="oppNumber">
                                                    <input name="" type="text" value="1" id="" class="txtBlack8Class"  style="text-align: right;" /></span>
                                                                周:
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>

                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周日</label></span></span>
                                                        </td>
                                                         <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周三</label></span></span>
                                                        </td>
                                                         <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周六</label></span></span>
                                                        </td>

                                                    </tr>
                                                    <tr>
                                                         <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周一</label></span></span>
                                                        </td>
                                                       <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周四</label></span></span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                         <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周二</label></span></span>
                                                        </td>
                                                        <td style="width: 100px">
                                                            <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                                <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label  style="vertical-align: middle;">周五</label></span></span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>

                                        </div>
                                        <div id="" style="display:inline;">
                                          到期
								<div>
                                    <input id="" type="radio" name="" value="radioSpecificDay" checked="checked" />
                                    <span class="lblNormalClass" style="font-weight: normal;">天  </span><span id="" class="oppNumber">
                                        <input name="" type="text" id="" class="txtBlack8Class" style="text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">  每  </span><span id="" class="oppNumber">
                                            <input name="" type="text" value="1" id="" class="txtBlack8Class"  style="text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;"> 月</span>
                                </div>
                                            <div>
                                                <input id="" type="radio" name="a" value="radioRelativeDay" />
                                                <span class="lblNormalClass" style="font-weight: normal;">The  </span><span id="">
                                                    <select name="" id="" class="txtBlack8Class" style="width: 100px" disabled="">
                                                        <option value="0"></option>

                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;"> </span><span id="">
                                                        <select name="" id="" class="txtBlack8Class" style="width: 100px" disabled="">
                                                            <option value="0"></option>

                                                        </select></span><span class="lblNormalClass" style="font-weight: normal;">  of every  </span><span id="" class="oppNumber">
                                                            <input name="" type="text" value="1" id="" class="txtBlack8Class"  style="text-align: right;"  disabled="" /></span><span class="lblNormalClass" style="font-weight: normal;">  month(s) </span>
                                            </div>

                                        </div>
                                        <div id="" style="display: none;">

                                            <div>
                                                <input id="" type="radio" name="" value="radioYearlySpecific" checked="checked" />
                                                <span class="lblNormalClass" style="font-weight: normal;">Due every  </span><span id="">
                                                    <select name="" id="" class="txtBlack8Class" style="width: 100px">
                                                        <option value="0"></option>
                                                        <option selected="selected" value="1">January</option>
                                                        <option value="2">February</option>
                                                        <option value="3">March</option>
                                                        <option value="4">April</option>
                                                        <option value="5">May</option>
                                                        <option value="6">June</option>
                                                        <option value="7">July</option>
                                                        <option value="8">August</option>
                                                        <option value="9">September</option>
                                                        <option value="10">October</option>
                                                        <option value="11">November</option>
                                                        <option value="12">December</option>

                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">   </span><span id="" class="oppNumber">
                                                        <input name="" type="text" id="" class="txtBlack8Class"  style="text-align: right;" /></span><span class="lblNormalClass" style="font-weight: normal;">  </span>
                                            </div>
                                            <div>
                                                <input id="" type="radio" name="" value="radioYearlyRelative" />
                                                <span class="lblNormalClass" style="font-weight: normal;">The  </span><span id="">
                                                    <select name="" id="" class="txtBlack8Class" style="width: 100px" disabled="">
                                                        <option value="0"></option>
                                                       

                                                    </select></span><span class="lblNormalClass" style="font-weight: normal;">   </span><span id="">
                                                        <select name="" id="" class="txtBlack8Class" style="width: 100px" disabled="">
                                                            <option value="0"></option>
                                                            <option selected="selected" value="1">Monday</option>
                                                            <option value="2">Tuesday</option>
                                                            <option value="4">Wednesday</option>
                                                            <option value="8">Thursday</option>
                                                            <option value="16">Friday</option>
                                                            <option value="32">Saturday</option>
                                                            <option value="64">Sunday</option>
                                                            <option value="128">Day</option>
                                                            <option value="256">Weekday</option>

                                                        </select></span><span class="lblNormalClass" style="font-weight: normal;">  in  </span><span id=">
                                                            <select name="" id="" class="txtBlack8Class" style="width: 100px" disabled="">
                                                                <option value="0"></option>
                                                                <option selected="selected" value="1">January</option>
                                                                <option value="2">February</option>
                                                                <option value="3">March</option>
                                                                <option value="4">April</option>
                                                                <option value="5">May</option>
                                                                <option value="6">June</option>
                                                                <option value="7">July</option>
                                                                <option value="8">August</option>
                                                                <option value="9">September</option>
                                                                <option value="10">October</option>
                                                                <option value="11">November</option>
                                                                <option value="12">December</option>

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
                    <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_UDFLabel" class="lblNormalClass" style="font-weight: bold; font-weight: bold;">User-Defined Fields</span>
                </div>
                <div class="Content">
                    <div id="EditControlFormRecurringTicketEntryFavEditor.ascx_UDFForm" class="searchpanel" style="width: 100%;">


                        <table style="overflow-y: auto; border-collapse: collapse; border: 0px;" id="udfWrapperTable" class="Neweditsubsection" width="100%">
                            <tbody>
                                <tr>
                                    <td style="border: 0px;">

                                        <div id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_pnlMain" style="border-style: None; padding-bottom: 0px; min-height: 30px;">
                                            <table border="0" style="border-collapse: collapse;" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;">ticket-01</span><span id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682911_ATTextEdit_required_span" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682911" style="display: inline-block;">
                                                                <input name="EditControlFormRecurringTicketEntryFavEditor.ascx:ucTicketFormTemplateUDF:udf_29682911:ATTextEdit" type="text" id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682911_ATTextEdit" class="txtBlack8Class" isrequired="0" validationcaption="ticket-01" onkeypress=";SetPageIsDirtyOnKeyPress(event);" onchange=";SetPageIsDirty();" style="width: 170px;"></span>
                                                        </div>
                                                        </td>
                                                        <td valign="top" align="left" width="170px"><span class="Fieldlabel" style="font-weight: bold;">ticket-02</span><span id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_ATTextEdit_required_span" class="errorSmallClass" style="font-weight: bold;"></span><div>
                                                            <span image_id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimage" image_disabled_id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimagedisabled" id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912" style="display: inline-block;">
                                                                <input name="EditControlFormRecurringTicketEntryFavEditor.ascx:ucTicketFormTemplateUDF:udf_29682912:ATTextEdit" type="text" id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_ATTextEdit" class="txtBlack8Class" isdate="1" dontvalidateonload="1" isrequired="0" validationcaption="ticket-02" image_id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimage" image_disabled_id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimagedisabled" onkeypress=";SetPageIsDirtyOnKeyPress(event);" onchange=";SetPageIsDirty();" style="width: 170px;" title="DD/MM/YYYY">&nbsp;<img id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimage" class="DateEditImage" onclick="CalendarPopup.Show(event, document.getElementById('EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_ATTextEdit'));" src="/graphics/icons/content/date.png?v=49958" alt="Calendar" border="0" style="cursor: pointer; display: inline-block;"><img id="EditControlFormRecurringTicketEntryFavEditor.ascx_ucTicketFormTemplateUDF_udf_29682912_calimagedisabled" class="DateEditDisabledImage" src="/graphics/icons/content/date-disabled.png?v=49958" border="0" style="display: none;"></span>
                                                        </div>
                                                        </td>
                                                    </tr>
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
                                            <tr>
                                                <td class="CheckboxPadding">
                                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" origchecked="true"><label for="EditControlFormRecurringTicketEntryFavEditor.ascx_ccME_ATCheckBox" style="vertical-align: middle;">CC Me</label></span></span>
                                                </td>
                                                <td class="CheckboxPadding">
                                                    <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_chkAcctMgr" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="EditControlFormRecurringTicketEntryFavEditor.ascx_chkAcctMgr_ATCheckBox" type="checkbox" name="EditControlFormRecurringTicketEntryFavEditor.ascx:chkAcctMgr:ATCheckBox" style="vertical-align: middle;" origchecked="true"><label for="EditControlFormRecurringTicketEntryFavEditor.ascx_chkAcctMgr_ATCheckBox" style="vertical-align: middle;">Account Manager</label></span></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="CheckboxPadding">
                                                    <span id="EditControlFormRecurringTicketEntryFavEditor.ascx_fromHelpDesk" class="FieldLabel"><span class="txtBlack8Class">
                                                        <input id="EditControlFormRecurringTicketEntryFavEditor.ascx_fromHelpDesk_ATCheckBox" type="checkbox" name="EditControlFormRecurringTicketEntryFavEditor.ascx:fromHelpDesk:ATCheckBox" style="vertical-align: middle;" origchecked="true"><label for="EditControlFormRecurringTicketEntryFavEditor.ascx_fromHelpDesk_ATCheckBox" style="vertical-align: middle;">Send Email from hong.li@itcat.net.cn</label></span></span>
                                                </td>
                                                <td class="CheckboxPadding"></td>
                                            </tr>
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
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TASK_NOTE)
                { %>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TASK_TIME_ENTRY)
                { %>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET)
                { %>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET_NOTE)
                { %>
            <%}
                else if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.TICKET_TIME_ENTRY)
                { %>
            <%} %>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
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
        return true;
    })
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
    // 客户查找带回
    function chooseCompany() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=GetContactList", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
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
    // 产品查找带回
    function chooseProduct() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=productId", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

</script>
