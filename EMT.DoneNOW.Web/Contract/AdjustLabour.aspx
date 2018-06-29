<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustLabour.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AdjustLabour" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>工时调整</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <style>
        .bold {
            display: inline-block;
            color: #151515;
            font-size: 14px;
            width: 170px;
            font-weight: 700;
            height: 30px;
            line-height: 30px;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">工时调整</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="content clear">
                <% if (deduction != null)
                    {%>
                <div class="information clear">
                    <p class="informationTitle"><i></i>工时条目</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td style="width: 50%;">
                                    <label>客户</label>
                                    <span><%=account?.name %></span>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <label>员工</label>
                                    <span><%=resource?.name %></span>
                                </td>
                                <td>
                                    <label>工作时间</label>
                                    <span><%=resource?.name %></span>
                                </td>
                            </tr>
                            <%if (task != null)
                                {%>
                            <tr>
                                <td>
                                    <label>任务或工单标题</label>
                                    <span><%=task.title %></span>
                                </td>
                                <td>
                                    <label>任务或工单编号</label>
                                    <span><%=task.no %></span>
                                </td>
                            </tr>
                            <%} %>
                        </table>
                    </div>
                </div>

                <%} %>
                <div class="information clear">
                    <p class="informationTitle"><i></i>合同</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td style="width: 50%;">
                                    <span class="bold">合同</span>
                                    <div>
                                        <span><%=contract?.name %></span>
                                    </div>

                                </td>
                                <td>
                                    <span class="bold">合同类型</span>
                                    <div>
                                        <span><%=contractType?.name %></span>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle"><i></i>调整</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <label>调整类型</label>
                                    <div>
                                        <select id="adjustType" name="adjustType">
                                            <option value="Add">返还</option>
                                            <option value="Reduce">扣除</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label><%=contract?.type_id==(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS?"调整小时数":(contract?.type_id==(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER?"调整金额":"") %> <span style="color: red;">*</span></label>
                                    <div>
                                        <input type="text" class="Todec4" id="AdjustNum" name="AdjustNum" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label>原因<span style="color: red;">*</span></label>
                                    <div>
                                        <textarea style="resize: vertical;" id="reason" name="reason"></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/index.js"></script>
<script>
    $(".Todec4").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal4(thisValue));
        }
        else {
            $(this).val("");
        }
    })

    $("#save_close").click(function () {

        <%if (block != null)
    {%>
        var AdjustNum = $("#AdjustNum").val();
        if (AdjustNum == "") {
            LayerMsg("请填写调整数量！");
            return false;
        }
        var reason = $("#reason").val();
        if (reason == "") {
            LayerMsg("请填写调整原因！");
            return false;
        }
        <%} %>

        return true;
    })

</script>
