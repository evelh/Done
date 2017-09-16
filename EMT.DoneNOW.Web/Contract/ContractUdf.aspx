<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractUdf.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractUdf" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/style.css" />
  <title>编辑自定义字段</title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <!--顶部-->
      <div class="TitleBar">
        <div class="Title">
          <span class="text1">编辑自定义字段</span>
          <a href="###" class="help"></a>
        </div>
      </div>
      <!--按钮-->
      <div class="ButtonContainer header-title">
        <ul id="btn">
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" />
          </li>
        </ul>
      </div>
      <div class="DivSection" style="border: none; padding-left: 0;">
        <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
          <tbody>
            <tr>
              <td>
                <div>
                  <table cellpadding="0" cellspacing="0" style="width: 100%;">
                    <% 
                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                        {%>
                    <tr>
                      <td>
                        <label><%=udf.name %></label>
                        <input type="text" name="<%=udf.id %>" value="<%=udfValue %>" class="sl_cdt" />
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                        {%>
                    <tr>
                      <td>
                        <label><%=udf.name %></label>
                        <textarea name="<%=udf.id %>" rows="2" cols="20"><%=udfValue %></textarea>
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                        {%>
                    <tr>
                      <td>
                        <label><%=udf.name %></label>
                        <input onclick="WdatePicker()" type="text" value="<%=udfValue %>" name="<%=udf.id %>" class="sl_cdt" />
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                        {%>
                    <tr>
                      <td>
                        <label><%=udf.name %></label>
                        <input type="text" name="<%=udf.id %>" value="<%=udfValue %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                        {%>

                    <%} %>
                    <tr>
                      <td>
                        <label>修改原因</label>
                        <textarea name="description" rows="2" cols="20"></textarea>
                      </td>
                    </tr>
                  </table>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <asp:HiddenField ID="id" runat="server" />
        <asp:HiddenField ID="contract_id" runat="server" />
      </div>
    </div>
  </form>
</body>
</html>
