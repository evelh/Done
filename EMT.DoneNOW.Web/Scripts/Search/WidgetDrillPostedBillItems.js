$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();



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
    }
}


var itemType = "";
var contract_id = "";
var task_id = "";
var project_id = "";
var isTicket = "";


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
                    $("#TaskMenu").text("工单详情");
                }
                else {
                    isTicket == "";
                    $("#TaskMenu").text("任务详情");
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
      
        if (task_id != "" && isTicket == "1") {
            $("#TaskMenu").show();
        }
        if (contract_id != "") {
            $("#contractMenu").show();
        }
    }
    else if (itemType == "entry") {
      
        $("#EntrytMenu").show();
        if (contract_id != "") {
            $("#contractMenu").show();
        }

        if (task_id != "") {
            $("#TaskMenu").show();
            if (isTicket == "" && project_id != "") {
                $("#ProjectMenu").show();
            } 
        }
    }
    else if (itemType == "service") {
        if (contract_id != "") {
            $("#contractMenu").show();
        }
    }
    else if (itemType == "milestone") {
        $("#MileDetailMenu").show();
        if (contract_id != "") {
            $("#contractMenu").show();
        }
    }
    else if (itemType == "expense") {
       
    }
    else if (itemType == "subscription") {
       
    }
    else {
        queryTypeId = "";
    }


    ShowContextMenu();
}
