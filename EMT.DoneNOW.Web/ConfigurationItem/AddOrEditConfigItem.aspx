<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddOrEditConfigItem.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.AddOrEditConfigItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>配置项<%=isAdd?"新增":"修改" %></title>
    <%--<link rel="stylesheet" type="text/css" href="../Content/base.css" />--%>
    <%--<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />--%>
    <%--<link href="../Content/index.css" rel="stylesheet" />--%>
    <link href="../Content/style.css" rel="stylesheet" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/index.css" rel="stylesheet" />
    <style>
        /*顶部内容和帮助*/
        .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

            .TitleBar > .Title {
                top: 0;
                height: 36px;
                left: 10px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 97%;
            }

        .collection {
            background-image: url(../Images/collection.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 38px;
            top: 10px;
            width: 16px;
        }

        .text2 {
            margin-left: 5px;
        }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*工具*/
        .RightClickMenu {
            padding: 16px;
            background-color: #FFF;
            border: solid 1px #CCC;
            cursor: pointer;
            z-index: 999;
            position: absolute;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
        }

        .RightClickMenuItem {
            min-height: 24px;
            min-width: 100px;
        }

        .RightClickMenuItemIcon {
            padding: 1px 5px 1px 5px;
            width: 16px;
        }

        .RightClickMenuItemTable tr:first-child td:last-child {
            white-space: nowrap;
        }

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }

        .Tools {
            background-image: url(../Images/dropdown.png);
        }
        /*保存按钮*/
        .ButtonContainer {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

            .ButtonContainer ul li .Button {
                margin-right: 5px;
                vertical-align: top;
            }

        li.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

        .Button > .Icon {
            display: inline-block;
            flex: 0 0 auto;
            height: 16px;
            margin: 0 3px;
            width: 16px;
        }

        .Save, .SaveAndClone, .SaveAndNew {
            background-image: url("../Images/save.png");
        }

        .Cancel {
            background-image: url("../Images/cancel.png");
        }

        .Button > .Text {
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /*切换按钮*/
        .TabBar {
            border-bottom: solid 1px #adadad;
            font-size: 0;
            margin: 0 0 10px 0;
            padding: 0 0 0 5px;
        }

            .TabBar a.Button.SelectedState {
                background: #fff;
                border-color: #adadad;
                border-bottom-color: #fff;
            }

            .TabBar a.Button {
                background: #eaeaea;
                border: solid 1px #dfdfdf;
                border-bottom-color: #adadad;
                color: #858585;
                height: 24px;
                padding: 0;
                margin: 0 0 -1px 5px;
                width: 100px;
            }

        a.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

        .TabBar a.Button span.Text {
            padding: 0 6px 0 6px;
            margin: 0 auto;
        }

        a.Button > .Text {
            -ms-flex: 0 1 auto;
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /*切换内容*/
        /*头*/
        .DivSectionWithHeader {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 4px 0 0 0;
        }

            .DivSectionWithHeader .HeaderRow {
                position: relative;
                padding-bottom: 3px;
            }

            .DivSectionWithHeader > .HeaderRow > .Toggle {
                background: #d7d7d7;
                background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                border: 1px solid #c6c6c6;
                cursor: pointer;
                height: 14px;
                margin: 2px 6px 0 6px;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
                width: 14px;
                float: left;
            }

                .DivSectionWithHeader > .HeaderRow > .Toggle.Collapse > .Vertical {
                    display: none;
                }

                .DivSectionWithHeader > .HeaderRow > .Toggle > .Vertical {
                    background-color: #888;
                    height: 8px;
                    left: 13px;
                    position: absolute;
                    top: 6px;
                    width: 2px;
                }

                .DivSectionWithHeader > .HeaderRow > .Toggle > .Horizontal {
                    background-color: #888;
                    height: 2px;
                    left: 10px;
                    position: absolute;
                    top: 9px;
                    width: 8px;
                }

                .DivSectionWithHeader > .HeaderRow > .Toggle + span {
                    padding-left: 0;
                }

            .DivSectionWithHeader > .HeaderRow > span {
                display: inline-block;
                vertical-align: middle;
                position: relative;
            }

            .DivSectionWithHeader > .HeaderRow > span {
                padding: 2px 4px 6px 6px;
                color: #666;
                height: 16px;
                font-size: 12px;
                font-weight: bold;
                line-height: 17px;
                text-transform: uppercase;
            }
            /*内容*/
            .DivSectionWithHeader .Content {
                padding: 0 28px 0 28px;
            }

        .FieldLabel {
            font-weight: bold;
            font-size: 12px;
            color: #4F4F4F;
            background-color: transparent;
        }

        .DivSection div, .DivSectionWithHeader .Content div {
            padding-bottom: 10px;
        }

        input[type=text], select, textarea, input[type=password] {
            border: solid 1px #D7D7D7;
            font-size: 12px;
            color: #333;
            margin: 0;
        }

        input[type=text], input[type=password] {
            height: 24px;
            padding: 0 6px;
        }

        .DataSelectorLinkIcon img {
            vertical-align: middle;
            margin-top: -2px;
            margin-left: 1px;
        }

        .txtBlack8Class {
            font-size: 12px;
            color: #333;
            font-weight: normal;
        }

        select {
            height: 24px;
            padding: 0;
        }

        textarea {
            padding: 6px;
            resize: vertical;
        }

        .ip_general_label_udf {
            width: 120px;
            padding-right: 3px;
            height: 22px;
            padding-left: 2px;
        }

        .ip_general_ctrl {
            text-align: left;
        }

        .tabTwo {
            height: 22px;
        }

        .DivSection, .DivSectionOnly {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

        .NoneBorder {
            border: none;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"修改" %>配置项</span>
                <a href="###" class="collection"></a>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon Save"></span>
                    <span class="Text">
                        <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存&关闭" BorderStyle="None" OnClick="save_close_Click" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                    <span class="Icon SaveAndNew"></span>
                    <span class="Text">
                        <asp:Button ID="save_add" runat="server" Text="保存&新建" BorderStyle="None" OnClick="save_add_Click" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text" id="close">取消</span>
                </li>
                <% if (!isAdd)
                    { %>
                <li class="Button ButtonIcon NormalState" id="ToolsButton" tabindex="0">
                    <span class="Icon" style="width: 0; margin: 0;"></span>
                    <span class="Text">工具</span>
                    <span class="Icon Tools"></span>
                </li>
                <%} %>

                <li class="Button ButtonIcon Edit NormalState" id="SiteConfiguration" tabindex="0">
                    <span class="Icon" style="width: 0; margin: 0;"></span>
                    <span class="Text" onclick="window.open('../Company/CompanySiteManage.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>','left=200,top=200,width=960,height=750', false);">站点配置</span>
                </li>
                <li class="Button ButtonIcon Appendix NormalState" id="OtherConfigurationItems" tabindex="0">
                    <span class="Icon" style="width: 0; margin: 0;"></span>
                    <span class="Text">其他配置项</span>
                </li>
            </ul>
        </div>
        <div class="RightClickMenu" style="left: 349px; top: 71px; display: none;">
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemIcon" align="center" valign="middle">
                                <img src="../Images/copy.png" alt="">
                            </td>
                            <td class="RightClickMenuItemText">
                                <span class="lblNormalClass">复制</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemIcon" align="center" valign="middle">
                                <img src="../Images/refresh.png" alt="">
                            </td>
                            <td class="RightClickMenuItemText">
                                <span class="lblNormalClass">替换</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="RightClickMenuItemIcon" align="center" valign="middle">
                                <img src="../Images/employees.png" alt="">
                            </td>
                            <td class="RightClickMenuItemText">
                                <span class="lblNormalClass">谁能看这个？</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="TabBar">
            <a class="Button ButtonIcon SelectedState">
                <span class="Text">常规</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">工单</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">附件</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">成本</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">订阅</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">通知</span>
            </a>
        </div>
        <div class="TabContainer">
            <div class="DivScrollingContainer Tab" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 120px;">
                <div class="DivSectionWithHeader">
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">常规信息</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            <%--<input type="hidden" id="id" name="id" value="<%=!isAdd?iProduct.id.ToString():"" %>"/>--%>
                                                            <%
                                                                if (!isAdd)
                                                                {
                                                                    product = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(iProduct.product_id);
                                                                }
                                                            %>
                                                    产品 <span style="color: Red;">*</span>
                                                            <div>
                                                                <span style="display: inline-block;">
                                                                    <input type="text" name="productName" id="product_id" value="<%=product==null?"":product.name %>" /></span>
                                                                <a onclick="chooseProduct()" class="DataSelectorLinkIcon">
                                                                    <img src="../Images/data-selector.png" alt="" /></a>
                                                                <a id="EditProduct" onclick="EditProduct()" style="display: none;" class="DataSelectorLinkIcon">
                                                                    <img src="../Images/edit.png" alt="" /></a>


                                                                <input type="hidden" name="product_id" id="product_idHidden" value="<%=product==null?"":product.id.ToString() %>" />

                                                            </div>
                                                        </td>
                                                        <td class="FieldLabel">激活&nbsp;&nbsp;&nbsp;<span style="display: inline-block;">
                                                            <asp:CheckBox ID="is_active_" runat="server" />
                                                        </span>
                                                            <div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">配置项类型
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="installed_product_cate_id" runat="server" CssClass="txtBlack8Class"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel" style="width: 330px;">所属客户
                                                    <div>
                                                        <a href="../Company/ViewCompany.aspx?id=<%=account.id %>"><%=account.name %></a>
                                                        <input type="hidden" name="account_id" id="account_id" value="<%=account.id %>" />
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">安装人
                                                    <div>
                                                        <% EMT.DoneNOW.DTO.UserInfoDto user = null;
                                                            if (isAdd)
                                                            {
                                                                user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(LoginUserId);
                                                            }
                                                            else
                                                            {
                                                                if (iProduct.installed_resource_id != null)
                                                                {
                                                                    user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo((long)(iProduct.installed_resource_id));

                                                                }

                                                            }


                                                            if (user != null)
                                                            {%>
                                                        <!-- todo 发送邮件？ -->
                                                        <span id="userName"><%=user.name %><i id="SendEmail" style="width: 20px; height: 20px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat; display: none;"></i> </span>
                                                        <input type="hidden" name="installed_by" value="<%=user.id %>" />
                                                        <%}
                                                        %>
                                                        <img onclick="Email('<%=user.email %>')" src="../Images/email.png" style="cursor: pointer;" />
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel" style="cursor: pointer; margin-left: 2px; margin-bottom: -3px;">联系人
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="contact_id" runat="server" Width="260px"></asp:DropDownList>
                                                            <a id="EditContact" onclick="EditContact()" style="display: none;" class="DataSelectorLinkIcon">
                                                                <img src="../Images/data-selector.png" alt=""></a>
                                                        </span>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">安装日期<span style="color: Red;">*</span>
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" onclick="WdatePicker()" class="Wdate" name="start_date" id="start_date" value="<%=(!isAdd)&&iProduct.start_date!=null?((DateTime)iProduct.start_date).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                                        </span>
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel" style="cursor: pointer; margin-left: 2px; margin-bottom: -3px;">位置 <%--<span style="color: Red;">*</span>--%>
                                                            <div>
                                                                <span style="display: inline-block;">
                                                                    <input type="text" style="width: 250px;" name="location" id="location" value="<%=(!isAdd)&&iProduct.location!=null?iProduct.location:"" %>" /></span>

                                                            </div>

                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">质保过期日期<span style="color: Red;">*</span>
                                                       <div>
                                                           <span style="display: inline-block;">
                                                               <input type="text" onclick="WdatePicker()" class="Wdate" name="through_date" id="through_date" value="<%=(!isAdd)&&iProduct.through_date!=null?((DateTime)iProduct.through_date).ToString("yyyy-MM-dd"):DateTime.Now.AddYears(1).ToString("yyyy-MM-dd") %>" />
                                                           </span>
                                                       </div>
                                                        </td>
                                                        <td class="FieldLabel" style="cursor: pointer; margin-left: 2px; margin-bottom: -3px;">合同
                                                            <div>

                                                                <input type="text" name="contract_name" id="contract_id" value="<%=contract!=null?contract.name:"" %>" />
                                                                <input type="hidden" name="contract_id" id="contract_idHidden" value="<%=contract!=null?contract.id.ToString():"" %>" />
                                                                <a onclick="chooseContract()" class="DataSelectorLinkIcon">
                                                                    <img src="../Images/data-selector.png" alt="" /></a>

                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">序列号 
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" name="serial_number" id="serial_number" value="<%=(!isAdd)&&iProduct.serial_number!=null?iProduct.serial_number:"" %>" /></span>
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel">服务/服务集
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <asp:DropDownList ID="service" runat="server" CssClass="txtBlack8Class" Width="260px"></asp:DropDownList>
                                                        </span>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">参考号 
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" name="reference_number" id="reference_number" value="<%=(!isAdd)&&iProduct.reference_number!=null?iProduct.reference_number:"" %>" /></span>
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel" style="cursor: pointer; margin-left: 2px; margin-bottom: -3px;">

                                                            <div>
                                                                <span style="display: inline-block;">
                                                                    <span class="txtBlack8Class">
                                                                        <%--               <label>是否经过合同审核</label>
                                                               <asp:CheckBox ID="Reviewed_for_contract" runat="server" />--%>
                                                               
                                                                    </span>
                                                                </span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">参考名称 
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" name="reference_name" id="reference_name" value="<%=(!isAdd)&&iProduct.reference_name!=null?iProduct.reference_name:"" %>" /></span>
                                                    </div>
                                                        </td>
                                                        <td>物料成本
                                                           <p id="materal_code"></p>
                                                            <input type="hidden" name="materal_code" id="materal_codeHidden" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">用户数 
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <input type="text" style="width: 250px;" name="number_of_users" id="number_of_users" value="<%=(!isAdd)&&iProduct.number_of_users!=null?((decimal)iProduct.number_of_users).ToString("0"):"" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" /></span>
                                                    </div>
                                                        </td>
                                                        <td class="FieldLabel">供应商
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <select id="vendor_id" class="txtBlack8Class" style="width: 265px;">
                                                            </select>

                                                        </span>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td></td>
                                                        <td>
                                                            <div>
                                                                制造商 &nbsp;&nbsp;&nbsp;<span id="manufacturer"></span>
                                                                <input type="hidden" name="manufacturer" id="manufacturerHidden" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" class="FieldLabel">备注
                                                    <div>
                                                        <textarea style="height: 80px; width: 640px; resize: none;" name="notes"><%=isAdd?"":iProduct.remark %></textarea>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>



                        <%--                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>产品<span class="red">*</span></label>
                                    <input type="text" name="productName" id="product_id" value="" />
                                    <i onclick="chooseProduct();" style="width: 20px; height: 20px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                    <i onclick="EditProduct();" id="EditProduct" style="width: 20px; height: 20px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat; display: none;"></i>
                                    <input type="hidden" name="product_id" id="product_idHidden" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>配置项类型</label>
                                    <asp:DropDownList ID="installed_product_cate_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>安装人</label>
                                    <% var user = Session["dn_session_user_info"] as EMT.DoneNOW.Core.sys_user;
                                        if (user != null)
                                        {%>
                                    <!-- todo 发送邮件？ -->
                                    <p><%=user.name %><i onclick="" id="SendEmail" style="width: 20px; height: 20px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat; display: none;"></i> </p>
                                    <%}
                                    %>
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>安装日期</label>
                                    <input type="text" name="start_date" id="start_date" value="<%=(!isAdd)&&iProduct.start_date!=null?((DateTime)iProduct.start_date).ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>质保过期日期</label>
                                    <input type="text" name="through_date" id="through_date" value="<%=(!isAdd)&&iProduct.through_date!=null?((DateTime)iProduct.through_date).ToString("yyyy-MM-dd"):DateTime.Now.AddYears(1).ToString("yyyy-MM-dd") %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>序列号</label>
                                    <input type="text" name="serial_number" id="serial_number" value="<%=(!isAdd)&&iProduct.serial_number!=null?iProduct.serial_number:"" %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>参考号</label>
                                    <input type="text" name="reference_number" id="reference_number" value="<%=(!isAdd)&&iProduct.reference_number!=null?iProduct.reference_number:"" %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>参考名称</label>
                                    <input type="text" name="reference_name" id="reference_name" value="<%=(!isAdd)&&iProduct.reference_name!=null?iProduct.reference_name:"" %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>用户数</label>
                                    <input type="text" name="number_of_users" id="number_of_users" value="<%=(!isAdd)&&iProduct.number_of_users!=null?iProduct.number_of_users.ToString():"" %>" />
                                </div>
                            </td>

                        </tr>
                        <tr>
                            <td></td>

                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="clear">
                                    <textarea></textarea>
                                </div>
                            </td>
                        </tr>
                    </table>

                    <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>激活</label>
                                    <asp:CheckBox ID="is_active_" runat="server" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>所属客户</label>
                                    <p><a href="../Company/ViewCompany.aspx?id=<%=account.id %>"><%=account.name %></a></p>
                                    <input type="hidden" name="account_id" value="<%=account.id %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>联系人</label>
                                    <asp:DropDownList ID="contact_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>位置</label>
                                    <input type="text" name="location" id="location" value="<%=(!isAdd)&&iProduct.location!=null?iProduct.location:"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>合同</label>
                                    <input type="text" name="contract_name" id="contract_id" value="" />
                                    <input type="hidden" name="contract_id" id="contract_idHidden" value="<%=(!isAdd)&&iProduct.contract_id!=null?iProduct.contract_id.ToString():"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>服务/服务包</label>
                                   
                                    <asp:DropDownList ID="service_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>是否经过合同审核</label>
                                    <asp:CheckBox ID="Reviewed_for_contract" runat="server" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>物料代码</label>
                                    <p id="wuliaodaima"></p>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>供应商</label>
                                    <asp:DropDownList ID="vendor_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>制造商</label>
                                    <p id="zhizaoshang"></p>
                                </div>
                            </td>
                        </tr>

                    </table>--%>
                    </div>
                </div>
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle2">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">用户自定义配置项信息</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>

                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                <tbody>

                                                    <% if (iProduct_udfList != null && iProduct_udfList.Count > 0)
                                                        {
                                                            foreach (var udf in iProduct_udfList)
                                                            {

                                                                if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                                                {%>
                                                    <tr>
                                                        <td class="ip_general_label_udf">
                                                            <div class="clear">
                                                                <label><%=udf.name %></label>
                                                                <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd)&&iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                                            </div>

                                                        </td>
                                                    </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                                        {%>
                                                    <tr>
                                                        <td class="ip_general_label_udf">
                                                            <div class="clear">
                                                                <label><%=udf.name %></label>
                                                                <textarea name="<%=udf.id %>" rows="2" cols="20"><%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>
                                                            </div>

                                                        </td>
                                                    </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                                        {%><tr>
                                                            <td class="ip_general_label_udf">
                                                                <div class="clear">
                                                                    <label><%=udf.name %></label>

                                                                    <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value.ToString():"" %>" />
                                                                </div>

                                                            </td>
                                                        </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                                        {%>
                                                    <tr>
                                                        <td class="ip_general_label_udf">
                                                            <div class="clear">
                                                                <label><%=udf.name %></label>
                                                                <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <%}
                                                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                                        {%>

                                                    <%}
                                                            }
                                                        } %>
                                                    <%--  <tr>
                                                    <td class="ip_general_label_udf">
                                                        <span class="FieldLabel">Brand</span>
                                                    </td>
                                                    <td class="ip_general_ctrl">
                                                        <span style="display: inline-block">
                                                            <input type="text" style="width:250px;margin-bottom: 2px;">
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="ip_general_label_udf">
                                                        <span class="FieldLabel">Brand</span>
                                                        <span style="color:red;">*</span>
                                                    </td>
                                                    <td class="ip_general_ctrl">
                                                        <span style="display: inline-block">
                                                            <input type="text" style="width:250px;margin-bottom: 2px;">
                                                        </span>
                                                    </td>
                                                </tr>--%>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle3">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">关联配置项</span>
                    </div>
                    <div class="Content">
                    </div>
                </div>

            </div>
            <%--  <div class="information clear">
                <p class="informationTitle"><i></i>自定义信息</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 815px;">

                        <% if (iProduct_udfList != null && iProduct_udfList.Count > 0)
                            {
                                foreach (var udf in iProduct_udfList)
                                {

                                    if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                    {%>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=udf.name %></label>
                                    <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd)&&iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                </div>

                            </td>
                        </tr>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                            {%>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=udf.name %></label>
                                    <textarea name="<%=udf.id %>" rows="2" cols="20"><%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %></textarea>
                                </div>

                            </td>
                        </tr>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                            {%><tr>
                                <td>
                                    <div class="clear">
                                        <label><%=udf.name %></label>

                                        <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value.ToString():"" %>" />
                                    </div>

                                </td>
                            </tr>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                            {%>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label><%=udf.name %></label>
                                    <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=iProduct_udfValueList!=null&&iProduct_udfValueList.Count>0?iProduct_udfValueList.FirstOrDefault(_=>_.id==udf.id).value:"" %>" />
                                </div>
                            </td>
                        </tr>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                            {%>

                        <%}
                                }
                            } %>
                    </table>

                </div>
            </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>关联配置项</p>
                <div>
                </div>
            </div>--%>
        </div>
        <div class="TabContainer" style="display: none;"></div>
        <div class="TabContainer" style="display: none;"></div>
        <div class="TabContainer" style="display: none;">
            <div class="DivSection NoneBorder">
                <table style="width: 720px;" border="0" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabel">每小时成本
                            <div>
                                <span style="display: inline-block;">
                                    <input maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" type="text" name="hourly_cost" id="hourly_cost" style="width: 250px; text-align: right;" value="<%=(!isAdd)&&iProduct.hourly_cost!=null?((decimal)iProduct.hourly_cost).ToString("#0.00"):"0.00" %>">
                                </span>
                            </div>
                            </td>
                            <td class="FieldLabel">每次使用成本
                            <div>
                                <span style="display: inline-block;">
                                    <input maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" type="text" name="peruse_cost" id="peruse_cost" style="width: 250px; text-align: right;" value="<%=(!isAdd)&&iProduct.peruse_cost!=null?((decimal)iProduct.peruse_cost).ToString("#0.00"):"0.00" %>">
                                </span>
                            </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">月度成本
                            <div>
                                <span style="display: inline-block;">
                                    <input maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" type="text" name="monthly_cost" id="monthly_cost" style="width: 250px; text-align: right;" value="<%=(!isAdd)&&iProduct.monthly_cost!=null?((decimal)iProduct.monthly_cost).ToString("#0.00"):"0.00" %>">
                                </span>
                            </div>
                            </td>
                            <td class="FieldLabel">初始费用
                            <div>
                                <span style="display: inline-block;">
                                    <input maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" type="text" name="setup_fee" id="setup_fee" style="width: 250px; text-align: right;" value="<%=(!isAdd)&&iProduct.setup_fee!=null?((decimal)iProduct.setup_fee).ToString("#0.00"):"0.00" %>">
                                </span>
                            </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">日成本
                            <div>
                                <span style="display: inline-block;">
                                    <input maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="Number" type="text" name="daily_cost" id="daily_cost" style="width: 250px; text-align: right;" value="<%=(!isAdd)&&iProduct.daily_cost!=null?((decimal)iProduct.daily_cost).ToString("#0.00"):"0.00" %>">
                                </span>
                            </div>
                            </td>
                            <td class="FieldLabel">客户链接
                            <div>
                                <span style="display: inline-block;">
                                    <input type="text" name="accounting_link" id="accounting_link" style="width: 250px;" value="<%=(!isAdd)&&iProduct.accounting_link!=null?iProduct.accounting_link:"" %>">
                                </span>
                            </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="TabContainer" style="display: none;">
            <% if (!isAdd)
                { %>
            <iframe runat="server" id="viewSubscription_iframe" width="860" height="500" frameborder="0" marginheight="0" marginwidth="0" style="overflow: scroll;"></iframe>
            <%} %>
        </div>
        <div class="TabContainer" style="display: none;"></div>

        <%--    <div id="menu">
        <ul style="width: 220px;">
            <li onclick=""><i class="menu-i1"></i>编辑</li>
            <li onclick=""><i class="menu-i1"></i>更新</li>
            <li onclick=""><i class="menu-i1"></i>取消</li>
            <li onclick=""><i class="menu-i1"></i>失效</li>
            <li onclick=""><i class="menu-i1"></i>删除</li>
        </ul>
    </div>--%>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>

<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>

    $("#SaveButton").on("mouseover", function () {
        $("#SaveButton").css("background", "#fff");
    });
    $("#SaveButton").on("mouseout", function () {
        $("#SaveButton").css("background", "#f0f0f0");
    })
        ; $("#SaveAndCloneButton").on("mouseover", function () {
            $("#SaveAndCloneButton").css("background", "#fff");
        });
    $("#SaveAndCloneButton").on("mouseout", function () {
        $("#SaveAndCloneButton").css("background", "#f0f0f0");
    });
    $("#SaveAndNewButton").on("mouseover", function () {
        $("#SaveAndNewButton").css("background", "#fff");
    });
    $("#SaveAndNewButton").on("mouseout", function () {
        $("#SaveAndNewButton").css("background", "#f0f0f0");
    });
    $("#CancelButton").on("mouseover", function () {
        $("#CancelButton").css("background", "#fff");
    });
    $("#CancelButton").on("mouseout", function () {
        $("#CancelButton").css("background", "#f0f0f0");
    });
    $("#SiteConfiguration").on("mouseover", function () {
        $("#SiteConfiguration").css("background", "#fff");
    });
    $("#SiteConfiguration").on("mouseout", function () {
        $("#SiteConfiguration").css("background", "#f0f0f0");
    });
    $("#OtherConfigurationItems").on("mouseover", function () {
        $("#OtherConfigurationItems").css("background", "#fff");
    });
    $("#OtherConfigurationItems").on("mouseout", function () {
        $("#OtherConfigurationItems").css("background", "#f0f0f0");
    });
    $.each($(".TabBar a"), function (i) {
        $(this).click(function () {
            debugger;
            var isadd = '<%=isAdd %>';
            if (isadd == 'True') {
                var thisValue = $(this).children().first().text(); //配置项必须先保存，才能继续，请确认
                if (thisValue == "工单" || thisValue == "附件" || thisValue == "订阅") {
                    alert('配置项必须先保存，才能继续，请确认');
                    return false;
                }
            }

            $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
        })
    });
    var colors = ["#efefef", "white"];
    var index1 = 0;
    var index2 = 0;
    var index3 = 0;
    var index4 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index2 % 2]);
        index2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index3 % 2]);
        index3++;
    });
    $(".Toggle4").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index4 % 2]);
        index4++;
    });
    //工具
    $("#ToolsButton").on("mouseover", function () {
        $("#ToolsButton").css("background", "#fff");
        $(this).css("border-bottom", "none");
        $(".RightClickMenu").show();
    });
    $("#ToolsButton").on("mouseout", function () {
        $("#ToolsButton").css("background", "#f0f0f0");
        $(this).css("border-bottom", "1px solid #BCBCBC");
        $(".RightClickMenu").hide();
    });
    $(".RightClickMenu").on("mouseover", function () {
        $("#ToolsButton").css("background", "#fff");
        $("#ToolsButton").css("border-bottom", "none");
        $(this).show();
    });
    $(".RightClickMenu").on("mouseout", function () {
        $("#ToolsButton").css("background", "#f0f0f0");
        $("#ToolsButton").css("border-bottom", "1px solid #BCBCBC");
        $(this).hide();
    });
    $(".RightClickMenuItem").on("mouseover", function () {
        $(this).css("background", "#E9F0F8");
    });
    $(".RightClickMenuItem").on("mouseout", function () {
        $(this).css("background", "#FFF");
    });
//工具结束
</script>

<script>


    $(function () {
        debugger;

         <%if (contract != null)
         { %>
            GetServiceByContract();
            <%
         }
         else
         {%>
        $("#service").prop("disabled", true);
        <%}%>


       <%if (isAdd)
    { %>
            $("#EditProduct").css("display", "");
        <%}
    else
    {
        if (iProduct.service_id != null)
        {%>
            $("#service").val(<%=iProduct.service_id %>);
        <%}

        if(iProduct.service_bundle_id != null)
        {%>
            $("#service").val(<%=iProduct.service_bundle_id %>);
        <%}
    }%>
        GetDaraByProduct();

    
    })
    // contact_id
    $("#contact_id").change(function () {
        var value = $(this).val();
        if (value != 0) {
            // 如果选择了联系人显示修改联系人的链接
            $("#EditContact").css("display", "");
        }
        else {
            $("#EditContact").css("display", "none");
        }

    })


    $("#save").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })

    $("#save_close").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })

    $("#save_add").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })
    $("#CancelButton").click(function () {
        window.close();
    })




    $(".Number").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && $.trim(value) != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }
    })


    // 提交校验
    function submitCheck() {
        var product_idHidden = $("#product_idHidden").val();
        if (product_idHidden == "") {
            alert('请通过查找带回关联产品！');
            return false;
        }
        // is_active_
        //var is_active_ = $("#is_active_").val();
        //if (is_active_ == "" || is_active_==0) {
        //    alert('请选择激活！');
        //    return false;
        //}
        // account_id
        var account_id = $("#account_id").val();
        if (account_id == "") {
            alert('客户丢失！');
            return false;
        }
        // userName
        var userName = $("#userName").text();
        if (userName == "") {
            alert('用户丢失！');
            return false;
        }
        // contact_id
        //var contact_id = $("#contact_id").val();
        //if (contact_id == "" || contact_id==0) {
        //    alert('请选择联系人！');
        //    return false;
        //}
        // start_date
        var start_date = $("#start_date").val();
        if (start_date == "") {
            alert('请选择安装日期！');
            return false;
        }
        // through_date
        var through_date = $("#through_date").val();
        if (through_date == "") {
            alert('请选择质保过期日期！');
            return false;
        }
        // location
        //var location = $("#location").val();
        //if (location == "") {
        //    alert('请填写位置！');
        //    return false;
        //}
        // service
        // 所选合同如果是服务类型的，则此下拉框可选。可选内容为合同项--todo
        //var service = $("#service").val();
        //if (service == "" || service==0) {
        //    alert('请选择服务/服务集！');
        //    return false;
        //}
        // wuliaodaima
        //var materal_code = $("#materal_code").text();
        //if (materal_code == "" ) {
        //    alert('请选择物料成本代码！');
        //    return false;
        //}

        var hourly_cost = $("#hourly_cost").val();
        if (hourly_cost == "") {
            alert('请填写每小时成本！');
            return false;
        }
        var peruse_cost = $("#peruse_cost").val();
        if (peruse_cost == "") {
            alert('请填写每次成本！');
            return false;
        }
        //var monthly_cost = $("#monthly_cost").text();
        //if (monthly_cost == "") {
        //    alert('请填写月度成本！');
        //    return false;
        //}
        var setup_fee = $("#setup_fee").val();
        if (setup_fee == "") {
            alert('请填写初始费用！');
            return false;
        }
        var daily_cost = $("#daily_cost").val();
        if (daily_cost == "") {
            alert('请填写日成本！');
            return false;
        }



        return true;
    }

    function chooseProduct() { //PRODUCT_CALLBACK
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=product_id&callBack=GetDaraByProduct", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDaraByProduct() {
        var product_id = $("#product_idHidden").val();
        if (product_id != "") {
            //$("object_id").val(product_id);

            var productCateId = "";
            var cost_code_id = "";
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=product&product_id=" + product_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        debugger;
                        $("#EditProduct").css("display", "");
                        //$("#EditProduct").attr("click", EditProduct())
                        // $("#installed_product_cate_id").val(data.cate_id);   // 配置项种类
                        productCateId = data.cate_id;
                        cost_code_id = data.cost_code_id;
                    }
                    else {
                        $("#EditProduct").css("display", "none");
                    }
                },
            });
            // 根据产品的cate_id 去获取到相对应的配置项类型ID

            if (productCateId != "" && productCateId != undefined) {
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/GeneralAjax.ashx?act=general&id=" + productCateId,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {

                            $("#installed_product_cate_id").val(data.ext1);
                        }

                    },
                });
            }



            // 根据查找带回的产品，获取相对应的供应商的列表，显示在下拉框中
            $("#vendor_id").html("");
            $.ajax({
                type: "GET",
                async: false,
                // dataType: "json",
                url: "../Tools/CompanyAjax.ashx?act=vendorList&product_id=" + product_id,
                success: function (data) {
                    if (data != "") {
                        $("#vendor_id").html(data);
                    }
                },

            });

            // 带回物料代码 --todo
            if (cost_code_id != "" && productCateId != undefined) {
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=costCode&cost_code_id=" + cost_code_id,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {
                            $("#materal_code").text(data.name);
                            $("#materal_codeHidden").val(data.id);
                        }
                        else {

                        }
                    },
                });
            }

            // 带回制造商
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetVendorInfo&product_id=" + product_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    debugger;
                    if (data != "") {
                        var thisText = data.name + '(' + data.vendor_product_no + ')';
                        $("#manufacturer").text(thisText);
                    }
                },

            });

        }
    }

    function EditProduct() {
        var product = $("#product_idHidden").val();
        if (product != "") {
            alert('跳转到修改产品的功能暂未实现！');
            //window.open("");// todo-
        }
    }

    function EditContact() {
        var contact_id = $("#contact_id").val();
        if (contact_id != 0 && contact_id != "") {
            window.open("../Contact/AddContact.aspx?id=" + contact_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactEdit %>', 'left=200,top=200,width=600,height=800', false);
        }
        else {

        }
    }
    function Email(email) {
        location.href = "mailto:" + email + "";
    }

    function chooseContract() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_CALLBACK %>&field=contract_id&callBack=GetServiceByContract", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 如果选择的是服务的合同，那么服务包可选。是该服务下的服务包
    function GetServiceByContract() {
        var contract_id = $("#contract_idHidden").val();
        if (contract_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=isService&contract_id=" + contract_id,
                success: function (data) {
                    if (data != "") {
                        $("#service").html(data);
                        $("#service").prop("disabled", false);
                    }
                    else {
                        $("#service").prop("disabled", true);
                    }
                }
            })
        }
    }
</script>
