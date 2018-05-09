
(function ($) {
    "use strict";

    function O_dad() {
        var self = this;
        this.x = 0;
        this.y = 0;
        this.target = false;
        this.clone = false;
        this.placeholder = false;
        this.cloneoffset = {
            x: 0,
            y: 0
        };
        this.move = function (e) {
            e.preventDefault()
            self.x = e.pageX;
            self.y = e.pageY;
            if (self.clone != false && self.target != false) {
                
                //if(self.y- self.cloneoffset.y+36>=self.target.parent().height()-26){
                //    self.clone.css({
                //        top: self.target.parent().height()-26,
                //    })
                //}else
                //if(self.y- self.cloneoffset.y+36<=36){
                //    self.clone.css({
                //        top: 36,
                //    })
                //}else{
                //    self.clone.css({
                //        top: self.y- self.cloneoffset.y+36,
                //    })
                //}
                ////console.log(self.clone.css('top'))
                self.clone.css({
                    top: self.y - self.cloneoffset.y ,
                })
            } else {}
        };
        $(window).on('mousemove', function (e) {
            self.move(e)
        })
    }
    $.prototype.Dad_SideBar = function (opts) {
        var me, defaults, options;
        me = this;
        defaults = {
            target: '>div',
            draggable: false,
            placeholder: '',
            callback: false,
            containerClass: 'dad-container',
            childrenClass: 'dads-children',
            cloneClass: 'dads-children-clone-bar',
            active: true
        };
        options = $.extend({}, defaults, opts);
        $(this).each(function () {
            var mouse, target, dragClass, active, callback, placeholder, daddy, childrenClass, jQclass, cloneClass;
            mouse = new O_dad();
            active = options.active;
            daddy = $(this);
            if (!daddy.hasClass('dad-active') && active == true) daddy.addClass('dad-active');
            childrenClass = options.childrenClass;
            cloneClass = options.cloneClass;
            jQclass = '.' + childrenClass;
            daddy.addClass(options.containerClass);
            target = daddy.find(options.target);
            placeholder = options.placeholder;
            callback = options.callback;
            dragClass = 'dad-draggable-area';
            me.addDropzone = function (selector, func) {
                $(selector).on('mouseenter', function () {
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'none'
                        });
                        mouse.target.css({
                            display: 'none'
                        });
                        $(this).addClass('active')
                    }
                }).on('mouseup', function () {
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'block'
                        });
                        mouse.target.css({
                            display: 'block'
                        });
                        func(mouse.target);
                        dad_end()
                    }
                    $(this).removeClass('active')
                }).on('mouseleave', function () {
                    if (mouse.target != false) {
                        mouse.placeholder.css({
                            display: 'block'
                        });
                        mouse.target.css({
                            display: 'block'
                        })
                    }
                    $(this).removeClass('active')
                })
            };
            me.getPosition = function () {
                var positionArray = [];
                $(this).find(jQclass).each(function () {
                    positionArray[$(this).attr('data-dad-id')] = parseInt($(this).attr('data-dad-position'))
                });
                return positionArray
            };
            me.activate = function () {
                active = true;
                if (!daddy.hasClass('dad-active')) {
                    daddy.addClass('dad-active')
                }
                return me
            };
            me.deactivate = function () {
                active = false;
                daddy.removeClass('dad-active');
                return me
            };
            $(document).on('mouseup', function () {
                dad_end()
            });
            var order = 1;
            target.addClass(childrenClass).each(function () {
                if ($(this).data('dad-id') == undefined) {
                    $(this).attr('data-dad-id', order)
                }
                $(this).attr('data-dad-position', order);
                order++
            });

            function update_position(e) {
                var order = 1;
                e.find(jQclass).each(function () {
                    $(this).attr('data-dad-position', order);
                    order++
                })
            }

            function dad_end() {
                if (mouse.target != false && mouse.clone != false) {
                    if (callback != false) {
                        callback(mouse.target)
                    }
                    var appear = mouse.target;
                    var desapear = mouse.clone;
                    var holder = mouse.placeholder;
                    var bLeft = 0;
                    Math.floor(parseFloat(daddy.css('border-left-width')));
                    var bTop = 0;
                    Math.floor(parseFloat(daddy.css('border-top-width')));
                    if ($.contains(daddy[0], mouse.target[0])) {
                        mouse.clone.animate({
                            top: mouse.target.offset().top+36 - daddy.offset().top - bTop,
                            left: mouse.target.offset().left - daddy.offset().left - bLeft
                        }, 300, function () {
                            appear.css({
                                visibility: 'visible'
                            }).removeClass('active');
                            desapear.remove()
                        })
                    } else {
                        mouse.clone.fadeOut(300, function () {
                            desapear.remove()
                        })
                    }
                    holder.remove();
                    mouse.clone = false;
                    mouse.placeholder = false;
                    mouse.target = false;
                    update_position(daddy)
                }
                $("html,body").removeClass('dad-noSelect')
            }

            function dad_update(obj) {
                if (mouse.target != false && mouse.clone != false) {
                    var newplace, origin;
                    origin = $('<span style="display:none"></span>');
                    newplace = $('<span style="display:none"></span>');
                    if (obj.prevAll().hasClass('active')) {
                        obj.after(newplace)
                    } else {
                        obj.before(newplace)
                    }
                    mouse.target.before(origin);
                    newplace.before(mouse.target);
                    mouse.placeholder.css({
                        top: mouse.target.offset().top - daddy.offset().top,
                        left: mouse.target.offset().left - daddy.offset().left,
                        width: mouse.target.outerWidth() - 10,
                        height: mouse.target.outerHeight() - 10
                    });
                    origin.remove();
                    newplace.remove()
                }
            }
            var jq = (options.draggable != false) ? options.draggable : jQclass;
            daddy.find(jq).addClass(dragClass);
            daddy.find(jq).on('mousedown touchstart', function (e) {
                if (mouse.target == false && e.which == 1 && active == true) {
                    if (options.draggable != false) {
                        mouse.target = daddy.find(jQclass).has(this)
                    } else {
                        mouse.target = $(this)
                    }
                    mouse.clone = mouse.target.clone();
                    mouse.clone.css({
                        background:'#676767',   
                        borderBottom:'1px solid #fff',                     
                        borderTop:'1px solid #fff',                     
                    })
                    mouse.target.css({
                        visibility: 'hidden',
                    }).addClass('active');
                    mouse.clone.addClass(cloneClass);
                    daddy.append(mouse.clone);
                    mouse.placeholder = $('<div></div>');
                    mouse.placeholder.addClass('dads-children-placeholder-bar');
                    mouse.placeholder.css({
                        top: mouse.target.offset().top - daddy.offset().top,
                        left: mouse.target.offset().left - daddy.offset().left,
                        width: mouse.target.outerWidth() - 10,
                        height: mouse.target.outerHeight() - 10,
                        lineHeight: mouse.target.height() - 18 + 'px',
                        textAlign: 'center'
                        
                    }).text(placeholder);
                    daddy.append(mouse.placeholder);
                    var difx, dify;
                    var bLeft = Math.floor(parseFloat(daddy.css('border-left-width')));
                    var bTop = Math.floor(parseFloat(daddy.css('border-top-width')));
                    difx = mouse.x - mouse.target.offset().left + daddy.offset().left + bLeft;
                    dify = mouse.y - mouse.target.offset().top + daddy.offset().top + bTop;
                    mouse.cloneoffset.x = difx;
                    mouse.cloneoffset.y = dify;
                    mouse.clone.removeClass(childrenClass).css({
                        position: 'absolute',
                        top: mouse.y - mouse.cloneoffset.y+36,
                        left: mouse.x - mouse.cloneoffset.x
                    });
                    $("html,body").addClass('dad-noSelect')
                }
            });
            $(jQclass).on('mouseenter', function () {
                dad_update($(this))
            })
        });
        return this
    }
}(jQuery));


//console.log($('.Grip').eq(3).parent().siblings('.Left').height())

//side
var flag = true;
$('.Siderbar_button_item').each(function (i) {
    var _this = $('.Siderbar_button_item').eq(i);

    _this.click(function () {
        $('.WorkListItems').eq(i).show().siblings('.WorkListItems').hide();
        //var _thisCount = _this.children(".Badge").eq(0).text();
        if (i == 1) {
            debugger;
            $('.HeaderBadge').hide();
            $('.WorkListLinkContainer').hide()
            $(".WorkListTaskLinkContainer").show();
            LoadWorkListTask();
            var _thisCount = $("#TaskWorkListItems").children(".WorkListItem").length; 
            $(".HeaderText").eq(0).text("任务列表" + "(" + _thisCount + ")");

        } else {
            $('.HeaderBadge').show();
            $('.WorkListLinkContainer').show()
            $(".WorkListTaskLinkContainer").hide();
            LoadWorkListTicket(); 
            var _thisCount = $("#TicketWorkListItems").children(".WorkListItem").length; 
            $(".HeaderText").eq(0).text("工单列表" + "(" + _thisCount + ")");
        }
        if (flag == false) {
            if (_this.hasClass('Selected')) {
                $('.Siderbar_button_item').eq(0).children('.Icon').css('background-position', '0 -16px');
                $('.Siderbar_button_item').eq(1).children('.Icon').css('background-position', '-16px -16px');
                $('.SlideOut').animate({ right: -230 }, 300)
                    $(".cont").eq(0).animate({ right: 30 }, 300)
                    $("#yibiaopan").animate({ right: 30 }, 300)
                $('.Siderbar_button').animate({ right: 0 }, 300);
                _this.removeClass('Selected').siblings().removeClass('Selected');
                flag = true;
            } else {
                _this.addClass('Selected').siblings().removeClass('Selected');
                $('.Selected').children('.Icon').css('background-position', '-32px 0px');
                if (i == 0) {
                    $('.Selected').siblings().children('.Icon').css('background-position', '-16px -16px');
                } else {
                    $('.Selected').siblings().children('.Icon').css('background-position', '0px -16px');
                }
            }

        } else {
            flag = false;
            _this.addClass('Selected').siblings().removeClass('Selected');
            $('.Selected').children('.Icon').css('background-position', '-32px 0px');
            $('.SlideOut').animate({ right: 0 }, 300)
                $(".cont").eq(0).animate({ right: 260 }, 300)
                $("#yibiaopan").animate({ right: 260 }, 300)
            $('.Siderbar_button').animate({ right: 230 }, 300)
        }
    })
})



function Timer(dom) {
    this.mm = 0;
    this.lock = null;
    this.dom = dom;
    this.Timeflag = true;
    this.init();
}
Timer.prototype.init = function () {
    var _this = this;
    this.dom.click(function () {
        if (_this.Timeflag) {
            _this.dom.css('background-position', '-23px 0')
            _this.Timeflag = false;
            _this.lock = setInterval(function () {
                var Tnumber = _this.mm++;
                var h = parseInt(Tnumber / 3600);
                var m = parseInt((Tnumber % 3600) / 60);
                var s = parseInt(Tnumber % 60);
                _this.dom.siblings('.StopwatchTime').html(_this.toDub(h) + ':' + _this.toDub(m) + ':' + _this.toDub(s))
            }, 1000)
        } else {
            window.clearInterval(_this.lock)
            _this.dom.css('background-position', '0 0')
            _this.Timeflag = true;
        }
    })
    this.dom.siblings('.Stop').click(function () {
        _this.dom.css('background-position', '0 0')
        _this.dom.siblings('.StopwatchTime ').html('00:00:00')
        window.clearInterval(_this.lock)
        _this.Timeflag = true;
        _this.mm = 0;
    })
}
Timer.prototype.toDub = function (n) {
    return n < 10 ? "0" + n : "" + n;
}

$.each($('.Play'), function (i) {
    if (!$('.Play').eq(i).hasClass('DisabledState')) {
        new Timer($('.Play').eq(i))
    }
})
// 移除工作列表
function RemoveWorkListTicket(taskId,isTicket) {
    if (taskId != "") {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=DeleteSingWorkTicketByTaskId&taskId=" + taskId,
            dataType: "json",
            success: function (data) {
                if (data) {
                    
                    if (isTicket == "1") {
                        LoadWorkListTicket();
                      
                    }
                    else if (isTicket == "") {
                        LoadWorkListTask();
                       
                    }
                }
                else {
                    LayerMsg("删除失败！请刷新页面后重试！");
                }
            },
        });
    }
}
// 移除全部工单
function DeleteAllWorkTicket() {
    LayerConfirm("是否移除全部工单？", "是", "否", function () {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=DeleteWorkTicket&isTicket=1",
            dataType: "json",
            success: function (data) {
                LoadWorkListTicket();
                //setTimeout(function () { history.go(0); }, 800)
            },
        });
    }, function () { });
}
// 移除全部任务
function DeleteAllWorkTask() {
    LayerConfirm("是否移除全部任务？", "是", "否", function () {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=DeleteWorkTicket",
            dataType: "json",
            success: function (data) {
                LoadWorkListTask();
                //setTimeout(function () { history.go(0); }, 800)
            },
        });
    }, function () { });
}
// 加载工单信息
function LoadWorkListTicket() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/IndexAjax.ashx?act=LoadMyTicketWorkList",
        //dataType: "json",
        success: function (data) {
            //setTimeout(function () { history.go(0); }, 800)
            $("#TicketWorkListItems").html(data);
        },
    });
    $.each($('.Play'), function (i) {
        if (!$('.Play').eq(i).hasClass('DisabledState')) {
            new Timer($('.Play').eq(i))
        }
    })
    var _thisCount = $("#TicketWorkListItems").children(".WorkListItem").length;
    $(".HeaderText").eq(0).text("工单列表" + "(" + _thisCount + ")");
    $('.Siderbar_button_item').eq(0).children(".Badge").eq(0).text(_thisCount);
    $('.Grip').each(function (i) {
        $('.Grip').eq(i).css({
            'height': $('.Grip').eq(i).parent().siblings('.Left').height() - 30,
        })
        //console.log($('.Grip').eq(i).parent().siblings('.Left').height())
    })
    $('.WorkListItems').eq(0).Dad_SideBar({
        draggable: '.Grip'
    })
   
}
// 加载任务信息
function LoadWorkListTask() {
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/IndexAjax.ashx?act=LoadMyTaskWorkList",
        //dataType: "json",
        success: function (data) {
            //setTimeout(function () { history.go(0); }, 800)
            $("#TaskWorkListItems").html(data);
        },
    });
    var _thisCount = $("#TaskWorkListItems").children(".WorkListItem").length;
    $(".HeaderText").eq(0).text("任务列表" + "(" + _thisCount + ")");
    $('.Siderbar_button_item').eq(1).children(".Badge").eq(0).text(_thisCount);
    $('.Grip').each(function (i) {
        $('.Grip').eq(i).css({
            'height': $('.Grip').eq(i).parent().siblings('.Left').height() - 30,
        })
        //console.log($('.Grip').eq(i).parent().siblings('.Left').height())
    })
    $('.WorkListItems').eq(1).Dad_SideBar({
        draggable: '.Grip'
    })

}
// 新窗口打开工单
function NewOpenTicket(ticketId) {
    if (ticketId != "") {
        window.open("../ServiceDesk/TicketView?id=" + ticketId, windowType.blank, 'left=200,top=200,width=1280,height=800', false);
    }
}
// 新窗口打开任务
function NewOpenTask(taskId) {
    if (taskId != "") {
        window.open("../Project/TaskView.aspx?id=" + taskId, '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
}
// 重置所有秒表
function ResetAllWatch() {
    $(".StopwatchTime").each(function () {
        var _this = $(this);
        if (!_this.hasClass("DisabledState")) {
            _this.siblings(".Stop").eq(0).trigger("click");
        }
    })
}
// 显示工单的设置
function ShowTicketWorkListSetting() {
    window.open('../Common/ColumnSelector.aspx?type=250&group=264', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);
}
// 显示任务的设置
function ShowTaskWorkListSetting() {
    window.open('../Common/ColumnSelector.aspx?type=251&group=265', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);
}

function DragWorkTask(firstTaskId, lastTaskId) {
    if (firstTaskId == "" || lastTaskId == "" || firstTaskId == lastTaskId) {
        return;
    }
    $.ajax({
        type: "GET",
        async: false,
        url: "../Tools/IndexAjax.ashx?act=ChangeWorkTaskSort&firstTaskId=" + firstTaskId + "&lastTaskId=" + lastTaskId,
        dataType: "json",
        success: function (data) {
            
        },
    });
}