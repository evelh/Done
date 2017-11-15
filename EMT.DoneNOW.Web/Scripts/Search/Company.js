function EditCompany() {
    OpenWindow("../Company/EditCompany.aspx?id=" + entityid, windowObj.company + windowType.edit);
}
function ViewCompany() {
    OpenWindow("../Company/ViewCompany.aspx?id=" + entityid, windowType.blank);
}
function Add() {
    OpenWindow("../Company/AddCompany.aspx", windowObj.company + windowType.add);
}
function DeleteCompany() {
    OpenWindow("../Company/DeleteCompany.aspx?id=" + entityid, windowObj.company + windowType.edit);
}
function View(id) {
    OpenWindow("../Company/ViewCompany.aspx?id=" + id, windowType.blank);
}
function AddNote() {
    OpenWindow("../Activity/Notes.aspx?accountId=" + entityid, windowObj.notes + windowType.add);
}