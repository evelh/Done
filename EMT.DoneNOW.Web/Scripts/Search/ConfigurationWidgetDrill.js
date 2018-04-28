$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();
function Edit() {
    window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, windowObj.configurationItem + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function Active() {
    $.ajax({
        type: "GET",
        url: "../Tools/ProductAjax.ashx?act=ActivationIP&iProduct_id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "ok") {
                alert('激活成功');
                history.go(0);
            } else if (data == "no") {
                LayerMsg('该配置项已经激活');
            }
        }
    })
}
function Inactive() {
    $.ajax({
        type: "GET",
        url: "../Tools/ProductAjax.ashx?act=NoActivationIP&iProduct_id=" + entityid,
        async: false,
        success: function (data) {
            if (data == "ok") {
                alert('停用成功');
                history.go(0);
            } else if (data == "no") {
                alert('该配置项已经停用');
            }
        }
    })
}
function DeleteIProduct() {
    LayerConfirmOk("删除后无法恢复，是否继续?", "确定", "取消", function () {
        $.ajax({
            type: "GET",
            url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
            success: function (data) {

                if (data == "True") {
                    alert('删除成功');
                } else if (data == "False") {
                    alert('删除失败');
                }
                history.go(0);
            }
        })
    });
}
function AddTicket() {

}