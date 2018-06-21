$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();




function TaskViewDetails() {
    window.open("../Project/TaskView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=1080,height=800', false);
}

function EditObject() {
    window.open("../Project/TaskAddOrEdit.aspx?id=" + entityid, windowObj.task + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}

function ModifySingTask() {
    window.open("../Project/TaskModify.aspx?taskIds=" + entityid, windowObj.task + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}

function AddToMyWorkList() {
    var userId = $("#loginUserId").val();
    if (entityid != "" && userId!="") {
        AddToWorkList(userId, entityid);
    }
}

function AddToPriResWorkList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.owner_resource_id != "" && data.owner_resource_id != null && data.owner_resource_id != undefined) {
                    AddToWorkList(data.owner_resource_id, entityid);
                } else {
                    LayerMsg("暂无主负责人");
                }
            }
        },
    });
}

function AddToOtherResWorkList() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                $("#ToOtherTaskNo").text(data.no);
            }
        },
    });

    $("#BackgroundOverLay").show();
    $("#ShowAddOtherDiv").show();
}

function ChooseOtherRes() {
    window.open("../Common/SelectCallBack.aspx?cat=913&field=ToOtherResIds&muilt=1&callBack=GetRes", 'chooseRes', 'left=200,top=200,width=600,height=800', false);
}
function GetRes() {
    var resIds = $("#ToOtherResIdsHidden").val();
    var resHtml = "";
    if (resIds != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetResList&ids=" + resIds,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    for (var i = 0; i < data.length; i++) {
                        resHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                    }
                }
            },
        });
    }
    $("#ResManySelect").html(resHtml);
    $("#ResManySelect option").dblclick(function () {
        RemoveResDep(this);
    })
}
function RemoveResDep(val) {
    $(val).remove();
    var ids = "";
    $("#ResManySelect option").each(function () {
        ids += $(this).val() + ',';
    })
    if (ids != "") {
        ids = ids.substr(0, ids.length - 1);
    }
    $("#ToOtherResIdsHidden").val(ids);
}

function SaveAddToOtherWorkList() {
    var resIds = $("#ToOtherResIdsHidden").val();
    if (resIds != "" && entityid != "") {
        AddToWorkList(resIds, entityid);
    }
    CloseDigAddOtherDiv();
}
function CloseDigAddOtherDiv() {
    $("#BackgroundOverLay").hide();
    $("#ShowAddOtherDiv").hide();
}
function AddToWorkList(resIds, taskId) {
    if (resIds == "" || taskId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/IndexAjax.ashx?act=AddWorkList&resIds=" + resIds + "&taskId=" + taskId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("添加成功！");
            } else {
                LayerMsg("添加失败！");
            }
        },
    });
}



function NewAddWorkEntry() {
    window.open("../Project/WorkEntry.aspx?task_id=" + entityid + "&NoTime=1", windowObj.workEntry + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}

function NewAddWorkEntryStart() {
    window.open("../Project/WorkEntry.aspx?task_id=" + entityid, windowObj.workEntry + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
}

function AddTaskServiceCall() {
    window.open("../ServiceDesk/TaskServiceCall?ticketId=" + entityid, windowObj.serviceCall + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}



function ViewNote() {
    window.open("../Project/ProjectNoteShow.aspx?task_id=" + entityid , '_blank', 'left=200,top=200,width=1080,height=800', false);
}
function ViewProject() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.project_id != "") {
                    window.open("../Project/ProjectView.aspx?id=" + data.project_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
                }
            }
        },
    });
}


