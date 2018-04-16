function Add() {
    window.open("../SysSetting/Holiday.aspx?hid=" + $("input[name='con1239']").val(), windowObj.holiday, 'left=0,top=0,location=no,status=no,width=450,height=400', false);
}
function Edit() {
    window.open("../SysSetting/Holiday.aspx?id=" + entityid, windowObj.holiday, 'left=0,top=0,location=no,status=no,width=450,height=400', false);
}
function Delete() {
    LayerConfirm("删除操作将不能恢复，是否继续？", "确定", "取消", function () {
        requestData("/Tools/GeneralAjax.ashx?act=DeleteHoliday&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            }
        })
    }, function () { });
}