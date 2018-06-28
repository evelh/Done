$(function () {
    $(".General").hide();
})
function Add() {
    var year = "";
    var month = "";
    if ($("input[name = 'con5059']").val() != undefined) {
        var time = $("input[name = 'con5059']").eq(0).val();
        var timeArr = time.split('-');
        if (timeArr.length == 2) {
            year = timeArr[0];
            month = timeArr[1];
        }
    }
    
    window.open('../SaleOrder/SaleQuotaMonth?year=' + year + "&month=" + month, windowObj.saleQuota + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
   
}

function Edit() {
    window.open("../SaleOrder/SaleQuotaMonth.aspx?id=" + entityid, windowObj.saleQuota + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
}

function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/SaleOrderAjax.ashx?act=DeleteQuota&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })
}

//function RightClickFunc() {

//    ShowContextMenu();
//}

