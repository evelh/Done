<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CopyToProject.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.CopyToProject" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>复制工单到项目</title>
    <style>
        .Instructions{
                color: #666;
    font-size: 12px;
    line-height: 14px;
    margin: 0 10px 11px 10px;
    padding: 0 0 5px 0;
        }
        input {
    width: 180px;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">复制工单到项目</span>
                </div>
            </div>

             <div class="ButtonContainer header-title" style="margin:0;">
                <ul id="btn">
                    <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input type="button" value="保存并关闭" style="width:68px;" />
                    </li>
                    <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="取消" style="width: 30px;" />
                    </li>
                </ul>
            </div>
            <div class="Instructions">
                选择您想要将这些共单添加为任务的客户和项目。 如果您没有在项目进度表中指定一个位置，则所选任务将被添加到项目进度表的末尾。
            </div>
             <div class="DivSection" style="border: none; padding-left: 25px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="30%" class="FieldLabels">客户<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="accountId" value=""  />
                                    <input type="hidden" id="accountIdHidden" name="accountId" value=""  />
                                    <img src="../Images/data-selector.png" onclick="AccountCallBack()" style="vertical-align: middle;cursor: pointer;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">项目<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="projectId" />
                                    <input type="hidden" id="projectIdHidden" name="projectId" value="" />
                                    <img src="../Images/data-selector.png" onclick="ProjectCallBack()" style="vertical-align: middle;cursor: pointer;" />
                                </div>
                            </td>
                        </tr>
                       
                        <tr>
                            <td width="30%" class="FieldLabels">部门<span class="errorSmall">*</span>
                                <div>
                                    <select id="departmentId" name="departmentId" style="width:194px;">
                                        <option></option>
                                        <%foreach (var dep in depList) { %>
                                        <option value="<%=dep.id %>" ><%=dep.name %></option>
                                        <%} %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">阶段
                                <div>
                                    <input type="text" id="phaseId" disabled="disabled"  />
                                    <input type="hidden" id="phaseIdHidden" name="phaseId" />
                                    <img src="../Images/data-selector.png" onclick="PhaseCallback()" style="vertical-align: middle;cursor: pointer;" />
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
    $("#saveClose").click(function () {
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden == "") {
            LayerMsg("请通过查找选择客户！");
            return false;
        }
        
        var projectIdHidden = $("#projectIdHidden").val();
        if (projectIdHidden == "") {
            LayerMsg("请通过查找选择项目！");
            return false;
        }
        var departmentId = $("#departmentId").val();
        if (departmentId == "") {
            LayerMsg("请选择相关部门！");
            return false;
        }
        $("#form1").submit();
    })
    // 客户查找带回事件处理
    function GetDataByAccount() {
        // 清除 其他相关信息
        $("#projectIdHidden").val("");
        $("#projectId").val("");
        $("#departmentId").val("");
        $("#phaseId").val("");
        $("#phaseIdHidden").val("");
    }
    function AccountCallBack() {
        window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=GetDataByAccount', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)
    }

    function ProjectCallBack() {
        var accountIdHidden = $("#accountIdHidden").val();
        if (accountIdHidden != "" && accountIdHidden != null && accountIdHidden != undefined) {
            window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_CALLBACK %>&field=projectId&callBack=GetDataByProject&con997=' + accountIdHidden, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)
        }
        else {
            LayerMsg("请先选择客户！");
        }
    }
    
    function GetDataByProject() {
        $("#phaseId").val("");
        $("#phaseIdHidden").val("");
        // 获取到项目阶段
        var projectIdHidden = $("#projectIdHidden").val();
        if (projectIdHidden != "" && projectIdHidden != null && projectIdHidden != undefined) {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=" + projectIdHidden,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#departmentId").val(data.department_id);
                    } 
                },
               
            })
        }
        else {
            $("#departmentId").val("");
        }
    }
    $("#Close").click(function () {
        window.close();
    })

    function PhaseCallback() {
        var projectIdHidden = $("#projectIdHidden").val();
        if (projectIdHidden != "" && projectIdHidden != null && projectIdHidden != undefined) {
            window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_PHASE %>&field=phaseId&con2466=' + projectIdHidden, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorSelect %>', 'left=200,top=200,width=600,height=800', false)
        }
        else {
            LayerMsg("请先选择项目！");
        }
        
       
    }
</script>
