$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})

function Add() {
    window.open("../Contact/NewContactTemplate.aspx?noPar=1", windowObj.contactActionTemp + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function View() {
    window.open("../Contact/ExecuteContact.aspx?tempId=" + entityid +"&isTemp=1", windowObj.contactActionTemp + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Edit() {
    window.open("../Contact/NewContactTemplate.aspx?noPar=1&id="+entityid, windowObj.contactActionTemp + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function Delete() {
    
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ContactAjax.ashx?act=DeleteContactActionTemp&tempId=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            } else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}







