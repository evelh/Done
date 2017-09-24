<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTempBottom.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTempBottom" %>

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
            <span class="text1">发票模板结尾</span>
            <span class="text2">-<%=tempinfo.name %></span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <%--<!--中间form表单-->--%>
        <div></div>
        <!--按钮部分-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok"></span>
                     <asp:Button ID="OkButton1" runat="server" Text="确认" OnClientClick="return save_deal()" cssclass="Text" BorderStyle="None" OnClick="Save" />
                    <input id="data" type="hidden" name="data" value=""/>
                    <input id="bottom" type="hidden" name="bottom" />
                </li>
                <li class="Button ButtonIcon Cancel NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                     <asp:Button ID="cancel" runat="server" Text="取消" cssclass="Text" BorderStyle="None" OnClick="Button1_Click"/>
                </li>
            </ul>
        </div>
    <div style="position: absolute;left: 0;overflow-x: auto;overflow-y: auto;right: 0;top: 82px;bottom: 0px;">
        <div class="Section">
            <div class="Heading">发票底部信息</div>
            <div class="DescriptionText">以下定义的内容会显示在发票的结束部分，只会显示一次（如果设置了附录，则会放在附录前面）</div>
            <div class="Content">
                <script id="containerHead" name="content" type="text/plain"></script>
                <div class="Dialog">
                   <img src="../RichText/img/Dialog.png" alt=""/>
                </div>
            </div>
        </div>
        <div class="Section">
            <div class="Heading">
                <span class="Text">其他信息设置</span>
            </div>
            <div class="Content">
                <div class="Normal Column">
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label>发票备注</label>
                            <div class="SecondaryText">（变量必须是发票模板变量）</div>
                        </div>
                    </div>
                    <div class="Normal Editor TextArea">
                        <div class="InputField">
                            <textarea class="Medium">bottom of invoice notes test</textarea>
                        </div>
                    </div>
                </div>
                <div class="Normal Column">
                    <div class="Normal Editor CheckBox">
                        <div class="InputField">
                            <div>
                                <asp:CheckBox ID="tax_cate" runat="server" />
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label for="DisplayTaxCategory">显示税种</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Editor CheckBox">
                        <div class="InputField">
                            <div>
                               <asp:CheckBox ID="tax_sup" runat="server" />
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label for="DisplayTaxCategorySuperscript">显示税种上标</label>
                                    <div class="SecondaryText">显示分税信息时，必须设置显示[发票：税收详情]</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Editor CheckBox">
                        <div class="InputField">
                            <div>
                               <asp:CheckBox ID="tax_group" runat="server" /> 
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label for="DisplaySeparateLineItemPerTax">显示税种分税信息</label>
                                    <div class="SecondaryText">必须设置显示[发票：税收详情]</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Section Collapsed">
            <div class="Heading">
                <div class="Toggle Collapse Toggle1">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="Text">合同余额信息</span>
            </div>
            <div class="DescriptionText">合同余额变量定义（预付费合同、事件合同、预付费用合同）</div>
            <div class="Content">
                <div class="Normal Column">
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付时间：已用</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value" <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[0].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[0].value %>"<%}else{ %>value="已用时间"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付时间：剩余</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[1].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[1].value %>"<%}else{ %>value="剩余时间"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付事件：已用</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[2].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[2].value %>"<%}else{ %>value="已用事件"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付事件：剩余</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[3].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[3].value %>"<%}else{ %>value="剩余事件"<%} %>/>
                        </div>
                    </div>
                </div>
                <div class="Normal Column">
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付费用：已用</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[4].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[4].value %>"<%}else{ %>value="已用费用"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付费用：剩余</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[5].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[5].value %>"<%}else{ %>value="剩余费用"<%} %>/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Section Collapsed">
            <div class="Heading">
                <div class="Toggle Collapse Toggle2">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="Text">发票汇总信息</span>
            </div>
            <div class="DescriptionText">发票汇总变量定义</div>
            <div class="Content">
                <div class="Normal Column">
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">不计费工时</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[6].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[6].value %>"<%}else{ %>value="不计费工时"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">预付时间</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[7].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[7].value %>"<%}else{ %>value="预付时间"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">调整的计费工时</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[8].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[8].value %>"<%}else{ %>value="调整的计费工时"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">全部计费工时</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[9].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[9].value %>"<%}else{ %>value="全部计费工时"<%} %>/>
                        </div>
                    </div>
                </div>
                <div class="Normal Column">
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">全部计费金额（调整前）</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[10].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[10].value %>"<%}else{ %>value="全部计费金额（调整前）"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">付款/信贷</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[11].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[11].value %>"<%}else{ %>value="付款/信贷"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">税金总额</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[12].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[12].value %>"<%}else{ %>value="税金总额"<%} %>/>
                        </div>
                    </div>
                    <div class="EditorLabelContainer">
                        <div class="Label">
                            <label class="bottom_text">总计</label>
                        </div>
                    </div>
                    <div class="Normal Editor TextBox">
                        <div class="InputField">
                            <input type="text" class="bottom_value"  <%if (bottomttt.Bottom_Item!=null&&bottomttt.Bottom_Item[13].value != null)
                                { %>value="<%=bottomttt.Bottom_Item[13].value %>"<%}else{ %>value="总计"<%} %>/>
                        </div>
                    </div>
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
<script src="../Scripts/jquery-3.1.0.min.js"></script>
            <script src="../RichText/js/ueditor.config.js"></script>
            <script src="../RichText/js/ueditor.all.js"></script>
            <script src="../RichText/js/InvoiceTemplate.js"></script>
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
            var Model = '<table style="width:100%; padding-top:20px; border-collapse:collapse;font-size:12px;">dgssdfjghk,hjdgs'+
                    '<tbody>'+
                    '<tr>'+
                    '<td id="InvoiceNotesBlock" style="vertical-align:top;border:none;">[Invoice: Invoice Notes]</td>'+
                    '<td id="InvoiceSummaryBlock" style="vertical-align:top;width:300px;border:none;" align="right">[Invoice: Totals]<br><br>'+
                    '<div>[Invoice: Tax Detail]</div>'+
                    '</td>'+
                    '</tr>'+
                    '</tbody>'+
                    '</table>';
            ue.setContent(Model);
        });
        //点击确定数据保存至后台  在展示页展示
        $("#OkButton").on("click",function(){
            var html = ue.getContent();
            console.log(html);
            var txt = ue.getContentTxt();
            console.log(txt);
        })
        // 点击取消直接返回
        //$("#CancelButton").on("click",function(){
        //    window.location.href="QuotationTemplate.html";
        //})
        //情空内容
        $("#ResetButton").on("click",function(){
            ue.setContent('')
        })
        function dbclick(val) {
            UE.getEditor('containerHead').focus();
            UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
            $("#BackgroundOverLay").hide();
            $(".AlertBox").hide();
        }
        //保存数据
        function save_deal() {
            var html = ue.getContent();
            console.log(html);
            var data = [];
            //表格显示字段设置
            data.push("{\"Item\":[");
            for (var i = 0; i < 14; i++) {
                var name = $(".bottom_text").eq(i).text();
                var value = $(".bottom_value").eq(i).val();
                var Item = { "id": "0", "name": name, "value": value};
                var jsonArrayFinal = JSON.stringify(Item);
                data.push(jsonArrayFinal);
                console.log(jsonArrayFinal);
            }
            data.push("]}");
            $("#bottom").val($('<div/>').text(data).html());
            $("#data").val($('<div/>').text(html).html());
            var txt = ue.getContentTxt();
            console.log(txt);
        }

    </script>
        </div>
    </form>
</body>
</html>
