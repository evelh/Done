$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Reject()">拒绝</li>');
$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Approve()">批准</li>');
var startDate;
window.onload = function () {
    var dt = $("input[name='con2739']").val();
    var date; var endDate;
    if (dt != null && dt != "") {
        date = new Date(dt);
    } else {
        date = new Date();
    }
    if (date.getDay() == 0) {
        date.setDate(date.getDate() - 6);
    } else {
        date.setDate(date.getDate() - date.getDay() + 1);
    }
    startDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
    endDate = new Date(date);
    endDate.setDate(date.getDate() + 6);
    $("#addDiv").html("<span style='color:#66D;'>日期：" + date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + "至" + endDate.getFullYear() + "-" + (endDate.getMonth() + 1) + "-" + endDate.getDate() + "</span>");
    
}
function Approve() {
    requestData("../Tools/TimesheetAjax.ashx?act=approve&ids=" + $("#param1").val(), null, function (data) {
        if (data == 1) {
            window.location.href = "../Common/SearchFrameSet.aspx?cat=1632&isCheck=1";
            LayerMsg("审批成功！");
        } else if (data == 0) {
            LayerMsg("审批失败，请重新查看待审批数据！");
        }
    })
}
function Reject() {
    $("#BackgroundOverLay").show();
    $("#RefuseExpenseReport").show();
}
$("#rejectButton").click(function () {
    var rejectReason = $("#rejectReason").val();
    if ($.trim(rejectReason) == "") {
        LayerMsg("请填写拒绝原因");
    } else {
        requestData("../Tools/TimesheetAjax.ashx?act=reject&ids=" + $("#param1").val() + "&reason=" + rejectReason, null, function (data) {
            if (data == true) {
                window.location.href = "Common/SearchFrameSet.aspx?cat=1632&isCheck=1";
            } else {
                LayerMsg("拒绝失败！");
            }
        })
    }
})