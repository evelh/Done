<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectCompleteWizard.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectCompleteWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>完成项目向导</title>

    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/LostOpp.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">完成项目向导</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="Workspace Workspace1">
            <div class="PageInstructions">下面是此项目未完成任务的列表，点击下一步，设置此项目的所有任务为完成并继续，或点击取消 </div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <thead>
                                            <tr>
                                                <td>结束日期</td>
                                                <td width="80px" align="left">员工姓名</td>
                                                <td style="padding-left: 8px;" align="left">任务标题</td>
                                                <td style="padding-left: 8px;" align="left">状态</td>
                                                <td style="padding-left: 8px;" align="right">实际时间</td>
                                            </tr>
                                        </thead>
                                        <tbody>

                                            <% if (actTaskList != null && actTaskList.Count > 0)
                                                {
                                                    var sDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                                    var gDal = new EMT.DoneNOW.DAL.d_general_dal();
                                                    var gtDal = new EMT.DoneNOW.DAL.d_general_table_dal();
                                                    var statusList = gDal.GetDictionary(gtDal.GetById((int)EMT.DoneNOW.DTO.GeneralTableEnum.TICKET_STATUS));
                                                    var proBLL = new EMT.DoneNOW.BLL.ProjectBLL();
                                                    foreach (var actTask in actTaskList)
                                                    {%>
                                            <tr>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap><%=actTask.estimated_end_date==null?"":((DateTime)actTask.estimated_end_date).ToString("yyyy-MM-dd") %></td>
                                                <% string resouName = "";
                                                    if (actTask.owner_resource_id != null)
                                                    {
                                                        var resou = sDal.FindNoDeleteById((long)actTask.owner_resource_id);
                                                        if (resou != null)
                                                        {
                                                            resouName = resou.name;
                                                        }
                                                    } %>

                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=resouName %></td>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=actTask.title %></td>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=statusList.FirstOrDefault(_=>_.val==actTask.status_id.ToString()).show %></td>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=proBLL.RetTaskActHours(actTask.id).ToString("#0.00") %></td>
                                            </tr>
                                            <% }
                                                } %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a1">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">下面是未安装产品的成本列表，请选择要安装的产品。 </div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <thead>
                                            <tr>
                                                <td></td>
                                                <td>成本名称</td>
                                                <td width="80px" align="left">计费代码名称</td>
                                                <td style="padding-left: 8px;" align="left">产品</td>
                                                <td style="padding-left: 8px;" align="left">序列号</td>
                                                <td style="padding-left: 8px;" align="right">安装日期</td>
                                                <td style="padding-left: 8px;" align="right">保修过期日期</td>
                                                <td style="padding-left: 8px;" align="right">已计费</td>
                                            </tr>
                                        </thead>
                                        <tbody style="overflow: scroll; overflow-x: hidden;">
                                            <% if (noCicostList != null && noCicostList.Count > 0)
                                                {
                                                    var dccDal = new EMT.DoneNOW.DAL.d_cost_code_dal();
                                                    var ipDal = new EMT.DoneNOW.DAL.ivt_product_dal();
                                                    foreach (var noCiCost in noCicostList)
                                                    { %>
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="CheckCost" id="<%=noCiCost.id %>" value="<%=noCiCost.id %>" /></td>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=noCiCost.name %></td>
                                                <% var thisCost = dccDal.FindNoDeleteById(noCiCost.cost_code_id); %>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=thisCost==null?"":thisCost.name %></td>
                                                <% EMT.DoneNOW.Core.ivt_product thisProduct = null;
                                                    if (noCiCost.product_id != null)
                                                    {
                                                        thisProduct = ipDal.FindNoDeleteById((long)noCiCost.product_id);
                                                    }
                                                %>
                                                <td id="txtBlack8" style="vertical-align: middle;" >
                                                    <input type="text" id="<%=noCiCost.id %>_product_id" value="<%=thisProduct==null?"":thisProduct.name %>" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left" />
                                                    <input type="hidden" id="<%=noCiCost.id %>_product_idHidden" name="<%=noCiCost.id %>_product_idHidden" value="<%=thisProduct==null?"":thisProduct.id.ToString() %>" /><a onclick="ChooseProduct('<%=noCiCost.id %>')">
                                                    <img src="../Images/data-selector.png" /></a>

                                                </td>
                                                <td id="txtBlack8" style="vertical-align: middle;" >
                                                    <input type="text" id="<%=noCiCost.id %>_serial_number" name="<%=noCiCost.id %>_serial_number" />
                                                </td>
                                                <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right">
                                                    <input type="text" id="<%=noCiCost.id %>_date_purchased" name="<%=noCiCost.id %>_date_purchased" value="<%=noCiCost.date_purchased.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" />
                                                </td>
                                                  <td id="txtBlack8" style="vertical-align: middle;" nowrap align="right">
                                                    <input type="text" id="<%=noCiCost.id %>_through_date" value="" name="<%=noCiCost.id %>_through_date" onclick="WdatePicker()" />
                                                </td>
                                                <td  style="vertical-align: middle;" nowrap align="right">
                                                    <%=noCiCost.bill_status==1?"√":"" %>
                                                </td>
                                            </tr>
                                            <%}
                                                } %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a2">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b2">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions"></div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels" colspan="2">定义实施时间
                                                    <div>
                                                        <input type="text" onclick="WdatePicker()" name="ProStartDate" id="ProStartDate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" style="width:15px;">
                                                    <asp:CheckBox ID="cbStaTime" runat="server" />
                                                </td>
                                                <td class="fieldLabels" id="txtgray8"><span>更新相关商机的项目或服务开始时间</span></td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabels" style="width:15px;">
                                                    <asp:CheckBox ID="cbStatus" runat="server" />
                                                </td>
                                                <td class="fieldLabels" id="txtgray8"><span>更新相关商机的状态为“已实施”</span></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a3">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b3">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">请选择要通知的人。如果有分配列表，请使用“其他邮件地址”。</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tbody>

                                        <tr>
                                            <td class="FieldLabels">员工
                                            <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">Load</a>)</span>
                                                <div id="reshtml" style="width: 500px;height: 170px;border: 1px solid #d7d7d7;margin-bottom: 20px;">
                                                  
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">其他邮件地址
                                            <div>
                                                <input type="text" style="width: 488px;" name="otherMail" id="otherMail" />
                                            </div>
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a4">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>

                </ul>
            </div>
        </div>
           <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">请输入主题和要通知的其他信息。</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tbody>

                                      <tr>
                                        <td class="FieldLabels">
                                            通知模板
                                            <div>
                                                <asp:DropDownList ID="noTempId" runat="server" Width="350px"></asp:DropDownList>
                                            </div>
                                        </td>
                                    </tr>
                                        <tr>
                                            <td class="FieldLabels">主题
                                            <div>
                                                <input type="text" style="width: 350px;" name="subject" id="subject">
                                            </div>
                                            </td>
                                        </tr>
                                            <tr>
                                            <td class="FieldLabels">其他邮件文本
                                            <div>
                                               <textarea name="appendText" id="appendText" style="width:350px" rows="6"></textarea>
                                            </div>
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a5">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b5">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>

                </ul>
            </div>
        </div>
      <div class="Workspace Workspace6" style="display: none;">
        <div class="PageInstructions">向导已完成，点击结束进行下列活动：</div>
        <div class="WizardSection">
            <table cellspacing="0" cellpadding="0" width="100%">
                <tbody>
                    <tr height="85%">
                        <td width="90%">
                            <div>
                                <a href="##">完成项目</a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="90%">
                            <div>
                                <a href="##">完成任务</a>
                            </div>
                        </td>
                    </tr>
                    <tr id="UpdateOpp" style="display:none;">
                        <td width="90%">
                            <div>
                                <a href="##">更新商机</a>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar WizardButtonBar" style="width:97%;">
            <ul>
                     <!--上一层-->
                    <li id="a6">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>

                <li class="right" id="d8">
                    <a class="ImgLink">
                        <img class="ButtonRightImg" src="../Images/cancel.png">
                        <span class="Text"><asp:Button ID="finish" runat="server" Text="完成" OnClick="finish_Click" /></span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
        <input type="hidden" name="costIds" id="costIds"/> <!-- 用户选择生成配置项的成本 -->
        <input type="hidden" name="noResIds" id="noResIds"/> <!-- 用户选择通知的员工ID -->

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#b1").on("click", function () {
        $(".Workspace1").hide();
        $(".Workspace2").show();
    });
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });
    $("#b2").on("click", function () {
        debugger;
        var ids = "";         // 成本ID集合
        var isTrans = "";
        $(".CheckCost").each(function () {
            var thisId = $(this).val();
            if ($(this).is(":checked")) {
                var product_id = $("#"+thisId + "_product_idHidden").val();
                if (product_id != undefined && product_id!="")
                {
                    ids += thisId + ',';
                } else {
                    isTrans += thisId+",";
                }
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        if (isTrans != "")
        {
            LayerConfirm("有勾选的成本未选择产品，这些项目成本将不会生成配置项，是否继续", "继续", "取消", function () {
                $("#costIds").val(ids);
                $(".Workspace2").hide();
                $(".Workspace3").show(); }, function () { });
        } else {
            $("#costIds").val(ids);
            $(".Workspace2").hide();
            $(".Workspace3").show();
        }

    });
    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    });
    $("#b3").on("click", function () {
         <%if (thisProject.opportunity_id != null)
        { %>
        if ($("#cbStaTime").is(":checked") || $("#cbStatus").is(":checked")) {
            $("#UpdateOpp").show();
        }
        <%} %>
        $(".Workspace3").hide();
        $(".Workspace4").show();
    });
    $("#a4").on("click", function () {
        $(".Workspace3").show();
        $(".Workspace4").hide();
    });
    $("#b4").on("click", function () {
        var resIds = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                resIds += $(this).val()+',';
            }
        })
        if (resIds != "") {
            resIds = resIds.substring(0, resIds.length - 1);
        }
        $("#noResIds").val(resIds);
        $(".Workspace4").hide();
        $(".Workspace5").show();
    });
    $("#a5").on("click", function () {
        $(".Workspace4").show();
        $(".Workspace5").hide();
    });
    $("#b5").on("click", function () {

        $(".Workspace5").hide();
        $(".Workspace6").show();
    });

    $("#a6").on("click", function () {
        $(".Workspace5").show();
        $(".Workspace6").hide();
    });

    $("#d6").on("click", function () {
        window.close();
    });
    $("#load111").on("click", function () {
        $(".grid").show();
    });
    $("#all").on("click", function () {
        if ($(this).is(":checked")) {
            $(".grid input[type=checkbox]").prop('checked', true);
        } else {
            $(".grid input[type=checkbox]").prop('checked', false);
        }
    });



 
   
</script>
<script>

    $(function () {
        <% if (thisProject.opportunity_id != null)
    { %>
        $("#cbStaTime").prop("checked", true);
        $("#cbStatus").prop("checked", true);
        <%}
    else
    {%>
        $("#cbStaTime").prop("disabled", true);
        $("#cbStatus").prop("disabled", true);
        $("#ProStartDate").prop("disabled", true);
        <%}%>
    })

    $("#checkAll").click(function () {
        if ($(this).is(":checked")) {
            $(".checkRes").prop("checked", true);
        } else {
            $(".checkRes").prop("checked", false);
        }
    })

    $("#finish").click(function () {
        var noti = $("#noTempId").val();
        if (noti == undefined || noti == "" || noti == "0" || noti == null) {
            LayerMsg("请选择通知模板！");
            return false;
        }

        <% if (thisProject.opportunity_id != null)
        {%>
        var ProStartDate = $("#ProStartDate").val();
        if ($("#cbStaTime").is(":checked") && ProStartDate == "") {
            LayerMsg("请填写定义实施时间！");
            return false;
        }
        <% }%>
        return true;
    })

    function ChooseProduct(id) {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=" + id + "_product_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
        
    }

    function LoadRes() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetActiveRes",
            success: function (data) {
                if (data != "") {
                    var resList = JSON.parse(data);
                    var resHtml = "";
                    resHtml += "<div class='grid' style='overflow: auto;height: 147px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'><input type='checkbox' id='checkAll'/></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";
                    for (var i = 0; i < resList.length; i++) {
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='checkRes' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email+"</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }
</script>
