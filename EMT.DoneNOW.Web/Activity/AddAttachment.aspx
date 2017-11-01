<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAttachment.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.AddAttachment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <link rel="stylesheet" href="../Content/NewConfigurationItem.css" />
  <title>新增附件</title>
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">新增附件</span>
    </div>
  </div>
  <div class="ButtonContainer">
    <ul>
      <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton">
        <span class="Icon SaveAndClone"></span>
        <span class="Text">保存并关闭</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="SaveAndNewButton">
        <span class="Icon SaveAndNew"></span>
        <span class="Text">保存并新建</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="CancelButton">
        <span class="Icon Cancel"></span>
        <span class="Text">取消</span>
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="DivScrollingContainer" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
      <div class="DivSectionWithHeader" style="max-width: 740px;">
        <!--头部-->
        <div class="HeaderRow">
          <div class="Toggle Collapse Toggle1">
            <div class="Vertical"></div>
            <div class="Horizontal"></div>
          </div>
          <span class="lblNormalClass">常规信息</span>
        </div>
        <div class="Content">
          <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
            <tbody>
              <tr>
                <td>
                  <div>
                    <table cellpadding="0" cellspacing="0" style="width: 100%;">
                      <tbody>
                        <tr>
                          <td class="FieldLabel" width="50%">类型
                            <div>
                              <span style="display: inline-block;">
                                <select class="txtBlack8Class" style="width: 264px;">
                                  <option value="">0</option>
                                  <option value="">1</option>
                                </select>
                              </span>
                            </div>
                          </td>
                          <td class="FieldLabel">附件名称<span style="color: Red;">*</span>
                            <div>
                              <span style="display: inline-block;">
                                <input type="text" style="width: 250px;" />
                              </span>
                            </div>
                          </td>
                        </tr>
                        <tr>
                          <td class="FieldLabel" width="50%">附件名称<span style="color: Red;">*</span>
                            <div>
                              <span style="display: inline-block;">
                                <input type="text" style="width: 250px;"></span>
                              <a class="DataSelectorLinkIcon">
                                <img src="img/data-selector.png"></a>
                            </div>
                          </td>
                          <td class="FieldLabel">External Project Number
                            <div>
                              <span style="display: inline-block;">
                                <input type="text" style="width: 250px;"></span>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1。0.min.js"></script>
  <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script src="../Scripts/NewProject.js"></script>
</body>
</html>
