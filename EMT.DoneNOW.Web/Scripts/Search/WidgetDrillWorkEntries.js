$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();



function ViewTicket() {
    if (taskId != "") {
        window.open("../ServiceDesk/TicketView?id=" + taskId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
    }
   
}



function ViewTask() {
    if (taskId != "") {
        window.open("../Project/TaskView.aspx?id=" + taskId, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
   
}

var taskId = "";
function RightClickFunc() {
    $("#TicketMenu").hide();
    $("#TaskMenu").hide();
 
    taskId = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        async: false,
        success: function (data) {
            if (data != "") {
               
                taskId = data.task_id;
            }
        }
    });
    if (taskId != "" && taskId != undefined) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + taskId,
            success: function (data) {
                if (data == "1") {
                    $("#TicketMenu").show();
                }
                else {
                    $("#TaskMenu").show();
                }
            },
        });
    }

    ShowContextMenu();
}


