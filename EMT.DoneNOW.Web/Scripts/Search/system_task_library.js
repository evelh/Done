$(function () {
    $(".General").hide();
})


function Edit() {
    window.open("../Project/TaskToLibrary.aspx?id=" + entityid, windowObj.general + windowType.edit, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=DeleteTaskLibary&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            setTimeout(function () { history.go(0); }, 800)
        }
    })
}