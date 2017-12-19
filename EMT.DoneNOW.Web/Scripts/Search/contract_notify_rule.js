$(function () {
    $(".General").hide();
})

function View(id) {

}
function Add() {
    var contract_id = $("#id").val();
    if (contract_id != undefined && contract_id != null && contract_id != "") {
        OpenWindow("../Contract/NotiRuleManage.aspx?contract_id=" + contract_id, windowObj.contractNotRule + windowType.add);
    }

}

function Edit() {
    OpenWindow("../Contract/NotiRuleManage.aspx?id=" + entityid, windowObj.contractNotRule + windowType.edit);
}
function Delete() {

    LayerConfirm("删除不可恢复，是否继续", "是", "否", function () {
            $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=DeleteContractRule&rule_id=" + entityid,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data == "True") {
                    LayerMsg("删除成功！");
                } else {
                    LayerMsg("删除失败！");
                }
                history.go(0);
            }
        })

    }, function () { });
  
}