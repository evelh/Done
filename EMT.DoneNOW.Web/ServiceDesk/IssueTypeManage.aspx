<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IssueTypeManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.IssueTypeManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
 <title><%=isAdd?"新增":"编辑" %><%=tableId==(int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_SUB_ISSUE_TYPE?"子":"" %>问题</title>
     <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
         <div class="header"><%=isAdd?"新增":"编辑" %><%=tableId==(int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_SUB_ISSUE_TYPE?"子":"" %>问题</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click"  />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
          <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span class="red">*</span></label>
                                        <input type="text" name="name" id="name" value="<%=thisIssue!=null?thisIssue.name:"" %>" />

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>激活<span class="red"></span></label>
                                        <input type="checkbox" name="isActive" id="isActive" <%if (isAdd || (thisIssue != null && thisIssue.is_active == 1))
                                            {%>
                                            checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>关联队列<span class="red">*</span></label>
                                        <select id="ext1" name="ext1">
                                            <option></option>
                                            <% if (depList != null && depList.Count > 0)
                                                {
                                                    foreach (var dep in depList)
                                                    {  %>
                                            <option value="<%=dep.id %>" <%if (thisIssue != null && thisIssue.ext1 == dep.id.ToString())
                                                {%>
                                                selected="selected" <%} %>><%=dep.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        
                        </table>
                    </div>
                </div>
             
                <%if (!isAdd)
                    { %>
                   
                <div class="information clear">
                  <div class="content clear" id="ResourceDiv">
                <div class="header-title">
                    <ul>
                        <li onclick="AddIssue()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>新增</li>
                          <li onclick="DeleteIssue()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>删除</li>
                    </ul>
                </div>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader">
                                    <td style="width: 10%;"></td>
                                    <td style="width: 35%;">子问题类型</td>
                                    <td align="center" style="width: 35%;">关联队列</td>
                                    <td align="center" style="width: 20%;">激活</td>
                                </tr>

                                <% if (subIssueList != null && subIssueList.Count > 0 )
                                    {
                                        foreach (var subIssue in subIssueList)
                                        {
                                            var queName = "";
                                            if (depList != null && depList.Count > 0 && !string.IsNullOrEmpty(subIssue.ext1))
                                            {
                                                var thisQue = depList.FirstOrDefault(_=>_.id.ToString()==subIssue.ext1);
                                                if (thisQue != null)
                                                {
                                                    queName = thisQue.name;
                                                }
                                            }
                                %>
                                <tr class="dataGridBody" style="cursor: pointer;" data-val="<%=subIssue.id %>">
                                    <td><input type="checkbox" class="SubIssue" value="<%=subIssue.id.ToString() %>"/></td>
                                    <td align="center"><%=subIssue.name %></td>
                                    <td align="center"><%=queName %></td>
                                    <td align="center"><%=subIssue.is_active==1?"✓":"" %></td>
                                </tr>
                                <% }
                                    } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                         </div>
                </div>
                <%} %>
         
            </div>
            
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return false;
        }
        return true;
    })

    function AddIssue() {
        window.open('../ServiceDesk/IssueTypeManage?parentId=<%=thisIssue!=null?thisIssue.id.ToString():"" %>&tableId=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.TASK_SUB_ISSUE_TYPE %>', 'AddSubIssue', 'left=0,top=0,location=no,status=no,width=400,height=350', false);
    }

    function DeleteIssue() {

    }
</script>
