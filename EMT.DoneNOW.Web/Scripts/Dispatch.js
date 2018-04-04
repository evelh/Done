$('.Grid1_Container').css('height', $(window).height() - $('.Grid1_Container').offset().top - 50)
$('.Grid2_Container .ContainerBottom').css('height', $(window).height() - $('.Grid2_Container .ContainerBottom').offset().top - 50)
$(window).resize(function () {
    $('.Grid1_Container').css('height', $(window).height() - $('.Grid1_Container').offset().top - 50)
    $('.Grid2_Container .ContainerBottom').css('height', $(window).height() - $('.Grid2_Container .ContainerBottom').offset().top - 50)
})
//高度
$.each($('.R-ContainerUser'), function (i) {
    var _this = $('.R-ContainerUser').eq(i).children('li');

    $.each(_this, function (j) {
        var x = $(_this).eq(0).children('.UserContainer').height();
        if ($(_this).eq(j).children('.UserContainer').height() > x) {
            x = $(_this).eq(j).children('.UserContainer').height();
        }
        $(_this).eq(j).children('.UserContainer').css('height', x)
        $('.ContainerUser li').eq(i).children('.icon').css('height', x + 2)
        //右击
        $(_this).eq(j).children('.UserContainer').children(".hovertask").bind("contextmenu", ShowContextAppMenu)
        $(_this).eq(j).children('.UserContainer').bind("contextmenu", ShowContextMenu);


    })
})
function ShowContextMenu(e) {
    var menu = document.getElementById("menu");
    if ($(this).hasClass("hoverAppoint")) {
        menu = document.getElementById("AppiontMenu");
    }
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
}
var appiontId="";
function ShowContextAppMenu(e) {
    var menu = document.getElementById("menu");
    if ($(this).hasClass("hoverAppoint")) {
        menu = document.getElementById("AppiontMenu");
    }
    $(this).parent().unbind();
    appiontId = $(this).data("val");
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
            RunDaysDom($('.daysElm ul li').eq(i).html())
        }, 1000)
    })
})

function RunDaysDom(a) {
    if (a == 1) {
        $('.Grid1_Container').hide()
        $('.Grid2_Container').show()
        $('.ContainerTop-Two').css('width', $('.ContainerTop-Two').width() - 18)

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
            showBox.html(domList.eq(i).html())
            showBox.css({
                'left': e.clientX + 10,
                'top': e.clientY + 10,
            })
            showBox.show()
        })
        domList.eq(i).mousemove(function (e) {
            showBox.eq(i).html(domList.eq(i).html())
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


function drag(obj) {
    obj.bind('mousedown', start);
    var ol = obj.offset().left;
    var ot = obj.offset().top;
    function start(e) {
        // deltaX = e.pageX - ol;
        // deltaY = e.pageY - ot;
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
                    if ($('.UserContainer').eq(i).find('div').length == 0) {
                        $('.UserContainer').eq(i).css('background', '#FFF8DC')
                        localStorage.setItem('MoveD', i)
                    }
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
        obj.css({ 'left': 0, 'top': 0, 'border': 'none', 'background': 'none' })
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
            // ...  $('.UserContainer').eq(localStorage.getItem('MoveD'))
        })
    }
}

//drag($('.stockstask'))



// Loading

var a = false;
$('.loading').css('height', $(window).height())
function Loading() {
    $('.loading').show()
    setTimeout(function () { a = true; $('.loading').hide() }, 1000)
}
Loading()

//timework

var date = new Date();
$('.Wdate').val(date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate())
function GetDateStr(AddDayCount) {
    var dd = new Date($('.Wdate').val());
    dd.setDate(dd.getDate() + AddDayCount);//获取AddDayCount天后的日期 
    var y = dd.getFullYear();
    var m = dd.getMonth() + 1;//获取当前月份的日期 
    var d = dd.getDate();
    return y + "-" + m + "-" + d;
}
// console.log(GetDateStr(1))
function TimeCut(ispev) {
    if ($('.ShowdatsElm').html() == '7+') {
        $('.Wdate').val(GetDateStr(ispev * 7))
    } else {
        console.log($('.ShowdatsElm').html())
        $('.Wdate').val(GetDateStr(ispev * $('.ShowdatsElm').html()))
    }
}
$('.dateElm-pev').click(function () {
    TimeCut(-1)
    RContainerDays()
})
$('.dateElm-next').click(function () {
    TimeCut(1)
    RContainerDays()
})


//Grid1_Container
function RContainerDays() {
    $.each($('.R-ContainerDays li'), function (i) {
        $('.R-ContainerDays li').eq(i).children('.Days-1').children('.Day-1-text3').children('p').eq(0).html('MON ' + GetDateStr(i))
    })
}

function EditAppoint() {
    if (appiontId != "") {
        window.open("../ServiceDesk/AppointmentsManage.aspx?id=" + appiontId, windowObj.appointment + windowType.edit, 'left=200,top=200,width=600,height=800', false);
    }
}

function DeleteAppoint() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/DispatchAjax.ashx?act=DeleteAppointment&id=" + appiontId,
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

