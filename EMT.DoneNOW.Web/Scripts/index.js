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
    }, 200)
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
    }, 200)
});
//循环一级菜单   显示二级菜单
//优化
var Navtimer; var x = 0;
$.each($(".GuideNavigation"), function (i) {
    $(this).mouseover(function () {
        var _this = this;
        Navtimer = setInterval(function () {
            x++;
            if (x >= 2) {
                $(_this).addClass("SelectedState").siblings("div").removeClass("SelectedState").addClass("NormalState");
                $(".Module").eq(i).show().siblings(".Module").hide();
            }
        }, 100)
        
    });
    $(this).mouseout(function () {
        clearInterval(Navtimer)
        x = 0;

    });
});
$(".Content").on("mouseover", function () {
    $(this).children("a").removeClass("NormalState").addClass("HoverState");
});
$(".Content").on("mouseout", function () {
    $(this).children("a").removeClass("HoverState").addClass("NormalState");
});
$(".ModuleContainer").find(".Content").on("click", function () {
    setTimeout(function () {
        $(".cont").show();
        $("#SearchTitle").hide();
    }, 300);
    setTimeout(function () {
        $("#yibiaopan").hide();
    }, 100);
});
$(".Logo").on("click", function () {
    $(".cont").hide();
    setTimeout(function () {
        $("#yibiaopan").show();
    }, 300);
});
$(".MyOverlay").on("click", function () {
    setTimeout(function () {
        $(".cont").show();
        $("#SearchTitle").hide();
    }, 300);
    setTimeout(function () {
        $("#yibiaopan").hide();
    }, 100);
});
$("#HomePage").on("click", function () {
    $(".cont").hide();
    setTimeout(function () {
        $("#yibiaopan").show();
    }, 300);
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

//我的下拉菜单
$(".My").on("mousemove", function () {
    $(this).addClass("HoverState");
    $(this).css("borderBottom", "1px solid #fff");
    $(".MyOverlay").show();
});
$(".My").on("mouseout", function () {
    $(this).removeClass("HoverState");
    $(this).css("borderTop", "1px solid #d7d7d7");
    $(this).css("borderBottom", "1px solid #d7d7d7");
    $(".MyOverlay").hide();
});
$(".MyOverlay").on("mousemove", function () {
    $(".My").addClass("HoverState");
    $(".My").css("borderBottom", "1px solid #fff");
    $(this).show();
});
$(".MyOverlay").on("mouseout", function () {
    $(".My").removeClass("HoverState");
    $(".My").css("borderTop", "1px solid #d7d7d7");
    $(".My").css("borderBottom", "1px solid #d7d7d7");
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

//书签的下拉菜单
$(".Bookmark").on("mousemove", function () {
    $(this).addClass("HoverState");
    $(this).css("borderBottom", "1px solid #fff");
    $(".BookmarkDiv").show();
});
$(".Bookmark").on("mouseout", function () {
    $(this).removeClass("HoverState");
    $(this).css("borderTop", "1px solid #d7d7d7");
    $(this).css("borderBottom", "1px solid #d7d7d7");
    $(".BookmarkDiv").hide();
});
$(".BookmarkDiv").on("mousemove", function () {
    $(".Bookmark").addClass("HoverState");
    $(".Bookmark").css("borderBottom", "1px solid #fff");
    $(this).show();
});
$(".BookmarkDiv").on("mouseout", function () {
    $(".Bookmark").removeClass("HoverState");
    $(".Bookmark").css("borderTop", "1px solid #d7d7d7");
    $(".Bookmark").css("borderBottom", "1px solid #d7d7d7");
    $(this).hide();
});

//内容的选项卡切换
$.each($(".SelectDashboardTab"), function (i) {
    $(this).on("click", function () {
        $(this).addClass("SelectedState").siblings("div").removeClass("SelectedState");
    });
});

