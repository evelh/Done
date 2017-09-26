$(".titleAdd").click(function(){
/*	var htmlLi="<li>"+"<p>"+"111"+"</p>"+"<span>"+"</span>"+"</li>"
	$(this).before(htmlLi)
var downUpLeft = $(".titleTop-down .up-left").offset().left;//up-left距左距离
var downUpWidth = $(".titleTop-down .up-left").width();//up-left宽度
var downUpright = $(".titleTop-down .up-right").offset().left;//up-right距左距离
var distances = downUpright -(downUpLeft+downUpWidth);//up-left，up-right直接距离
var Width=downUpright-downUpLeft-50;
if(distances<=50){
	var Pp=$(".titleTop-down .up-left li").children("p");//获取p标签
	var Pwidth=Pp.width();//获取p标签宽度
	var LILenght=$(".titleTop-down .up-left li").length;//获取li长度
	var PNewWidth=Width/LILenght;
	$(".titleTop-down .up-left").css("width",Width+"px");
	Pp.css("width",+PNewWidth+"px");
		if($(".titleTop-down .up-left").width()==Width){
		$(".titleAdd").css({"position":"absolute","right":"-90"})
	}
}
*/
//alert("开发中，敬请期待")
})
$(".informationTitle i").click(function(){
	//$(".information").toggleClass("ba");
    $(this).toggleClass("jia");
    $(this).parent().next("div").toggleClass("hide");
    $("#SearchFrameSet").remove();
    
})


var  informationWidth=$(".information").width();
var leftLenght=$(".information ").children(".left").length;
var leftWidth=100/leftLenght;
$(".information ").children(".left").width(leftWidth + "%");

//logo的下拉菜单内容
var timer;
var timer1;
$(".Logo").on("mousemove", function () {
    clearTimeout(timer);
    $(this).css("border-color", "#d7d7d7");
    $(".GuideOverlay").show();
});
$(".Logo").on("mouseout", function () {
    var _this = this;
    timer = setTimeout(function () {
        $(_this).css("border-color", "#fff");
        $(".GuideOverlay").hide();
    }, 500)
});
$(".GuideOverlay").on("mousemove", function () {
    clearTimeout(timer);
    $(".Logo").css("border-color", "#d7d7d7");
    $(this).show();
});
$(".GuideOverlay").on("mouseout", function () {
    var _this = this;
    timer = setTimeout(function () {
        $(".Logo").css("border-color", "#fff");
        $(_this).hide();
    }, 500)
});
//循环一级菜单   显示二级菜单
$.each($(".GuideNavigation"), function (i) {
    $(this).mousemove(function () {
        $(this).addClass("SelectedState").siblings("div").removeClass("SelectedState").addClass("NormalState");
        $(".Module").eq(i).show().siblings(".Module").hide();
    });
});
$(".Content").on("mouseover", function () {
    $(this).children("a").removeClass("NormalState").addClass("HoverState");
});
$(".Content").on("mouseout", function () {
    $(this).children("a").removeClass("HoverState").addClass("NormalState");
});

//历史记录搜索
$(".Search").on("click", function () {
    $(".SearchOverlay").show();
});
$(".SearchOverlay").on("mouseover", function () {
    $(this).show();
});
$(".SearchOverlay").on("mouseout", function () {
    $(this).hide();
});

//新增的下拉菜单
$(".New").on("mousemove", function () {
    $(this).addClass("HoverState");
    $(this).css("borderBottom", "1px solid #fff");
    $(".NewOverlay").show();
});
$(".New").on("mouseout", function () {
    $(this).removeClass("HoverState");
    $(this).css("borderTop", "1px solid #d7d7d7");
    $(this).css("borderBottom", "1px solid #d7d7d7");
    $(".NewOverlay").hide();
});
$(".NewOverlay").on("mousemove", function () {
    $(".New").addClass("HoverState");
    $(".New").css("borderBottom", "1px solid #fff");
    $(this).show();
});
$(".NewOverlay").on("mouseout", function () {
    $(".New").removeClass("HoverState");
    $(".New").css("borderTop", "1px solid #d7d7d7");
    $(".New").css("borderBottom", "1px solid #d7d7d7");
    $(this).hide();
});


//历史的下拉菜单
$(".Recent").on("mousemove", function () {
    $(this).addClass("HoverState");
    $(this).css("borderBottom", "1px solid #fff");
    $(".RecentOverlay").show();
});
$(".Recent").on("mouseout", function () {
    $(this).removeClass("HoverState");
    $(this).css("borderTop", "1px solid #d7d7d7");
    $(this).css("borderBottom", "1px solid #d7d7d7");
    $(".RecentOverlay").hide();
});
$(".RecentOverlay").on("mousemove", function () {
    $(".Recent").addClass("HoverState");
    $(".Recent").css("borderBottom", "1px solid #fff");
    $(this).show();
});
    $(".RecentOverlay").on("mouseout", function () {
        $(".Recent").removeClass("HoverState");
        $(".Recent").css("borderTop", "1px solid #d7d7d7");
        $(".Recent").css("borderBottom", "1px solid #d7d7d7");
        $(this).hide();
    });