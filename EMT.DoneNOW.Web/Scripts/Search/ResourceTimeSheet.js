$("#noData").hide(); $("#SelectLi").hide();
$("#SearchTable").append("<tr id='addData'><td><select id='selRes'></select></td><td><select id='selTier'><option value='1'>第一级</option><option value='2'>第二级</option><option value='3'>第三级</option></select></td><td><input type='button' value='保存' onclick='SaveNew()' /></td></tr>");
$("#addData").hide();
requestData("/Tools/ResourceAjax.ashx?act=GetActiveRes", null, function (data) {
    var opt = "";
    for (var i = 0; i < data.length; i++) {
        opt += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
    }
    $("#selRes").html(opt);
})
function Add() {
    $("#addData").show();
}
function Delete(id) {
    requestData("/Tools/ResourceAjax.ashx?act=DeleteApprover&id=" + id, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function SaveNew() {
    requestData("/Tools/ResourceAjax.ashx?act=AddTimesheetApporver&resId=" + $("input[name='con2673']").val() + "&approver=" + $("#selRes").val() + "&tier=" + $("#selTier").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("添加失败，审批人重复");
        }
    })
}