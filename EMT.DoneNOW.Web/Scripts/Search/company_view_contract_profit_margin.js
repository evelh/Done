$(function () {
    $("#FilterSpan").hide();
    $("#FilterSelect").hide();
    $("#FilterPosted").val("BillDate");
    if ($("input[name = 'con3583']").val() != undefined) {
        $("#IsBilled").val($("input[name = 'con3583']").eq(0).val());
    }
    $("#BillSelectSpan").after("<span style='margin- left:10px;'>合同状态</span><span><select id='ContractStatus'><option value=''></option><option value='1'>已计费</option><option value='2'>待计费</option></select></span>")

    if ($("input[name = 'con3584']").val() != undefined) {
        $("#ContractStatus").val($("input[name = 'con3584']").eq(0).val());
    }
   
})

$("#Apply").click(function () {
    //var searchType = $("#FilterPosted").val();
    var isbilled = $("#IsBilled").val();
    var contractStatus = $("#ContractStatus").val();
    var accountId = "";
    if ($("input[name = 'con3585']").val() != undefined) {
        accountId = $("input[name = 'con3585']").eq(0).val();
    }
    if (accountId == "" || accountId == undefined) {
        return;
    }
    var url = "";
    url = "../Common/SearchBodyFrame.aspx?cat=1647&type=257&con3583=" + isbilled + "&con3584=" + contractStatus + "&con3585=" + accountId;
    location.href = url;
})

$("#ReturnUpper").click(function () {
    parent.ShowFunanic();
})