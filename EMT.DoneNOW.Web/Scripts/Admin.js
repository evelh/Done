$.each($(".TabBar a"),function(i){
    $(this).click(function(){
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});

$(".Toggle").on("click", function () {
    $(this).find(".Vertical").toggle();
    $(this).parent().siblings().toggle();
    $(this).parent().parent().css("background", ($(this).parent().siblings().is(":hidden") ? "#efefef" : "white"));
})

$(".ShowAll").on("click", function () {
    $(this).parent().parent().find(".Toggle").each(function () {
        $(this).find(".Vertical").hide();
        $(this).parent().siblings().show();
        $(this).parent().parent().css("background", "white");
    })
})

$(".HideAll").on("click", function () {
    $(this).parent().parent().find(".Toggle").each(function () {
        $(this).find(".Vertical").show();
        $(this).parent().siblings().hide();
        $(this).parent().parent().css("background", "#efefef");
    })
})
