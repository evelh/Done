$(function () {
    $(".General").hide();
})

function View(id) {
    debugger;
    window.parent.ShowCandeldarDetail(id);
}
function ViewCalendar() {
    debugger;
    window.parent.ShowCandeldarDetail(entityid);
}
function EditCalendar() {
    window.open("../Project/ProjectCalendar.aspx?id=" + entityid, windowObj.projectCalendar + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}
function Add() {
    var project_id = $("#id").val();
    if (project_id != "") {
        window.open("../Project/ProjectCalendar.aspx?project_id=" + project_id, windowObj.projectCalendar + windowType.add, 'left=200,top=200,width=1080,height=800', false);
    }

}

function Delete() {
    LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DeleteCalendar&cal_id=" + entityid,
            async: false,
            //dataType: json,
            success: function (data) {

                if (data == "True") {
                    LayerMsg("删除成功");
                } else {
                    LayerMsg("删除失败");
                }

                history.go(0);
            }
        })
    }, function () { });
}
