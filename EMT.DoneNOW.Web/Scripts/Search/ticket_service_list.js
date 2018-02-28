$(function () {
    $(".General").hide();
    $("#SelectLi").show();
    $(".page.fl").hide();
    $("#RefreshLi").show();
})

// 新增待办
function AddTodo() {
    var ticketId = parent.$("#ticket_id").val();
    if (ticketId != "") {
        window.open("../Activity/Todos.aspx?ticketId=" + ticketId, windowObj.todos + windowType.add, 'left=200,top=200,width=800,height=800', false);
    }
}
// 新增服务预定
function AddServiceCall() {

}

function Refresh() {
    history.go(0);
}