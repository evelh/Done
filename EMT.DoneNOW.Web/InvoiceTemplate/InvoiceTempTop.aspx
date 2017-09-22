<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTempTop.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTempTop" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../RichText/css/reset.css" rel="stylesheet" />
    <link href="../RichText/css/QuoteTop.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form method="post" id="EditQuoteTemplate" runat="server">
        <div>
             <!--顶部  内容和帮助-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">发票模板--<%=opop%></span>
            <span class="text2">--<%=tempinfo.name %></span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--中间form表单-->
        <div></div>
        <!--按钮部分-->
        <div class="ButtonContainer">
           <ul id="btn">
                <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok"></span>
                     <asp:Button ID="OkButton1" runat="server" Text="确认" cssclass="Text" BorderStyle="None" OnClick="Save" />
                    <input id="data" type="hidden" name="data" value=""/>
                </li>
                <li class="Button ButtonIcon Cancel NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                     <asp:Button ID="cancel" runat="server" Text="取消" cssclass="Text" BorderStyle="None" OnClick="Button1_Click"/>
                </li>
               <%if (op == "top")
                   { %>
                <li class="Button ButtonIcon Reset NormalState" id="ResetButton" tabindex="0">
                    <span class="Icon Reset"></span>
                    <span class="Text">恢复默认内容</span>
                </li>
               <%} %>
            </ul>
        </div>
<div style="position: absolute;left: 0;overflow-x: auto;overflow-y: auto;right: 0;top: 82px;bottom: 0px;">
    <div class="Section">
        <div class="Heading">发票模板--<%=opop %></div>
        <div class="DescriptionText"></div>
        <div class="Content">
            <script id="containerHead" name="content" type="text/plain"></script>
            <div class="Dialog">
                <img src="../RichText/img/Dialog.png" alt=""/>
            </div>
        </div>
    </div>
                </div>
    <div class="AlertBox">
        <div>
            <div class="CancelDialogButton"></div>
            <div class="AlertTitleBar">
                <div class="AlertTitle">
                    <span>变量</span>
                </div>
            </div>
            <div class="VariableInsertion">
                <div class="AlertContent">
               <div class="AlertContentTitle">这是弹出的变量内容，可双击选择</div>

                     <asp:ScriptManager ID="ScriptManager1" runat="server">
         </asp:ScriptManager>
         <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="True">
             <ContentTemplate>
              <asp:DropDownList ID="AlertVariableFilter" runat="server" OnSelectedIndexChanged="AlertVariableFilter_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>              
                 <select name="" multiple="multiple" id="AlertVariableList">
                         <asp:Literal ID="VariableList" runat="server"></asp:Literal>
                    </select>
             </ContentTemplate>
         </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>
    <!--黑色幕布-->
    <div id="BackgroundOverLay"></div>
    <!--默认数据-->
            <script src="../Scripts/jquery-3.1.0.min.js"></script>
            <script src="../RichText/js/ueditor.config.js"></script>
            <script src="../RichText/js/ueditor.all.js"></script>
    <script>
        $("#OkButton").on("mouseover",function(){
            $("#OkButton").css("background","#fff");
        })
        $("#OkButton").on("mouseout",function(){
            $("#OkButton").css("background","#f0f0f0");
        })
        $("#CancelButton").on("mouseover",function(){
            $("#CancelButton").css("background","#fff");
        })
        $("#CancelButton").on("mouseout",function(){
            $("#CancelButton").css("background","#f0f0f0");
        })
        $("#ResetButton").on("mouseover",function(){
            $("#ResetButton").css("background","#fff");
        })
        $("#ResetButton").on("mouseout",function(){
            $("#ResetButton").css("background","#f0f0f0");
        })
        //        富文本编辑器
        var ue = UE.getEditor('containerHead',{
            toolbars: [
                ['source','fontfamily', 'fontsize', 'bold', 'italic', 'underline','fontcolor','backcolor','justifyleft','justifycenter','justifyright','insertorderedlist','insertunorderedlist','insertimage','undo','redo']
            ],
            initialFrameHeight:300,//设置编辑器高度
            initialFrameWidth:780, //设置编辑器宽度
            wordCount:false,
            elementPathEnabled : false,
            autoHeightEnabled:false  //设置滚动条
        });
        ue.ready(function(){
            //获取html内容  返回：<p>内容</p>
            ue.setContent("<%= head%>");
            var html = ue.getContent();
            //获取纯文本内容  返回：内容
            var txt = ue.getContentTxt();
            $(".Dialog").on("click",function(){
                $("#BackgroundOverLay").show();
                $(".AlertBox").show();
            });
            $(".CancelDialogButton").on("click",function(){
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            });

            $(".val").on("dblclick",function(){
                UE.getEditor('containerHead').focus();
                UE.getEditor('containerHead').execCommand('inserthtml',$(this).html());
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            });
            var Model=
                    '<style type="text/css">'+
                        '#LogoBlock'+
                        '{'+
                            'width: 100%;'+
                            'padding-bottom: 30px;'+
                        '}'+
                        '#ServiceProviderBlock'+
                        '{'+
                            'padding-bottom: 30px;'+
                        '}'+
                        '#InvoiceInfoBlock'+
                        '{'+
                            'display: table;'+
                            'padding-left: 40px;'+
                        '}'+
                        '.boxHeader'+
                        '{'+
                            'border: 1px solid black;'+
                            'background-color: #f7f7f7;'+
                            'font-weight: bold;'+
                            'padding: 5px 5px 5px 5px;'+
                        '}'+
                        '.boxBody'+
                        '{'+
                            'border-right: 1px solid black;'+
                            'border-left: 1px solid black;'+
                            'border-bottom: 1px solid black;'+
                            'padding: 5px 5px 5px 5px;'+
                        '}'+
                        '.invoiceInfoRow'+
                        '{'+
                        '}'+
                        '.invoiceInfoNameCell'+
                        '{'+
                        '}'+
                        '.invoiceInfoValueCell'+
                        '{'+
                        '}'+
                    '</style>'+
                    '<table style="width:100%; border-collapse:collapse;font-size:12px;">'+
                    '<tbody><tr>'+
                    '<td width="100%" colspan="2">'+
                    '<div style="width:100%;padding-bottom: 30px;">[Miscellaneous: Primary Logo]</div>'+
            '</td>'+
            '</tr>'+
            '<tr>'+
            '<td width="50%">'+
                    '<div style="padding-bottom: 30px;">'+
                    '[Your Company: Name]<br>'+
            '[Your Company: Address]'+
            '<br>'+
            '[Your Company: Phone]<br>'+
            'Fax: [Your Company: Fax]'+
            '<div>[Your Company: Tax ID, ACN, ABN, VAT, etc.]</div>'+
            '</div>'+
            '<div>'+
                    '<div style="width: 70%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;">Bill To</div>'+
            '<div style="width: 70%;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;">'+
                    '[Account: Name] [Billing: Attention]<br>'+
            '[Billing: Address]'+
            '</div>'+
            '</div>'+
            '</td>'+
            '<td width="50%" valign="bottom">'+
                    '<div style="float:right;display: table;padding-left: 40px;">'+
                    '<div style="display: table-row;height: 20px">'+
                    '<div style="font-weight: bold;text-align: right;display: table-cell"></div>'+
                    '<div style="text-align: left;display: table-cell;padding-left: 5px;">'+
                    '<div style="height: 70px;">'+
                    '<div style="width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;">Date</div>'+
                    '<div style="width: 120px; text-align: center;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;border-right: 1px solid black;">[Invoice: Date]</div>'+
            '</div>'+
            '</div>'+
            '</div>'+
            '<div style="display: table-row;height: 20px">'+
                    '<div style="font-weight: bold;text-align: right;display: table-cell">Invoice Number:</div>'+
            '<div style="text-align: left;display: table-cell;padding-left: 5px;">[Invoice: Number/ID]</div>'+
            '</div>'+
            '<div style="display: table-row;height: 20px">'+
                '<div style="font-weight: bold;text-align: right;display: table-cell">Invoice Date Range:</div>'+
                '<div style="text-align: left;display: table-cell;padding-left: 5px;">[Invoice: Date Range From] to [Invoice: Date Range To]</div>'+
            '</div>'+
            '<div style="display: table-row;height: 20px">'+
                '<div style="font-weight: bold;text-align: right;display: table-cell">Purchase Order Number:</div>'+
                '<div style="text-align: left;display: table-cell;padding-left: 5px;">[Invoice: Purchase Order Number]</div>'+
            '</div>'+
            '<div style="display: table-row;height: 20px">'+
                '<div style="font-weight: bold;text-align: right;display: table-cell">Payment Terms:</div>'+
                '<div style="text-align: left;display: table-cell;padding-left: 5px;">[Invoice: Payment Terms]</div>'+
            '</div>'+
            '<div style="display: table-row;height: 20px">'+
                '<div style="font-weight: bold;text-align: right;display: table-cell">Payment Due:</div>'+
                '<div style="text-align: left;display: table-cell;padding-left: 5px;">[Invoice: Payment Due Date]</div>'+
            '</div>'+
            '</div>'+
            '</td>'+
            '</tr>'+
            '</tbody></table>';
            ue.setContent(Model);
        });
        //        点击确定数据保存至后台  在展示页展示
        $("#OkButton1").on("click", function () {
            var html = ue.getContent();
            console.log(html);
            $("#data").val($('<div/>').text(html).html());
            var txt = ue.getContentTxt();
            console.log(txt);
        });
        //情空内容
        $("#ResetButton").on("click",function(){
            ue.setContent('')
        })
    </script>
        </div>
    </form>
</body>
</html>
