$("#goBack").click(function () {
    window.parent.ShowDashboard();
})
window.parent.ShowSearchCon()
window.parent.HideLoading();


function ViewOpp() {
    OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, '_blank');
}
function View(id) {
    OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + id, '_blank');
}
function ViewCompany() {
    OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, '_blank');
}

function EditOpp() {
    OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid, windowObj.opportunity + windowType.edit);
}

function DeleteOpp() {
    $.ajax({
        type: "GET",
        url: "../Tools/OpportunityAjax.ashx?act=delete&id=" + entityid,
        success: function (data) {
            alert(data);
        }
    })
}

function CloseOppo() {
    window.open('../Opportunity/CloseOpportunity.aspx?id=' + entityid, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}

function LostOppo() {
    window.open('../Opportunity/LoseOpportunity.aspx?id=' + entityid, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}