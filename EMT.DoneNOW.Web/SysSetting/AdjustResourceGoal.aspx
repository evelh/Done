<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustResourceGoal.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.AdjustResourceGoal" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>员工周计费目标设置</title>
</head>
<body>
    <form id="form1" runat="server">
                <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">员工周计费目标设置</span>
            <a href="###" class="help"></a>
        </div>
    </div>
     <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                保存并关闭
            </li>
            <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                取消
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                       员工姓名
                        <span class="errorSmall"></span>
                        <div>
                           <label><%=thisRes!=null?thisRes.name:"" %></label>
                        </div>
                    </td>
                </tr>
                <tr >
                    <td width="30%" class="FieldLabels">
                       工作时长总计
                        <div>
                             <label><%=resAva!=null&&resAva.total!=null?((decimal)resAva.total).ToString("#0.00"):"" %></label>
                        </div>
                    </td>
                </tr>
                
                <tr>
                    <td width="30%" class="FieldLabels">
                        每周计费时间目标
                        <div>
                            <input type="text" id="goal" name="goal" style="width:220px;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" value="<%=resAva!=null&&resAva.goal!=null?((decimal)resAva.goal).ToString("#0.00"):"" %>" class="ToDec2" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
        
      
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })
    $("#SaveClose").click(function () {
        var goal = $("#goal").val();
        if (goal == "") {
            goal = 0;
        }
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=ChangeResourceGoal&id=<%=resAva!=null?resAva.id.ToString():"" %>&goal=" + goal,
            dataType: 'json',
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功");
                }
                setTimeout(function () { window.close(); }, 800);
            },
        });
    })
</script>
