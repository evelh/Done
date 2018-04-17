$("#noData").hide(); $("#SelectLi").hide();
$("#SearchTable").append("<tr id='addData'><td><select id='selCate'></select></td><td></td><td><input id='desc' type='text'/></td><td><input id='complete' type='checkbox'</td><td><input type='button' value='保存' onclick='SaveNew()' /></td></tr>");
$("#addData").hide();
requestData("/Tools/SysSettingAjax.ashx?act=GetSkillCates&type=2", null, function (data) {
    if (data != null) {
        var opt = "";
        for (var i = 0; i < data.length; i++) {
            opt += "<option value='" + data[i].val + "'>" + data[i].show + "</option>";
        }
        $("#selCate").html(opt);
    }
})
function Add() {
    $("#addData").show();
}
function Delete(id) {
    requestData("/Tools/ResourceAjax.ashx?act=DeleteSkill&id=" + id, null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}
function SaveNew() {
    var cplt = 0;
    if ($("#complete").is(':checked')) { cplt = 1; }
    requestData("/Tools/ResourceAjax.ashx?act=AddCert&resId=" + $("input[name='con2678']").val() + "&cate=" + $("#selCate").val() + "&complete=" + cplt + "&desc=" + $("#desc").val(), null, function (data) {
        if (data == true) {
            window.location.reload();
        }
    })
}