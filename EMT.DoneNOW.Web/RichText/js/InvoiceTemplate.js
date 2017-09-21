var colors = ["white","#efefef"];
var index1=0;
var index2=0;
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