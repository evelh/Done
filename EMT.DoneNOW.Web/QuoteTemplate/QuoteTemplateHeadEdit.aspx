<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTemplateHeadEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplateHeadEdit" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HeadEdit</title>
    <link rel="stylesheet" href="../RichText/css/reset.css">
    <link rel="stylesheet" href="../RichText/css/HeadEdit.css">
</head>
<body>
    <!--顶部  内容和帮助-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">报价模板</span>
            <span class="text2">- burberryquotetemplate</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--中间form表单-->
    <form  method="post" id="EditQuoteTemplate" runat="server">
        <div></div>
        <!--按钮部分-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok"></span>
                   <%-- <span class="Text">确认</span>--%>
                    <asp:Button ID="OkButton1" runat="server" Text="确认" cssclass="Text" BorderStyle="None" OnClick="Save" />
                    <input id="data" type="hidden" name="data" value=""/>
                  <%--  <asp:TextBox ID="data" runat="server" Visible="False" Text="123"></asp:TextBox>--%>
                </li>
                <li class="Button ButtonIcon Cancel NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                  <%--  <asp:Button ID="cancel" runat="server" Text="取消" cssclass="Text" BorderStyle="None" OnClick="Cancel"/>--%>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
    </form>
    <div class="Section">
        <div class="Heading">头部</div>
        <div class="DescriptionText">这是头部</div>
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
                    <select name="" id="AlertVariableFilter">
                        <option value="1">Show All Variables</option>
                        <option value="2">Show Account Variables</option>
                        <option value="3">Show Contact Variables</option>
                        <option value="4">Show Opportunity Variables</option>
                        <option value="5">Show Quote Variables</option>
                        <option value="6">Show Miscellaneous Variables</option>
                        <option value="7">Show Your Company Variables</option>
                        <option value="8">Show Your Location Variables</option>
                    </select>
                    <select name="" multiple="multiple" id="AlertVariableList">
                        <option value="" class="val">1</option>
                        <option value="" class="val">2</option>
                        <option value="" class="val">3</option>
                        <option value="" class="val">4</option>
                        <option value="" class="val">5</option>
                        <option value="" class="val">6</option>
                        <option value="" class="val">7</option>
                        <option value="" class="val">8</option>
                        <option value="" class="val">9</option>
                        <option value="" class="val">10</option>
                        <option value="" class="val">1</option>
                        <option value="" class="val">2</option>
                        <option value="" class="val">3</option>
                        <option value="" class="val">4</option>
                        <option value="" class="val">5</option>
                        <option value="" class="val">6</option>
                        <option value="" class="val">7</option>
                        <option value="" class="val">8</option>
                        <option value="" class="val">9</option>
                        <option value="" class="val">10</option>
                    </select>
                </div>
            </div>
        </div>
    </div>
    <!--黑色幕布-->
    <div id="BackgroundOverLay"></div>



    <script src="../Scripts/jquery-3.1.0.min.js"></script>
<%-- <script type="text/javascript" src="../RichText/js/jquery-3.2.1.min.js"></script>--%>
    <script type="text/javascript" src="../RichText/js/ueditor.config.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.all.js"></script>
    <script>
        $("#OkButton").on("mouseover", function () {
            $("#OkButton").css("background", "#fff");
        })
        $("#OkButton").on("mouseout", function () {
            $("#OkButton").css("background", "#f0f0f0");
        })
        $("#CancelButton").on("mouseover", function () {
            $("#CancelButton").css("background", "#fff");
        })
        $("#CancelButton").on("mouseout", function () {
            $("#CancelButton").css("background", "#f0f0f0");
        })

        //        富文本编辑器
        var ue = UE.getEditor('containerHead', {
            toolbars: [
                ['source', 'fontfamily', 'fontsize', 'bold', 'italic', 'underline', 'fontcolor', 'backcolor', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 'insertimage', 'undo', 'redo']
            ],
            initialFrameHeight: 300,//设置编辑器高度
            initialFrameWidth: 780, //设置编辑器宽度
            wordCount: false,
            elementPathEnabled : false,
            autoHeightEnabled: false  //设置滚动条
        });
        ue.ready(function () {
            ue.setContent("<%= page_head%>");
            //获取html内容  返回：<p>内容</p>
            var html = ue.getContent();
            //获取纯文本内容  返回：内容
            var txt = ue.getContentTxt();
            $(".Dialog").on("click", function () {
                $("#BackgroundOverLay").show();
                $(".AlertBox").show();
            });
            $(".CancelDialogButton").on("click", function () {
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            });

            $(".val").on("dblclick", function () {
                UE.getEditor('containerHead').focus();
                UE.getEditor('containerHead').execCommand('inserthtml', $(this).html());
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            })
        });

        //        点击确定数据保存至后台  在展示页展示
        $("#OkButton1").on("click", function () {
            var html = ue.getContent();
            console.log(html);
            $("#data").val($('<div/>').text(html).html());
            var txt = ue.getContentTxt();
            console.log(txt);
        });
        //        点击取消直接返回
        $("#CancelButton").on("click", function () {
            window.location.href = "QuoteTemplateEdit.aspx?id="+<%=id%>+"&op=edit";
        });

    </script>
</body>
</html>
