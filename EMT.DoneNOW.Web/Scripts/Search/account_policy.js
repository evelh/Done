
$(function () {
    $(".General").hide();
    $(".OrderTh").removeAttr("onclick");
    ShowThisExp();
})

// 找到费用id是这个的元素 特殊显示
function ShowThisExp()
{
    var exp_id = window.parent.document.getElementById("thisRuleId").value;
    
    if (exp_id != undefined && exp_id != "" && exp_id != null) {

        $(".dn_tr").each(function () {
            var thisId = $(this).data("val");
            if (thisId == exp_id) {
                $(this).css("color", "red");
                return false;
            }
        })
    }
    
}
