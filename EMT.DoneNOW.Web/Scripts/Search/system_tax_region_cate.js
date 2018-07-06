$(function () {
    $(".General").hide();
})

function AddTaxRegion() {
    window.open('../General/GeneralManage?tableId=5', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function AddTaxCate() {
    window.open('../SysSetting/TaxCateManage', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function Add() {
    window.open('../SysSetting/TaxRateManage', 'AddRegionTaxTax', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Edit() {
    window.open('../SysSetting/TaxRateManage?id=' + entityid, 'AddRegionTaxTax', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Delete() {
    LayerConfirm("删除不能撤消。 是否删除？", "是", "否", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=DeleteRegion&id=" + entityid,
            dataType: "json",
            async: false,
            success: function (data) {
                if (data) {
                    LayerMsg("删除成功");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        });
    });
}