$(function () {
    var appHtml = "<li class='right' style='float: right;line-height:28px; border:0px solid #bcbcbc; margin-right: 25px;'><select id='GroupType'  style='width:100px;height: 24px;'><option value='contract'>合同</option><option value='project'>项目</option><option value='resource'>员工</option></select></li>";
    $("#RefreshLi").after(appHtml);
    $("#GroupType").val("resource");
    $("#GroupType").change(function () {
        var thisValue = $(this).val();
        if (thisValue == "contract") {
            parent.location.href = "../Common/SearchFrameSet?cat=1673&type=283";
        }
        else if (thisValue == "resource") {
            parent.location.href = "../Common/SearchFrameSet?cat=1674&type=284";
        }
        else if (thisValue == "project") {
            parent.location.href = "../Common/SearchFrameSet?cat=1675&type=285";
        }

    })
})

