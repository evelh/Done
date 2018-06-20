function Add() {
    window.open("../SysSetting/UserDefinedField.aspx", windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=550,height=650', false);
}
function Edit() {
    window.open("../SysSetting/UserDefinedField.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=550,height=650', false);
}
function Active() {
    requestData("/Tools/SysSettingAjax.ashx?act=UpdateUdfStatus&active=1&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function InActive() {
    requestData("/Tools/SysSettingAjax.ashx?act=UpdateUdfStatus&active=0&id=" + entityid, null, function (data) {
        window.location.reload();
    })
}
function Delete() {
    LayerConfirmOk("删除操作将不能恢复，是否继续?", "确定", "取消", function () {
        requestData("/Tools/SysSettingAjax.ashx?act=DeleteUdf&id=" + entityid, null, function (data) {
            window.location.reload();
        })
    })
}
function RightClickFunc() {
    requestData("/Tools/SysSettingAjax.ashx?act=UdfStatus&id=" + entityid, null, function (data) {
        if (data == 1) {
            $("#ActiveLi").hide();
            $("#InActiveLi").show();
        } else {
            $("#ActiveLi").show();
            $("#InActiveLi").hide();
        }
        ShowContextMenu();
    })
}
