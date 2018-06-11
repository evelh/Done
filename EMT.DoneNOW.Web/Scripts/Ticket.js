var backImg = ["up.png", "down.png"];
var index1 = 0; var index2 = 0; var index3 = 0; var index4 = 0; var index5 = 0; var index6 = 0; var index7 = 0; var index8 = 0;
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
$(".Title8").on("click", function () {
    $(this).next().toggle();
    $(this).children().find($('.Toggle')).children().find($('.InlineIcon ')).css("background-image", "url(../Images/" + backImg[index8 % 2] + ")");
    index8++;
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
$("#KonwLi").on("mousemove", function () {
    $("#Down3").show();
    $(this).css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $("#Down3").hide();
    $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down3").on("mousemove", function () {
    $(this).show();
    $("#KonwLi").css("border-bottom", "1px solid white").css("background", "white");
}).on("mouseout", function () {
    $(this).hide();
    $("#KonwLi").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
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
    //$(this).children().first().next().focus();
    //$(this).children().first().next().select();
    //if (document.execCommand('copy', false, null)) {

    //}
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
        LayerMsg("请填写备注信息！");
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
            setTimeout(function () { ApplyFilter("");},1000)
            
        }
    })



})

$(".Refresh").click(function () {
    ApplyFilter("");
})
// 应用过滤器 查看工单活动使用
function ApplyFilter(isAppFilter) {
    if (isAppFilter == "1") {
        $("#isAppFilter").val("1");
    }
    else if (isAppFilter == "0") {
        $("#isAppFilter").val("");
        $("#CkPublic").prop("checked", false);
        $("#CkInter").prop("checked", false);
        $("#CkLabour").prop("checked", false);
        $("#CkNote").prop("checked", false);
        $("#CkAtt").prop("checked", false);
        $("#CkMe").prop("checked", false);
    }
    GetItemCount();
    var ticket_id = $("#ticket_id").val();
    if (ticket_id != null && ticket_id != "") {
        LayerLoad();
        var url = "../Tools/TicketAjax.ashx?act=GetTicketActivity&ticketId=" + ticket_id;

        var isApp = $("#isAppFilter").val();
        if (isApp == "1") {
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
        }
      
        var orderBy = $("#orderBy").val();
        if (orderBy != null && orderBy != "" && orderBy != undefined) {
            url += "&orderBy=" + orderBy;
        }
        if ($("#CkShowSysNote").is(":checked")) {
            url += "&CkShowSys=1";
        }

        var actHtml = "";
        $.ajax({
            type: "GET",
            url: url,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data !=  "") {
                    actHtml = data;
                }
            }
        })
       

       
        setTimeout(function () {
            $("#ShowTicketActivity").html(actHtml);
            if ($("#CkShowBillData").is(":checked")) {
                $(".LabourBillData").show();
            }
            else {
                $(".LabourBillData").hide();
            }
            LayerLoadClose();
        }, 300);
    }
}

$("#CkShowSysNote").click(function () {
    ApplyFilter("");
})
$("#orderBy").change(function () {
    ApplyFilter("");
})

//$("#CkShowBillData").click(function () {
//    ApplyFilter("");
//})
$("#CkShowBillData").click(function () {
    if ($(this).is(":checked")) {
        $(".LabourBillData").show();
    }
    else {
        $(".LabourBillData").hide();
    }
})

$("#CancelLi").click(function () {
    window.close();
})

function AcceptTicket() {
    debugger;
    var ticket_id = $("#ticket_id").val();
    if (ticket_id != "" && ticket_id != null && ticket_id != undefined) {
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=AcceptTicket&ticket_id=" + ticket_id,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("接受成功！");
                    }
                    else {
                        LayerMsg("接受失败！" + data.reason);
                    }
                }
            }
        })
        setTimeout(function () { location.reload(); }, 1000)
    }
}

function ActDelete(id) {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + id, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    ApplyFilter("");
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}

function TodoComplete(id) {
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + id, null, function (data) {
        ApplyFilter("");
    })
}
function TodoEdit(id) {
    window.open("../Activity/Todos.aspx?id=" + id, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function NoteAddNote(cate, level, objType, objId) {
    var ticket_id = $("#ticket_id").val();
    window.open("../Activity/QuickAddNote.aspx?cate=" + cate + "&level=" + level + "&type=" + objType + "&objectId=" + objId + "&func=ApplyFilter&ticket_id=" + ticket_id, windowObj.notes + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function NoteEdit(id) {
    window.open("../Activity/Notes.aspx?id=" + id, windowObj.notes + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function NoteAddAttach(objId, objType) {
    window.open("../Activity/AddAttachment?objId=" + objId + "&objType=" + objType +"&noFunc=ApplyFilter", windowObj.attachment + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function AttDelete(id) {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + id, null, function (data) {
            ApplyFilter("");
        })
    }, function () { })
}
function OpenAttachment(id, isUrl, name) {
    if (isUrl == 1)
        window.open(name, windowType.blank, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
    else
        window.open("../Activity/OpenAttachment.aspx?id=" + id, windowType.blank, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}
function ViewOpportunity(id) {
    window.open('../Opportunity/ViewOpportunity.aspx?id=' + id, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}
function ViewSalesOrder(id) {
    window.open('../SaleOrder/SaleOrderView.aspx?id=' + id, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}
function ViewContract(id) {
    window.open('../Contract/ContractView.aspx?id=' + id, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}
function ViewContact(id) {
    window.open('../Contact/ViewContact.aspx?id=' + id, windowType.blank, 'left=200,top=200,width=900,height=750', false);
}
function NoteAddLabour(ticketId, parentId, AddType) {
    window.open('../ServiceDesk/TicketLabour.aspx?ticket_id=' + ticketId + "&parentObjId=" + parentId + "&AddType=" + AddType + "&noFunc=ApplyFilter", windowType.blank, 'left=200,top=200,width=1000,height=943', false);
}

function LabourDelete(id) {
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ProjectAjax.ashx?act=DeleteEntry&entry_id=" + id, null, function (data) {
            if (data.result) {
                LayerMsg("删除成功");
            }
            else {
                LayerMsg("删除失败！" + data.reason);
            }
            setTimeout(function () { ApplyFilter(""); },1000)
            
        })
    }, function () { })
}

function EditLabour(id) {
    window.open("../ServiceDesk/TicketLabour.aspx?id=" + id, windowObj.workEntry + windowType.edit, 'left=0,top=0,location=no,status=no,width=1000,height=943', false);
}

$(function () {
    //var maxNumber = 2000;
    //$("#WordNumber").text(maxNumber);
    $("#Note").keyup(function () {
        var insert = $("#Note").val();
        if (insert != '') {
            var length = insert.length;
            $("#WordNumber").text(length);
            if (length > 2000) {
                $(this).val($(this).val().substring(0, 2000));
                $("#WordNumber").text(length);
            }
        }

    });
})
// 页内查询
$("#ActivitySeachText").keyup(function () {
    highlight();
})
// 清除高亮显示
function clearSelection() {
    //找到所有highlight属性的元素；
    $('#ShowTicketActivity span').find('.highlight').each(function () {
        $(this).replaceWith($(this).html());//将他们的属性去掉；
    });
}

var i = 0;
var sCurText;
function highlight() {
    clearSelection();//先清空一下上次高亮显示的内容；

    var flag = 0;
    var bStart = true;

    //$('#tip').text('');
    //$('#tip').hide();
    var searchText = $('#ActivitySeachText').val();
    //var _searchTop = $('#searchstr').offset().top + 30;
    //var _searchLeft = $('#searchstr').offset().left;
    if ($.trim(searchText) == "") {
        //showTips("请输入查找车站名", _searchTop, 3, _searchLeft);
        return;
    }
    //查找匹配
    var searchText = $('#ActivitySeachText').val();//获取你输入的关键字；
    var regExp = new RegExp(searchText, 'g');//创建正则表达式，g表示全局的，如果不用g，则查找到第一个就不会继续向下查找了；
    var content = $("#ShowTicketActivity").text();
		if (!regExp.test(content)) {
			// showTips("没有找到要查找的车站",_searchTop,3,_searchLeft);
	        return;
	    } else {
	        if (sCurText != searchText) {
	            i = 0;
	            sCurText = searchText;
	         }
	    }
		//高亮显示
        $('#ShowTicketActivity span').each(function () {
            var html = $(this).text();
            //将找到的关键字替换，加上highlight属性；
            var newHtml = html.replace(regExp, '<span class="highlight">' + searchText + '</span>');
            $(this).html(newHtml);//更新；
			flag = 1;
		});
		
  //      //定位并提示信息
  //      if (flag == 1 && $(".highlight") != undefined) {
  //          if ($(".highlight").length > 1) {
		//		var _top = $(".highlight").eq(i).offset().top+$(".highlight").eq(i).height();
		//		var _tip = $(".highlight").eq(i).parent().find("strong").text();
		//		if(_tip=="") _tip = $(".highlight").eq(i).parent().parent().find("strong").text();
		//		var _left = $(".highlight").eq(i).offset().left;
	 //           var _tipWidth = $("#tip").width();
		//		if (_left > $(document).width() - _tipWidth) {
	 //                _left = _left - _tipWidth;
	 //           }
		//		//$("#tip").html(_tip).show();
	 //  //         $("#tip").offset({ top: _top, left: _left });
	 //  //         $("#search_btn").val("查找下一个");
		//	}else{
		//		var _top = $(".highlight").offset().top+$(".highlight").height();
		//		var _tip = $(".highlight").parent().find("strong").text();
	 //           var _left = $(".highlight").offset().left;
	 //           //$('#tip').show();
	 //           //$("#tip").html(_tip).offset({ top: _top, left: _left });
		//	}
		//	//$("html, body").animate({ scrollTop: _top - 50 });
	 //       i++;
  //          if (i > $(".highlight").length - 1) {
	 //           i = 0;
	 //       }
		//}
}

// 获取 相关条目数量
function GetItemCount() {
    var ticket_id = $("#ticket_id").val();
    if (ticket_id != "" && ticket_id != null && ticket_id != undefined) {
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=GetTicketItemCount&ticketId=" + ticket_id,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    $(".TicketItemCount").show();
                    $("#pubUser").text('('+data["pub"]+')'); 
                    $("#intUser").text('(' + data["int"] + ')');

                    $("#ItemLabour").text('(' + data["entry"] + ')');
                    $("#ItemNote").text('(' + data["act"] + ')');
                    $("#ItemAtt").text('(' + data["att"] + ')');

                    $("#ItemMe").text('(' + data["me"] + ')');
                } else {
                    $(".TicketItemCount").hide();
                }
            },
            error: function (data) {
                $(".TicketItemCount").hide();
            },
        })
    } else {
        $(".TicketItemCount").hide();
    }
}

function RemoveResOther(id) {
    LayerConfirm("确认移除该审批人吗？", "是", "否", function () {
        $("#other_" + id).remove();
    }, function () { })
}

function CancelTicketOther() {
    $("#bord_id").val("");
    $("#AllPass").prop("checked", true);
    $("#OtherOnePass").prop("checked", false);
    $("#ticketOtherNewTbody").html("");
}

function AppOther() {
    var ticketId = $("#ticket_id").val();
    if (ticketId == "")
        return;
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=AppOther&ticket_id=" + ticketId,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("审批成功！");
                setTimeout(function () { history.go(0); }, 800)
            }
        }
    })
}
function RevokeAppOther() {
    var ticketId = $("#ticket_id").val();
    if (ticketId == "")
        return;
    $.ajax({
        type: "GET",
        url: "../Tools/TicketAjax.ashx?act=RevokeAppOther&ticket_id=" + ticketId,
        async: false,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("撤销审批成功！");
                setTimeout(function () { history.go(0); }, 800)
            }
        }
    })
}
// 跳转到变更单审批页面
function ToAppOtherPage() {
    var ticketId = $("#ticket_id").val();
    if (ticketId == "")
        return;
    window.open("../ServiceDesk/ChangeTicketApprove.aspx?ticket_id=" + ticketId, "_blank", 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}



