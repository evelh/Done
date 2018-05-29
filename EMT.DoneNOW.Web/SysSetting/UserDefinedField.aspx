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
            <div class="DivSection" style="border: none; padding-left: 20px; width: 560px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels">对象
                                <div>
                                    <%if (udfField == null) {%>
                                    <select id="cate_id" name="cate_id" onchange="CateChange(0)" <%if (udfField != null) { %> style="display:none;" <%} else { %> style="width: 250px; padding: 0;" <%} %> >
                                        <%if (udfField == null) {
                                                foreach(var cate in udfCates) {
                                                %>
                                        <option value="<%=cate.val %>"><%=cate.show %></option>
                                        <%}} %>
                                    </select><% } else { %>
                                    <label ><%=udfCates.Find(_=>_.val.Equals(udfField.cate.ToString())).show %></label><%} %>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="FieldLabels" style="font-weight: bold;">名称<span class="errorSmall">*</span></span>
                                <div>
                                    <input type="hidden" id="fieldId" name="fieldId" <%if (udfField != null){ %> value="<%=udfField.id %>" <%} %> />
                                    <input type="text" id="col_comment" name="col_comment" style="width: 248px; padding: 0;" <%if (udfField != null){ %> value="<%=udfField.name %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="active" name="active" <%if (udfField == null || udfField.is_active == 1) { %> checked="checked" <%} %> />
                                    <label for="active">激活</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">描述
                                <div>
                                    <input type="text" id="description" name="description" style="width: 248px; padding: 0;" <%if (udfField != null){ %> value="<%=udfField.description %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr id="requireTr">
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="require" name="require" <%if (udfField != null && udfField.required == 1) { %> checked="checked" <%} %> />
                                    <label for="require">必填</label><asp:Label ID="requireDesc" runat="server"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr style="display:none;" id="protectTr">
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="protect" name="protect" <%if (udfField != null && udfField.is_protected == 1) { %> checked="checked" <%} %> />
                                    <label for="protect">保护</label>
                                </div>
                            </td>
                        </tr>
                        <tr style="display:none;" id="encryptedTr">
                            <td class="FieldLabels">
                                <div>
                                    <input type="checkbox" id="encrypted" name="encrypted" <%if (udfField != null && udfField.is_encrypted == 1) { %> checked="checked" <%} %> />
                                    <label for="encrypted">密文</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">排序值
                                <div>
                                    <input type="text" id="sort_value" name="sort_value" style="width: 248px; padding: 0;" <%if (udfField != null){ %> value="<%=udfField.sort_order %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">字段类型
                                <div>
                                    <select id="data_type_id" name="data_type_id" style="width: 250px; padding: 0;">
                                        <%if (udfField == null) { %>
                                        <%foreach (var type in udfTypes) { %>
                                        <option value="<%=type.val %>"><%=type.show %></option>
                                        <%} %>
                                        <%} else { %>
                                        <%=udfTypeOpts %>
                                        <%} %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr <%if (udfField == null || udfField.data_type != (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST) { %> style="display:none;" <%} %> id="listValTr">
                            <td class="FieldLabels">列表值
                                <div>
                                    <table id="listTable">
                                        <tr>
                                            <th>显示值</th>
                                            <th>排序号</th>
                                            <th>默认</th>
                                            <th>操作</th>
                                        </tr>
                                        <%if (udfField != null && udfField.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST) {
                                                foreach(var val in udfField.list) { %>
                                        <tr id="listVale<%=val.id %>"><td><%=val.name %><input type="hidden" name="listValShowe<%=val.id %>" value="<%=val.name %>" /></td><td><%=val.sort_order %><input type="hidden" name="listValOrdere<%=val.id %>" value="<%=val.sort_order %>" /></td><td><%=val.is_default==1?"是":"否" %><input type="hidden" name="listValDefte<%=val.id %>" value="<%=val.is_default %>" /></td><td><input type="button" value="删除" onclick="DeleteListVal(<%=val.id%>)" /></td></tr>
                                        <%}
                                            } %>
                                        <tr id="listAdd">
                                            <td><input type="text" id="displayVal" /></td>
                                            <td><input type="text" id="sortVal" /></td>
                                            <td><input type="checkbox" id="is_dft" /></td>
                                            <td><input type="button" value="添加" onclick="AddListVal()" /></td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">默认值
                                <div>
                                    <input type="text" id="default_value" name="default_value" style="width: 248px; padding: 0;" <%if (udfField != null){ %> value="<%=udfField.default_value %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr style="display:none;" id="projectTr">
                            <td class="FieldLabels">与商机字段映射
                                <div>
                                    <select id="crm_to_project_udf_id" name="crm_to_project_udf_id" style="width: 250px; padding: 0;">

                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr style="display:none;" id="showinportalTr">
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
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script>
        function CateChange(idx) {
            if (idx == 0) {
                idx = $("#cate_id").val();
            }
            if (idx == 522) {
                $("#projectTr").show();
            }
            if (idx == 523) {
                $("#protectTr").show();
                $("#encryptedTr").show();
                $("#showinportalTr").show();
            }
            if (idx == 513) {
                $("#protectTr").show();
                $("#encryptedTr").show();
            }
            if (idx == 512) {
                $("#requireTr").hide();
                $("#showinportalTr").show();
            }
        }
        <%if (udfField != null) { %>CateChange(<%=udfField.cate%>);<%}%>
        $("#data_type_id").change(function () {
            if ($("#data_type_id").val() == 530) {
                $("#listValTr").show();
            } else {
                $("#listValTr").hide();
            }
        })
        var listIdx = 1;
        var deftIdx = 0;
        var ids = '';
        function AddListVal() {
            if ($("#displayVal").val() == "") {
                LayerMsg("请输入默认值");
                return;
            }
            if ($("#is_dft").prop("checked")) {
                if (deftIdx != 0) {
                    $("#dft" + deftIdx)[0].innerText = "否";
                }
                deftIdx = listIdx;
            }
            var addTr = $("#listTable").remove();
            $("#listTable").append('<tr id="listVal' + listIdx + '"><td>' + $("#displayVal").val() + '<input type="hidden" name="listValShow' + listIdx + '" value="' + $("#displayVal").val() + '" /></td><td>' + $("#sortVal").val() + '<input type="hidden" name="listValOrder' + listIdx + '" value="' + $("#sortVal").val() + '" /></td><td id="dft' + listIdx + '">' + $("#is_dft").prop("checked") ? "是" : "否" + '</td><td><input type="button" value="删除" onclick="DeleteListVal(' + listIdx + ')" /></td></tr>');
            ids += listIdx + ',';
            listIdx++;
            $("#listTable").append(addTr);
        }
        function DeleteListVal(idx) {
            if (deftIdx == idx) {
                deftIdx = 0;
            }
            $("#listVal" + idx).remove();
            var strids = ids.split(',');
            ids = '';
            for (var i = 0; i < strids.length; i++) {
                if (strids[i] != idx && strids[i] != '') {
                    ids += strids[i] + ',';
                }
            }
        }
    </script>
</body>
</html>
