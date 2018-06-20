$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();



function Add() {
    window.open("../ServiceDesk/MasterTicket", windowType.masterTicket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function Edit() {
    window.open("../ServiceDesk/MasterTicket?id=" + entityid, windowType.masterTicket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}

function Delete() {
    window.open("../ServiceDesk/DeleteMasterTicket?ticket_id=" + entityid, windowType.masterTicket + windowType.Delete, 'left=200,top=200,width=1280,height=800', false);
}

function InActive() {
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=RecStatusManage&ticket_id=" + entityid + "&is_active=0",
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("停用成功！");
            } else {
                LayerMsg("停用失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })
}
function Active() {
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=RecStatusManage&ticket_id=" + entityid + "&is_active=1",
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("激活成功！");
            } else {
                LayerMsg("激活失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })
}

function RightClickFunc() {

    // 获取状态-是否激活 控制显示隐藏
    $("#InActTic").hide();
    $("#ActTic").hide();
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=GetRecTicket&ticket_id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.is_active == "1") {
                    $("#InActTic").show();
                }
                else {
                    $("#ActTic").show();
                }
            }
        }
    })

    ShowContextMenu();
}
