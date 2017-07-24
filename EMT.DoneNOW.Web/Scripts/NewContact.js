$.each($(".nav-title li"), function(i) {
	$(this).click(function(){
		$(this).addClass("boders").siblings("li").removeClass("boders");
		$(".content").eq(i).show().siblings(".content").hide();
	})
});
$(".savetable th input[type=checkbox]").click(function () {
    if ($(this).is(':checked')) {
        $(".savetable td input[type=checkbox]").prop('checked', 'checked');
    } else {
        $(".savetable td input[type=checkbox]").prop('checked', '');
    }
});