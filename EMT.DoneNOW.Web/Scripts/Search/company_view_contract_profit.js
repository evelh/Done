$(function () {

    
    //$("#FilterPosted").val("BillDate");
    $("#IsBilled").html("<option value=''></option><option value='1'>激活</option><option value='0'>未激活</option>");
    if ($("input[name = 'con3581']").val() != undefined) {
        $("#IsBilled").val($("input[name = 'con3581']").eq(0).val());
    }
    $("#BillSpanName").text("合同状态");
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    var isbilled = $("#IsBilled").val();
    var accountId = "";
    if ($("input[name = 'con3586']").val() != undefined) {
        accountId = $("input[name = 'con3586']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    if (searchType == "ItemDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1645&type=255&con3581=" + isbilled + "&con3586=" + accountId;
    }
    else if (searchType == "BillDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1646&type=256&con3582=" + isbilled + "&con3587=" + accountId;
    }
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})