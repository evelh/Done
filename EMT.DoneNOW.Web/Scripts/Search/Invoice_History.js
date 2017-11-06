function Add() {
    alert("暂未实现");
}
//修改发票
function EditInvoice() {
    window.open('../Invoice/InvoiceNumberAndDateEdit.aspx?id=' + entityid, windowObj.invoice + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
//作废发票
function VoidInvoice() {
    $.ajax({
        type: "GET",
        url: "../Tools/HistoryInvoiceAjax.ashx?act=voidone&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
//作废本批发票
function VoidBatchInvoice() {
    $.ajax({
        type: "GET",
        url: "../Tools/HistoryInvoiceAjax.ashx?act=voidbatch&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
//作废发票并取消审批
function VoidInvoiceAndUnPost() {
    $.ajax({
        type: "GET",
        url: "../Tools/HistoryInvoiceAjax.ashx?act=voidunpost&id=" + entityid,
        async: false,
        success: function (data) {
            alert(data);
            history.go(0);
        }
    })
}
//查看发票
function InvoiceView() {
    window.open("../Invoice/InvoicePreview.aspx?isInvoice=1&invoice_id=" + entityid, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
//查看本批全部发票
function InvoiceAllView() {
    $.ajax({
        type: "GET",
        url: "../Tools/HistoryInvoiceAjax.ashx?act=getbatch_id&id=" + entityid,
        async: false,
        success: function (data) {
            if (data > 0) {
                window.open("../Invoice/InvoicePreview.aspx?isInvoice=1&inv_batch=" + data, windowType.blank, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("跳转失败！");
            }
        }
    })
}
//发票设置
function InvoiceEdit() {
    $.ajax({
        type: "GET",
        url: "../Tools/HistoryInvoiceAjax.ashx?act=getaccount_id&id=" + entityid,
        async: false,
        success: function (data) {
            window.open("../Invoice/PreferencesInvoice.aspx?account_id=" + data, windowObj.invoice + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
    })
}