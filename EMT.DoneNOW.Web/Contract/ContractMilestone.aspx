<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMilestone.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractMilestone" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title><%if (milestoneId > 0) { %>编辑<%} else { %>新增<%} %>里程碑</title>
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/LostOpp.css" />
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <div class="TitleBar">
        <div class="Title">
          <span class="text1"><%if (milestoneId > 0) { %>编辑<%} else { %>新增<%} %>里程碑</span>
        </div>
      </div>
      <div class="ButtonContainer header-title">
        <ul id="btn">
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <input type="button" value="保存并关闭" id="SaveClose" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
            <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClientClick="javascript:window.close();" />
          </li>
        </ul>
      </div>
      <div class="DivSection" style="border: none; padding-left: 0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td width="30%" class="FieldLabels">标题<span class="errorSmall">*</span>
                <div>
                  <asp:TextBox ID="name" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">总额<span class="errorSmall">*</span>
                <div>
                  <asp:TextBox ID="dollars" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">截止日期<span class="errorSmall">*</span>
                <div>
                  <input type="text" name="due_date" value="<%=duDate %>" onclick="WdatePicker()" />
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">计费代码
                <div>
                  <input type="hidden" id="billCodeSelectHidden" name="cost_code_id" />
                  <asp:TextBox ID="billCodeSelect" Enabled="false" runat="server"></asp:TextBox>
                  <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=billCodeSelect&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE %>', '<%=EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle;cursor: pointer;" />
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">状态
                <div>
                  <select name="status_id" >
                    <%foreach (var sta in statuList) {
                          if (statu != 0 && sta.val.Equals(statu))
                          { %>
                    <option selected="selected" value="<%=sta.val %>"><%=sta.show %></option>
                    <%}
                        else { %>
                    <option value="<%=sta.val %>"><%=sta.show %></option>
                    <%} 
                    } %>
                  </select>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">描述
                <div>
                  <asp:TextBox ID="description" runat="server" Height="90px"></asp:TextBox>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <asp:HiddenField ID="milstId" runat="server" />
        <asp:HiddenField ID="contract_id" runat="server" />
      </div>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script>
    $("#SaveClose").on("click", function () {
      if ($("#name").val() == "") {
        alert("请输入标题");
        return;
      }
      if ($("#dollars").val() == "") {
        alert("请输入总额");
        return;
      }
      if ($("#due_date").val() == "") {
        alert("请输入截止日期");
        return;
      }
      $("#form1").submit();
    });
  </script>
</body>
</html>
