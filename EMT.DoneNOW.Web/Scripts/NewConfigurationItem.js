
$("#SaveButton").on("mouseover", function () {
    $("#SaveButton").css("background", "#fff");
});
$("#SaveButton").on("mouseout", function () {
    $("#SaveButton").css("background", "#f0f0f0");
});
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
$("#EditButton").on("mouseover", function () {
    $("#EditButton").css("background", "#fff");
});
$("#EditButton").on("mouseout", function () {
    $("#EditButton").css("background", "#f0f0f0");
});
$("#PrintButton").on("mouseover", function () {
    $("#PrintButton").css("background", "#fff");
});
$("#PrintButton").on("mouseout", function () {
    $("#PrintButton").css("background", "#f0f0f0");
});
//工具
$("#ToolsButton").on("mouseover", function () {
    $("#ToolsButton").css("background", "#fff");
    $(this).css("border-bottom", "none");
    $(".RightClickMenu").show();
});
$("#ToolsButton").on("mouseout", function () {
    $("#ToolsButton").css("background", "#f0f0f0");
    $(this).css("border-bottom", "1px solid #BCBCBC");
    $(".RightClickMenu").hide();
});
$(".RightClickMenu").on("mouseover", function () {
    $("#ToolsButton").css("background", "#fff");
    $("#ToolsButton").css("border-bottom", "none");
    $(this).show();
});
$(".RightClickMenu").on("mouseout", function () {
    $("#ToolsButton").css("background", "#f0f0f0");
    $("#ToolsButton").css("border-bottom", "1px solid #BCBCBC");
    $(this).hide();
});
$(".RightClickMenuItem").on("mouseover", function () {
    $(this).css("background", "#E9F0F8");
});
$(".RightClickMenuItem").on("mouseout", function () {
    $(this).css("background", "#FFF");
});
//工具结束
$("#SiteConfiguration").on("mouseover", function () {
    $("#SiteConfiguration").css("background", "#fff");
});
$("#SiteConfiguration").on("mouseout", function () {
    $("#SiteConfiguration").css("background", "#f0f0f0");
});
$("#OtherConfigurationItems").on("mouseover", function () {
    $("#OtherConfigurationItems").css("background", "#fff");
});
$("#OtherConfigurationItems").on("mouseout", function () {
    $("#OtherConfigurationItems").css("background", "#f0f0f0");
});
//销售订单导航
$(".nav").on("mouseover", function () {
    $(this).css("background", "#fff");
    $(this).css("border-bottom", "none");
    $(".LeftClickMenu").show();
});
$(".nav").on("mouseout", function () {
    $(this).css("background", "#f0f0f0");
    $(".LeftClickMenu").hide();
});
$(".LeftClickMenu").on("mouseover", function () {
    $(".nav").css("background", "#fff");
    $(".nav").css("border-bottom", "none");
    $(this).show();
});
$(".LeftClickMenu").on("mouseout", function () {
    $(".nav").css("background", "#f0f0f0");
    $(this).hide();
});
$.each($(".TabBar a"), function (i) {
    $(this).click(function () {
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});
var colors = ["#efefef", "white"];
var index1 = 0;
var index2 = 0;
var index3 = 0;
var index4 = 0;
var index5 = 1;
$(".Toggle1").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[index1 % 2]);
    index1++;
});
$(".Toggle2").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[index2 % 2]);
    index2++;
});
$(".Toggle3").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[index3 % 2]);
    index3++;
});
$(".Toggle4").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[index4 % 2]);
    index4++;
});
$(".Toggle5").on("click", function () {
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[index5 % 2]);
    index5++;
});