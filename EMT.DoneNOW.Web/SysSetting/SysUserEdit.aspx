<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysUserEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.SysUserEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/sysset_user.css" rel="stylesheet" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title>系统管理</title>
</head>
<body>
    <form id="form1" runat="server" method="post" enctype="multipart/form-data">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">系统管理</span>
                <span class="text2">当前用户：<asp:Label ID="username" runat="server" Text="用户名"></asp:Label></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮部分-->
        <div class="ButtonBar">
            <ul>
                <li class="LiButton" id="f1">
                    <img src="../Images/save.png" alt="" class="ButtonImg" />
                    <%-- <span class="Text">保存 & 克隆</span>--%>
                    <asp:Button ID="Save_Clone" runat="server" Text="保存并关闭" BorderStyle="None" class="Text" OnClick="Save_Cloes_Click" />
                </li>
                <li class="LiButton" id="f2">
                    <img src="../Images/save.png" alt="" class="ButtonImg" />
                    <%-- <span class="Text">保存</span>--%>
                    <asp:Button ID="Save" runat="server" Text="保存" BorderStyle="None" class="Text" OnClick="Save_Click" />
                </li>
                <li class="LiButton" id="f3">
                    <img src="../Images/save.png" alt="" class="ButtonImg" />
                    <%--<span class="Text">保存 & 复制</span>--%>
                    <asp:Button ID="Save_copy" runat="server" Text="保存并复制" BorderStyle="None" class="Text" OnClick="Save_copy_Click" />
                </li>
                <li class="LiButton" id="f4">
                    <img src="../Images/cancel.png" alt="" class="ButtonImg" />
                    <%-- <span class="Text">取消</span>--%>
                    <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" class="Text" OnClick="Cancel_Click" />
                </li>
                <span class="FieldLevelInstruction">包含所需字段<span style="color: red;">*</span>选项卡</span>
            </ul>
        </div>
        <!--选择框-->
        <div class="TabCtrl" style="display: inline-block; width: 100%;">
            <div style="border-style: None; height: 600px; width: 100%;">
                <div style="border-width: 0px; border-bottom: 1px solid #adadad; height: 25px; overflow: HIDDEN;">
                    <table class="ATTabControlHiddenTable" style="height: 26px; border-collapse: collapse; position: RELATIVE;">
                        <tbody>
                            <tr style="height: 25px;"></tr>
                        </tbody>
                    </table>
                    <table class="ATTabControlVisibleTable" style="border-style: None; height: 26px; border-collapse: collapse; z-index: 100; position: RELATIVE; top: -26px;">
                        <tbody>
                            <tr class="ATTabControlTabRow" style="height: 26px;">
                                <td class="Selected" style="height: 100%;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;" id="tab1">常规
                                    <span style="color: red;">*</span>
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;" id="tab2">授权
                                    <span style="color: red;">*</span>
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">人力资源
                                    <span style="color: red;">*</span>
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">批准者
                                    <span style="color: red;">*</span>
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">协会
                                    <span style="color: red;">*</span>
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">技能
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">附件
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div style="height: 100%; width: 100%" class="C">
                    <div style="height: 100%; width: 100%;">
                        <div class="DivScrollingContainer Tab" style="padding-top: 10px;">
                            <div class="DivSection" style="margin-bottom: 8px;">
                                <table cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" style="width: 480px;">
                                                <table cellpadding="0" cellspacing="0">
                                                    <tbody>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">前缀</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="Prefix" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">姓<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="first_name" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="first_name"></asp:TextBox> 
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">名<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="last_name" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="last_name" ></asp:TextBox>                                                                       
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">标题</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="title" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="title"></asp:TextBox>                                                                       
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">后缀</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="NameSuffix" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">性别</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="Sex" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">主要位置<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="Position" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div style="padding-bottom: 0; margin-top: 5px; margin-left: 5px;">
                                                                    <!--添加主要位置-->
                                                                    <a href="##">
                                                                        <img src="../Images/add.png" alt="" /></a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td valign="top" align="left" width="210">                                              
                                                <img id="imgshow" src="<%=avatarPath %>" />
                        <a href="#" style="display: inline-block; width: 100px; height: 24px; position: relative; overflow: hidden;">点击修改头像
                            <input type="file" value="浏览" id="browsefile" name="browsefile" style="position: absolute; right: 0; top: 0; opacity: 0; filter: alpha(opacity=0);" />
                        </a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="DivSection">
                                <table cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" style="width: 480px;">
                                                <table cellpadding="0" cellspacing="0">
                                                    <tbody>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">办公室电话</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="office_phone" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 150px;" name="office_phone"></asp:TextBox>                                                                        
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="standard_entry_control" style="padding-left: 10px;">
                                                                <span class="lblNormalClass">延伸</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="TextBox1" runat="server"  class="txtBlack8Class" type="text" maxlength="50" style="width: 70px;"></asp:TextBox>                                                                        
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">家庭电话</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="home_phone" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 150px;" name="home_phone"></asp:TextBox>                                                                       
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">手机</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="mobile_phone" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 150px;" name="mobile_phone"></asp:TextBox>                                                                       
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">E-mail地址<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="email" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="email" ></asp:TextBox>                                                                     
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="standard_label" style="padding-left: 10px;">
                                                                <span class="lblNormalClass">E-mail类型<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="EmailType" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">E-mail地址1</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="email1" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="email1" ></asp:TextBox>                                                                        
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="standard_label" style="padding-left: 10px;">
                                                                <span class="lblNormalClass">E-mail类型1</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="EmailType1" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">E-mail地址2</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="email2" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="email2"></asp:TextBox>                                                                     
                                                                    </span>
                                                                </div>
                                                            </td>
                                                            <td class="standard_label" style="padding-left: 10px;">
                                                                <span class="lblNormalClass">E-mail类型2</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="EmailType2" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="DivSection">
                                <table cellpadding="0" cellspacing="0">
                                    <tbody>
                                        <tr>
                                            <td valign="top" style="width: 480px;">
                                                <table cellpadding="0" cellspacing="0">
                                                    <tbody>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">日期格式<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="DateFormat" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">时间格式<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="TimeFormat" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">数字格式<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="NumberFormat" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="height: 100%; width: 100%; display: none;" class="C">
                    <div style="height: 100%; width: 100%;">
                        <div class="DivScrollingContainer Tab" style="padding: 8px 8px 8px 0;">
                            <table cellpadding="0" cellspacing="0" style="width: 880px;">
                                <tbody>
                                    <tr>
                                        <td width="60%" valign="top" style="padding-right: 8px;">
                                            <div class="DivSectionWithHeader" style="margin-bottom: 8px;">
                                                <div class="HeaderRow">
                                                    <span class="lblNormalClass">资格证书</span>
                                                </div>
                                                <div class="Content">
                                                    <table cellpadding="0" cellspacing="0" style="margin-top: 8px;">
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">用户名<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="name" runat="server" type="text" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="name" ></asp:TextBox>
                                                                           </span>
                                                                        <span class="lblNormalClass">
                                                                            <asp:Label ID="www" runat="server" Text="@itcat.net.cn"></asp:Label></span>
                                                                    </div>                                                                    
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">请输入密码<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="password" runat="server" type="password" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="password"></asp:TextBox></span>
                                                                    </div>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">请确认密码<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="password2" runat="server" type="password" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="password2"></asp:TextBox>
                                                                            </span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div>
                                                                        <span>
                                                                            <span class="txtBlack8Class" style="margin-top: 5px">
                                                                                <asp:CheckBox ID="ACTIVE" runat="server" disabled="disabled" Style="vertical-align: middle;" Checked="True" />
                                                                                <label>激活</label>
                                                                            </span>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">权限等级<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:DropDownList ID="Security_Level" runat="server"></asp:DropDownList>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span>
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">
                                                                            <asp:CheckBox ID="can_edit_skills" runat="server" />
                                                                            <label>允许员工编辑技能</label>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span>
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">
                                                                            <asp:CheckBox ID="can_manage_kb_articles" runat="server" />
                                                                            <label>允许员工创建、编辑和删除知识库文章</label>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span>
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">
                                                                            <asp:CheckBox ID="allow_send_bulk_email" runat="server" />
                                                                            <label>允许员工群发邮件</label>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span style="padding-left: 17px;">
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">为了使员工能给联系人组群发邮件必须勾选
                                                                        <a href="###" style="color: #376597; text-decoration: none;">Terms and Conditions</a>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <div>
                                                                        <span>
                                                                            <span class="txtBlack8Class" style="margin-top: 5px">
                                                                               <asp:CheckBox ID="is_required_to_submit_timesheets" runat="server" />
                                                                                <label>不要求用户提交工时表</label>
                                                                            </span>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">外包权限<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:DropDownList ID="Outsource_Security" runat="server"></asp:DropDownList>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="40%" valign="top">
                                            <div class="DivSectionWithHeader" style="margin-bottom: 8px;">
                                                <div class="HeaderRow">
                                                    <span class="lblNormalClass">双因素认证</span>
                                                </div>
                                                <div class="Content">
                                                    <div class="lblNormalClass" style="padding: 0 0 10px 0;">
                                                        <span>
                                                            <span class="txtBlack8Class" style="margin-top: 5px">
                                                                <input type="checkbox" style="vertical-align: middle;">
                                                                <label>需要此资源的双因素认证 </label>
                                                            </span>
                                                        </span>
                                                    </div>
                                                    <div>
                                                        <div class="lblNormalClass" style="padding-bottom: 0;">
                                                            <span class="FieldLevelInstruction" style="font-weight: bold;">选择1 - authanvil</span><br>
                                                            <span class="FieldLevelInstruction">AuthAnvil offers a strong authentication platform to cover multiple assets (including
							Windows network, production devices and web-based software) with a single solution,
							allowing you to consolidate security management and token use. It also provides
							a source of new revenue by allowing you to manage strong authentication for client
							assets on the same platform.</span>
                                                            <p style="margin-bottom: 12px;">
                                                                <span class="FieldLevelInstruction">To learn more about AuthAnvil Two-Factor Authentication or sign up,</span>
                                                                <a href="##" style="color: #376597; text-decoration: none;">点击这里</a>
                                                            </p>
                                                        </div>
                                                        <div class="lblNormalClass" style="padding-bottom: 0; font-weight: bold;"><span>选择2 - authanvil</span></div>
                                                        <div class="lblNormalClass" style="padding-bottom: 0; font-weight: bold;">
                                                            <span class="FieldLevelInstruction" style="font-weight: bold;">选择3 - authanvil</span><br>
                                                            <span class="FieldLevelInstruction">Time-based one-time password</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div style="height: 100%; width: 100%; display: none;" class="C"></div>
                <div style="height: 100%; width: 100%; display: none;" class="C"></div>
                <div style="height: 100%; width: 100%; display: none;" class="C"></div>
                <div style="height: 100%; width: 100%; display: none;" class="C"></div>
                <div style="height: 100%; width: 100%; display: none;" class="C"></div>
            </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/sysset_users.js"></script>
        <script type="text/javascript">
            $("#tab1").click(function () {//点击常规

            });
            $("#tab2").click(function () {
                var firstname = $("#first_name").val();
                var lastname = $("#last_name");
                if (firstname == null || firstname == '') {
                    alert("无法跳转，请输入姓！");
                    return false;
                }
                if (lastname == null || lastname == '') {
                    alert("无法跳转，请输入名！");
                    return false;
                }
                var email = $("#email").val();
                if (email == null || email == '') {
                    alert("无法跳转，未填写邮件地址！");
                    return false;
                }
                if (!$("#email").val().match(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/)) {
                    alert("邮箱格式不正确");
                    return false;
                }
            });
            $("#Save").click(function () {
                var firstname = $("#first_name").val();
                var lastname = $("#last_name");
                if (firstname == null || firstname == '') {
                    alert("请输入姓后再进行保存！");
                    return false;
                }
                if (lastname == null || lastname == '') {
                    alert("请输入名后再进行保存！");
                    return false;
                }
                //if ($("#Position").val() == 0) {
                //    alert("请选择主要办公地址！");
                //    return false;
                //}
                var email = $("#email").val();
                if (email == null || email == '') {
                    alert("未填写邮件地址！");
                    return false;
                }
                if (!$("#email").val().match(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/)) {
                    alert("邮箱格式不正确");
                    return false;
                }
                if ($("#EmailType").val() == 0) {
                    alert("请选择邮件类型！");
                    return false;
                }
                if ($("#DateFormat").val == 0) {
                    alert("请选择日期类型！");
                    return false;
                }
                if ($("#NumberFormat").val == 0) {
                    alert("请选择数值类型！");
                    return false;
                }
                if ($("#name").val() == null || $("#name").val() == '')
                {
                    alert("请在常规选项卡输入用户名");
                    return false;
                }
                if ($("#password").val() == null || $("#password").val() == '') {
                    alert("请在常规选项卡输入密码");
                    return false;
                }
                if ($("#password2").val() == null || $("#password2").val() == '') {
                    alert("请在常规选项卡再次输入密码");
                    return false;
                }
                if ($("#Security_Level").val() == 0) {
                    alert("请输入权限等级");
                    return false;
                }
            });
            $("#password2").blur(function () {
                var ps1 = $("#password").val();
                if (ps1 == null | ps1 == '') {
                    alert("请先填写密码！");
                    return false;
                }
                if (ps1 != $("#password2").val()) {
                    alert("两次输入密码不相同，请确认后再输入！");
                }
            });
        </script>
    </form>
</body>
</html>
