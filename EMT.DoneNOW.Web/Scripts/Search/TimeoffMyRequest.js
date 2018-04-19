function Add() {
    if ($("input[name='con2743']").val() != "" && $("input[name='con2743']").val() != undefined) {
        window.open('../TimeSheet/TimeoffRequestAdd?resourceId=' + $("input[name='con2743']").val(), windowObj.timeoffRequest + windowType.add, 'left=0,top=0,location=no,status=no,width=825,height=679', false);
    } else {
        window.open('../TimeSheet/TimeoffRequestAdd', windowObj.timeoffRequest + windowType.add, 'left=0,top=0,location=no,status=no,width=825,height=679', false);
    }
}
function Cancle() {
    LayerConfirm("取消不可恢复，请确认", "确定", "取消", function () {
        requestData("../Tools/TimeoffPolicyAjax.ashx?act=cancleRequest&id=" + entityid, null, function (data) {
            if (data == true) {
                LayerAlert("取消成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("已取消、已拒绝申请不能取消。对应的工时已提交，不能删除");
            }
        })
    }, function () { })
}