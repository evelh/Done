
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

function Add() {
    var ids = "";
    $(".IsChecked").each(function () {
        if ($(this).is(":checked")) {
            ids += $(this).val() + ',';
        }
    });

    if (ids != "") {
        ids = ids.substring(0, ids.length - 1);
        $.ajax({
            type: "GET",
            url: "../Tools/ReverseAjax.ashx?act=Labour&ids=" + ids,
            success: function (data) {
                alert(data);
                history.go(0);
            }
        })
    } else {
        alert("请选择需要审批的数据！");
    }
}