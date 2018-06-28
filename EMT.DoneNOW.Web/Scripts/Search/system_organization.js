$(function () {
    $(".General").hide();
})
function Add() {
    window.open('../SysSetting/RegionManage', windowObj.Region + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Edit() {
    window.open("../SysSetting/RegionManage.aspx?id=" + entityid, windowObj.Region + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/AddressAjax.ashx?act=DeleteOrganization&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.result) {
                    LayerMsg("删除成功！");
                }
                else {
                    LayerMsg("删除失败！" + data.reason);
                }
                setTimeout(function () { history.go(0); }, 800);
            }
            
        }
    })
}

