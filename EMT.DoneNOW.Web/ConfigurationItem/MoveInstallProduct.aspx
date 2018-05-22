<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MoveInstallProduct.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.MoveInstallProduct" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>移动配置项</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">移动配置项</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="Move()">移动</li>

                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>取消</li>
            </ul>
        </div>
        <div class="PageLevelInstruction">
            <span>选择此配置项的目标公司。将为该公司创建配置项的副本，并且原始配置项将被禁用。 .</span>
        </div>
        <div class="sectionContainer">
            <div>
                <div class="labelText">
                    客户<span class="AsteriskLabel">*</span>
                </div>
                <div class="data">
                    <span id="ctl00_mainContent_accountSelector" class="dataSelector">
                        <div id="" class="dataSelectorUpperPanel">
                            <div id="" class="visible">
                                <input name="" type="text" id="accountId" class="dataSelectorTextBox dataSelectorAutoCompleteTextBox" /><a onclick="" id="" class="Button DataSelector IconOnly NormalState" ><span><span class="Icon"></span><span class="Text"></span></span></a>
                            </div>
                            <input type="hidden" name="" id="accountIdHidden" />
                            
                        </div>
                        <span id="ctl00_mainContent_accountSelector_PopupClientCommand"></span></span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        var insProId = '<%=Request.QueryString["InsProId"] %>';
        if (insProId == "") {
            LayerMsg("未获取到配置项信息");
            setTimeout(function () { window.close(); }, 800)
        }
    })

    function Move() {
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden == "") {
            LayerMsg("请通过查找带回选择客户！");
            return;
        }
    }

    function AccountCallBack(){
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUB_COMPANY_CALLBACK %>&field=accountId", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
</script>
