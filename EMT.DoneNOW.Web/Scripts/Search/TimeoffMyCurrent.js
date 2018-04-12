var startDate;
window.onload = function () {
    $('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="Delete()">删除</li>');

    var dt = $("input[name='con2734']").val();
    var date; var endDate;
    if (dt != null && dt != "") {
        date = GetDateFromString(dt);
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

    if ($("input[name='con2735']").val() != undefined) {
        requestData("/Tools/TimesheetAjax.ashx?act=getStatus&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
            if (data == 1) {
                $('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="Submit()">提交</li>');
            } else if (data == 2) {
                $('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="CancleSubmit()">取消提交</li>');
            }
        })
    }
}
function Add() {
    window.open('../TimeSheet/RegularTimeAddEdit', windowObj.timeoffRequest + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
}
function Submit() {
    requestData("/Tools/TimesheetAjax.ashx?act=submit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function CancleSubmit() {
    requestData("/Tools/TimesheetAjax.ashx?act=cancleSubmit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function Delete() {
    requestData("/Tools/TimesheetAjax.ashx?act=delete&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("工时表未提交才可以删除");
        }
    })
}