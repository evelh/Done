function Edit() {
    window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?id=' + entityid + '&type=1', windowObj.quoteEmailTmpl + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Add() {
    window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?type=1', windowObj.quoteEmailTmpl + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function View(id) {
    window.open('../SysSetting/QuoteAndInvoiceEmailTempl.aspx?id=' + id + '&type=1', windowObj.quoteEmailTmpl, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Default() {
    requestData("/Tools/SysSettingAjax.ashx?act=SetQuoteEmailTmplDefault&type=1&id=" + entityid, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function Delete() {
    requestData("/Tools/SysSettingAjax.ashx?act=DeleteQuoteEmailTmpl&id=" + entityid, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}