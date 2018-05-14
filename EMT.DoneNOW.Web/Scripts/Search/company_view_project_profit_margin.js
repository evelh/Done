$(function () {

   
    if ($("input[name = 'con3593']").val() != undefined) {
        $("#ProjectStatus").val($("input[name = 'con3593']").eq(0).val());
    }

    $("#IsBilled").html("<option value= ''></option><option value='1'>已计费</option><option value='2'>待计费</option>");
    if ($("input[name = 'con3592']").val() != undefined) {
        $("#IsBilled").val($("input[name = 'con3592']").eq(0).val());
    }
    $("#FilterSpan").hide();
    $("#FilterSelect").hide();
})

$("#Apply").click(function () {
    var searchType = $("#FilterPosted").val();
    var isbilled = $("#IsBilled").val();
    var projectStatus = $("#ProjectStatus").val();
    var accountId = "";
    if ($("input[name = 'con3594']").val() != undefined) {
        accountId = $("input[name = 'con3594']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
   
    url = "../Common/SearchBodyFrame.aspx?cat=1650&type=260&con3592=" + isbilled + "&con3593=" + projectStatus + "&con3594=" + accountId;
    
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})