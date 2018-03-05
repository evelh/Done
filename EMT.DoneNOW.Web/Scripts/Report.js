$.each($(".TabBar a"), function (i) {
    $(this).click(function () {
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});

var colors = ["white", "#efefef"];

$(function () {
   
    $.each($('.Collapsed'), function (i) {
        $('.Collapsed').eq(i).click(function () {
            debugger;
            if ($('.Collapsed').eq(i).hasClass("col")) {
                $('.Collapsed').eq(i).removeClass("col");
                $('.Collapsed').eq(i).css("background", "white");
            }
            else {
                $('.Collapsed').eq(i).addClass("col");
                $('.Collapsed').eq(i).css("background", "#efefef");
            }
            $('.Collapsed').eq(i).find(".Vertical").toggle();
            $('.Collapsed').eq(i).find('.Content').toggle();
        })
    })

})



$("#d1").on("click", function () {
    $(".Toggle1").find(".Vertical1").hide();
    $(".Content1").show();
    var color = colors[0];
    $(".Normal1").css("background", color);
    
    $('.TabContainer1>.Collapsed').removeClass("col");
    $('.TabContainer1>.Collapsed').css("background", "white");

});
$("#d2").on("click", function () {
    $(".Toggle1").find(".Vertical1").show();
    $(".Content1").hide();
    var color = colors[1];
    $(".Normal1").css("background", color);
    $('.TabContainer1>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer1>.Collapsed').css("background", "#efefef");
});
$("#d3").on("click", function () {
    $(".Toggle2").find(".Vertical2").hide();
    $(".Content2").show();
    var color = colors[0];
    $(".Normal2").css("background", color);

    $('.TabContainer2>.Collapsed').removeClass("col");
    $('.TabContainer2>.Collapsed').css("background", "white");
});
$("#d4").on("click", function () {
    $(".Toggle2").find(".Vertical2").show();
    $(".Content2").hide();
    var color = colors[1];
    $(".Normal2").css("background", color);
    $('.TabContainer2>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer2>.Collapsed').css("background", "#efefef");
});
$("#d5").on("click", function () {
    $(".Toggle3").find(".Vertical3").hide();
    $(".Content3").show();
    var color = colors[0];
    $(".Normal3").css("background", color);

    $('.TabContainer3>.Collapsed').removeClass("col");
    $('.TabContainer3>.Collapsed').css("background", "white");

});
$("#d6").on("click", function () {
    $(".Toggle3").find(".Vertical3").show();
    $(".Content3").hide();
    var color = colors[1];
    $(".Normal3").css("background", color);
    $('.TabContainer3>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer3>.Collapsed').css("background", "#efefef");
});

$("#d7").on("click", function () {
    $(".Toggle4").find(".Vertical4").hide();
    $(".Content4").show();
    var color = colors[0];
    $(".Normal4").css("background", color);

    $('.TabContainer4>.Collapsed').removeClass("col");
    $('.TabContainer4>.Collapsed').css("background", "white");

});
$("#d8").on("click", function () {
    $(".Toggle4").find(".Vertical4").show();
    $(".Content4").hide();
    var color = colors[1];
    $(".Normal4").css("background", color);
    $('.TabContainer4>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer4>.Collapsed').css("background", "#efefef");
});



