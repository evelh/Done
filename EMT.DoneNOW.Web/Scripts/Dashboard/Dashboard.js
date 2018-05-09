//配色标签
var ColorTheme = [
    ['#E41937', '#00457C', '#518AC9', '#E6D9C4', '#B4B4B4'],
    ['#85BDB2', '#518AC8', '#C36B66', '#E9B271', '#817479'],
    ['#586C7F', '#A2AF40', '#E3B000', '#D2483A', '#518AC8'],
    ['#18A2D6', '#D12189', '#37617F', '#C8CE3D', '#868A91'],
    ['#C11E39', '#D0D848', '#005859', '#AEAEAE', '#74A1D3'],
    ['#3C9654', '#E3B000', '#518AC9', '#673980', '#981B27'],
    ['#E51C38', '#43CDC5', '#586C7F', '#474747', '#96B8DE'],
    ['#673980', '#E1721E', '#3A747F', '#74A1D3', '#AE0E1E'],
]
//选中配色;
var SelectTheme;
var ThemeIdx;
//var ThemeArry = ['AutotaskTheme', 'CoastalTheme', 'CollegiateTheme', 'LivelyTheme', 'ModernTheme', 'PrismTheme', 'TechTheme', 'TrendTheme'];
//$('#ThemeList').change(function () {
//    for (var i = 0; i < ThemeArry.length; i++) {
//        if ($('#ThemeList').val() == ThemeArry[i]) {
//            $('.colors').css('background-position-x', i * 105);
//            var a = ThemeArry[i];
//            SelectTheme = ColorTheme[i];
//        }
//    }
//})
function RefreshDashboard() {
    var id = CurrentDashboardId();
    if (id == null)
        return;
    ShowLoading();
    setTimeout(function () {
        requestData("/Tools/DashboardAjax.ashx?act=GetDashboard&id=" + id, null, function (data) {
            if (data == null) {
                return;
            }
            InitDashboard(data);
        })
    }, 500)
}
function CurrentDashboardId() {
    var id = $(".panel_nav .panel_nav_now").data('dshdb');
    if (id == undefined)
        return null;
    return id;
}
function AddWidget(dom, wgt) {
    var str = '<div  data-size="' + wgt.width + '" id="widget' + wgt.widgetId + '" class="WidgetShell">';
    str += '<div class="LoadingWidget"></div>';
    str += '<div class="LittleBorder dad-draggable-area"></div>';
    str += '<div class="Draggable"></div>';
    str += '<div class="Content"></div>';
    str += '<div class="ContainerMenu"><span></span><span></span><span></span><ul class="MenuBox">';
    str += '<li title="删除" onclick="DeleteWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconDelete"></span><span class="WidgetMenuText">删除</span></li><li title="复制"><span class="WidgetMenuIcon WidgetMenuIconCopy"></span><span class="WidgetMenuText">复制</span></li>';
    str += '<li title="设置"><span class="WidgetMenuIcon WidgetMenuIconSetting"></span><span class="WidgetMenuText">设置</span></li><li title="移至其他仪表板"><span class="WidgetMenuIcon WidgetMenuIconMove"></span><span class="WidgetMenuText">移至其他仪表板</span></li>';
    str += '<li title="分享给其他用户"><span class="WidgetMenuIcon WidgetMenuIconApply"></span><span class="WidgetMenuText">分享给其他用户</span></li><li title="刷新" onclick="RefreshWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconRefresh"></span><span class="WidgetMenuText">刷新</span></li>';
    str += '</ul><div class="Menuborderline"></div></div>';
    //dom.appendChild(str);
    dom[0].innerHTML += str;
    RefreshWidget(wgt.widgetId);
}

function SwichDashboard(id) {
    var crtId = CurrentDashboardId();
    if (crtId == id) return;
    $.each($(".panel_nav_now").removeClass('panel_nav_now').addClass('panel_nav_no').siblings(), function () {
        if ($(this).data("dshdb") == id)
            $(this).addClass('panel_nav_now').removeClass('panel_nav_no');
    });
    $("#dshli" + crtId).hide();
    $("#dshli" + id).show();
    RefreshDashboard();
}

function AddDashboardList(list) {
    var dom = $('.panel_nav > .nav_heard');
    var str = '';
    var strCtn = '';
    var strList = '';
    if (list.length > 0) {
        str += '<div class="panel_nav_now" data-dshdb="' + list[0].val + '" >' + list[0].show + '</div>';
        strCtn += '<li style="display: block;" id="dshli' + list[0].val + '"></li>';
        for (var i = 0; i < list.length; i++) {
            strList += "<div class='Content'><a class='Button ButtonIcon NormalState HistoryClick' onclick='SwichDashboard(" + list[i].val + ")' ><span class='Text'>" + list[i].show + "</span></a></div>";
        }
        $("#DashboardList")[0].innerHTML = strList;
    }
    if (list.length > 1) {
        for (var i = 1; i < list.length; i++) {
            str += '<div class="panel_nav_no" data-dshdb="' + list[i].val + '">' + list[i].show + '</div>';
            strCtn += '<li id="dshli' + list[i].val + '"></li>';
        }
    }
    dom[0].innerHTML = str;
    $('.panel_nav .nav_heard').dad2()  
    $('.panel_content > ul')[0].innerHTML = strCtn;

    //$.each($('.panel_nav > ul > li'), function (i) {
    //    var _this = $('.panel_nav > ul > li').eq(i);
    //    _this.click(function () {
    //        if (i == $('.panel_nav > ul > li').length - 1) {
    //            // Addpanel()
    //        } else {
    //            $('.panel_nav > ul > li').eq(i).addClass('panel_nav_now').removeClass('panel_nav_no').siblings().removeClass('panel_nav_now').addClass('panel_nav_no')
    //            $('.panel_content > ul > li').eq(i).show().siblings().hide()
    //            $('#PresentTit').html($('.panel_nav > ul > li').eq(i).html())
    //        }
    //    })
    //})
}
function WidgetClick(id, val1, val2) {
    ShowLoading();
    window.open("/Common/SearchBodyFrame?widgetDrill=1&id=" + id + "&val1=" + val1 + "&val2=" + val2, "PageFrame", "", true);
}
function ChangeWidgetPosition(change) {
    requestData("/Tools/DashboardAjax.ashx?act=ChangeWidgetPosition&change=" + change + "&id=" + CurrentDashboardId(), null, function (data) {
        if (data != true) {
            RefreshDashboard();
        }
    })
}
function SettingDashboard() {
    $('.loading').hide();
    $('#cover').hide();
    //InitDashboard();
}
function InitDashboard(data) {
    ThemeIdx = data.theme_id;
    SelectTheme = ColorTheme[ThemeIdx];
    $("#dshli" + data.id)[0].innerHTML = '';
    for (var i = 0; i < data.widgetList.length; i++) {
        AddWidget($("#dshli" + data.id), data.widgetList[i]);
    }
    $(".panel_nav_now").unbind("click");
    $(".panel_nav_no").unbind("click").click(function () {
        $('.panel_nav .nav_heard').dad2()
        var id = $(this).data('dshdb');
        if (id == undefined)
            return;

        ShowLoading();
        var dom = $(this);
        //$('#PresentTit').html($('.panel_nav > ul > li').eq(i).html())
        setTimeout(function () {
            requestData("/Tools/DashboardAjax.ashx?act=GetDashboard&id=" + id, null, function (data) {
                if (data == null) {
                    return;
                }
                dom.addClass('panel_nav_now').removeClass('panel_nav_no').siblings().removeClass('panel_nav_now').addClass('panel_nav_no')
                $("#dshli" + id).show().siblings().hide();
                InitDashboard(data);
            })
        }, 500)
    });

    // 最低高度 宽度
    $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 20)
    $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 20)
    // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    $(window).resize(function () {
        $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 20)
        $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 20)
        // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    })

    var dom = $("#dshli" + data.id).children('.WidgetShell');
    var screenW = window.screen.width - 20 - 17;  //去掉padding值     滚动条
    $.each(dom, function (i) {
        var size = dom.eq(i).data('size');
        $('.panel_content > ul > li').eq(i).css('min-width', (screenW / 8) * 2)    //最小宽度为两格
        if (data.auto_place == 0) {
            $('.panel_content > ul > li').eq(i).css('max-width', (screenW / 8) * 4)
        }
        dom.eq(i).css('width', (screenW / 8) * size - 14)
    })
    //判断数量，是否有添加按钮
    if (dom.length < 12) {
        var addShell = '<div onclick="AddWidgetStep0()" class="WidgetShell addShell" style="width:200px;"><div class="addWidget"><span></span> <span></span>  添加</div></div>';
        $("#dshli" + data.id).append(addShell)
        $('.addShell').css('width', screenW / 8 - 14)
    }

    $.each($('.panel_content > ul > li'), function (i) {
        $('.panel_content > ul > li').eq(i).dad({
            draggable: '.Draggable',
            callbackmethod: ChangeWidgetPosition
        });
    })

    HideLoading();
}
$(function () {
    ShowLoading();
    setTimeout(function () {
        requestData("/Tools/DashboardAjax.ashx?act=GetInitailDashboard", null, function (data) {
            if (data == null) {
                HideLoading();
                return;
            }
            AddDashboardList(data[0]);
            InitDashboard(data[1]);
        })
    }, 500)
});
$(function () {
    var hidden, state, visibilityChange, time;
    if (typeof document.hidden !== "undefined") {
        hidden = "hidden";
        visibilityChange = "visibilitychange";
        state = "visibilityState";
    } else if (typeof document.mozHidden !== "undefined") {
        hidden = "mozHidden";
        visibilityChange = "mozvisibilitychange";
        state = "mozVisibilityState";
    } else if (typeof document.msHidden !== "undefined") {
        hidden = "msHidden";
        visibilityChange = "msvisibilitychange";
        state = "msVisibilityState";
    } else if (typeof document.webkitHidden !== "undefined") {
        hidden = "webkitHidden";
        visibilityChange = "webkitvisibilitychange";
        state = "webkitVisibilityState";
    }
    
    document.addEventListener(visibilityChange, function () {
        if (document[state] == "hidden") {
            time = new Date().getTime();
        } else if (document[state] == "visible") {
            var sc = new Date().getTime() - time;
            if (sc > 300000) {
                RefreshDashboard();
            }
        }
        //document.title = document[state];
    }, false);
})
function AddDashboard() {

}

function ManageDashboard() {

}


//POP  toogle方法
function Toogle(dom) {
    $(dom).parent().siblings().toggle()
    if ($(dom).children().eq(0).css('display') == 'none') {
        $(dom).children().eq(0).show()
        $(dom).parent().parent().css('background', '#F2F2F2')
    } else {
        $(dom).children().eq(0).hide()
        $(dom).parent().parent().css('background', '')
    }
}

//POP  close方法
function POPClose(dom) {
    $(dom).parent().hide()
    $('#cover').hide()
}

//POP 打开
function POPOpen(dom) {
    var pop = $(dom).attr('data-pop');
    $('#cover').show();
    if (pop == 'AddWidgetRemind') {
        $.each($('.panel_content > ul > li'), function (i) {
            if ($('.panel_content > ul > li').eq(i).is(':visible')) {
                console.log($('.panel_content > ul > li').eq(i).children('.WidgetShell').length)
                if ($('.panel_content > ul > li').eq(i).children('.WidgetShell').length < 12) {
                    AddWidgetStep0();
                } else {
                    $('#' + pop).show()
                }
            }
        })
    } else {
        $('#' + pop).show()
    }

}
