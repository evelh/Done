$("#AddButton").on("mouseover",function(){
    $("#AddButton").css("background","#fff");
});
$("#AddButton").on("mouseout",function(){
    $("#AddButton").css("background","#f0f0f0");
});

//编辑
var RightClickMenu = document.getElementById("RightClickMenu");
$(".ContextMenu").on("click",function(event){
    var oEvent = event;
    var Top = $(this).scrollTop()+oEvent.clientY;
    console.log(Top);
    RightClickMenu.style.top=Top+"px";
    $(".RightClickMenu").show();
});
$(".ContextMenu").on("mouseout",function(){
    $(".RightClickMenu").hide();
});
$(".RightClickMenu").on("mouseover",function(){
    $(this).show();
});
$(".RightClickMenu").on("mouseout",function(){
    $(this).hide();
});
$(".RightClickMenuItem").on("mouseover",function(){
    $(this).css("background","#E9F0F8");
});
$(".RightClickMenuItem").on("mouseout",function(){
    $(this).css("background","#FFF");
});
//上下移动
$(".next").on('click',function() {
    if($(this).parent().parent().parent().next()){
        $(this).parent().parent().parent().next().after($(this).parent().parent().parent());
        sort();
    }
});
$(".prev").on('click',function() {
    if($(this).parent().parent().parent().prev()){
        $(this).parent().parent().parent().prev().before($(this).parent().parent().parent());
        sort();
    }
});
function sort(){
    for(var i=0;i<$(".Sort").length;i++){
        var index=i+1;
        $(".Sort").eq(i).html(index);
    }
}
sort();
