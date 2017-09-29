$.each($(".TabBar a"),function(i){
    $(this).click(function(){
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});

var colors = ["white","#efefef"];
var index1 = 0;
var index2 = 0;
var index3 = 0;
var index4 = 0;
var index5 = 0;
var index6 = 0;
var index7 = 0;
var index8 = 0;
$("#a1").on("click",function(){
    $(this).find(".Vertical1").toggle();
    $("#c1").toggle();
    var color = colors[index1++];
    $("#b1").css("background",color);
    if(index1==colors.length){
        index1 = 0;
    }
});
$("#a2").on("click",function(){
    $(this).find(".Vertical1").toggle();
    $("#c2").toggle();
    var color = colors[index2++];
    $("#b2").css("background",color);
    if(index2==colors.length){
        index2 = 0;
    }
});
$("#a3").on("click",function(){
    $(this).find(".Vertical1").toggle();
    $("#c3").toggle();
    var color = colors[index3++];
    $("#b3").css("background",color);
    if(index3==colors.length){
        index3 = 0;
    }
});
$("#a4").on("click", function () {
    $(this).find(".Vertical1").toggle();
    $("#c4").toggle();
    var color = colors[index4++];
    $("#b4").css("background", color);
    if (index4 == colors.length) {
        index4 = 0;
    }
});
$("#a5").on("click", function () {
    $(this).find(".Vertical1").toggle();
    $("#c5").toggle();
    var color = colors[index5++];
    $("#b5").css("background", color);
    if (index5 == colors.length) {
        index5 = 0;
    }
});
$("#a6").on("click", function () {
    $(this).find(".Vertical1").toggle();
    $("#c6").toggle();
    var color = colors[index6++];
    $("#b6").css("background", color);
    if (index6 == colors.length) {
        index6 = 0;
    }
});
$("#a7").on("click", function () {
    $(this).find(".Vertical1").toggle();
    $("#c7").toggle();
    var color = colors[index7++];
    $("#b7").css("background", color);
    if (index7 == colors.length) {
        index7 = 0;
    }
});
$("#a8").on("click", function () {
    $(this).find(".Vertical1").toggle();
    $("#c8").toggle();
    var color = colors[index8++];
    $("#b8").css("background", color);
    if (index8 == colors.length) {
        index8 = 0;
    }
});



var bol1 = 0;
var bol2 = 0;
var bol3 = 0;
var bol4 = 0;
var bol5 = 0;
var bol6 = 0;
$("#e1").on("click",function(){
    $(this).find(".Vertical2").toggle();
    $("#g1").toggle();
    var color = colors[bol1++];
    $("#f1").css("background",color);
    if(bol1==colors.length){
        bol1 = 0;
    }
});
$("#e2").on("click",function(){
    $(this).find(".Vertical2").toggle();
    $("#g2").toggle();
    var color = colors[bol2++];
    $("#f2").css("background",color);
    if(bol2==colors.length){
        bol2 = 0;
    }
});
$("#e3").on("click",function(){
    $(this).find(".Vertical2").toggle();
    $("#g3").toggle();
    var color = colors[bol3++];
    $("#f3").css("background",color);
    if(bol3==colors.length){
        bol3 = 0;
    }
});


$("#d1").on("click",function(){
    $(".Toggle1").find(".Vertical1").hide();
    $(".Content1").show();
    var color = colors[0];
    $(".Normal1").css("background",color);
    index1=1;
    index2=1;
    index3 = 1;
    index4 = 1;
    index5 = 1;
    index6 = 1;
    index7 = 1;
    index8 = 1;

});
$("#d2").on("click",function(){
    $(".Toggle1").find(".Vertical1").show();
    $(".Content1").hide();
    var color = colors[1];
    $(".Normal1").css("background",color);
    index1=0;
    index2=0;
    index3 = 0;
    index4 = 0;
    index5 = 0;
    index6 = 0;
    index7 = 0;
    index8 = 0;
});
$("#d3").on("click",function(){
    $(".Toggle2").find(".Vertical2").hide();
    $(".Content2").show();
    var color = colors[0];
    $(".Normal2").css("background",color);
    bol1=1;
    bol2=1;
    bol3 = 1;
});
$("#d4").on("click",function(){
    $(".Toggle2").find(".Vertical2").show();
    $(".Content2").hide();
    var color = colors[1];
    $(".Normal2").css("background",color);
    bol1=0;
    bol2=0;
    bol3 = 0;
});