$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function ApprovalAndPost() {
    if (queryTypeId != "") {
        OpenWindow('../Contract/ContractPostDate.aspx?type=' + queryTypeId + '&id=' + entityid, windowObj.expense + windowType.manage);
    }

}

function AjustPrice() {
    if (queryTypeId != "") {
        window.open('../Contract/AdjustExtendedPrice.aspx?type=' + queryTypeId + '&id=' + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

    }
}

function EditCost() {
    // 编辑工时
    var taskId = "";
    $.ajax({
        type: "GET",
        url: "../Tools/ApproveAndPostAjax.ashx?act=GetLabourInfo&id=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                // todo 获取taskId 判断是工时还是工单
                taskId = data.task_id;
            }
        }
    });
    if (taskId != "" && taskId != undefined) {
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + taskId,
            success: function (data) {
                if (data == "1") {
                    window.open("../ServiceDesk/TicketLabour.aspx?id=" + entityid, windowObj.workEntry + windowType.edit, 'left=0,top=0,location=no,status=no,width=1000,height=943', false);
                }
                else if (data == "2") {
                    OpenWindow("../Project/WorkEntry.aspx?id=" + entityid, windowObj.workEntry + windowType.edit);
                }

            },

        });
    }

}

function EditTicket() {
    if (task_id != "" && isTicket == "1") {
        window.open("../ServiceDesk/TicketManage?id=" + task_id, windowObj.ticket + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
    }
}

function ShowMile() {
    window.open('../Contract/ContractMilestoneDetail.aspx?id=' + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function ShowContract() {
    if (contract_id != "") {
        window.open("../Contract/ContractView.aspx?id=" + contract_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}

function ShowEntry() {
    OpenWindow("../Project/EntryDetail.aspx?id=" + entityid, windowObj.workEntry + windowType.blank);
}

function ShowProject() {
    if (project_id != "") {
        window.open("../Project/ProjectView.aspx?id=" + project_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}

function ShowTask() {
    if (task_id != "") {
        if (isTicket == "1") {
            window.open("../ServiceDesk/TicketView?id=" + entityid, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
        }
        else {
            window.open("../Project/TaskView.aspx?id=" + task_id, '_blank', 'left=200,top=200,width=1080,height=800', false);

}

function MakeAsNoBill() {
    if (queryTypeId != "") {
        $.ajax({
            type: "GET",
            url: "../Tools/ApproveAndPostAjax.ashx?act=nobilling&id=" + entityid + "&type=" + queryTypeId,
            async: false,
            success: function (data) {
                alert(data);
            }
        });
        setTimeout(function () { history.go(0); }, 800);
    }
}







var itemType = "";
var contract_id = "";
var task_id = "";
var project_id = "";
var isTicket = "";
var queryTypeId = "";

function RightClickFunc() {
    $(".menu").hide();

    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/InvoiceAjax.ashx?act=GetItemType&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                itemType = data.itemType;
                contract_id = data.contract_id;
                task_id = data.task_id;
            }
        },
    });

    if (task_id != "" && task_id != undefined && task_id != null) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + task_id,
            success: function (data) {
                if (data == "1") {
                    isTicket == "1";
                    $("#taskMenu").text("工单详情");
                }
                else {
                    isTicket == "";
                    $("#taskMenu").text("任务详情");
                }
            },
        });

        if (isTicket == "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + task_id,
                success: function (data) {
                    if (data != "") {
                        project_id = data.project_id;
                    }
                },
            });
        }
        else {
            project_id = "";
        }

    }

    if (itemType == "cost") {
        $("#appPostMenu").show();
        $("#AjustPriceMenu").show();
        $("#EditChargeMenu").show();

        $("#contractMenu").show();
        $("#MakeAsNoBillMenu").show();
        // $("#appPostMenu").show();
        queryTypeId = "84";
    }
    else if (itemType == "entry") {
        $("#appPostMenu").show();
        $("#EditChargeMenu").show();

        if (task_id != "") {
            if (isTicket == "1") {
                $("#EditTicketMenu").show();
                $("#TaskMenu").show();

            } else {
                $("#AjustPriceMenu").show();
                $("#TaskMenu").show();
                if (project_id != "") {
                    $("#ProjectMenu").show();
                }
            }
        }

        $("#EntrytMenu").show();
        if (contract_id != "") {
            $("#contractMenu").show();
        }

        $("#appPostMenu").show();
        $("#appPostMenu").show();
        queryTypeId = "133";
    }
    else if (itemType == "service") {
        $("#appPostMenu").show();
        $("#AjustPriceMenu").show();
        if (contract_id != "") {
            $("#contractMenu").show();
        }
        queryTypeId = "87";
    }
    else if (itemType == "milestone") {
        $("#appPostMenu").show();
        $("#MileDetailMenu").show();
        if (contract_id != "") {
            $("#contractMenu").show();
        }
        queryTypeId = "85";
    }
    else if (itemType == "expense") {
        $("#appPostMenu").show();
        $("#AjustPriceMenu").show();
        if (task_id != "" && isTicket == "1") {
            $("#EditTicketMenu").show();
        }
        if (contract_id != "") {
            $("#contractMenu").show();
            $("#TaskMenu").show();
        }
        $("#MakeAsNoBillMenu").show();
        queryTypeId = "124";
    }
    else if (itemType == "subscription") {
        $("#appPostMenu").show();
        $("#AjustPriceMenu").show();
        queryTypeId = "86";
    }
    else {
        queryTypeId = "";
    }


    ShowContextMenu();
}