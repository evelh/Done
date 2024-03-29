﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTemplateFootEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplateFootEdit" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FootEdit</title>
    <link rel="stylesheet" href="../RichText/css/reset.css">
    <link rel="stylesheet" href="../RichText/css/FootEdit.css">
</head>
<body>
    <!--顶部  内容和帮助-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">报价模板</span>
            <span class="text2"><%=qtb.GetQuoteTemplate(id).name %></span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--中间form表单-->
    <form runat="server" method="post" id="EditQuoteTemplate">
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
                    <%--<span class="Text">取消</span>--%>
                </li>
            </ul>
        </div>
    <div class="Section">
        <div class="Heading">页脚</div>
        <div class="DescriptionText">这是页脚</div>
        <div class="Content">
            <script id="containerHead" name="content" type="text/plain"></script>
            <div class="Dialog">
                <img src="../RichText/img/Dialog.png" alt="">
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
            </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
     <%--<script type="text/javascript" src="../RichText/js/jquery-3.2.1.min.js"></script>--%>
    <script type="text/javascript" src="../RichText/js/ueditor.config.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.all.js"></script>
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
            ue.setContent("<%= page_foot%>");
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
        });

        function dbclick(val) {
            UE.getEditor('containerHead').focus();
            UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
            $("#BackgroundOverLay").hide();
            $(".AlertBox").hide();
        }

//        点击确定数据保存至后台  在展示页展示
        $("#OkButton1").on("click",function(){
            var html = ue.getContent();
            console.log(html);
            $("#data").val($('<div/>').text(html).html());
            var txt = ue.getContentTxt();
            console.log(txt);
        })

//        点击取消直接返回
<%--        $("#CancelButton").on("click",function(){
            window.location.href = "QuoteTemplateEdit.aspx?id=" +<%=id%>+"&op=edit";
        })--%>

    </script>
</body>
</html>