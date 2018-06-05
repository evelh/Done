<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteAndInvoiceEmailTempl.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteAndInvoiceEmailTempl" %>

<%--发票和报价的邮件模板(未完成变量替换)--%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/EmailTempl.css" rel="stylesheet" />
    <style>
        .header-title {
            width: 100%;
            margin: 10px;
            width: auto;
            height: 30px;
        }

            .header-title ul li {
                position: relative;
                height: 30px;
                line-height: 30px;
                padding: 0 10px;
                float: left;
                margin-right: 10px;
                border: 1px solid #CCCCCC;
                cursor: pointer;
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            }

                .header-title ul li input {
                    height: 28px;
                    line-height: 28px;
                }

                .header-title ul li:hover ul {
                    display: block;
                }

                .header-title ul li .icon-1 {
                    width: 16px;
                    height: 16px;
                    display: block;
                    float: left;
                    margin-top: 7px;
                    margin-right: 5px;
                }

                .header-title ul li ul {
                    display: none;
                    position: absolute;
                    left: -1px;
                    top: 28px;
                    border: 1px solid #CCCCCC;
                    background: #F5F5F5;
                    width: 160px;
                    padding: 10px 0;
                    z-index: 99;
                }

                    .header-title ul li ul li {
                        float: none;
                        border: none;
                        background: #F5F5F5;
                        height: 28px;
                        line-height: 28px;
                    }

                .header-title ul li input {
                    outline: none;
                    border: none;
                    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                }

        .icon-1 {
            width: 16px;
            height: 16px;
            display: block;
            float: left;
            margin-top: 7px;
            margin-right: 5px;
        }

        .Fuwenben {
            position: relative;
        }

            .Fuwenben div {
                padding-bottom: 0 !important;
            }

        .Dialog {
            width: 21px;
            height: 20px;
            background: #fafafa;
            position: absolute;
            left: 514px;
            top: 4px;
            z-index: 1000;
            border: 1px solid #fafafa;
        }

            .Dialog:hover {
                border: 1px solid #dcac6c;
                background: #ffe69f;
            }
        /*弹出框内容*/
        .AlertBox {
            width: 486px;
            height: 450px;
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            margin: auto;
            background-color: #b9b9b9;
            border: solid 4px #b9b9b9;
            z-index: 2000;
            display: none;
        }

            .AlertBox > div, .AlertMessage > div {
                background-color: #fff;
                bottom: 0;
                left: 0;
                position: absolute;
                right: 0;
                top: 0;
            }

        .CancelDialogButton {
            background-image: url(../Images/cancel1.png);
            background-position: 0 -32px;
            border-radius: 50%;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
        }

        .AlertTitleBar {
            color: #fff;
            background-color: #346a95;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

        .AlertTitle {
            top: 0;
            height: 36px;
            left: 10px;
            overflow: hidden;
            position: absolute;
            text-overflow: ellipsis;
            text-transform: uppercase;
            white-space: nowrap;
            width: 80%;
        }

        .AlertContent {
            top: 46px;
            bottom: 0px;
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: absolute;
            right: 0;
            padding: 0 10px 0 10px;
        }

        .AlertContentTitle {
            padding-bottom: 5px;
            color: #666;
            font-size: 12px;
            overflow: hidden;
        }

        select {
            color: #333;
            height: 24px;
            margin: 0;
            padding: 0;
            white-space: nowrap;
            border: 1px solid #d7d7d7;
            font-size: 12px;
            resize: vertical;
        }

        #AlertVariableFilter {
            margin-bottom: 5px;
            width: 410px;
        }

        #AlertVariableList {
            height: 249px;
            width: 410px;
        }

        select option {
            line-height: 16px;
        }
        /*加载的css样式*/
        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 25;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }

        #LoadingIndicator {
            width: 100px;
            height: 100px;
            background-image: url(img/Loading.gif);
            background-repeat: no-repeat;
            background-position: center center;
            z-index: 30;
            margin: auto;
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            display: none;
        }
        /*弹出信息*/
        .AlertMessage {
            height: 169px;
            margin-left: -247px;
            margin-top: -89px;
            z-index: 10003;
            width: 486px;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: #b9b9b9;
            border: solid 4px #b9b9b9;
            display: none;
        }

        .ScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            padding: 0 10px 0 10px;
            position: absolute;
            right: 0;
        }

            .ScrollingContainer .Medium {
                width: 446px;
                padding: 12px 0 5px 0;
                border: none;
                margin: 0 0 12px 0;
            }

                .ScrollingContainer .Medium .Content {
                    padding-top: 0;
                    padding-left: 28px;
                    padding-right: 28px;
                }

        .StandardText {
            font-size: 12px;
            line-height: 16px;
            padding-bottom: 7px;
        }

        .Confirmation {
            padding: 20px 0 0 0;
            width: auto;
            height: 26px;
        }
        input[type=text]{
            width:280px;
        }
    </style>
    <title></title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1"><%=typename %></span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--按钮-->
            <div class="ButtonContainer header-title">
                <ul id="btn">
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="Save_Close_Click" />
                    </li>
                    <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                        <asp:Button ID="Cancel" OnClientClick="window.close();" runat="server" Text="取消" BorderStyle="None" />
                    </li>
                </ul>
            </div>
             <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 118px;">
            <div class="DivScrollingContainer Tab" style="top: 82px;">
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">基本信息</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="FieldLabel">名称            
                                                    <span class="Required">*</span>
                                                            <div>
                                                                <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                                                                <asp:CheckBox ID="Active" runat="server" Style="vertical-align: middle; margin-left: 50px;" />激活
                                                               <%if (type == (int)EMT.DoneNOW.DTO.QueryType.Quote_Email_Tmpl)
                                                                   { %>
                                                                <asp:CheckBox ID="AttachPdf" runat="server" Style="vertical-align: middle; margin-left: 50px;" />将报价附加为PDF<%} %>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">描述
                                                    <div>
                                                        <asp:TextBox ID="Description" runat="server" TextMode="MultiLine" Height="102px" Width="600px"></asp:TextBox>
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
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle2">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">邮件消息</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="FieldLabel">发送者-姓
                                                    <div>
                                                        <asp:TextBox ID="SendFromFirstName" runat="server"></asp:TextBox>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">发送者-名
                                                    <div>
                                                        <asp:TextBox ID="SendFromLastName" runat="server"></asp:TextBox>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">发送者-邮箱
                                                    <div>
                                                        <asp:TextBox ID="SendFromEmail" runat="server"></asp:TextBox>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">           
                                                    抄送
                                                    <span style="font-weight: normal;">(多个使用英文,号分割)</span>
                                                            <div>
                                                                <asp:TextBox ID="CC" runat="server" TextMode="MultiLine" Style="width: 600px; min-height: 40px;"></asp:TextBox>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">密送
                                                    <span style="font-weight: normal;">(多个使用英文,号分割)</span>
                                                            <div>
                                                                <asp:TextBox ID="BCC" runat="server" TextMode="MultiLine" Style="width: 600px; min-height: 40px;"></asp:TextBox>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            <div>
                                                                <asp:CheckBox ID="BccAccountManager" runat="server"></asp:CheckBox>
                                                                密送客户经理
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">邮件主题
                                                    <span class="Required">*</span>
                                                            <div>
                                                                <asp:TextBox ID="Email_Subject" runat="server"></asp:TextBox><img src="../RichText/img/Dialog.png" style="vertical-align: middle;" id="AddButton" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">邮件格式
                                                    <div style="padding-bottom: 3px;">
                                                        <input type="radio" name="EmailFormat" id="EmailFormatHtml2" style="vertical-align: middle;"<%if (emailtempl.is_html_format != 2)
                                                            { %>
                                                            checked="checked"
                                                            <%} %> />
                                                        <label for="EmailFormatHtml2" style="cursor: pointer;">Html</label>
                                                    </div>
                                                    <div>
                                                        <input type="radio" name="EmailFormat" id="EmailFormatPlaintext2" style="vertical-align: middle;" <%if (emailtempl.is_html_format == 2)
                                                            { %>
                                                            checked="checked"
                                                            <%} %> />
                                                        <label for="EmailFormatPlaintext2" style="cursor: pointer;">纯文本</label>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">邮件正文
                                                    <div class="Fuwenben">
                                                        <script id="containerHead" name="content" type="text/plain"></script>
                                                        <div class="Dialog">
                                                            <img src="../RichText/img/Dialog.png" />
                                                        </div>
                                                    </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">发送测试邮件到
                                                    <span style="font-weight: normal;">(多个使用英文,号分割)</span>
                                                            <div>
                                                                <textarea name="CarbonCopyEmailAddress" style="width: 600px; min-height: 40px;"></textarea>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div>
                                                                <asp:Button ID="TestSend" runat="server" Text="发送测试" />
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
            <!--弹框-->
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
            <div class="AlertMessage">
                <div>
                    <div class="CancelDialogButton" id="CancelMessage"></div>
                    <div class="AlertTitleBar">
                        <div class="AlertTitle">
                            <span>信息</span>
                        </div>
                    </div>
                    <div class="VariableInsertion">
                        <div class="ScrollingContainer">
                            <div class="Medium">
                                <div class="Content">
                                    <div style="width: 390px; display: inline-block; vertical-align: top;">
                                        <div class="StandardText">如果切换邮件格式，当前输入的邮件正文内容将会丢失，要继续吗?</div>
                                        <div class="Confirmation">
                                            <a class="Button ButtonIcon">
                                                <span class="Text" id="yes">Yes</span>
                                            </a>
                                            <a class="Button ButtonIcon">
                                                <span class="Text" id="no">No</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>           
             <%-- Body部分的内容--%>
          <input type="hidden" id="bodydata" name="bodydata"/>
          <input type="hidden" id="htmlformat" name="htmlformat" value="<%=emailtempl.is_html_format %>"/>
        </div>
             <!--黑色幕布-->
            <%--<div id="BackgroundOverLay"></div>--%>
            </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
        <script src="../RichText/js/ueditor.config.js"></script>
        <script src="../RichText/js/ueditor.all.js"></script>
        <script src="../Scripts/EmailTempl.js"></script>
        <script>
            $("#_ctl3_chkTaxExempt_ATCheckBox").on("click", function () {
                var _this = $(this);
                if (_this.is(":checked")) {
                    $("#_ctl3_ddlTaxRegion_ATDropDown").prop("disabled", true);
                } else {
                    $("#_ctl3_ddlTaxRegion_ATDropDown").prop("disabled", false);
                }
            });
            $("#_ctl3_rdoAccount").on("click", function () {
                $("#address1").prop("disabled", true);
                $("#address2").prop("disabled", true);
                $("#city").prop("disabled", true);
                $("#state").prop("disabled", true);
                $("#postCode").prop("disabled", true);
                $("#country").prop("disabled", true);
                $("#additionalAddressInformation").prop("disabled", true);
            });
            $("#_ctl3_rdoAccountBillTo").on("click", function () {
                $("#address1").prop("disabled", false);
                $("#address2").prop("disabled", false);
                $("#city").prop("disabled", false);
                $("#state").prop("disabled", false);
                $("#postCode").prop("disabled", false);
                $("#country").prop("disabled", false);
                $("#additionalAddressInformation").prop("disabled", false);
            });

            //        富文本编辑器
            var ue = UE.getEditor('containerHead', {
                //serverUrl: '../Tools/UploadAjax.ashx',
                toolbars: [
                    ['source', 'fontfamily', 'fontsize', 'bold', 'italic', 'underline', 'fontcolor', 'backcolor', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 'insertimage', 'undo', 'redo']
                ],
                initialFrameHeight: 300,//设置编辑器高度
                initialFrameWidth: 612, //设置编辑器宽度
                wordCount: false,
                elementPathEnabled : false,
                autoHeightEnabled: false  //设置滚动条
            });
            //$(".upload-img").InitUploader({ filesize: "10240", sendurl: "../Tools/UploadAjax.ashx", swf: "../RichText/uploader.swf", filetypes: "gif,jpg,jpeg,png,bmp" });
            var _this;
            $("#AddButton").on("click", function () {
                //_this = $(this).previousSbiling;
                _this = $("#Email_Subject");
                $("#BackgroundOverLay").show();
                $(".AlertBox").show();
                //return _this;
            });
            ue.ready(function () {
                //初始化内容
                ue.setContent("<%=BodyContent%>");
                //获取html内容  返回：<p>内容</p>               
                var html = ue.getContent();
                //获取纯文本内容  返回：内容
                var txt = ue.getContentTxt();
                $(".Dialog").on("click", function () {
                    _this = $("#AlertVariableList");
                    $("#BackgroundOverLay").show();
                    $(".AlertBox").show();
                });
                $(".CancelDialogButton").on("click", function () {
                    $("#BackgroundOverLay").hide();
                    $(".AlertBox").hide();
                });
            });
            //双击选中事件
            function dbclick(val) {
                if (_this[0].id == 'Email_Subject') {
                    _this.focus();  
                    _this.val(_this.val()+$(val).html());
                    $("#BackgroundOverLay").hide();
                    $(".AlertBox").hide();
                } else {
                    UE.getEditor('containerHead').focus();
                    UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
                    $("#BackgroundOverLay").hide();
                    $(".AlertBox").hide();
                }               
            }
            //点击确定数据保存至后台  在展示页展示
            function save_deal() {
                if ($("#EmailFormatPlaintext2").is(':checked')) {
                    //获取纯文本内容  返回：内容
                    var txt = ue.getContentTxt();
                    $("#bodydata").val(txt);
                    $("#htmlformat").val("2");
                }
                if ($("#EmailFormatHtml2").is(':checked')) {
                    //获取html内容  返回：<p>内容</p>               
                    var html = ue.getContent();
                    $("#bodydata").val($('<div/>').text(html).html());
                    $("#htmlformat").val("1");
                }
                if ($("#Name").val() == null || $("#Name").val() == '') {
                    alert("请填写名称！");
                    $("#Name").focus();
                    return false;
                }
                if ($("#Email_Subject").val() == null || $("#Email_Subject").val() == '') {
                    alert("请填写邮件模板主体！");
                    $("#Email_Subject").focus();
                    return false;
                }
                return true;
            }
            $("input[name='EmailFormat']").change(function () {
                var _this = $(this);
                $("#BackgroundOverLay").show();
                $(".AlertMessage").show();
                $("#yes").unbind("click").bind("click", function () {
                    ue.setContent('');
                    $("#BackgroundOverLay").hide();
                    $(".AlertMessage").hide();
                });
                $("#no").unbind("click").bind("click", function () {
                    $("#BackgroundOverLay").hide();
                    $(".AlertMessage").hide();
                    if (_this[0].id == 'EmailFormatPlaintext2') {
                        $("#EmailFormatHtml2").prop("checked", true);
                        $("#EmailFormatPlaintext2").prop("checked", false);
                    } else if (_this[0].id == 'EmailFormatHtml2') {
                        $("#EmailFormatPlaintext2").prop("checked", true);
                        $("#EmailFormatHtml2").prop("checked", false);
                    }
                });
                $("#CancelMessage").unbind("click").bind("click", function () {
                    $("#BackgroundOverLay").hide();
                    $(".AlertMessage").hide();
                    if (_this[0].id == 'EmailFormatPlaintext2') {
                        $("#EmailFormatHtml2").prop("checked", true);
                        $("#EmailFormatPlaintext2").prop("checked", false);
                    } else if (_this[0].id == 'EmailFormatHtml2') {
                        $("#EmailFormatPlaintext2").prop("checked", true);
                        $("#EmailFormatHtml2").prop("checked", false);
                    }
                });
            });
        </script>
    </form>
</body>
</html>
