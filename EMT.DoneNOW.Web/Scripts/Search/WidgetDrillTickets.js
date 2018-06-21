$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


$(function () {
    $("#btnEditMaster").hide();
    $("#AccTicketHistory").hide();
    $("#ReportHidden").hide();

    $("#MenuAddNewCall").hide();
    $("#MenuAddAlreadyCall").hide();
    
})
