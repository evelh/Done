<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaxRateTaxManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TaxRateTaxManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>分税信息</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %>分税信息</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="content clear">
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                             <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">名称</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="tax_name" name="tax_name" style="width: 220px;" maxlength="11" value="<%=thisCateTax?.tax_name %>" />
                                        </div>
                                    </td>
                                </tr>
                             <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">税率</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="tax_rate" name="tax_rate" style="width: 220px;" maxlength="11" value="<%=((thisCateTax?.tax_rate)??0).ToString("#0.0000") %>" />
                                        </div>
                                    </td>
                                </tr>
                             <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left: 15px;">排序号</span><span style="color: red;"></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" id="sort_order" name="sort_order" style="width: 220px;" maxlength="5" value="<%=(thisCateTax?.sort_order) %>" />
                                        </div>
                                    </td>
                                </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>

    $("#save_close").click(function () {
        var tax_name = $("#tax_name").val();
        if (tax_name == "") {
            LayerMsg("请填写名称");
            return false;
        }
        var isRepeat = "";

        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=CheckRegionCateTax&regionCateId=<%=thisCate?.id %>&name=" + tax_name + "&id=<%=thisCateTax?.id %>",
            dataType: "json",
            async: false,
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        });
        if (isRepeat == "1") {
            LayerMsg("该名称已存在");
            return false;
        }

        return true;
     })
</script>
    
