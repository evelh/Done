$("#SaveAndCloneButton").on("mouseover", function () {
    $("#SaveAndCloneButton").css("background", "#fff");
});
$("#SaveAndCloneButton").on("mouseout", function () {
    $("#SaveAndCloneButton").css("background", "#f0f0f0");
});
$("#SaveAndNewButton").on("mouseover", function () {
    $("#SaveAndNewButton").css("background", "#fff");
});
$("#SaveAndNewButton").on("mouseout", function () {
    $("#SaveAndNewButton").css("background", "#f0f0f0");
});
$("#CancelButton").on("mouseover", function () {
    $("#CancelButton").css("background", "#fff");
});
$("#CancelButton").on("mouseout", function () {
    $("#CancelButton").css("background", "#f0f0f0");
});
$("#NewButton").on("mouseover", function () {
    $("#NewButton").css("background", "#fff");
});
$("#NewButton").on("mouseout", function () {
    $("#NewButton").css("background", "#f0f0f0");
});
$("#SaveButton").on("mouseover", function () {
    $("#SaveButton").css("background", "#fff");
});
$("#SaveButton").on("mouseout", function () {
    $("#SaveButton").css("background", "#f0f0f0");
});
$("#CancelButton1").on("mouseover", function () {
    $("#CancelButton1").css("background", "#fff");
});
$("#CancelButton1").on("mouseout", function () {
    $("#CancelButton1").css("background", "#f0f0f0");
});
$("#NewButton1").on("mouseover", function () {
    $("#NewButton1").css("background", "#fff");
});
$("#NewButton1").on("mouseout", function () {
    $("#NewButton1").css("background", "#f0f0f0");
});
$.each($(".TabBar a"), function (i) {
    $(this).click(function () {
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});
