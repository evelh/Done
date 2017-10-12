<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskLibrary.aspx.cs" Inherits="EMT.DoneNOW.Web.TaskLibrary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <style>
        .header-title {
            width: 100%;
            margin: 10px;
            width: auto;
            height: 30px;
        }

            .header-title ul li {
                position: relative;
                height: 30px;
                line-height: 30px;
                padding: 0 10px;
                float: left;
                margin-right: 10px;
                border: 1px solid #CCCCCC;
                cursor: pointer;
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            }

                .header-title ul li input {
                    height: 28px;
                    line-height: 28px;
                }

                .header-title ul li:hover ul {
                    display: block;
                }

                .header-title ul li .icon-1 {
                    width: 16px;
                    height: 16px;
                    display: block;
                    float: left;
                    margin-top: 7px;
                    margin-right: 5px;
                }

                .header-title ul li ul {
                    display: none;
                    position: absolute;
                    left: -1px;
                    top: 28px;
                    border: 1px solid #CCCCCC;
                    background: #F5F5F5;
                    width: 160px;
                    padding: 10px 0;
                    z-index: 99;
                }

                    .header-title ul li ul li {
                        float: none;
                        border: none;
                        background: #F5F5F5;
                        height: 28px;
                        line-height: 28px;
                    }

                .header-title ul li input {
                    outline: none;
                    border: none;
                    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                }

        .icon-1 {
            width: 16px;
            height: 16px;
            display: block;
            float: left;
            margin-top: 7px;
            margin-right: 5px;
        }
    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">任务库管理</span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <div class="ButtonContainer header-title">
                <ul id="btn">
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click" />
                    </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancel" OnClientClick="window.close();" runat="server" Text="取消" BorderStyle="None" />
                    </li>
                </ul>
            </div>
             <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        类别
                        <div>
                            <select name="" style="width:400px;">
                                <option value="0">(Select Category)</option>
                                <option value="1">deployment</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        标题
                        <span class="errorSmall">*</span>
                        <div>
                            <input type="text" style="width:387px;" value="test__Create DNS records for mail flow">
                        </div>
                    </td> 
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        详细
                        <div>
                            <textarea style="width:387px;height:125px;resize: vertical;" rows="8">Create DNS records at your DNS hosting provider that route email for your domain to Office 365, set up Autodiscover for Exchange Online, and so on. For more information about creating DNS records for other servicesYou can add multiple domains to Office 365, but you can’t use single-label domains. They are DNS names that don’t contain a suffix, such as .com, .corp, .net, or .org. For example: Not supported: contosoSupported: contoso.com For more information about adding multiple domains, see Microsoft Online Services compatibility with single-label domains, with disjoint namespaces, and with discontiguous namespaces.</textarea>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        估计时间
                        <div>
                            <input type="text" style="width: 80px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        部门
                        <div>
                            <select name="" style="width:400px;">
                                <option value="0">(Select a Department)</option>
                                <option value="1">Administration</option>
                                <option value="2">Engineering-SH</option>
                                <option value="3">Sales/Marking--SH</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        工作类型
                        <div>
                            <select name="" style="width:400px;">
                                <option value="0">----------</option>
                                <option value="1">Emergency/After Hours Support</option>
                                <option value="1">Emergency/After Hours Support</option>
                                <option value="1">Emergency/After Hours Support</option>
                                <option value="1">Emergency/After Hours Support</option>
                            </select>
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
