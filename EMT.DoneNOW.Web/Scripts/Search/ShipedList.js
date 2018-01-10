$(document).ready(function () {
    var html = $(".contenttitle ul").html();
    html = "<li class='General' onclick=Ship()><span style='margin: 0 10px;'>取消配送</span></li><li class='General'><span style='margin: 0 10px;'>打印拣货清单</span></li><li class='General'><span style='margin: 0 10px;'>打印包装清单</span></li>";
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
        LayerConfirm("确认取消配送吗？", "确定", "取消", function () {
            ids = ids.substring(0, ids.length - 1);
            requestData("/Tools/PurchaseOrderAjax.ashx?act=purchaseUnShip&ids=" + ids, null, function (data) {
                if (data == "") {
                    window.location.reload();
                } else {
                    LayerMsg(data);
                }
            })
        }, function () { })
    } else {
        LayerMsg("请选择待取消配送产品！");
    }
}