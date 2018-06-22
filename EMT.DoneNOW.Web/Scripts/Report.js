$.each($(".TabBar a"), function (i) {
    $(this).click(function () {
        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
    })
});

var colors = ["white", "#efefef"];

$(function () {
   
    $.each($('.Collapsed'), function (i) {
        $('.Collapsed').eq(i).children().first().click(function () {
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

$("#d9").on("click", function () {
    $(".Toggle5").find(".Vertical5").hide();
    $(".Content5").show();
    var color = colors[0];
    $(".Normal5").css("background", color);

    $('.TabContainer5>.Collapsed').removeClass("col");
    $('.TabContainer5>.Collapsed').css("background", "white");

});
$("#d10").on("click", function () {
    $(".Toggle5").find(".Vertical5").show();
    $(".Content5").hide();
    var color = colors[1];
    $(".Normal5").css("background", color);
    $('.TabContainer5>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer5>.Collapsed').css("background", "#efefef");
});


$("#d11").on("click", function () {
    $(".Toggle6").find(".Vertical6").hide();
    $(".Content6").show();
    var color = colors[0];
    $(".Normal6").css("background", color);

    $('.TabContainer6>.Collapsed').removeClass("col");
    $('.TabContainer6>.Collapsed').css("background", "white");

});
$("#d12").on("click", function () {
    $(".Toggle6").find(".Vertical5").show();
    $(".Content6").hide();
    var color = colors[1];
    $(".Normal6").css("background", color);
    $('.TabContainer6>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer6>.Collapsed').css("background", "#efefef");
});

$("#d13").on("click", function () {
    $(".Toggle7").find(".Vertical6").hide();
    $(".Content7").show();
    var color = colors[0];
    $(".Normal7").css("background", color);

    $('.TabContainer7>.Collapsed').removeClass("col");
    $('.TabContainer7>.Collapsed').css("background", "white");

});
$("#d14").on("click", function () {
    $(".Toggle7").find(".Vertical5").show();
    $(".Content7").hide();
    var color = colors[1];
    $(".Normal7").css("background", color);
    $('.TabContainer7>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer7>.Collapsed').css("background", "#efefef");
});

$("#d15").on("click", function () {
    $(".Toggle8").find(".Vertical6").hide();
    $(".Content8").show();
    var color = colors[0];
    $(".Normal8").css("background", color);

    $('.TabContainer8>.Collapsed').removeClass("col");
    $('.TabContainer8>.Collapsed').css("background", "white");

});
$("#d16").on("click", function () {
    $(".Toggle8").find(".Vertical5").show();
    $(".Content8").hide();
    var color = colors[1];
    $(".Normal8").css("background", color);
    $('.TabContainer8>.Collapsed').each(function () {
        if (!$(this).hasClass("col")) {
            $(this).addClass("col");
        }
    })
    $('.TabContainer8>.Collapsed').css("background", "#efefef");
});



