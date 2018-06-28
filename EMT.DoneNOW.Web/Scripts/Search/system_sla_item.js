$(function () {
    $(".General").hide();
})
function Add() {
    var slaId = parent.$("#SLAId").val();
    if (slaId != "") {
        window.open('../SLA/SLAItemManage?slaId=' + slaId, windowObj.slaItem + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
    }
}

function Edit() {
    window.open("../SLA/SLAItemManage.aspx?id=" + entityid, windowObj.slaItem + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
}
function Copy() {
    var slaId = parent.$("#SLAId").val();
    if (slaId != "") {
        window.open("../SLA/SLAItemManage.aspx?copy=1&slaId=" + slaId, windowObj.slaItem + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=700', false);
    }
  
}
function Delete() {
    $.ajax({
        type: "GET",
        url: "../Tools/SLAAjax.ashx?act=DeleteSLAItem&id=" + entityid,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        }
    })
}


function RightClickFunc() {

    $("#ActiveLi").hide();
    $("#InActiveLi").hide();

    ShowContextMenu();
}

