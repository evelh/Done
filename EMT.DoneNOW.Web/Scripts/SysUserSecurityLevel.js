$("#SaveButton").on("mouseover",function(){
    $("#SaveButton").css("background","#fff");
});
$("#SaveButton").on("mouseout",function(){
    $("#SaveButton").css("background","#f0f0f0");
});
$("#CancelButton").on("mouseover",function(){
    $("#CancelButton").css("background","#fff");
});
$("#CancelButton").on("mouseout",function(){
    $("#CancelButton").css("background","#f0f0f0");
});
$.each($(".TabBar a"),function(i){
    $(this).click(function(){
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});

//点击每一个
var colors = ["white","#efefef"];
var index1=0;
var index2=0;
var index3=0;
var index4=0;
var index5=0;
var index6=0;
var index7=0;
var index8=0;
$(".Toggle1").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index1%2]);
    index1++;
});
$(".Toggle2").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index2%2]);
    index2++;
});
$(".Toggle3").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index3%2]);
    index3++;
});
$(".Toggle4").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index4%2]);
    index4++;
});
$(".Toggle5").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index5%2]);
    index5++;
});
$(".Toggle6").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index6%2]);
    index6++;
});
$(".Toggle7").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index7%2]);
    index7++;
});
$(".Toggle8").on("click",function(){
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background",colors[index8%2]);
    index8++;
});
$(".Full").on("click",function(){
    $(this).parent().parent().next().find("input[type='checkbox']").prop("checked", true);
    $(this).parent().parent().next().find("option").removeAttr("selected");

    $(this).parent().parent().next().find("option[value='989']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='973']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='1242']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='976']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='978']").removeAttr("selected", "selected");

    $(this).parent().parent().next().find("option[value='986']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='970']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='1241']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='974']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='977']").attr("selected", "selected");
});
$(".Empty").on("click",function(){
    $(this).parent().parent().next().find("input[type='checkbox']").prop("checked",false);
    $(this).parent().parent().next().find("option").removeAttr("selected");


    $(this).parent().parent().next().find("option[value='986']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='970']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='1241']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='974']").removeAttr("selected", "selected");
    $(this).parent().parent().next().find("option[value='977']").removeAttr("selected", "selected");

    $(this).parent().parent().next().find("option[value='989']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='973']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='1242']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='976']").attr("selected", "selected");
    $(this).parent().parent().next().find("option[value='978']").attr("selected", "selected");


});







