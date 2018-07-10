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
var ThemeArry;
//var ThemeArry = ['AutotaskTheme', 'CoastalTheme', 'CollegiateTheme', 'LivelyTheme', 'ModernTheme', 'PrismTheme', 'TechTheme', 'TrendTheme'];
$('#dashboardTheme').change(function () {
    for (var i = 0; i < ThemeArry.length; i++) {
        if ($('#dashboardTheme').val() == ThemeArry[i].val) {
            $('.colors').css('background-position-x', i * 105);
            //var a = ThemeArry[i];
            //SelectTheme = ColorTheme[i];
        }
    }
})
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
function AddWidget(dom, wgt, share) {
    var str = '<div  data-size="' + wgt.width + '" id="widget' + wgt.widgetId + '" class="WidgetShell">';
    str += '<div class="LoadingWidget"></div>';
    str += '<div class="LittleBorder dad-draggable-area"></div>';
    str += '<div class="Draggable"></div>';
    str += '<div class="Content"></div>';
    str += '<div class="ContainerMenu"><span></span><span></span><span></span><ul class="MenuBox">';
    if (share == 1 && dashboardContainer == null) {
        str += '<li title="刷新" onclick="RefreshWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconRefresh"></span><span class="WidgetMenuText">刷新</span></li>';
    } else {
        str += '<li title="删除" onclick="DeleteWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconDelete"></span><span class="WidgetMenuText">删除</span></li><li title="复制" onclick="CopyWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconCopy"></span><span class="WidgetMenuText">复制</span></li>';
        str += '<li title="设置" onclick="SettingWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconSetting"></span><span class="WidgetMenuText">设置</span></li><li title="移至其他仪表板" onclick="MoveWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconMove"></span><span class="WidgetMenuText">移至其他仪表板</span></li>';
        str += '<li title="分享给其他用户" onclick="ShareWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconApply"></span><span class="WidgetMenuText">分享给其他用户</span></li><li title="刷新" onclick="RefreshWidget(' + wgt.widgetId + ')"><span class="WidgetMenuIcon WidgetMenuIconRefresh"></span><span class="WidgetMenuText">刷新</span></li>';
    }
    str += '</ul><div class="Menuborderline"></div></div>';
    //dom.appendChild(str);
    dom[0].innerHTML += str;
    RefreshWidget(wgt.widgetId);
}

function SwichDashboard(id) {
    if (dashboardContainer != null) {
        BackDashboardContainer();
    }
    $(".cont").hide();
    $("#yibiaopan").show();

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
var dashboardList;
function AddDashboardList(list) {
    dashboardList = list;
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

function InitDashboard(data) {
    ThemeIdx = data.theme_id;
    SelectTheme = ColorTheme[ThemeIdx];
    $("#dshli" + data.id)[0].innerHTML = '';
    for (var i = 0; i < data.widgetList.length; i++) {
        AddWidget($("#dshli" + data.id), data.widgetList[i], data.is_shared);
    }
    if (dashboardContainer == null) {
        if (data.is_shared) {
            $("#dashboardSettingLi").hide();
            $("#dashboardAddWgtLi").hide();
            $("#dashboardShareLi").hide();
        } else {
            $("#dashboardSettingLi").show();
            $("#dashboardAddWgtLi").show();
            $("#dashboardShareLi").show();
        }
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
    if (dom.length < 12 && (data.is_shared == 0 || dashboardContainer != null)) {
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
    RefreshAllDashboard();

    // 最低高度 宽度
    $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
    $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
    // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    $(window).resize(function () {
        $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
        $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
        // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    })
});
function RefreshAllDashboard() {
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
    }, 100)
}
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
            if (sc > 1800000) {
                RefreshDashboard();
            }
        }
        //document.title = document[state];
    }, false);
})
function AddDashboard() {
    $("#cover").show();
    var allDshList;
    requestData("/Tools/DashboardAjax.ashx?act=GetDashboardList", null, function (data) {
        allDshList = data;
        var str = '';
        for (var i = 0; i < data[0].length; i++) {
            str += '<option value="' + data[0][i].val + '">' + data[0][i].show + '</option>';
        }
        $("#addDashboardSelectExist")[0].innerHTML = str;
        str = '';
        for (var i = 0; i < data[1].length; i++) {
            str += '<option value="' + data[1][i].val + '">' + data[1][i].show + '</option>';
        }
        $("#addDashboardSelectDefault")[0].innerHTML = str;
        str = '';
        for (var i = 0; i < data[2].length; i++) {
            str += '<option value="' + data[2][i].val + '">' + data[2][i].show + '</option>';
        }
        $("#addDashboardSelectClosed")[0].innerHTML = str;
        $("#AddDashboard").show();

        $(".AddDashboardNext").unbind("click").bind("click", function () {
            var seltype = $("input:radio[name='addDashboardType']:checked").val();
            $("#AddDashboard").hide();
            if (seltype == 1) {
                InitDashboardInfo(null, 0);
            } else if (seltype == 2) {
                requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + $("#addDashboardSelectExist").val(), null, function (data) {
                    InitDashboardInfo(data, 1);
                })
            } else if (seltype == 3) {
                requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + $("#addDashboardSelectDefault").val(), null, function (data) {
                    InitDashboardInfo(data, 1);
                })
            } else if (seltype == 4) {
                var selval = $("#addDashboardSelectClosed").val();
                for (var i = 0; i < allDshList[2].length; i++) {
                    if (allDshList[2][i].val != selval) continue;
                    if (allDshList[2][i].share == 1) {
                        requestData("/Tools/DashboardAjax.ashx?act=AddClosedDashboard&id=" + $("#addDashboardSelectClosed").val(), null, function (data) {
                            RefreshAllDashboard();
                            $("#cover").hide();
                        })
                    } else {
                        requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + $("#addDashboardSelectClosed").val(), null, function (data) {
                            InitDashboardInfo(data, 2);
                        })
                    }
                }
            }
        })
    })
}

function ShareDashboard() {
    $("#cover").show();
    $("#ShareTabStep1").show();
}
function ShareDashboardSelect() {
    var isnew = '';
    if ($("input:radio[name='shareTabType']:checked").val() == '1') { isnew = '&isnew=1'; }
    LayerLoad();
    requestData("/Tools/DashboardAjax.ashx?act=ShareTab&id=" + CurrentDashboardId() + isnew, null, function (data) {
        LayerLoadClose();
        if (data == 0) {
            RefreshAllDashboard();
        } else {
            $("#ShareTabStep1").hide();
            $("#ShareTabStep2").show();
            $("#SettingShareTab").unbind("click").bind("click", function () {
                $("#cover").show();
                $("#ShareTabStep2").hide();
                requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + data, null, function (data) {
                    InitDashboardInfo(data, 0);
                })
            })
            $("#ShareShareTab").unbind("click").bind("click", function () {
                setTimeout(function () {
                    $(".cont").show();
                }, 300);
                setTimeout(function () {
                    $("#yibiaopan").hide();
                }, 100);
                window.open("/System/ShareDashboard?id=" + data, windowObj.shareDashboard, 'left=0,top=0,location=no,status=no,width=910,height=920', false);
            })
        }
    })
}

var dashboardFilters;
function SettingDashboard() {
    if (CurrentDashboardId() == 0) return;
    $("#cover").show();
    requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + CurrentDashboardId(), null, function (data) {
        InitDashboardInfo(data, 0);
    })
}
function AddSharedDashboard() {
    $("#cover").show();
    InitDashboardInfo(null, 3);
}
function CopySharedDashboard(id) {
    $("#cover").show();
    requestData("/Tools/DashboardAjax.ashx?act=DashboardSettingInfo&id=" + id, null, function (data) {
        InitDashboardInfo(data, 4);
    })
}
var dashboardContainer = null;
function EditSharedDashboard(id) {
    setTimeout(function () {
        $(".cont").hide();
        $("#SearchTitle").hide();
    }, 300);
    setTimeout(function () {
        $("#yibiaopan").show();
    }, 100);
    if (dashboardContainer == null)
        dashboardContainer = $("#DashboardContainer").remove();
    $("#SharedDashboardEdit")[0].innerHTML = '<div class="panel_nav"><div class="nav_heard"></div><div style="background-color: inherit;color: #fff;margin-left: 64px;text-decoration: underline;padding-top: 4px;"><span style="cursor: pointer;" onclick="BackDashboardContainer()">返回仪表板</span><span style="cursor: pointer;margin-left:12px;" onclick="BackSharedManage()">返回共享仪表板管理</span></div>'
        + '<div class="settings"><span></span><span></span><span></span><ul class="settingsBox"><li title="仪表板设置" onclick="SettingDashboard()"><span class="Icon" style="float:left;display: block;width: 16px;height: 16px; background:url(Images/ButtonIcons.svg) no-repeat scroll;background-position: -288px -32px;margin-top: 2px;"></span>'
        + '<span class="Text" style="float: left;display: block;padding-left:8px; ">仪表板设置</span></li><li title="添加小窗口" onclick="AddWidgetStep0()"><span class="Icon" style="float:left;display: block;width: 16px;height: 16px; background:url(Images/ButtonIcons.svg) no-repeat scroll;background-position: -80px 0;margin-top: 2px;"></span>'
        + '<span class="Text" style="float: left;display: block;padding-left:8px; ">添加小窗口</span></li></ul></div></div><div class="panel_content"><ul></ul></div>';

    // 最低高度 宽度
    $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
    $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
    // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    $(window).resize(function () {
        $('.panel_content > ul').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
        $('.panel_content > ul >li').css('min-height', $(window).height() - $('.panel_nav').height() - 80)
        // $('.panel_nav .nav_heard').css('min-width',$('.panel_nav .nav_heard').width())
    })

    $("#SharedDashboardEdit").show();

    requestData("/Tools/DashboardAjax.ashx?act=GetDashboard&id=" + id, null, function (data) {
        var dom = $('.panel_nav > .nav_heard');
        var str = '';
        var strCtn = '';
        
        str += '<div class="panel_nav_now" data-dshdb="' + data.id + '" >' + data.name + '</div>';
        strCtn += '<li style="display: block;" id="dshli' + data.id + '"></li>';
        
        dom[0].innerHTML = str;
        $('.panel_nav .nav_heard').dad2()
        $('.panel_content > ul')[0].innerHTML = strCtn;

        InitDashboard(data);
    })
}
function BackSharedManage() {
    if (dashboardContainer == null) window.location.reload();
    $("#SharedDashboardEdit").empty();
    $("#yibiaopan").append(dashboardContainer);
    dashboardContainer = null;
    $("#SharedDashboardEdit").hide();
    $("#PageFrame").attr("src", "/Common/SearchFrameSet.aspx?cat=1718");
    $(".cont").show();
    $("#yibiaopan").hide();

    // 重新添加事件
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
}
function BackDashboardContainer() {
    if (dashboardContainer != null) {
        $("#yibiaopan").append(dashboardContainer);
        dashboardContainer = null;
        $("#SharedDashboardEdit").empty();
        $("#SharedDashboardEdit").hide();

        $(".cont").hide();
        $("#yibiaopan").show();

        // 重新添加事件
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
    }
}
function InitDashboardInfo(data, opType) {
    $("#dashboardIsCopy").val(opType);
    $(".SettingsPOP").find(".delete").hide();
    if (data != null) {
        if (opType == 0) {
            $(".SettingsPOP").find(".delete").show();
        }
        $("#dashboardName").val(data.name);
        $("#dashboardId").val(data.id);
        if (data.widget_auto_place == 1)
            $("#dashboardAutoPlace").prop("checked", true);
        else
            $("#dashboardAutoPlace").prop("checked", false);
        if (ThemeArry == null) {
            requestData("/Tools/DashboardAjax.ashx?act=GetColorThemeList", null, function (dataTheme) {
                ThemeArry = dataTheme;
                var str = "";
                for (var i = 0; i < dataTheme.length; i++) {
                    str += '<option value="' + dataTheme[i].val + '">' + dataTheme[i].show + '</option>';
                }
                $("#dashboardTheme")[0].innerHTML = str;
                $("#dashboardTheme").val(data.theme_id);
                for (var i = 0; i < ThemeArry.length; i++) {
                    if ($('#dashboardTheme').val() == ThemeArry[i].val) {
                        $('.colors').css('background-position-x', i * 105);
                    }
                }
            })
        } else {
            $("#dashboardTheme").val(data.theme_id);
            for (var i = 0; i < ThemeArry.length; i++) {
                if ($('#dashboardTheme').val() == ThemeArry[i].val) {
                    $('.colors').css('background-position-x', i * 105);
                }
            }
        }
        if (dashboardFilters == null) {
            requestData("/Tools/DashboardAjax.ashx?act=GetDashboardFilter", null, function (dataFlt) {
                dashboardFilters = dataFlt;
                var str = '<option value=""></option>';
                for (var i = 0; i < dataFlt.length; i++) {
                    str += '<option value="' + dataFlt[i].id + '">' + dataFlt[i].description + '</option>';
                }
                $("#dashboardFilter")[0].innerHTML = str;
                if (data.filter_id == null)
                    $("#dashboardFilter").val("");
                else
                    $("#dashboardFilter").val(data.filter_id);

                $("#dashboardFilter").unbind("change").bind("change", function () {
                    dsbdFilterChange();
                })
                dsbdFilterChange();
            })
        } else {
            if (data.filter_id == null)
                $("#dashboardFilter").val("");
            else
                $("#dashboardFilter").val(data.filter_id);
            dsbdFilterChange();
        }
    } else {
        $("#dashboardId").val(0);
        $("#dashboardName").val("");
        $("#dashboardAutoPlace").prop("checked", true);
        if (ThemeArry == null) {
            requestData("/Tools/DashboardAjax.ashx?act=GetColorThemeList", null, function (dataTheme) {
                ThemeArry = dataTheme;
                var str = "";
                for (var i = 0; i < dataTheme.length; i++) {
                    str += '<option value="' + dataTheme[i].val + '">' + dataTheme[i].show + '</option>';
                }
                $("#dashboardTheme")[0].innerHTML = str;
                $('.colors').css('background-position-x', 0);
            })
        }
        if (dashboardFilters == null) {
            requestData("/Tools/DashboardAjax.ashx?act=GetDashboardFilter", null, function (dataFlt) {
                dashboardFilters = dataFlt;
                var str = '<option value=""></option>';
                for (var i = 0; i < dataFlt.length; i++) {
                    str += '<option value="' + dataFlt[i].id + '">' + dataFlt[i].description + '</option>';
                }
                $("#dashboardFilter")[0].innerHTML = str;

                $("#dashboardFilter").unbind("change").bind("change", function () {
                    dsbdFilterChange();
                })
                dsbdFilterChange();
            })
        } else {
            $("#dashboardFilter").val("");
            dsbdFilterChange();
        }
    }

    $("#settings").show();


    function dsbdFilterChange() {
        var fltVal = $("#dashboardFilter").val();
        if (fltVal == "") {
            $("#dashboardDftValDiv").hide();
            $("#dashboardMuiltFilter2").hide();
            $("#dashboardMuiltFilter1").hide();
            if ($("#dashboardLimitType2").prop("checked")) {
                $("#dashboardLimitType1").prop("checked", true);
                $("#dashboardLimitType2").prop("checked", false);
            }
            $("#dashboardLimitType2").attr("disabled", "disabled");
            return;
        }
        if (fltVal == 3975 || fltVal == 3978 || fltVal == 3980 || fltVal == 3981 || fltVal == 3982) {
            $("#dashboardLimitType2").removeAttr("disabled");
        } else {
            if ($("#dashboardLimitType2").prop("checked")) {
                $("#dashboardLimitType1").prop("checked", true);
                $("#dashboardLimitType2").prop("checked", false);
            }
            $("#dashboardLimitType2").attr("disabled", "disabled");
        }
        $("#dashboardDftValDiv").show();
        for (var i = 0; i < dashboardFilters.length; i++) {
            if (dashboardFilters[i].id != fltVal) continue;
            if (dashboardFilters[i].data_type == 809) {
                var str = '<option value=""></option>';
                for (var j = 0; j < dashboardFilters[i].values.length; j++) {
                    str += '<option value="' + dashboardFilters[i].values[j].val + '">' + dashboardFilters[i].values[j].show + '</option>';
                }
                $("#dashboardDftValDiv")[0].innerHTML = '<p>默认值<span style="color: red;">*</span></p><select id="dashboardSingleFilterHidden"></select>';
                $("#dashboardSingleFilterHidden")[0].innerHTML = str;
                str = '';
                for (var j = 0; j < dashboardFilters[i].values.length; j++) {
                    str += '<option value="' + dashboardFilters[i].values[j].val + '">' + dashboardFilters[i].values[j].show + '</option>';
                }
                $("#dmultiselect").empty();
                $("#dmultiselect")[0].innerHTML = str;
                $('#dmultiselect').multiselect({
                    sort: false
                });
                $("#dmultiselect_to").empty();
                $("#dashboardMuiltFilter1").show();
                $("#dashboardMuiltFilter2").hide();
            } else {
                $("#dashboardDftValDiv")[0].innerHTML = '<p>默认值<span style="color: red;">*</span></p><input type="text" id="dashboardSingleFilter" disabled="disabled" style="float:left;" /><input type="hidden" id="dashboardSingleFilterHidden" /><i class="icon-dh" onclick="window.open(\'' + dashboardFilters[i].ref_url +'dashboardSingleFilter\', \'_blank\', \'left= 200, top = 200, width = 600, height = 800\', false)" style="height:16px;margin-top:3px;margin-left:3px;float:left;"></i>';
                $("#dashboardMuiltFilter1").hide();
                $("#dashboardMuiltFilter2").show();
                $("#dashboardMuiltFilter").val("");
                $("#dashboardMuiltFilterHidden").val("");
                $("#dashboardMuiltFilterClick").unbind("click").bind("click", function () {
                    window.open(dashboardFilters[i].ref_url +'dashboardMuiltFilter&muilt=1', '_blank', 'left= 200, top = 200, width = 600, height = 800', false);
                })
            }
            break;
        }
    }
}
function ChangeDashboardLimit(idx) {
    if ($("#dashboardFilter").val() == "") return;
    for (var i = 0; i < dashboardFilters.length; i++) {
        if (dashboardFilters[i].id != $("#dashboardFilter").val()) continue;
        if (dashboardFilters[i].data_type == 809) {
            if (idx == 2522) {
                $("#dashboardMuiltFilter1").show();
            } else {
                $("#dashboardMuiltFilter1").hide();
            }
        } else {
            if (idx == 2522) {
                $("#dashboardMuiltFilter2").show();
            } else {
                $("#dashboardMuiltFilter2").hide();
            }
        }
    }
}
function SaveDashboard() {
    if ($("#dashboardName").val() == "") {
        LayerMsg("请输入仪表板名称");
        $("#settings").hide();
        $("#cover").hide();
        return;
    }
    var fltVal = $("#dashboardFilter").val();
    var fltStr = "";
    if (fltVal != "") {
        if ($("#dashboardSingleFilterHidden").val() == "") {
            LayerMsg("请过滤条件默认值");
            $("#settings").hide();
            $("#cover").hide();
            return;
        }
        fltStr += "&filter_id=" + fltVal + "&default=" + $("#dashboardSingleFilterHidden").val() + "&limit_type=" + $('input:radio[name="dashboardLimitType"]:checked').val() + "&limit_value=";
        for (var i = 0; i < dashboardFilters.length; i++) {
            if (dashboardFilters[i].id != fltVal) continue;
            if (dashboardFilters[i].data_type == 809) {
                var ids = "";
                $("#dmultiselect_to option").each(function () {
                    ids += $(this).val() + ',';
                });
                ids = ids.substr(0, ids.length - 1);
                fltStr += ids;
            } else {
                fltStr += $("#dashboardMuiltFilterHidden").val();
            }
        }
    }
    LayerLoad();
    requestData("/Tools/DashboardAjax.ashx?act=SaveDashboard&id=" + $("#dashboardId").val() + "&type=" + $("#dashboardIsCopy").val() + "&name=" + $("#dashboardName").val() + "&widget_auto_place=" + ($("#dashboardAutoPlace").prop("checked") ? 1 : 0) + "&theme_id=" + $('#dashboardTheme').val() + fltStr, null, function (data) {
        $("#settings").hide();
        $("#cover").hide();
        if ($("#dashboardIsCopy").val() == 3 || $("#dashboardIsCopy").val() == 4) {
            LayerLoadClose();
            var formbody = window.frames["PageFrame"].frames["SearchBody"].contentWindow;
            if (formbody == undefined)
                formbody = window.frames["PageFrame"].frames["SearchBody"].document;
            else
                formbody = formbody.document;
            formbody.location.reload();
        } else if ($("#dashboardId").val() == 0 || $("#dashboardIsCopy").val() != 0) {
            RefreshAllDashboard();
        } else {
            RefreshDashboard();
        }
    })
}
function DleteDashboard() {
    LayerConfirmOk("删除操作将不能恢复，是否继续?", "确定", "取消", function () {
        requestData("/Tools/DashboardAjax.ashx?act=DeleteDashboard&id=" + id, null, function (data) {
            RefreshAllDashboard();
        })
    })
}
function CloseDashboard() {
    ShowLoading();
    $('#cover').hide();
    $("#CloseTable").hide();
    requestData("/Tools/DashboardAjax.ashx?act=CloseDashboard&id=" + CurrentDashboardId(), null, function (data) {
        RefreshAllDashboard();
    })
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


//全屏模式
var PowerTime;      //演示定时器
var PowerIndex = 0;   //演示面板初始值
(function ($) {
    $.support.fullscreen = supportFullScreen();
    $.fn.fullScreen = function (props) {

        if (!$.support.fullscreen || this.length != 1) {
            return this;
        }

        if (fullScreenStatus()) {
            cancelFullScreen();
            return this;
        }


        var options = $.extend({
            'background': '#111',
            'callback': function () { }
        }, props);


        var fs = $('<div>', {
            'css': {
                'overflow-y': 'auto',
                'width': '100%',
                'height': '100%',
                'align': 'center'
            }
        });

        var elem = this;

        elem.addClass('fullScreen');

        fs.insertBefore(elem);
        fs.append(elem);
        requestFullScreen(fs.get(0));

        fs.click(function (e) {
            if (e.target == this) {
                cancelFullScreen();
            }
        });

        elem.cancel = function () {
            cancelFullScreen();
            return elem;
        };

        onFullScreenEvent(function (fullScreen) {

            if (!fullScreen) {
                elem.removeClass('fullScreen').insertBefore(fs);
                fs.remove();
                clearInterval(PowerTime)     //停止定时器
                $('.ModeTitle').hide()
                $('.panel_content > ul').css('padding-bottom', 0);
                $('.panel_content > ul').css('overflow', '');
                $('.panel_content > ul').css('background', '#fff');
                $('.panel_content > ul').css('height', 'auto');
                $('.panel_content').css({
                    'overflow-y': 'scroll',
                    'padding': 10,
                    'height': 'auto'
                })
                $('.addShell').css('background', '#fff')
            }
            options.callback(fullScreen);
        });

        return elem;
    };
    function supportFullScreen() {
        var doc = document.documentElement;

        return ('requestFullscreen' in doc) ||
            ('mozRequestFullScreen' in doc && document.mozFullScreenEnabled) ||
            ('webkitRequestFullScreen' in doc);
    }

    function requestFullScreen(elem) {
        if (elem.requestFullscreen) {
            elem.requestFullscreen();
        } else if (elem.mozRequestFullScreen) {
            elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullScreen) {
            elem.webkitRequestFullScreen();
        }
    }

    function fullScreenStatus() {
        return document.fullscreen ||
            document.mozFullScreen ||
            document.webkitIsFullScreen;
    }

    function cancelFullScreen() {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        }

    }

    function onFullScreenEvent(callback) {
        $(document).on("fullscreenchange mozfullscreenchange webkitfullscreenchange", function () {
            callback(fullScreenStatus());
        });
    }

    $('.PresentationModeCancelButton').click(function () {
        cancelFullScreen()
    })
})(jQuery);
//进入演示

$(function () {

    $("#EnterPresentationMode").click(function () {
        var type = $("input:radio[name='dashPresent']:checked").val();
        var filter = 0;
        var tab = 0;
        if (type == 1 || type == 3)
            filter = 1;
        if (type == 2 || type == 3)
            tab = 1;
        PowerTime = setInterval(function () {
            $('.panel_content > ul > li').eq(PowerIndex).fadeIn().siblings().fadeOut();
            $('.ModeTitle #PresentTit').html($('.panel_nav > ul > li').eq(PowerIndex).html())     //动态的标题
            $('.panel_nav > ul > li').eq(PowerIndex).addClass('panel_nav_now').siblings().removeClass('panel_nav_now')
            PowerIndex++;
            if (PowerIndex == $('.panel_content > ul > li').length) {
                PowerIndex = 0;
            }
        }, 60000);
        $('#PresentationMode').hide()
        $('#cover').hide()
        $('.ModeTitle').show()
        $('.panel_content > ul').css('background', '#E3E3E3');
        $('.panel_content > ul').css('height', $(window).height());
        $('.panel_content > ul').css('padding-bottom', 15);
        $('.panel_content > ul').css('overflow-y', 'auto');
        $('.panel_content').css({
            'overflow-y': 'hidden',
            'padding': 0,
            'height': '100%'
        })
        $('.panel_content').fullScreen();
        $('.addShell').css('background', '#E3E3E3')
    })

});



//找到当前打开的面板 
$.each($('.panel_content > ul > li'), function (i) {
    // console.log($('.panel_content > ul > li').eq(i).is(':visible'))
    if ($('.panel_content > ul > li').eq(i).is(':visible')) {
        PowerIndex = i;
    }
})

// 仪表板过滤器
var crtDashboardFilter;
var crtDashboardFilters;