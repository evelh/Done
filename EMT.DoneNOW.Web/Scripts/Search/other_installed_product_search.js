
function RightClickFunc() {

    var thisInsProId = "";
    if ($("input[name = 'con3966']").val() != undefined) {
        thisInsProId = $("input[name = 'con3966']").eq(0).val();
    }
    var isHasContract = "";  // 该配置项是否有合同
    var isReview = "";       // 该配置项是否需要合同审核

    var isParent = "";    // 右键配置项 是否是本配置项父级
    var isChild = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=GetInsProInfo&insProId=" + thisInsProId,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.parent_id == entityid) {
                    isParent = "1";
                }
              
            }
        },
    });
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
                if (data.parent_id == thisInsProId) {
                    isChild = "1";
                }
            }
        },
    });


    if (isParent == "1" || isChild == "1") {
        $("#AsParent").hide();
        $("#AsChild").hide();
        if (isParent == "1") {
            $("#CancelChild").hide();
            $("#CancelParent").show();
        } else {
            $("#CancelParent").hide();
            $("#CancelChild").show();
        }
    }
    else {
        $("#CancelParent").hide();
        $("#CancelChild").hide();
        $("#AsParent").show();
        $("#AsChild").show();
    }

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

function SetAsParent() {
    var thisInsProId = ""; 
    if ($("input[name = 'con3966']").val() != undefined) {
        thisInsProId = $("input[name = 'con3966']").eq(0).val();
    }
    
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=InsProSetAsParent&insProId=" + thisInsProId + "&insProParentId=" + entityid,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function SetAsChild() {
    var thisInsProId = "";
    if ($("input[name = 'con3966']").val() != undefined) {
        thisInsProId = $("input[name = 'con3966']").eq(0).val();
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=InsProSetAsParent&insProId=" + entityid + "&insProParentId=" + thisInsProId,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function RemoveParent() {
    var thisInsProId = "";
    if ($("input[name = 'con3966']").val() != undefined) {
        thisInsProId = $("input[name = 'con3966']").eq(0).val();
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=InsProCancelAsParent&insProId=" + thisInsProId ,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function RemoveChild() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=InsProCancelAsParent&insProId=" + entityid,
        dataType: 'json',
        success: function (data) {
            history.go(0);
        },
    });
}

function Edit() {
    window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, windowObj.configurationItem + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Copy() {

}


function Swap() {

}

function Move() {

}

function Delete() {
    if (confirm("删除后无法恢复，是否继续?")) {
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
    }
}

function ReViewByContract() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ProductAjax.ashx?act=ReviewInsPro&insProId=" + entityid +"&isView=1",
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
