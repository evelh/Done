<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExecutiveSummarySearch.aspx.cs" Inherits="EMT.DoneNOW.Web.Reports.ExecutiveSummarySearch" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
    <style>
        .content input[type='text'] {
            height: 25px;
        }
        .content input[type='radio'] {
            height: 15px;
            width: 15px;
        }
        select{
            width:220px;
        }
        .content input{
            margin-left:0px;
        }
        .content select{
            margin-left:0px;
               width:220px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
      <%--  <div class="TitleBar">
            <div class="Title">
                <span class="text1">执行汇总表</span>
                <a href="###" class="help"></a>
            </div>
        </div>--%>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="run" runat="server" Text="运行报告" BorderStyle="None" OnClick="run_Click" />

                </li>
                <li onclick="Reset();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="content clear">
                <div class="information clear">
                    <div style="padding-left:20px;">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels">报表周期<span style="color: red;">*</span>
                                        <div style="margin-left:10px;">
                                            <span><span style="float: left;">开始时间：</span><span><input type="text" id="startDate" name="startDate" onclick="WdatePicker()" style="width: 100px;" value="<%=DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd") %>" /></span></span>
                                            <span style="margin-left: 10px;"><span style="float: left;">结束时间：</span><span><input type="text" style="width: 100px;"  id="endDate" name="endDate" onclick="WdatePicker()" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" /></span></span>
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                    <td width="30%" class="FieldLabels">客户经理
                                        <div>
                                          <select id="accManId" name="accManId">
                                              <option></option>
                                              <% if (accManList != null && accManList.Count > 0) {
                                                      foreach (var accMan in accManList)
                                                      {%>
                                              <option value="<%=accMan.id %>"><%=accMan.name %></option>
                                                    <%  }
                                                  } %>
                                          </select>
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                    <td width="30%" class="FieldLabels">地域名称
                                        <div>
                                          <select id="terrId" name="terrId">
                                              <option></option>
                                              <% if (terrList != null && terrList.Count > 0) {
                                                      foreach (var terr in terrList)
                                                      {%>
                                              <option value="<%=terr.id %>"><%=terr.name %></option>
                                                    <%  }
                                                  } %>
                                          </select>
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                    <td width="30%" class="FieldLabels">客户<span style="color: red;">*</span>
                                        <input id="accountId" type="hidden"/>
                                        <input id="accountIdHidden" name="accountIdHidden" type="hidden"/>
                                        <div style="height:15px;"><input type="text" disabled="disabled" style="width:208px;"/> <img src="../Images/data-selector.png" style="width:15px;height:15px;float:left;margin-left:5px;" onclick="AccountCallBack()"/></div>
                                        <br />
                                        <div> 
                                          <select id="accountSelect" multiple="multiple" style="height:150px;">
                                          </select>
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                    <td width="30%" class="FieldLabels">
                                       显示收入按照：
                                        <div>
                                            <span><span style="float: left;">合同名称：</span><span><input type="radio" name="displayType" style="width: 12px;"  value="name" checked="checked"/></span></span>
                                            <span style="margin-left: 10px;"><span style="float: left;margin-left:20px;">合同类型：</span><span><input type="radio" name="displayType" style="width: 12px;"  value="type" /></span></span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
   
    function AccountCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&muilt=1&callBack=GetCompany", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetCompany() {
        var accountId = $("#accountIdHidden").val();
        var html = "";
        if (accountId != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CompanyAjax.ashx?act=GetAccountByIds&ids=" + accountId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#accountSelect").html(html);
        $("#accountSelect option").dblclick(function () {
            RemoveAccount(this);
        })

    }
    function RemoveAccount(val) {
        $(val).remove();
        var ids = "";
        $("#accountSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#accountIdHidden").val(ids);
    }

    $("#run").click(function () {
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        if (startDate == "") {
            LayerMsg("请填写开始时间！");
            return false;
        }
        if (endDate == "") {
            LayerMsg("请填写结束时间！");
            return false;
        }
        var accIds = $("#accountIdHidden").val();

        if (accIds == "") {
            LayerMsg("请选择相关客户！");
            return false;
        }

        return true;
    })

</script>
