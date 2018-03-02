var backImg = ["up.png", "down.png"];
var index1 = 0; var index2 = 0; var index3 = 0; var index4 = 0; var index5 = 0; var index6 = 0; var index7 = 0;
$(".Title1").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index1 % 2] + ")");
    index1++;
});
$(".Title2").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index2 % 2] + ")");
    index2++;
});
$(".Title3").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index3 % 2] + ")");
    index3++;
});
$(".Title4").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index4 % 2] + ")");
    index4++;
});
$(".Title5").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index5 % 2] + ")");
    index5++;
});
$(".Title6").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index6 % 2] + ")");
    index6++;
});
$(".Title7").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index7 % 2] + ")");
    index7++;
});

var colors = ["#white", "white"];
var color1 = 0; var color2 = 0; var color3 = 0; var color4 = 0;
$(".Toggle1").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[color1 % 2]);
    color1++;
});
$(".Toggle2").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[color2 % 2]);
    color2++;
});
$(".Toggle3").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[color3 % 2]);
    color3++;
});
$(".Toggle4").on("click", function () {
    $(this).parent().parent().find($(".Vertical")).toggle();
    $(this).parent().parent().find($('.Content')).toggle();
    $(this).parent().parent().css("background", colors[color4 % 2]);
    color4++;
});
// filter
// FilterDiv
$("#ToolLi").on("mousemove", function () {
    $("#Down2").show();
    $(this).css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $("#Down2").hide();
    $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down2").on("mousemove", function () {
    $(this).show();
    $("#ToolLi").css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $(this).hide();
    $("#ToolLi").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });

$("#filter").on("mousemove", function () {
    $("#FilterDiv").show();
    $(this).css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $("#FilterDiv").hide();
    $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#FilterDiv").on("mousemove", function () {
    $(this).show();
    $("#filter").css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $(this).hide();
    $("#filter").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});

$(".QuickLaunchButton").mouseover(function () {
    $(this).children().first().show();
})
$(".QuickLaunchButton").mouseleave(function () {
    $(this).children().first().hide();
})



var hour, minute, second;//时 分 秒
hour = minute = second = 0;//初始化
//var millisecond = 0;//毫秒
var int;
function Reset()//重置
{
    window.clearInterval(int);
    hour = minute = second = 0;
    //document.getElementById('timetext').value = '00时00分00秒000毫秒';
    $("#ShowWatchTime").html("00:00:00");
    $("#PlayTimeDiv").removeClass("noplay");
    $("#PlayTimeDiv").addClass("Play");
    stop();
}

function start()//开始
{
    int = setInterval(timer, 1000);
}

function timer()//计时
{

    second = second + 1;

    if (second >= 60) {
        second = 0;
        minute = minute + 1;
    }

    if (minute >= 60) {
        minute = 0;
        hour = hour + 1;
    }
    if (hour >= 24) {
        hour = 0;
    }
    $("#ShowWatchTime").html(Return2(hour) + ":" + Return2(minute) + ":" + Return2(second));
}

function stop()//暂停
{
    window.clearInterval(int);
}

function Return2(num) {
    if (Number(num) < 10) {
        return "0" + num;
    }
    else {
        return num;
    }
}

$("#PlayTimeDiv").click(function () {
    if ($(this).hasClass("Play")) {
        $(this).removeClass("Play");
        $(this).addClass("noplay");
        start();
    }
    else {
        $(this).removeClass("noplay");
        $(this).addClass("Play");
        stop();
    }
})

var toId = "";
var type = "in";

function drag() {

    // var obj = $('#Drap .HighImportance');
    var obj = $('#Drap .Interaction');
    obj.bind('mousedown', DragStart);
    function DragStart(e) {
        var ol = obj.parent().offset().left;
        var ot = obj.parent().offset().top;
        deltaX = e.pageX - ol;
        deltaY = e.pageY - ot;
        $(this).trigger("click");
        $(document).bind({
            'mousemove': move,
            'mouseup': DragStop
        });
        return false;
    }
    function move(e) {


        $.each(obj.parent().siblings(), function (i) {
            var mX = obj.parent().siblings().eq(i).offset().left;
            var mY = obj.parent().siblings().eq(i).offset().top;
            if (e.pageX > mX && e.pageX < mX + obj.parent().siblings().eq(i).width() && e.pageY > mY && e.pageY < mY + obj.parent().siblings().eq(i).height()) {
                obj.parent().css('cursor', 'move')
                obj.css('cursor', 'move')
                $('.border_left').show()
                $('.border_right').show()
                type = "in";
                $('.border-line').hide()
                $('.border_left').css({
                    "left": 0,
                    "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                })
                $('.border_right').css({
                    "right": 0,
                    "top": obj.parent().siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.parent().siblings().eq(i).height() / 2 - 8,
                })
                $('.cover').show()
                $('.cover').css({
                    "left": (e.pageX + $('.cover').width() + 10) - $('.RowContainer').offset().left,
                    "top": (e.pageY - $('.RowContainer').offset().top),
                    "display": 'block'
                })

                $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                toId = obj.parent().siblings().eq(i).data("val");  // 代表将要放的位置的id

            } else {
                obj.parent().css('cursor', 'none')
            }
            if (e.pageY > mY - 5 && e.pageY < mY + 5) {
                type = "above";
                $('.border-line').show()
                $('.border-line').css({
                    'top': mY - $('.RowContainer').offset().top
                })
                $('.border_left').css({
                    "left": 0,
                    "top": mY - $('.RowContainer').offset().top - 6
                })
                $('.border_right').css({
                    "right": 0,
                    "top": mY - $('.RowContainer').offset().top - 6
                })
                //obj.css('border-top','1px solid #346a95')
                if (e.pageY < mY) {
                    $('.cover').html(obj.parent().siblings().eq(i).find('.Num').html());
                    // toId = obj.data("val");
                }
            }
        })

        // obj.css({
        //     "left": (e.pageX - deltaX),
        //     "top": (e.pageY - deltaY),
        //     "cursor":'move'
        // });


        return false;
    }
    function DragStop() {

        $('.cover').hide()
        $('.border_right').hide()
        $('.border_left').hide()
        $('.border-line').hide()
        obj.parent().css('cursor', '')
        obj.parent().find('.Interaction').css('cursor', '')
        $(document).unbind({
            'mousemove': move,
            'mouseup': DragStop,
            "cursor": 'pointer'
        });
        //DragTask();
    }
}
drag();
$(".IconContainer").on('click', function () {
    if ($(this).hasClass("Selected")) {
        $(this).removeClass('Selected');

    }
    else {
        $(this).addClass('Selected');
    }
    $(this).find('.Vertical').toggle();
    var _this = $(this).parent().parent().parent();
    var str = _this.find('.DataDepth').attr('data-depth');

});

$(".CopyTextButton").click(function () {
    $(this).children().first().next().focus();
    $(this).children().first().next().select();
    if (document.execCommand('copy', false, null)) {

    }
})

$(".Dot").mouseover(function (event) {
    //var winWidth = window.innerWidth;
    //var winHeight = window.innerHeight;


    //var Left = $(document).scrollLeft() + event.clientX;
    //var Top = $(document).scrollTop() + event.clientY;
    //var menuWidth = $(this).next().children().first().width();
    //var menuHeight = $(this).next().children().first().height();
    //var scrLeft = $(document).scrollLeft();
    //var scrTop = $(document).scrollTop();


    //$(this).next().children().first().css("left",  Left -30 + "px");
    //$(this).next().children().first().css("margin-top", Top - 145 + "px");
    $(this).next().children().first().show();

})


$(".Dot").mouseleave(function () {
    $(this).next().children().first().hide();
})


$(".TargetPointer>.Target").mouseover(function (event) {
    var winWidth = window.innerWidth;
    var winHeight = window.innerHeight;


    var Left = $(document).scrollLeft() + event.clientX;
    var Top = $(document).scrollTop() + event.clientY;
    var menuWidth = $(this).parent().next().children().first().width();
    var menuHeight = $(this).parent().next().children().first().height();
    var scrLeft = $(document).scrollLeft();
    var scrTop = $(document).scrollTop();


    $(this).parent().next().children().first().css("left", Left - 30 + "px");
    $(this).parent().next().children().first().css("margin-top", Top - 145 + "px");
    $(this).parent().next().children().first().show();
})
$(".TargetPointer>.Target").mouseleave(function () {
    $(this).parent().next().children().first().hide();
})

// 隐藏完成的检查单
function HideItem() {
    $(".Completed").hide();
    $("#CheckMange").text("显示完成条目");
    $("#CheckMange").removeAttr("onclick");
    $("#CheckMange").click(function () {
        ShowItem();
    })
}
// 显示完成的检查单
function ShowItem() {
    $(".Completed").show();
    $("#CheckMange").text("隐藏完成条目");
    $("#CheckMange").removeAttr("onclick");
    $("#CheckMange").click(function () {
        HideItem();
    })
}

$(".TicketButton").click(function () {
    var obj = $(this);
    $(".TicketButton").each(function () {
        $(this).removeClass("SelectedState");
        if (!$(this).hasClass("NormalState")) {
            $(this).addClass("NormalState");
        }
    })
    obj.addClass("SelectedState");
})
// 点击进行检查单完成取消操作
$(".ChecklistIcon").click(function () {
    var ckId = $(this).parent().data("val")
    var isCom = "1";
    if ($(this).hasClass("Checked")) {
        isCom = "0";
    }
    var obj = $(this);
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=ChangeCheckComplete&check_id=" + ckId + "&is_com=" + isCom,
        async: false,
        success: function (data) {
            if (data != "") {

            }
        }
    })
    var count = $("#CompletedCount").text();
    var isCom = obj.parent().hasClass("Completed");
    var creaInfo = obj.next().children().first().next().next().text();
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=GetCheckInfo&check_id=" + ckId,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                isCom = data.isCom;
                creaInfo = data.creTime + data.creRes;
            }
        }
    })
    if (isCom) {
        if (!obj.parent().hasClass("Completed")) {
            obj.parent().addClass("Completed");
        }
        if (!obj.hasClass("Checked")) {
            obj.addClass("Checked");
            obj.removeClass("Empty");
        }
        obj.next().children().first().next().next().text(creaInfo);
        count = Number(count) + 1;

        if ($("#CheckMange").text() == "显示完成条目") {
            $(".Completed").hide();
        }
    }
    else {
        if (obj.parent().hasClass("Completed")) {
            obj.parent().removeClass("Completed");
        }

        if (obj.hasClass("Checked")) {
            obj.addClass("Empty");
            obj.removeClass("Checked");
        }
        obj.next().children().first().next().next().text("");
        count = Number(count) - 1;
    }
    $("#CompletedCount").text(count);

})

$("#Note").click(function () {
    var isShowSave = $("#isShowSave").val();
    if (isShowSave == "") {
        $(".Details>.ButtonBar").show();
        $(".Details>.OptionBar").show();

        $("#isShowSave").val("1");
    }
})

$("#CancelTicketNoteAdd").click(function () {
    $("#isShowSave").val("");
    $(".Details>.ButtonBar").hide();
    $(".Details>.OptionBar").hide();
})

// 保存备注相关操作
$("#SaveTicketNoteAdd").click(function () {
    var ticket_id = $("#ticket_id").val();
    if (ticket_id == "" || ticket_id == null || ticket_id == undefined) {
        LayerMsg("工单信息丢失，请刷新页面重试！");
        return false;
    }
    var Note = $("#Note").val();
    if (Note == "") {
        LayerMsg("q请填写备注信息！");
        return false;
    }
    var NoteTypes = $("#NoteTypes").val();
    if (NoteTypes == "") {
        LayerMsg("请选择工单备注类型");
        return false;
    }
    var url = "../Tools/TicketAjax.ashx?act=AddTicketNote&ticket_id=" + ticket_id + "&ticket_note_type_id=" + NoteTypes + "&ticket_note_desc=" + Note;
    // is_inter    noti_contact   noti_pri_res   noti_inter_all
    if ($("#punlishInter").is(":checked")) {
        url += "&is_inter=1";
    }
    if ($("#TicketNoteNotiPriRes").is(":checked")) {
        url += "&noti_pri_res=1";
    }
    if ($("#TicketNoteNotiContact").is(":checked")) {
        url += "&noti_contact=1";
    }
    if ($("#TicketNoteNotiInterAll").is(":checked")) {
        url += "&noti_inter_all=1";
    }

    $.ajax({
        type: "GET",
        url: url,
        async: false,
        //dataType: "json",
        success: function (data) {
            if (data != "") {
                if (data == "True") {
                    LayerMsg("添加成功！");
                }
                else {
                    LayerMsg("添加失败！");
                }
            }
            setTimeout(function () { history.go(0);},1000)
            
        }
    })



})

$("#Refresh").click(function () {
    location.reload();
})
// 应用过滤器 查看工单活动使用
function ApplyFilter() {
    var ticket_id = $("#ticket_id").val();
    if (ticket_id != null && ticket_id != "") {
        LayerLoad();
        var url = "../Tool/TicketAjax?act=aa&ticketId=" + ticket_id;
        if ($("#CkPublic").is(":checked")) {
            url += "&CkPublic=1";
        }
        if ($("#CkInter").is(":checked")) {
            url += "&CkInter=1";
        }
        if ($("#CkLabour").is(":checked")) {
            url += "&CkLabour=1";
        }
        if ($("#CkNote").is(":checked")) {
            url += "&CkNote=1";
        }
        if ($("#CkAtt").is(":checked")) {
            url += "&CkAtt=1";
        }
        if ($("#CkMe").is(":checked")) {
            url += "&CkMe=1";
        }
        var orderBy = $("#orderBy").val();
        if (orderBy != null && orderBy != "" && orderBy != undefined) {
            url += "&orderBy=" + orderBy;
        }

        var actHtml = "";
        $.ajax({
            type: "GET",
            url: url,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    actHtml = data;
                }
            }
        })
       
        setTimeout(function () {
            $("#ShowTicketActivity").html(actHtml);
            LayerLoadClose();
        }, 300);
    }
}

$("#CkShowSysNote").click(function () {
    ApplyFilter();
})

$("#CkShowBillData").click(function () {
    ApplyFilter();
})

$("#CancelLi").click(function () {
    window.close();
})