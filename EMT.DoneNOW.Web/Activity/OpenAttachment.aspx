<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpenAttachment.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.OpenAttachment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <%if (!string.IsNullOrEmpty(filePath)){ %>
  <title>文件/文件夹路径</title>
  <link rel="stylesheet" href="../Content/reset.css" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <%} %>
</head>
<body>
  <%if (!string.IsNullOrEmpty(filePath)){ %>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">文件/文件夹路径</span>
    </div>
  </div>
  <div class="ButtonContainer">
    <ul>
      <li class="Button ButtonIcon NormalState" onclick="javascript:window.close();">
        <span class="Icon Cancel"></span>
        <span class="Text">关闭</span>
      </li>
    </ul>
  </div>
  <div style="margin:10px;">
    <div style="margin-right:10px;">
      <span style="font-size:12px;color:#666;line-height:16px;">
        文件/文件夹路径不支持在浏览器中打开，你可以复制链接并粘贴在文件浏览窗口打开文件/文件夹。
      </span>
    </div>
    <div style="margin:10px 10px 0 0">
      <span style="font-size:12px;">
        <input type="text" value="<%=filePath %>" style="width:400px;" />
      </span>
    </div>
  </div>
  <%} %>
</body>
</html>
