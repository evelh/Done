$(function () {
    $(".General").hide();
})

function View(id) {
    window.open("../Project/ProjectView.aspx?id=" + id, '_blank', 'left=200,top=200,width=900,height=800', false);
}