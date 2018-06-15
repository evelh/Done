$(function () {
    $(".General").hide();
})

function AddTaxRegion() {
    window.open('../General/GeneralManage?tableId=5', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}

function AddTaxCate() {
    window.open('../SysSetting/TaxCateManage', windowObj.general + windowType.add, 'left=0,top=0,location=no,status=no,width=700,height=500', false);
}