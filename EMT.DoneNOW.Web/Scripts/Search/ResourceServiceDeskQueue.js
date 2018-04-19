$("#noData").hide(); $("#SelectLi").hide();
$("#SearchTable").append("<tr id='addData'><td><select id='selQue'></select></td><td><select id='selRole'></select></td><td><input id='default' type='checkbox'/></td><td><input id='active' checked='checked' type='checkbox'/></td><td><input type='button' value='保存' onclick='SaveNew()' /></td></tr>");
$("#addData").hide();
requestData("/Tools/ResourceAjax.ashx?act=GetDepartmentList&dptType=1", null, function (data) {
    var opt = "";
    for (var i = 0; i < data.length; i++) {
        opt += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
    }
    $("#selQue").html(opt);
})
requestData("/Tools/ResourceAjax.ashx?act=GetRoleList", null, function (data) {
    var opt = "";
    for (var i = 0; i < data.length; i++) {
        opt += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
    }
    $("#selRole").html(opt);
})
function Add() {
    $("#addData").show();
}
function Delete(id) {
    requestData("/Tools/ResourceAjax.ashx?act=DeleteDepartment&id=" + id, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function SaveNew() {
    var dft = 0;
    var act = 0;
    if ($("#default").is(':checked')) { dft = 1; }
    if ($("#active").is(':checked')) { act = 1; }
    requestData("/Tools/ResourceAjax.ashx?act=AddQueue&resId=" + $("input[name='con2676']").val() + "&queId=" + $("#selQue").val() + "&role=" + $("#selRole").val() + "&dft=" + dft + "&isact=" + act, null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("添加失败");
        }
    })
}