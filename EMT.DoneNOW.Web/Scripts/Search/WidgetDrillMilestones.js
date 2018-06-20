$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function Edit() {
    window.open("../Contract/ContractMilestone.aspx?id=" + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Delete() {
    if (confirm("确定要删除此里程碑吗?")) {
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=DeleteMilestone&milestoneId=" + entityid,
            async: false,
            success: function (data) {
                if (data == "True") {
                    alert('删除成功');
                    history.go(0);
                } else {
                    alert("删除失败，已计费状态下不能删除");
                }
            }
        })
    }
}