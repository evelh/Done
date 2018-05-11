$(function () {
    if ($("input[name = 'con3597']").val() != undefined) {
        $("#IsBilled").val($("input[name = 'con3597']").eq(0).val());
        //$("#isDiaodu").val($("input[name = 'con3595']").eq(0).val());
    }
    $("#FilterPosted").val("BillDate")
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    var isbilled = $("#IsBilled").val();
    var accountId = "";
    if ($("input[name = 'con3598']").val() != undefined) {
        accountId = $("input[name = 'con3598']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    if (searchType == "ItemDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1651&type=261&con3595=" + isbilled + "&con3596=" + accountId;
    }
    else if (searchType == "BillDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1652&type=262&con3597=" + isbilled + "&con3598=" + accountId;
    }
    location.href = url;
})
$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})