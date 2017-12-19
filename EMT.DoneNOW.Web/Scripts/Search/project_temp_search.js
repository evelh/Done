$(function () {
    $("#PrintLi").hide();
})

function View(id) {
    OpenWindow("ProjectView.aspx?id=" + id, windowObj.project + windowType.blank);
}

function ViewDetail() {
    OpenWindow("../Project/ProjectView.aspx?id=" + entityid, windowObj.project + windowType.blank);
}

function Edit() {
    OpenWindow("../Project/ProjectAddOrEdit.aspx?id=" + entityid, windowObj.quote + windowType.edit);
}

function Delete() {
    if (confirm("确认删除该项目模板，删除不可恢复")) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=DeletePro&project_id=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result ) {
                        LayerMsg("删除项目模板成功！");
                        history.go(0);
                    } else if (!data.result ) {
                        LayerMsg("该项目模板不能被删除，因为有一个或多个时间条目，费用，费用，服务预定，备注，附件，里程碑！");
                    }
                }
            },
        });
    }
    
}
function Add() {
    OpenWindow("../Project/ProjectAddOrEdit.aspx?isTemp=1", windowObj.project + windowType.add);
}