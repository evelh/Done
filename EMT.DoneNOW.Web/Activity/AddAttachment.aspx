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
      <li class="Button ButtonIcon NormalState" id="SaveAndCloseButton">
        <span class="Icon SaveAndClone"></span>
        <span class="Text">保存并关闭</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="SaveAndNewButton">
        <span class="Icon SaveAndNew"></span>
        <span class="Text">保存并新建</span>
      </li>
      <li class="Button ButtonIcon NormalState" onclick="javascript:window.close();">
        <span class="Icon Cancel"></span>
        <span class="Text">取消</span>
      </li>
    </ul>
  </div>
  <form id="form1" enctype="multipart/form-data" runat="server">
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
                                <select id="actType" name="actType" class="txtBlack8Class" style="width: 264px;">
                                  <%foreach (var type in attTypeList) { %>
                                  <option value="<%=type.val %>" <%if (type.val.Equals(((int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())) { %> selected="selected" <%} %> ><%=type.show %></option>
                                  <%} %>
                                </select>
                              </span>
                            </div>
                          </td>
                          <td class="FieldLabel">附件名称<span style="color: Red;">*</span>
                            <div>
                              <span style="display: inline-block;">
                                <input type='text' id="attName" name='attName' style='width: 250px;' />
                              </span>
                            </div>
                          </td>
                        </tr>
                        <tr id="attTypeTr">
                          <td class='FieldLabel' width='50%'>附件<span style='color: Red;'>*</span>
                            <div>
                              <input type='file' id='att' name='attFile' style='width:260px;' />
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
      <div class="DivSectionWithHeader" style="max-width: 740px;">
        <!--头部-->
        <div class="HeaderRow">
          <div class="Toggle Collapse Toggle2">
            <div class="Vertical"></div>
            <div class="Horizontal"></div>
          </div>
          <span class="lblNormalClass">通知</span>
        </div>
        <div class="Content">
          <div class="DescriptionText">文件会作为邮件附件发送，最多限制10M。</div>
          
        </div>
      </div>
      <input type="hidden" id="action" name="action" />
      <input type="hidden" name="objId" value="<%=objId %>" />
      <input type="hidden" name="objType" value="<%=objType %>" />
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js"></script>
  <script src="../Scripts/common.js"></script>
  <script>
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0;
    $(".Toggle1").on("click", function () {
      $(this).parent().parent().find($(".Vertical")).toggle();
      $(this).parent().parent().find($('.Content')).toggle();
      $(this).parent().parent().css("background", colors[index1 % 2]);
      index1++;
    });
    $(".Toggle2").on("click", function () {
      $(this).parent().parent().find($(".Vertical")).toggle();
      $(this).parent().parent().find($('.Content')).toggle();
      $(this).parent().parent().css("background", colors[index2 % 2]);
      index2++;
    });

    $("#actType").change(function () {
      if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>){
        $("#attTypeTr").html("<td class='FieldLabel' width='50%'>附件<span style='color: Red;'>*</span><div><input type='file' id='att' name='attFile' style='width:260px;' /></div></td>");
      } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FILE_LINK %>){
        $("#attTypeTr").html("<td class='FieldLabel' width='50%'>文件/文件夹路径<span style='color: Red;'>*</span><div><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
      } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FOLDER_LINK %>){
        $("#attTypeTr").html("<td class='FieldLabel' width='50%'>文件/文件夹路径<span style='color: Red;'>*</span><div><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
      } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.URL %>){
        $("#attTypeTr").html("<td class='FieldLabel' width='50%'>URL<span style='color: Red;'>*</span><div><input type='text' id='att' name='attLink' style='width:250px;' /></div></td>");
      }
    })

    $("#SaveAndCloseButton").click(function () {
      subCheck("saveClose");
    })
    $("#SaveAndNewButton").click(function () {
      subCheck("saveNew");
    })
    function subCheck(act) {
      if ($("#attName").val() == "") {
        LayerMsg("请输入附件名称");
        return;
      }
      if ($("#att").val() == "") {
        if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.ATTACHMENT %>){
          LayerMsg("请选择附件");
        } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FILE_LINK %>){
          LayerMsg("请输入文件/文件夹路径");
        } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.FOLDER_LINK %>){
          LayerMsg("请输入文件/文件夹路径");
        } else if ($("#actType").val() ==<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_TYPE.URL %>){
          LayerMsg("请输入URL");
        }
        return;
      }
      $("#action").val(act);
      $("#form1").submit();
    }
  </script>
</body>
</html>
