$("#noData").hide(); $("#SelectLi").hide();
$("#SearchTable").append("<tr id='addData'><td><select id='selDpt'></select></td><td><select id='selRole'></select></td><td><input id='default' type='checkbox'/></td><td><input id='depart' type='checkbox'/></td><td><input id='active' checked='checked' type='checkbox'/></td><td><input type='button' value='保存' onclick='SaveNew()' /></td></tr>");
$("#addData").hide();
requestData("/Tools/ResourceAjax.ashx?act=GetDepartmentList", null, function (data) {
    var opt = "";
    for (var i = 0; i < data.length; i++) {
        opt += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
    }
    $("#selDpt").html(opt);
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
    var dpt = 0;
    var act = 0;
    if ($("#default").is(':checked')) { dft = 1; }
    if ($("#depart").is(':checked')) { dpt = 1; }
    if ($("#active").is(':checked')) { act = 1; }
    requestData("/Tools/ResourceAjax.ashx?act=AddDepartment&resId=" + $("input[name='con2675']").val() + "&dptId=" + $("#selDpt").val() + "&role=" + $("#selRole").val() + "&dft=" + dft + "&dpt=" + dpt + "&act=" + act, null, function (data) {
        if (data == true) {
            window.location.reload();
        } else {
            LayerMsg("添加失败");
        }
    })
}