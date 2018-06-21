$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function Edit() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?id=" + entityid, windowObj.quote + windowType.edit);
}
function QuotePref() {
    OpenWindow("../Quote/PreferencesQuote.aspx?quote_id=" + entityid, windowType.blank);
}
function QuoteManage() {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + entityid, windowObj.quote + windowType.view);
}


function View(id) {
    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + id, windowObj.quote + windowType.view);
}


function ViewOpp() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteAjax.ashx?act=GetQuote&quoteId=" + entityid,
        async: false,
        dataType:'json',
        success: function (data) {
            if (data != "") {
                if (data.opportunity_id != "") {
                    OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + data.opportunity_id, windowType.blank);
                }
            }
        }
    })
    
}
function ViewCompany() {
    OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, windowType.blank);
}

function ViewQuote(){
    window.open('../Quote/QuoteView.aspx?id=' + entityid, '_blank', 'left=200,top=200,width=960,height=750', false);
}



function CopyQuote() {
    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?copy=1&id=" + entityid, windowObj.quote + windowType.add);
}

function LossQuote() {
    OpenWindow("../Quote/QuoteLost.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}
function CloseQuote() {
    OpenWindow("../Quote/QuoteClose.aspx?id=" + entityid, windowObj.quote + windowType.manage);
}

function DeleteQuote() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteAjax.ashx?act=delete&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
        }
    })
}