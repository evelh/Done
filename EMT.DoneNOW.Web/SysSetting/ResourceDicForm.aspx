<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResourceDicForm.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ResourceDicForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title><%=typeName %></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=typeName %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                    
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div class="DivSection" style="border:none;padding-left:10px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                       <%=typeName %>名称<span style="color:red;">*</span>
                        <span class="errorSmall"></span>
                        <div>
                            <input type="text" id="name" name="name" style="width:220px;"  maxlength="11"  value="<%=thisDic!=null?thisDic.name:"" %>" />
                        </div>
                    </td>
                </tr>
                <tr >
                    <td width="30%" class="FieldLabels">
                        <%=typeName %>类别<span style="color:red;">*</span>
                        <div>
                             <select name="cateId" id="cateId" style="width:232px;">
                                 <option></option>
                                 <%if (cateList != null && cateList.Count > 0) {
                                         foreach (var cate in cateList)
                                         {%>
                                 <option value="<%=cate.id %>" <%if (thisDic != null && thisDic.parent_id == cate.id) {%> selected="selected" <%} %>><%=cate.name %></option>
                                        <% }
                                     } %>
                             </select><a class="Button ButtonIcon IconOnly New NormalState" id="AddAccA" tabindex="0" style="display: inline-grid; width: 17px; border: 0px;background-color: white;background: linear-gradient(to bottom,#ffffff 0,#fbfbfb 100%);" onclick="AddCate()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></span><span class="Text"></span></a>
                        </div>
                    </td>
                </tr>
                
                <tr>
                    <td width="30%" class="FieldLabels">
                       <%=typeName %>描述
                        <div>
                            <input type="text" id="remark" name="remark" style="width:220px;"  value="<%=thisDic!=null?thisDic.remark:"" %>" class="ToDec2" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                          激活  <input type="checkbox" id="isActive" name="isActive" <%if (isAdd || (thisDic != null && thisDic.is_active == 1)) {%> checked="checked"  <%} %> />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return false;
        }
        var cateId = $("#cateId").val();
        if (cateId == "") {
            LayerMsg("请选择类别！");
            return false;
        }
        return true;
    })
    function AddCate() {
        window.open("../SysSetting/ResourceDicCateForm?type=<%=type %>", windowObj.generalCate + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=350', false);
        
    }
</script>
