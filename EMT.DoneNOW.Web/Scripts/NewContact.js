$.each($(".nav-title li"), function (i) {
    $(this).click(function () {
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
$(".switchicon").click(function () {
    if ($(this).hasClass("switchicon1")) {
        $(this).addClass("switchicon2").removeClass("switchicon1").parent().parent().addClass("allswitch")
    } else if ($(this).hasClass("switchicon2")) {
        $(this).addClass("switchicon1").removeClass("switchicon2").parent().parent().removeClass("allswitch")
    }
});

$("#close").click(function () {
    if (navigator.userAgent.indexOf("MSIE") > 0) {
        if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
            window.opener = null;
            window.close();
        } else {
            window.open('', '_top');
            window.top.close();
        }
    }
    else if (navigator.userAgent.indexOf("Firefox") > 0) {
        window.location.href = 'about:blank ';
    } else {
        window.opener = null;
        window.open('', '_self', '');
        window.close();
    }
});

