<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewActivity.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.ViewActivity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>查看<%=isTodo?"待办":"备注" %></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">查看<%=isTodo?"待办":"备注" %>-<%=actType!=null?actType.name:"" %><%=account!=null?$"({account.name})":"" %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="DivSection" style="border: none; padding-left: 0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="50%" class="FieldLabels">创建人
                        <div>
                            <%=createUser!=null?createUser.name:"" %>
                        </div>
                        </td>
                         <td width="50%" class="FieldLabels">活动类型
                        <div>
                          <%=actType!=null?actType.name:"" %>
                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">创建日期
                        <div>
                            <%=thisActivity==null?"":EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisActivity.create_time).ToString("yyyy-MM-dd HH:mm") %>
                        </div>
                        </td>
                         <td width="50%" class="FieldLabels">指派给
                        <div>
                                <%=assignUser!=null?assignUser.name:"" %>
                        </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <span><%=thisActivity!=null?thisActivity.description:"" %></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {

    })
</script>
