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
function CloseOpportunity() {
    window.open('../Opportunity/CloseOpportunity.aspx?account_id=' + entityid, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}
function LoseOpportunity() {
    window.open('../Opportunity/LoseOpportunity.aspx?account_id=' + entityid, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}