$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Reject()">拒绝</li>');
$('.contenttitle ul li').eq(0).before('<li style="text-align:center;padding:0 8px;" onclick="Approve()">批准</li>');
$("#CheckAll").click(function () {
    if ($(this).is(":checked")) {
        $(".IsChecked").prop("checked", true);
        $(".IsChecked").css("checked", "checked");
    }
    else {
        $(".IsChecked").prop("checked", false);
        $(".IsChecked").css("checked", "");
    }
})
function Approve() {

}
function Reject() {

}