<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteView.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/Quote.css" rel="stylesheet" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <style>.bord{border-bottom: 1px solid #eaeaea;border-top: 1px solid #eaeaea;}</style>
    <title>查看报价单</title>
</head>
<body>
     <div class="TitleBar">
        <div class="Title">
            <span class="text1">查看报价单</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <form id="form1" runat="server">
         <div class="ButtonContainer header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="Save" runat="server" Text="保存" cssclass="Text" BorderStyle="None" OnClick="Save_click" />
                </li>
                <li class="Button" id="PrintButton" tabindex="0">
                    <span class="Icon Print"></span>
                </li>
                <li class="Button" id="ViewPdfButton" tabindex="0">
                    <span class="Icon ViewPdf"></span>
                    <span class="Text">PDF预览</span>
                </li>
                <li class="Button" id="RefreshButton" tabindex="0">
                    <span class="Icon Refresh"></span>
                </li>
                 <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <asp:Button ID="Close" runat="server" Text="关闭" cssclass="Text" BorderStyle="None" OnClick="Close_click" />
                </li>
                <li class="Button" id="GroupButton" tabindex="0">
                    <span class="Text">发布报价</span>
                    <span class="Icon Right"></span>
                </li>
                <!--下拉菜单-->
                <li class="DropDownButton">
                    <div style="padding:10px 0;">
                        <div class="Group">
                            <div class="Button1" id="QuickPublishButton" tabindex="0">
                                <span class="Text">立即发布</span>
                            </div>
                            <div class="Button1" id="PublishManuallyButton" tabindex="0">
                                <span class="Text">手工发布</span>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>
        </div>
    <!--内容部分-->
    <div class="ScrollingContainer">
        <div class="CustomHtmlPrintContainer">
            <div class="PreviewQuote_QuoteTemplateDropdown">
                <asp:ScriptManager ID="ScriptManager1" runat="server">
         </asp:ScriptManager>
         <asp:UpdatePanel ID="UpdatePanel2" runat="server" ChildrenAsTriggers="True">
             <ContentTemplate>
                <asp:DropDownList ID="quoteTemplateDropDownList" runat="server" OnSelectedIndexChanged="quoteTemplateDropDownList_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
            <div id="quoteTemplateDiv">
                <asp:Literal ID="table" runat="server"></asp:Literal>
               <%-- 此处写表格显示数据--%>
            </div>
                   </ContentTemplate>
         </asp:UpdatePanel>  
        </div>
    </div>
</div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript">
        $("#PrintButton").on("mouseover",function(){
            $("#PrintButton").css("background","#fff");
        });
        $("#PrintButton").on("mouseout",function(){
            $("#PrintButton").css("background","#f0f0f0");
        });
        $("#SaveButton").on("mouseover",function(){
            $("#SaveButton").css("background","#fff");
        });
        $("#SaveButton").on("mouseout",function(){
            $("#SaveButton").css("background","#f0f0f0");
        });
        $("#ViewPdfButton").on("mouseover",function(){
            $("#ViewPdfButton").css("background","#fff");
        });
        $("#ViewPdfButton").on("mouseout",function(){
            $("#ViewPdfButton").css("background","#f0f0f0");
        });
        $("#RefreshButton").on("mouseover",function(){
            $("#RefreshButton").css("background","#fff");
        });
        $("#RefreshButton").on("mouseout",function(){
            $("#RefreshButton").css("background","#f0f0f0");
        });
        $("#CancelButton").on("mouseover",function(){
            $("#CancelButton").css("background","#fff");
        });
        $("#CancelButton").on("mouseout",function(){
            $("#CancelButton").css("background","#f0f0f0");
        });
        $("#GroupButton").on("mouseover",function(){
            $("#GroupButton").css("background","#fff");
            $("#GroupButton").css("border-bottom","0px");
            $(".DropDownButton").show();
            $(".DropDownButton").css("border-top","0px");
        });
        $("#GroupButton").on("mouseout",function(){
            $("#GroupButton").css("background","#f0f0f0");
            $("#GroupButton").css("border-bottom","1px solid #d7d7d7");
            $(".DropDownButton").hide();
            $(".DropDownButton").css("border-top","1px solid #d7d7d7");
        });
        $(".DropDownButton").on("mouseover",function(){
            $("#GroupButton").css("background","#fff");
            $("#GroupButton").css("border-bottom","0px");
            $(".DropDownButton").show();
            $(".DropDownButton").css("border-top","0px");
        });
        $(".DropDownButton").on("mouseout",function(){
            $("#GroupButton").css("background","#f0f0f0");
            $("#GroupButton").css("border-bottom","1px solid #d7d7d7");
            $(".DropDownButton").hide();
            $(".DropDownButton").css("border-top","1px solid #d7d7d7");
        });
        $("#QuickPublishButton").on("mouseover",function(){
            $(this).css("background","#E9F0F8");
        });
        $("#QuickPublishButton").on("mouseout",function(){
            $(this).css("background","#FFF");
        });
        $("#PublishManuallyButton").on("mouseover",function(){
            $(this).css("background","#E9F0F8");
        });
        $("#PublishManuallyButton").on("mouseout",function(){
            $(this).css("background","#FFF");
        });
        //加载函数
        function loading(){
            var mask = $('<div id="BackgroundOverLay">'+'</div>');
            var load = $('<div id="LoadingIndicator">'+'</div>');
            $("body").prepend(load).prepend(mask);
            $("#BackgroundOverLay").show();
            $("#LoadingIndicator").show();
            setTimeout(function(){
                $("#BackgroundOverLay").remove();
                $("#LoadingIndicator").remove();
            },1000)
        }
            $("#quoteTemplateDropDownList").change(function(){
                console.log("1");
                loading();
            })

    </script>
</body>
</html>
