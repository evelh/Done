$(function () {
    var maxNumber = 2000;
    $("#WordNumber").text(maxNumber);
    $("#insert").keyup(function () {
        var insert = $("#insert").val();
        if (insert != '') {
            var length = insert.length;
            $("#WordNumber").text(maxNumber - length);
            if (length > 2000) {
                $(this).val($(this).val().substring(0, 2000));
                $("#WordNumber").text("0");
            }
        }

    });
})
$("#addNote").click(function () {
    if ($("#insert").val() == "") {
        return;
    }
    requestData("../Tools/ActivityAjax.ashx?act=AddNote&account_id=" + $("#account_id").val() + "&desc=" + $("#insert").val() + "&type=" + $("#noteType").val(), null, function (data) {
        if (data[0] == "1") {
            RequestActivity();
        }
    })
})

$(".checkboxs input").each(function () {
    $(this).change(function () {
        RequestActivity();
    })
})
$("#OrderBy").change(function () {
    RequestActivity();
})
function RequestActivity() {
    LayerLoad();
    var type = "";
    if ($("#Todos").is(':checked'))
        type += "todo=1&";
    if ($("#Note").is(':checked'))
        type += "crmnote=1&";
    if ($("#Opportunities").is(':checked'))
        type += "opportunity=1&";
    if ($("#SalesOrders").is(':checked'))
        type += "sale=1&";
    if ($("#Tickets").is(':checked'))
        type += "ticket=1&";
    if ($("#Contracts").is(':checked'))
        type += "contract=1&";
    if ($("#Projects").is(':checked'))
        type += "project=1&";
    if (type == "") {
        setTimeout(function () {
            $("#activityContent").html("");
            LayerLoadClose();
        }, 500);
        return;
    }
    var url = "../Tools/ActivityAjax.ashx?act=GetActivities&" + type + "account_id=" + $("#account_id").val() + "&order=" + $("#OrderBy").val();
    requestData(url, null, function (data) {

        setTimeout(function () {
            $("#activityContent").html(data);
            LayerLoadClose();
        }, 500);
    })
}
function ActDelete(id) {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + id, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    RequestActivity();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}

function TodoComplete(id) {
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + id, null, function (data) {
        RequestActivity();
    })
}
function TodoEdit(id) {
    window.open("../Activity/Todos.aspx?id=" + id, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function NoteAddNote(cate, level, objType, objId) {
    window.open("../Activity/QuickAddNote.aspx?cate=" + cate + "&level=" + level + "&type=" + objType + "&objectId=" + objId, windowObj.notes + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function NoteEdit(id) {
    window.open("../Activity/Notes.aspx?id=" + id, windowObj.notes + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function NoteAddAttach(objId, objType) {
    window.open("../Activity/AddAttachment?objId=" + objId + "&objType=" + objType, windowObj.attachment + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function AttDelete(id) {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + id, null, function (data) {
            RequestActivity();
        })
    }, function () { })
}
function OpenAttachment(id, isUrl, name) {
    if (isUrl==1)
        window.open(name, windowType.blank, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    else
        window.open("../Activity/OpenAttachment.aspx?id=" + id, windowType.blank, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}