$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();



function ShowLabour() {
    if (object_id != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetLabourInfo&id=" + object_id,
            dataType: 'json',
            success: function (data) {
                if (data != "") {
                    window.open("../Project/EntryDetail?id=" + object_id, windowType.blank, 'left=200,top=200,width=1280,height=800', false);  
                }
            },
        });
        
    }
    
}

function ShowTicket() {
    
    if (task_id != "") {
        if (isTicket == "1") {
            window.open("../ServiceDesk/TicketView?id=" + task_id, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
        }
        else {
            window.open("../Project/TaskView.aspx?id=" + task_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
        }
    }
}

function ShowProject() {
    if (project_id != "") {
        window.open("../Project/ProjectView.aspx?id=" + project_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}

function ShowContract() {
    if (contract_id != "") {
        window.open("../Contract/ContractView.aspx?id=" + contract_id, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}


var contract_id = "";
var task_id = "";
var object_id = "";
var project_id = "";
var isTicket = "";
// 右键菜单处理
function RightClickFunc() {
    $("#labourMenu").hide();
    $("#projectMenu").hide();
    $("#taskMenu").hide();
    $("#contractMenu").hide();

    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/InvoiceAjax.ashx?act=GetAccDedItem&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                contract_id = data.contract_id;
                task_id = data.task_id;
                object_id = data.object_id;
            }
        },
    });
    if (contract_id != "" && contract_id != undefined && contract_id != null) {
        $("#contractMenu").show();
    }
    if (task_id != "" && task_id != undefined && task_id != null) {
        $("#taskMenu").show();
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=IsTicket&ticket_id=" + task_id,
            success: function (data) {
                if (data == "1") {
                    isTicket = "1";
                    $("#taskMenu").text("工单详情");
                }
                else {
                    isTicket = "";
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
    else {
        project_id = "";
    }

    if (object_id != "") {
       
    }

    ShowContextMenu();
}