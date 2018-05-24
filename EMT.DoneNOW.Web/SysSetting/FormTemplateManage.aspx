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
                <li onclick="SaveClose()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -128px -32px;" class="icon-1"></i><asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" /></li>
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

        <div id="editForm" class="searchpanel" >
            <% if (formTypeId == (int)EMT.DoneNOW.DTO.DicEnum.FORM_TMPL_TYPE.OPPORTUNITY){ %>
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
                                            <input name="name" type="text" id="" class="txtBlack8Class" value="<%=tempOppo != null ? tempOppo.name : "" %>"/></span>
                                    </div>
                                </td>
                            </tr>
                            <tr class="inputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        客户
                                    </div>
                                    <div id="" widthatdataselector="360">
                                        <span id=""  style="display:inline-block;">
                                            <input name="account_id" type="hidden" id="accountIdHidden" value="<%=thisAccount!=null?thisAccount.id.ToString():"" %>" />
                                            <input name="" type="text" value="<%=thisAccount!=null?thisAccount.name:"" %>" id="accountId" class="txtBlack8Class" />
                                            <img id="" src="" align="top" border="0" style="cursor:pointer;" />
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
                                                    <td id=""><span  style="display: inline-block;">
                                                        <select name="contact_id" id="contact_id" class="txtBlack8Class" style="width: 374px;">
                                                        </select>
                                                              </span></td>
                                                    <td id="" style="display: none;">
                                                        </td>
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
                                            <select name="" id="" class="txtBlack8Class">
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
                                        <span  class="editDD">
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
                                                        <span onchange="OnProjectCloseDateChange()">
                                                            <input id="ckKeep" type="radio" name="OppoCloseType" value="pcdKeepCurrent"/></span>
                                                        <span class="txtBlack8Class">保持不变</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckFromToday" type="radio" name="OppoCloseType" value="radioFromToday" checked="checked" />
                                                        <span class="txtBlack8Class">距离今天:</span>
                                                    </td>
                                                    <td>
                                                        <span id="" class="oppNumber">
                                                            <input name="txtOppoFromToday" type="text" value="0" id="txtOppoFromToday" class="txtBlack8Class" style="text-align: right;width:105px;" /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckFromCreate" type="radio" name="OppoCloseType" value="radioFromCreateDate"/>
                                                        <span class="txtBlack8Class">距离创建时间:</span>
                                                    </td>
                                                    <td>
                                                        <span id="" class="oppNumber">
                                                            <input name="txtOppoFromCreate" type="text" id="txtOppoFromCreate" class="txtBlack8Class" style="text-align: right;width:105px;" /></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input id="ckDayMonth" type="radio" name="OppoCloseType" value="radioLastDayOfMonth" />
                                                        <span class="txtBlack8Class">该月份的最后一天:&nbsp;&nbsp;&nbsp;</span>
                                                    </td>
                                                    <td class="oppNumber">
                                                        <span id="" class="pcdLastDayOfMonth">
                                                            <select name="selOppoDayMonth" id="selOppoDayMonth" class="txtBlack8Class" style="width:105px;" >
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
                                            <input name="" type="text" id="" class="txtBlack8Class" style="width: 120px; text-align: right;" value="<%=tempOppo!=null&&tempOppo.probability!=null?tempOppo.probability.ToString():"" %>" /></span>
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
                                    <div id="EditControlFormOpportunityEntryFavEditor.ascx_primaryProductID" favoriteid="dslProduct" selectortype="Products" widthatdataselector="360">
                                        <input name="primary_product_id" type="hidden" id="productId" value="<%=thisProduct!=null?thisProduct.id.ToString():"" %>"><nobr><span id="" style="display:inline-block;">
                                            <input name="" type="text" id="productIdHidden" class="txtBlack8Class"  style="width:374px;" value="<%=thisProduct!=null?thisProduct.name:"" %>"></span>&nbsp;
                                            <a href="#" id="" class="DataSelectorLinkIcon" ><img id="" src="" align="top" border="0" style="cursor:pointer;"></a></nobr>
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
                                            <input name="promotion_name" type="text" id="" class="txtBlack8Class" value="<%=tempOppo!=null?tempOppo.promotion_name:"" %>" ></span>
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
                                            <select name="" id="" class="txtBlack8Class">
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
                                        <input id="ckOppoUseQuote" type="checkbox" name="ckOppoUseQuote" style="vertical-align: middle;"/>
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
                                                            <input name="one_time_revenue" type="text" id="one_time_revenue" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.one_time_revenue!=null?((decimal)tempOppo.one_time_revenue).ToString("#0.00"):"" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                     一次性成本
									
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_oneTimeCost" class="oppNumber2">
                                                            <input name="one_time_cost" type="text" id="one_time_cost" class="txtBlack8Class  Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.one_time_cost!=null?((decimal)tempOppo.one_time_cost).ToString("#0.00"):"" %>" /></span>
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
                                                            <input name="monthly_revenue" type="text" id="monthly_revenue" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.monthly_revenue!=null?((decimal)tempOppo.monthly_revenue).ToString("#0.00"):"" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        月度成本
									
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_monthlyCost" class="oppNumber2">
                                                            <input name="monthly_cost" type="text" id="monthly_cost" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.monthly_cost!=null?((decimal)tempOppo.monthly_cost).ToString("#0.00"):"" %>" /></span>
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
                                                            <input name="quarterly_revenue" type="text" id="quarterly_revenue" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.quarterly_revenue!=null?((decimal)tempOppo.quarterly_revenue).ToString("#0.00"):"" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        季度成本
                                                    </div>
                                                    <div>
                                                        <span id="" class="oppNumber2">
                                                            <input name="quarterly_cost" type="text" id="quarterly_cost" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.quarterly_cost!=null?((decimal)tempOppo.quarterly_cost).ToString("#0.00"):"" %>" /></span>
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
                                                            <input name="semi_annual_revenue" type="text" id="semi_annual_revenue" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.semi_annual_revenue!=null?((decimal)tempOppo.semi_annual_revenue).ToString("#0.00"):"" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        半年成本
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_semiAnnualCost" class="oppNumber2">
                                                            <input name="semi_annual_cost" type="text" id="semi_annual_cost" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.semi_annual_cost!=null?((decimal)tempOppo.semi_annual_cost).ToString("#0.00"):"" %>" /></span>
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
                                                            <input name="yearly_revenue" type="text" id="yearly_revenue" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.yearly_revenue!=null?((decimal)tempOppo.yearly_revenue).ToString("#0.00"):"" %>" /></span>
                                                    </div>
                                                </td>
                                                <td class="inputLabel2">
                                                    <div class="FieldLabel">
                                                        年成本
                                                    </div>
                                                    <div>
                                                        <span id="EditControlFormOpportunityEntryFavEditor.ascx_yearlyCost" class="oppNumber2">
                                                           <input name="yearly_cost" type="text" id="yearly_cost" class="txtBlack8Class Calculation ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.yearly_cost!=null?((decimal)tempOppo.yearly_cost).ToString("#0.00"):"" %>" /></span>
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
                                    <span id="" class="FieldLabel" ><span class="txtBlack8Class">
                                        <input id="ckOppoSpreadValue" type="checkbox" name="ckOppoSpreadValue" style="vertical-align: middle;" />
                                        <label style="vertical-align: middle;">总计费时长</label></span></span>
                                    &nbsp;
			<span id="" style="display: inline-block;">
                <input name="number_months_for_estimating_total_profit" type="text" value="1" maxlength="4" id="number_months_for_estimating_total_profit" class="txtBlack8Class"  style="height: 22px; width: 40px; text-align: right;" /></span>&nbsp;
			<span id="" style="display:inline-block;">
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
                                            <input name="ext1" type="text" id="ext1" class="txtBlack8Class ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.semi_annual_cost!=null?((decimal)tempOppo.semi_annual_cost).ToString("#0.00"):"" %>" /></span>
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
                                        <span  class="CurrencyStyle">
                                            <input name="ext2" type="text" id="ext2" class="txtBlack8Class ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.ext2!=null?((decimal)tempOppo.ext2).ToString("#0.00"):"" %>" /></span>
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
                                        <span  class="CurrencyStyle">
                                           <input name="ext3" type="text" id="ext3" class="txtBlack8Class ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.ext3!=null?((decimal)tempOppo.ext3).ToString("#0.00"):"" %>" /></span>
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
                                            <input name="ext4" type="text" id="ext4" class="txtBlack8Class ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.ext4!=null?((decimal)tempOppo.ext4).ToString("#0.00"):"" %>" /></span>
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
                                            <input name="ext5" type="text" id="ext5" class="txtBlack8Class ToDec2"  style="text-align: right;" value="<%=tempOppo!=null&&tempOppo.ext5!=null?((decimal)tempOppo.ext5).ToString("#0.00"):"" %>" /></span>
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
                            <tr>
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span  class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" />
                                        <label style="vertical-align: middle;">抄送给我</label></span></span>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td class="input CheckboxPadding">
                                    <span id="" class="FieldLabel"><span class="txtBlack8Class">
                                        <input id="" type="checkbox" name="" style="vertical-align: middle;" /><label style="vertical-align: middle;">客户经理</label></span></span>
                                </td>
                            </tr>
                            <tr class="ExtraPaddingInputRow">
                                <td></td>
                                <td class="inputLabel">
                                    <div class="FieldLabel">
                                        <span class="lblNormalClass" style="font-weight: bold;">其他邮箱</span>
                                    </div>
                                    <div>
                                        <span id="" class="editDD" style="display: inline-block;">
                                            <input name="" type="text" maxlength="2000" id="" class="txtBlack8Class" style="width: 360px;" /></span>
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
                                            <select name="" id="" class="txtBlack8Class">
                                                <option selected="selected" value=""></option>
                                                

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
                                        <textarea name="" id="" rows="3" cols="67" class="oppText2" style="resize: vertical;width:374px;"></textarea>
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
<script>
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
</script>
<!--商机JS -->
<script>
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

</script>
