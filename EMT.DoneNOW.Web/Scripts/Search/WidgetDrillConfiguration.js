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
    window.open('../ServiceDesk/TicketManage.aspx?insProId=' + entityid, windowObj.ticket + windowType.add, 'left=200,top=200,width=900,height=750', false);
}
// 右键菜单处理
function RightClickFunc() {
    var isHasContract = "";  // 该配置项是否有合同
    var isReview = "";       // 该配置项是否需要合同审核
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=GetInsProInfo&insProId=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.contract_id != "" && data.contract_id != undefined && data.contract_id != null) {
                    isHasContract = "1";
                }
                if (data.reviewed_for_contract == "1") {
                    isReview = "1";
                }
                if (data.is_active == "1") {
                    $("#ActiveThis").css("color", "grey");
                    $("#NoActiveThis").css("color", "");
                    $("#ActiveThis").removeAttr('onclick');

                    $("#NoActiveThis").click(function () {
                        Inactive();
                    })
                }
                else if (data.is_active == "0") {
                    $("#ActiveThis").css("color", "");
                    $("#NoActiveThis").css("color", "grey");

                    $("#NoActiveThis").removeAttr('onclick');

                    $("#ActiveThis").click(function () {
                        Active();
                    })
                }
            }
        },
    });

    if (isHasContract != "") {
        $("#ReViewByContractMenu").hide();
        $("#NoReViewByContractMenu").hide();
    }
    else {
        if (isReview == "1") {
            $("#NoReViewByContractMenu").show();
            $("#ReViewByContractMenu").hide();
        }
        else {
            $("#NoReViewByContractMenu").hide();
            $("#ReViewByContractMenu").show();
        }
    }

    ShowContextMenu();
}


function Copy() {
    window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid + "&isCopy=1", windowObj.configurationItem + windowType.add, 'left=200,top=200,width=1080,height=800', false);
}

function ReViewByContract() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + entityid + "&isView=1",
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function NoReViewByContract() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + entityid,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}
