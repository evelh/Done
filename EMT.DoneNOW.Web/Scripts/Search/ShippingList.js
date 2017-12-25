$(document).ready(function () {
    var html = $(".contenttitle ul").html();
    html = "<li class='General' onclick=Ship()><span style='margin: 0 10px;'>配送</span></li><li class='General'><span style='margin: 0 10px;'>打印拣货清单</span></li><li class='General'><span style='margin: 0 10px;'>打印包装清单</span></li>";
    $(".contenttitle ul").html(html + $(".contenttitle ul").html());
    $("#PrintLi").hide();
})
$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
        $(".IsChecked").css("checked", "checked");
    }
    else {
        $(".IsChecked").prop("checked", false);
        $(".IsChecked").css("checked", "");
    }
})
function Ship() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });
    if (ids != "") {
        var edit = 0;
        LayerConfirm("是否将全部产品已配送的销售订单状态改为“已完成”?", "是", "否", function () { edit = 1; }, function () { edit = 0; });
        ids = ids.substring(0, ids.length - 1);
        requestData("/Tools/PurchaseOrderAjax.ashx?act=purchaseShip&ids=" + ids + "&isEditSo=" + edit, null, function (data) {
            window.location.reload();
        })
    } else {
        LayerMsg("请选择待配送产品！");
    }
}