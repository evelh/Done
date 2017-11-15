function EditContact() {
    OpenWindow("../Contact/AddContact.aspx?id=" + entityid, windowObj.contact + windowType.edit);
}
function ViewContact() {
    OpenWindow("../Contact/ViewContact.aspx?id=" + entityid, '_blank');
}
function View(id) {
    OpenWindow("../Contact/ViewContact.aspx?id=" + id, '_blank');
}
function DeleteContact() {
    $.ajax({
        type: "GET",
        url: "../Tools/ContactAjax.ashx?act=delete&id=" + entityid,
        success: function (data) {
            alert(data);
        }

    })
}
function AddNote() {
    OpenWindow("../Activity/Notes.aspx?contactId=" + entityid, windowObj.notes + windowType.add);
}
function Add() {
    OpenWindow('../Contact/AddContact.aspx?account_id=' + $("#id").val(), windowObj.contact + windowType.add);
}