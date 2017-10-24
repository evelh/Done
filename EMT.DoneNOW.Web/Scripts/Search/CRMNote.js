function Add() {
    window.open("../Activity/Notes.aspx", windowObj.notes + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Edit() {
    window.open("../Activity/Notes.aspx?id=" + entityid, windowObj.notes + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function SetScheduled() {

}

function Delete() {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + entityid, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}