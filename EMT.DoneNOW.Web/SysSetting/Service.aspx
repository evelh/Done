<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Service.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.Service" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title><%if (isAdd) { %>新增<%} else { %>编辑<%} %>服务</title>
    <style>
        input{width:180px;}
    </style>
</head>
<body style="overflow:auto;">
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1"><%if (isAdd) { %>新增<%} else { %>编辑<%} %>服务</span>
                </div>
            </div>
            <div class="ButtonContainer header-title" style="margin:0;">
                <ul id="btn">
                    <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input type="button" value="保存并关闭" style="width:68px;" />
                    </li>
                </ul>
            </div>
            <div class="DivSection" style="border: none; padding-left: 0;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="30%" class="FieldLabels">名称<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="name" name="name" <%if (service != null) { %> value="<%=service.name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">描述
                                <div>
                                    <input type="text" name="description" <%if (service != null) { %> value="<%=service.name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">发票描述
                                <div>
                                    <input type="text" name="invoice_description" <%if (service != null) { %> value="<%=service.name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">SLA
                                <div>
                                    <select id="sla_id" name="sla_id" style="width:194px;">
                                        <option></option>
                                        <%foreach (var sla in slaList) { %>
                                        <option value="<%=sla.id %>" <%if (service != null && service.sla_id != null && service.sla_id == sla.id) { %> selected="selected" <%} %> ><%=sla.name %></option>
                                        <%} %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">供应商
                                <div>
                                    <input type="text" id="vendorSelect" disabled="disabled" <%if (service != null && service.vendor_account_id != null) { %> value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)service.vendor_account_id).name %>" <%} %> />
                                    <input type="hidden" id="vendorSelectHidden" name="vendor_account_id" <%if (service != null && service.vendor_account_id != null) { %> value="<%=service.vendor_account_id %>" <%} %> />
                                    <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VENDOR_CALLBACK %>&field=vendorSelect', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle;cursor: pointer;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">周期类型<span class="errorSmall">*</span>
                                <div>
                                    <select id="period_type_id" name="period_type_id" style="width:194px;">
                                        <%foreach (var period in periodType) { %>
                                        <option value="<%=period.val %>" <%if ((service!=null&&period.val.Equals(service.period_type_id.ToString()))||(service==null&&period.val.Equals(((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH).ToString()))){%> selected="selected"<% } %>><%=period.show %></option>
                                        <%}%>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">单位成本
                                <div>
                                    <input type="text" id="unit_cost" name="unit_cost" <%if (service != null) { %> value="<%=service.unit_cost %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">加价%
                                <div>
                                    <input type="text" id="markup" disabled="disabled" <%if (service != null && service.unit_cost != null && service.unit_cost != 0 && service.unit_price != null) { %> value="<%=decimal.Round((decimal)(service.unit_price / service.unit_cost - 1) * 100, 2) %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">单元价格<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="unit_price" name="unit_price" <%if (service != null) { %> value="<%=service.unit_price %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">计费代码<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="billCode" disabled="disabled" <%if (service != null) { %> value="<%=new EMT.DoneNOW.DAL.d_cost_code_dal().FindById(service.cost_code_id).name %>" <%} %> />
                                    <input type="hidden" id="billCodeHidden" name="cost_code_id" <%if (service != null) { %> value="<%=service.cost_code_id %>" <%} %> />
                                    <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=billCode&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle;cursor: pointer;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">
                                <div>
                                    <input type="checkbox" name="active" <%if (isAdd || service.is_active == 1) { %> checked="checked" <%} %> style="width:15px;height:15px;" />
                                    激活
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/common.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        $("#saveClose").click(function () {
            if ($("#name").val() == "") {
                LayerMsg("请输入名称！");
                return;
            }
            if ($("#unit_price").val() == "") {
                LayerMsg("请输入单价！");
                return;
            }
            if ($("#billCodeHidden").val() == "") {
                LayerMsg("请选择计费代码！");
                return;
            }
            $("#form1").submit();
        });
        $("#unit_cost").change(function () {
            calcMarkup();
        })
        $("#unit_price").change(function () {
            calcMarkup();
        })
        function calcMarkup() {
            if ($("#unit_price").val() == "" || $("#unit_cost").val() == "") {
                $("#markup").val("");
                return;
            }
            var price = parseFloat($("#unit_price").val());
            var cost = parseFloat($("#unit_cost").val());
            if (cost == 0) {
                $("#markup").val("");
            } else {
                var mkp = toDecimal2((price / cost - 1) * 100);
                $("#markup").val(mkp + "%");
            }
        }
    </script>
</body>
</html>
