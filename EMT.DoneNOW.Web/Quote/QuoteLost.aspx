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
        <div class="InstructionItem">这个报价的条件将被设置为“丢失”。</div>
        <div class="InstructionItem">请为这个报价的机会选择一个损失原因。</div>
        <div class="InstructionItem">请为这个报价的机会输入一个损失原因细节。</div>
    </div>
    <form action="post">
        <div class="ScrollingContainer">
            <div class="Medium">
                <div class="Content">
                    <div class="Normal">
                        <div class="EditorLabelContainer Editor">
                            <div class="Label">
                                <label>丢失原因</label>
                                <span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Normal Editor SingleSelect">
                            <div class="InputField">
                                <select name="LossReasonList" id="LossReasonList">
                                    <option></option>
                                    <option value="1" title="Need">Need</option>
                                    <option value="2" title="Timing">Timing</option>
                                    <option value="3" title="Price" selected="selected">Price</option>
                                    <option value="4" title="Competition">Competition</option>
                                    <option value="5" title="Feature">Feature</option>
                                    <option value="6" title="Poor qualification">Poor qualification</option>
                                </select>
                            </div>
                        </div>
                        <div class="EditorLabelContainer Editor">
                            <div class="Label">
                                <label>丢失原因详情</label>
                                <span class="Required">*</span>
                            </div>
                        </div>
                        <div class="Normal Editor TextArea">
                            <div class="InputField">
                                <textarea class="area" name="LossReasonDetail" id="LossReasonDetail"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
