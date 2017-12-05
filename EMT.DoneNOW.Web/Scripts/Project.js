$("#DownButton").on("mousemove",function(){
    $("#Down1").show();
$(this).css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $("#Down1").hide();
    $(this).css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down1").on("mousemove",function(){
    $(this).show();
    $("#DownButton").css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $(this).hide();
    $("#DownButton").css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#ViewButton").on("mousemove",function(){
    $("#Down2").show();
    $(this).css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $("#Down2").hide();
    $(this).css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down2").on("mousemove",function(){
    $(this).show();
    $("#ViewButton").css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $(this).hide();
    $("#ViewButton").css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#ToolsButton").on("mousemove",function(){
    $("#Down3").show();
    $(this).css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $("#Down3").hide();
    $(this).css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down3").on("mousemove",function(){
    $(this).show();
    $("#ToolsButton").css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $(this).hide();
    $("#ToolsButton").css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#LinksButton").on("mousemove",function(){
    $("#Down4").show();
    $(this).css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $("#Down4").hide();
    $(this).css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#Down4").on("mousemove",function(){
    $(this).show();
    $("#LinksButton").css("border-bottom","1px solid white").css("background","white");
}).on("mouseout",function(){
    $(this).hide();
    $("#LinksButton").css("border-bottom","1px solid #d7d7d7").css("background","linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
});
$("#TableDropButton").on("mousemove",function(){
    $("#Down5").show().css("border-top","1px solid white");
    $(this).addClass('DropDownButtonCss');
}).on("mouseout",function(){
    $("#Down5").hide();
    $(this).removeClass('DropDownButtonCss');
});
$("#Down5").on("mousemove",function(){
    $(this).show().css("border-top","1px solid white");
    $("#TableDropButton").addClass('DropDownButtonCss');
}).on("mouseout",function(){
    $(this).hide();
    $("#TableDropButton").removeClass('DropDownButtonCss');
});

//日历的弹框
$(".calendar").on("click",function(){
    $(".AlertMessage").show();
    $("#BackgroundOverLay").show();
    $("#yes").on("click",function(){
        $(".AlertMessage").hide();
        $("#BackgroundOverLay").hide();


    });
    $("#no").on("click",function(){
        $(".AlertMessage").hide();
        $("#BackgroundOverLay").hide();
    });
    $(".CancelDialogButton").on("click",function(){
        $(".AlertMessage").hide();
        $("#BackgroundOverLay").hide();
    });
});
//第一级拖拽
// function changeNum(){
//     $(".D").each(function(){
//         var indexNum=$(".D").index(this);
//         var a=indexNum+1;
//         $(this).find(".Num").text(a);
//     });
// }
// $(function(){
//     $('#Drap').sortable().bind('sortupdate',function() {
//         //changeNum();
//     });
// });


var toId = "";
var type = "in";

function drag() {
    
    var obj = $('#Drap .HighImportance');
    obj.bind('mousedown', start);
    function start(e) {
        var ol = obj.offset().left;
        var ot = obj.offset().top;
        deltaX = e.pageX - ol;
        deltaY = e.pageY - ot;
        $(this).children('.Interaction').first().trigger("click");
        $(document).bind({
            'mousemove': move,
            'mouseup': stop
        });
        return false;
    }
    function move(e) {
        debugger;

        $.each(obj.siblings(), function (i) {
            var mX = obj.siblings().eq(i).offset().left;
            var mY = obj.siblings().eq(i).offset().top;
            if (e.pageX > mX && e.pageX < mX + obj.siblings().eq(i).width() && e.pageY > mY && e.pageY < mY + obj.siblings().eq(i).height()) {
                obj.css('cursor', 'move')
                obj.find('.Interaction').css('cursor', 'move')
                $('.border_left').show()
                $('.border_right').show()
                type = "in";
                $('.border-line').hide()
                $('.border_left').css({
                    "left": 0,
                    "top": obj.siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.siblings().eq(i).height() / 2 - 8,
                })
                $('.border_right').css({
                    "right": 0,
                    "top": obj.siblings().eq(i).children('.Interaction').offset().top - $('.RowContainer').offset().top + obj.siblings().eq(i).height() / 2 - 8,
                })
                $('.cover').show()
                $('.cover').css({
                    "left": (e.pageX + $('.cover').width() + 10) - $('.RowContainer').offset().left,
                    "top": (e.pageY - $('.RowContainer').offset().top),
                    "display": 'block'
                })
                $('.cover').html(obj.siblings().eq(i).find('.Num').html());
                toId = $(this).data("val");  // 代表将要放的位置的id

            } else {
                obj.css('cursor', 'none')
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
                    $('.cover').html(obj.siblings().eq(i).find('.Num').html());
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
    function stop() {
   
        $('.cover').hide()
        $('.border_right').hide()
        $('.border_left').hide()
        $('.border-line').hide()
        obj.css('cursor', '')
        obj.find('.Interaction').css('cursor', '')
        $(document).unbind({
            'mousemove': move,
            'mouseup': stop,
            "cursor": 'pointer'
        });
        DragTask();
    }
}
drag();




//选中及其子集
$("#Drap tr>.Interaction").on("click",function(){
    var _this = $(this).parent();
    _this.siblings().removeClass('Selected');
    _this.addClass('Selected');
    var _thisDataDepth=_this.find('.DataDepth').attr('data-depth');
    $("#OutdentButton").on("click",function(){
        if(_thisDataDepth>1){
            var _thisDataDepthDec=_this.find('.DataDepth').attr('data-depth')-1;
            _this.find('.DataDepth').attr('data-depth',_thisDataDepthDec);
            Style();
        }
    });
    var str = _this.find('.DataDepth').attr('data-depth');
    for(i in _this.nextAll()){
        if(str<_this.nextAll().eq(i).find('.DataDepth').attr('data-depth')){
            _this.addClass('Selected');
            _this.nextAll().eq(i).addClass('Selected');

            $("#OutdentButton").on("click",function(){
                for(j in _this.nextAll()){
                    var DataDepth=_this.nextAll().eq(j).find('.DataDepth').attr('data-depth');
                    var DataDepthDec = DataDepth-1;
                    _this.nextAll().eq(j).find('.DataDepth').attr('data-depth',DataDepthDec);
                    Style();
                }
            });
        }else{
            return false;
        }
    }
    Style();
});
//缩进
function Style(){
    for(i in $(".Spacer")){
        var Width = $(".Spacer").eq(i).parent().attr('data-depth')*22+'px';
        $(".Spacer").eq(i).width(Width).css('min-width',Width);
    }
}
Style();
//缩小展开
$(".IconContainer").on('click',function(){
    $(this).find('.Vertical').toggle();
    var _this = $(this).parent().parent().parent();
    var str = _this.find('.DataDepth').attr('data-depth');
    for(i in _this.nextAll()){
        if(str<_this.nextAll().eq(i).find('.DataDepth').attr('data-depth')&&$(this).find('.Vertical').css('display')=='block'){
            _this.nextAll().eq(i).hide();
            _this.nextAll().eq(i).find('.Vertical').show();
        }else if(str<_this.nextAll().eq(i).find('.DataDepth').attr('data-depth')&&$(this).find('.Vertical').css('display')=='none'){
            _this.nextAll().eq(i).show();
            _this.nextAll().eq(i).find('.Vertical').hide();
        }else if(str>=_this.nextAll().eq(i).find('.DataDepth').attr('data-depth')){
            return false;
        }
    }
});

//点击全选全部选
$("#LeftSelectButton").on("click",function(){
    var _this = $(this);
    if(_this.is(':checked')){
        $(".D").addClass('Selected');
    }else{
        $(".D").removeClass('Selected');
    }
});


