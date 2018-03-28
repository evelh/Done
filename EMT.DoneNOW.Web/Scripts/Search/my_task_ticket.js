

function AddLabour() {
    var ticketStatus = "";
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=property&ticket_id=" + entityid +"&property=status_id",
        success: function (data) {
            ticketStatus = data;
        },
       
    });
    if (ticketStatus != "") {
        if (ticketStatus == "1894") {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralAjax.ashx?act=GetSysSetting&sys_id=41",
                async: false,
                success: function (data) {
                    if (data != "") {
                        if (data.setting_value == "1") {
                            window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=" + entityid, windowObj.workEntry + windowType.add, 'left=200,top=200,width=1000,height=800', false);
                        }
                        else {
                            LayerMsg("已完成工单不可添加工时！");
                        }
                    }
                }
            })
        }
        else {
            window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=" + entityid, windowObj.workEntry + windowType.add, 'left=200,top=200,width=1000,height=800', false);
        }
    }
}
function AddServiceLabour() {

}
function EditTicket() {
    window.open("../ServiceDesk/TicketManage?id=" + entityid, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}
function ViewTicket() {
    window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
}
function ViewTicketHistory() {

}
function ViewTicketOpenHistory() {

}
function ToGoReport() {

}
function CopyTicket() {

}
function CopyTicketToProject() {

}
function MergeToTicket() {

}
function AbsorbToTicket() {

}
function AddServiceCall() {

}
function AddTicketNote() {
    window.open("../Project/TaskNote.aspx?ticket_id=" + entityid + "&notifi_type=", windowObj.notes + windowType.add  , 'left=200,top=200,width=1080,height=800', false);
}
function ModifyTicket() {

}
function DeleteTicket() {
    LayerConfirm("确认删除该工单吗？", "是", "否", function () {
        //$("#BackgroundOverLay").show();
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=DeleteTicket&ticket_id=" + entityid,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("删除成功！");
                        history.go(0);
                    }
                    else {
                       
                    }
                }
            }
        })

    }, function () {

    });
}
function AddMyWorkList() {

}
function AddPriWorkList() {

}
function AddOtherWorkList() {

}
function DisProject() {

}

// 新增工单
function AddTicket(ticket_type_id) {
    if (ticket_type_id == "") {
        OpenWindow("../ServiceDesk/TicketManage", windowObj.ticket + windowType.add, );
    }
    else {
        OpenWindow("../ServiceDesk/TicketManage?ticket_type_id=" + ticket_type_id, windowObj.ticket + windowType.add, );
    }

}


// 右键菜单处理
function RightClickFunc() {
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + entityid,
        success: function (data) {
            if (data == "1") {
                $(".ticket").show();
                $(".task").hide();
            }
            else if (data == "2"){
                $(".ticket").hide();
                $(".task").show();
            }
            else {
                $(".ticket").hide();
                $(".task").hide();
            }
        },
        error: function () {
            $(".ticket").hide();
            $(".task").hide();
        },
    });

    ShowContextMenu();
    $("#menuUl").width(240);
}


function AddTaskLabour() {
    if (entityid != "" && entityid != undefined) {
        window.open("../Project/WorkEntry.aspx?task_id=" + entityid, windowObj.workEntry + windowType.add , 'left=200,top=200,width=1080,height=800', false);
    }
}

function AddTaskServiceLabour() {

}

function EditTask() {
    window.open("../Project/TaskAddOrEdit.aspx?id=" + entityid, windowObj.task + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function AddTaskServiceCall() {

}

function ViewTask() {
    window.open("../Project/TaskView.aspx?id=" + entityid, '_blank', 'left=200,top=200,width=1080,height=800', false);

}
function ViewTaskNote() {
    window.open("../Contract/ContractNoteShow.aspx?task_id=" + entityid, '_blank', 'left=200,top=200,width=1080,height=800', false);
}

function ViewProject() {
    var project_id = "";
    $.ajax({
        type: "GET",
        async: false,
        //dataType: "json",
        url: "../Tools/TicketAjax.ashx?act=property&ticket_id=" + entityid + "&property=project_id",
        success: function (data) {
            project_id = data;
        },

    });
    if (project_id != "" && project_id != null && project_id != undefined) {
        window.open("../Project/ProjectView.aspx?id=" + project_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}

function ToGoTaskReport() {


}
function AddTaskMyWorkList() {

}

function AddTaskPriWorkList() {

}

function AddTaskOtherWorkList() {


}





