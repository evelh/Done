<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractServiceCompliance.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.ContractServiceCompliance" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/style.css" rel="stylesheet" />
    <title>重复合同服务规范</title>
    <style>
        body{
            background: white;
    left: 0;
    position: relative;
    top: 0;
    overflow: visible;
    height: 100%;
    font-size: 10pt;
    left: 0;
    margin: 0;
    min-width:600px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header" style="padding-left: 10px;">重复合同服务规范</div>
        <div class="pageInstructions" style="padding-left: 10px;">
            所选服务/服务包中没有足够的可用单元来覆盖此配置项目。请选择下面的一个选项。
        </div>
        <div class="neweditsubsection"  style="padding-left: 10px;margin-top:15px;">
            <table cellspacing="0" border="0" style="width: 98%; border-collapse: collapse; margin: 0px 3px 10px 0px;">
                <tbody>
                    <tr>
                        <td align="left" style="width: 50px; padding-left: 10px;"><span class="fieldLabel" style="font-weight: bold;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">合同 </font></font></span></td>
                        <td align="left" style="width: 650px; padding-left: 10px;"><span class="lblNormalClass" style="font-weight: normal;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;"><%=contract.name %>（<%=(contract.start_date).ToString("yyyy-MM-dd") %> - <%=(contract.end_date).ToString("yyyy-MM-dd") %>）</font></font></span></td>
                    </tr>
                    <tr>
                        <td align="left" style="width: 50px; padding-left: 10px; padding-top: 10px;"><span class="fieldLabel" style="font-weight: bold;"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">服务 </font></font></span></td>
                        <td style="width: 650px; padding-left: 10px; padding-top: 10px;"><span class="lblNormalClass" style="font-weight: normal;"></span></td>
                    </tr>
                </tbody>
            </table>
            <table cellspacing="0" border="0" style="width: 98%; border-collapse: collapse; margin: 3px;">
                <tbody>
                    <tr>
                        <td>
                            <input id="_ctl14_0" type="radio" name="_ctl14" value="AjastService" checked="checked" /><label for="_ctl14_0"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">调整此服务/服务包添加一个单元，其有效期为 </font></font></label>
                            <input type="text" id="ChooseDate" onclick="WdatePicker()"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input id="_ctl14_1" type="radio" name="_ctl14" value="SetCompliance" /><label for="_ctl14_1"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">将合同设置为不一致</font></font></label></td>
                    </tr>
                    <tr>
                        <td>
                            <input id="_ctl14_2" type="radio" name="_ctl14" value="Close /><label for="_ctl14_2"><font style="vertical-align: inherit;"><font style="vertical-align: inherit;">忽略</font></font></label></td>
                    </tr>
                    <tr>
                        <td style="text-align:center;vertical-align:middle;">
                            <div onclick="DealEvent()" style="width: 45px;height: 28px;margin-left: 49%;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);padding-top: 10px;"> <span style="margin-top: 3px;position: absolute;margin-left: -11px;">确认</span></div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function DealEvent() {
        var eventType = $('input[type=radio]:checked').eq(0).val();
        if (eventType == "AjastService") {
            var ChooseDate = $("#ChooseDate").val();
            if (ChooseDate == "") {
                LayerMsg("请选择相关日期！");
                return;
            }
               <%var endTime = new EMT.DoneNOW.BLL.ContractServiceBLL().GetServiceMaxApproveTime(contractService.id);
      if (endTime != null) {%>
            if (compareTime('<%=((DateTime)endTime).ToString("yyyy-MM-dd") %>', ChooseDate)) {
                LayerMsg("结束时间不能早于已审批并提交的服务结束时间");
                return;
            }
      <% } %>
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=AjustServiceDate&contractId=<%=contract.id %>&serviceId=<%=contractService.id %>&chooseDate=" + ChooseDate,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("调整成功！");
                    }
                    else {
                        LayerMsg("调整失败！");
                    }
                    setTimeout(function () { window.close(); }, 800)
                },
             });

        }
        else if (eventType == "SetCompliance") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=SetContractCompliance&contract_id=<%=contract.id %>",
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("设置成功！");
                    }
                    else {
                        LayerMsg("设置失败！");
                    }
                    setTimeout(function () { window.close();},800)
                },
             });
        }
        else {
            window.close();
        }
    }
    
</script>
