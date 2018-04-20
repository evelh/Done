var startDate;
var status = 0;
$('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="AddProjectEntry(\'\')"><i style="background-image: url(../Images/new.png);"></i>项目工时(起止时间)</li>');
$('.contenttitle ul li').eq(0).after('<li style="text-align:center;padding:0 8px;" onclick="AddProjectEntry(\'1\')"><i style="background-image: url(../Images/new.png);"></i>项目工时</li>');
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
                $('.contenttitle ul li').eq(2).after('<li style="text-align:center;padding:0 8px;" onclick="Submit()">提交</li>');
            } else if (data == 2) {
                $('.contenttitle ul li').eq(2).after('<li style="text-align:center;padding:0 8px;" onclick="CancleSubmit()">取消提交</li>');
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
function AddProjectEntry(type) {
    window.open("../Project/WorkEntry.aspx?NoTime=" + type + "&chooseDate=" + startDate, windowType.add, 'left=200,top=200,width=1080,height=800', false);
}
function Add() {
    if (status == 1) {
        window.open('../TimeSheet/RegularTimeAddEdit?startDate=' + startDate + '&resourceId=' + $("input[name='con2735']").val(), windowObj.timeoffRequest + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
    } else {
        LayerMsg("工时表提交后不能新增");
    }
}
function Edit() {
    if (status == 1) {
        requestData("/Tools/TimesheetAjax.ashx?act=getType&id=" + entityid, null, function (data) {
            if (data[0] == false) {
                LayerMsg("未知工时");
                return;
            } else if (data[1]==1) {
                window.open('../TimeSheet/RegularTimeAddEdit?id=' + entityid, windowObj.timeoffRequest + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
            } else if (data[1] == 2) {
                LayerMsg("休假请求不能修改");
                return;
            } else if (data[1] == 3) {
                window.open('../Project/WorkEntry?id=' + data[2], windowObj.workEntry + windowType.manage, 'left=0,top=0,location=no,status=no,width=925,height=755', false);
            } else if (data[1] == 4) {
                window.open("../ServiceDesk/TicketLabour.aspx?id=" + data[2], windowObj.workEntry + windowType.edit, 'left=0,top=0,location=no,status=no,width=1000,height=943', false);
            }
        })
    } else {
        LayerMsg("工时表提交后不能修改、删除");
    }
}
function Submit() {
    requestData("/Tools/TimesheetAjax.ashx?act=submitCheck&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
        if (data == 1) {
            LayerConfirmOk("工时表为空，需要提交吗？", "确定", "取消", function () {
                requestData("/Tools/TimesheetAjax.ashx?act=submit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
                    if (data == true) {
                        window.location.reload();
                    } else {
                        LayerMsg("已审批和已提交工时表不能提交");
                    }
                })
            })
        } else if (data==2) {
            LayerMsg("已审批和已提交工时表不能提交");
        } else if (data == 0) {
            LayerConfirmOk("要将所有工时提交吗？", "确定", "取消", function () {
                requestData("/Tools/TimesheetAjax.ashx?act=submit&startDate=" + startDate + "&resId=" + $("input[name='con2735']").val(), null, function (data) {
                    if (data == true) {
                        window.location.reload();
                    } else {
                        LayerMsg("已审批和已提交工时表不能提交");
                    }
                })
            })
        }
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