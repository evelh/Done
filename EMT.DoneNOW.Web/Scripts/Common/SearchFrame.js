$("#SearchBtn").click(function () {
    var vals = $(".sl_cdt");

    var formbody = window.parent.frames["SearchBody"].contentWindow;
    if (formbody == undefined)
        formbody = window.parent.frames["SearchBody"].document;
    else
        formbody = formbody.document;
    var inner = "";
    for (var i = 0; i < vals.length; ++i) {
        if (vals[i].value == "")
            continue;
        inner += '<input type="hidden" name="' + vals[i].name + '" value="' + vals[i].value + '" />';
    }
    formbody.getElementById("conditions").innerHTML = inner;
    formbody.getElementById("search_id").value = "";
    formbody.getElementById("form1").submit();
});

function OpenQuery(catId, typeId, groupId) {

}

$(".form_datetime").datetimepicker({
    language: 'zh-CN',//显示中文
    format: 'yyyy-mm-dd',//显示格式
    minView: "month",//设置只显示到月份
    initialDate: new Date(),//初始化当前日期
    autoclose: true,//选中自动关闭
    todayBtn: true//显示今日按钮
});