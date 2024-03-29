﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTempEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTempEdit" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>报价模板</title>
	<link rel="stylesheet" href="../RichText/css/reset.css">
	<link rel="stylesheet" href="../RichText/css/QuoteTemplate.css">
       <link href="../Content/Quote.css" rel="stylesheet" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <style>.bord{border-bottom: 1px solid #eaeaea;border-top: 1px solid #eaeaea;}</style>
</head>
<body>
	<!--顶部 内容和帮助-->
	<div class="TitleBar">
		<div class="Title">
			<span class="text1">发票模板</span>
			<span class="text2">--<%=tempinfo.name %></span>
			<a href="###" class="help"></a>
		</div>
	</div>
	<!--中间form表单-->
	<form method="post" id="form1" runat="server">
		<div></div>
		<!--按钮部分-->
		<div class="ButtonContainer">
			<ul id="btn">
				<li class="Button ButtonIcon Save NormalState" id="SaveAndCloneButton" tabindex="0">
					<span class="Icon SaveAndClone"></span>
                    <asp:Button ID="Save_Close" cssclass="Text" BorderStyle="None" runat="server" Text="保存并关闭" OnClick="Save_Close_Click" />
				</li>
				<li class="Button ButtonIcon Save NormalState" id="SaveButton" tabindex="0">
					<span class="Icon Save"></span>
                    <asp:Button ID="Save" cssclass="Text" BorderStyle="None" runat="server" Text="保存" OnClick="Save_Click" />
				</li>
				<li class="Button ButtonIcon Pdf NormalState" id="ViewPdfButton" tabindex="0">
					<span class="Icon ViewPdf"></span>
					<span class="Text">PDF显示</span>
				</li>
				<li class="Button ButtonIcon Edit NormalState" id="EditPropertiesButton" tabindex="0">
					<span class="Icon EditProperties"></span>
					<span class="Text">修改模板属性</span>
				</li>
				<li class="Button ButtonIcon Appendix NormalState" id="EditAppendixButton" tabindex="0">
					<span class="Icon EditAppendix"></span>
					<span class="Text">编辑附录</span>
				</li>
				<li class="Button ButtonIcon Cancel NormalState" id="CancelButton" tabindex="0">
					<span class="Icon CancelButton"></span>
                    <asp:Button ID="Cancel" cssclass="Text" BorderStyle="None" runat="server" Text="取消" OnClick="Cancel_Click" />
				</li>
			</ul>
		</div>
		<!--中间主体部分-->
		<div class="ScrollingContainer">
			<div class="ImageHotspotContainer" style="height:1361px;width:815px;">
				<div class="Image">
					<div class="ImageHotspot" style="height: 60px; top: 0px;" id="a1">
						<div class="SimpleLabel" id="b1">报价页眉</div>
						<asp:Literal ID="head" runat="server"></asp:Literal>
						<div class="CompleteLabel" id="c1">
							<div class="Compact Information">
                                <%--<div class="Title1">报价页眉</div>--%>
								<div class="IntendedAction">编辑</div>
							</div>
						</div>
					</div>
					<div class="ImageHotspot" style="height: 400px; top: 60px;" id="a2">
						<div class="SimpleLabel Small" id="b2">报价头部</div>
                        <asp:Literal ID="top" runat="server"></asp:Literal>

						<div class="CompleteLabel" id="c2">
							<div class="Compact Information">
                                <div class="Title1">报价头部</div>
								<div class="IntendedAction">编辑</div>
							</div>
						</div>
					</div>
					<div class="ImageHotspot" style="height: 470px;top:460px;" id="a3">
						<div class="SimpleLabel" id="b3">报价主体</div>                        
                        <asp:Literal ID="body" runat="server"></asp:Literal>
						<div class="CompleteLabel" id="c3">
							<div class="Information">
								<div class="Title1">报价主体</div>
								<div class="Description"></div>
								<div class="IntendedAction">编辑</div>
							</div>
						</div>
					</div>
					<div class="ImageHotspot" style="height: 400px;top:930px" id="a4">
						<div class="SimpleLabel" id="b4">报价底部</div>
                        <asp:Literal ID="bottom" runat="server"></asp:Literal>
						<div class="CompleteLabel" id="c4">
							<div class="Compact Information">
								<div class="Title1">报价底部</div>
								<div class="Description"></div>
								<div class="IntendedAction">编辑</div>
							</div>
						</div>
					</div>
					<div class="ImageHotspot" style="height: 60px;top:1331px" id="a5">
						<div class="SimpleLabel" id="b5">页脚</div>
                        <asp:Literal ID="foot" runat="server"></asp:Literal>
						<div class="CompleteLabel" id="c5">
							<div class="Compact Information">
								<div class="IntendedAction">编辑</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    	<script type="text/javascript" src="../RichText/js/QuoteTemplate.js"></script>
    <script type="text/javascript">
        //点击跳转编辑  进入富文本编辑器
        $("#a1").on("click", function () {
            window.location.href = "InvoiceTempTop.aspx?op=head&id="+<%=id%>+"";
        })
        $("#a2").on("click", function () {
            window.location.href = "InvoiceTempTop.aspx?op=top&id=" +<%=id%>+"";
        })
        $("#a3").on("click", function () {
            window.location.href = "InvoiceTempBody.aspx?id=" +<%=id%>+"";
        })
        $("#a4").on("click", function () {
            window.location.href = "InvoiceTempBottom.aspx?id=" +<%=id%>+"";
        })
        $("#a5").on("click", function () {
            window.location.href = "InvoiceTempTop.aspx?op=foot&id=" +<%=id%>+"";
        });
        //编辑属性
        $("#EditPropertiesButton").on("click", function () {
            window.open("InvoiceTemplateAttr.aspx?id=" +<%=id%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceTemplateAttr %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        });
        //修改附录
        $("#EditAppendixButton").on("click", function () {
            window.location.href = "InvoiceTempTop.aspx?op=appendix&id=" +<%=id%>+"";
        }); 
    </script>
</body>
</html>