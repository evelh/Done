function Edit() {
    window.open("../SaleOrder/SaleOrderEdit.aspx?id=" + entityid, windowObj.saleOrder + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function NewNote() {
    OpenWindow("../Activity/Notes.aspx?saleorderId=" + entityid, windowObj.notes + windowType.add);
}
function NewTodo() {
    OpenWindow("../Activity/Todos.aspx?saleorderId=" + entityid, windowObj.notes + windowType.add);
}
function View(id) {
    window.open("../SaleOrder/SaleOrderView.aspx?id=" + id, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function CancelSaleOrder() {
    $.ajax({
        type: "GET",
        url: "../Tools/SaleOrderAjax.ashx?act=status&status_id=469&id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "True") {
                alert('取消成功');
                history.go(0);
            } else {
                alert("取消失败");
            }

        }
    })
}