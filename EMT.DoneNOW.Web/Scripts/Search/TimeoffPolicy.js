function Add() {
    window.open("../SysSetting/AddTimeOffPolicy", windowObj.timeoffPolicy + windowType.add, 'left=0,top=0,location=no,status=no,width=910,height=920', false);
}
function Edit() {
    window.open("../SysSetting/AddTimeOffPolicy?id=" + entityid, windowObj.timeoffPolicy + windowType.add, 'left=0,top=0,location=no,status=no,width=910,height=920', false);
}
function Copy() {

}
function Delete() {
    LayerConfirm("删除操作将不能恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/TimeoffPolicyAjax.ashx?act=deletePolicy&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("删除失败，有员工关联不能删除！");
            }
        })
    }, function () { })
}