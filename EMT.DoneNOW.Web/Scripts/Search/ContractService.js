function AddService() {
    window.open('../Contract/AddService.aspx?type=1&contractId=' + $("#id").val(), windowObj.contractService + windowType.add, 'left=0,top=0,location=no,status=no,width=710,height=524', false);
}
function AddServiceBundle() {
    window.open('../Contract/AddService.aspx?type=2&contractId=' + $("#id").val(), windowObj.contractService + windowType.add, 'left=0,top=0,location=no,status=no,width=710,height=524', false);
}
function ApplyDiscount() {
}
function AdjustService() {
    window.open('../Contract/AdjustService.aspx?id=' + entityid, windowObj.contractService + windowType.edit, 'left=0,top=0,location=no,status=no,width=710,height=600', false);
}
function EditDescription() {
    window.open('../Contract/EditServiceInvoiceDesc.aspx?id=' + entityid, windowObj.contractService + windowType.manage, 'left=0,top=0,location=no,status=no,width=710,height=524', false);
}
function editTime() {
    $("#form1").submit();
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/ContractAjax.ashx?act=IsApprove&id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "True") {
                LayerMsg('该服务/服务包不能删除，因为已经计费');
                return;
            } else {
                if (confirm("所有的合同服务周期和交易历史将会被删除，是否继续?")) {
                    $.ajax({
                        type: "GET",
                        url: "../Tools/ContractAjax.ashx?act=DeleteService&id=" + entityid,
                        async: false,
                        success: function (data) {
                            if (data == "True") {
                                LayerMsg('删除成功');
                                window.location.reload();
                            } else {
                                LayerMsg('该服务/服务包不能删除，因为已经计费');
                            }
                        }
                    })
                }
            }
        }
    })
}
