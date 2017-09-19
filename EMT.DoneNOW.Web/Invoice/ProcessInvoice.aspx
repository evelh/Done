<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProcessInvoice.aspx.cs" Inherits="EMT.DoneNOW.Web.Invoice.ProcessInvoice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>发票处理</title>
    <link href="../../Content/reset.css" rel="stylesheet" />
    <link href="../../Content/WorkType.css" rel="stylesheet" />
    <style>
        #is_InvoiceEmail{
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
         <div class="TitleBar">
        <div class="Title">
            <span class="text1">发票处理</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon" style="margin: 0;width:0;"></span>
                <span class="Text"><asp:Button ID="process" runat="server" Text="处理选中发票" BorderStyle="None" OnClick="process_Click" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General">
        <div class="PageLevelInstructions">
            <span>你正准备处理<%=idList.Count() %>个发票。请选择处理活动并设置下列发票属性.</span>
        </div>
        <div class="DivSectionWithHeader">
            <div class="Content">
                <table border="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels">
                                <span class="lblNormalClass">处理活动</span>
                                <div>
                                    <select name="process_action" id="process_action" style="width: 450px;">
                                        <option value="">创建DoneNow发票</option>
                                        <option value="">创建DoneNow发票并生成XML文件</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabels">
                                <span class="lblNormalClass">发票模板</span>
                                <div>
                                    <asp:DropDownList ID="invoice_template_id" runat="server" Width="450px"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <asp:CheckBox ID="is_InvoiceEmail" runat="server" />
                                    启用发票邮件服务，发送发票给客户
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                邮件信息/模板
                                <div>
                                    <asp:DropDownList ID="email_temp_id" runat="server" Width="300px"></asp:DropDownList>
                                    
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                发票日期<span class="errorSmallClass">*</span>
                                <div>
                                    <input type="text" name="invoice_date" id="invoice_date" onclick="WdatePicker()" class="Wdate" style="width: 120px;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                发票开始日期   
                                <div>
                                    <input type="text" onclick="WdatePicker()" class="Wdate" name="date_range_from" id="date_range_from" style="width: 120px;">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                 发票结束日期  
                                <div>
                                    <input type="text" onclick="WdatePicker()" class="Wdate" name="date_range_to" id="date_range_to" style="width: 120px;">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                订单号  
                                <div>
                                    <input type="text" name="purchase_order_no" id="purchase_order_no" style="width: 180px;" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldLabel">
                                发票备注
                                <div>
                                    <textarea name="notes" id="notes"  style="width:450px;height:50px"></textarea>
                                </div>
                            </td>
                        </tr>
                <%--        <tr>
                            <td>
                                <div style="padding-bottom: 10px;">
                                    <input type="radio" name="Notes" checked><span>Add to the notes from each company's Invoice Template</span>
                                </div>
                                <div>
                                    <input type="radio" name="Notes"><span>Override the notes from each company's Invoice Template</span>
                                </div>
                            </td>
                        </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
    <script type="text/javascript" src="js/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="js/NewWorkType.js"></script>
    <script type="text/javascript" src="js/My97DatePicker/WdatePicker.js"></script>
    <script>
        $("#is_InvoiceEmail").on("click", function () {
            var _this = $(this);
            if (_this.is(":checked")) {
                $("#email_temp_id").prop("disabled", false);
            } else {
                $("#email_temp_id").prop("disabled", true)
            }
        })

        $("#process").click(function () {
            var invoice_date = $("#invoice_date").val();
            if (invoice_date == "") {
                alert("请填写发票日期！");
                return false;
            }
            return true;
        })
    </script>
