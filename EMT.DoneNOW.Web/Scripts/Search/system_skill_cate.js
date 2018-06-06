$(function () {

})
function Add() {
    window.open("../SysSetting/ResourceDicCateForm.aspx", windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Edit() {
    window.open("../SysSetting/ResourceDicCateForm.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/GeneralAjax.ashx?act=DeleteSkillFromGeneral&id" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })

}