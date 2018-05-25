<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDefinedField.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.UserDefinedField" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>用户自定义字段</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/Roles.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">用户自定义字段</span>
                </div>
            </div>
            <div class="ButtonContainer header-title">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="SaveCloseBtn">
                        <span class="Icon SaveAndClone"></span>
                        <span class="Text">保存并关闭</span>
                    </li>
                    <li class="Button ButtonIcon NormalState" id="SaveNewBtn">
                        <span class="Icon SaveAndClone"></span>
                        <span class="Text">保存并新增</span>
                    </li>
                    <li class="Button ButtonIcon NormalState" id="CancelBtn">
                        <span class="Icon Cancel"></span>
                        <span class="Text">取消</span>
                    </li>
                </ul>
                <input type="hidden" id="act" name="act" />
            </div>
            <div class="DivSection" style="border: none; padding-left: 20px; width: 360px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <span class="FieldLabels" style="font-weight: bold;">名称<span class="errorSmall">*</span></span>
                                <div>
                                    <input type="hidden" id="fieldId" name="fieldId" <%if (udfField != null){ %> value="<%=udfField.id %>" <%} %> />
                                    <input type="text" id="col_comment" name="col_comment" style="width: 248px; padding: 0;" <%if (udfField != null){ %> value="<%=udfField.col_comment %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">描述
                                <div>
                                    <input type="text" id="description" name="description" <%if (udfField != null){ %> value="<%=udfField.description %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="require" name="require" <%if (udfField == null || udfField.is_required == 1) { %> checked="checked" <%} %> />
                                    <label for="require">必填</label><asp:Label ID="requireDesc" runat="server"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="protect" name="protect" <%if (udfField != null && udfField.is_protected == 1) { %> checked="checked" <%} %> />
                                    <label for="protect">保护</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="encrypted" name="encrypted" <%if (udfField != null && udfField.is_encrypted == 1) { %> checked="checked" <%} %> />
                                    <label for="encrypted">密文</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">字段类型
                                <div>
                                    <select id="data_type_id" name="data_type_id">

                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">默认值
                                <div>
                                    <input type="text" id="default_value" name="default_value" <%if (udfField != null){ %> value="<%=udfField.default_value %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">变量名
                                <div>
                                    <input type="text" id="merge_variable_name" name="merge_variable_name" <%if (udfField != null){ %> value="<%=udfField.merge_variable_name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">与商机字段映射
                                <div>
                                    <select id="crm_to_project_udf_id" name="crm_to_project_udf_id">

                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="showinportal" name="showinportal" <%if (udfField != null && udfField.is_visible_in_portal == 1) { %> checked="checked" <%} %> />
                                    <label for="showinportal">显示在客户门户上</label>
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
