<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteLost.aspx.cs" Inherits="EMT.DoneNOW.Web.Quote.QuoteLost" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>丢失报价</title>
    <link rel="stylesheet" href="../Content/reset.css"/>
    <link rel="stylesheet" href="../Content/LostQuote.css"/>
</head>
<body>
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">丢失报价</span>
        </div>
    </div>
    <div class="Instructions">
        <div class="InstructionItem">报价对应的商机将会设置为“丢失”状态。</div>
        <%if (needReasonType != EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE) { %>
        <div class="InstructionItem">请选择商机丢失原因。</div>
        <%} %>
        <%if (needReasonType == EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL) { %>
        <div class="InstructionItem">请输入商机丢失原因详情。</div>
        <%} %>
    </div>
    <form id="form1" runat="server">
        <div class="ScrollingContainer">
            <div class="Medium">
                <div class="Content">
                    <div class="Normal">
                        <%if (needReasonType != EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE) { %>
                        <div class="EditorLabelContainer Editor">
                            <div class="Label">
                                <label>丢失原因</label>
                                <span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Normal Editor SingleSelect">
                            <div class="InputField">
                                <asp:DropDownList ID="LossReasonList" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <%} %>
                        <%if (needReasonType == EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL) { %>
                        <div class="EditorLabelContainer Editor">
                            <div class="Label">
                                <label>丢失原因详情</label>
                                <span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Normal Editor TextArea">
                            <div class="InputField">
                                <textarea class="area" name="LossReasonDetail" id="LossReasonDetail"><%=lossReason %></textarea>
                            </div>
                        </div>
                        <%} %>
                    </div>
                </div>
            </div>
        </div>
        <p>
            <asp:Button ID="Finish" runat="server" Text="完成" OnClick="Finish_Click" />
        </p>
    </form>
</body>
</html>
