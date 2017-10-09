<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddService.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddService" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <title>新增服务</title>
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">新增服务</span>
    </div>
  </div>
  <form id="form1" runat="server">
    <div class="ButtonContainer">
      <ul>
        <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
          <span class="Icon SaveAndClone"></span>
          <span class="Text">保存 & 关闭</span>
        </li>
        <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
          <span class="Icon Cancel"></span>
          <span class="Text">取消</span>
        </li>
      </ul>
    </div>
    <div class="DivSection" style="width: 622px;">
      <table border="0">
        <tbody>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;">服务名称<span class="errorSmall">*</span></span>
              <div>
                <input type="hidden" id="ServiceIdHidden" />
                <input type="text" id="ServiceId" style="width: 260px;" />
                <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALLBACK %>&field=ServiceId', '<%=EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <span class="FieldLabels" style="font-weight: bold;">日期<span class="errorSmall">*</span>
                <span style="font-weight: normal;">(这是括号里的内容)</span>
              </span>
              <div>
                <input type="text" onclick="WdatePicker()" class="Wdate" style="width: 90px;" />
                <label>注意：一大堆的描述</label>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div style="width: 100%; margin-bottom: 10px;">
      <div class="GridContainer" style="height: auto;">
        <div style="overflow: auto; z-index: 0; width: 680px;">
          <table class="dataGridBody" cellspacing="0" style="width: 100%; border-collapse: collapse;">
            <tbody>
              <tr class="dataGridHeader">
                <td style="width: 200px;"></td>
                <td align="right" style="width: 420px;">总数
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位数<span class="errorSmall">*</span></span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px;text-align: right;" value="1"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单价</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总价</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>单位成本</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px;text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>总成本</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px; text-align: right;" />
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总价</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
              <tr class="dataGridBody">
                <td>
                  <span>按比例分配的总成本</span>
                </td>
                <td align="right">
                  <input type="text" style="width: 320px; text-align: right;"/>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </form>
</body>
</html>
