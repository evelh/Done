$(function () {
    $("#BillSelectSpan").hide();
    $("#BillSpanName").hide();
    $("#FilterPosted").val("BillDate");
    
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    var accountId = "";
    if ($("input[name = 'con3601']").val() != undefined) {
        accountId = $("input[name = 'con3601']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    if (searchType == "ItemDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1653&type=263&con3600=" + accountId;
    }
    else if (searchType == "BillDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1654&type=264&con3601=" + accountId;
    }
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})