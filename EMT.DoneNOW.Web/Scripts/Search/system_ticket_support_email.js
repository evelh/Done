$(function () {
    $(".General").hide();
})

function Edit() {
    window.open("../General/GeneralManage.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function RightClickFunc() {
    $("#DeleteLi").hide();
    ShowContextMenu();
}
