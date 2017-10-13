<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractUdf.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractUdf" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/Roles.css" />
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
          <li class="Button ButtonIcon NormalState" tabindex="0"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="SaveClose_Click" style="outline:none;background:transparent;cursor:pointer;border:none;"/>
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
                      <td class="FieldLabels">
                        <label><%=udf.name %></label>
                         <div>
                            <input type="text" name="<%=udf.id %>" value="<%=udfValue %>" class="sl_cdt" style="width:200px;"/>
                         </div>
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                        {%>
                    <tr>
                      <td class="FieldLabels">
                        <label><%=udf.name %></label>
                        <div>
                            <textarea name="<%=udf.id %>" rows="2" cols="20"><%=udfValue %></textarea>
                        </div>
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                        {%>
                    <tr>
                      <td class="FieldLabels">
                        <label><%=udf.name %></label>
                        <div>
                           <input onclick="WdatePicker()" type="text" value="<%=udfValue %>" name="<%=udf.id %>" class="Wdate" />
                        </div>
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                        {%>
                    <tr>
                      <td class="FieldLabels">
                        <label><%=udf.name %></label>
                          <div>
                               <input type="text" name="<%=udf.id %>" value="<%=udfValue %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                          </div>
                      </td>
                    </tr>
                    <%}
                        else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                        {%>

                    <%} %>
                    <tr>
                      <td class="FieldLabels">
                        <label>修改原因</label>
                          <div>
                               <textarea name="description" style="width:200px;height:100px;"></textarea>
                          </div>
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
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
</body>
</html>
