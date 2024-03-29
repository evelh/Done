﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTempTop.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTempTop" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../RichText/css/reset.css" rel="stylesheet" />
    <link href="../RichText/css/QuoteTop.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form method="post" id="form1" runat="server">
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
                <li class="Button ButtonIcon Reset NormalState" id="ResetButton" tabindex="0" style="margin-right: -5px;">
                    <span class="Icon Reset"></span>
                    <span class="Text">恢复默认内容</span>
                </li>
               <!--下拉框-->
                <li class="Button ButtonIcon" id="DownButton" tabindex="0" style="padding: 0;">
                    <span class="Icon Down"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <li class="DropDownButton" style="top:71px;left:137px;" id="Down">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Content">
                                <div class="Button1" id="FirstModel" tabindex="0">
                                    <span class="Text">第一个模板（默认的）</span>
                                </div>
                                <div class="Button1" id="SecondModel" tabindex="0">
                                    <span class="Text">第二个模板</span>
                                </div>
                                <div class="Button1" id="ThirdModel" tabindex="0">
                                    <span class="Text">第三个模板</span>
                                </div>
                            </div>
                        </div>
                    </div>
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
            <div class="Dialog" style="top:42px;">
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
        $("#DownButton").on("mousemove", function () {
            $(this).css("background", "#fff");
            $("#Down").show();
        }).on("mouseout", function () {
            $(this).css("background", "#f0f0f0");
            $("#Down").hide();
        });
        $("#Down").on("mousemove", function () {
            $(this).show();
            $("#DownButton").css("background", "#fff");
        }).on("mouseout", function () {
            $(this).hide();
            $("#DownButton").css("background", "#f0f0f0");
        });
        //富文本编辑器
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
            <%if(opop=="头部"&&string.IsNullOrEmpty(head)){%>
            ue.setContent(Model);
            <%}%>            
        });
        function dbclick(val) {
            UE.getEditor('containerHead').focus();
            UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
            $("#BackgroundOverLay").hide();
            $(".AlertBox").hide();
        }
        //点击确定数据保存至后台  在展示页展示
        $("#OkButton1").on("click", function () {
            var html = ue.getContent();
            console.log(html);
            $("#data").val($('<div/>').text(html).html());
            var txt = ue.getContentTxt();
            console.log(txt);
        });
        //
        $("#ResetButton").on("click",function(){
            ue.setContent("<table style='width:100%; border-collapse:collapse;font-size:12px;'><tbody><tr class='firstRow'><td width='100%' colspan='2' style='word-break: break-all;'><div style='width:100%;padding-bottom: 30px;'>[Miscellaneous: Primary Logo (Requires HTML)]</div></td></tr><tr><td width='50%' style='word-break: break-all;'><div style='padding-bottom: 30px;'><p>[公司名称：名称]</p><p>[公司名称：地址]</p><p>[公司名称：电话]</p><p><br/></p><p>传真：[公司名称：传真]</p><p>[客户：税编号、ACN、ABN、VAT等。]</p><p><br/></p></div><div><div style='width: 70%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Bill To</div><div style='width: 70%;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;'>[客户：名称]&nbsp;[发票：编号]</div></div></td><td width='50%' valign='bottom' style='word-break: break-all;'><div style='float:right;display: table;padding-left: 40px;'><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'></div><div style='text-align: left;display: table-cell;padding-left: 5px;'><div style='height: 70px;'><div style='width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>日期</div><div style='width: 120px; text-align: center;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;border-right: 1px solid black;'>[发票：日期]</div></div></div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票编号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：号码/编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票日期范围:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：日期范围始于] to [发票：日期范围至]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>采购订单号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款期限:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款截止日期:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限截止日期]</div></div></div></td></tr></tbody></table>");
        })
       // ue.setContent(Model1);
        $("#FirstModel").on("click", function () {
            ue.setContent('');
            ue.setContent("<table style='width:100%; border-collapse:collapse;font-size:12px;'><tbody><tr class='firstRow'><td width='100%' colspan='2' style='word-break: break-all;'><div style='width:100%;padding-bottom: 30px;'>[Miscellaneous: Primary Logo (Requires HTML)]</div></td></tr><tr><td width='50%' style='word-break: break-all;'><div style='padding-bottom: 30px;'><p>[公司名称：名称]</p><p>[公司名称：地址]</p><p>[公司名称：电话]</p><p><br/></p><p>传真：[公司名称：传真]</p><p>[客户：税编号、ACN、ABN、VAT等。]</p><p><br/></p></div><div><div style='width: 70%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Bill To</div><div style='width: 70%;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;'>[客户：名称]&nbsp;[发票：编号]</div></div></td><td width='50%' valign='bottom' style='word-break: break-all;'><div style='float:right;display: table;padding-left: 40px;'><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'></div><div style='text-align: left;display: table-cell;padding-left: 5px;'><div style='height: 70px;'><div style='width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>日期</div><div style='width: 120px; text-align: center;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;border-right: 1px solid black;'>[发票：日期]</div></div></div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票编号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：号码/编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票日期范围:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：日期范围始于] to [发票：日期范围至]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>采购订单号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款期限:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款截止日期:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限截止日期]</div></div></div></td></tr></tbody></table>");
        });
        $("#SecondModel").on("click", function () {
            ue.setContent('');
            ue.setContent("<table style='width:100%; border-collapse:collapse;font-size:12px;'><tbody><tr class='firstRow'><td width='100%' colspan='2' style='word-break: break-all;'><div style='width:100%;padding-bottom: 30px;'>[Miscellaneous: Primary Logo (Requires HTML)]</div></td></tr><tr><td width='50%' style='word-break: break-all;'><div style='padding-bottom: 30px;'><p>[客户：名称]</p><p>[客户：名称（链接）]</p><p>[客户：类型]</p><p>[客户：传真]</p><p>[客户：电话]</p><p>[客户：税编号、ACN、ABN、VAT等。]</p><p>[计费：尊称][计费：区县][计费：城市][计费：省]</p><p>[计费：邮政编码][计费：国家][计费：地址]</p><p>[计费：其它地址信息]</p></div><div><div style='width: 70%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Bill To</div><div style='width: 70%;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;'>[客户：名称]&nbsp;[发票：编号]</div></div></td><td width='50%' valign='bottom' style='word-break: break-all;'><div style='float:right;display: table;padding-left: 40px;'><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'></div><div style='text-align: left;display: table-cell;padding-left: 5px;'><div style='height: 70px;'><div style='width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px 5px 5px 5px;'>Date</div><div style='width: 120px; text-align: center;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px 5px 5px 5px;border-right: 1px solid black;'>[发票：日期]</div></div></div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票编号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：号码/编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>发票日期范围:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：日期范围始于] to [发票：日期范围至]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>采购订单号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：编号]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款期限:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限]</div></div><div style='display: table-row;height: 20px'><div style='font-weight: bold;text-align: right;display: table-cell'>付款截止日期:</div><div style='text-align: left;display: table-cell;padding-left: 5px;'>[发票：付款期限截止日期]</div></div></div></td></tr></tbody></table>");
        });
        $("#ThirdModel").on("click", function () {
            ue.setContent('');
            ue.setContent("<table style='margin: auto; border-collapse: collapse;' width='100%'><tbody><tr class='firstRow'><td valign='top' width='80%' style='border: none;padding:0;'><div style='height: 160px;overflow: hidden;padding-left: 25px;padding-top: 0px;font-size: 12px;'><p>[公司名称：名称]</p><p>[公司名称：地址]</p><br/><p>[公司名称：电话]</p><p>传真:&nbsp;[公司名称：传真]</p><div>[[客户：税编号、ACN、ABN、VAT等。]</div></div><div style='padding-left: 25px;'><div style='width: 90%; text-align: left;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px;font-size: 12px;'>Bill To</div><div style='width: 90%;font-size: 12px;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px;height: 90px;'>[客户：名称]&nbsp;[计费：尊称][计费：地址]</div></div></td><td valign='bottom' width='20%' style='border: none;padding:0;'><div style='width: 100%;padding-bottom: 30px;font-size: 12px;'>[Miscellaneous: Primary Logo]</div><div style='display: table-row;'><div style='text-align: left;display: table-cell;padding:0 0 5px 5px;'><div style='width: 120px; text-align: center;border: 1px solid black;background-color: #f7f7f7;font-weight: bold;padding: 5px;font-size: 12px;'>日期</div><div style='width: 120px; text-align: center;border-right: 1px solid black;border-left: 1px solid black;border-bottom: 1px solid black;padding: 5px;font-size: 12px;'>[发票：日期]</div></div></div></td></tr><tr><td style='padding: 20px 0 0 0;border: none;' valign='top' colspan='2' align='right'><div style='display: table;width:100%;'><div style='display: table-row;'><div style='font-weight: bold;text-align: right;display: table-cell;width: 80%;padding-bottom: 5px;font-size: 12px;'>发票编号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;padding-bottom: 5px;font-size: 12px;'>[发票：号码/编号]</div></div><div style='display: table-row;'><div style='font-weight: bold;text-align: right;display: table-cell;width: 80%;padding-bottom: 5px;font-size: 12px;'>发票日期范围:</div><div style='text-align: left;display: table-cell;padding-left: 5px;padding-bottom: 5px;font-size: 12px;'>[发票：日期范围始于]to [发票：日期范围至]</div></div><div style='display: table-row;'><div style='font-weight: bold;text-align: right;display: table-cell;width: 80%;padding-bottom: 5px;font-size: 12px;'>采购订单号:</div><div style='text-align: left;display: table-cell;padding-left: 5px;padding-bottom: 5px;font-size: 12px;'>[发票：订单号]</div></div><div style='display: table-row;'><div style='font-weight: bold;text-align: right;display: table-cell;width: 80%;padding-bottom: 5px;font-size: 12px;'>支付期限:</div><div style='text-align: left;display: table-cell;padding-left: 5px;padding-bottom: 5px;font-size: 12px;'>[发票：付款期限]</div></div><div style='display: table-row;'><div style='font-weight: bold;text-align: right;display: table-cell;width: 80%;padding-bottom: 5px;font-size: 12px;'>付款截止日期:</div><div style='text-align: left;display: table-cell;padding-left: 5px;padding-bottom: 5px;font-size: 12px;'>[发票：付款期限截止日期]</div></div></div></td></tr></tbody></table>");
        });
    </script>
        </div>
    </form>
</body>
</html>
