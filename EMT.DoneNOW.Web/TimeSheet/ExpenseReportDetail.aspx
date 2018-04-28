<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExpenseReportDetail.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.ExpenseReportDetail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>费用报表详情</title>
    <style>
        body {
            font-size: 12px;
            overflow: auto;
            background: white;
            left: 0;
            top: 0;
            position: relative;
            margin: 0;
        }

        .HeaderRow {
            background-color: #346a95;
            z-index: 100;
            height: 36px;
            padding-left: 10px;
            margin-bottom: 10px;
        }

            .HeaderRow table {
                width: 100%;
                border-collapse: collapse;
            }

            .HeaderRow span {
                color: #FFF;
                top: 10px;
                display: block;
                width: 85%;
                position: absolute;
                text-transform: uppercase;
                font-size: 15px;
                font-weight: bold;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                }

                    .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
                        background: #d7d7d7;
                        background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                        border: 1px solid #bcbcbc;
                        display: inline-block;
                        color: #4F4F4F;
                        cursor: pointer;
                        padding: 0 5px 0 3px;
                        position: relative;
                        text-decoration: none;
                        vertical-align: middle;
                        height: 24px;
                    }

        .ExpenseDetail {
            padding: 10px;
            width: 100%;
        }

            .ExpenseDetail table {
                width: 100%;
            }

                .ExpenseDetail table .LeftTd {
                    width: 150px;
                    white-space: nowrap;
                }

        .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

            .FieldLabels .label {
                font-weight: normal;
            }

        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
            font-size: 12px;
            font-weight: bold;
            line-height: 26px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        #Approval, #Refuse {
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            font-size: 12px;
            font-weight: bold;
            line-height: 24px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        span#errorSmall {
            color: red;
        }
        .grid {
    font-size: 12px;
    background-color: #FFF;
}
        .grid table {
    border-bottom-color: #98b4ca;
    width: 100%;
    border-bottom-width: 1px;
    border-bottom-style: solid;
}
        .grid thead {
    /* background-color: #cbd9e4; */
}
        thead {
    display: table-header-group;
    vertical-align: middle;
    border-color: inherit;
}
        .grid thead tr td {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
}
        .grid thead td {
    border-width: 1px;
    border-style: solid;
    font-size: 13px;
    font-weight: bold;
    height: 19px;
    padding: 4px 4px 4px 4px;
    word-wrap: break-word;
    vertical-align: top;
}
        .grid tbody tr td:first-child, .grid tfoot tr td:first-child {
    border-left-color: #98b4ca;
}
        .grid tbody td, tfoot td {
    BORDER-LEFT: solid 1px #cccccc;
    BORDER-RIGHT: solid 1px #cccccc;
    BORDER-TOP: none;
    BORDER-BOTTOM: 1px solid;
    border-color: #cccccc;
}
        .grid tbody td {
    border-width: 1px;
    border-style: solid;
    border-left-color: #F8F8F8;
    border-right-color: #F8F8F8;
    border-top-color: #e8e8e8;
    border-bottom-width: 0;
    padding: 4px 4px 4px 4px;
    vertical-align: top;
    word-wrap: break-word;
    font-size: 12px;
    color: #333;
}
        .select{
                background: linear-gradient(to bottom,#d7d7d7 0,#fff 100%);
        }
        .menu {
            position: absolute;
            z-index: 999;
            display: none;
        }

            .menu ul {
                margin: 0;
                padding: 0;
                position: relative;
                width: 150px;
                border: 1px solid gray;
                background-color: #F5F5F5;
                padding: 10px 0;
            }

                .menu ul li {
                    padding-left: 20px;
                    height: 25px;
                    line-height: 25px;
                    cursor: pointer;
                    list-style: none;
                }

                    .menu ul li ul {
                        display: none;
                        position: absolute;
                        right: -150px;
                        top: -1px;
                        background-color: #F5F5F5;
                        min-height: 90%;
                    }

                        .menu ul li ul li:hover {
                            background: #e5e5e5;
                        }

                    .menu ul li:hover {
                        background: #e5e5e5;
                    }

                        .menu ul li:hover ul {
                            display: block;
                        }

                    .menu ul li .menu-i1 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: left;
                    }

                    .menu ul li .menu-i2 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: right;
                    }

                .menu ul .disabled {
                    color: #AAAAAA;
                }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>费用报表详情-<%=thisReport==null?"":thisReport.title %></span></td>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <%if (isSubmit)
                    { %>
                <li ><a class="ImgLink" id="" name="" onclick="AddExpense()">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text" style="line-height: 24px;">添加费用</span></a></li>
                <li style="margin-left: 14px;"><a class="ImgLink" id="" name="" onclick="AddAttach()">
                    <span class="icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    <span class="Text" style="line-height: 24px;">添加附件</span></a></li>
                <li style="margin-left: 14px;"><a class="ImgLink" id="" name="" onclick="CompanyPolicy()">
                    <span class="Text" style="line-height: 24px;">客户策略</span></a></li>
                <li style="margin-left: 14px;"><a class="ImgLink" id="" name="" onclick="Submit()">
                    <span class="Text" style="line-height: 24px;">提交</span></a></li>
          
                <%}
                    else
                    { %>

                <%} %>
                      <li style="margin-left: 14px;"><a class="ImgLink" id="" name="" onclick="Report()">
                    <span class="Text" style="line-height: 24px;">报告</span></a></li>
                     
                  <li style="margin-left: 14px;"><a class="ImgLink" >
                    <span class="icon" style="background-image: url(../Images/print.png); width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    </a></li>

                    <li style="margin-left: 14px;" ><a class="ImgLink" onclick="ShowExpense()" style="<%=isReport?"background: linear-gradient(to bottom,#d7d7d7 0,#fff 100%);":"" %>">
                    <span class="Text" style="line-height: 24px;">费用</span></a></li>
                    <li><a class="ImgLink" onclick="ShowAttach()" style="<%=!isReport?"background: linear-gradient(to bottom,#d7d7d7 0,#fff 100%);":"" %>" >
                    <span class="Text" style="line-height: 24px;">附件(<%=attList!=null?attList.Count:0 %>)</span></a></li>
            </ul>
        </div>
        <% if (isRefuse)
            { %>
        <div style="margin-left:10px;">
            <img src="../Images/alert.png" border="0" align="absmiddle" />&nbsp;&nbsp;<a onclick="showRejectionReason();" class="PrimaryLink">费用报表被拒绝，点击查看详情。</a>
        </div>
        <%} %>
        <div class="GridContainer DivScrollingContainer SearchResultContainer ScreenDiv" id="divData" style="margin-left:10px;">
            <%if (isReport)
                { %>
            <div class="grid">
                <table width="100%" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                    <thead>
                        <tr>
                            <%if (isCheck)
                                {%>
                             <td align="center">拒绝</td>
                               <% }
                                %>
                            <td align="center">费用日期</td>
                            <td>费用类别</td>
                            <td>说明</td>
                            <td>客户名称</td>
                            <td>关联项目任务或工单</td>
                            <td align="right">金额</td>

                            <td>付款类型</td>
                            <td align="center">有收据</td>
                            <td align="center">计费的</td>
                        </tr>
                    </thead>

                    <tbody>
                        <% if (expList != null && expList.Count > 0)
                            {
                                foreach (var thisExp in expList)
                                {
                        %>
                        <tr align="left" valign="middle" class="expenseTr <%=isSubmit?"rightMenu":"" %>" data-val="<%=thisExp.id %>" style="cursor: pointer;">
                            <%if (isCheck)
                                {%>
                             <td align="center"><input type="checkbox" id="cf_ref_<%=thisExp.id %>" value="<%=thisExp.id %>" class="ckRefuse" /></td>
                               <% }
                                %>
                            <td align="center"><span id="DisplayValueForDateTime"><%=thisExp.add_date.ToString("yyyy-MM-dd") %></span></td>
                            <td><%if (thisExp.expense_cost_code_id != null)
                                    {
                                        var thisCost = cateList.FirstOrDefault(_ => _.id == thisExp.expense_cost_code_id);
                            %>
                                <%=thisCost==null?"":thisCost.name %>
                                <%} %>
                            </td>
                            <td><%=thisExp.description %>
                            </td>
                            <td><% var thisAcc = cBLL.GetCompany(thisExp.account_id);
                                    string accName = thisAcc == null ? "" : thisAcc.name; %>
                                <% if (thisAcc != null && thisAcc.type_id != null)
                                    {
                                        var thisType = accTypeList.FirstOrDefault(_ => _.id == thisAcc.type_id);
                                        if (thisType != null)
                                        {
                                            accName += $"({thisType.name})";
                                        }
                                    } %>
                                <%=accName %>
                            </td>
                            <td>
                                <% if (thisExp.project_id != null)
                                    {
                                        var thisPro = ppDal.FindNoDeleteById((long)thisExp.project_id);
                                        if (thisPro != null)
                                        {
                                            accName += "\r" + thisPro.name;
                                        }

                                    }
                                    if (thisExp.task_id != null)
                                    {
                                        var thisTask = stDal.FindNoDeleteById((long)thisExp.task_id);
                                        if (thisTask != null)
                                        {
                                            accName += "\r" + thisTask.title;
                                        }

                                    }
                                %>
                                <%=accName %>
                            </td>

                            <td align="right"><%=thisExp.amount.ToString("#0.00") %></td>


                            <td><%var thisPay = payTypeList.FirstOrDefault(_ => _.id == thisExp.payment_type_id);  %>
                                <%=thisPay==null?"":thisPay.name %>
                            </td>
                            <td align="center">
                                <%=thisExp.has_receipt==1?"✓":"" %>
                            </td>
                            <td align="center">
                                <%=thisExp.is_billable==1?"✓":"" %>
                            </td>
                        </tr>
                        <%
                                }%>
                     
                            <%} %>
                           <tr align="left" valign="middle" id="TotalRow">
                            <td colspan="<%=isCheck?6:5 %>" align="right" class="FieldLabels">费用合计</td>
                            <td align="right" class="FieldLabels"><%=(expList!=null&&expList.Count>0?expList.Sum(_=>_.amount):0).ToString("$0.00")  %></td>

                            <td colspan="3">&nbsp;</td>

                        </tr>
                        <!---->
                        <tr align="left" valign="middle" id="TotalRow">
                            <td colspan="<%=isCheck?6:5 %>" align="right" class="FieldLabels">预付现金总额</td>
                            <td align="right" class="FieldLabels"><%=(thisReport.cash_advance_amount??0).ToString("#0.00")  %></td>

                            <td colspan="3">&nbsp;</td>

                        </tr>
                        <!---->
                        <tr align="left" valign="middle" id="TotalRow">
                            <td colspan="<%=isCheck?6:5 %>" align="right" class="FieldLabels">不报销总额</td>
                            <td align="right" class="FieldLabels"><%
                                                                      var noPayList = new List<EMT.DoneNOW.Core.sdk_expense>();
                                                                      if (expList != null && expList.Count > 0)
                                                                      {
                                                                          expList.Where(_ =>
                                                                      {
                                                                          bool result = false;
                                                                          var thisPay = payTypeList.FirstOrDefault(thisPayType => thisPayType.id == _.payment_type_id);
                                                                          if (thisPay != null && thisPay.ext1 == "1")
                                                                          {
                                                                              result = true;
                                                                          }
                                                                          return result;
                                                                      }).ToList();
                                                                      }
                                                                      
                            %>

                                <%=noPayList!=null&&noPayList.Count>0?noPayList.Sum(_=>_.amount).ToString("#0.00"):"0.00" %>
                            </td>

                            <td colspan="3">&nbsp;</td>

                        </tr>
                        <!---->
                        <tr align="left" valign="middle" id="LastRow">
                            <td colspan="<%=isCheck?6:5 %>" align="right" class="FieldLabels">截止总额</td>
                            <td align="right" class="FieldLabels">
                                <% var dueMoney = (expList!=null&&expList.Count>0?expList.Sum(_=>_.amount):0) - (noPayList != null && noPayList.Count > 0 ? noPayList.Sum(_ => _.amount) : 0) - (thisReport.cash_advance_amount ?? 0);  %>
                                <%=dueMoney.ToString("#0.00") %>
                            </td>

                            <td colspan="3">&nbsp;</td>

                        </tr>

                    </tbody>

                </table>
            </div>
            <%}
                else
                { %>
            <div class="grid GridContainer DivScrollingContainer SearchResultContainer" style="top: 0px">
                <table width="100%" style="border-collapse: collapse;" cellspacing="0" cellpadding="0">
                    <thead>
                        <tr>
                            <td width="30%">附件名称</td>
                            <td width="30%">文件名称</td>
                            <td align="center" width="20%">创建日期</td>
                            <td align="center" width="20%">大小</td>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (attList != null && attList.Count > 0)
                            {
                                foreach (var thisAtt in attList)
                                {
                        %>
                        <tr data-val="<%=thisAtt.id %>" style="cursor: pointer;" class="attachTr rightMenu">
                            <td><%=thisAtt.title %></td>
                            <td><%=thisAtt.filename %></td>
                            <td align="center"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisAtt.create_time).ToString("yyyy-MM-dd") %></td>
                            <td align="center"><%=thisAtt.sizeinbyte??0 %>字节
                            </td>
                        </tr>
                        <%
                                }
                            } %>
                    </tbody>
                </table>
            </div>
            <%} %>
        </div>
        <div id="expenseMenu" class="menu">
            <ul style="width: 220px;">
                 <li id="" onclick="EditExpense()"><i class="menu-i1"></i>编辑费用
                </li>
                <li id="" onclick="DeleteExpense()"><i class="menu-i1"></i>删除费用
                </li>
            </ul>
        </div>
        <div id="attachMenu" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="DeleteAttach()"><i class="menu-i1"></i>删除附件
                </li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    var entityid = "";
    var Times = 0;
    $(".rightMenu").bind("contextmenu", function (event) {
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = "";
        //var thisClassName = $(this).prop("className"); attachMenuS expenseTr attachTr
        if ($(this).hasClass("expenseTr")) {
            menu = document.getElementById("expenseMenu");
        } else if ($(this).hasClass("attachTr")) {
            menu = document.getElementById("attachMenu");
        } 

        entityid = $(this).data("val");
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 - 25 + scrTop + "px";
        } else {
            menu.style.top = Top - 25 + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
        return false;
    });
</script>
<script>
    <% if (isSubmit){%>
    $(".expenseMenu").click(function () {
        var thisValue = $(this).data("val");
        if (thisValue != "" && thisValue != undefined && thisValue != null) {
            window.open("../Project/ExpenseManage.aspx?id=" + thisValue, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_EDIT %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
        }
    })
    <%}%>
    
    $(".attachTr").click(function () {
        var thisValue = $(this).data("val");
        if (thisValue != "" && thisValue != undefined && thisValue != null)
        {
            window.open("../Activity/OpenAttachment.aspx?id=" + thisValue, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);
        }
    })

</script>
<script>
    function AddExpense() {
        window.open("../Project/ExpenseManage.aspx?report_id=<%=thisReport.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_ADD %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
    }
    function AddAttach() {
        window.open('../Activity/AddAttachment?objId=<%=thisReport.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.EXPENSE_REPORT %>&noFunc=1', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.AttachmentAdd %>', 'left=200,top=200,width=730,height=750', false);
    }

    // 客户策略
    function CompanyPolicy() {
        var accId = '<%=defAcc==null?"":defAcc.id.ToString() %>';
        if (accId != "") {
            window.open("../Project/CompanyPolicy.aspx?account_id=" + accId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_ADD %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
        }
        
    }

    // 提交操作
    function Submit() {
        var thisStatus = '<%=thisReport.status_id.ToString() %>';
        if (thisStatus == '<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_REPORT_STATUS.HAVE_IN_HAND %>' || thisStatus == '<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED %>' )
        {
            LayerConfirm("确认要提交吗？", "确认", "取消", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ExpenseAjax.ashx?act=Submit&id=<%=thisReport.id %>",
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            if (data.result) {
                                LayerMsg("提交成功");
                                history.go(0);
                            } else {
                                LayerMsg("提交失败。" + data.reason);
                            }
                        }

                    }
                })
            }, function () { });
        }
        else
        {
            LayerMsg('进行中或者已拒绝状态的费用报表才可以提交');
        }
    }

    // 修改费用
    function EditExpense() {
        window.open("../Project/ExpenseManage.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_EDIT %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
    }

    // 删除费用
    function DeleteExpense() {
            LayerConfirm("确认要删除吗？", "确认", "取消", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProjectAjax.ashx?act=DeleteExpense&exp_id=" + entityid,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            if (data.result) {
                                LayerMsg("删除成功");
                                history.go(0);
                            } else {
                                LayerMsg("删除失败。" + data.reason);
                            }
                        }

                    }
                })
            }, function () { });
    }

    // 删除附件
    function DeleteAttach() {
        LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + entityid,
                async: false,
                dataType: "json",
                success: function (data) {
                    history.go(0);
                }
            })
        }, function () { });
    }
    // 显示费用表格
    function ShowExpense() {
        location.href = "ExpenseReportDetail?id=<%=thisReport.id %>&isCheck=<%=Request.QueryString["isCheck"] %>"; 
    }
    // 显示附件表格
    function ShowAttach() {
        location.href = "ExpenseReportDetail?id=<%=thisReport.id %>&isCheck=<%=Request.QueryString["isCheck"] %>&ShowAtt=1";
    }
    // 显示报表报告
    function Report() {
        
        window.open("../TimeSheet/ReportView.aspx?id=<%=thisReport.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EXPENSE_REPORT_REFUSE %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
    }
    // 获取选中的费用报表
    function GetCheckIds() {
        var ids = "";
        $(".ckRefuse").each(function () {
            if ($(this).is(":checked")) {
                var thisValue = $(this).val();
                if (thisValue != "" && thisValue != undefined && thisValue != null) {
                    ids += thisValue + ",";
                }
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length-1);
        }
        return ids;
    }
    $(".ckRefuse").click(function () {
        var ids = GetCheckIds();
        window.parent.GetRefIds(ids);
    })

    function showRejectionReason(){
        var thisStatus = '<%=thisReport.status_id.ToString() %>';
        if (thisStatus == '<%=(int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED %>') {
            window.open("../TimeSheet/RefuseReportReason.aspx?id=<%=thisReport.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EXPENSE_REPORT_REFUSE %>', 'left=200,top=200,location=no,status=no,width=900,height=750', false);
        }
    }
    
</script>
