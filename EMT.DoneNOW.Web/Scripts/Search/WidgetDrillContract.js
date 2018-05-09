$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();
function Edit() {
    window.open("../Contract/ContractEdit.aspx?id=" + entityid, windowObj.contract + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=980', false);
}
function ViewContract() {
    window.open("../Contract/ContractView.aspx?id=" + entityid, windowType.blank, 'left=0,top=0,location=no,status=no,width=1350,height=950', false);
}
function View(id) {
    window.open("../Contract/ContractView.aspx?id=" + id, windowType.blank, 'left=0,top=0,location=no,status=no,width=1350,height=950', false);
}
function ViewNewWindow() {
    window.open("../Contract/ContractView.aspx?id=" + entityid, windowType.blank);
}
function RenewContract() {
    window.open("../Contract/ContractRenew.aspx?id=" + entityid, windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function CopyContract() {
    window.open("../Contract/ContractCopy.aspx?id=" + entityid, windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function DeleteContract() {
    if (confirm('删除合同，是否继续?')) {
        $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=deleteContract&id=" + entityid,
            success: function (data) {
                if (data == "True") {
                    alert("删除成功");
                    window.location.reload();
                } else {
                    alert("删除失败，合同关联以下对象时不能被删除：项目、工单、合同默认成本、配置项、合同成本、已计费条目、工时、taskfire。")
                }
            }
        });
    }
}
$(".dn_tr").bind("contextmenu", function (event) {
    clearInterval(Times);
    var oEvent = event;
    entityid = $(this).data("val");
    (function () {
        menu.style.display = "block";
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    };
    var Top = $(document).scrollTop() + oEvent.clientY;
    var Left = $(document).scrollLeft() + oEvent.clientX;
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;
    var menuWidth = menu.clientWidth;
    var menuHeight = menu.clientHeight;
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();
    var clientWidth = Left + menuWidth;
    var clientHeight = Top + menuHeight;
    if (winWidth < clientWidth) {
        menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
    } else {
        menu.style.left = Left + "px";
    }
    if (winHeight < clientHeight) {
        menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
    } else {
        menu.style.top = Top + "px";
    }

    $("#RenewContract").removeAttr('onclick');
    $("#RenewContract").unbind('click');
    requestData("../Tools/ContractAjax.ashx?act=CanRenewContract&id=" + entityid, null, function (data) {
        if (data == 0) {
            $("#RenewContract").css("color", "");
            $("#RenewContract").click(function () {
                RenewContract();
            })
        } else if (data == 1) {
            $("#RenewContract").css("color", "");
            $("#RenewContract").click(function () {
                LayerMsg("此合同已续约过，不可再续约");
            })
        } else {
            $("#RenewContract").css("color", "grey");
        }
    });

    return false;
});