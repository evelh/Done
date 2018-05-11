$(function () {

    if ($("input[name = 'con3578']").val() != undefined) {
        $("#IsBilled").val($("input[name = 'con3578']").eq(0).val());
    }
    $("#FilterPosted").val("BillDate");
    $("#IsBilled").html("<option value=''></option><option value='1'>计费</option><option value='2'>不计费</option>");
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    var isbilled = $("#IsBilled").val();
    var accountId = "";
    if ($("input[name = 'con3579']").val() != undefined) {
        accountId = $("input[name = 'con3579']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    if (searchType == "ItemDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1643&type=253&con3576=" + isbilled + "&con3577=" + accountId;
    }
    else if (searchType == "BillDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1644&type=254&con3578=" + isbilled + "&con3579=" + accountId;
    }
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})