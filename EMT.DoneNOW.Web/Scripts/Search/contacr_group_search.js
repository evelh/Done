$(function () {
    $(".General").hide();
    $("#SelectLi").show();
})

function RightClickFunc() {

    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ContactAjax.ashx?act=GetContactGroup&id=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data != "") {
                if (data.is_active == "1") {
                    $("#Active").hide();
                }
                else {
                    $("#InActive").hide();
                }
            }
            else {
                $("#Active").hide();
                $("#InActive").hide();
            }
        },
    });
    ShowContextMenu();
}
function Add() {
    window.open("../Contact/ContactGroupManage.aspx", windowObj.contactGroup + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function CreateNote() {
    
    window.open("../Contact/ExecuteContact.aspx?groupId=" + entityid + "&isGroup=1&chooseType=note", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function CreateTodo() {
    var accountId = parent.$("#AccountId").val();
    window.open("../Contact/ExecuteContact.aspx?groupId=" + entityid + "&isGroup=1&chooseType=todo", "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function ViewGroup() {
    window.open("../Contact/ViewContactGroup.aspx?groupId=" + entityid, 'groupSelect', 'left=200,top=200,width=600,height=800', false);
}
function View(id) {
    window.open("../Contact/ViewContactGroup.aspx?groupId=" + id, 'groupSelect', 'left=200,top=200,width=600,height=800', false);
}

function EditGroup() {
    window.open("../Contact/ContactGroupManage.aspx?id=" + entityid, windowObj.contactGroup + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function CopyGroup() {
    window.open("../Contact/ContactGroupManage.aspx?isCopy=1&id=" + entityid + "&isGroup=1&chooseType=note", windowObj.contactGroup + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
function ActiveGroup() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ContactAjax.ashx?act=ActiveContactGroup&groupId=" + entityid,
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("激活成功！");
            } else {
                LayerMsg("激活失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function InActiveGroup() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ContactAjax.ashx?act=ActiveContactGroup&groupId=" + entityid +"&inActive=1",
        dataType: 'json',
        success: function (data) {
            if (data) {
                LayerMsg("失活成功！");
            } else {
                LayerMsg("失活失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function DeleteGroup() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ContactAjax.ashx?act=DeleteContactGroup&groupId=" + entityid ,
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