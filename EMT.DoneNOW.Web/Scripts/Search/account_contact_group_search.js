$(function () {
    $(".General").hide();
})


function Add() {
    var accountId = parent.$("#AccountId").val();
    if (accountId != "" && accountId != undefined) {
        window.open("../Contact/AddAccountContactGroup.aspx?accountId=" + accountId, windowObj.contactGroup + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
}

function AddRemove() {
    var accountId = parent.$("#AccountId").val();
    if (accountId != "" && accountId != undefined) {
        window.open("../Contact/AddAccountContactGroup.aspx?isDisGroup=dis&accountId=" + accountId + "&groupId=" + entityid, windowObj.contactGroup + windowType.manage, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
}

function CreateNote() {
    var accountId = parent.$("#AccountId").val();
    window.open("../Contact/ExecuteContact.aspx?groupId=" + entityid + "&isGroup=1&chooseType=note&accountId=" + accountId,"ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function CreateTodo() {
    var accountId = parent.$("#AccountId").val();
    window.open("../Contact/ExecuteContact.aspx?groupId=" + entityid + "&isGroup=1&chooseType=todo&accountId=" + accountId, "ExecuteContact", 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function ViewGroup() {
    window.open("../Contact/ViewContactGroup.aspx?groupId=" + entityid, 'groupSelect', 'left=200,top=200,width=600,height=800', false);
}

function EditGroup() {
    window.open("../Contact/ContactGroupManage.aspx?id=" + entityid, windowObj.contactGroup + windowType.edit, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}
