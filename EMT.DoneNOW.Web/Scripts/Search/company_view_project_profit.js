$(function () {
    
    //$("#FilterPosted").val("BillDate");
    if ($("input[name = 'con3588']").val() != undefined) {
        $("#ProjectStatus").val($("input[name = 'con3588']").eq(0).val());
    }
    $("#BillSelectSpan").hide();
    $("#BillSpanName").hide();
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    //var isbilled = $("#IsBilled").val();
    var projectStatus = $("#ProjectStatus").val();
    var accountId = "";
    if ($("input[name = 'con3589']").val() != undefined) {
        accountId = $("input[name = 'con3589']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    if (searchType == "ItemDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1648&type=258&con3588=" + projectStatus + "&con3589=" + accountId;
    }
    else if (searchType == "BillDate") {
        url = "../Common/SearchBodyFrame.aspx?cat=1649&type=259&con3590=" + projectStatus + "&con3591=" + accountId;
    }
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})