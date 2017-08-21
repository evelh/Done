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
    $(this).parent().parent().next().find("input[type='checkbox']").prop("checked",true);
    $(this).parent().parent().next().find("option[value='0']").removeAttr("selected");
    $(this).parent().parent().next().find("option[value='1']").removeAttr("selected");
    $(this).parent().parent().next().find("option[value='1']").attr("selected", "true");
});
$(".Empty").on("click",function(){
    $(this).parent().parent().next().find("input[type='checkbox']").prop("checked",false);
    $(this).parent().parent().next().find("option").removeAttr("selected");
    $(this).parent().parent().next().find("option[value='0']").attr("selected", "true");
});







