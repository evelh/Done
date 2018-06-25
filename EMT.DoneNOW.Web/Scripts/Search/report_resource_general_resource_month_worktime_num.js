$(function () {
    
    $("#ExportLi").after("<li style='background: white;border: 0px;'><span style='margin- left:10px;'>报表类型</span><span><select id='ReportType'><option value='1'>工时</option><option value='2'>金额</option></select></span></li>");
    $("#ReportType").change(function () {
        var type = $(this).val();
        if (type == "2") {
            parent.location.href = "../Common/SearchFrameSet.aspx?cat=1770";
        }
        else {
            parent.location.href = "../Common/SearchFrameSet.aspx?cat=1769";
        }
    })
})

