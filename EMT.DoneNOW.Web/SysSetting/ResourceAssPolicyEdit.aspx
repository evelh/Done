<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResourceAssPolicyEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ResourceAssPolicyEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>员工关联休假策略</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <div class="header">员工关联休假策略</div>
    <div class="header-title" style="min-width: 400px;">
        <ul>
            <li id="Save"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div>
            <table>
                <tr>
                    <td><label>休假策略<span style="color: red;">*</span></label></td>
                    <td>
                        <select id="plc" name="plc" <%if (plcAss != null) { %> disabled="disabled" <%} %> style="float:left;width:172px;" >
                            <%foreach (var plc in policyList) { %>
                            <option value="<%=plc.id %>" <%if ((plcAss == null && plc.is_default == 1) || (plcAss != null && plcAss.timeoff_policy_id == plc.id)) { %> selected="selected" <%} %> ><%=plc.name %></option>
                            <%} %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><label>生效时间<span style="color: red;">*</span></label></td>
                    <td><input type="text" id="effDate" name="effDate" onclick="WdatePicker()" class="Wdate" <%if (plcAss != null) { %> value="<%=plcAss.effective_date.ToString("yyyy-MM-dd") %>" <%} %> style="float:left;" /></td>
                </tr>
            </table>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $("#Save").click(function () {
            if ($("#effDate").val() == "") {
                LayerMsg("请输入生效时间");
                return;
            }
            LayerLoad();
            $("#form1").submit();
        })
    </script>
</body>
</html>
