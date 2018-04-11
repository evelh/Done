<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysUserEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.SysUserEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/sysset_user.css" rel="stylesheet" />    
    <title>系统管理</title>
    <style>
        ul,ul li{margin: 0;padding: 0;}
@font-face {
	font-family:'Glyphicons Halflings';
	src: url(../fonts/glyphicons-halflings-regular.eot);
	src: url(../fonts/glyphicons-halflings-regular.svg);
	src: url(../fonts/glyphicons-halflings-regular.ttf);
	src: url(../fonts/glyphicons-halflings-regular.woff);
}
.header-title{width: 100%;margin:10px;width: auto;height: 30px;}
.header-title ul li{position: relative;height:30px;line-height:30px; padding: 0 10px;float: left;margin-right: 10px;border: 1px solid #CCCCCC;cursor:pointer;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);}
.header-title ul li input{height:28px;line-height:28px;}
.header-title ul li:hover ul{display: block;}
.header-title ul li .icon-1{width: 16px;height:16px;display: block;float: left;margin-top: 7px;margin-right: 5px;}
.header-title ul li ul{display: none; position:absolute; left: -1px;top: 28px;border: 1px solid #CCCCCC;background: #F5F5F5;width:160px;padding: 10px 0;z-index: 99;}
.header-title ul li ul li{float: none;border: none;background: #F5F5F5;height:28px;line-height:28px;}
.header-title ul li input{outline:none; border: none;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);}
.icon-1{width: 16px;height:16px;display: block;float: left;margin-top: 7px;margin-right: 5px;}
    </style>
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
       <div class="ButtonBar header-title">
            <ul id="btn">
                 <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="Save_Clone" OnClientClick="return save_deal()" runat="server" Text="保存并关闭" BorderStyle="None" class="Text" OnClick="Save_Cloes_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                    <asp:Button ID="Save" runat="server" OnClientClick="return save_deal()" Text="保存" BorderStyle="None" class="Text" OnClick="Save_Click" />
                </li>
                 <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                    <asp:Button ID="Save_copy" runat="server" OnClientClick="return save_deal()" Text="保存并复制" BorderStyle="None" class="Text" OnClick="Save_copy_Click" />
                </li>
                 <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" class="Text" OnClick="Cancel_Click" />
                </li>
                <%--<span class="FieldLevelInstruction">包含所需字段<span style="color: red;">*</span>选项卡</span>--%>
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
                                    </span>
                                </td>
                                <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">审批人
                                        <span style="color: red;">*</span>
                                    </span>
                                </td>
                              <td style="height: 100%; cursor: pointer;">
                                    <span class="ATTabControlTabLabel" style="position: relative; z-index: 900;">隶属
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
                                                       <%-- <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">前缀</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="Prefix" runat="server"></asp:DropDownList>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>--%>
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
                                                                <span class="lblNormalClass">姓名</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="resource_name" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="title" Visible="True" Enabled="False"></asp:TextBox>
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">头衔</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="title" runat="server" class="txtBlack8Class" type="text" maxlength="50" style="width: 218px;" name="title"></asp:TextBox>                                                                       
                                                                    </span>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="standard_label">
                                                                <span class="lblNormalClass">称谓</span>
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
                                                                <span class="lblNormalClass">主区域<span style="color: red;">*</span></span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:DropDownList ID="Position" runat="server"></asp:DropDownList>
                                                                    </span><!--添加主要位置-->
                                                                    <img src="../Images/add.png" onclick="alert('后期开发！');" /> 
                                                                </div> 
                                                            </td>                                                                 
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </td>
                                            <td valign="top" align="left" width="210">                                              
                                                <img id="imgshow" src="..<%=avatarPath %>" />
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
                                                           <%-- <td class="standard_entry_control" style="padding-left: 10px;">
                                                                <span class="lblNormalClass">延伸</span>
                                                                <div>
                                                                    <span style="display: inline-block">
                                                                        <asp:TextBox ID="TextBox1" runat="server"  class="txtBlack8Class" type="text" maxlength="50" style="width: 70px;"></asp:TextBox>                                                                        
                                                                    </span>
                                                                </div>
                                                            </td>--%>
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
                            <div class="DivSection" style="display:none">
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
                                                            <tr style="display:none;">
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">用户名<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="name" runat="server" type="text" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="name" ></asp:TextBox>
                                                                           </span>
                                                                        <%--<span class="lblNormalClass">
                                                                            <asp:Label ID="www" runat="server" Text="@itcat.net.cn"></asp:Label></span>--%>
                                                                    </div>                                                                    
                                                                </td>
                                                            </tr>
                                                                   <tr class="ButtonCollectionBase btn1"><td> <span class="ButtonCollectionBase btn1" style="height:27px;">
                                                                       <input type="button" value="修改密码" id="btn1" />           
                                                              </span></td></tr>
                                                            <tr class="xiugai">
                                                                <td colspan="2" class="xiugai">
                                                                    <span class="lblNormalClass xiugai">请输入密码<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="pass_word" runat="server" type="password" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="pass_word"></asp:TextBox></span>
                                                                    </div>
                                                                </td>
                                                            </tr>

                                                            <tr class="xiugai">
                                                                <td colspan="2">
                                                                    <span class="lblNormalClass">请确认密码<span style="color: red;">*</span></span>
                                                                    <div>
                                                                        <span>
                                                                            <asp:TextBox ID="pass_word2" runat="server" type="password" maxlength="32" class="txtBlack8Class" style="width: 150px;" name="pass_word2"></asp:TextBox>
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
                                                                            <asp:CheckBox ID="CanEditSkills" runat="server" />
                                                                            <label>允许员工编辑技能</label>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span>
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">
                                                                            <asp:CheckBox ID="CanManagekbarticles" runat="server" />
                                                                            <label>允许员工创建、编辑和删除知识库文章</label>
                                                                        </span>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">
                                                                    <span>
                                                                        <span class="txtBlack8Class" style="margin-top: 5px">
                                                                            <asp:CheckBox ID="AllowSendbulkemail" runat="server" />
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
                                                                               <asp:CheckBox ID="IsRequiredtosubmittimesheets" runat="server" />
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
                                        <td width="40%" valign="top" style="display:none">
                                            <div class="DivSectionWithHeader" style="margin-bottom: 8px;">
                                                <div class="HeaderRow">
                                                    <span class="lblNormalClass">双因素认证</span>
                                                </div>
                                                <div class="Content">
                                                    <div class="lblNormalClass" style="padding: 0 0 10px 0;">
                                                        <span>
                                                            <span class="txtBlack8Class" style="margin-top: 5px">
                                                                <input type="checkbox" style="vertical-align: middle;" />
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
                <div style="height: 100%; width: 100%; display: none;" class="C">
                    <div style="height:320px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">工时表审批人</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_TIME_SHEET %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceTimeSheet %>&con2673=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                    <div style="height:320px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">费用报表审批人</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_EXPENSE_REPORT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceExpense %>&con2674=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                </div>
                <div style="height: 100%; width: 100%; display: none;" class="C">
                    <div style="height:520px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">部门</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_DEPARTMENT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceDepartment %>&con2675=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                </div>
                <div style="height: 100%; width: 100%; display: none;" class="C">
                    <div style="height:220px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">技能</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_SKILL %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceSkill %>&con2677=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                    <div style="height:220px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">证书和培训</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CERTIFICATE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceCertificate %>&con2678=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                    <div style="height:220px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">学位</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_DEGREE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceDegree %>&con2679=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                </div>
                <div style="height: 100%; width: 100%; display: none;" class="C">
                    <div style="height:520px;width:100%;border:1px solid #e8e8fa;">
                        <span style="font-weight:bold;color:#666;font-size:12px;padding-left:10px;">附件</span>
                        <div style="width:100%;margin-top:3px;padding:5px 10px 10px 10px;">
                            <iframe src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_ATTACHMENT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.ResourceAttachment %>&con2680=<%=id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                        </div>
                    </div>
                </div>
</div>
            </div>
        
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/sysset_users.js"></script>
        <script type="text/javascript">
            $("#first_name").change(function () {
                $("#resource_name").val($("#first_name").val() + $("#last_name").val());
            });
            $("#last_name").change(function () {
                $("#resource_name").val($("#first_name").val() + $("#last_name").val());
            });
            //ButtonCollectionBase
            $(document).ready(function () {
                $(".xiugai").hide();
            });

            $("#btn1").click(function () {
                $(".xiugai").show();
                $("#btn1").hide();
            });

            $("#tab1").click(function () {//点击常规

            });
            $("#tab2").click(function () {
                var firstname = $("#first_name").val();
                var lastname = $("#last_name");
                if (firstname == null || firstname == '') {
                    alert("无法跳转，请输入姓名！");
                    return false;
                }
                if (lastname == null || lastname == '') {
                    alert("无法跳转，请输入姓名！");
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
            function save_deal() {
                var firstname = $("#first_name").val();
                var lastname = $("#last_name");
                if (firstname == null || firstname == '') {
                    alert("请输入姓名后再进行保存！");
                    return false;
                }
                if (lastname == null || lastname == '') {
                    alert("请输入姓名后再进行保存！");
                    return false;
                }
                //if ($("#Position").val() == 0) { 数据配置不齐全，可空
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
                //if ($("#name").val() == null || $("#name").val() == '')
                //{
                //    alert("请在常规选项卡输入用户名");
                //    return false;
                //}
                //if ($("#pass_word").val() == null || $("#pass_word").val() == '') {
                //    alert("请在常规选项卡输入密码");
                //    return false;
                //}
                //if ($("#pass_word2").val() == null || $("#pass_word2").val() == '') {
                //    alert("请在常规选项卡再次输入密码");
                //    return false;
                //}
                if ($("#Security_Level").val() == 0) {  //数据配置不齐全可空
                    alert("请输入权限等级");
                    return false;
                }
            }
            $("#pass_word2").change(function () {
                var ps1 = $("#pass_word").val();
                if (ps1 == null | ps1 == '') {
                    alert("请先填写密码！");
                    return false;
                }
                if (ps1 != $("#pass_word2").val()) {
                    alert("两次输入密码不相同，请确认后再输入！");
                }
            });
            $("#browsefile").change(function (e) {
                for (var i = 0; i < e.target.files.length; i++) {
                    var file = e.target.files.item(i);
                    if (!(/^image\/.*$/i.test(file.type))) {
                        continue;            //不是图片 就跳出这一次循环
                    }

                    //实例化FileReader API
                    var freader = new FileReader();
                    freader.readAsDataURL(file);
                    freader.onload = function (e) {
                        $("#imgshow").attr("src", e.target.result);
                    }
                }
            });
        </script>
    </form>
</body>
</html>
