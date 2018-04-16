function Add() {
    window.open("../SysSetting/HolidaySet.aspx", windowObj.holidaySet, 'left=0,top=0,location=no,status=no,width=650,height=500', false);
}
function Edit() {
    window.open("../SysSetting/HolidaySet.aspx?id=" + entityid, windowObj.holidaySet, 'left=0,top=0,location=no,status=no,width=650,height=500', false);
}
function Delete() {
    LayerConfirm("删除操作将不能恢复，是否继续？", "确定", "取消", function () {
        requestData("/Tools/GeneralAjax.ashx?act=DeleteHolidaySet&id=" + entityid, null, function (data) {
            if (data == true) {
                window.location.reload();
            } else {
                LayerMsg("请先删除节假日详情");
            }
        })
    }, function () { });
}