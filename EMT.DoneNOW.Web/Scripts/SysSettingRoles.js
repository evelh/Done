$("#SaveAndCloneButton").on("mouseover",function(){
    $("#SaveAndCloneButton").css("background","#fff");
});
$("#SaveAndCloneButton").on("mouseout",function(){
    $("#SaveAndCloneButton").css("background","#f0f0f0");
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
