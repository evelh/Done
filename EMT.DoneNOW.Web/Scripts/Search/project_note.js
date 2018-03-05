$(function () {
    $(".General").hide();
})
// 在父页面上展示详情
function ViewNote() {
    debugger;
    window.parent.ShowNoteDetail(entityid);
}
function View(id) {
    debugger;
    window.parent.ShowNoteDetail(id);
}

function EditNote() {
    window.open("../Project/TaskNote.aspx?id=" + entityid, windowObj.notes + windowType.edit , 'left=200,top=200,width=1080,height=800', false);
}
function DeleteNote() {
    LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DeleteNote&note_id=" + entityid,
            async: false,
            //dataType: json,
            success: function (data) {

                if (data == "True") {
                    LayerMsg("删除成功");
                } else {
                    LayerMsg("删除失败");
                }

                //history.go(0);
                parent.history.go(0);
            }
        })
    }, function () { });
}

function Add() {
    debugger;
    var object_id = "";
    if ($("input[name = 'con1054']").val() != undefined) {
        object_id = $("input[name = 'con1054']").val();
    }
    if (object_id != "") {
        debugger;
        var parAddType = $("#AddNoteType", parent.document).val();
        if (parAddType == "contract") {
            var contract_id = $("#contract_id", parent.document).val();
            window.open("../Project/TaskNote.aspx?contract_id=" + contract_id, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
        }
        else if (parAddType == "task"){
            window.open("../Project/TaskNote.aspx?task_id=" + object_id, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
        }
        else {
            window.open("../Project/TaskNote.aspx?project_id=" + object_id, windowObj.notes + windowType.add, 'left=200,top=200,width=1080,height=800', false);
        }

    }
 
}

