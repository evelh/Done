$.each($(".nav-title li"), function(i) {
	$(this).click(function(){
		$(this).addClass("boders").siblings("li").removeClass("boders");
		$(".content").eq(i).show().siblings(".content").hide();
	})
});