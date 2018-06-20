$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function Edit() {
    OpenWindow("../QuoteItem/QuoteItemAddAndUpdate.aspx?id=" + entityid, windowObj.quoteItem + windowType.edit);
}


function EditQuote() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/QuoteAjax.ashx?act=GetQuoteItem&quoteItemId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.quote_id != "" && data.quote_id != undefined) {
                    OpenWindow("../Quote/QuoteAddAndUpdate.aspx?id=" + data.quote_id, windowObj.quote + windowType.edit);
                }     
            }
           
        },
    });
}


function QuoteManage() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/QuoteAjax.ashx?act=GetQuoteItem&quoteItemId=" + entityid,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data.quote_id != "" && data.quote_id != undefined) {
                    OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + data.quote_id, windowObj.quote + windowType.view);
                }
            }

        },
    });
}
