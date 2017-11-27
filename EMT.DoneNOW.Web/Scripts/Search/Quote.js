function Edit() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?id=" + entityid, windowObj.quote + windowType.edit);
}
function ViewOpp() {
    OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, windowType.blank);
}
function ViewCompany(id) {
    OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, windowType.blank);
}
function LossQuote() {
    OpenWindow("../Quote/QuoteLost.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}
function CloseQuote() {
    OpenWindow("../Quote/QuoteClose.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}
function QuotePref() {
    OpenWindow("../Quote/PreferencesQuote.aspx?quote_id=" + entityid, windowType.blank);
}
function QuoteManage() {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + entityid, windowObj.quote + windowType.view);
}
function DeleteQuote() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteAjax.ashx?act=delete&id=" + entityid,
        success: function (data) {
            alert(data);
        }
    })
}
function View(id) {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + id, windowObj.quote + windowType.view);
}
function Add() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx", windowObj.quote + windowType.add);
}
function ViewQuote() {
    OpenWindow("../Quote/QuoteView.aspx?id=" + entityid, windowType.blank);
}