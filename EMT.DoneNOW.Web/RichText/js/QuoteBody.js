var colors = ["#efefef","white"];
var index1 = 0;
var index2 = 0;
var index3 = 0;
var index4 = 0;
$("#a1").on("click",function(){
    $(this).find(".Vertical").toggle();
    $("#c1").toggle();
    $("#d1").toggle();
    var color = colors[index1++];
    $("#b1").css("background",color);
    if(index1==colors.length){
        index1 = 0;
    }
})
$("#a2").on("click",function(){
    $(this).find(".Vertical").toggle();
    $("#d2").toggle();
    var color = colors[index2++];
    $("#b2").css("background",color);
    if(index2==colors.length){
        index2 = 0;
    }
})
$("#a3").on("click",function(){
    $(this).find(".Vertical").toggle();
    $("#c3").toggle();
    $("#d3").toggle();
    var color = colors[index3++];
    $("#b3").css("background",color);
    if(index3==colors.length){
        index3 = 0;
    }
})
$("#a4").on("click",function(){
    $(this).find(".Vertical").toggle();
    $("#c4").toggle();
    $("#d4").toggle();
    var color = colors[index4++];
    $("#b4").css("background",color);
    if(index4==colors.length){
        index4 = 0;
    }
})

//加载函数
function loading(){
    var mask = $('<div id="BackgroundOverLay">'+'</div>');
    var load = $('<div id="LoadingIndicator">'+'</div>');
    $("body").prepend(load).prepend(mask);
    $("#BackgroundOverLay").show();
    $("#LoadingIndicator").show();
    setTimeout(function(){
        $("#BackgroundOverLay").hide();
        $("#LoadingIndicator").hide();
    },1000)

}


$(".next").on('click',function() {
    if($(this).parent().parent().parent().next())
        $(this).parent().parent().parent().next().after($(this).parent().parent().parent());
});
$(".prev").on('click',function() {
    if($(this).parent().parent().parent().prev())
        $(this).parent().parent().parent().prev().before($(this).parent().parent().parent());
});


//点击循环第一块
$(".E").on("click",function(){
    loading();
    $(this).parent().addClass("DisplayEditingRow").siblings().removeClass("DisplayEditingRow");
    var editor =
    $('<tr class="EditingRow">'+
        '<td class="DragAndDropEnabled EditingInteraction">'+'<div class="Text">'+$(this).parent().find('.Text').html()+'</div>'+'</td>'+
        '<td class="Text U1">'+$(this).parent().find('.U1').html()+'</td>'+
        '<td class="XL">'+
        '<div class="Normal Editor TextBox">'+
        '<div class="InputField">'+
        '<input type="text" id="" maxlength="50" value='+$(this).parent().find('.U2').html()+'>'+
        '</div>'+
        '</div>'+
        '</td>'+
        '<td class="BooleanEditing Medium">'+
        '<div class="Normal Editor CheckBox">'+
        '<div class="InputField">'+
        '<input type="checkbox" checked="checked" id="check" >'+
        '</div>'+
        '</div>'+
        '</td>'+
        '</tr>'+
        '<tr class="EditingButtonRow">'+
        '<td>'+'</td>'+
        '<td colspan="3">'+
        '<ul>'+
        '<li class="Button ButtonIcon Save SelectedState">'+
        '<span class="Icon save">'+'</span>'+
        '<span class="Text">'+'Save'+'</span>'+
        '</li>'+
        '<li class="Button ButtonIcon Cancel NormalState">'+
        '<span class="Icon cancel">'+'</span>'+
        '<span class="Text">'+'Cancel'+'</span>'+
        '</li>'+
        '</ul>'+
        '</td>'+
        '</tr>');
    $(this).parent().siblings("tr").remove(".EditingRow").remove(".EditingButtonRow")
  	$(this).parent().after(editor);

    $(".Save").on("click",function(){
        var content = $(this).parent().parent().parent().prev().find("input[type='text']").val();
        $(this).parent().parent().parent().prev().prev().find('.XL').html(content);
        $(this).parent().parent().parent().siblings().removeClass("DisplayEditingRow");
        if($(this).parent().parent().parent().prev().find("input[type='checkbox']").is(':checked')){
            $(this).parent().parent().parent().prev().prev().find('.CheckMark').addClass('CM');
        }else{
            $(this).parent().parent().parent().prev().prev().find('.CheckMark').removeClass('CM');
        }
        editor.remove();
    })
    $(".Cancel").on("click",function(){
        $(this).parent().parent().parent().siblings().removeClass("DisplayEditingRow");
        editor.remove();
    })
})

//点击第三块
$(".Edit").on("click",function(){
    var $_this=$(this);
    loading();
    var innerContent = $(this).parent().next().next().html();
    var mask = $('<div id="BackgroundOverLay">'+'</div>');
    var AddText = $('<div class="addText">'+
                        '<div>'+
                            '<div class="CancelDialogButton"></div>'+
                            '<div class="TitleBar">'+
                                '<div class="Title">'+
                                '<span class="text1">编辑项目列：服务或捆绑</span>'+
                                '<span class="text2"></span>'+
                                '</div>'+
                            '</div>'+
                            '<form action="" method="post" >'+
                                '<div class="ButtonContainer">'+
                                    '<ul>'+
                                        '<li class="Button addButtonIcon Okey NormalState" id="addOkButton" tabindex="0">'+
                                            '<span class="Icon Ok"></span>'+
                                            '<span class="Text">确认</span>'+
                                        '</li>'+
                                        '<li class="Button addButtonIcon Cancel NormalState" id="ResetButton" tabindex="0">'+
                                            '<span class="Icon Reset"></span>'+
                                            '<span class="Text">恢复默认</span>'+
                                        '</li>'+
                                    '</ul>'+
                                '</div>'+
                            '</form>'+
                            '<div class="ScrollingContainer">'+
                                '<div class="Heading">头部</div>'+
                                '<div class="addDescriptionText">这是头部</div>'+
                                '<div class="addContent">'+
                                    '<script id="containerHead" name="content" type="text/plain"></script>'+
                                    '<div class="Dialog">'+
                                         '<img src="img/Dialog.png">'+
                                    '</div>'+
                                '</div>'+
                            '</div>'+
                            '<div class="AlertBox">'+
                            '<div>'+
                            '<div class="CancelDialogButton1"></div>'+
                            '<div class="AlertTitleBar">'+
                            '<div class="AlertTitle">'+
                            '<span>变量</span>'+
                            '</div>'+
                            '</div>'+
                            '<div class="VariableInsertion">'+
                            '<div class="AlertContent">'+
                            '<div class="AlertContentTitle">这是弹出的变量内容，可双击选择</div>'+
                        '<select name="" id="AlertVariableFilter">'+
                            '<option value="1">Show All Variables</option>'+
                        '<option value="2">Show Account Variables</option>'+
                        '<option value="3">Show Contact Variables</option>'+
                        '<option value="4">Show Opportunity Variables</option>'+
                        '<option value="5">Show Quote Variables</option>'+
                        '<option value="6">Show Miscellaneous Variables</option>'+
                        '<option value="7">Show Your Company Variables</option>'+
                        '<option value="8">Show Your Location Variables</option>'+
                        '</select>'+
                        '<select name="" multiple="multiple" id="AlertVariableList">'+
                            '<option value="" class="val">1</option>'+
                            '<option value="" class="val">2</option>'+
                            '<option value="" class="val">3</option>'+
                            '<option value="" class="val">4</option>'+
                            '<option value="" class="val">5</option>'+
                            '<option value="" class="val">6</option>'+
                            '<option value="" class="val">7</option>'+
                            '<option value="" class="val">8</option>'+
                            '<option value="" class="val">9</option>'+
                            '<option value="" class="val">10</option>'+
                            '<option value="" class="val">1</option>'+
                            '<option value="" class="val">2</option>'+
                            '<option value="" class="val">3</option>'+
                            '<option value="" class="val">4</option>'+
                            '<option value="" class="val">5</option>'+
                            '<option value="" class="val">6</option>'+
                            '<option value="" class="val">7</option>'+
                            '<option value="" class="val">8</option>'+
                            '<option value="" class="val">9</option>'+
                            '<option value="" class="val">10</option>'+
                            '</select>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '</div>'+
                            '<div id="BackgroundOverLay1"></div>'+
                        '</div>'+
                    '</div>');
    $('body').prepend(AddText).prepend(mask);
    //富文本编辑器
    UE.delEditor('containerHead');
    var ue = UE.getEditor('containerHead',{
        toolbars: [
            ['source','fontfamily', 'fontsize', 'bold', 'italic', 'underline','fontcolor','backcolor','justifyleft','justifycenter','justifyright','insertorderedlist','insertunorderedlist','undo','redo']
        ],
        initialFrameHeight:300,//设置编辑器高度
        initialFrameWidth:780, //设置编辑器宽度
        wordCount:false,
        elementPathEnabled : false,
        autoHeightEnabled:false  //设置滚动条
    });

    ue.ready(function(){
        //获取html内容  返回：<p>内容</p>
        var html = ue.getContent();
        //获取纯文本内容  返回：内容
        var txt = ue.getContentTxt();
        ue.setContent(innerContent);
        $(".Dialog").on("click",function(){
            $("#BackgroundOverLay1").show();
            $(".AlertBox").show();
        });
        $(".CancelDialogButton1").on("click",function(){
            $("#BackgroundOverLay1").hide();
            $(".AlertBox").hide();
        });
        $(".val").on("dblclick",function(){
            UE.getEditor('containerHead').focus();
            UE.getEditor('containerHead').execCommand('inserthtml',$(this).html());
            $("#BackgroundOverLay1").hide();
            $(".AlertBox").hide();
        })
    });
    //        点击确定数据保存至后台  在展示页展示
    $("#addOkButton").on("click",function(){
        var html = ue.getContent();
        var txt = ue.getContentTxt();
        $_this.parent().next().next().html(html);
        mask.remove();
        $(".addText").hide();
        $("#BackgroundOverLay").hide();
    });
    //点击关闭
    $(".CancelDialogButton").on("click",function(){
        mask.remove();
        AddText.remove();
        $(".addText").hide();
        $("#BackgroundOverLay").hide();
    })
    $("#addOkButton").on("mouseover",function(){
        $("#addOkButton").css("background","#fff");
    });
    $("#addOkButton").on("mouseout",function(){
        $("#addOkButton").css("background","#f0f0f0");
    });
    $("#ResetButton").on("mouseover",function(){
        $("#ResetButton").css("background","#fff");
    });
    $("#ResetButton").on("mouseout",function(){
        $("#ResetButton").css("background","#f0f0f0");
    });
});



