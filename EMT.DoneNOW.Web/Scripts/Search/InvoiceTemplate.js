function Add() {
    OpenWindow("../InvoiceTemplate/InvoiceTemplateAttr.aspx", windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function View(id) {
    OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + id, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Edit() {
    OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + entityid, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Copy() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteTemplateAjax.ashx?act=copyInvoiceTmpl&id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "error") {
                alert("发票模板复制失败！");
            } else {
                alert("发票模板复制成功，点击确定进入编辑界面！");
                OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + data, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }
    })
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteTemplateAjax.ashx?act=deleteInvoiceTmpl&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
function Default() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteTemplateAjax.ashx?act=defaultInvoiceTmpl&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
function Active() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteTemplateAjax.ashx?act=activeInvoiceTmpl&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
function NoActive() {
    $.ajax({
        type: "GET",
        url: "../Tools/QuoteTemplateAjax.ashx?act=noactiveInvoiceTmpl&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
