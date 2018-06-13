<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CostCodeManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.CostCodeManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
      <link href="../Content/index.css" rel="stylesheet" />
  <style>
       input[type="radio"]{
           width:14px;
       }
       .RoleTable input[type="text"]{
           height:20px;
       }
       .content input[type=checkbox]{
           margin-top:0px;
       }
  </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %><%=cateGeneral!=null?cateGeneral.name:"" %></span>
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
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div class="content clear">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">名称</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="name" name="name" style="width: 220px;" maxlength="11" value="<%=code!=null?code.name:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">部门</span>
                                        <div>
                                            <select name="department_id" id="department_id" style="width: 232px;">
                                                <option></option>
                                                <%if (depList != null && depList.Count > 0)
                                                    {
                                                        foreach (var cate in depList)
                                                        {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.department_id == cate.id)
                                                    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <div>
                                             <span style="margin-left:15px;"> 激活</span>  <input type="checkbox" id="isActive" name="isActive" <%if (isAdd || (code != null && code.is_active == 1))
    {%> checked="checked"  <%} %> />
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                   <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">外部代码</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="external_id" name="external_id" style="width: 220px;" maxlength="11" value="<%=code!=null?code.external_id:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">总账代码</span>
                                        <div>
                                            <select name="general_ledger_id" id="general_ledger_id" style="width: 232px;">
                                                <option></option>
                                                <%if (ledgerList != null && ledgerList.Count > 0)
                                                    {
                                                        foreach (var cate in ledgerList)
                                                        {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.general_ledger_id == cate.id)
                                                    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">税种</span>
                                        <div>
                                            <select name="tax_category_id" id="tax_category_id" style="width: 232px;">
                                                <option></option>
                                                <%if (taxCateList != null && taxCateList.Count > 0)
                                                    {
                                                        foreach (var cate in taxCateList)
                                                        {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.tax_category_id == cate.id)
                                                    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <div>
                                              <span style="margin-left:15px;">包括新合同</span>  <input type="checkbox" id="isIncludeContract" name="isIncludeContract" <%if ((code != null && code.excluded_new_contract == 1))
    {%> checked="checked"  <%} %> />
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                 <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="RoleTable">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left:10px;">帐单费率和小时修改
                                    
                                        <div>
                                            
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdRole" name="RateTypeGroup" value="rdRole" /> <span style="display:block;margin-top:5px;">使用角色费率</span></td>
                                    <td><input type="text" id="txtRole" name="txtRole"/></td>
                                </tr>
                         
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>

</script>
