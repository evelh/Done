var startDate;
var status = 0;
window.onload = function () {
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
            status = data;
        })
    }
}
function RightClickFunc() {
    if (entityid != "") {
        ShowContextMenu();
    }
}
function Add() {
    if (status == 1) {
        window.open('../TimeSheet/RegularTimeAddEdit', windowObj.timeoffRequest + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
    } else {
        LayerMsg("工时表提交后不能新增");
    }
}
function Edit() {
    if (status == 1) {
        requestData("/Tools/TimesheetAjax.ashx?act=getType&id=" + entityid, null, function (data) {
            if (data[0] == true) {
                window.open('../TimeSheet/RegularTimeAddEdit?id=' + entityid, windowObj.timeoffRequest + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
            } else {
                window.open('../Project/WorkEntry?id=' + data[1], windowObj.workEntry + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
            }
        })
    } else {
        LayerMsg("工时表提交后不能修改、删除");
    }
}
function Submit() {
    LayerConfirmOk("要将所有工时提交吗", "确定", "取消", function () {
        requestData("/Tools/TimesheetAjax.ashx?act=submit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("已审批和已提交工时表不能提交");
            }
        })
    })
}
function CancleSubmit() {
    LayerConfirmOk("该操作不可恢复，请确认", "确定", "取消", function () {
        requestData("/Tools/TimesheetAjax.ashx?act=cancleSubmit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("已提交工时表才能取消");
            }
        })
    })
}
function Delete() {
    if (status == 1) {
        LayerConfirmOk("删除不可恢复，请确认", "确定", "取消", function () {
            requestData("/Tools/TimesheetAjax.ashx?act=deleteWorkEntry&id=" + entityid, null, function (data) {
                if (data == true) {
                    window.location.reload();
                } else {
                    LayerMsg("工时表未提交才可以删除");
                }
            })
        })
    } else {
        LayerMsg("工时表提交后不能修改、删除");
    }
}