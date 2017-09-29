$("#b0").on("click", function () {
    if ($("#currentPage").val() == 0) {
        if ($("#typeSelect").val() == "") {
            alert("请选择合同类型");
            return;
        }
        contractType = $("#typeSelect").val();
        $("#contractType").val(contractType);
        $(".Workspace0").hide();
        SelectType();
        $(".Workspace1").show();
        $("#a0").hide();
        $("#currentPage").val(1);
    } else if ($("#currentPage").val() == 1) {
        // TODO:检查必填项
        if ($("#name").val() == "") {
            alert("请填写合同名称!");
            return;
        }
        if ($("#account_id").val() == "") {
            alert("请选择公司名称!");
            return;
        }
        if ($("#start_date").val() == "") {
            alert("请填写开始日期!");
            return;
        }
        if (endType == 1 && $("#end_date").val() == "") {
            alert("请填写结束日期!");
            return;
        }
        if (endType == 2 && $("#occurrences").val() == "") {
            alert("请填写结束周期!");
            return;
        }

        if ($("#cnt").val() == 0) {
            $(".Workspace1").hide();
            $("#a0").show();
            $("#currentPage").val(3);
            $("#b0").click();
        } else {
            $(".Workspace1").hide();
            $(".Workspace3").show();
            $("#a0").show();
            $("#currentPage").val(3);
        }
    } else if ($("#currentPage").val() == 3) {
        if (contractType == 1199) {
            $(".Workspace3").hide();
            $(".Workspace4").show();
            $("#currentPage").val(4);
        } else {
            SetTimeReporting();
            $(".Workspace3").hide();
            $(".Workspace5").show();
            $("#currentPage").val(5);
        }
    } else if ($("#currentPage").val() == 4) {
        SetTimeReporting();
        $(".Workspace4").hide();
        $(".Workspace5").show();
        $("#currentPage").val(5);
    } else if ($("#currentPage").val() == 5) {
        if ($("#bill_post_type_id").val() == "") {
            alert("请选择工时计费");
            return;
        }
        if (contractType == 1199 || contractType == 1204) {
            $("#b0").hide();
            $("#c0").show();
            $(".Workspace5").hide();
            $(".Workspace8").show();
            $("#currentPage").val(8);
        } else {
            $(".Workspace5").hide();
            $(".Workspace6").show();
            $("#currentPage").val(6);
        }
    } else if ($("#currentPage").val() == 6) {
        if (contractType == 1201) {
            $(".Workspace6").hide();
            $(".Workspace7").show();
            $("#currentPage").val(7);
        } else {
            $("#b0").hide();
            $("#c0").show();
            $(".Workspace6").hide();
            $(".Workspace8").show();
            $("#currentPage").val(8);
        }
    } else if ($("#currentPage").val() == 7) {
        $("#b0").hide();
        $("#c0").show();
        $(".Workspace7").hide();
        $(".Workspace8").show();
        $("#currentPage").val(8);
    }
});
$("#a0").on("click",function(){
    if ($("#currentPage").val() == 3) {
        $("#a0").hide();
        $(".Workspace3").hide();
        $(".Workspace1").show();
        $("#currentPage").val(1);
    } else if ($("#currentPage").val() == 4) {
        if ($("#cnt").val() == 0) {
            $("#a0").hide();
            $(".Workspace4").hide();
            $(".Workspace1").show();
            $("#currentPage").val(1);
        } else {
            $(".Workspace4").hide();
            $(".Workspace3").show();
            $("#currentPage").val(3);
        }
    } else if ($("#currentPage").val() == 5) {
        $(".Workspace5").hide();
        if (contractType == 1199) {
            $(".Workspace4").show();
            $("#currentPage").val(4);
        } else {
            if ($("#cnt").val() == 0) {
                $("#a0").hide();
                $(".Workspace1").show();
                $("#currentPage").val(1);
            } else {
                $(".Workspace3").show();
                $("#currentPage").val(3);
            }
        }
    } else if ($("#currentPage").val() == 6) {
        $(".Workspace6").hide();
        $(".Workspace5").show();
        $("#currentPage").val(5);
    } else if ($("#currentPage").val() == 7) {
        $(".Workspace7").hide();
        $(".Workspace6").show();
        $("#currentPage").val(6);
    } else if ($("#currentPage").val() == 8) {
        $(".Workspace8").hide();
        $("#c0").hide();
        $("#b0").show();
        if (contractType == 1201) {
            $(".Workspace7").show();
            $("#currentPage").val(7);
        } else if (contractType == 1199 || contractType == 1204) {
            $(".Workspace5").show();
            $("#currentPage").val(5);
        } else {
            $(".Workspace6").show();
            $("#currentPage").val(6);
        }
    }
});
$("#d0").on("click",function(){
    window.close();
});
$("#c0").on("click", function () {
    $("#form1").submit();
});
$(".ImgLink").on("mousemove",function(){
    $(this).css("background","#fff");
});
$(".ImgLink").on("mouseout",function(){
    $(this).css("background","linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    $(this).css("background","-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
});

$("#AddButton").on("mouseover",function(){
    $("#AddButton").css("background","#fff");
});
$("#AddButton").on("mouseout",function(){
    $("#AddButton").css("background","#f0f0f0");
});
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
function InitContact() {
    $.ajax({
        type: "GET",
        url: "../Tools/CompanyAjax.ashx?act=contactList&account_id=" + $("#companyNameHidden").val(),
        success: function (data) {
            if (data != "") {
                $("#contactSelect").html(data).removeAttr("disabled");
            }
        },
    });
}
// 根据不同合同类型修改表单内容
function SelectType() {
    if (contractType == 1199)
        $(".text1").text("合同向导(定期服务合同)");
    if (contractType == 1200)
        $(".text1").text("合同向导(工时及物料合同)");
    if (contractType == 1201)
        $(".text1").text("合同向导(固定价格合同)");
    if (contractType == 1202)
        $(".text1").text("合同向导(预付时间合同)");
    if (contractType == 1203)
        $(".text1").text("合同向导(预付费合同)");
    if (contractType == 1204)
        $(".text1").text("合同向导(事件合同)");
}
// 设置工时表单
function SetTimeReporting() {

}
var endType = 1;
function getRadio(index) {
    if (index == 1) {
        endType = 1;
        $("#occurrences").attr("disabled", "disabled");
        $("#end_date").removeAttr("disabled");
    } else if (index == 2) {
        endType = 2;
        $("#end_date").attr("disabled", "disabled");
        $("#occurrences").removeAttr("disabled");
    }
}
var contractType;
window.onload=function () {
    contractType = $("#contractType").val();
    if ($("#isFinish").val() == "1") {
        $("#a0").hide();
        $("#b0").hide();
        $("#c0").hide();
        $("#d0").show();
        $(".Workspace").hide();
        $(".Workspace9").show();
        $("#currentPage").val(9);
        return;
    }
    if (contractType == 0) {
        $(".Workspace0").show();
        $("#currentPage").val(0);
    } else {
        $(".Workspace1").show();
        $("#currentPage").val(1);
    }
}

function AddService() {
    requestData("../Tools/ContractAjax.ashx?act=AddService&id=" + $("#ServiceNameHidden").val(), "", function (data) {
        var ids = $("#AddServiceIds").val().split(",");
        for (i = 0; i < ids.length; i++) {
            if (ids[i] == data[2]) {
                return;
            }
        }

        $("#ServiceBody").append(data[0]);
        $("#ServicePrice").val($("#ServicePrice").val() + data[1]);
        if ($("#AddServiceIds").val() == "")
            $("#AddServiceIds").val(data[2]);
        else
            $("#AddServiceIds").val($("#AddServiceIds").val() + "," + data[2]);
        CalcService();
    })
}

function AddServiceBundle() {
    requestData("../Tools/ContractAjax.ashx?act=AddServiceBundle&id=" + $("#ServiceNameHidden").val(), "", function (data) {
        var ids = $("#AddSerBunIds").val().split(",");
        for (i = 0; i < ids.length; i++) {
            if (ids[i] == data[2]) {
                return;
            }
        }

        $("#ServiceBody").append(data[0]);
        $("#ServicePrice").val($("#ServicePrice").val() + data[1]);
        if ($("#AddSerBunIds").val() == "")
            $("#AddSerBunIds").val(data[2]);
        else
            $("#AddSerBunIds").val($("#AddSerBunIds").val() + "," + data[2]);
        CalcService();
    })
}

function CalcService() {
    var ids = $("#AddServiceIds").val().split(",");
    var total = 0;
    for (i = 0; i < ids.length; i++) {
        var price = $("#price" + ids[i]).val() * $("#num" + ids[i]).val();
        price = Math.floor(price * 10000) / 10000;
        total += price;
        $("#pricenum" + ids[i]).val(price);
    }
    $("#ServicePrice").val(total);
}

function RemoveService(id) {
    $("#service" + id).hide();
    var ids = $("#AddServiceIds").val().split(",");
    var idRm = "";
    for (i = 0; i < ids.length; i++){
        if (ids[i] != id) {
            if (idRm == "")
                idRm = ids[i];
            else
                idRm = idRm + "," + ids[i];
        }
    }
    $("#AddServiceIds").val(idRm);
    CalcService();
}
function RemoveServiceBundle(id) {
    $("#service" + id).hide();
    var ids = $("#AddSerBunIds").val().split(",");
    var idRm = "";
    for (i = 0; i < ids.length; i++) {
        if (ids[i] != id) {
            if (idRm == "")
                idRm = ids[i];
            else
                idRm = idRm + "," + ids[i];
        }
    }
    $("#AddSerBunIds").val(idRm);
    CalcService();
}

function AddMil() {
    $("#MilList").hide();
    $("#MilAdd").show();
    $("#milName").val("");
    $("#milAmout").val("");
    $("#milAddCode").val("");
    $("#milDate").val("");
    $("#milCheckbox").prop("checked", false);
    $("#milCheckbox").css("checked", "");
    $("#milDesc").val("");
}

var milCnt = 1;
function AddMilOk() {
    if ($("#milName").val() == "") {
        alert("请输入标题");
        return;
    }
    if ($("#milDate").val() == "") {
        alert("请输入截止日期");
        return;
    }
    var txt = "<tr id='milestone" + milCnt + "'>";
    txt += "<td style='white - space:nowrap; vertical-align:bottom;'><img src = '../Images/delete.png' onclick='RemoveMil(" + milCnt + ")' alt = '' /></ td > ";
    txt += "<td><input type='text' disabled name='MilName" + milCnt + "' value='" + $("#milName").val() + "' /><input type='hidden' value='" + $("#milDesc").val() +"' name='MilDetail" + milCnt + "' /></td > ";
    txt += "<td nowrap><input type='text' disabled id='milAmount" + milCnt + "' name='MilAmount" + milCnt + "' value='" + $("#milAmout").val() +"' /></td>";
    txt += "<td nowrap><input type='text' disabled name='MilDate" + milCnt + "' value='" + $("#milDate").val() +"' /></td>";
    txt += "<td nowrap align='right'><input type='text' disabled value='" + $("#milAddCode").val() + "' /><input type='hidden' value='" + $("#milAddCodeHidden").val() +"' name='MilCode" + milCnt + "' /></td>";
    txt += "</tr>";
    $("#MilListBody").append(txt);
    $("#MilList").show();
    $("#MilAdd").hide();

    if ($("#milestoneAddList").val() == "") {
        $("#milestoneAddList").val(milCnt);
    } else {
        $("#milestoneAddList").val($("#milestoneAddList").val() + "," + milCnt);
    }
    milCnt++;
    CalcMilAmount();
}

function RemoveMil(id) {
    $("#milestone" + id).hide();

    var ids = $("#milestoneAddList").val().split(",");
    var idRm = "";
    for (i = 0; i < ids.length; i++) {
        if (ids[i] != id) {
            if (idRm == "")
                idRm = ids[i];
            else
                idRm = idRm + "," + ids[i];
        }
    }
    $("#milestoneAddList").val(idRm);
    CalcMilAmount();
}

function CalcMilAmount() {
    var ids = $("#milestoneAddList").val().split(",");
    var total = 0;
    for (i = 0; i < ids.length; i++) {
        var price = $("#milAmount" + ids[i]).val();
        price = Math.floor(price * 100) / 100;
        total += price;
    }
    $("#milAmountTotal").val("¥"+total);
}

function AddMilCancle() {
    $("#MilList").show();
    $("#MilAdd").hide();
}

function ShowResource() {
    $("#ResourceDiv").show();
}

function CheckRoleRate(id) {
    if ($("#roleRateCheck" + id).val() == "")
        $("#roleRateCheck" + id).val(id);
    else
        $("#roleRateCheck" + id).val("");
}

$(".grid table tbody tr").on("mousemove", function () {
    $(this).addClass('selected').siblings().removeClass('selected');
}).on("mouseout", function () {
    $(this).removeClass('selected');
});
