﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RelatiobContract.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.RelatiobContract" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>关联合同</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/Roles.css" />
    <style>
        .Edit {
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">关联合同</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0" onclick="javascript:window.close();">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div style="margin: 0 10px 12px 10px; padding-bottom: 0;">
            <div class="lblNormalClass" style="font-weight: normal;">
                请选择覆盖此配置项的服务或服务包:
            </div>
        </div>
        <!--内容-->
        <div class="DivSection" style="width: 622px;">
            <table border="0">
                <tbody>
                    <tr>
                        <td>
                            <span class="FieldLabels" style="font-weight: bold;">配置项名称:</span>
                            <div>
                                <%
                                    var product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(iProduct.product_id);
                                %>
                                <span class="lblNormalClass" style="font-weight: normal;"><%=product.name %></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="FieldLabels" style="font-weight: bold;">序列号:</span>
                            <div>
                                <span class="lblNormalClass" style="font-weight: normal;"><%=iProduct.serial_number %></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="FieldLabels" style="font-weight: bold;">安装日期:</span>
                            <div>
                                <span class="lblNormalClass" style="font-weight: normal;"><%=iProduct.start_date==null?"":((DateTime)iProduct.start_date).ToString("yyyy-MM-dd") %></span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <div class="GridContainer" style="height: auto;">
                <div style="overflow: auto; z-index: 0; width: 683px;">
                    <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                        <tbody>
                            <tr class="dataGridHeader">
                                <td>
                                    <span>服务/包名称</span>
                                </td>
                                <td>描述</td>
                                <td align="right">配置项按照日期可用单元数
                                </td>
                                <td align="right">全部单元
                                </td>
                            </tr>
                            <%if (serviceList != null && serviceList.Count > 0)
                                {
                                    foreach (var item in serviceList)
                                    {
                                        var service = new EMT.DoneNOW.DAL.ivt_service_dal().FindNoDeleteById(item.object_id);
                                        var service_bundle = new EMT.DoneNOW.DAL.ivt_service_bundle_dal().FindNoDeleteById(item.object_id);
                                        if (service == null && service_bundle == null)
                                        {
                                            continue;
                                        }
                                        var existCount = insBLL.GetExistInsServiceCount(contract.id, item.object_id);
                                        var diffCount = (item.quantity - existCount) < 0 ? 0 : (item.quantity - existCount);
                            %>
                            <tr class="dataGridBody" onclick="Choose('<%=item.object_id %>','<%=diffCount %>','<%=item.id %>')">
                                <%

                                %>
                                <td>
                                    <span><%=service!=null?service.name:service_bundle.name %></span>
                                </td>
                                <td>
                                    <span><%=service!=null?service.description:service_bundle.description %></span>
                                </td>
                                <td align="right">
                                    <span><%=diffCount %></span>
                                </td>
                                <td align="right">
                                    <span><%=item.quantity %></span>
                                </td>
                            </tr>
                            <%}
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    function Choose(serviceId, diffCount, conSerId) {
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=RelationIP&InsProId=<%=iProduct.id %>&contract_id=<%=contract.id %>&service_id=" + serviceId,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert('关联成功');
                } else if (data == "False") {
                    alert('关联失败');
                }
                self.opener.parent.location.reload();
                if (diffCount == 0) {
                    window.open("ContractServiceCompliance?contractId=<%=contract.id %>&serviceId=" + conSerId + "&insProId=<%=iProduct.id %>", "_blank", "left=200,top=200,width=900,height=750", false);
                }
                window.close();
            }
        })
    }
</script>


