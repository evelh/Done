<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MileageDefaults.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.MileageDefaults" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>里程默认值</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <style>
        img{
            width:20px;
            height:20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">里程默认值</span>
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
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="content clear">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="text" id="costCodeId" value="<%=thisCode!=null?thisCode.name:"" %>" />
                                            <input type="hidden" id="costCodeIdHidden" name="costCodeId" value="<%=thisCode!=null?thisCode.  id.ToString():"" %>" />
                                            <img src="../Images/data-selector.png" onclick="Callack()" style="width:20px;height:20px;float:left;margin-left:5px;"/>
                                        </div>
                                    </td>
                                </tr> 
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div style="padding-top:5px;">
                                            <input type="checkbox" id="isCk" style="margin-top: 0px;" name="isCk" disabled="disabled" />
                                            <span style="margin-left: 0px;">激活</span>
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
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function Callack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE %>&field=costCodeId&callBack=CheckMilestone", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function CheckMilestone() {
        var costCodeId = $("#costCodeIdHidden").val();
        if (costCodeId != "") {
            $("#isCk").prop("disabled", false);
        }
        else {
            $("#isCk").prop("disabled", true);
            $("#isCk").prop("checked", false);
        }
    }
</script>
