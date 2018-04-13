$('.Grid1_Container').css('height', $(window).height() - $('.Grid1_Container').offset().top - 50)
$('.Grid2_Container .ContainerBottom').css('height', $(window).height() - $('.Grid2_Container .ContainerBottom').offset().top - 50)
$(window).resize(function () {
    $('.Grid1_Container').css('height', $(window).height() - $('.Grid1_Container').offset().top - 50)
    $('.Grid2_Container .ContainerBottom').css('height', $(window).height() - $('.Grid2_Container .ContainerBottom').offset().top - 50)
})
function MenuBind() {
    $.each($('.R-ContainerUser'), function (i) {
        var _this = $('.R-ContainerUser').eq(i).children('li');
        var x = $(_this).eq(0).children('.UserContainer').height();

        $.each(_this, function (j) {

            if ($(_this).eq(j).children('.UserContainer').height() > x) {
                x = $(_this).eq(j).children('.UserContainer').height();
                //console.log(x)
            }
            if (i == 1 && j == 1) {
                // console.log($(_this).eq(1).children('.UserContainer').height())
            }
            $(_this).eq(j).children('.UserContainer').css('height', x)
            $(_this).eq(0).children('.UserContainer').css('height', x)
            $('.ContainerUser li').eq(i).children('.icon').css('height', x)
            //右击
            $(_this).eq(j).children('.UserContainer').bind("contextmenu", ShowContextMenu)
            $(_this).eq(j).children('.UserContainer').children(".hovertask").bind("contextmenu", ShowContextAppMenu)
        })
    })
}
//改动 新加   到   145行
$('.ContainerRight').css('width', $(window).width() - $('.ContainerLeft').width() - 38)
$('.R-ContainerDays-Total').css('width', $(window).width() - $('.ContainerDays').width() - 38)
$('.R-ContainerUser-Total').css('width', $(window).width() - $('.ContainerUser').width() - 20)
$('.R-ContainerUser-Total').css('height', $('.ContainerRight').height() - $('.R-ContainerDays-Total').height())
$('.ContainerUserScroll').css('height', $('.R-ContainerUser-Total').height())

$(window).resize(function () {
    $('.ContainerRight').css('width', $(window).width() - $('.ContainerLeft').width() - 38)
    $('.R-ContainerDays-Total').css('width', $(window).width() - $('.ContainerDays').width() - 38)
    $('.R-ContainerUser-Total').css('width', $(window).width() - $('.ContainerUser').width() - 20)
    $('.R-ContainerUser-Total').css('height', $('.ContainerRight').height() - $('.R-ContainerDays-Total').height())
    $('.ContainerUserScroll').css('height', $('.R-ContainerUser-Total').height())

})

//



//

//$.each($('.ContainerTop-User li'), function (i) {
//    var ob = $('.HouverTask').eq(i).children('li').eq(1).find('.HouverTaskItem');
//    var x = $('.HouverTask').length;
//    if (ob.length > 1) {
//        x += ob.length;
//        localStorage.setItem('xE', x)
//        $('.HouverTask').eq(i).css('width', 100 / x * ob.length + '%')
//        $('.ContainerTop-User li').eq(i).css('width', 100 / x * ob.length + '%')
//        ob.css('width', 98 / ob.length + '%')
//        console.log($('.ContainerBottom-Two').width() / x)

//    } else {
//        var xE = localStorage.getItem('xE');
//        $('.HouverTask').eq(i).css('width', 100 / xE + '%')
//        $('.ContainerTop-User li').eq(i).css('width', 100 / xE + '%')


//    }
//    var xE = localStorage.getItem('xE');
//    if ($('.ContainerBottom-Two').width() / xE < 220) {
//        $('.ContainerBottom-Two .HouverTaskA').css('width', (200 + x * 9) * xE)
//        $('.ContainerTop-User').css('width', (200 + xE * 9) * xE)
//    } else {
//        $('.ContainerBottom-Two .HouverTaskA').css('width', '100%')
//        //$('.ContainerTop-User').css('width', '100%')


//    }
//    $(window).resize(function () {
//        var xE = localStorage.getItem('xE');
//        if ($('.ContainerBottom-Two').width() / xE < 220) {
//            $('.ContainerBottom-Two .HouverTaskA').css('width', (200 + xE * 9) * xE)
//            $('.ContainerTop-User').css('width', (200 + xE * 9) * xE)

//        } else {
//            $('.ContainerBottom-Two .HouverTaskA').css('width', '100%')
//            //$('.ContainerTop-User').css('width', '100%')


//        }
//    })

//})


//var useritemW = $('.HouverTask').find('.HouverTaskItem').width() * $('.HouverTask').length;
var useritemW = '100%'

// $('.ContainerTop-User').css('width', useritemW)
//console.log($('.HouverTask').find('.HouverTaskItem').width() * $('.HouverTask').length)
$('.ContainerTop-Two').children().css('width', useritemW)
$('.HouverTaskA').css('width', useritemW)
$('.ContainerTop-Two').children('.ContainerTop-User').css('width', useritemW)
$(window).resize(function () {
    $('.ContainerBottom-Two').css('width', $(window).width() - $('.ContainerBottom-One').width() - 38)
    $('.ContainerTop-Two').css('width', $(window).width() - $('.ContainerTop-One').width() - 38)
    $('.ContainerTop-Two').children().css('width', $('.ContainerTop-User').width())
    $('.ContainerTop-Two').children('.ContainerTop-User').css('width', useritemW)

})


//console.log($('.ContainerTop-One').width())
$('.ContainerBottom-Two').css('width', $(window).width() - $('.ContainerBottom-One').width() - 38)
$('.ContainerTop-Two').css('width', $(window).width() - $('.ContainerTop-One').width() - 38)
var groupArr = new Array;
var SetgroupArr;
$.each($('.ContainerTop-User li'), function (i) {
    var ob = $('.HouverTask').eq(i).children('li').eq(1).find('.HouverTaskItem');
    var x = $('.HouverTask').length;
    if (ob.length > 1) {
        x += ob.length;
        localStorage.setItem('xE', x)
        $('.HouverTask').eq(i).css('width', 100 / x * ob.length + '%')
        $('.ContainerTop-User li').eq(i).css('width', 100 / x * ob.length + '%')
        ob.css('width', 98 / ob.length + '%')
        //console.log($('.ContainerBottom-Two').width() / x)

    } else {
        var xE = localStorage.getItem('xE');
        $('.HouverTask').eq(i).css('width', 100 / xE + '%')
        $('.ContainerTop-User li').eq(i).css('width', 100 / xE + '%')


    }
    var xE = localStorage.getItem('xE');

    groupArr.push($('.ContainerTop-User li').eq(i).data('group'));
    SetgroupArr = Array.from(new Set(groupArr))
   
    if ($('.ContainerBottom-Two').width() / xE < 220) {
        $('.ContainerBottom-Two .HouverTaskA').css('width', (200 + x * 9) * xE)
        $('.ContainerTop-User').css('width', (200 + xE * 9) * xE)
    } else {
        $('.ContainerBottom-Two .HouverTaskA').css('width', '100%')
        $('.ContainerTop-User').css('width', '100%')


    }
    $(window).resize(function () {
        var xE = localStorage.getItem('xE');
        if ($('.ContainerBottom-Two').width() / xE < 220) {
            $('.ContainerBottom-Two .HouverTaskA').css('width', (200 + xE * 9) * xE)
            $('.ContainerTop-User').css('width', (200 + xE * 9) * xE)

        } else {
            $('.ContainerBottom-Two .HouverTaskA').css('width', '100%')
            $('.ContainerTop-User').css('width', '100%')
        }
    })

})
// 更改休假Div 高度
var maxHouverHeight = 27;
$(".HouverTask").each(function () {
    var thisHeight = 0;
    var obj = $(this).children("li").eq(0).children(".Hover-t");
    thisHeight = obj.children(".hovertask").length * 16;
    if (maxHouverHeight < thisHeight) {
        maxHouverHeight = thisHeight
    }
    //console.log(thisHeight);
})
$(".Hover-t").css("height", maxHouverHeight);
$(".HouverTask").each(function () {
    $(this).children("li").eq(0).children(".border").eq(0).css("height", maxHouverHeight);
})

$.each($('.DaysList .Days-2'), function (i) {
    var w = 0;
    for (var j = 0; j < groupArr.length; j++) {
        if (groupArr[j] == SetgroupArr[i]) {
            w += $('.ContainerTop-User li').eq(j).width();
            $('.DaysList .Days-2').eq(i).css('width', w + '%')
            $(window).resize(function () {
                $('.DaysList .Days-2').eq(i).css('width', w + '%')
            })
        }
    }
   

});
function RunDaysDom(a) {
    if (a == 1) {
        $('.Grid1_Container').hide()
        $('.Grid2_Container').show()
        debugger
        $('.ContainerTop-Two').css('width', $(window).width() - $('.ContainerTop-One').width() - 38)
        $('.ContainerBottom-Two').css('width', $(window).width() - $('.ContainerBottom-One').width() - 38)
        $('.ContainerTop-Two').children().css('width', $('.ContainerTop-User').width())
        $('.ContainerTop-Two').children('.ContainerTop-User').css('width', '150%')
        $(window).resize(function () {
            $('.ContainerBottom-Two').css('width', $(window).width() - $('.ContainerBottom-One').width() - 38)
            $('.ContainerTop-Two').css('width', $(window).width() - $('.ContainerTop-One').width() - 38)
            $('.ContainerTop-Two').children().css('width', $('.ContainerTop-User').width())
            $('.ContainerTop-Two').children('.ContainerTop-User').css('width', '150%')

        })

    }
    if (a == 5) {
        $('.Grid1_Container').show()
        $('.Grid2_Container').hide()
        $('.ContainerRight .R-ContainerDays li').eq(5).hide()
        $('.ContainerRight .R-ContainerDays li').eq(6).hide()
        $.each($('.R-ContainerUser'), function (i) {
            $('.R-ContainerUser').eq(i).children('li').css('width', 100 / 5 + "%");
            $('.R-ContainerUser').eq(i).children('li').eq(5).hide()
            $('.R-ContainerUser').eq(i).children('li').eq(6).hide()
        })
        $('.ContainerRight .R-ContainerDays li').css('width', 100 / 5 + "%");
    }
    if (a == 7 || a == '7+') {
        $('.Grid1_Container').show()
        $('.Grid2_Container').hide()
        $('.ContainerRight .R-ContainerDays li').eq(5).show()
        $('.ContainerRight .R-ContainerDays li').eq(6).show()
        $.each($('.R-ContainerUser'), function (i) {
            $('.R-ContainerUser').eq(i).children('li').css('width', 100 / 7 + "%");
            $('.R-ContainerUser').eq(i).children('li').eq(5).show()
            $('.R-ContainerUser').eq(i).children('li').eq(6).show()
        })
        $('.ContainerRight .R-ContainerDays li').css('width', 100 / 7 + "%");
    }
}

//div跟随滚动条滚动条
function OnScrollH(dom) {
    $('.ContainerTop-Two').children().css('left', -dom.scrollLeft)
    // console.log()
}
function OnScrollHAW(dom) {
    $('.R-ContainerDays').css('left', -dom.scrollLeft)
    $('.ContainerUserScroll').children().css('top', -dom.scrollTop)
}

MenuBind();
var objectDate = "";
function ShowContextMenu(e) {
    var menu = document.getElementById("menu");
    if ($(this).hasClass("hoverAppoint")) {
        menu = document.getElementById("AppiontMenu");
    }
    objectDate = $(this).data("date");
    var Times = 0;
    clearInterval(Times);
    (function () {
        menu.style.display = "block";
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    };
    menu.style.left = e.clientX + 'px';
    menu.style.top = e.clientY + 'px';
    clearInterval(Times);

}
var objectId = "";
function ShowContextAppMenu(e) {
    $(".otherMenu").hide();
    var menu = document.getElementById("menu");
    if ($(this).hasClass("hoverAppoint")) {
        menu = document.getElementById("OtherMenu");
        $(".AppiontMenu").show();
    }
    else if ($(this).hasClass("hoverTodo")) {
        menu = document.getElementById("OtherMenu");
        $(".TodoMenu").show();
    }
    else if ($(this).hasClass("hoverCall")) {
        menu = document.getElementById("OtherMenu");
        $(".CallMenu").show();
    }
    $(this).parent().unbind();
    objectId = $(this).data("val");
    objectDate = $(this).data("date");
    var Times = 0;
    clearInterval(Times);
    (function () {
        menu.style.display = "block";
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
    }());
    menu.onmouseenter = function () {
        clearInterval(Times);
        menu.style.display = "block";
    };
    menu.onmouseleave = function () {
        Times = setTimeout(function () {
            menu.style.display = "none";
        }, 1000);
        $(this).parent().bind("contextmenu", ShowContextMenu);
    };
    menu.style.left = e.clientX + 'px';
    menu.style.top = e.clientY + 'px';
    clearInterval(Times);

}

// 1 天
$.each($('.HouverTask'), function (i) {
    var _this = $('.HouverTask').eq(i).children('li')
    $.each(_this, function (j) {
        _this.eq(j).bind("contextmenu", ShowContextMenu)
    })
})
//选择周期天数
$('.daysElm ul li').each(function (i) {
    $('.daysElm ul li').eq(i).click(function () {
        //需要时调用
        Loading();

        setTimeout(function () {
            $('.daysElm ul li').eq(i).addClass('ShowdatsElm').siblings().removeClass('ShowdatsElm');
            // RunDaysDom($('.daysElm ul li').eq(i).html())
            ChangeFilter("");
        }, 1000)
    })
})



//function RunDaysDom(a) {
//    if (a == 1) {
//        $('.Grid1_Container').hide()
//        $('.Grid2_Container').show()
//        $('.ContainerTop-Two').css('width', $('.ContainerTop-Two').width() - 18)

//    }
//    if (a == 5) {
//        $('.Grid1_Container').show()
//        $('.Grid2_Container').hide()
//        $('.ContainerRight .R-ContainerDays li').eq(5).hide()
//        $('.ContainerRight .R-ContainerDays li').eq(6).hide()
//        $.each($('.R-ContainerUser'), function (i) {
//            $('.R-ContainerUser').eq(i).children('li').css('width', 100 / 5 + "%");
//            $('.R-ContainerUser').eq(i).children('li').eq(5).hide()
//            $('.R-ContainerUser').eq(i).children('li').eq(6).hide()
//        })
//        $('.ContainerRight .R-ContainerDays li').css('width', 100 / 5 + "%");
//    }
//    if (a == 7 || a == '7+') {
//        $('.Grid1_Container').show()
//        $('.Grid2_Container').hide()
//        $('.ContainerRight .R-ContainerDays li').eq(5).show()
//        $('.ContainerRight .R-ContainerDays li').eq(6).show()
//        $.each($('.R-ContainerUser'), function (i) {
//            $('.R-ContainerUser').eq(i).children('li').css('width', 100 / 7 + "%");
//            $('.R-ContainerUser').eq(i).children('li').eq(5).show()
//            $('.R-ContainerUser').eq(i).children('li').eq(6).show()
//        })
//        $('.ContainerRight .R-ContainerDays li').css('width', 100 / 7 + "%");
//    }
//}



//取消浏览器右击默认事件 
$('body').bind("contextmenu", function () {

    return false;
});


document.onclick = function () {
    menu.style.display = "none";
}


//鼠标悬浮提示
function Suspension(domList, showBox) {
    //悬浮类domList     
    $.each(domList, function (i) {
        domList.eq(i).mouseover(function (e) {
            //内容样式
            showBox.html(domList.eq(i).children(".HiddenToolTip").html())
            showBox.css({
                'left': e.clientX + 10,
                'top': e.clientY + 10,
            })
            showBox.show()
        })
        domList.eq(i).mousemove(function (e) {
            showBox.eq(i).html(domList.eq(i).children(".HiddenToolTip").html())
            showBox.css({
                'left': e.clientX + 10,
                'top': e.clientY,
            })
        })
        domList.eq(i).mouseout(function (e) {
            showBox.eq(i).html('')
            showBox.hide();
        })
    })
}

//引用
Suspension($('.hovertask'), $('.WzTtDiV'))
var startId = "";
var startType = "";
var startDate = "";
var startResId = "";
var endDate = "";
var endResId = "";
var endId = "";
function drag(obj) {
    debugger;
    var dayType = $(".ShowdatsElm").eq(0).text();
    obj.bind('mousedown', start);
    var ol = obj.offset().left;
    var ot = obj.offset().top;
        function start(e) {
            if (e.button != 0) {
                return false
            }
            // deltaX = e.pageX - ol;
            // deltaY = e.pageY - ot;
            startId = obj.data("val");
            startType = obj.data("type");
            startDate = obj.data("date");
            startResId = obj.data("res");
            obj.css({ 'left': e.pageX - ol + 10, 'top': e.pageY - ot, 'border': '1px solid #8F8D98' })
            $(document).bind({
                'mousemove': move,
                'mouseup': stop
            });
            obj.parent().css('cursor', 'move')
            obj.parents('.R-ContainerUser').siblings('.R-ContainerUser').find('.UserContainer').css('cursor', 'move')
            return false;
        };
        function move(e) {
            obj.css({ 'left': e.pageX - ol + 10, 'top': e.pageY - ot })
            // var objWith =obj.parent().width();
            // var objHeight = obj.parent().height();
            // //判断指针到某个盒子的位置
            // if(e.pageX >=  ol && e.pageX < e.pageX+ objWith && e.pageY >= ot && e.pageY < e.pageY+ objHeight ){
            //     obj.parent().css('background','#FFF8DC')
            // }else{
            //     obj.parent().css('background','none')                    
            // }
            function moeent() {
                $.each($('.UserContainer'), function (i) {
                    $('.UserContainer').eq(i).mouseover(function () {
                        //if ($('.UserContainer').eq(i).find('div').length == 0) {
                        $('.UserContainer').eq(i).css('background', '#FFF8DC')
                        localStorage.setItem('MoveD', i)
                        //}
                    })
                    $('.UserContainer').eq(i).mouseout(function () {
                        $('.UserContainer').eq(i).css('background', 'none')
                        localStorage.setItem('MoveD', '')
                    })
                })
                return false
            }
            moeent()

        };
        function stop() {
            $(document).unbind({
                'mousemove': move,
                'mouseup': stop,
            });
            obj.css({ 'left': 0, 'top': 0, 'border': 'none' })
            obj.parent().css('cursor', 'pointer')
            obj.parents('.R-ContainerUser').siblings('.R-ContainerUser').find('.UserContainer').css('cursor', 'pointer')
            if (localStorage.getItem('MoveD') == '') {
                // alert('移动失败')                    
            } else {
                // alert('移到了第'+localStorage.getItem('MoveD')+'个类')                                                          
            }
            $.each($('.UserContainer'), function (i) {
                $('.UserContainer').eq(i).css('background', 'none')
                $('.UserContainer').eq(i).unbind();
                //拖拽完成处理
                var endObj = $('.UserContainer').eq(localStorage.getItem('MoveD'));
                endDate = endObj.data("date");
                endResId = endObj.data("res");
                endId = endObj.data("val");
            })
            MenuBind();
            ShowDialog();
        }
}
function DragSingle(obj) {
    obj.bind('mousedown', startSingle);
    var ol = obj.offset().left;
    var ot = obj.offset().top;
    function startSingle(e) {
        if (e.button != 0) {
            return false
        }
        // deltaX = e.pageX - ol;
        // deltaY = e.pageY - ot;
        startId = obj.data("val");
        startType = obj.data("type");
        startDate = obj.data("date");
        startResId = obj.data("res");
        obj.css({ 'left': e.pageX - ol + 10, 'top': e.pageY - ot, 'border': '1px solid #8F8D98' })
        $(document).bind({
            'mousemove': moveSingle,
            'mouseup': stopSingle
        });
        obj.parent().css('cursor', 'moveSingle')
        obj.parents('.HouverTask').siblings('.HouverTask').find('.UserContainer').css('cursor', 'moveSingle')
        return false;
    };
    function moveSingle(e) {
        obj.css({ 'left': e.pageX - ol + 10, 'top': e.pageY - ot })
        // var objWith =obj.parent().width();
        // var objHeight = obj.parent().height();
        // //判断指针到某个盒子的位置
        // if(e.pageX >=  ol && e.pageX < e.pageX+ objWith && e.pageY >= ot && e.pageY < e.pageY+ objHeight ){
        //     obj.parent().css('background','#FFF8DC')
        // }else{
        //     obj.parent().css('background','none')                    
        // }
        function moeentSingle() {
            $.each($('.HouverTask li'), function (i) {
                $('.HouverTask li').eq(i).mouseover(function () {
                    //if ($('.UserContainer').eq(i).find('div').length == 0) {
                    $('.HouverTask li').eq(i).css('background', '#FFF8DC')
                    localStorage.setItem('MoveD', i)
                    //}
                })
                $('.HouverTask li').eq(i).mouseout(function () {
                    $('.HouverTask li').eq(i).css('background', 'none')
                    localStorage.setItem('MoveD', '')
                })
            })
            return false
        }
        moeentSingle()

    };
    function stopSingle() {
        $(document).unbind({
            'mousemove': moveSingle,
            'mouseup': stopSingle,
        });
        obj.css({ 'left': 0, 'top': 0, 'border': 'none' })
        obj.parent().css('cursor', 'pointer')
        obj.parents('.R-ContainerUser').siblings('.R-ContainerUser').find('.UserContainer').css('cursor', 'pointer')
        if (localStorage.getItem('MoveD') == '') {
            // alert('移动失败')                    
        } else {
            // alert('移到了第'+localStorage.getItem('MoveD')+'个类')                                                          
        }
        $.each($('.HouverTask li'), function (i) {
            $('.HouverTask li').eq(i).css('background', 'none')
            $('.HouverTask li').eq(i).unbind();
            //拖拽完成处理
            var endObj = $('.HouverTask li').eq(localStorage.getItem('MoveD'));
            endDate = endObj.data("date");
            endResId = endObj.data("res");
            endId = endObj.data("val");
        })
        MenuBind();
        ShowDialog();

    }

}


function ShowDialog() {
    debugger;
    if (startId == "" || endDate == "") {
        ClearTempId();
        return;
    }
    if (startType == "CallDiv") {
        if (startResId == endResId && startDate == endDate) {
            ClearTempId();
            return;
        }
        else {
            // endResId 判断拖拽的员工是否有
            if (endResId == "" || endResId == null || endResId == undefined) {
                LayerMsg("请选择相应的负责人");
                ClearTempId();
                return;
            }
            if (startResId != endResId) {
                // endResId 获取选择的负责人的相应角色，没有角色则无法选择
                // 如果服务预定关联了任务，且任务的团队成员中没有目标员工
                var isInCall = "";
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ServiceCallAjax.ashx?act=CheckResInCall&resId=" + endResId + "&callId=" + startId,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            isInCall = "1";
                        }
                    },
                });
                if (isInCall != "1") {
                    LayerMsg("您将一个或多个任务拖到不属于项目组成员的员工中。请先将此员工添加到项目团队");
                    ClearTempId();
                    return;
                }
                var isHasRole = "";
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/RoleAjax.ashx?act=GetRoleByResId&resId=" + endResId,
                    dataType: "json",
                    success: function (data) {
                        if (data!="") {
                            isHasRole = "1";
                            for (var i = 0; i < data.length; i++) {
                                $("#ResRoleList").append("<option value='"+data[i].id+"'>"+data[i].name+"</option>");
                            }
                        } 
                    },
                });
                if (isHasRole != "1") {
                    LayerMsg("请先给此员工设置角色!");
                    ClearTempId();
                    return;
                }
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ServiceCallAjax.ashx?act=GetCall&callId=" + startId,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#CallRoleAccountName").text(data.accountName);
                            $("#CallRoleTicketTitle").text(data.accountName);
                        } else {
                            LayerMsg("为获取到该服务预定信息，请刷新页面后重试");
                            CanCallRoleDialog();
                            ClearTempId();
                        }
                    },
                });
                $("#BackgroundOverLay").show();
                $("#Nav1").show();
            }
            else {
                ShowNav2();
            }
        }
    }
    else if (startType == "AppiontDiv") {
        if (endResId != "") {
            ShowNav3();
        }
    }
    else if (startType == "ToDoDiv") {
        if (endResId != "") {
            ShowNav4();
        }
    }
    
}
function CanCallRoleDialog() {
    $(".Dialog").hide();
    $("#BackgroundOverLay").hide();
    ClearTempId();
}

function ShowNav2() {
    $("#BackgroundOverLay").show();
    $("#Nav2").show();
    var endDateArr = endDate.split(' ');
    if (endDateArr.length == 1) {
        $("#CallStartDate").text(endDate);
    } else {
        $("#CallStartDate").text(endDateArr[0]);
    }
    //$("#CallStartDate").text(endDate);
    // 根据服务预定 获取客户信息
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ServiceCallAjax.ashx?act=GetCall&callId=" + startId,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                $("#accountName").text(data.accountName);
                $("#callDescption").text(data.description);
                if (endDateArr.length == 1) {
                    $("#CallStartTime").val(data.startTimeString);
                }
                else {
                    $("#CallStartTime").val(endDateArr[1]);
                }
                
                //$("#CallStartDate").text(data.startDateString);
                $("#CallDurationTime").val(data.durHours);
                $("#CallEndTimeSpan").text(data.endTimeString);
                $("#CallEndDate").text(data.endDateString);
                ChangeCallEndDate();
            } else {
                LayerMsg("为获取到该服务预定信息，请刷新页面后重试");
                CanCallRoleDialog();
            }
        },
    });
}

function ShowNav3() {
    if (endResId == "") {
        return;
    }
    $("#BackgroundOverLay").show();
    $("#Nav3").show();

    var endDateArr = endDate.split(' ');
    if (endDateArr.length == 1) {
        $("#AppiontStartDate").text(endDate);
    } else {
        $("#AppiontStartDate").text(endDateArr[0]);
    }
  
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DispatchAjax.ashx?act=GetAppiont&id=" + startId,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                $("#AppiontTitle").text(data.name);
                $("#AppiontDescption").text(data.description);
                if (endDateArr.length == 1) {
                    $("#AppiontStartTime").val(data.startTimeString);
                } else {
                    $("#AppiontStartTime").val(endDateArr[1]);
                }
                $("#AppiontDurationTime").val(data.durHours);
                ChangeAppiontEndDate();
            } else {
                LayerMsg("为获取到约定信息，请刷新页面后重试");
                CanCallRoleDialog();
            }
        },
    });
}

function ShowNav4() {
    debugger;
    $("#BackgroundOverLay").show();
    $("#Nav4").show();
    var endDateArr = endDate.split(' ');
    if (endDateArr.length == 1) {
        $("#TodoStartDate").text(endDate)
    } else {
        $("#TodoStartDate").text(endDateArr[0]);
    }
    ;
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ActivityAjax.ashx?act=GetActicityInfo&id=" + startId,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                $("#TodoAccount").text(data.accName);
                $("#TodoActicity").text(data.actiType);
                if (endDateArr.length == 1) {
                    $("#TodoStartTime").val(data.startTimeString);
                }
                else {
                    $("#TodoStartTime").val(endDateArr[0]);
                }
                $("#TodoDurationTime").val(data.durHours);
                ChangeTodoEndDate();
            } else {
                LayerMsg("为获取到约定信息，请刷新页面后重试");
                CanCallRoleDialog();
            }
        },
    });
}

function SaveChangeTodo() {
    var startDate = $("#TodoStartDate").text();
    var CallStartTime = $("#TodoStartTime").val();
    var CallDurationTime = $("#TodoDurationTime").val();
    if (CallStartTime == "") {
        LayerMsg("请填写开始时间");
        return;
    }
    CallStartTime = startDate + " " + CallStartTime;
    if (CallDurationTime == "") {
        LayerMsg("请填写持续时间");
        return;
    }
    $('.loading').show();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DispatchAjax.ashx?act=EditTodo&id=" + startId + "&startTime=" + CallStartTime + "&durHours=" + CallDurationTime + "&resId=" + endResId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("保存成功");
            }
            else {
                LayerMsg("保存失败");
            }
            setTimeout(function () { history.go(0); }, 900);
        },
    });
}
$("#TodoStartTime").blur(function () {
    ChangeTodoEndDate();
})
$("#TodoDurationTime").blur(function () {
    ChangeTodoEndDate();
})
function ChangeTodoEndDate() {
    var startDate = $("#TodoStartDate").text();
    var startTime = $("#TodoStartTime").val();
    var duraHours = $("#TodoDurationTime").val();
    if (startDate == "" || startTime == "" || duraHours == "")
        return;
    var start = new Date(Date.parse((startDate + " " + startTime).replace(/-/g, "/")));
    var timestamp = start.getTime();
    var addHours = Number(duraHours) * 60 * 60 * 1000;
    var endTimeStamp = Number(timestamp) + Number(addHours);
    var endDate = new Date(endTimeStamp);
    $("#TodoEndDate").text(endDate.getFullYear() + "-" + ReturnTwo(endDate.getMonth() + 1) + "-" + ReturnTwo(endDate.getDate()));
    $("#TodoEndTimeSpan").text(ReturnTwo(endDate.getHours()) + ":" + ReturnTwo(endDate.getMinutes()));
}

function SaveChangeAppiont() {
    var startDate = $("#AppiontStartDate").text();
    var CallStartTime = $("#AppiontStartTime").val();
    var CallDurationTime = $("#AppiontDurationTime").val();
    if (CallStartTime == "") {
        LayerMsg("请填写开始时间");
        return;
    }
    CallStartTime = startDate + " " + CallStartTime;
    if (CallDurationTime == "") {
        LayerMsg("请填写持续时间");
        return;
    }
    $('.loading').show();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DispatchAjax.ashx?act=EditAppiont&id=" + startId + "&startTime=" + CallStartTime + "&durHours=" + CallDurationTime + "&resId=" + endResId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("保存成功");
            }
            else {
                LayerMsg("保存失败");
            }
            setTimeout(function () { history.go(0); }, 900);
        },
    });
}
$("#AppiontStartTime").blur(function () {
    ChangeAppiontEndDate();
})
$("#AppiontDurationTime").blur(function () {
    ChangeAppiontEndDate();
})
function ChangeAppiontEndDate() {
    var startDate = $("#AppiontStartDate").text();
    var startTime = $("#AppiontStartTime").val();
    var duraHours = $("#AppiontDurationTime").val();
    if (startDate == "" || startTime == "" || duraHours == "")
        return;
    var start = new Date(Date.parse((startDate + " " + startTime).replace(/-/g, "/")));
    var timestamp = start.getTime();
    var addHours = Number(duraHours) * 60 * 60 * 1000;
    var endTimeStamp = Number(timestamp) + Number(addHours);
    var endDate = new Date(endTimeStamp);
    $("#AppiontEndDate").text(endDate.getFullYear() + "-" + ReturnTwo(endDate.getMonth() + 1) + "-" + ReturnTwo(endDate.getDate()));
    $("#AppiontEndTimeSpan").text(ReturnTwo(endDate.getHours()) + ":" + ReturnTwo(endDate.getMinutes()));
}

function ToChangeCall() {
    var ResRoleList = $("#ResRoleList").val();
    if (ResRoleList == "") {
        LayerMsg("请为负责人选择角色！");
        return;
    }
    $("#ChooseRoleId").val(ResRoleList);
    ShowNav2();
}
function SaveChangeCall() {
    var startDate = $("#CallStartDate").text();
    var CallStartTime = $("#CallStartTime").val();
    var CallDurationTime = $("#CallDurationTime").val();
    if (CallStartTime == "")
    {
        LayerMsg("请填写开始时间");
        return;
    }
    CallStartTime = startDate + " " + CallStartTime;
    if (CallDurationTime == "") {
        LayerMsg("请填写持续时间");
        return;
    }
    $('.loading').show();
    var ChooseRoleId = $("#ChooseRoleId").val();
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/ServiceCallAjax.ashx?act=EditCall&callId=" + startId + "&startTime=" + CallStartTime + "&durHours=" + CallDurationTime + "&roleId=" + ChooseRoleId + "&resId=" + endResId + "&oldResId=" + startResId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("保存成功");
            }
            else {
                LayerMsg("保存失败");
            }
            setTimeout(function () { history.go(0); }, 900);
        },
    });
}
$("#CallStartTime").blur(function () {
    ChangeCallEndDate();
})
$("#CallDurationTime").blur(function () {
    ChangeCallEndDate();
})
function ChangeCallEndDate() {
    var startDate = $("#CallStartDate").text();
    var startTime = $("#CallStartTime").val();
    var duraHours = $("#CallDurationTime").val();
    if (startDate == "" || startTime == "" || duraHours == "")
        return;
    var start = new Date(Date.parse((startDate + " " + startTime).replace(/-/g, "/")));
    var timestamp = start.getTime();
    var addHours = Number(duraHours) * 60 * 60 * 1000;
    var endTimeStamp = Number(timestamp) + Number(addHours);
    var endDate = new Date(endTimeStamp);
    $("#CallEndDate").text(endDate.getFullYear() + "-" + ReturnTwo(endDate.getMonth() + 1) + "-" + ReturnTwo(endDate.getDate())); 
    $("#CallEndTimeSpan").text(ReturnTwo(endDate.getHours()) + ":" + ReturnTwo(endDate.getMinutes()));
}
function ReturnTwo(num) {
    if (Number(num) < 10) {
        return "0" + num;
    }
    return num;
}
 
// 清除拖拽数据
function ClearTempId() {
    startId = "";
    startType = "";
    startDate = "";
    startResId = "";
    endDate = "";
    endResId = "";
    endId = "";
}

$.each($('.stockstask'), function (i) {
    var dayType = $(".ShowdatsElm").eq(0).text();
    if (dayType == "1") {
        DragSingle($('.stockstask').eq(i)); 
    }
    else {
        drag($('.stockstask').eq(i));
    }
    
})



// Loading

var a = false;
$('.loading').css('height', $(window).height())
function Loading() {
    $('.loading').show()
    setTimeout(function () { a = true; $('.loading').hide() }, 1000)
}
Loading()

//timework

//var date = new Date();
//$('.Wdate').val(date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate())
function GetDateStr(AddDayCount) {
    var dd = new Date($('.Wdate').val());
    dd.setDate(dd.getDate() + AddDayCount);//获取AddDayCount天后的日期 
    var y = dd.getFullYear();
    var m = dd.getMonth() + 1;//获取当前月份的日期 
    var d = dd.getDate();
    return y + "-" + m + "-" + d;
}
// console.log(GetDateStr(1))
//function TimeCut(ispev) {
//    if ($('.ShowdatsElm').html() == '7+') {
//        $('.Wdate').val(GetDateStr(ispev * 7))
//    } else {
//        console.log($('.ShowdatsElm').html())
//        $('.Wdate').val(GetDateStr(ispev * $('.ShowdatsElm').html()))
//    }
//}
//$('.dateElm-pev').click(function () {
//    TimeCut(-1)
//    RContainerDays()
//})
//$('.dateElm-next').click(function () {
//    TimeCut(1)
//    RContainerDays()
//})


//Grid1_Container
//function RContainerDays() {
//    $.each($('.R-ContainerDays li'), function (i) {
//        $('.R-ContainerDays li').eq(i).children('.Days-1').children('.Day-1-text3').children('p').eq(0).html('MON ' + GetDateStr(i))
//    })
//}
// 约会
function EditAppoint() {
    if (objectId != "") {
        window.open("../ServiceDesk/AppointmentsManage.aspx?id=" + objectId, windowObj.appointment + windowType.edit, 'left=200,top=200,width=600,height=800', false);
    }
}

function DeleteAppoint() {
    if (objectId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DispatchAjax.ashx?act=DeleteAppointment&id=" + objectId,
        dataType:"json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            } else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
// 待办
function EditTodo() {
    if (objectId == "") {
        return;
    }
    window.open("../Activity/Todos.aspx?id=" + objectId, windowObj.todos + windowType.edit, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

function DeleteTodo() {
    if (objectId == "") {
        return;
    }
    LayerConfirm("删除后无法恢复，是否继续", "确定", "取消", function () {
        requestData("../Tools/ActivityAjax.ashx?act=Delete&id=" + objectId, null, function (data) {
            if (data == true) {
                LayerAlert("删除成功", "确定", function () {
                    window.location.reload();
                })
            }
            else {
                LayerMsg("删除失败");
            }
        })
    }, function () { })
}

function ShowContact() {

}

function DoneTodo() {
    if (objectId == "") {
        return;
    }
    requestData("../Tools/ActivityAjax.ashx?act=TodoComplete&id=" + objectId, null, function (data) {
        window.location.reload();
    })
}

function TodoShowAccount() {
    if (objectId == "") {
        return;
    }
    window.open('../Company/ViewCompany.aspx?src=com_activity&id=' + objectId, '_blank', 'left=200,top=200,width=1200,height=1000', false);
}

function ShowTodo() {

}
// 服务预定
function EditCall() {
    if (objectId == "") {
        return;
    }
    window.open("../ServiceDesk/ServiceCall?id=" + objectId, windowType.serviceCall + windowType.edit, 'left=200,top=200,width=1280,height=800', false);
}
function CallShowAccount() {
    if (objectId == "") {
        return;
    }
    var accountId = "";
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=GetCall&callId=" + objectId,
        dataType: "json",
        success: function (data) {
            if (data != "") {
                accountId = data.account_id;
            }
        },
    });
    if (accountId != "" && accountId != null && accountId != undefined) {
        window.open("../Company/ViewCompany.aspx?id=" + accountId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
    }
}
function DoneCall() {
    if (objectId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=DoneCall&callId=" + objectId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("完成成功！");
            }
            else {
                LayerMsg("完成失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}
function CopyCall() {
    if (objectId == "") {
        return;
    }
    window.open("../ServiceDesk/ServiceCall?copy=1&id=" + objectId, windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}
function DeleteCall() {
    if (objectId == "") {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/TicketAjax.ashx?act=DeleteCall&callId=" + objectId,
        dataType: "json",
        success: function (data) {
            if (data) {
                LayerMsg("删除成功！");
            }
            else {
                LayerMsg("删除失败！");
            }
            setTimeout(function () { history.go(0); }, 800);
        },
    });
}

function QuickAddCall() {
    window.open("../ServiceDesk/AddQuickCall", windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}
function AddCall() {
    window.open("../ServiceDesk/ServiceCall", windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
}
function AddAppiont() {
    var url = "../ServiceDesk/AppointmentsManage.aspx?a=1";
    if (objectDate != "" && objectDate != null && objectDate != undefined) {
        url += "&chooseDate=" + objectDate;
    } 
    window.open(url, windowObj.appointment + windowType.add, 'left=200,top=200,width=600,height=800', false);
}
function AddTodo() {
    window.open("../Activity/Todos.aspx", windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
}

