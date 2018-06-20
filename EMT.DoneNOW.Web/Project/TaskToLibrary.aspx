<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskToLibrary.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskToLibrary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />--%>
    <title><%=isAdd?"新增":"编辑" %>任务库</title>
    <style>
        body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

            .HeaderRow table {
                width: 100%;
                border-collapse: collapse;
            }

            .HeaderRow span {
                color: #FFF;
                top: 10px;
                display: block;
                width: 85%;
                position: absolute;
                text-transform: uppercase;
                font-size: 15px;
                font-weight: bold;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                }

                    .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
                        background: #d7d7d7;
                        background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                        border: 1px solid #bcbcbc;
                        display: inline-block;
                        color: #4F4F4F;
                        cursor: pointer;
                        padding: 0 5px 0 3px;
                        position: relative;
                        text-decoration: none;
                        vertical-align: middle;
                        height: 24px;
                    }

        .DivScrollingContainer.General {
            top: 82px;
        }

        .DivScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: fixed;
            right: 0;
            bottom: 0;
        }

        .PageLevelInstructions {
            padding: 0 10px 12px 10px;
        }

        td {
            font-size: 12px;
        }

        .PageLevelInstructions span {
            font-size: 12px;
            color: #666;
            line-height: 16px;
        }

        .NoneBorder {
            border: none;
        }

        .DivSection {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

            .DivSection > table {
                border: 0;
                margin: 0;
                border-collapse: collapse;
            }

            .DivSection td[id="txtBlack8"], .DivSection td[class="FieldLabels"] {
                vertical-align: top;
            }

            .DivSection td {
                /*padding: 0;*/
                text-align: left;
                padding: 10px 10px 10px 10px;
            }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }
        #save_close{
            border-style: none;
    background-color: #dddddd;
        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tr>
                    <%if (isAdd)
                        { %>
                    <td><span>添加到任务库: <%=thisTask == null ? "" : thisTask.title %></span></td>
                    <%}
    else
    { %>
                    <td><span>编辑任务库</span></td>
                    <%} %>
                    <td align="right" class="helpLink"><a class="HelperLinkIcon">
                        </a></td>
                </tr>
            </table>
        </div>

        <!-- TOP BUTTONS -->
        <div class="ButtonBar">
            <ul>
                <li><a class="ImgLink" id="HREF_btnSaveClose" name="HREF_btnSaveClose">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;width: 16px;height: 16px;display: inline-block;margin: -2px 3px;margin-top: 3px;"></span><span class="Text"><asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" /></span></a></li>
                <li style="margin-left:20px;" onclick="javascript:window.close();"><a class="ImgLink" id="HREF_btnCancel" name="HREF_btnCancel" title="Cancel">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;width: 16px;height: 16px;display: inline-block;margin: -2px 3px;margin-top: 3px;"></span>
                    <span class="Text">取消</span></a></li>

            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 145px;">
            <div class="DivScrollingContainer General">
                <%if (isAdd)
                    { %>
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="Searchareaborder">
                    <tr>
                        <td class="PageLevelInstructions"><span>选择一个类别，验证任务信息，然后单击“保存和关闭”添加到任务库中。</span></td>
                    </tr>
                </table>
                <%} %>
                <div class="DivSection NoneBorder" style="padding-left: 0px; padding-top: 0px;min-width:700px;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                        <tr>
                            <td class="FieldLabels">种类
				<div>
                    <select id="cate_id" name="cate_id" style="width:362px;">
                        <option></option>
                        <% if (libCateList != null && libCateList.Count > 0) {
                                foreach (var libCate in libCateList)
                                {%>
                        <option value="<%=libCate.id %>" <% if (taskLib != null && taskLib.cate_id == libCate.id) {%> selected="selected" <% } %> ><%=libCate.name %></option>
                               <% }
                            } %>
                    </select>
                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">标题<span id="errorSmall" style="color:red;">*</span>
                                <div>
                                    <input type="text" name="title" style="width: 362px;" id="title" value="<%=taskLib!=null?taskLib.title:(thisTask!=null?thisTask.title:"") %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">描述
				<div>
                    <textarea name="description" id="description" rows="6" style="width: 362px;"><%=taskLib!=null?taskLib.title:(thisTask!=null?thisTask.description:"") %></textarea>
                </div>
                            </td>
                        </tr>

                        <tr>
                            <td class="FieldLabels">预估时间
				<div>
                    <input type="text" name="estimated_hours" size="8" style="width: 60px;" id="estimated_hours" value="<%=taskLib!=null?(taskLib.estimated_hours!=null?(((decimal)taskLib.estimated_hours).ToString("#0.00")):""):(thisTask!=null?thisTask.estimated_hours.ToString("#0.00"):"") %>" maxlength="4" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')"  />
                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">部门
				<div>
                    <select id="department_id" name="department_id" style="width:362px;">
                        <option></option>
                        <% if (depList != null && depList.Count > 0) {
                                foreach (var dep in depList)
                                {%>
                        <option value="<%=dep.id %>" <% if (taskLib != null && taskLib.department_id == dep.id) {%> selected="selected" <% } %> ><%=dep.name %></option>
                               <% }
                            } %>
                    </select>
                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">工作类型
				<div>
                    <select name="cost_code_id" id="cost_code_id" style="width: 362px;">
                    </select>
                </div>

                            </td>
                        </tr>
                        <%if (isAdd)
                            { %>
                        <tr>
                            <td class="FieldLevelInstructions"><span>默认任务工作类型下拉框工作类型如果不计费则用括弧标记出来，如“销售（不可计费）
                            </span>
                            </td>
                        </tr>
                        <%} %>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        GetWorkTypeByDepId();
        <%if (isAdd && thisTask != null && thisTask.department_id != null) {%>
        $("#department_id").val('<%=thisTask.department_id %>');
    <%} %>
        <%if (taskLib != null && taskLib.cost_code_id != null)
    { %>
        $("#cost_code_id").val('<%=taskLib.cost_code_id %>');
        <%} %>
    })
    $("#save_close").click(function () {
        var title = $("#title").val();
        if (title == "") {
            LayerMsg("请填写标题");
            return false;
        }
        return true;
    })
    $("#department_id").change(function () {
        GetWorkTypeByDepId();
    });
    function GetWorkTypeByDepId() {
        // department_id
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "" && department_id != "0") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/DepartmentAjax.ashx?act=GetWorkType&department_id=" + department_id,
                success: function (data) {
                    if (data != "") {
                        $("#cost_code_id").html(data);
                    }
                },
            });
        }
        else {
            $("#cost_code_id").html("<option value=''> <option>");
        }

    }
</script>
